PGPackDumper
============

.. py:class:: PGPackDumper(
   connector,
   compression_method=CompressionMethod.ZSTD,
   logger=None,
   )

   Класс для чтения и записи данных в PGPack формате PostgreSQL/GreenPlum.

   :param connector: Коннектор для подключения к PostgreSQL/GreenPlum
   :type connector: PGConnector
   :param compression_method: Метод сжатия данных
   :type compression_method: CompressionMethod
   :param logger: Логгер для записи событий
   :type logger: Logger | None
   :raises PGPackDumperError: При ошибках инициализации

**Описание:**

Внешний модуль ``pgpack-dumper`` входит в состав ``dbhose-airflow``, но может быть установлен отдельно.

Установка модуля pgpack-dumper без установки dbhose-airflow
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ./install_module.sh
   :language: bash

.. toctree::
   :caption: Линки на проект:

   GitHub <https://github.com/0xMihalich/pgpack_dumper>
   PyPI <https://pypi.org/project/pgpack-dumper/>

Часть кода написана на языке ``Cython``, что обеспечивает более быструю работу по сравнению с языком ``Python``.

Назначение класса PGPackDumper - обмен данными с серверами PostgreSQL и GreenPlum в PGPack формате.

Импорт модуля
^^^^^^^^^^^^^

.. literalinclude:: ./import_module.py
   :language: python

``PGPackDumper`` предоставляет функциональность для работы с PGPack форматом - 
специализированным бинарным форматом для эффективной передачи данных между PostgreSQL/GreenPlum 
и внешними системами.

Класс автоматически устанавливает соединение с сервером базы данных, определяет версию 
и инициализирует необходимые компоненты для работы с PGPack форматом.

**Параметры инициализации:**

.. list-table:: Параметры конструктора PGPackDumper
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``connector``
     - ``PGConnector``
     - **Обязательный.** Коннектор, содержащий параметры подключения к PostgreSQL/GreenPlum (хост, порт, пользователь, пароль, база данных)
   * - ``compression_method``
     - ``CompressionMethod``
     - Метод сжатия данных. По умолчанию: ``CompressionMethod.ZSTD``. Поддерживаемые методы: ZSTD, LZ4, NONE
   * - ``logger``
     - ``Logger | None``
     - Логгер для записи событий и ошибок. Если не указан, создается ``DumperLogger`` по умолчанию

**Атрибуты экземпляра:**

.. py:attribute:: connector
   :type: PGConnector

   Коннектор для подключения к PostgreSQL/GreenPlum.

.. py:attribute:: compression_method
   :type: CompressionMethod

   Метод сжатия данных.

.. py:attribute:: logger
   :type: Logger

   Логгер для записи событий.

.. py:attribute:: application_name
   :type: str

   Параметр application_name для передачи в pg_stat_activity.

.. py:attribute:: connect
   :type: Connection

   Соединение с базой данных.

.. py:attribute:: cursor
   :type: Cursor

   Курсор для выполнения запросов.

.. py:attribute:: copy_buffer
   :type: CopyBuffer

   Буфер для операций COPY.

.. py:attribute:: version
   :type: str

   Версия сервера PostgreSQL/GreenPlum.

.. py:attribute:: _dbmeta
   :type: DBMetadata | None
   :private:

   Метаданные базы данных (кешируются для производительности).

.. py:attribute:: dbname
   :type: str

   Имя базы данных.

.. py:attribute:: _size
   :type: int
   :private:

   Размер переданных данных в байтах.

**Ограничения и исключения:**

* **Требуется корректный коннектор** - должен содержать все необходимые параметры подключения
* **Поддержка PostgreSQL и GreenPlum** - автоматическое определение типа СУБД и версии
* **Использование COPY протокола** - для максимальной производительности при передаче данных

**Примеры использования:**

.. code-block:: python

    # Создание PGPackDumper с параметрами по умолчанию
    from pgpack-dumper import PGPackDumper, PGConnector, CompressionMethod
    
    connector = PGConnector(
        host="localhost",
        port=5432,
        user="postgres",
        password="password",
        dbname="mydatabase"
    )
    
    dumper = PGPackDumper(
        connector=connector,
        compression_method=CompressionMethod.ZSTD,
    )

    # Создание с кастомным логгером
    import logging
    
    custom_logger = logging.getLogger("pgpack_dumper")
    custom_logger.setLevel(logging.DEBUG)
    
    dumper_with_logger = PGPackDumper(
        connector=connector,
        logger=custom_logger
    )

**Обработка ошибок:**

.. code-block:: python

    try:
        connector = PGConnector(host="localhost", port=5432, dbname="nonexistent")
        dumper = PGPackDumper(connector=connector)
    except PGPackDumperError as e:
        print(f"Ошибка подключения: {e}")
    
    try:
        dumper.read_dump("output.pgpack", query="SELECT * FROM nonexistent_table")
    except PGPackDumperReadError as e:
        print(f"Ошибка чтения: {e}")

**Примечания:**

* PGPack формат - оптимизированный бинарный формат для передачи данных PostgreSQL/GreenPlum
* Поддерживает сжатие данных для уменьшения объема передаваемых данных
* Автоматически определяет версию СУБД (PostgreSQL или GreenPlum)
* Использует COPY протокол для максимальной производительности
* Поддерживает передачу данных между различными источниками (файлы, другие базы данных, Python объекты)
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
