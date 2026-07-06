from uuid import UUID

from fastapi import HTTPException, status

from app.models.group import Group
from app.models.group_member import GroupMember, MemberRole
from app.repositories.group_repository import GroupRepository


class GroupService:

    def __init__(self, repository: GroupRepository):
        self.repository = repository

    async def create(
        self,
        name: str,
        description: str | None,
        created_by: UUID,
    ):
        group = Group(
            name=name,
            description=description,
            created_by=created_by,
        )

        group = await self.repository.create(group)

        member = GroupMember(
            group_id=group.id,
            user_id=created_by,
            role=MemberRole.ADMIN,
        )

        await self.repository.create_member(member)

        return group

    async def get_user_groups(self, user_id: UUID):
        return await self.repository.get_user_groups(user_id)

    async def get_group_for_member(
        self,
        group_id: UUID,
        user_id: UUID,
    ):
        group = await self.repository.get_by_id(group_id)

        if group is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Group not found",
            )

        membership = await self.repository.get_membership(
            group_id,
            user_id,
        )

        if membership is None:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You are not a member of this group.",
            )

        return group

    async def get_group_for_admin(
        self,
        group_id: UUID,
        user_id: UUID,
    ):
        group = await self.get_group_for_member(
            group_id,
            user_id,
        )

        if not await self.repository.is_admin(
            group_id,
            user_id,
        ):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only group admins can perform this action.",
            )

        return group

    async def update(
        self,
        group: Group,
        name: str | None,
        description: str | None,
    ):
        if name is not None:
            group.name = name

        if description is not None:
            group.description = description

        return await self.repository.update(group)

    async def delete(self, group: Group):
        await self.repository.delete(group)