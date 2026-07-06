from __future__ import annotations

from datetime import datetime
from decimal import Decimal
from typing import TYPE_CHECKING

from sqlalchemy import DateTime, ForeignKey, Numeric, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import BaseModel

if TYPE_CHECKING:
    from app.models.group import Group
    from app.models.user import User


class SettlementHistory(BaseModel):
    __tablename__ = "settlement_history"

    group_id: Mapped[UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("groups.id"),
        nullable=False,
    )

    payer_id: Mapped[UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id"),
        nullable=False,
    )

    receiver_id: Mapped[UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id"),
        nullable=False,
    )

    amount: Mapped[Decimal] = mapped_column(
        Numeric(10, 2),
        nullable=False,
    )

    note: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True,
    )

    settled_at: Mapped[datetime] = mapped_column(
        DateTime,
        default=datetime.utcnow,
    )

    payer: Mapped["User"] = relationship(
        foreign_keys=[payer_id],
    )

    receiver: Mapped["User"] = relationship(
        foreign_keys=[receiver_id],
    )

    group: Mapped["Group"] = relationship()