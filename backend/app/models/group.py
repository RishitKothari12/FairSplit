from typing import TYPE_CHECKING

from sqlalchemy import ForeignKey, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import BaseModel

if TYPE_CHECKING:
    from app.models.user import User
    from app.models.group_member import GroupMember
    from app.models.expense import Expense
    from app.models.settlement_history import SettlementHistory


class Group(BaseModel):
    __tablename__ = "groups"

    name: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
    )

    description: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True,
    )

    created_by: Mapped[UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id"),
        nullable=False,
    )

    creator: Mapped["User"] = relationship(
        back_populates="created_groups",
    )

    members: Mapped[list["GroupMember"]] = relationship(
        back_populates="group",
        cascade="all, delete-orphan",
    )

    expenses: Mapped[list["Expense"]] = relationship(
        back_populates="group",
        cascade="all, delete-orphan",
    )

    settlements: Mapped[list["SettlementHistory"]] = relationship(
        cascade="all, delete-orphan",
    )