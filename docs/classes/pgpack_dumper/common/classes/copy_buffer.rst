CopyBuffer
==========

.. py:class:: CopyBuffer(cursor, logger, query=None, table_name=None)

   Буфер для операций COPY в PostgreSQL/GreenPlum.

   :param cursor: Курсор базы данных
   :type cursor: Cursor
   :param logger: Логгер для записи событий
   :type logger: Logger
   :param query: SQL-запрос для выборки данных
   :type query: str | None
   :param table_name: Имя таблицы для операций
   :type table_name: str | None

**Атрибуты экземпляра:**

.. py:attribute:: is_readonly
   :type: bool

   Запущена ли текущая сессия в режиме только чтение. По умолчанию False.

**Описание:**

Класс для управления операциями COPY (чтение/запись) между PostgreSQL/GreenPlum 
и внешними источниками данных.

**Свойства:**

.. py:method:: metadata -> bytes

   Возвращает метаданные таблицы в байтах.

**Методы:**

.. py:method:: copy_to() -> Iterator[Copy]

   Создает объект Copy для чтения данных из базы.

   :raises CopyBufferTableNotDefined: Если не указаны query и table_name
   :raises CopyBufferObjectError: Если объект недоступен для чтения

.. py:method:: copy_from(copyobj: Iterator[bytes]) -> None

   Записывает данные в таблицу через COPY.

   :param copyobj: Итератор с данными для записи
   :raises CopyBufferTableNotDefined: Если не указана таблица

.. py:method:: copy_between(copy_buffer: CopyBuffer) -> None

   Копирует данные между двумя источниками PostgreSQL.

   :param copy_buffer: Исходный буфер с данными

.. py:method:: copy_reader() -> Generator[bytes, None, None]

   Генератор для чтения данных из Copy объекта.
