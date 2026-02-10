read_metadata
=============

.. py:function:: read_metadata(cursor, query=None, table_name=None)

   :param cursor: Курсор базы данных
   :type cursor: Cursor
   :param query: SQL-запрос для получения метаданных
   :type query: str | None
   :param table_name: Имя таблицы для получения метаданных
   :type table_name: str | None
   :param is_readonly: Запущена ли текущая сессия в режиме только чтение. По умолчанию False
   :type is_readonly: bool
   :return: Метаданные в бинарном формате
   :rtype: bytes
   :raises ValueError: Если не указаны ни query, ни table_name

**Описание:**

Читает метаданные таблицы (структуру колонок и типы данных) для запроса 
или таблицы PostgreSQL/GreenPlum.

**Особенности:**

- Для запросов с ``LIMIT`` создает временную таблицу
- Использует подготовленные запросы для сложных SQL
- Автоматически очищает временные объекты после выполнения
