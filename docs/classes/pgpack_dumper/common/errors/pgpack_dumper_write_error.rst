PGPackDumperWriteError
======================

.. py:exception:: PGPackDumperWriteError

   **Родитель:**

   ``PGPackDumperError``

   Ошибка записи данных в PGPackDumper.

**Когда возникает:**

- Проблемы при выполнении ``write_dump()``
- Ошибки при операциях ``from_rows()``, ``from_pandas()``, ``from_polars()``
- Несоответствие структуры данных таблице
- Ошибки ограничений таблицы (constraints)

**Примеры:**

- Несоответствие типов данных
- Нарушение ограничений NOT NULL, UNIQUE
