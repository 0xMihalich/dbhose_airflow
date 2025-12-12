from_frame
==========

.. py:method:: DBHose.from_frame(data_frame: PDFrame | PLFrame)

   Загрузка данных из pandas или polars DataFrame в целевую СУБД.

**Описание:**

Выполняет полный цикл загрузки данных из DataFrame:

1. Создает временную таблицу (``create_temp``)
2. Загружает данные из DataFrame (``from_pandas`` или ``from_polars``)
3. Проверяет качество данных (``dq_check``)
4. Переносит в целевую таблицу (``to_table``)

**Параметры:**

.. py:param:: data_frame
    :type: PDFrame | PLFrame

    DataFrame с данными для загрузки. Поддерживаются два типа:

    * **pandas.DataFrame** - pandas DataFrame
    * **polars.DataFrame** - polars DataFrame

    При передаче объекта другого типа возникает исключение ``TypeError``.

**Исключения:**

.. py:exception:: TypeError

    Возникает, если переданный объект не является pandas или polars DataFrame.

**Примеры:**

.. code-block:: python

    # Загрузка из pandas DataFrame
    import pandas as pd
    
    df_pandas = pd.DataFrame({
        'id': [1, 2, 3],
        'name': ['Alice', 'Bob', 'Charlie']
    })
    dbhose.from_frame(df_pandas)

    # Загрузка из polars DataFrame
    import polars as pl

    df_polars = pl.DataFrame({
        'id': [1, 2, 3],
        'name': ['Alice', 'Bob', 'Charlie']
    })
    dbhose.from_frame(df_polars)

**См. также:**

- :doc:`create_temp` - Создание временной таблицы
- :doc:`dq_check` - Проверка качества данных
- :doc:`to_table` - Перенос в целевую таблицу
