StreamReader
============

.. py:class:: StreamReader(metadata, copyobj)

   Класс для потокового чтения из PostgreSQL/GreenPlum.

   :param metadata: Метаданные таблицы в байтах
   :type metadata: bytes
   :param copyobj: Итерируемый Copy объект для чтения данных
   :type copyobj: Iterable[Copy]

**Описание:**

Класс для потокового чтения данных из PostgreSQL/GreenPlum через 
Copy протокол. Наследуется от ``PGPackReader``.

**Атрибуты экземпляра:**

.. py:attribute:: metadata
   :type: bytes

   Метаданные таблицы.

.. py:attribute:: columns
   :type: list[str]

   Имена колонок таблицы.

.. py:attribute:: pgtypes
   :type: list

   Типы данных PostgreSQL колонок.

.. py:attribute:: pgcopy
   :type: PGCopyReader

   Ридер для работы с PGCopy форматом.

**Методы:**

.. py:method:: to_bytes() -> NoReturn

   Не реализовано в потоковом режиме.

   :raises NotImplementedError: Всегда вызывает исключение

.. py:method:: close() -> None

   Закрывает потоковый объект и освобождает ресурсы.
