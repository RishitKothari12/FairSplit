from uuid import UUID

from fastapi import HTTPException, status

from app.models.group_member import GroupMember, MemberRole
from app.repositories.group_repository import GroupRepository
from app.repositories.user_repository import UserRepository


class GroupMemberService:

    def __init__(
        self,
        group_repository: GroupRepository,
        user_repository: UserRepository,
    ):
        self.group_repository = group_repository
        self.user_repository = user_repository

    async def add_member(
        self,
        group_id: UUID,
        admin_id: UUID,
        email: str,
    ):
        # Only admins can add members
        if not await self.group_repository.is_admin(group_id, admin_id):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only group admins can add members.",
            )

        # User must exist
        user = await self.user_repository.get_by_email(email)

        if user is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found.",
            )

        # User already a member?
        membership = await self.group_repository.get_membership(
            group_id,
            user.id,
        )

        if membership is not None:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="User is already a member.",
            )

        member = GroupMember(
            group_id=group_id,
            user_id=user.id,
            role=MemberRole.MEMBER,
        )

        return await self.group_repository.create_member(member)

    async def get_members(
        self,
        group_id: UUID,
        user_id: UUID,
    ):
        membership = await self.group_repository.get_membership(
            group_id,
            user_id,
        )

        if membership is None:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You are not a member of this group.",
            )

        return await self.group_repository.get_group_members(group_id)

    async def remove_member(
        self,
        group_id: UUID,
        admin_id: UUID,
        user_id: UUID,
    ):
        if not await self.group_repository.is_admin(
            group_id,
            admin_id,
        ):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only group admins can remove members.",
            )

        membership = await self.group_repository.get_membership(
            group_id,
            user_id,
        )

        if membership is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Member not found.",
            )

        await self.group_repository.delete_member(membership)