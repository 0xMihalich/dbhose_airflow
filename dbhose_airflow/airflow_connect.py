from __future__ import annotations
from typing import TYPE_CHECKING

from airflow.hooks.base import BaseHook
from light_compressor import CompressionMethod
from native_dumper.common import DBMS_DEFAULT_TIMEOUT_SEC

from .dumper import DBHoseDumpParams

if TYPE_CHECKING:
    from airflow.models.connection import Connection
    from native_dumper import NativeDumper
    from pgpack_dumper import PGPackDumper


def dbhose_dumper(
    airflow_connection: str,
    compress_method: CompressionMethod = CompressionMethod.ZSTD,
    timeout: int = DBMS_DEFAULT_TIMEOUT_SEC,
) -> NativeDumper | PGPackDumper:
    """Make Dumper object from Airflow connection string."""

    connection: Connection = BaseHook.get_connection(airflow_connection)
    return DBHoseDumpParams[connection.conn_type].from_airflow(
        connection=connection,
        compress_method=compress_method,
        timeout=timeout,
    )
