from __future__ import annotations
from os.path import dirname
from typing import (
    Any,
    TYPE_CHECKING,
)

from airflow.hooks.base import log
from dbhose_utils import DumpType
from light_compressor import CompressionMethod
from native_dumper import NativeDumper
from native_dumper.common import DBMS_DEFAULT_TIMEOUT_SEC
from pandas import DataFrame as PDFrame
from polars import DataFrame as PLFrame

from .airflow_connect import dbhose_dumper
from .dq_check import DQCheck
from .move_method import MoveMethod

if TYPE_CHECKING:
    from collections.abc import Iterable
    from io import BufferedReader


__all__ = (
    "DBMS_DEFAULT_TIMEOUT_SEC",
    "CompressionMethod",
    "DBHose",
    "DumpType",
    "MoveMethod",
    "dbhose_dumper",
)
__version__ = "0.0.0.1"


root_path = dirname(__file__)
logo_path = f"{root_path}/LOGO"
ddl_path = f"{root_path}/ddl/{{}}.sql"
dq_path = f"{root_path}/dq/{{}}/{{}}.sql"
mv_path = f"{root_path}/move/{{}}/{{}}.sql"


def read_text(path: str) -> str:
    """Read text from file."""

    with open(path, encoding="utf-8") as file:
        return file.read()


def wrap_frame(
    text: str,
    min_width: int = 79,
) -> str:
    """Wraps text in a frame with a minimum size.

    Arguments:
           text (str): Text to wrap
           min_width (int): Minimum frame width (default 79)

    Returns:
           str: Text in frame

    """

    lines = [line.strip() for line in str(text).split("\n") if line.strip()]
    max_line_length = max(len(line) for line in lines) if lines else 0
    content_width = max(
        max_line_length, min_width - 4,
    )
    frame_width = content_width + 4
    result = [""]
    result.append("┌" + "─" * (frame_width - 2) + "┐")

    for line in lines:
        spaces_needed = content_width - len(line)
        padded_line = f" {line}{' ' * spaces_needed} "
        result.append("│" + padded_line + "│")

    result.append("└" + "─" * (frame_width - 2) + "┘")
    return "\n".join(result)


class DBHose:
    """DBHose object."""

    def __init__(
        self,
        table_dest: str,
        connection_dest: str,
        connection_src: str | None = None,
        dq_skip_check: list[str] = [],
        filter_by: list[str] = [],
        drop_temp_table: bool = True,
        move_method: MoveMethod = MoveMethod.replace,
        custom_move: str | None = None,
        compress_method: CompressionMethod = CompressionMethod.ZSTD,
        timeout: int = DBMS_DEFAULT_TIMEOUT_SEC,
    ) -> None:
        """Class initialization."""

        self.logger = log
        self.table_dest = table_dest
        self.connection_dest = connection_dest
        self.connection_src = connection_src
        self.dq_skip_check = dq_skip_check
        self.filter_by = filter_by
        self.drop_temp_table = drop_temp_table
        self.move_method = move_method
        self.custom_move = custom_move
        self.dumper_dest = dbhose_dumper(
            self.connection_dest,
            compress_method,
            timeout,
        )
        self.dumper_src = None
        self.ddl = None
        self.temp_ddl = None
        self.table_temp = None

        if self.connection_src:
            self.dumper_src = dbhose_dumper(
                self.connection_src,
                compress_method,
                timeout,
            )

        self.logger.info(read_text(logo_path))

    def create_temp(self) -> None:
        """Create temporary table."""

        self.logger.info("Make temp table operation start")
        query_ddl = read_text(ddl_path.format(self.dumper_dest.dbname))
        self.logger.info("Getting data from server")
        reader = self.dumper_dest.to_reader(
            query_ddl.format(table=self.table_dest)
        )
        self.ddl, self.temp_ddl, self.table_temp = tuple(*reader.to_rows())

        if not self.ddl:
            msg = f"Table {self.table_dest} not found!"
            self.logger.error(wrap_frame(msg))
            raise ValueError(msg)

        self.logger.info(f"Make table {self.table_temp}")
        self.dumper_dest.cursor.execute(self.temp_ddl)

        if self.dumper_dest.__class__ is not NativeDumper:
            self.dumper_dest.connect.commit()

        self.logger.info(wrap_frame(f"Table {self.table_temp} created"))

    def drop_temp(self) -> None:
        """Drop temp table."""

        if self.drop_temp_table:
            self.logger.info("Drop temp table operation start")
            self.dumper_dest.cursor.execute(
                f"drop table if exists {self.table_temp}"
            )

            if self.dumper_dest.__class__ is not NativeDumper:
                self.dumper_dest.connect.commit()

            self.logger.info(wrap_frame(f"Table {self.table_temp} dropped"))
        else:
            self.logger.warning(
                wrap_frame("Drop temp table operation skipped by user")
            )

    def dq_check(self, table: str | None = None) -> None:
        """Data quality checker."""

        self.logger.info(wrap_frame("Start Data Quality tests"))

        for test in DQCheck._member_names_:
            dq = DQCheck[test]

            if test in self.dq_skip_check:
                self.logger.warning(
                    wrap_frame(f"{dq.description} test skipped by user")
                )
                continue
            if dq.need_source_table and not table:
                self.logger.warning(
                    wrap_frame(
                        f"{dq.description} test skipped [no source object]"
                    ),
                )
                continue

            query_dest = read_text(
                dq_path.format(self.dumper_dest.dbname, test),
            )

            if dq.need_source_table:
                dumper_src = self.dumper_src or self.dumper_dest
                query_src = read_text(
                    dq_path.format(dumper_src.dbname, test),
                )

                if dq.generate_queryes:
                    reader_src = dumper_src.to_reader(
                        query_src.format(table=table),
                    )
                    tests_src = list(reader_src.to_rows())
                    have_test = next(iter(tests_src))

                    if not have_test:
                        self.logger.warning(
                            wrap_frame(f"{dq.description} test Skip "
                            "[no data types for test]"),
                        )
                        continue

                    reader_dest = self.dumper_dest.to_reader(
                        query_dest.format(table=self.table_temp),
                    )
                    tests_dest = list(reader_dest.to_rows())

                    for (_, column_src, test_src) in tests_src:
                        for (_, column_dest, test_dest) in tests_dest:
                            if column_src == column_dest:
                                reader_src = dumper_src.to_reader(test_src)
                                reader_dest = self.dumper_dest.to_reader(
                                    test_dest,
                                )
                                value_src = next(iter(*reader_src.to_rows()))
                                value_dst = next(iter(*reader_dest.to_rows()))

                                if value_src != value_dst:
                                    err_msg = (
                                        f"Check {column_src} test Fail: "
                                        f"value {value_src} <> {value_dst}"
                                    )
                                    self.logger.error(wrap_frame(err_msg))
                                    raise ValueError(err_msg)

                                self.logger.info(
                                    wrap_frame(
                                        f"Check {column_src} test Pass"
                                    ),
                                )
                                break
                        else:
                            self.logger.warning(
                                wrap_frame(f"Check {column_src} test Skip "
                                "[no column for test]"),
                            )
                else:
                    reader_src = dumper_src.to_reader(
                        query_src.format(table=table),
                    )
                    reader_dest = self.dumper_dest.to_reader(
                        query_dest.format(table=self.table_temp),
                    )
                    value_src = next(iter(reader_src.to_rows()))[0]
                    value_dst = next(iter(reader_dest.to_rows()))[0]

                    if value_src != value_dst:
                        err_msg = (
                            f"{dq.description} test Fail: "
                            f"value {value_src} <> {value_dst}"
                        )
                        self.logger.error(wrap_frame(err_msg))
                        raise ValueError(err_msg)

            else:
                reader_dest = self.dumper_dest.to_reader(
                    query_dest.format(table=self.table_temp),
                )

                if dq.generate_queryes:
                    tests = list(reader_dest.to_rows())

                    for (have_test, column_name, query) in tests:

                        if not have_test:
                            self.logger.warning(
                                wrap_frame(f"{dq.description} test Skip "
                                "[no column for test]"),
                            )
                            break

                        reader_dest = self.dumper_dest.to_reader(query)
                        value, result = next(iter(reader_dest.to_rows()))

                        if result == "Fail":
                            err_msg = (
                                f"Check {column_name} test Fail "
                                f"with {value} error rows"
                            )
                            self.logger.error(wrap_frame(err_msg))
                            raise ValueError(err_msg)

                        self.logger.info(
                            wrap_frame(f"Check {column_name} test Pass"),
                        )
                else:
                    value, result = next(iter(reader_dest.to_rows()))

                    if result == "Fail":
                        err_msg = (
                            f"{dq.description} test Fail "
                            f"with {value} error rows"
                        )
                        self.logger.error(wrap_frame(err_msg))
                        raise ValueError(err_msg)

            self.logger.info(wrap_frame(f"{dq.description} test Pass"))

        self.logger.info(
            wrap_frame("All Data Quality tests have been completed")
        )

    def to_table(self) -> None:
        """Move data to destination table."""

        self.logger.info(
            wrap_frame(f"Move data with method {self.move_method.name}")
        )

        if self.move_method.need_filter and not self.filter_by:
            error_msg = "You must specify columns in filter_by"
            self.logger.error(wrap_frame(error_msg))
            raise ValueError(error_msg)

        if self.move_method.is_custom:

            if not self.custom_move:
                error_msg = "You must specify custom query"
                self.logger.error(wrap_frame(error_msg))
                raise ValueError(error_msg)

            self.dumper_dest.cursor.execute(self.custom_move)

            if self.dumper_dest.__class__ is not NativeDumper:
                self.dumper_dest.connect.commit()

        elif self.move_method.have_sql:
            move_query = read_text(
                mv_path.format(self.dumper_dest.dbname, self.move_method.name)
            )
            reader = self.dumper_dest.to_reader(move_query.format(
                table_dest=self.table_dest,
                table_temp=self.table_temp,
                filter_by=self.filter_by,
            ))
            is_avaliable, move_query = tuple(*reader.to_rows())

            if not is_avaliable:
                error_msg = (
                    f"Method {self.move_method.name} is not available for "
                    f"{self.table_dest}. Use another method."
                )
                self.logger.error(wrap_frame(error_msg))
                raise ValueError(error_msg)

            self.dumper_dest.cursor.execute(move_query)

            if self.dumper_dest.__class__ is not NativeDumper:
                self.dumper_dest.connect.commit()

        else:
            self.dumper_dest.write_between(self.table_dest, self.table_temp)

        self.logger.info(wrap_frame(f"Data moved into {self.table_dest}"))
        self.drop_temp()

    def from_file(
        self,
        fileobj: BufferedReader,
    ) -> None:
        """Upload from dump file object."""

        self.create_temp()
        self.dumper_dest.write_dump(fileobj, self.table_temp)
        self.dq_check()
        self.to_table()

    def from_iterable(
        self,
        dtype_data: Iterable[Any],
    ) -> None:
        """Upload from python iterable object."""

        self.create_temp()
        self.dumper_dest.from_rows(dtype_data, self.table_temp)
        self.dq_check()
        self.to_table()

    def from_frame(
        self,
        data_frame: PDFrame | PLFrame,
    ) -> None:
        """Upload from DataFrame."""

        self.create_temp()

        if data_frame.__class__ is PDFrame:
            self.dumper_dest.from_pandas(data_frame, self.table_temp)
        elif data_frame.__class__ is PLFrame:
            self.dumper_dest.from_polars(data_frame, self.table_temp)
        else:
            msg = f"Unknown DataFrame type {data_frame.__class__}."
            raise TypeError(msg)

        self.dq_check()
        self.to_table()

    def from_dmbs(
        self,
        query: str | None = None,
        table: str | None = None,
    ) -> None:
        """Upload from DMBS."""

        self.create_temp()
        self.dumper_dest.write_between(
            self.table_temp,
            table,
            query,
            self.dumper_src,
        )
        self.dq_check(table)
        self.to_table()
