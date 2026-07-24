from uuid import UUID

from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import get_current_user
from app.db.session import get_db
from app.models.user import User
from app.repositories.group_repository import GroupRepository
from app.repositories.settlement_repository import SettlementRepository
from app.schemas.settlement import (
    SettlementCreate,
    SettlementResponse,
)
from app.services.settlement_service import SettlementService

router = APIRouter(
    prefix="/settlements",
    tags=["Settlements"],
)


@router.post(
    "",
    response_model=SettlementResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_settlement(
    settlement: SettlementCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):

    service = SettlementService(
        SettlementRepository(db),
        GroupRepository(db),
    )

    return await service.create(
        current_user_id=current_user.id,
        group_id=settlement.group_id,
        payer_id=settlement.payer_id,
        receiver_id=settlement.receiver_id,
        amount=settlement.amount,
        note=settlement.note,
    )


@router.get(
    "/group/{group_id}",
    response_model=list[SettlementResponse],
)
async def get_group_settlements(
    group_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):

    service = SettlementService(
        SettlementRepository(db),
        GroupRepository(db),
    )

    return await service.get_group_settlements(
        group_id,
        current_user.id,
    )