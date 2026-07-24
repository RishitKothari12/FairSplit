from __future__ import annotations

from datetime import datetime, timezone
from decimal import Decimal
from enum import Enum
from typing import TYPE_CHECKING

from sqlalchemy import DateTime, Enum as SQLEnum, ForeignKey, Numeric, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import BaseModel

if TYPE_CHECKING:
    from app.models.group import Group
    from app.models.user import User
    from app.models.expense_split import ExpenseSplit


class SplitType(str, Enum):
    EQUAL = "equal"
    EXACT = "exact"
    PERCENTAGE = "percentage"
    SHARES = "shares"


class Expense(BaseModel):
    __tablename__ = "expenses"

    group_id: Mapped[UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("groups.id"),
        nullable=False,
    )

    paid_by: Mapped[UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id"),
        nullable=False,
    )

    title: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
    )

    description: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True,
    )

    amount: Mapped[Decimal] = mapped_column(
        Numeric(10, 2),
        nullable=False,
    )

    currency: Mapped[str] = mapped_column(
        String(10),
        default="INR",
    )

    split_type: Mapped[SplitType] = mapped_column(
        SQLEnum(SplitType),
        default=SplitType.EQUAL,
    )

    expense_date: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
    )

    group: Mapped["Group"] = relationship(
        back_populates="expenses",
    )

    payer: Mapped["User"] = relationship(
        back_populates="expenses_paid",
    )

    splits: Mapped[list["ExpenseSplit"]] = relationship(
        back_populates="expense",
        cascade="all, delete-orphan",
    )