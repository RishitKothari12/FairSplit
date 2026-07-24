from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.models.expense import Expense
from app.models.expense_split import ExpenseSplit


class ExpenseRepository:

    def __init__(self, db: AsyncSession):
        self.db = db

    async def create_expense(
        self,
        expense: Expense,
    ):
        self.db.add(expense)
        await self.db.flush()
        await self.db.refresh(expense)
        return expense

    async def create_expense_split(
        self,
        split: ExpenseSplit,
    ):
        self.db.add(split)

    async def get_by_id(
        self,
        expense_id: UUID,
    ):
        result = await self.db.execute(
            select(Expense)
            .options(
                selectinload(Expense.payer),
                selectinload(Expense.splits).selectinload(
                    ExpenseSplit.user,
                ),
            )
            .where(
                Expense.id == expense_id,
            )
        )

        return result.scalar_one_or_none()

    async def get_group_expenses(
        self,
        group_id: UUID,
    ):
        result = await self.db.execute(
            select(Expense)
            .options(
                selectinload(Expense.payer),
                selectinload(Expense.splits).selectinload(
                    ExpenseSplit.user,
                ),
            )
            .where(
                Expense.group_id == group_id,
            )
            .order_by(
                Expense.created_at.desc(),
            )
        )

        return result.scalars().all()

    async def get_group_splits(
        self,
        group_id: UUID,
    ):
        result = await self.db.execute(
            select(
                Expense,
                ExpenseSplit,
            )
            .join(
                ExpenseSplit,
                Expense.id == ExpenseSplit.expense_id,
            )
            .where(
                Expense.group_id == group_id
            )
        )

        return result.all()

    async def commit(self):
        await self.db.commit()

    async def rollback(self):
        await self.db.rollback()

    async def update(
        self,
        expense: Expense,
    ):
        await self.db.commit()
        await self.db.refresh(expense)
        return expense

    async def delete(
        self,
        expense: Expense,
    ):
        await self.db.delete(expense)
        await self.db.commit()