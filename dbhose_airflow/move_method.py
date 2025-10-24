from enum import Enum
from typing import NamedTuple


class MoveType(NamedTuple):
    """Move method object."""

    name: str
    have_sql: bool
    need_filter: bool
    is_custom: bool


class MoveMethod(MoveType, Enum):
    """Insert from temp table methods."""

    append = MoveType("append", False, False, False)
    custom = MoveType("custom", False, False, True)
    delete = MoveType("delete", True, True, False)
    replace = MoveType("replace", True, False, False)
