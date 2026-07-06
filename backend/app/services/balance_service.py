from collections import defaultdict
from decimal import Decimal
from uuid import UUID

from app.repositories.expense_repository import ExpenseRepository


class BalanceService:

    def __init__(
        self,
        expense_repository: ExpenseRepository,
    ):
        self.expense_repository = expense_repository

    async def calculate_group_balances(
        self,
        group_id: UUID,
    ):
        balances = defaultdict(
            lambda: Decimal("0.00")
        )

        rows = await self.expense_repository.get_group_splits(
            group_id,
        )

        credited_expenses: set[UUID] = set()

        for expense, split in rows:

            # Credit each expense only once
            if expense.id not in credited_expenses:
                balances[expense.paid_by] += expense.amount
                credited_expenses.add(expense.id)

            # Debit every participant's share
            balances[split.user_id] -= split.amount_owed
        return balances