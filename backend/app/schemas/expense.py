from datetime import datetime
from decimal import Decimal
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field, model_validator

from app.models.expense import SplitType


class ExpenseSplitInput(BaseModel):
    user_id: UUID
    amount: Decimal | None = None
    percentage: Decimal | None = None
    shares: int | None = None


class ExpenseCreate(BaseModel):
    group_id: UUID

    paid_by: UUID

    title: str = Field(
        min_length=2,
        max_length=100,
    )

    description: str | None = None

    amount: Decimal = Field(gt=0)

    currency: str = Field(
        default="INR",
        max_length=10,
    )

    expense_date: datetime | None = None

    split_type: SplitType

    participants: list[ExpenseSplitInput]

    @model_validator(mode="after")
    def validate_split(self):

        # Minimum participants
        if len(self.participants) < 2:
            raise ValueError(
                "An expense must have at least two participants."
            )

        participant_ids = [
            participant.user_id
            for participant in self.participants
        ]

        # Duplicate participants
        if len(participant_ids) != len(set(participant_ids)):
            raise ValueError(
                "Duplicate participants are not allowed."
            )

        # Payer must be one of the participants
        if self.paid_by not in participant_ids:
            raise ValueError(
                "The payer must be included in participants."
            )

        # Exact split validation
        if self.split_type == SplitType.EXACT:
            if any(
                participant.amount is None
                for participant in self.participants
            ):
                raise ValueError(
                    "Amount is required for exact split."
                )

        # Percentage split validation
        if self.split_type == SplitType.PERCENTAGE:
            if any(
                participant.percentage is None
                for participant in self.participants
            ):
                raise ValueError(
                    "Percentage is required for percentage split."
                )

        # Shares split validation
        if self.split_type == SplitType.SHARES:
            if any(
                participant.shares is None
                for participant in self.participants
            ):
                raise ValueError(
                    "Shares are required for shares split."
                )

        return self


class ExpenseResponse(BaseModel):
    id: UUID
    group_id: UUID
    paid_by: UUID

    title: str
    description: str | None

    amount: Decimal

    currency: str

    split_type: SplitType

    model_config = ConfigDict(
        from_attributes=True,
    )