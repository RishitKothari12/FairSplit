from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field


class GroupCreate(BaseModel):
    name: str = Field(min_length=2, max_length=100)
    description: str | None = Field(
        default=None,
        max_length=255,
    )


class GroupUpdate(BaseModel):
    name: str | None = Field(
        default=None,
        min_length=2,
        max_length=100,
    )
    description: str | None = Field(
        default=None,
        max_length=255,
    )


class GroupResponse(BaseModel):
    id: UUID
    name: str
    description: str | None
    created_by: UUID

    model_config = ConfigDict(
        from_attributes=True,
    )