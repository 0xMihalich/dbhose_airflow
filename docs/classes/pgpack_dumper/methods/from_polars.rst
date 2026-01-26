from_polars
===========

.. py:method:: PGPackDumper.from_polars(data_frame, table_name)

   :param data_frame: DataFrame polars для загрузки в PostgreSQL/GreenPlum
   :type data_frame: polars.DataFrame
   :param table_name: Имя таблицы в PostgreSQL/GreenPlum для записи данных
   :type table_name: str
   :raises PGPackDumperWriteError: Ошибки записи данных
   :raises ImportError: Если polars не установлен

   Загрузка данных из polars DataFrame в таблицу PostgreSQL/GreenPlum.

**Описание:**

Метод выполняет загрузку данных из polars DataFrame непосредственно в таблицу PostgreSQL/GreenPlum.
Внутренне использует метод ``from_rows()``, преобразуя DataFrame в итерируемый объект
с использованием ``iter_rows()`` и сохранением информации о типах данных колонок и их названиях.

**Преимущества polars:**

* **Высокая производительность** - polars оптимизирован для работы с большими данными
* **Потоковая обработка** - эффективная работа с данными, не помещающимися в память
* **Строгая типизация** - богатая система типов с поддержкой сложных структур данных
* **Ленивые вычисления** - возможность оптимизации запросов перед выполнением
* **Многопоточность** - автоматическое распараллеливание операций

**Параметры:**

.. list-table:: Параметры метода from_polars
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``data_frame``
     - ``polars.DataFrame``
     - **Обязательный.** DataFrame polars, содержащий данные для загрузки. Должен содержать названия колонок.
   * - ``table_name``
     - ``str``
     - **Обязательный.** Имя таблицы в PostgreSQL/GreenPlum. Формат: ``"schema.table_name"`` или ``"table_name"``.

**Примеры использования:**

.. code-block:: python

    # Пример 1: Базовая загрузка DataFrame
    import polars as pl
    from pgpack_dumper import PGPackDumper, PGConnector
    
    # Создание подключения
    connector = PGConnector(host="localhost", port=5432, dbname="mydb")
    dumper = PGPackDumper(connector)
    
    # Создание тестового DataFrame
    df = pl.DataFrame({
        'id': [1, 2, 3, 4, 5],
        'name': ['Alice', 'Bob', 'Charlie', 'David', 'Eve'],
        'age': [25, 30, 35, 28, 32],
        'salary': [50000.0, 60000.5, 75000.0, 55000.0, 65000.0],
        'is_active': [True, True, False, True, False],
        'created_at': pl.datetime_range(
            start=pl.datetime(2024, 1, 1),
            end=pl.datetime(2024, 1, 5),
            interval='1d',
            eager=True
        )
    })
    
    # Загрузка данных
    dumper.from_polars(
        data_frame=df,
        table_name="public.employees"
    )

.. code-block:: python

    # Пример 2: Загрузка LazyFrame с оптимизацией запросов
    import polars as pl
    
    # Создание LazyFrame с ленивыми вычислениями
    lazy_df = (
        pl.scan_csv('large_data.csv')
        .filter(pl.col('amount') > 100)
        .group_by('category')
        .agg([
            pl.mean('amount').alias('avg_amount'),
            pl.sum('amount').alias('total_amount'),
            pl.count().alias('transaction_count')
        ])
        .sort('total_amount', descending=True)
    )
    
    # Выполнение ленивого запроса и загрузка результата
    result_df = lazy_df.collect()
    
    dumper.from_polars(
        data_frame=result_df,
        table_name="analytics.category_summary"
    )

.. code-block:: python

    # Пример 3: Загрузка данных с различными типами polars
    import polars as pl
    
    df_complex_types = pl.DataFrame({
        'transaction_id': range(1, 1001),
        'timestamp': pl.datetime_range(
            start=pl.datetime(2024, 1, 1),
            end=pl.datetime(2024, 1, 2),
            interval='90s',
            eager=True
        )[:1000],
        'amount': (pl.Series(range(1000)) * 1.5).cast(pl.Float32),
        'currency': pl.Series(['USD'] * 400 + ['EUR'] * 350 + ['GBP'] * 250),
        'status': pl.Series(['completed'] * 850 + ['pending'] * 100 + ['failed'] * 50),
        'customer_segment': pl.Series(['A', 'B', 'C'] * 334, dtype=pl.Categorical)[:1000]
    })
    
    dumper.from_polars(
        data_frame=df_complex_types,
        table_name="finance.transactions"
    )

.. code-block:: python

    # Пример 4: Загрузка с использованием streaming API для больших данных
    import polars as pl
    
    # Использование streaming API для обработки данных, не помещающихся в память
    large_lazy = (
        pl.scan_parquet('huge_dataset/*.parquet')
        .filter(pl.col('year') == 2024)
        .select(['id', 'metric1', 'metric2', 'category'])
    )
    
    # Сборка с использованием streaming (обработка частями)
    streamed_result = large_lazy.collect(streaming=True)
    
    dumper.from_polars(
        data_frame=streamed_result,
        table_name="analytics.huge_dataset_2024"
    )

.. code-block:: python

    # Пример 5: Загрузка агрегированных данных со сложными вычислениями
    import polars as pl
    
    # Исходные данные
    raw_df = pl.DataFrame({
        'order_id': range(1, 10001),
        'customer_id': pl.Series(range(1, 10001)) % 100,  # 100 уникальных клиентов
        'order_date': pl.datetime_range(
            start=pl.datetime(2024, 1, 1),
            end=pl.datetime(2024, 1, 11),
            interval='90s',
            eager=True
        )[:10000],
        'amount': (pl.Series(range(10000)) * 0.5 + 10).cast(pl.Float32),
        'product_category': pl.Series(['Electronics', 'Clothing', 'Books', 'Food'] * 2500)
    })
    
    # Агрегация с использованием выражений polars
    aggregated_df = raw_df.group_by('customer_id', 'product_category').agg([
        pl.count().alias('order_count'),
        pl.sum('amount').alias('total_spent'),
        pl.mean('amount').alias('avg_order_value'),
        pl.min('order_date').alias('first_order'),
        pl.max('order_date').alias('last_order')
    ]).sort(['customer_id', 'total_spent'], descending=[False, True])
    
    dumper.from_polars(
        data_frame=aggregated_df,
        table_name="reports.customer_purchases"
    )

**Логирование:**

Метод генерирует информационные сообщения о загрузке, включая диаграмму передачи
с указанием polars как источника данных и типами колонок:

.. code-block:: text

    INFO: polars [DataFrame] → mydb [PostgreSQL 15.0]
    INFO: Connection to host localhost updated.

**Метаданные источника:**

Метод автоматически создает метаданные из DataFrame:
* **name**: "polars"
* **version**: "DataFrame" 
* **columns**: OrderedDict с названиями колонок и их типами polars

**Преобразование типов polars → PostgreSQL:**

Метод использует встроенное преобразование типов через PGCopyWriter:

.. list-table:: Преобразование типов данных
   :widths: 30 30
   :header-rows: 1

   * - Polars тип
     - PostgreSQL тип (пример)
   * - ``Int64``, ``Int32``, ``Int16``, ``Int8``
     - ``BIGINT``, ``INTEGER``, ``SMALLINT``
   * - ``UInt64``, ``UInt32``, ``UInt16``, ``UInt8``
     - ``BIGINT``, ``INTEGER``, ``SMALLINT``
   * - ``Float64``, ``Float32``
     - ``DOUBLE PRECISION``, ``REAL``
   * - ``String``, ``Utf8``
     - ``TEXT``, ``VARCHAR``
   * - ``Boolean``
     - ``BOOLEAN``
   * - ``Date``
     - ``DATE``
   * - ``Datetime``
     - ``TIMESTAMP``
   * - ``Categorical``
     - ``TEXT`` (преобразуется в строку)
   * - ``List``
     - ``ARRAY`` (поддерживается для простых типов)
   * - ``Struct``
     - ``JSONB`` (может требовать преобразования)

**Обработка специальных значений:**

* **null значения** - преобразуются в ``NULL`` PostgreSQL
* **NaN/Inf** - могут требовать специальной обработки в зависимости от типа
* **Пустые массивы/списки** - сохраняются как пустые массивы PostgreSQL
* **Категориальные значения** - преобразуются в строки при передаче

**Обработка ошибок:**

.. code-block:: python

    # Пример 1: Ошибка при отсутствии polars
    try:
        from pgpack_dumper import PGPackDumper
        dumper = PGPackDumper(connector)
        # Вызов метода без установленного polars вызовет ImportError
    except ImportError as e:
        print(f"Требуется установка polars: pip install polars")

.. code-block:: python

    # Пример 2: Ошибка несоответствия структуры данных
    try:
        # DataFrame с колонками, которых нет в целевой таблице
        df_mismatch = pl.DataFrame({
            'existing_column': [1, 2, 3],
            'extra_column': ['a', 'b', 'c']  # Отсутствует в таблице
        })
        dumper.from_polars(df_mismatch, "existing.table")
    except PGPackDumperWriteError as e:
        print(f"Ошибка структуры данных: {e}")
        # Возможная причина: "ERROR: column "extra_column" does not exist"

.. code-block:: python

    # Пример 3: Ошибка преобразования сложных типов
    try:
        # DataFrame с неподдерживаемым сложным типом
        df_complex = pl.DataFrame({
            'nested_data': pl.Series([
                {'a': 1, 'b': 2},
                {'a': 3, 'b': 4}
            ])
        })
        dumper.from_polars(df_complex, "test.table")
    except Exception as e:
        print(f"Ошибка преобразования типов: {e}")

**Оптимизация производительности с polars:**

.. code-block:: python

    # Пример 1: Оптимизация типов данных для экономии памяти
    import polars as pl
    
    def optimize_polars_dataframe(df):
        """Оптимизация типов данных в DataFrame polars."""
        
        # Копируем DataFrame для изменений
        optimized_df = df.clone()
        
        # Оптимизация числовых колонок
        for col in optimized_df.columns:
            dtype = optimized_df[col].dtype
            
            # Для целочисленных типов
            if dtype in [pl.Int64, pl.Int32]:
                min_val = optimized_df[col].min()
                max_val = optimized_df[col].max()
                
                if min_val >= 0:
                    if max_val < 256:
                        optimized_df = optimized_df.with_columns(
                            pl.col(col).cast(pl.UInt8)
                        )
                    elif max_val < 65536:
                        optimized_df = optimized_df.with_columns(
                            pl.col(col).cast(pl.UInt16)
                        )
                    elif max_val < 4294967296:
                        optimized_df = optimized_df.with_columns(
                            pl.col(col).cast(pl.UInt32)
                        )
            
            # Для строковых колонок с малым количеством уникальных значений
            elif dtype == pl.Utf8:
                unique_count = optimized_df[col].n_unique()
                total_count = len(optimized_df)
                if unique_count / total_count < 0.3:  # 30% уникальных значений
                    optimized_df = optimized_df.with_columns(
                        pl.col(col).cast(pl.Categorical)
                    )
        
        return optimized_df
    
    # Использование оптимизированного DataFrame
    df_large = pl.DataFrame({
        'id': range(500_000),
        'score': pl.Series(range(500_000)) % 1000,
        'category': pl.Series(['A', 'B', 'C', 'D'] * 125_000)
    })
    
    df_optimized = optimize_polars_dataframe(df_large)
    print(f"Размер до оптимизации: {df_large.estimated_size('mb'):.1f} MB")
    print(f"Размер после оптимизации: {df_optimized.estimated_size('mb'):.1f} MB")
    
    dumper.from_polars(df_optimized, "optimized.large_data")

**Использование iter_rows():**

Метод использует ``data_frame.iter_rows()`` для эффективной итерации по строкам:

.. code-block:: python

    # Эквивалент того, что происходит внутри метода
    for row in data_frame.iter_rows():
        # Каждая строка как tuple значений
        # Автоматическое преобразование типов через PGCopyWriter
        # row = (1, 'Alice', 25, 50000.0, True, datetime(...))
        process_row(row)

**Особенности работы polars.iter_rows():**

1. **Эффективная итерация** - минимальные накладные расходы
2. **Преобразование типов** - автоматическое преобразование polars типов в Python типы
3. **Обработка null** - null значения преобразуются в None
4. **Потоковая обработка** - низкое потребление памяти

**Рекомендации для больших DataFrames:**

1. **Используйте LazyFrame** для оптимизации запросов перед выполнением
2. **Применяйте streaming=True** для данных, не помещающихся в память
3. **Оптимизируйте типы данных** - выбирайте минимально достаточные типы
4. **Разбивайте на части** при загрузке огромных объемов данных
5. **Используйте индексы** в целевых таблицах PostgreSQL для быстрой вставки

**Сравнение с pandas:**

.. list-table:: Сравнение polars и pandas
   :widths: 30 35 35
   :header-rows: 1

   * - Аспект
     - Polars
     - Pandas
   * - Производительность
     - Выше (написано на Rust, многопоточность)
     - Хорошая (написано на Cython)
   * - Использование памяти
     - Более эффективное
     - Менее эффективное
   * - API стиль
     - Функциональный/экспрессивный
     - Императивный/объектный
   * - Потоковая обработка
     - Встроенная поддержка (streaming=True)
     - Требует ручной реализации
   * - Система типов
     - Богатая, строгая
     - Более простая, динамическая
   * - Ленивые вычисления
     - Поддерживается через LazyFrame
     - Ограниченная поддержка

**Ограничения:**

1. **Сложные вложенные структуры** - Struct и сложные List могут требовать преобразования
2. **Десериализация** - некоторые специализированные типы polars не имеют прямых аналогов в PostgreSQL
3. **Потребление памяти** - весь DataFrame должен помещаться в памяти для метода iter_rows()

**Примечания:**

* Для временных данных рекомендуется использовать типы ``pl.Date`` и ``pl.Datetime``
* Категориальные типы автоматически преобразуются в строки при использовании iter_rows()
* При использовании streaming API убедитесь, что данные могут обрабатываться последовательно
* Метод использует транзакцию, которая автоматически фиксируется после успешной загрузки

**См. также:**

- :doc:`from_rows` - Базовый метод для загрузки итерируемых объектов
- :doc:`from_pandas` - Загрузка данных из pandas DataFrame
