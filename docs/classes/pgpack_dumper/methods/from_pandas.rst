from_pandas
===========

.. py:method:: PGPackDumper.from_pandas(data_frame, table_name)

   :param data_frame: DataFrame pandas для загрузки в PostgreSQL/GreenPlum
   :type data_frame: pandas.DataFrame
   :param table_name: Имя таблицы в PostgreSQL/GreenPlum для записи данных
   :type table_name: str
   :raises PGPackDumperWriteError: Ошибки записи данных
   :raises ImportError: Если pandas не установлен

   Загрузка данных из pandas DataFrame в таблицу PostgreSQL/GreenPlum.

**Описание:**

Метод выполняет загрузку данных из pandas DataFrame непосредственно в таблицу PostgreSQL/GreenPlum.
Внутренне использует метод ``from_rows()``, преобразуя DataFrame в итерируемый объект
с сохранением информации о типах данных колонок и их названиях.

**Преимущества метода:**

* **Автоматическое извлечение типов** - типы pandas сохраняются в метаданных
* **Сохранение названий колонок** - названия колонок DataFrame передаются в метаданные
* **Эффективное преобразование** - используется ``data_frame.values`` для оптимальной итерации
* **Поддержка всех типов pandas** - включая временные, категориальные и числовые типы
* **Прозрачное логирование** - включая информацию об источнике данных (pandas DataFrame)

**Параметры:**

.. list-table:: Параметры метода from_pandas
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``data_frame``
     - ``pandas.DataFrame``
     - **Обязательный.** DataFrame pandas, содержащий данные для загрузки. Должен содержать названия колонок.
   * - ``table_name``
     - ``str``
     - **Обязательный.** Имя таблицы в PostgreSQL/GreenPlum. Формат: ``"schema.table_name"`` или ``"table_name"``.

**Примеры использования:**

.. code-block:: python

    # Пример 1: Базовая загрузка DataFrame
    import pandas as pd
    from pgpack_dumper import PGPackDumper, PGConnector
    
    # Создание подключения
    connector = PGConnector(host="localhost", port=5432, dbname="mydb")
    dumper = PGPackDumper(connector)
    
    # Создание тестового DataFrame
    df = pd.DataFrame({
        'id': [1, 2, 3, 4, 5],
        'name': ['Alice', 'Bob', 'Charlie', 'David', 'Eve'],
        'age': [25, 30, 35, 28, 32],
        'salary': [50000.0, 60000.5, 75000.0, 55000.0, 65000.0],
        'is_active': [True, True, False, True, False],
        'created_at': pd.date_range('2024-01-01', periods=5, freq='D')
    })
    
    # Загрузка данных
    dumper.from_pandas(
        data_frame=df,
        table_name="public.employees"
    )

.. code-block:: python

    # Пример 2: Загрузка DataFrame с разными типами данных
    import pandas as pd
    import numpy as np
    
    # DataFrame с комплексными типами
    df_complex = pd.DataFrame({
        'timestamp': pd.date_range('2024-01-01', periods=100, freq='H'),
        'value_float': np.random.randn(100),
        'value_int': np.random.randint(1, 1000, 100),
        'category': pd.Categorical(np.random.choice(['A', 'B', 'C'], 100)),
        'description': [f'Item_{i}' for i in range(100)],
        'flag': np.random.choice([True, False], 100)
    })
    
    dumper.from_pandas(
        data_frame=df_complex,
        table_name="analytics.measurements"
    )

.. code-block:: python

    # Пример 3: Загрузка больших DataFrame
    # Генерация большого DataFrame (100k записей)
    large_df = pd.DataFrame({
        'transaction_id': range(100_000),
        'customer_id': np.random.randint(1, 10000, 100_000),
        'amount': np.random.uniform(10, 1000, 100_000).round(2),
        'currency': np.random.choice(['USD', 'EUR', 'GBP'], 100_000),
        'transaction_date': pd.date_range('2024-01-01', periods=100_000, freq='T'),
        'status': np.random.choice(['completed', 'pending', 'failed'], 100_000)
    })
    
    # Загрузка 100 тысяч записей
    dumper.from_pandas(
        data_frame=large_df,
        table_name="finance.transactions"
    )

.. code-block:: python

    # Пример 4: Загрузка из CSV файла через pandas
    import pandas as pd
    
    # Чтение CSV файла с явным указанием типов
    df_from_csv = pd.read_csv(
        'data.csv',
        parse_dates=['date_column'],
        dtype={'category_column': 'category'}
    )
    
    # Опционально: очистка данных
    df_from_csv = df_from_csv.dropna(subset=['important_column'])
    df_from_csv['price'] = pd.to_numeric(df_from_csv['price'], errors='coerce')
    
    dumper.from_pandas(
        data_frame=df_from_csv,
        table_name="imported.csv_data"
    )

.. code-block:: python

    # Пример 5: Загрузка агрегированных данных
    import pandas as pd
    
    # Исходные данные транзакций
    transactions_df = pd.DataFrame({
        'customer_id': np.random.randint(1, 100, 1000),
        'amount': np.random.uniform(10, 500, 1000),
        'date': pd.date_range('2024-01-01', periods=1000, freq='H')
    })
    
    # Агрегация данных перед загрузкой
    aggregated_df = transactions_df.groupby('customer_id').agg({
        'amount': ['sum', 'mean', 'count'],
        'date': 'max'
    }).reset_index()
    
    # Выравнивание мультииндекса колонок
    aggregated_df.columns = [
        'customer_id', 
        'total_amount', 
        'avg_amount', 
        'transaction_count', 
        'last_transaction_date'
    ]
    
    dumper.from_pandas(
        data_frame=aggregated_df,
        table_name="reports.customer_summary"
    )

**Логирование:**

Метод генерирует информационные сообщения о загрузке, включая диаграмму передачи
с указанием pandas как источника данных и типами колонок:

.. code-block:: text

    INFO: pandas [DataFrame] → mydb [PostgreSQL 15.0]
    INFO: Connection to host localhost updated.

**Метаданные источника:**

Метод автоматически создает метаданные из DataFrame:

* **name**: "pandas"
* **version**: "DataFrame" 
* **columns**: OrderedDict с названиями колонок и их типами pandas

**Преобразование типов pandas → PostgreSQL:**

Метод использует встроенное преобразование типов через PGCopyWriter:

.. list-table:: Преобразование типов данных
   :widths: 30 30
   :header-rows: 1

   * - Pandas тип
     - PostgreSQL тип (пример)
   * - ``int64``, ``int32``, ``int16``, ``int8``
     - ``INTEGER``, ``BIGINT``, ``SMALLINT``
   * - ``float64``, ``float32``
     - ``DOUBLE PRECISION``, ``REAL``
   * - ``object`` (строка)
     - ``TEXT``, ``VARCHAR``
   * - ``bool``
     - ``BOOLEAN``
   * - ``datetime64[ns]``
     - ``TIMESTAMP``
   * - ``category``
     - ``TEXT`` (преобразуется в строку)
   * - ``timedelta[ns]``
     - ``INTERVAL``

**Обработка специальных значений:**

* **NaN/NaT значения** - преобразуются в ``NULL`` PostgreSQL
* **None значения** - преобразуются в ``NULL`` PostgreSQL
* **Пустые строки** - сохраняются как пустые строки
* **Inf/-Inf** - могут требовать специальной обработки

**Обработка ошибок:**

.. code-block:: python

    # Пример 1: Ошибка при отсутствии pandas
    try:
        from pgpack_dumper import PGPackDumper
        dumper = PGPackDumper(connector)
        # Вызов метода без установленного pandas вызовет ImportError
    except ImportError as e:
        print(f"Требуется установка pandas: pip install pandas")

.. code-block:: python

    # Пример 2: Ошибка несоответствия структуры
    try:
        # DataFrame с колонками, которых нет в таблице
        df_extra = pd.DataFrame({
            'existing_col': [1, 2, 3],
            'extra_col': ['a', 'b', 'c']  # Этой колонки нет в таблице
        })
        dumper.from_pandas(df_extra, "existing.table")
    except PGPackDumperWriteError as e:
        print(f"Ошибка структуры данных: {e}")
        # Возможная причина: "ERROR:  column "extra_col" of relation "table" does not exist"

.. code-block:: python

    # Пример 3: Ошибка типов данных
    try:
        # DataFrame с неподдерживаемым типом
        df_problematic = pd.DataFrame({
            'complex_data': [{'key': 'value'}, {'key': 'value2'}]  # Словари
        })
        dumper.from_pandas(df_problematic, "test.table")
    except Exception as e:
        print(f"Ошибка преобразования типов: {e}")

**Оптимизация производительности:**

.. code-block:: python

    # Пример 1: Оптимизация использования памяти для больших DataFrame
    import pandas as pd
    import numpy as np
    
    def optimize_pandas_dataframe(df):
        """Оптимизация типов DataFrame для экономии памяти."""
        optimized_df = df.copy()
        
        for col in optimized_df.columns:
            col_type = optimized_df[col].dtype
            
            # Оптимизация числовых колонок
            if col_type in ['int64', 'int32']:
                c_min = optimized_df[col].min()
                c_max = optimized_df[col].max()
                
                if c_min >= 0:
                    if c_max < 255:
                        optimized_df[col] = optimized_df[col].astype(np.uint8)
                    elif c_max < 65535:
                        optimized_df[col] = optimized_df[col].astype(np.uint16)
                    elif c_max < 4294967295:
                        optimized_df[col] = optimized_df[col].astype(np.uint32)
                else:
                    if c_min > -128 and c_max < 127:
                        optimized_df[col] = optimized_df[col].astype(np.int8)
                    elif c_min > -32768 and c_max < 32767:
                        optimized_df[col] = optimized_df[col].astype(np.int16)
            
            # Оптимизация вещественных чисел
            elif col_type == 'float64':
                # Проверка возможности использования float32
                if (optimized_df[col].max() < 3.4e38 and 
                    optimized_df[col].min() > -3.4e38):
                    optimized_df[col] = optimized_df[col].astype(np.float32)
            
            # Оптимизация строковых колонок
            elif col_type == 'object':
                num_unique = optimized_df[col].nunique()
                num_total = len(optimized_df[col])
                # Преобразование в категории если уникальных значений мало
                if num_unique / num_total < 0.5:
                    optimized_df[col] = optimized_df[col].astype('category')
        
        return optimized_df
    
    # Использование оптимизированного DataFrame
    df_large = pd.DataFrame({
        'id': range(1_000_000),
        'score': np.random.randint(0, 100, 1_000_000),
        'category': np.random.choice(['A', 'B', 'C', 'D', 'E'], 1_000_000)
    })
    
    df_optimized = optimize_pandas_dataframe(df_large)
    print(f"Экономия памяти: {df_large.memory_usage().sum() / 1e6:.1f}MB -> "
          f"{df_optimized.memory_usage().sum() / 1e6:.1f}MB")
    
    dumper.from_pandas(df_optimized, "optimized.large_data")

**Особенности работы:**

1. **Порядок колонок** - сохраняется порядок колонок DataFrame
2. **Названия колонок** - должны соответствовать названиям в целевой таблице
3. **Типы данных** - автоматическое преобразование через PGCopyWriter
4. **NULL значения** - ``pd.NA``, ``np.nan``, ``None`` преобразуются в NULL
5. **Производительность** - используется итератор ``data_frame.values`` для эффективной передачи

**Ограничения:**

1. **Размер памяти** - весь DataFrame должен помещаться в памяти
2. **Типы данных** - некоторые экзотические типы pandas могут не поддерживаться
3. **Индексы DataFrame** - индексы pandas игнорируются, загружаются только данные колонок

**Рекомендации для больших DataFrames:**

1. Используйте оптимизацию типов данных
2. Разбивайте большие DataFrame на части (чанки)
3. Используйте ``from_rows()`` с генераторами для потоковой обработки
4. Убедитесь, что в таблице есть соответствующие индексы для быстрой вставки

**Примечания:**

* Для временных меток рекомендуется использовать ``pd.Timestamp`` или ``datetime`` объекты
* Категориальные типы преобразуются в строки при передаче
* Метод использует транзакцию, которая автоматически фиксируется после успешной загрузки

**См. также:**

- :doc:`from_rows` - Базовый метод для загрузки итерируемых объектов
- :doc:`from_polars` - Загрузка данных из polars DataFrame
