from uuid import UUID

from fastapi import HTTPException, status

from app.repositories.group_repository import GroupRepository


class GroupGuard:

    def __init__(
        self,
        group_repository: GroupRepository,
    ):
        self.group_repository = group_repository

    async def require_member(
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

        return membership

    async def require_admin(
        self,
        group_id: UUID,
        user_id: UUID,
    ):

        membership = await self.require_member(
            group_id,
            user_id,
        )

        if membership.role.value != "admin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only admins can perform this action.",
            )

        return membership