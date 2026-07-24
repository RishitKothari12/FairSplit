from uuid import UUID

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import get_current_user
from app.db.session import get_db
from app.models.user import User
from app.repositories.expense_repository import ExpenseRepository
from app.repositories.group_repository import GroupRepository
from app.repositories.settlement_repository import SettlementRepository
from app.schemas.balance import BalanceSummaryResponse
from app.services.balance_service import BalanceService

router = APIRouter(
    prefix="/balances",
    tags=["Balances"],
)


@router.get(
    "/group/{group_id}",
    response_model=BalanceSummaryResponse,
)
async def get_group_balances(
    group_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    service = BalanceService(
        ExpenseRepository(db),
        SettlementRepository(db),
        GroupRepository(db),
    )

    return await service.get_group_summary(
        group_id,
        current_user.id,
    )