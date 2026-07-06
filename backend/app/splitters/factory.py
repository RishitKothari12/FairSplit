from app.models.expense import SplitType
from app.splitters.equal_splitter import EqualSplitter
from app.splitters.exact_splitter import ExactSplitter
from app.splitters.percentage_splitter import PercentageSplitter
from app.splitters.shares_splitter import SharesSplitter


class SplitterFactory:

    @staticmethod
    def get(split_type: SplitType):

        if split_type == SplitType.EQUAL:
            return EqualSplitter()

        if split_type == SplitType.EXACT:
            return ExactSplitter()

        if split_type == SplitType.PERCENTAGE:
            return PercentageSplitter()

        if split_type == SplitType.SHARES:
            return SharesSplitter()

        raise ValueError("Unsupported split type.")