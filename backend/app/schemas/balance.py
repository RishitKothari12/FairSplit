from decimal import Decimal
from uuid import UUID

from pydantic import BaseModel


class UserBalance(BaseModel):
    user_id: UUID
    balance: Decimal


class BalanceResponse(BaseModel):
    from_user: UUID
    to_user: UUID
    amount: Decimal