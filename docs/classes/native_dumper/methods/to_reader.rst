to_reader
=========

.. py:method:: NativeDumper.to_reader(
    query=None,
    table_name=None,
   )

   :param query: SQL-запрос для выборки данных
   :type query: str | None
   :param table_name: Имя таблицы для полной выборки данных
   :type table_name: str | None
   :return: Объект NativeReader для потокового чтения данных
   :rtype: NativeReader
   :raises NativeDumperValueError: Если не указаны ни запрос, ни имя таблицы
   :raises ClickhouseServerError: Ошибка сервера при выполнении запроса

   Создание потока для чтения данных из ClickHouse в виде объекта NativeReader.

**Описание:**

Метод создает объект ``NativeReader``, который предоставляет потоковый доступ
к данным из ClickHouse в Native формате. Это позволяет обрабатывать большие
объемы данных без загрузки всего результата в память.

``NativeReader`` реализует интерфейс для чтения и конвертации данных из Native формата.

**Ключевые особенности:**

* **Потоковое чтение** - данные читаются по мере необходимости
* **Минимальное потребление памяти** - не загружает весь результат в память
* **Поддержка сжатия** - при получении сжатых данных распаковка происходит в потоке
* **Совместимость** - объект NativeDumper поддерживает конвертацию в привычные форматы (список Python | pandas.DataFrame | polars.DataFrame)

**Параметры:**

.. list-table:: Параметры метода to_reader
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``query``
     - ``str | None``
     - SQL-запрос для выборки данных. SQL-запрос имеет приоритет, поэтому, в случае передачи обоих параметров, метод проигнорирует указанную таблицу.
       Пример: ``"SELECT * FROM table WHERE condition"``
   * - ``table_name``
     - ``str | None``
     - Имя таблицы для полной выборки всех данных. Используется только если ``query`` не указан. Формат: ``"database.table"``

**Возвращаемое значение:**

Объект ``NativeReader``

**Примеры использования:**

.. code-block:: python

    # Пример 1: Потоковое чтение всей таблицы
    from native_dumper import NativeDumper, CHConnector
    
    connector = CHConnector(host="localhost", port=8123)
    dumper = NativeDumper(connector=connector)
    
    reader = dumper.to_reader(table_name="analytics.user_logs")
    
    # Пример 2: Чтение данных по запросу
    query = """
        SELECT user_id, action, timestamp 
        FROM events 
        WHERE date = today() 
        ORDER BY timestamp
    """
    
    reader = dumper.to_reader(query=query)

**Обработка ошибок:**

.. code-block:: python

    # Пример 1: Проверка параметров
    try:
        # Ошибка: не указаны ни запрос, ни таблица
        reader = dumper.to_reader()
    except ValueError as e:
        print(f"Ошибка параметров: {e}")
    
    # Пример 2: Ошибка запроса
    try:
        reader = dumper.to_reader(query="SELECT * FROM nonexistent_table")
        # Ошибка произойдет при попытке чтения
        data = reader.read_info()
    except ClickhouseServerError as e:
        print(f"Ошибка ClickHouse: {e}")

**Сценарии использования:**

1. **Потоковая обработка больших данных** - когда результат не помещается в память
2. **Проксирование данных** - передача из ClickHouse в другую систему
3. **Инкрементальная загрузка** - обработка данных по частям

**Производительность и память:**

* **Потоковая обработка** - данные передаются по мере чтения
* **Буферизация** - внутренний буфер оптимизирует сетевые запросы
* **Сжатие** - данные сжимаются для уменьшения объема передачи
* **Память** - использует фиксированный размер буфера, не зависит от размера данных

**Примечания:**

* Объект ``NativeReader`` является одноразовым - после закрытия нельзя читать снова, при потоковом чтении нельзя прочитать данные снова
* Доступна конвертация в список Python | pandas.DataFrame | polars.DataFrame

**См. также:**

- :doc:`NativeReader` - Документация по классу NativeReader
