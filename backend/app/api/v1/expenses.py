from uuid import UUID

from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import get_current_user
from app.db.session import get_db
from app.models.user import User
from app.repositories.expense_repository import ExpenseRepository
from app.repositories.group_repository import GroupRepository
from app.schemas.expense import ExpenseCreate, ExpenseResponse
from app.services.expense_service import ExpenseService

router = APIRouter(
    prefix="/expenses",
    tags=["Expenses"],
)


@router.post(
    "",
    response_model=ExpenseResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_expense(
    expense: ExpenseCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    service = ExpenseService(
        ExpenseRepository(db),
        GroupRepository(db),
    )

    return await service.create(
        current_user_id=current_user.id,
        group_id=expense.group_id,
        paid_by=expense.paid_by,
        title=expense.title,
        description=expense.description,
        amount=expense.amount,
        currency=expense.currency,
        expense_date=expense.expense_date,
        split_type=expense.split_type,
        participants=expense.participants,
    )


@router.get(
    "/{expense_id}",
    response_model=ExpenseResponse,
)
async def get_expense(
    expense_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    service = ExpenseService(
        ExpenseRepository(db),
        GroupRepository(db),
    )

    return await service.get(
        expense_id,
        current_user.id,
    )


@router.get(
    "/group/{group_id}",
    response_model=list[ExpenseResponse],
)
async def get_group_expenses(
    group_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    service = ExpenseService(
        ExpenseRepository(db),
        GroupRepository(db),
    )

    return await service.get_group_expenses(
        group_id,
        current_user.id,
    )


@router.delete(
    "/{expense_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_expense(
    expense_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    service = ExpenseService(
        ExpenseRepository(db),
        GroupRepository(db),
    )

    await service.delete(
        expense_id,
        current_user.id,
    )

    return None