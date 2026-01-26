PGPackDumperReadError
=====================

.. py:exception:: PGPackDumperReadError

   **Родитель:** ``PGPackDumperError``

   Ошибка чтения данных в PGPackDumper.

**Когда возникает:**

- Проблемы при выполнении ``read_dump()``
- Ошибки при создании ``StreamReader``
- Проблемы с метаданными таблицы
- Пустые результаты запроса

**Примеры:**

- ``Empty data returned.``
- Ошибки парсинга SQL запросов
