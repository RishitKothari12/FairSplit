from enum import Enum
from typing import TYPE_CHECKING

from sqlalchemy import Enum as SQLEnum
from sqlalchemy import ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import BaseModel

if TYPE_CHECKING:
    from app.models.user import User
    from app.models.group import Group


class MemberRole(str, Enum):
    ADMIN = "admin"
    MEMBER = "member"


class GroupMember(BaseModel):
    __tablename__ = "group_members"

    group_id: Mapped[UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("groups.id"),
    )

    user_id: Mapped[UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id"),
    )

    role: Mapped[MemberRole] = mapped_column(
        SQLEnum(MemberRole),
        default=MemberRole.MEMBER,
    )

    group: Mapped["Group"] = relationship(
        back_populates="members",
    )

    user: Mapped["User"] = relationship(
        back_populates="group_memberships",
    )