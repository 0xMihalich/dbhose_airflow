NativeDumperReadError
=====================

.. py:exception:: NativeDumperReadError

   **Родитель:**

   ``NativeDumperError``

   Ошибки чтения данных из ClickHouse.

**Когда возникает:**

- Проблемы при выгрузке данных (``read_dump``)
- Ошибки получения метаданных таблиц
- Сбои при потоковом чтении
- Повреждение данных в Native формате

**Методы, которые могут вызвать:**

- ``read_dump()``
- ``to_reader()``
- ``write_between()`` (при чтении из источника)
