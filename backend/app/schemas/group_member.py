from uuid import UUID

from pydantic import BaseModel, ConfigDict, EmailStr


class AddMemberRequest(BaseModel):
    email: EmailStr


class GroupMemberResponse(BaseModel):
    id: UUID
    user_id: UUID
    group_id: UUID

    full_name: str
    email: EmailStr

    role: str

    model_config = ConfigDict(from_attributes=True)