from_frame
==========

.. py:method:: DBHose.from_frame(data_frame: PDFrame | PLFrame)

   :param data_frame: DataFrame с данными для загрузки
   :type data_frame: pandas.DataFrame | polars.DataFrame
   :raises TypeError: Если переданный объект не является pandas или polars DataFrame

   Загрузка данных из pandas или polars DataFrame в целевую СУБД.

**Описание:**

Выполняет полный цикл загрузки данных из DataFrame:

1. Создает временную таблицу (``create_temp``)
2. Загружает данные из DataFrame (``from_pandas`` или ``from_polars``)
3. Проверяет качество данных (``dq_check``)
4. Переносит в целевую таблицу (``to_table``)

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
