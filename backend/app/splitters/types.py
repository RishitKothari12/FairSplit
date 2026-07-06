from dataclasses import dataclass
from decimal import Decimal
from uuid import UUID


@dataclass
class CalculatedSplit:
    user_id: UUID
    amount_owed: Decimal
    percentage: Decimal | None = None
    shares: int | None = None