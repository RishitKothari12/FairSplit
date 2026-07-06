from decimal import Decimal

from fastapi import HTTPException, status

from app.schemas.expense import ExpenseSplitInput
from app.splitters.base import BaseSplitter
from app.splitters.types import CalculatedSplit


class ExactSplitter(BaseSplitter):

    def calculate(
        self,
        amount: Decimal,
        participants: list[ExpenseSplitInput],
    ):

        total = sum(
            participant.amount or Decimal("0")
            for participant in participants
        )

        if total != amount:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Exact split amounts must equal total expense.",
            )

        return [
            CalculatedSplit(
                user_id=participant.user_id,
                amount_owed=participant.amount,
            )
            for participant in participants
        ]