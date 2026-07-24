from decimal import Decimal
from uuid import UUID

from fastapi import HTTPException, status

from app.models.settlement_history import SettlementHistory
from app.repositories.group_repository import GroupRepository
from app.repositories.settlement_repository import SettlementRepository
from app.services.group_guard import GroupGuard
from app.schemas.settlement import SettlementResponse


class SettlementService:

    def __init__(
        self,
        settlement_repository: SettlementRepository,
        group_repository: GroupRepository,
    ):
        self.settlement_repository = settlement_repository
        self.group_repository = group_repository
        self.guard = GroupGuard(group_repository)

    async def create(
        self,
        current_user_id: UUID,
        group_id: UUID,
        payer_id: UUID,
        receiver_id: UUID,
        amount: Decimal,
        note: str | None,
    ):

        group = await self.group_repository.get_by_id(
            group_id,
        )

        if group is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Group not found.",
            )

        # Both users must belong to the group
        # Logged-in user must belong to the group
        await self.guard.require_member(
            group_id,
            current_user_id,
        )

        # Both settlement participants must belong to the group
        await self.guard.require_member(
            group_id,
            payer_id,
        )

        await self.guard.require_member(
            group_id,
            receiver_id,
        )

        if payer_id == receiver_id:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="You cannot settle with yourself.",
            )

        settlement = SettlementHistory(
            group_id=group_id,
            payer_id=payer_id,
            receiver_id=receiver_id,
            amount=amount,
            note=note,
        )

        settlement = await self.settlement_repository.create(
            settlement,
        )

        # Load relationships so payer/receiver names are available
        settlement = await self.settlement_repository.get_by_id(
            settlement.id,
        )

        return SettlementResponse(
            id=settlement.id,
            group_id=settlement.group_id,
            payer_id=settlement.payer_id,
            payer_name=settlement.payer.full_name,
            receiver_id=settlement.receiver_id,
            receiver_name=settlement.receiver.full_name,
            amount=settlement.amount,
            note=settlement.note,
            settled_at=settlement.settled_at,
        )

    async def get_group_settlements(
        self,
        group_id: UUID,
        current_user_id: UUID,
    ):

        await self.guard.require_member(
            group_id,
            current_user_id,
        )

        settlements = await self.settlement_repository.get_group_settlements(
            group_id,
        )

        return [
            SettlementResponse(
                id=settlement.id,
                group_id=settlement.group_id,
                payer_id=settlement.payer_id,
                payer_name=settlement.payer.full_name,
                receiver_id=settlement.receiver_id,
                receiver_name=settlement.receiver.full_name,
                amount=settlement.amount,
                note=settlement.note,
                settled_at=settlement.settled_at,
            )
            for settlement in settlements
        ]