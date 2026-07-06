from decimal import Decimal, ROUND_HALF_UP

from app.schemas.expense import ExpenseSplitInput
from app.splitters.base import BaseSplitter
from app.splitters.types import CalculatedSplit


class EqualSplitter(BaseSplitter):

    def calculate(
        self,
        amount: Decimal,
        participants: list[ExpenseSplitInput],
    ):

        share = (
            amount / len(participants)
        ).quantize(
            Decimal("0.01"),
            rounding=ROUND_HALF_UP,
        )

        return [
            CalculatedSplit(
                user_id=participant.user_id,
                amount_owed=share,
            )
            for participant in participants
        ]