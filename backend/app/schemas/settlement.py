from datetime import datetime
from decimal import Decimal
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field


class SettlementCreate(BaseModel):
    group_id: UUID

    payer_id: UUID

    receiver_id: UUID

    amount: Decimal = Field(gt=0)

    note: str | None = Field(
        default=None,
        max_length=255,
    )


class SettlementResponse(BaseModel):
    id: UUID

    group_id: UUID

    payer_id: UUID
    payer_name: str

    receiver_id: UUID
    receiver_name: str

    amount: Decimal

    note: str | None

    settled_at: datetime