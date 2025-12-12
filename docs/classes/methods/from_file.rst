from_file
=========

.. py:method:: DBHose.from_file(fileobj: BufferedReader)

   Загрузка данных из файла дампа в целевую СУБД.

**Описание:**

Выполняет полный цикл загрузки данных из файла:

1. Создает временную таблицу (``create_temp``)
2. Загружает данные из файла (``write_dump``)
3. Проверяет качество данных (``dq_check``)
4. Переносит в целевую таблицу (``to_table``)

**Параметры:**

.. py:param:: fileobj
    :type: BufferedReader

    Файловый объект в бинарном режиме чтения, содержащий дамп данных.
    Поддерживаются форматы: Native (ClickHouse) и PGPack (PostgreSQL).

**Пример:**

.. code-block:: python

    # Загрузка из файла
    with open("data_dump.bin", "rb") as f:
        dbhose.from_file(f)

**См. также:**

- :doc:`create_temp` - Создание временной таблицы
- :doc:`dq_check` - Проверка качества данных
- :doc:`to_table` - Перенос в целевую таблицу
