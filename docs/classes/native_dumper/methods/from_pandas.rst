from_pandas
===========

.. py:method:: NativeDumper.from_pandas(data_frame, table_name)

   :param data_frame: DataFrame pandas для загрузки в ClickHouse
   :type data_frame: pandas.DataFrame
   :param table_name: Имя таблицы в ClickHouse для записи данных
   :type table_name: str
   :raises NativeDumperValueError: Если не указано имя таблицы
   :raises ClickhouseServerError: Ошибка сервера ClickHouse при загрузке
   :raises NativeDumperWriteError: Ошибки записи данных
   :raises ImportError: Если pandas не установлен

   Загрузка данных из pandas DataFrame в таблицу ClickHouse.

**Описание:**

Метод выполняет загрузку данных из pandas DataFrame непосредственно в таблицу ClickHouse.
Внутренне использует метод ``from_rows()``, преобразуя DataFrame в итерируемый объект
с сохранением информации о типах данных колонок.

**Преимущества метода:**

* **Автоматическое определение типов** - типы pandas сохраняются в метаданных
* **Оптимизированная передача** - эффективное преобразование внутренних структур pandas
* **Поддержка всех типов pandas** - включая категориальные, временные и числовые типы
* **Прозрачное логирование** - включая информацию об источнике данных (pandas)

**Параметры:**

.. list-table:: Параметры метода from_pandas
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``data_frame``
     - ``pandas.DataFrame``
     - **Обязательный.** DataFrame pandas, содержащий данные для загрузки.
   * - ``table_name``
     - ``str``
     - **Обязательный.** Имя таблицы в ClickHouse. Формат: ``"database.table_name"``.

**Примеры использования:**

.. code-block:: python

    # Пример 1: Базовая загрузка DataFrame
    import pandas as pd
    from native_dumper import NativeDumper, CHConnector
    
    # Создание подключения
    connector = CHConnector(host="localhost", port=8123)
    dumper = NativeDumper(connector)
    
    # Создание тестового DataFrame
    df = pd.DataFrame({
        'id': [1, 2, 3, 4, 5],
        'name': ['Alice', 'Bob', 'Charlie', 'David', 'Eve'],
        'age': [25, 30, 35, 28, 32],
        'salary': [50000.0, 60000.5, 75000.0, 55000.0, 65000.0],
        'active': [True, True, False, True, False]
    })
    
    # Загрузка данных
    dumper.from_pandas(
        data_frame=df,
        table_name="analytics.employees"
    )

.. code-block:: python

    # Пример 2: Загрузка DataFrame с временными данными
    import pandas as pd
    import numpy as np
    
    # DataFrame с разными типами данных
    dates = pd.date_range('2024-01-01', periods=100, freq='D')
    df_complex = pd.DataFrame({
        'date': dates,
        'temperature': np.random.normal(20, 5, 100),
        'humidity': np.random.randint(30, 90, 100),
        'location': np.random.choice(['A', 'B', 'C'], 100),
        'is_valid': np.random.choice([True, False], 100)
    })
    
    # Добавление категориального типа
    df_complex['location'] = df_complex['location'].astype('category')
    
    dumper.from_pandas(
        data_frame=df_complex,
        table_name="weather.measurements"
    )

.. code-block:: python

    # Пример 3: Загрузка больших DataFrame
    # Генерация большого DataFrame
    large_df = pd.DataFrame({
        'user_id': range(1_000_000),
        'score': np.random.uniform(0, 100, 1_000_000),
        'timestamp': pd.date_range('2024-01-01', periods=1_000_000, freq='s'),
        'category': np.random.choice(['A', 'B', 'C', 'D'], 1_000_000)
    })
    
    # Загрузка 1 миллиона записей
    dumper.from_pandas(
        data_frame=large_df,
        table_name="analytics.user_metrics"
    )

.. code-block:: python

    # Пример 4: Загрузка из CSV файла через pandas
    import pandas as pd
    
    # Чтение CSV файла
    df_from_csv = pd.read_csv('data.csv')
    
    # Опционально: преобразование типов
    df_from_csv['date_column'] = pd.to_datetime(df_from_csv['date_column'])
    df_from_csv['price'] = pd.to_numeric(df_from_csv['price'])
    
    dumper.from_pandas(
        data_frame=df_from_csv,
        table_name="imported.csv_data"
    )

.. code-block:: python

    # Пример 5: Загрузка с предобработкой данных
    import pandas as pd
    
    # Исходный DataFrame
    raw_df = pd.DataFrame({
        'product': ['A', 'B', 'C', 'A', 'B'],
        'quantity': [10, 20, 15, 5, 25],
        'price': [100.0, 200.0, 150.0, 100.0, 200.0]
    })
    
    # Агрегация данных перед загрузкой
    aggregated_df = raw_df.groupby('product').agg({
        'quantity': 'sum',
        'price': 'mean'
    }).reset_index()
    
    aggregated_df['total_value'] = aggregated_df['quantity'] * aggregated_df['price']
    
    dumper.from_pandas(
        data_frame=aggregated_df,
        table_name="reports.product_summary"
    )

**Логирование:**

Метод генерирует информационные сообщения о загрузке, включая диаграмму передачи
с указанием pandas как источника данных:

.. code-block:: text

    INFO: pandas [DataFrame] → clickhouse [23.8.1.2473]
    INFO: Start write into localhost.analytics.employees.
    INFO: Write into localhost.analytics.employees done.

**Преобразование типов pandas → ClickHouse:**

Метод автоматически преобразует типы данных pandas в соответствующие типы ClickHouse

**Обработка специальных значений:**

* **NaN значения** - преобразуются в NULL ClickHouse
* **None значения** - преобразуются в NULL ClickHouse
* **Inf/-Inf** - требуют специальной обработки в ClickHouse

**Обработка ошибок:**

.. code-block:: python

    # Пример 1: Ошибка валидации параметров
    try:
        dumper.from_pandas(
            data_frame=df,
            table_name=""  # Пустое имя таблицы
        )
    except NativeDumperValueError as e:
        print(f"Ошибка валидации: {e}")

.. code-block:: python

    # Пример 2: Pandas не установлен
    try:
        # Попытка использовать без pandas
        from native_dumper import NativeDumper
        dumper = NativeDumper(connector)
        # Метод вызовет ошибку при использовании
    except ImportError as e:
        print(f"Требуется установка pandas: {e}")

.. code-block:: python

    # Пример 3: Ошибка несоответствия типов
    try:
        # DataFrame с неподдерживаемым типом
        df_problematic = pd.DataFrame({
            'complex_col': [1+2j, 3+4j]  # Комплексные числа
        })
        dumper.from_pandas(df_problematic, "test.table")
    except Exception as e:
        print(f"Ошибка преобразования типов: {e}")

**Оптимизация производительности:**

.. code-block:: python

    # Пример 1: Оптимизация использования памяти
    import pandas as pd
    
    # Оптимизация типов для экономии памяти
    def optimize_dataframe(df):
        # Преобразование к минимально достаточным типам
        for col in df.columns:
            col_type = df[col].dtype
            
            if col_type == 'object':
                # Преобразование строк в категории если уникальных значений мало
                num_unique = df[col].nunique()
                if num_unique < len(df) * 0.5:  # Эвристика
                    df[col] = df[col].astype('category')
            
            elif col_type == 'float64':
                # Проверка возможности использования float32
                if (df[col].max() < 3.4e38 and df[col].min() > -3.4e38):
                    df[col] = df[col].astype('float32')
            
            elif col_type == 'int64':
                # Проверка возможности использования меньшего типа
                if df[col].min() >= 0:
                    if df[col].max() < 255:
                        df[col] = df[col].astype('uint8')
                    elif df[col].max() < 65535:
                        df[col] = df[col].astype('uint16')
                    elif df[col].max() < 4294967295:
                        df[col] = df[col].astype('uint32')
        
        return df
    
    # Использование оптимизированного DataFrame
    df_optimized = optimize_dataframe(df)
    dumper.from_pandas(df_optimized, "optimized.table")

**Сравнение с from_rows():**

Метод ``from_pandas()`` является специализированной версией ``from_rows()``
с следующими преимуществами:

1. **Сохранение метаданных** - автоматически извлекает типы колонок из DataFrame
2. **Оптимизированное преобразование** - использует ``data_frame.values`` для эффективной итерации
3. **Лучшая диагностика** - в логах указывается pandas как источник данных

**Ограничения:**

1. **Размер памяти** - весь DataFrame должен помещаться в памяти
2. **Типы данных** - не все типы pandas поддерживаются напрямую
3. **Производительность** - для очень больших DataFrames лучше использовать инкрементальную загрузку

**Примечания:**

* DataFrame должен иметь названия колонок, соответствующие названиям колонок в ClickHouse
* Для временных типов рекомендуется явное преобразование ``pd.to_datetime()``

**См. также:**

- :doc:`from_rows` - Базовый метод для загрузки итерируемых объектов
- :doc:`from_polars` - Загрузка данных из polars DataFrame
