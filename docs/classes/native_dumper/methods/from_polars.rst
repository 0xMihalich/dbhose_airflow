from_polars
===========

.. py:method:: NativeDumper.from_polars(data_frame, table_name)

   :param data_frame: DataFrame polars для загрузки в ClickHouse
   :type data_frame: polars.DataFrame
   :param table_name: Имя таблицы в ClickHouse для записи данных
   :type table_name: str
   :raises NativeDumperValueError: Если не указано имя таблицы
   :raises ClickhouseServerError: Ошибка сервера ClickHouse при загрузке
   :raises NativeDumperWriteError: Ошибки записи данных
   :raises ImportError: Если polars не установлен

   Загрузка данных из polars DataFrame в таблицу ClickHouse.

**Описание:**

Метод выполняет загрузку данных из polars DataFrame непосредственно в таблицу ClickHouse.
Внутренне использует метод ``from_rows()``, преобразуя DataFrame в итерируемый объект
с использованием ``iter_rows()`` и сохранением информации о типах данных колонок.

**Преимущества polars:**

* **Высокая производительность** - polars оптимизирован для работы с большими данными
* **Потоковая обработка** - эффективная работа с данными, не помещающимися в память
* **Богатая система типов** - строгая типизация и поддержка сложных типов данных
* **Ленивые вычисления** - возможность оптимизации запросов перед выполнением

**Параметры:**

.. list-table:: Параметры метода from_polars
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``data_frame``
     - ``polars.DataFrame``
     - **Обязательный.** DataFrame polars, содержащий данные для загрузки.
   * - ``table_name``
     - ``str``
     - **Обязательный.** Имя таблицы в ClickHouse. Формат: ``"database.table_name"``.

**Примеры использования:**

.. code-block:: python

    # Пример 1: Базовая загрузка DataFrame
    import polars as pl
    from native_dumper import NativeDumper, CHConnector
    
    # Создание подключения
    connector = CHConnector(host="localhost", port=8123)
    dumper = NativeDumper(connector)
    
    # Создание тестового DataFrame
    df = pl.DataFrame({
        'id': [1, 2, 3, 4, 5],
        'name': ['Alice', 'Bob', 'Charlie', 'David', 'Eve'],
        'age': [25, 30, 35, 28, 32],
        'salary': [50000.0, 60000.5, 75000.0, 55000.0, 65000.0],
        'active': [True, True, False, True, False]
    })
    
    # Загрузка данных
    dumper.from_polars(
        data_frame=df,
        table_name="analytics.employees"
    )

.. code-block:: python

    # Пример 2: Загрузка LazyFrame с оптимизацией
    import polars as pl
    
    # Создание LazyFrame (ленивого вычисления)
    lazy_df = (
        pl.scan_csv('large_data.csv')
        .filter(pl.col('value') > 100)
        .group_by('category')
        .agg([
            pl.mean('value').alias('avg_value'),
            pl.count().alias('count')
        ])
    )
    
    # Выполнение ленивого запроса и загрузка результата
    result_df = lazy_df.collect()
    
    dumper.from_polars(
        data_frame=result_df,
        table_name="analytics.aggregated_data"
    )

.. code-block:: python

    # Пример 3: Загрузка данных с временными типами
    import polars as pl
    
    df_temporal = pl.DataFrame({
        'event_id': range(1, 1001),
        'event_time': pl.datetime_range(
            start=pl.datetime(2024, 1, 1),
            end=pl.datetime(2024, 1, 10),
            interval='15m',
            eager=True
        )[:1000],
        'metric_value': pl.Series(range(1000)).cast(pl.Float64) * 1.5,
        'status': pl.Series(['ok'] * 800 + ['warning'] * 150 + ['error'] * 50)
    })
    
    dumper.from_polars(
        data_frame=df_temporal,
        table_name="monitoring.events"
    )

.. code-block:: python

    # Пример 4: Загрузка с использованием сложных типов polars
    import polars as pl
    
    df_complex = pl.DataFrame({
        'id': [1, 2, 3],
        'tags': [['python', 'data'], ['rust', 'systems'], ['go', 'backend']],
        'metadata': [
            {'version': '1.0', 'enabled': True},
            {'version': '2.0', 'enabled': False},
            {'version': '1.5', 'enabled': True}
        ],
        'scores': [
            [85.5, 90.0, 78.5],
            [92.0, 88.5, 95.0],
            [76.0, 82.5, 79.0]
        ]
    })
    
    dumper.from_polars(
        data_frame=df_complex,
        table_name="analytics.complex_data"
    )

.. code-block:: python

    # Пример 5: Загрузка больших данных с потоковой обработкой
    import polars as pl
    
    # Генерация большого DataFrame с потоковой обработкой
    large_df = (
        pl.LazyFrame({
            'id': range(1_000_000),
            'value': pl.arange(0, 1_000_000, eager=False) * 0.01,
            'group': pl.Series(range(1_000_000)) % 100
        })
        .filter(pl.col('value') < 5000)
        .group_by('group')
        .agg([
            pl.mean('value').alias('avg_value'),
            pl.std('value').alias('std_value'),
            pl.count().alias('count')
        ])
        .collect(streaming=True)  # Использование streaming API
    )
    
    dumper.from_polars(
        data_frame=large_df,
        table_name="analytics.streaming_results"
    )

**Логирование:**

Метод генерирует информационные сообщения о загрузке, включая диаграмму передачи
с указанием polars как источника данных:

.. code-block:: text

    INFO: polars [DataFrame] → clickhouse [23.8.1.2473]
    INFO: Start write into localhost.analytics.employees.
    INFO: Write into localhost.analytics.employees done.

**Преобразование типов polars → ClickHouse:**

Метод автоматически преобразует типы данных polars в соответствующие типы ClickHouse

**Обработка специальных значений:**

* **null значения** - преобразуются в NULL ClickHouse
* **NaN/Inf** - требуют специальной обработки в зависимости от типа
* **пустые списки/структуры** - сохраняются как значения по умолчанию

**Обработка ошибок:**

.. code-block:: python

    # Пример 1: Ошибка валидации параметров
    try:
        dumper.from_polars(
            data_frame=df,
            table_name=""  # Пустое имя таблицы
        )
    except NativeDumperValueError as e:
        print(f"Ошибка валидации: {e}")

.. code-block:: python

    # Пример 2: Polars не установлен
    try:
        # Попытка использовать без polars
        from native_dumper import NativeDumper
        dumper = NativeDumper(connector)
        # Метод вызовет ошибку при использовании
    except ImportError as e:
        print(f"Требуется установка polars: {e}")

.. code-block:: python

    # Пример 3: Ошибка несоответствия типов
    try:
        # DataFrame с неподдерживаемым типом
        df_problematic = pl.DataFrame({
            'binary_col': [b'data1', b'data2']  # Бинарные данные
        })
        dumper.from_polars(df_problematic, "test.table")
    except Exception as e:
        print(f"Ошибка преобразования типов: {e}")

**Оптимизация производительности с polars:**

.. code-block:: python

    # Пример 1: Использование правильных типов данных
    import polars as pl
    
    df_optimized = pl.DataFrame({
        'id': pl.Series(range(1000000), dtype=pl.UInt32),  # Экономия памяти
        'name': pl.Series(['user'] * 1000000),
        'score': pl.Series(range(1000000), dtype=pl.Float32),  # Float32 вместо Float64
        'category': pl.Series(['A', 'B', 'C'] * 333334, dtype=pl.Categorical),  # Категории
        'timestamp': pl.datetime_range(
            start=pl.datetime(2024, 1, 1),
            end=pl.datetime(2024, 1, 12),
            interval='1s',
            eager=True
        )[:1000000]
    })
    
    dumper.from_polars(df_optimized, "optimized.table")

.. code-block:: python

    # Пример 2: Пакетная обработка очень больших данных
    import polars as pl
    
    def load_large_data_in_batches(dumper, lazy_frame, table_name, batch_size=100000):
        """Загрузка больших данных пакетами."""
        
        total_rows = lazy_frame.select(pl.count()).collect().item()
        batches = total_rows // batch_size + (1 if total_rows % batch_size > 0 else 0)
        
        for batch_num in range(batches):
            offset = batch_num * batch_size
            
            batch_df = (
                lazy_frame
                .slice(offset, batch_size)
                .collect()
            )
            
            if len(batch_df) > 0:
                dumper.from_polars(
                    data_frame=batch_df,
                    table_name=table_name
                )
            
            print(f"Загружен пакет {batch_num + 1}/{batches} "
                  f"({len(batch_df)} строк)")
        
        print(f"Всего загружено {total_rows} строк")
    
    # Использование
    large_lazy = pl.scan_parquet('huge_data.parquet')
    load_large_data_in_batches(dumper, large_lazy, "huge.table", batch_size=50000)

**Сравнение с pandas:**

1. **Производительность:**
   * polars обычно быстрее pandas, особенно на больших данных
   * polars использует многопоточность по умолчанию
   * polars эффективнее работает с памятью

2. **Потоковая обработка:**
   * polars имеет встроенную поддержку streaming API
   * pandas требует ручной реализации чанкирования

3. **API:**
   * polars API более функциональный и экспрессивный
   * pandas API более императивный и знакомый

**Использование iter_rows():**

Метод использует ``data_frame.iter_rows()`` для эффективной итерации по строкам:

.. code-block:: python

    # Эквивалент того, что происходит внутри метода
    for row in data_frame.iter_rows():
        # Каждая строка как tuple значений
        # Автоматическое преобразование типов
        process_row(row)

**Рекомендации по использованию:**

1. **Оптимизируйте типы данных** - выбирайте минимально достаточные типы
2. **Используйте streaming=True** для очень больших данных
3. **Обрабатывайте null значения** - убедитесь в корректности преобразования
4. **Проверяйте совместимость типов** - сложные типы могут требовать дополнительной обработки

**Ограничения:**

1. **Сложные вложенные типы** - требуют дополнительного преобразования
2. **Десериализация** - некоторые типы polars не имеют прямых аналогов в ClickHouse
3. **Производительность iter_rows()** - для некоторых сценариев могут быть более эффективные подходы

**Примечания:**

* Для лучшей производительности используйте ``LazyFrame`` совместно с ``collect(streaming=True)`` для больших данных
* Типы данных сохраняются в метаданных, что помогает в отладке
* Рекомендуется использовать ленивые вычисления для предобработки данных

**См. также:**

- :doc:`from_rows` - Базовый метод для загрузки итерируемых объектов
- :doc:`from_pandas` - Загрузка данных из pandas DataFrame
