from pgpack_dumper import (
    PGPackDumper,
    PGConnector,
)

connector = PGConnector(
    host="localhost",
    dbname="",
    user="my_user",
    password="my_password",  # noqa: S106
    port=5432,

)
dumper = PGPackDumper(connector)
