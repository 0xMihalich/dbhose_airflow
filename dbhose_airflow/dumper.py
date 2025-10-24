from __future__ import annotations
from enum import Enum
from typing import (
    NamedTuple,
    TYPE_CHECKING,
)

from airflow.hooks.base import log
from light_compressor import CompressionMethod
from native_dumper import (
    CHConnector,
    NativeDumper,
)
from native_dumper.common import DBMS_DEFAULT_TIMEOUT_SEC
from pgpack_dumper import (
    PGConnector,
    PGPackDumper,
)

if TYPE_CHECKING:
    from airflow.models import Connection


class DBHoseObject(NamedTuple):
    """DBHoseDump init params."""

    name: str
    connection: CHConnector | PGConnector
    dumper: NativeDumper | PGPackDumper

    def from_airflow(
        self,
        connection: Connection,
        compress_method: CompressionMethod = CompressionMethod.ZSTD,
        timeout: int = DBMS_DEFAULT_TIMEOUT_SEC,
    ) -> NativeDumper | PGPackDumper:
        """Init dumper from airflow connection object."""

        params = {
            "compression_method": compress_method,
            "logger": log,
        }

        if self.connection is CHConnector and connection.port == 9000:
            port = 8123
            params["timeout"] = timeout
        else:
            port = connection.port

        dbhose_connector = self.connection(
            connection.host,
            connection.schema,
            connection.login,
            connection.password,
            port,
        )

        return self.dumper(dbhose_connector, **params)


class DBHoseDumpParams(DBHoseObject, Enum):
    """Enums for DBHoseDumps."""

    clickhouse = DBHoseObject("clickhouse", CHConnector, NativeDumper)
    ftp = DBHoseObject("ftp", CHConnector, NativeDumper)
    http = DBHoseObject("http", CHConnector, NativeDumper)
    postgres = DBHoseObject("postgres", PGConnector, PGPackDumper)
    greenplum = DBHoseObject("greenplum", PGConnector, PGPackDumper)
