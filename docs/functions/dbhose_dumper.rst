dbhose_dumper
=============

.. py:function:: dbhose_dumper(airflow_connection, compress_method=CompressionMethod.ZSTD, timeout=DBMS_DEFAULT_TIMEOUT_SEC)

   Создает объект дампера из строки соединения Airflow.
   
   :param str airflow_connection: ID соединения Airflow
   :param CompressionMethod compress_method: Метод сжатия, по умолчанию ZSTD
   :param int timeout: Таймаут в секундах, по умолчанию 300 (5 минут)
   :return: Объект :class:`NativeDumper` или :class:`PGPackDumper`
   :rtype: Union[NativeDumper, PGPackDumper]
   :raises KeyError: Если тип соединения не поддерживается
   :raises AirflowNotFoundException: Если соединение не найдено

**Описание:**

Функция создает объект дампера для работы с СУБД на основе конфигурации
соединения Airflow. Автоматически определяет тип СУБД (ClickHouse или PostgreSQL/Greenplum)
и создает соответствующий дампер с указанными параметрами сжатия и таймаута.

**Примеры использования:**

.. code-block:: python
   
   from dbhose_airflow import dbhose_dumper, CompressionMethod
   
   # Простое использование со стандартными параметрами
   dumper = dbhose_dumper("my_postgres_connection")
   
   # С кастомным сжатием и таймаутом
   dumper = dbhose_dumper(
       airflow_connection="my_clickhouse_connection",
       compress_method=CompressionMethod.LZ4,  # Быстрое сжатие
       timeout=600,  # 10 минут
   )

**Детали реализации:**

1. Получает объект соединения Airflow по ID
2. Определяет тип СУБД по ``conn_type``
3. Создает соответствующий коннектор и дампер
4. Применяет параметры сжатия и таймаута
5. Возвращает готовый к использованию объект дампера

**Практические примеры:**

.. code-block:: python
   
   # Пример 1: Создание дамперов для миграции данных
   def create_migration_dumpers(source_conn_id: str, target_conn_id: str):
       """Создает пару дамперов для миграции."""
       
       source_dumper = dbhose_dumper(
           airflow_connection=source_conn_id,
           compress_method=CompressionMethod.ZSTD,
           timeout=300
       )
       
       target_dumper = dbhose_dumper(
           airflow_connection=target_conn_id,
           compress_method=CompressionMethod.NONE,  # ClickHouse не поддерживает сжатие
           timeout=600  # Увеличенный таймаут для ClickHouse
       )
       
       return source_dumper, target_dumper
   
   # Пример 2: Фабрика дамперов с валидацией
   class DumperFactory:
       """Фабрика для создания и валидации дамперов."""
       
       @staticmethod
       def create_validated_dumper(conn_id: str, **kwargs):
           """Создает дампер с валидацией соединения."""
           
           try:
               dumper = dbhose_dumper(conn_id, **kwargs)
               # Дополнительная валидация
               if hasattr(dumper, 'test_connection'):
                   dumper.test_connection()
               return dumper
               
           except KeyError as e:
               raise ValueError(f"Неизвестный тип соединения: {conn_id}") from e
           except Exception as e:
               raise ConnectionError(f"Ошибка создания дампера для {conn_id}: {e}") from e
   
   # Пример 3: Пул дамперов для многопоточной работы
   from concurrent.futures import ThreadPoolExecutor
   
   def create_dumper_pool(conn_ids: list[str], max_workers: int = 5):
       """Создает пул дамперов в многопоточном режиме."""
       
       with ThreadPoolExecutor(max_workers=max_workers) as executor:
           dumpers = list(executor.map(dbhose_dumper, conn_ids))
       
       return dict(zip(conn_ids, dumpers))

.. note::

    - Для ClickHouse соединений используется порт 8123 либо 443
    - Порт 9000 автоматически меняется на 8123
    - Таймаут нужен только для Clickhouse соединения

.. seealso::
   
   - :class:`DBHoseDumpParams` - Перечисление конфигураций дамперов
   - :class:`CompressionMethod` - Методы сжатия данных
   - :data:`DBMS_DEFAULT_TIMEOUT_SEC` - Стандартный таймаут
   - :class:`NativeDumper` - Дампер для ClickHouse
   - :class:`PGPackDumper` - Дампер для PostgreSQL/Greenplum
