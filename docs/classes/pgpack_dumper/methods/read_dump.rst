read_dump
=========

.. py:method:: PGPackDumper.read_dump(
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

   Чтение данных из PostgreSQL/GreenPlum и создание дампа в PGPack формате.

**Описание:**

Метод выполняет выборку данных из PostgreSQL/GreenPlum и записывает их в файл в PGPack формате.
PGPack формат - это специализированный бинарный формат, оптимизированный для быстрой передачи данных между PostgreSQL/GreenPlum и внешними системами.

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
     - SQL-запрос для выборки данных. Если указан, параметр ``table_name`` игнорируется. Пример: ``"SELECT * FROM users WHERE active = true"``
   * - ``table_name``
     - ``str | None``
     - Имя таблицы для полной выборки данных. Используется только если ``query`` не указан. Формат: ``"schema.table"`` или ``"table"``

**Возвращаемое значение:**

* ``True`` - дамп успешно создан и записан в файл

**Исключения:**

* ``PGPackDumperReadError`` - ошибка при чтении данных или создании дампа

**Примеры использования:**

.. code-block:: python

    # Пример 1: Создание дампа с помощью SQL-запроса
    from pgpack_dumper import PGPackDumper, PGConnector
    
    connector = PGConnector(host="localhost", port=5432, dbname="mydb")
    dumper = PGPackDumper(connector=connector)
    
    # Создание дампа с фильтрацией данных
    with open("users_dump.pgpack", "wb") as f:
        query = "SELECT id, name, email FROM users WHERE created_at > '2024-01-01'"
        dumper.read_dump(
            fileobj=f,
            query=query
        )
    
    # Пример 2: Создание дампа всей таблицы
    with open("products_dump.pgpack", "wb") as f:
        dumper.read_dump(
            fileobj=f,
            table_name="public.products"  # Полная выборка из таблицы products
        )
    
    # Пример 3: Выгрузка с использованием схемы
    with open("sales_dump.pgpack", "wb") as f:
        dumper.read_dump(
            fileobj=f,
            table_name="sales.monthly"  # Таблица monthly в схеме sales
        )

**Особенности работы:**

1. **Формат данных:** Данные записываются в PGPack формате, который включает:
   * Заголовок с метаданными таблицы (типы данных, размеры колонок)
   * Блоки данных со сжатием (если указано в настройках PGPackDumper)
   * Информацию о PostgreSQL типах данных

2. **Производительность:** Метод использует COPY протокол PostgreSQL для потоковой передачи данных

3. **Сжатие:** Данные сжимаются в соответствии с настройками ``compression_method`` в PGPackDumper

4. **Метаданные:** Автоматически извлекаются и сохраняются метаданные таблицы

5. После успешного выполнения файловый объект закрывается автоматически

**Рекомендации:**

* Для больших таблиц используйте фильтры в запросах для разбиения на части
* Убедитесь, что файл открыт в бинарном режиме записи (``"wb"``)
* Для инкрементальных дампов используйте временные метки в WHERE-условиях
* Проверяйте доступ к таблицам и соответствующие права пользователя

**Обработка ошибок:**

.. code-block:: python

    try:
        with open("dump.pgpack", "wb") as f:
            success = dumper.read_dump(f, table_name="my_schema.my_table")
    except PGPackDumperReadError as e:
        print(f"Ошибка чтения: {e}")
        raise e

**Примечания:**

* PGPack формат специфичен для PostgreSQL/GreenPlum
* Поддерживаются все стандартные типы данных PostgreSQL
* Метод автоматически определяет и адаптируется к версии СУБД (PostgreSQL или GreenPlum)
* Для работы с GreenPlum требуется соответствующий коннектор и права доступа

**См. также:**

- :doc:`write_dump` - Запись дампа в PostgreSQL/GreenPlum
- :class:`CompressionMethod` - Методы сжатия данных
