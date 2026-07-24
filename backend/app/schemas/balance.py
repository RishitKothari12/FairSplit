from decimal import Decimal
from uuid import UUID

from pydantic import BaseModel, ConfigDict


class BalanceTransaction(BaseModel):
    from_user_id: UUID
    from_user_name: str

    to_user_id: UUID
    to_user_name: str

    amount: Decimal

    model_config = ConfigDict(
        from_attributes=True,
    )


class BalanceSummaryResponse(BaseModel):
    group_id: UUID

    you_owe: Decimal
    you_are_owed: Decimal

    net_balance: Decimal

    transactions: list[BalanceTransaction]

    model_config = ConfigDict(
        from_attributes=True,
    )