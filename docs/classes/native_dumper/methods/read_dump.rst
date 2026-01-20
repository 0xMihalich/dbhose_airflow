read_dump
=========

.. py:method:: NativeDumper.read_dump(
    fileobj,
    query=None,
    table_name=None,
   )

   :param fileobj: Файловый объект для записи данных
   :type fileobj: BufferedWriter
   :param query: SQL-запрос для выборки данных
   :type query: str | None
   :param table_name: Имя таблицы для выборки данных
   :type table_name: str | None
   :return: ``True`` если дамп успешно создан
   :rtype: bool

   Чтение данных из ClickHouse и создание дампа в Native формате.

**Описание:**

Метод выполняет выборку данных из ClickHouse и записывает их в файл в Native формате.
Native формат - это бинарный формат ClickHouse, оптимизированный для быстрой передачи данных.

Метод предоставляет два способа выборки данных:
1. Через SQL-запрос (параметр ``query``)
2. Через указание имени таблицы (параметр ``table_name``)

SQL-запрос имеет приоритет, поэтому, в случае передачи обоих параметров, метод проигнорирует указанную таблицу.

**Параметры:**

.. list-table:: Параметры метода read_dump
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``fileobj``
     - ``BufferedWriter``
     - **Обязательный.** Файловый объект, открытый в бинарном режиме записи. Данные будут записаны в этот объект.
   * - ``query``
     - ``str | None``
     - SQL-запрос для выборки данных. Если указан, параметр ``table_name`` игнорируется. Пример: ``"SELECT * FROM users WHERE active = 1"``
   * - ``table_name``
     - ``str | None``
     - Имя таблицы для полной выборки данных. Используется только если ``query`` не указан. Формат: ``"database.table"`` или ``"table"``

**Возвращаемое значение:**

* ``True`` - дамп успешно создан и записан в файл

**Исключения:**

* ``ClickhouseServerError`` - ошибка сервера ClickHouse при выполнении запроса
* ``NativeDumperValueError`` - если не указаны ни ``query``, ни ``table_name``
* ``NativeDumperReadError`` - любая другая ошибка

**Примеры использования:**

.. code-block:: python

    # Пример 1: Создание дампа с помощью SQL-запроса
    from your_module import NativeDumper, CHConnector
    import gzip
    
    connector = CHConnector(host="localhost", port=8123)
    dumper = NativeDumper(connector=connector)
    
    # Создание дампа с фильтрацией данных
    with open("users_dump.bin", "wb") as f:
        query = "SELECT id, name, email FROM users WHERE created_at > '2024-01-01'"
        success = dumper.read_dump(
            fileobj=f,
            query=query
        )
        if success:
            print("Данные успешно выгружены")
    
    # Пример 2: Создание дампа всей таблицы
    with open("products_dump.bin", "wb") as f:
        success = dumper.read_dump(
            fileobj=f,
            table_name="shop.products"  # Полная выборка из таблицы products
        )
    
    # Пример 3: Создание сжатого дампа
    with gzip.open("compressed_dump.bin.gz", "wb") as f:
        success = dumper.read_dump(
            fileobj=f,
            table_name="logs.application_logs"
        )
    
    # Пример 4: Инкрементальная выгрузка
    with open("incremental_dump.bin", "ab") as f:  # Режим добавления
        query = """
            SELECT * FROM events 
            WHERE event_date = today() 
            AND processed = 0
        """
        success = dumper.read_dump(f, query=query)

**Особенности работы:**

1. **Формат данных:** Данные записываются в ClickHouse Native формате, который включает:
   * Заголовок с метаданными
   * Блоки данных со сжатием (если указано в настройках NativeDumper)
   * Информацию о типах данных колонок

2. **Производительность:** Метод использует потоковую передачу данных для работы с большими объемами

3. **Сжатие:** Данные сжимаются в соответствии с настройками ``compression_method`` в NativeDumper

4. После успешного выполнения файловый объект закрывается автоматически

**Рекомендации:**

* Для таблиц с миллионами строк используйте фильтры в запросах
* Для инкрементальных дампов используйте параметры в WHERE-условиях
* Проверяйте возвращаемое значение метода для обработки ошибок

**Обработка ошибок:**

.. code-block:: python

    try:
        with open("dump.bin", "wb") as f:
            success = dumper.read_dump(f, table_name="my_table")
            
            if not success:
                print("Не удалось создать дамп")
                # Проверить логи dumper.logger
    except Exception as e:
        print(f"Ошибка: {e}")
        raise e

**Примечания:**

* Native формат специфичен для ClickHouse и не совместим с другими СУБД
* Размер дампа зависит от объема данных и степени сжатия
* Метод автоматически обрабатывает разные типы данных ClickHouse
* Для экспорта в другие форматы используйте дополнительные методы конвертации

**См. также:**

- :class:`CompressionMethod` - Методы сжатия данных
