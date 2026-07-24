from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload
from app.models.settlement_history import SettlementHistory



class SettlementRepository:

    def __init__(
        self,
        db: AsyncSession,
    ):
        self.db = db

    async def create(
        self,
        settlement: SettlementHistory,
    ):
        self.db.add(settlement)
        await self.db.commit()
        await self.db.refresh(settlement)
        return settlement

    async def get_group_settlements(
        self,
        group_id: UUID,
    ):
        result = await self.db.execute(
            select(SettlementHistory)
            .options(
                selectinload(SettlementHistory.payer),
                selectinload(SettlementHistory.receiver),
            )
            .where(
                SettlementHistory.group_id == group_id,
            )
            .order_by(
                SettlementHistory.settled_at.desc(),
            )
        )

        return result.scalars().all()

    async def get_by_id(
        self,
        settlement_id: UUID,
    ):
        result = await self.db.execute(
            select(SettlementHistory)
            .options(
                selectinload(SettlementHistory.payer),
                selectinload(SettlementHistory.receiver),
            )
            .where(
                SettlementHistory.id == settlement_id,
            )
        )

        return result.scalar_one()