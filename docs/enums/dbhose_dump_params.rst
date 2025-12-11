DBHoseDumpParams
================

.. py:class:: DBHoseDumpParams

   Перечисление параметров для инициализации DBHoseDump.
   
   Наследуется от :class:`DBHoseObject` и :py:class:`~enum.Enum`.
   
   .. versionadded:: 0.1.0
   
   **Назначение:**
   
   Определяет конфигурации для работы с различными типами СУБД и протоколов.
   Каждый элемент содержит специфичные настройки для конкретной цели
   (ClickHouse, PostgreSQL, Greenplum, FTP, HTTP).
   
   .. rubric:: Атрибуты DBHoseObject
   
   Каждый элемент перечисления содержит следующие атрибуты:
   
   .. py:attribute:: name
      :type: str
      
      Человеко-читаемое имя цели.
   
   .. py:attribute:: connection
      :type: Union[CHConnector, PGConnector]
      
      Класс коннектора для подключения к цели.
      ``CHConnector`` для ClickHouse, ``PGConnector`` для PostgreSQL/Greenplum.
   
   .. py:attribute:: dumper
      :type: Union[NativeDumper, PGPackDumper]
      
      Класс дампера для сериализации данных.
      ``NativeDumper`` для ClickHouse формата, ``PGPackDumper`` для PostgreSQL.

   .. rubric:: Методы
   
   .. py:method:: from_airflow(connection, compress_method=CompressionMethod.ZSTD, timeout=DBMS_DEFAULT_TIMEOUT_SEC)
      :staticmethod:
      
      Инициализирует дампер из объекта Airflow Connection.
      
      **Параметры:**
      
      - **connection** (:class:`~airflow.models.Connection`) - объект соединения Airflow
      - **compress_method** (:class:`CompressionMethod`) - метод сжатия (по умолчанию ZSTD)
      - **timeout** (:class:`int`) - таймаут подключения в секундах
      
      **Возвращает:**
      
      Экземпляр :class:`NativeDumper` или :class:`PGPackDumper`
      
.. code-block:: python
    
    from airflow.models import Connection
    from dbhose_airflow import DBHoseDumpParams, CompressionMethod
    
    # Получаем соединение из Airflow
    conn = Connection.get_connection_from_secrets("my_postgres_conn")
    
    # Создаем дампер для PostgreSQL
    dumper = DBHoseDumpParams.postgres.from_airflow(
        connection=conn,
        compress_method=CompressionMethod.LZ4,
        timeout=30
    )

.. rubric:: Элементы перечисления

.. py:data:: clickhouse
    :value: DBHoseObject("clickhouse", CHConnector, NativeDumper)
    
    Конфигурация для ClickHouse через нативный TCP протокол.
    
    **Характеристики:**
    
    - 📝 **Имя:** "clickhouse"
    - 🔌 **Коннектор:** :class:`CHConnector`
    - 📦 **Дампер:** :class:`NativeDumper`
    - 📊 **Формат:** Native (ClickHouse)
    
    **Использование:** Подключение к ClickHouse серверу.

.. py:data:: ftp
    :value: DBHoseObject("ftp", CHConnector, NativeDumper)
    
    Конфигурация для ClickHouse через FTP протокол.
    
    **Характеристики:**
    
    - 📝 **Имя:** "ftp"
    - 🔌 **Коннектор:** :class:`CHConnector`
    - 📦 **Дампер:** :class:`NativeDumper`
    - 📊 **Формат:** Native (ClickHouse)
    
    **Использование:** Подключение к ClickHouse серверу.

.. py:data:: http
    :value: DBHoseObject("http", CHConnector, NativeDumper)
    
    Конфигурация для ClickHouse через HTTP протокол.
    
    **Характеристики:**
    
    - 📝 **Имя:** "http"
    - 🔌 **Коннектор:** :class:`CHConnector`
    - 📦 **Дампер:** :class:`NativeDumper`
    - 📊 **Формат:** Native (ClickHouse)
    
    **Использование:** Подключение к ClickHouse серверу.

.. py:data:: postgres
    :value: DBHoseObject("postgres", PGConnector, PGPackDumper)
    
    Конфигурация для PostgreSQL.
    
    **Характеристики:**
    
    - 📝 **Имя:** "postgres"
    - 🔌 **Коннектор:** :class:`PGConnector`
    - 📦 **Дампер:** :class:`PGPackDumper`
    - 📊 **Формат:** PGPack (PGCopy с метаданными и сжатием)
    
    **Использование:** Подключение к PostgreSQL/Greenplum серверу.

.. py:data:: greenplum
    :value: DBHoseObject("greenplum", PGConnector, PGPackDumper)
    
    Конфигурация для Greenplum.
    
    **Характеристики:**
    
    - 📝 **Имя:** "greenplum"
    - 🔌 **Коннектор:** :class:`PGConnector`
    - 📦 **Дампер:** :class:`PGPackDumper`
    - 📊 **Формат:** PGPack (PGCopy с метаданными и сжатием)
    
    **Использование:** Подключение к Greenplum серверу.

.. note::

    Является внутренним объектом DBHose и не предназначен внешнего использования.

.. warning::

    Конфигурации ``ftp`` и ``http`` созданы для случаев, если в прод среде отсутствует провайдер Clickhouse и коннекторы прописаны с одним из этих типов данных.

.. seealso::

    - :class:`CHConnector` - Коннектор для ClickHouse
    - :class:`PGConnector` - Коннектор для PostgreSQL/Greenplum
    - :class:`NativeDumper` - Дампер для ClickHouse формата
    - :class:`PGPackDumper` - Дампер для PostgreSQL формата
