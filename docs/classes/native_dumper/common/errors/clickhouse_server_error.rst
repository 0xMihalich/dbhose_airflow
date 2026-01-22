ClickhouseServerError
=====================

.. py:exception:: ClickhouseServerError

   **Родитель:** ``ValueError``

   Ошибки, возвращаемые сервером ClickHouse.

   **Когда возникает:**

   - Некорректный SQL запрос
   - Ошибки доступа к таблицам
   - Проблемы с типами данных
   - Ограничения сервера (память, время выполнения)

   **Примеры:**

   - ``Table does not exist``
   - ``Syntax error in SQL query``
   - ``Memory limit exceeded``
