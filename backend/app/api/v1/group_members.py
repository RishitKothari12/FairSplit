from uuid import UUID

from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import get_current_user
from app.db.session import get_db
from app.models.user import User
from app.repositories.group_repository import GroupRepository
from app.repositories.user_repository import UserRepository
from app.schemas.group_member import (
    AddMemberRequest,
    GroupMemberResponse,
)
from app.services.group_member_service import GroupMemberService

router = APIRouter(
    prefix="/groups",
    tags=["Group Members"],
)


@router.post(
    "/{group_id}/members",
    response_model=GroupMemberResponse,
    status_code=status.HTTP_201_CREATED,
)
async def add_member(
    group_id: UUID,
    payload: AddMemberRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    service = GroupMemberService(
        GroupRepository(db),
        UserRepository(db),
    )

    return await service.add_member(
        group_id,
        current_user.id,
        payload.email,
    )


@router.get(
    "/{group_id}/members",
    response_model=list[GroupMemberResponse],
)
async def get_members(
    group_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    service = GroupMemberService(
        GroupRepository(db),
        UserRepository(db),
    )

    return await service.get_members(
        group_id,
        current_user.id,
    )


@router.delete(
    "/{group_id}/members/{user_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def remove_member(
    group_id: UUID,
    user_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    service = GroupMemberService(
        GroupRepository(db),
        UserRepository(db),
    )

    await service.remove_member(
        group_id,
        current_user.id,
        user_id,
    )

    return None