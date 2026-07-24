from pydantic import BaseModel, ConfigDict, EmailStr, Field
from uuid import UUID


class UserRegister(BaseModel):
    full_name: str = Field(min_length=2, max_length=100)
    email: EmailStr
    password: str = Field(min_length=8, max_length=128)


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class UserResponse(BaseModel):
    id: UUID
    full_name: str
    email: EmailStr
    profile_photo: str | None = None
    currency: str
    upi_id: str | None = None
    is_active: bool

    model_config = ConfigDict(from_attributes=True)

class UpdateUpiIdRequest(BaseModel):
    upi_id: str | None = Field(
        default=None,
        max_length=100,
    )

class UserPaymentResponse(BaseModel):
    id: UUID
    full_name: str
    upi_id: str | None

    model_config = ConfigDict(
        from_attributes=True,
    )
    
class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"