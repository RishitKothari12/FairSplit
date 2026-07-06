from decimal import Decimal

from fastapi import HTTPException, status

from app.schemas.expense import ExpenseSplitInput
from app.splitters.base import BaseSplitter
from app.splitters.types import CalculatedSplit


class PercentageSplitter(BaseSplitter):

    def calculate(
        self,
        amount: Decimal,
        participants: list[ExpenseSplitInput],
    ):

        total_percentage = sum(
            participant.percentage or Decimal("0")
            for participant in participants
        )

        if total_percentage != Decimal("100"):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Percentages must add up to 100.",
            )

        return [
            CalculatedSplit(
                user_id=participant.user_id,
                amount_owed=(
                    amount * participant.percentage / Decimal("100")
                ).quantize(Decimal("0.01")),
                percentage=participant.percentage,
            )
            for participant in participants
        ]