from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import get_current_user
from app.db.session import get_db
from app.models.user import User
from app.repositories.group_repository import GroupRepository
from app.schemas.group import (
    GroupCreate,
    GroupResponse,
    GroupUpdate,
)
from app.services.group_service import GroupService

router = APIRouter(
    prefix="/groups",
    tags=["Groups"],
)


@router.post(
    "",
    response_model=GroupResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_group(
    group: GroupCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    service = GroupService(GroupRepository(db))

    return await service.create(
        name=group.name,
        description=group.description,
        created_by=current_user.id,
    )


@router.get(
    "",
    response_model=list[GroupResponse],
)
async def get_groups(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    service = GroupService(GroupRepository(db))

    return await service.get_user_groups(
        current_user.id,
    )


@router.get(
    "/{group_id}",
    response_model=GroupResponse,
)
async def get_group(
    group_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    service = GroupService(GroupRepository(db))

    return await service.get_group_for_member(
        group_id,
        current_user.id,
    )


@router.patch(
    "/{group_id}",
    response_model=GroupResponse,
)
async def update_group(
    group_id: UUID,
    payload: GroupUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    service = GroupService(GroupRepository(db))

    group = await service.get_group_for_admin(
        group_id,
        current_user.id,
    )

    return await service.update(
        group,
        payload.name,
        payload.description,
    )

@router.delete(
    "/{group_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_group(
    group_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    service = GroupService(GroupRepository(db))

    group = await service.get_group_for_admin(
        group_id,
        current_user.id,
    )

    await service.delete(group)