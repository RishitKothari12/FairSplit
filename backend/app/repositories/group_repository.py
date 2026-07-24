from uuid import UUID

from sqlalchemy import desc, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.models.group import Group
from app.models.group_member import GroupMember, MemberRole


class GroupRepository:

    def __init__(self, db: AsyncSession):
        self.db = db

    async def create(self, group: Group):
        self.db.add(group)
        await self.db.commit()
        await self.db.refresh(group)
        return group

    async def create_member(self, member: GroupMember):
        self.db.add(member)
        await self.db.commit()
        await self.db.refresh(member)
        return member

    async def get_by_id(self, group_id: UUID):
        result = await self.db.execute(
            select(Group).where(Group.id == group_id)
        )
        return result.scalar_one_or_none()

    async def get_user_groups(self, user_id: UUID):
        result = await self.db.execute(
            select(Group)
            .join(GroupMember)
            .where(GroupMember.user_id == user_id)
            .order_by(desc(Group.created_at))
        )
        return result.scalars().all()

    async def get_membership(
        self,
        group_id: UUID,
        user_id: UUID,
    ):
        result = await self.db.execute(
            select(GroupMember).where(
                GroupMember.group_id == group_id,
                GroupMember.user_id == user_id,
            )
        )

        return result.scalar_one_or_none()

    async def is_admin(
        self,
        group_id: UUID,
        user_id: UUID,
    ) -> bool:
        membership = await self.get_membership(
            group_id,
            user_id,
        )

        return (
            membership is not None
            and membership.role == MemberRole.ADMIN
        )


    async def get_group_members(
        self,
        group_id: UUID,
    ):
        result = await self.db.execute(
            select(GroupMember)
           .options(
                selectinload(GroupMember.user),
            )
            .where(
                GroupMember.group_id == group_id
            )
        )

        return result.scalars().all()

    async def delete_member(
        self,
        member: GroupMember,
    ):
        await self.db.delete(member)
        await self.db.commit()

    async def update(self, group: Group):
        await self.db.commit()
        await self.db.refresh(group)
        return group

    async def delete(self, group: Group):
        await self.db.delete(group)
        await self.db.commit()