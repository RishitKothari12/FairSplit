from fastapi import APIRouter, Depends

from app.core.security import get_current_user
from app.models.user import User
from app.schemas.auth import UserResponse
from fastapi import Body
from app.repositories.user_repository import UserRepository
from app.db.session import get_db
from sqlalchemy.ext.asyncio import AsyncSession
from app.schemas.auth import UpdateUpiIdRequest
from uuid import UUID
from fastapi import HTTPException, status
from app.schemas.auth import UserPaymentResponse

router = APIRouter(
    prefix="/users",
    tags=["Users"],
)


@router.get(
    "/me",
    response_model=UserResponse,
)
async def get_me(
    current_user: User = Depends(get_current_user),
):
    return current_user

@router.patch(
    "/me/upi-id",
    response_model=UserResponse,
)
async def update_upi_id(
    request: UpdateUpiIdRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    repository = UserRepository(db)

    current_user.upi_id = request.upi_id

    return await repository.update(
        current_user,
    )

@router.get(
    "/{user_id}/payment",
    response_model=UserPaymentResponse,
)
async def get_user_payment_details(
    user_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    repository = UserRepository(db)

    user = await repository.get_by_id(
        user_id,
    )

    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found.",
        )

    return user