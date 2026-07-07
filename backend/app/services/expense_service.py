from datetime import datetime
from decimal import Decimal
from uuid import UUID

from fastapi import HTTPException, status

from app.models.expense import Expense, SplitType
from app.models.expense_split import ExpenseSplit
from app.repositories.expense_repository import ExpenseRepository
from app.repositories.group_repository import GroupRepository
from app.services.group_guard import GroupGuard
from app.splitters.factory import SplitterFactory


class ExpenseService:

    def __init__(
        self,
        expense_repository: ExpenseRepository,
        group_repository: GroupRepository,
    ):
        self.expense_repository = expense_repository
        self.group_repository = group_repository
        self.guard = GroupGuard(group_repository)

    async def create(
        self,
        current_user_id: UUID,
        group_id: UUID,
        paid_by: UUID,
        title: str,
        description: str | None,
        amount: Decimal,
        currency: str,
        expense_date: datetime | None,
        split_type: SplitType,
        participants,
    ):

        # Group must exist
        group = await self.group_repository.get_by_id(
            group_id,
        )

        if group is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Group not found.",
            )

        # Logged in user must belong to group
        await self._check_group_access(
            group_id,
            current_user_id,
        )

        # Payer must belong to group
        await self.guard.require_member(
            group_id,
            paid_by,
        )

        # Every participant must belong to the group
        for participant in participants:
            await self.guard.require_member(
                group_id,
                participant.user_id,
            )

        try:

            expense = Expense(
                group_id=group_id,
                paid_by=paid_by,
                title=title,
                description=description,
                amount=amount,
                currency=currency,
                expense_date=expense_date or datetime.utcnow(),
                split_type=split_type,
            )

            expense = await self.expense_repository.create_expense(
                expense,
            )

            splitter = SplitterFactory.get(
                split_type,
            )

            splits = splitter.calculate(
                amount,
                participants,
            )

            for calculated_split in splits:

                split = ExpenseSplit(
                    expense_id=expense.id,
                    user_id=calculated_split.user_id,
                    amount_owed=calculated_split.amount_owed,
                    percentage=calculated_split.percentage,
                    shares=calculated_split.shares,
                )

                await self.expense_repository.create_expense_split(
                    split,
                )

            await self.expense_repository.commit()

            return expense

        except Exception:
            await self.expense_repository.rollback()
            raise

    async def get(
        self,
        expense_id: UUID,
        current_user_id: UUID,
    ):
        expense = await self.expense_repository.get_by_id(
            expense_id,
        )

        if expense is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Expense not found.",
            )

        await self._check_group_access(
            expense.group_id,
            current_user_id,
        )

        return expense

    async def get_group_expenses(
        self,
        group_id: UUID,
        current_user_id: UUID,
    ):

        await self._check_group_access(
            group_id,
            current_user_id,
        )

        return await self.expense_repository.get_group_expenses(
            group_id,
        )

    async def delete(
        self,
        expense_id: UUID,
        current_user_id: UUID,
    ):
        expense = await self.expense_repository.get_by_id(
            expense_id,
        )

        if expense is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Expense not found.",
            )

        await self._check_group_access(
            expense.group_id,
            current_user_id,
        )

        is_admin = await self.group_repository.is_admin(
            expense.group_id,
            current_user_id,
        )

        if (
            expense.paid_by != current_user_id
            and not is_admin
        ):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You are not allowed to delete this expense.",
            )

        await self.expense_repository.delete(
            expense,
        )

    async def _check_group_access(
        self,
        group_id: UUID,
        user_id: UUID,
    ):
        await self.guard.require_member(
            group_id,
            user_id,
        )