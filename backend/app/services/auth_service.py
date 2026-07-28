from app.core.security import (
    create_access_token,
    hash_password,
    verify_password,
)
from app.models.user import User
from app.repositories.user_repository import UserRepository


class AuthService:

    def __init__(self, repository: UserRepository):
        self.repository = repository

    async def register(
        self,
        full_name: str,
        email: str,
        password: str,
    ):

        existing_user = await self.repository.get_by_email(email)

        if existing_user:
            raise ValueError("Email already registered")

        user = User(
            full_name=full_name,
            email=email,
            hashed_password=hash_password(password),
        )

        return await self.repository.create(user)

    async def login(
        self,
        email: str,
        password: str,
    ):

        user = await self.repository.get_by_email(email)

        print("=" * 50)
        print("LOGIN DEBUG")
        print("Email:", email)

        if not user:
            print("User not found")
            print("=" * 50)
            return None

        print("DB Hash:", user.hashed_password)
        print("Received Password:", password)

        is_valid = verify_password(
            password,
            user.hashed_password,
        )

        print("Password Valid:", is_valid)
        print("=" * 50)

        if not is_valid:
            return None

        token = create_access_token(
            subject=user.email,
        )

        return token