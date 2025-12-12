from_dbms
=========

.. py:method:: DBHose.from_dbms(
    query: Optional[str] = None,
    table: Optional[str] = None,
)

   Полный цикл загрузки данных из СУБД-источника в целевую СУБД.

**Описание:**

Выполняет автоматический ETL процесс:

1. Создает временную таблицу (``create_temp``)
2. Загружает данные из источника (``write_between``)
3. Проверяет качество данных (``dq_check``)
4. Переносит в целевую таблицу (``to_table``)

**Параметры:**

.. py:param:: query
    :type: Optional[str]

    SQL запрос для выборки данных из источника. Если не указан,
    загружается вся таблица.

.. py:param:: table
    :type: Optional[str]

    Имя таблицы-источника. Обязателен, если не указан ``query``.

**Пример:**

.. code-block:: python

    # Загрузка всей таблицы из источника
    dbhose.from_dbms(table="public.source_table")

    # Или с фильтрацией
    dbhose.from_dbms(
        query="SELECT * FROM events WHERE date >= '2024-01-01'"
    )

**См. также:**

- :doc:`create_temp` - Создание временной таблицы
- :doc:`dq_check` - Проверка качества данных
- :doc:`to_table` - Перенос в целевую таблицу
