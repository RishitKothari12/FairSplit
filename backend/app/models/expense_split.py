from __future__ import annotations

from decimal import Decimal
from typing import TYPE_CHECKING

from sqlalchemy import Boolean, ForeignKey, Numeric
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import BaseModel

if TYPE_CHECKING:
    from app.models.expense import Expense
    from app.models.user import User


class ExpenseSplit(BaseModel):
    __tablename__ = "expense_splits"

    expense_id: Mapped[UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("expenses.id"),
        nullable=False,
    )

    user_id: Mapped[UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id"),
        nullable=False,
    )

    amount_owed: Mapped[Decimal] = mapped_column(
        Numeric(10, 2),
        nullable=False,
    )

    percentage: Mapped[Decimal | None] = mapped_column(
        Numeric(5, 2),
        nullable=True,
    )

    shares: Mapped[int | None] = mapped_column(
        nullable=True,
    )

    is_settled: Mapped[bool] = mapped_column(
        Boolean,
        default=False,
    )

    expense: Mapped["Expense"] = relationship(
        back_populates="splits",
    )

    user: Mapped["User"] = relationship(
        back_populates="expense_splits",
    )