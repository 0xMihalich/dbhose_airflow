from native_dumper import (
    NativeDumper,
    CHConnector,
)

connector = CHConnector(
    host="localhost",
    dbname="",
    user="my_user",
    password="my_password",  # noqa: S106
    port=8123,

)
dumper = NativeDumper(connector)
