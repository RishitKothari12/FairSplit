from uuid import UUID

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import get_current_user
from app.db.session import get_db
from app.models.user import User
from app.repositories.expense_repository import ExpenseRepository
from app.schemas.balance import UserBalance
from app.services.balance_service import BalanceService

router = APIRouter(
    prefix="/balances",
    tags=["Balances"],
)


@router.get(
    "/group/{group_id}",
    response_model=list[UserBalance],
)
async def get_group_balances(
    group_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):

    service = BalanceService(
        ExpenseRepository(db),
    )

    balances = await service.calculate_group_balances(
        group_id,
    )

    return [
        UserBalance(
            user_id=user_id,
            balance=balance,
        )
        for user_id, balance in balances.items()
    ]