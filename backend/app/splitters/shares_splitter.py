from decimal import Decimal

from fastapi import HTTPException, status

from app.schemas.expense import ExpenseSplitInput
from app.splitters.base import BaseSplitter
from app.splitters.types import CalculatedSplit


class SharesSplitter(BaseSplitter):

    def calculate(
        self,
        amount: Decimal,
        participants: list[ExpenseSplitInput],
    ):

        total_shares = sum(
            participant.shares or 0
            for participant in participants
        )

        if total_shares <= 0:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Total shares must be greater than zero.",
            )

        value_per_share = amount / Decimal(total_shares)

        return [
            CalculatedSplit(
                user_id=participant.user_id,
                amount_owed=(
                    value_per_share * participant.shares
                ).quantize(Decimal("0.01")),
                shares=participant.shares,
            )
            for participant in participants
        ]