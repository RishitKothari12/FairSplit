from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.session import get_db
from app.repositories.user_repository import UserRepository
from app.schemas.auth import (
    Token,
    UserLogin,
    UserRegister,
    UserResponse,
)
from app.services.auth_service import AuthService

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"],
)


@router.post(
    "/register",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
)
async def register(
    user: UserRegister,
    db: AsyncSession = Depends(get_db),
):
    service = AuthService(UserRepository(db))

    return await service.register(
        full_name=user.full_name,
        email=user.email,
        password=user.password,
    )
    '''try:
        return await service.register(
            full_name=user.full_name,
            email=user.email,
            password=user.password,
        )
    except ValueError as e:
        raise HTTPException(
            status_code=400,
            detail=str(e),
        )
'''

@router.post(
    "/login",
    response_model=Token,
)
async def login(
    credentials: UserLogin,
    db: AsyncSession = Depends(get_db),
):
    service = AuthService(UserRepository(db))

    token = await service.login(
        credentials.email,
        credentials.password,
    )

    if token is None:
        raise HTTPException(
            status_code=401,
            detail="Invalid email or password",
        )

    return {
        "access_token": token,
        "token_type": "bearer",
    }