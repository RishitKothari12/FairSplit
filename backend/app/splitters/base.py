from abc import ABC, abstractmethod
from decimal import Decimal

from app.schemas.expense import ExpenseSplitInput


class BaseSplitter(ABC):

    @abstractmethod
    def calculate(
        self,
        amount: Decimal,
        participants: list[ExpenseSplitInput],
    ):
        pass