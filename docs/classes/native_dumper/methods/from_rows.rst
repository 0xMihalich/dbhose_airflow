from_rows
=========

.. py:method:: NativeDumper.from_rows(
    dtype_data,
    table_name,
    source=None,
   )

   :param dtype_data: Итерируемый объект с данными для записи
   :type dtype_data: Iterable[Any]
   :param table_name: Имя таблицы в ClickHouse для записи данных
   :type table_name: str
   :param source: Метаданные источника данных
   :type source: DBMetadata | None
   :raises NativeDumperValueError: Если не указано имя таблицы
   :raises ClickhouseServerError: Ошибка сервера ClickHouse при загрузке
   :raises NativeDumperWriteError: Другие ошибки записи данных
   :raises TypeError: Если данные имеют неправильный формат

   Запись данных из Python итерируемого объекта в таблицу ClickHouse.

**Описание:**

Метод выполняет загрузку данных из Python итерируемых объектов (списков, генераторов, итераторов)
непосредственно в таблицу ClickHouse с автоматическим преобразованием типов и валидацией.

Метод особенно полезен для:
* Загрузки данных из Python структур в ClickHouse
* Интеграции с другими Python библиотеками
* Постепенной загрузки данных из генераторов
* Миграции данных из памяти Python в ClickHouse

**Основные этапы работы:**

1. **Валидация параметров** - проверка имени таблицы
2. **Получение метаданных таблицы** - структура колонок через ``cursor.metadata()``
3. **Создание NativeWriter** - для преобразования Python данных в Native формат
4. **Преобразование данных** - ``writer.from_rows()`` + сжатие
5. **Логирование диаграммы передачи** - ``transfer_diagram()``
6. **Загрузка в ClickHouse** - ``cursor.upload_data()``
7. **Обновление сессии** - ``refresh()``

**Параметры:**

.. list-table:: Параметры метода from_rows
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``dtype_data``
     - ``Iterable[Any]``
     - **Обязательный.** Итерируемый объект с данными для загрузки. Поддерживаются списки, кортежи, генераторы.
   * - ``table_name``
     - ``str``
     - **Обязательный.** Имя таблицы в ClickHouse. Формат: ``"database.table_name"`` или ``"table_name"``.
   * - ``source``
     - ``DBMetadata | None``
     - Метаданные источника данных. Если ``None``, используется метаданные Python. По умолчанию: ``None``.

**Форматы входных данных:**

Поддерживаются следующие форматы:

1. **Список словарей** (рекомендуется):
   ```python
    [
        {"id": 1, "name": "Alice", "age": 25},
        {"id": 2, "name": "Bob", "age": 30},
    ]
   ```

2. **Список кортежей**:

   ```python
    [
        (1, "Alice", 25),
        (2, "Bob", 30),
    ]
   ```

3. **Генератор (для больших объемов)**:

   ```python
    def data_generator():
        for i in range(1000000):
            yield {"id": i, "value": i * 2}
   ```

**Примеры использования:**

.. code-block:: python

    # Пример 1: Загрузка списка словарей
    from native_dumper import NativeDumper, CHConnector
    
    connector = CHConnector(host="localhost", port=8123)
    dumper = NativeDumper(connector)
    
    data = [
        {"user_id": 1, "username": "alice", "score": 95.5},
        {"user_id": 2, "username": "bob", "score": 88.0},
        {"user_id": 3, "username": "charlie", "score": 92.3}
    ]
    
    dumper.from_rows(
        dtype_data=data,
        table_name="analytics.user_scores"
    )

.. code-block:: python

    # Пример 2: Загрузка с кастомными метаданными источника
    from native_dumper import DBMetadata
    
    source_meta = DBMetadata(
        name="postgresql",
        version="15.0",
        columns={"id": "integer", "name": "text", "created_at": "timestamp"}
    )
    
    dumper.from_rows(
        dtype_data=data,
        table_name="migrated.users",
        source=source_meta
    )

.. code-block:: python

    # Пример 3: Загрузка из генератора (большие данные)
    def generate_large_dataset(count):
        for i in range(count):
            yield {
                "timestamp": f"2024-01-{i%30+1:02d} 10:00:00",
                "sensor_id": i % 100,
                "value": i * 0.5,
                "status": "ok" if i % 1000 != 0 else "error"
            }
    
    # Загрузка 1 миллиона записей
    dumper.from_rows(
        dtype_data=generate_large_dataset(1_000_000),
        table_name="iot.sensor_readings"
    )

.. code-block:: python

    # Пример 4: Загрузка из CSV файла
    import csv
    
    with open("data.csv", "r") as f:
        reader = csv.DictReader(f)
        dumper.from_rows(
            dtype_data=reader,
            table_name="imported.csv_data"
        )

.. code-block:: python

    # Пример 5: Загрузка списка кортежей
    # Важно: порядок кортежей должен соответствовать порядку колонок в таблице
    tuple_data = [
        (1, "Product A", 19.99, 100),
        (2, "Product B", 29.99, 50),
        (3, "Product C", 9.99, 200)
    ]
    
    dumper.from_rows(
        dtype_data=tuple_data,
        table_name="warehouse.products"
    )

**Логирование диаграммы передачи:**

Метод генерирует информационную диаграмму передачи данных:

.. code-block:: text

    INFO: python [iterable object] → clickhouse [23.8.1.2473]
    INFO: Start write into localhost.analytics.user_scores.
    INFO: Write into localhost.analytics.user_scores done.

**Преобразование типов данных:**

Метод автоматически преобразует Python типы в типы ClickHouse:

.. list-table:: Преобразование типов данных
   :widths: 30 30
   :header-rows: 1

   * - Python тип
     - ClickHouse тип
   * - ``int``
     - ``Int32`` / ``Int64``
   * - ``float``
     - ``Float64``
   * - ``str``
     - ``String``
   * - ``bool``
     - ``UInt8``
   * - ``datetime.datetime``
     - ``DateTime``
   * - ``datetime.date``
     - ``Date``
   * - ``list``
     - ``Array``
   * - ``dict``
     - ``Map``

**Обработка ошибок:**

.. code-block:: python

    # Пример 1: Ошибка валидации параметров
    try:
        dumper.from_rows(
            dtype_data=[{"id": 1}],
            table_name=""  # Пустое имя таблицы
        )
    except NativeDumperValueError as e:
        print(f"Ошибка валидации: {e}")
        # NativeDumperValueError: Table name not defined.

.. code-block:: python

    # Пример 2: Ошибка типа данных
    try:
        # Неправильный формат данных
        dumper.from_rows(
            dtype_data="not an iterable",  # Ошибка
            table_name="test.table"
        )
    except TypeError as e:
        print(f"Ошибка типа данных: {e}")

.. code-block:: python

    # Пример 3: Ошибка несоответствия структуры
    try:
        # Данные не соответствуют структуре таблицы
        data = [{"wrong_column": 1}]  # Колонка не существует
        dumper.from_rows(data, "existing.table")
    except ClickhouseServerError as e:
        print(f"Ошибка ClickHouse: {e.message}")

**Производительность и оптимизация:**

1. **Используйте генераторы** для больших объемов данных
2. **Минимизируйте преобразования** - передавайте данные в правильном формате
3. **Пакетная обработка** - для лучшей производительности используйте пакеты по 1000-10000 записей
4. **Память** - метод использует потоковую обработку, не загружая все данные в память

**Внутренняя архитектура:**

.. code-block:: text

    Python данные → NativeWriter.from_rows() → Native формат → 
    define_writer() → Сжатие → cursor.upload_data() → ClickHouse

**Примечания:**

* Таблица должна существовать в ClickHouse перед загрузкой
* Порядок колонок в кортежах должен соответствовать порядку в таблице
* Для словарей порядок ключей не важен
* Метод автоматически обновляет сессию после загрузки (``refresh()``)

**Расширенные сценарии:**

.. code-block:: python

    # Пример 1: Загрузка с кастомной обработкой
    class DataProcessor:
        def __init__(self, source_data):
            self.source_data = source_data
        
        def __iter__(self):
            for item in self.source_data:
                # Кастомная трансформация
                yield {
                    "id": item["id"],
                    "processed_value": item["value"] * 2,
                    "timestamp": datetime.now().isoformat()
                }
    
    processor = DataProcessor(raw_data)
    dumper.from_rows(processor, "processed.data")

.. code-block:: python

    # Пример 2: Параллельная загрузка
    from concurrent.futures import ThreadPoolExecutor
    
    def load_chunk(chunk_data, table_suffix):
        dumper_local = NativeDumper(connector)  # Новый экземпляр
        dumper_local.from_rows(chunk_data, f"data.chunk_{table_suffix}")
        dumper_local.close()
    
    # Разделение данных на чанки
    chunks = [data[i:i+10000] for i in range(0, len(data), 10000)]
    
    with ThreadPoolExecutor(max_workers=4) as executor:
        futures = []
        for i, chunk in enumerate(chunks):
            future = executor.submit(load_chunk, chunk, i)
            futures.append(future)
        
        # Ожидание завершения
        for future in futures:
            future.result()

**См. также:**

- :doc:`from_pandas` - Загрузка данных из pandas DataFrame
- :doc:`from_polars` - Загрузка данных из polars DataFrame
- :doc:`nativewriter` - Класс для преобразования Python данных в Native формат
- :doc:`dbmetadata` - Метаданные источников данных
