NativeDumperWriteError
======================

.. py:exception:: NativeDumperWriteError

   **Родитель:** ``NativeDumperError``

   Ошибки записи данных в ClickHouse.

   **Когда возникает:**
   - Проблемы при загрузке данных (``write_dump``)
   - Ошибки преобразования типов данных
   - Сбои при потоковой записи
   - Проблемы со сжатием данных

   **Методы, которые могут вызвать:**
   - ``write_dump()``
   - ``from_rows()``
   - ``from_pandas()``
   - ``from_polars()``
   - ``write_between()`` (при записи в назначение)
