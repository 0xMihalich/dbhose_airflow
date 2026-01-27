CopyBufferObjectError
=====================

.. py:exception:: CopyBufferObjectError

   **Родитель:**

   ``TypeError``

   Объект назначения не поддерживается для операций чтения/записи.

**Когда возникает:**

- Попытка чтения из индекса, последовательности или TOAST-таблицы
- Обращение к системным объектам PostgreSQL
- Неподдерживаемый тип relkind объекта

**Примеры:**

- ``Read from Index not support.``
- ``Read from Sequence not support.``
