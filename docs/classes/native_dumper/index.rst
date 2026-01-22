NativeDumper
============

.. py:class:: NativeDumper(
   connector,
   compression_method=CompressionMethod.ZSTD,
   logger=None,
   timeout=DBMS_DEFAULT_TIMEOUT_SEC,
   )

   Класс для чтения и записи данных в Native формате ClickHouse.

   :param connector: Коннектор для подключения к ClickHouse
   :type connector: CHConnector
   :param compression_method: Метод сжатия данных
   :type compression_method: CompressionMethod
   :param logger: Логгер для записи событий
   :type logger: Logger | None
   :param timeout: Таймаут операций в секундах
   :type timeout: int
   :raises ValueError: Если используется порт 9000
   :raises ClickhouseServerError: При ошибках сервера ClickHouse
   :raises NativeDumperError: При других ошибках инициализации

**Описание:**

Внешний модуль ``native-dumper`` входит в состав ``dbhose-airflow``, но может быть установлен отдельно.

Установка модуля native-dumper без установки dbhose-airflow
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ./install_module.sh
   :language: bash

.. toctree::
   :caption: Линки на проект:

   GitHub <https://github.com/0xMihalich/native_dumper>
   PyPI <https://pypi.org/project/native-dumper/>

Часть кода написана на языке ``Rust``, что обеспечивает более быструю работу по сравнению с языком ``Python``.

Назначение класса NativeDumper - обмен данными с сервером Clickhouse по http/https протоколу.

Импорт модуля
^^^^^^^^^^^^^

.. literalinclude:: ./import_module.py
   :language: python

``NativeDumper`` предоставляет функциональность для работы с Native форматом ClickHouse - 
бинарным протоколом, оптимизированным для эффективной передачи данных между клиентом и сервером.

Класс автоматически устанавливает соединение с сервером ClickHouse, проверяет совместимость 
и инициализирует необходимые компоненты для работы с Native форматом.

**Параметры инициализации:**

.. list-table:: Параметры конструктора NativeDumper
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``connector``
     - ``CHConnector``
     - **Обязательный.** Коннектор, содержащий параметры подключения к ClickHouse (хост, порт, пользователь, пароль)
   * - ``compression_method``
     - ``CompressionMethod``
     - Метод сжатия данных. По умолчанию: ``CompressionMethod.ZSTD``. Поддерживаемые методы: ZSTD, LZ4, NONE
   * - ``logger``
     - ``Logger | None``
     - Логгер для записи событий и ошибок. Если не указан, создается ``DumperLogger`` по умолчанию
   * - ``timeout``
     - ``int``
     - Таймаут операций в секундах. По умолчанию: ``DBMS_DEFAULT_TIMEOUT_SEC``

**Атрибуты экземпляра:**

.. py:attribute:: connector
   :type: CHConnector

   Коннектор для подключения к ClickHouse.

.. py:attribute:: compression_method
   :type: CompressionMethod

   Метод сжатия данных.

.. py:attribute:: logger
   :type: Logger

   Логгер для записи событий.

.. py:attribute:: cursor
   :type: HTTPCursor

   Курсор для выполнения запросов через HTTP протокол.

.. py:attribute:: version
   :type: str

   Версия сервера ClickHouse.

.. py:attribute:: _dbmeta
   :type: DBMetadata | None
   :private:

   Метаданные базы данных (кешируются для производительности).

.. py:attribute:: dbname
   :type: str

   Имя СУБД (всегда "clickhouse").

**Ограничения и исключения:**

* **Порт 9000 не поддерживается** - NativeDumper использует HTTP/HTTPS протокол (порт 8123 по умолчанию), 
  а не Native протокол (порт 9000)
* **Требуется корректный коннектор** - должен содержать все необходимые параметры подключения
* **Автоматическое переподключение** - при потере соединения могут возникать исключения

**Примеры использования:**

.. code-block:: python

    # Создание NativeDumper с параметрами по умолчанию
    from native-dumper import NativeDumper, CHConnector, CompressionMethod
    
    connector = CHConnector(
        host="localhost",
        port=8123,
        user="default",
        password=""
    )
    
    dumper = NativeDumper(
        connector=connector,
        compression_method=CompressionMethod.ZSTD,
        timeout=30
    )

    # Создание с кастомным логгером
    import logging
    
    custom_logger = logging.getLogger("native_dumper")
    custom_logger.setLevel(logging.DEBUG)
    
    dumper_with_logger = NativeDumper(
        connector=connector,
        logger=custom_logger
    )

**Обработка ошибок:**

.. code-block:: python

    try:
        connector = CHConnector(host="localhost", port=9000)  # Неправильный порт!
        dumper = NativeDumper(connector=connector)
    except ValueError as e:
        print(f"Неправильная конфигурация: {e}")
    
    try:
        connector = CHConnector(host="nonexistent", port=8123)
        dumper = NativeDumper(connector=connector)
    except NativeDumperError as e:
        print(f"Ошибка подключения: {e}")

**Примечания:**

* Native формат - самый эффективный способ передачи данных в/из ClickHouse
* Используется HTTP/HTTPS протокол (порт 8123 или 443), а не Native TCP протокол (порт 9000)
* Сжатие данных уменьшает объем передаваемых данных и ускоряет передачу по сети
* Класс автоматически отправляет HELLO-пакет при инициализации для проверки соединения
* Для больших объемов данных рекомендуется использовать ZSTD сжатие

Доступные методы класса и декоратор multiquery
----------------------------------------------

.. toctree::
    :maxdepth: 1

    methods/read_dump
    methods/write_dump
    methods/write_between
    methods/to_reader
    methods/from_rows
    methods/from_pandas
    methods/from_polars
    methods/refresh
    methods/close
    hidden_methods/query_formatter
    hidden_methods/multiquery

Дополнительные компоненты
-------------------------

.. toctree::
    :maxdepth: 1

    common/index

**См. также:**

- :class:`CompressionMethod` - Перечисление методов сжатия
