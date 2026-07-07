from collections import defaultdict
from decimal import Decimal
from uuid import UUID

from app.repositories.expense_repository import ExpenseRepository
from app.repositories.group_repository import GroupRepository
from app.repositories.settlement_repository import SettlementRepository
from app.schemas.balance import BalanceResponse
from app.services.group_guard import GroupGuard


class BalanceService:

    def __init__(
        self,
        expense_repository: ExpenseRepository,
        settlement_repository: SettlementRepository,
        group_repository: GroupRepository,
    ):
        self.expense_repository = expense_repository
        self.settlement_repository = settlement_repository
        self.group_repository = group_repository
        self.guard = GroupGuard(group_repository)

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

        # Apply settlements
        settlements = await self.settlement_repository.get_group_settlements(
            group_id,
        )

        for settlement in settlements:
            balances[settlement.payer_id] += settlement.amount
            balances[settlement.receiver_id] -= settlement.amount

        return balances

    async def simplify_debts(
        self,
        group_id: UUID,
        current_user_id: UUID,
    ):

        await self.guard.require_member(
            group_id,
            current_user_id,
        )

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

            amount = min(
                debt,
                credit,
            )

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