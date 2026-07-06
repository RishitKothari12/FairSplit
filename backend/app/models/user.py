from sqlalchemy import Boolean, String
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import BaseModel
from typing import TYPE_CHECKING
from sqlalchemy.orm import relationship

if TYPE_CHECKING:
    from app.models.group import Group
    from app.models.group_member import GroupMember
    from app.models.expense import Expense
    from app.models.expense_split import ExpenseSplit
    from app.models.settlement_history import SettlementHistory

class User(BaseModel):
    __tablename__ = "users"

    full_name: Mapped[str] = mapped_column(String(100))

    email: Mapped[str] = mapped_column(
        String(255),
        unique=True,
        index=True,
    )

    hashed_password: Mapped[str] = mapped_column(String(255))

    profile_photo: Mapped[str | None] = mapped_column(
        String(500),
        nullable=True,
    )

    currency: Mapped[str] = mapped_column(
        String(10),
        default="INR",
    )

    is_active: Mapped[bool] = mapped_column(
        Boolean,
        default=True,
    )

    created_groups: Mapped[list["Group"]] = relationship(
        back_populates="creator",
    )

    group_memberships: Mapped[list["GroupMember"]] = relationship(
        back_populates="user",
    )

    expenses_paid: Mapped[list["Expense"]] = relationship(
        back_populates="payer",
    )

    expense_splits: Mapped[list["ExpenseSplit"]] = relationship(
        back_populates="user",
    )

    settlements_paid: Mapped[list["SettlementHistory"]] = relationship(
        foreign_keys="SettlementHistory.payer_id",
    )

    settlements_received: Mapped[list["SettlementHistory"]] = relationship(
        foreign_keys="SettlementHistory.receiver_id",
    )