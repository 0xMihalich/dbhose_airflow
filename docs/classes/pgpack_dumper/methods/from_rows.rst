from_rows
=========

.. py:method:: PGPackDumper.from_rows(
    dtype_data,
    table_name,
    source=None,
   )

   :param dtype_data: Итерируемый объект с данными для записи
   :type dtype_data: Iterable[Any]
   :param table_name: Имя таблицы в PostgreSQL/GreenPlum для записи данных
   :type table_name: str
   :param source: Метаданные источника данных
   :type source: DBMetadata | None
   :raises PGPackDumperWriteError: При ошибках записи данных

   Запись данных из Python итерируемого объекта в таблицу PostgreSQL/GreenPlum через COPY протокол.

**Описание:**

Метод выполняет загрузку данных из Python итерируемых объектов (списков, генераторов, итераторов)
непосредственно в таблицу PostgreSQL/GreenPlum с использованием COPY протокола для максимальной
производительности.

Метод особенно полезен для:

* Загрузки данных из Python структур в базу данных
* Интеграции с другими Python библиотеками и фреймворками
* Постепенной загрузки данных из генераторов и потоков
* Миграции данных из памяти Python в PostgreSQL/GreenPlum

**Основные этапы работы:**

1. **Инициализация буфера** - установка имени целевой таблицы в copy_buffer
2. **Получение метаданных таблицы** - структура колонок через ``metadata_reader()``
3. **Создание PGCopyWriter** - для преобразования Python данных в формат COPY
4. **Логирование диаграммы передачи** - отображение информации о source и destination
5. **Загрузка через COPY протокол** - ``copy_buffer.copy_from()``
6. **Фиксация транзакции** - ``self.connect.commit()``
7. **Обновление сессии** - ``self.refresh()``

**Параметры:**

.. list-table:: Параметры метода from_rows
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``dtype_data``
     - ``Iterable[Any]``
     - **Обязательный.** Итерируемый объект с данными для загрузки. Поддерживаются списки, кортежи, генераторы, итераторы.
   * - ``table_name``
     - ``str``
     - **Обязательный.** Имя таблицы в PostgreSQL/GreenPlum. Формат: ``"schema.table_name"`` или ``"table_name"``.
   * - ``source``
     - ``DBMetadata | None``
     - Метаданные источника данных. Если ``None``, используется метаданные Python ("iterable object"). По умолчанию: ``None``.

**Форматы входных данных**:

1. **Список кортежей (рекомендуется)**:

.. code-block:: python

    [
        (1, "Alice", 25, 95.5),
        (2, "Bob", 30, 88.0),
        (3, "Charlie", 28, 92.3),
    ]

2. **Генератор кортежей (для больших объемов)**:

.. code-block:: python

    def data_generator():
        for i in range(1000000):
            yield (i, f"user_{i}", i % 100, i * 1.5)

3. **Список списков**:

.. code-block:: python

    [
        [1, "Alice", 25, 95.5],
        [2, "Bob", 30, 88.0],
        [3, "Charlie", 28, 92.3],
    ]

**Примеры использования:**

.. code-block:: python

    # Пример 1: Загрузка списка кортежей
    from pgpack_dumper import PGPackDumper, PGConnector
    
    connector = PGConnector(host="localhost", port=5432, dbname="mydb")
    dumper = PGPackDumper(connector)
    
    data = [
        (1, "alice", 95.5),
        (2, "bob", 88.0),
        (3, "charlie", 92.3)
    ]
    
    dumper.from_rows(
        dtype_data=data,
        table_name="analytics.user_scores"
    )

.. code-block:: python

    # Пример 2: Загрузка с кастомными метаданными источника
    from pgpack_dumper import DBMetadata
    
    source_meta = DBMetadata(
        name="external_system",
        version="1.0.0",
        columns={"id": "integer", "name": "text", "score": "float"}
    )
    
    dumper.from_rows(
        dtype_data=data,
        table_name="imported.scores",
        source=source_meta
    )

.. code-block:: python

    # Пример 3: Загрузка из генератора (большие данные)
    def generate_large_dataset(count):
        import random
        from datetime import datetime, timedelta
        
        start_date = datetime(2024, 1, 1)
        for i in range(count):
            yield (
                i,
                f"sensor_{i % 100}",
                start_date + timedelta(days=i % 365),
                random.uniform(0, 100),
                "ok" if random.random() > 0.01 else "error"
            )
    
    # Загрузка 500 тысяч записей
    dumper.from_rows(
        dtype_data=generate_large_dataset(500_000),
        table_name="iot.sensor_readings"
    )

.. code-block:: python

    # Пример 4: Загрузка данных из CSV с обработкой
    import csv
    
    def csv_data_reader(file_path):
        with open(file_path, 'r', encoding='utf-8') as f:
            reader = csv.reader(f)
            next(reader)  # Пропуск заголовка
            for row in reader:
                # Преобразование типов и обработка
                yield (
                    int(row[0]),
                    row[1],
                    float(row[2]),
                    int(row[3])
                )
    
    dumper.from_rows(
        dtype_data=csv_data_reader("data.csv"),
        table_name="imported.csv_data"
    )

.. code-block:: python

    # Пример 5: Загрузка из батчей с промежуточным логированием
    def batched_data_generator(source_data, batch_size=1000):
        batch = []
        for i, item in enumerate(source_data):
            batch.append(item)
            if len(batch) >= batch_size:
                print(f"Processing batch {i // batch_size}")
                yield from batch
                batch = []
                # Освобождение памяти
                import gc
                gc.collect()
        
        if batch:
            yield from batch
    
    # Обработка больших данных батчами
    processed_data = batched_data_generator(huge_data_generator(), batch_size=5000)
    dumper.from_rows(processed_data, "processed.large_data")

**Логирование диаграммы передачи:**

Метод генерирует информационную диаграмму передачи данных:

.. code-block:: text

    INFO: python [iterable object] → mydb [PostgreSQL 15.0]
    INFO: Connection to host localhost updated.

**Преобразование типов данных:**

Метод использует PGCopyWriter для автоматического преобразования Python типов в PostgreSQL типы:

.. list-table:: Преобразование типов данных
   :widths: 30 30
   :header-rows: 1

   * - Python тип
     - PostgreSQL тип
   * - ``int``
     - ``INTEGER``, ``BIGINT``
   * - ``float``
     - ``REAL``, ``DOUBLE PRECISION``
   * - ``str``
     - ``TEXT``, ``VARCHAR``
   * - ``bool``
     - ``BOOLEAN``
   * - ``datetime.datetime``
     - ``TIMESTAMP``
   * - ``datetime.date``
     - ``DATE``
   * - ``bytes``
     - ``BYTEA``
   * - ``decimal.Decimal``
     - ``NUMERIC``

**Обработка ошибок:**

.. code-block:: python

    # Пример 1: Ошибка несоответствия структуры
    try:
        # Данные имеют больше/меньше колонок чем таблица
        data = [(1, "only_two_columns")]  # А таблица ожидает 3 колонки
        dumper.from_rows(data, "existing.table")
    except PGPackDumperWriteError as e:
        print(f"Ошибка записи: {e}")
        # Возможная причина: "ERROR:  extra data after last expected column"
    
    # Пример 2: Ошибка типа данных
    try:
        # Неправильный тип в данных
        data = [("not_an_int", "text_value")]  # Первая колонка ожидает integer
        dumper.from_rows(data, "typed.table")
    except PGPackDumperWriteError as e:
        print(f"Ошибка типа данных: {e}")

.. code-block:: python

    # Пример 3: Ошибка доступа к таблице
    try:
        data = [(1, "test")]
        dumper.from_rows(data, "restricted.table")
    except PGPackDumperWriteError as e:
        print(f"Ошибка доступа: {e}")
        # Возможная причина: недостаточно прав на запись в таблицу

**Производительность и оптимизация:**

1. **Используйте генераторы** для больших объемов данных для экономии памяти
2. **Оптимальный размер батчей** - передача по 1000-10000 записей за раз
3. **Прямое использование COPY** - максимальная производительность по сравнению с INSERT
4. **Сборка мусора** - автоматический вызов ``collect()`` для освобождения памяти

**Внутренняя архитектура:**

.. code-block:: text

    Python данные → PGCopyWriter.from_rows() → COPY формат → 
    copy_buffer.copy_from() → PostgreSQL/GreenPlum → commit() → refresh()

**Примечания:**

* Таблица должна существовать в базе данных перед загрузкой
* Порядок данных в кортежах должен строго соответствовать порядку колонок в таблице
* Для NULL значений используйте ``None`` в Python
* Метод работает в рамках транзакции, которая автоматически фиксируется после успешной загрузки

**Расширенные сценарии:**

.. code-block:: python

    # Пример 1: Загрузка с динамической трансформацией данных
    class DataTransformer:
        def __init__(self, raw_data, transform_rules):
            self.raw_data = raw_data
            self.rules = transform_rules
        
        def __iter__(self):
            for row in self.raw_data:
                transformed = []
                for i, value in enumerate(row):
                    if i in self.rules:
                        transformed.append(self.rules[i](value))
                    else:
                        transformed.append(value)
                yield tuple(transformed)
    
    # Правила трансформации для определенных колонок
    rules = {
        2: lambda x: x.upper() if isinstance(x, str) else x,
        3: lambda x: round(x, 2) if isinstance(x, float) else x,
    }
    
    transformer = DataTransformer(raw_data, rules)
    dumper.from_rows(transformer, "transformed.data")

.. code-block:: python

    # Пример 2: Параллельная загрузка в разные таблицы
    from concurrent.futures import ThreadPoolExecutor
    
    def load_to_table(table_name, chunk_data):
        # Создаем новый dumper для каждого потока
        local_dumper = PGPackDumper(connector)
        try:
            local_dumper.from_rows(chunk_data, table_name)
        finally:
            local_dumper.close()
    
    # Разделение данных и параллельная загрузка
    tables_data = {
        "table_a": data_for_a,
        "table_b": data_for_b,
        "table_c": data_for_c,
    }
    
    with ThreadPoolExecutor(max_workers=3) as executor:
        futures = []
        for table_name, data in tables_data.items():
            future = executor.submit(load_to_table, table_name, data)
            futures.append(future)
        
        # Ожидание завершения всех загрузок
        for future in futures:
            future.result()

**См. также:**

- :doc:`from_pandas` - Загрузка данных из pandas DataFrame
- :doc:`from_polars` - Загрузка данных из polars DataFrame
- :class:`PGCopyWriter` - Класс для преобразования данных в COPY формат
- :class:`DBMetadata` - Метаданные источников данных
- :doc:`metadata_reader` - Извлечение метаданных таблицы
- :doc:`make_columns` - Создание описания колонок
