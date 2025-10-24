from enum import Enum
from typing import NamedTuple


class DQTest(NamedTuple):
    """Data quality test."""

    description: str
    generate_queryes: int
    need_source_table: int


class DQCheck(DQTest, Enum):
    """Enum for avaliable tests."""

    empty = DQTest("Table not empty", 0, 0)
    uniq = DQTest("Table don't have any duplicate rows", 0, 0)
    future = DQTest("Table don't have dates from future", 1, 0)
    infinity = DQTest("Table don't have infinity values", 1, 0)
    nan = DQTest("Table don't have NaN values", 1, 0)
    total = DQTest("Equal data total rows count between objects", 0, 1)
    sum = DQTest("Equal data sums in digits columns between objects", 1, 1)
