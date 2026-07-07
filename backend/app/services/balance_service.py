from collections import defaultdict
from decimal import Decimal
from uuid import UUID

from app.repositories.expense_repository import ExpenseRepository
from app.schemas.balance import BalanceResponse


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

            # Debit every participant
            balances[split.user_id] -= split.amount_owed

        return balances

    async def simplify_debts(
        self,
        group_id: UUID,
    ):
        balances = await self.calculate_group_balances(
            group_id,
        )

        creditors = []
        debtors = []

        for user_id, balance in balances.items():

            if balance > 0:
                creditors.append([user_id, balance])

            elif balance < 0:
                debtors.append([user_id, -balance])

        settlements: list[BalanceResponse] = []

        i = 0
        j = 0

        while i < len(debtors) and j < len(creditors):

            debtor_id, debt = debtors[i]
            creditor_id, credit = creditors[j]

            amount = min(debt, credit)

            settlements.append(
                BalanceResponse(
                    from_user=debtor_id,
                    to_user=creditor_id,
                    amount=amount,
                )
            )

            debtors[i][1] -= amount
            creditors[j][1] -= amount

            if debtors[i][1] == Decimal("0.00"):
                i += 1

            if creditors[j][1] == Decimal("0.00"):
                j += 1

        return settlements