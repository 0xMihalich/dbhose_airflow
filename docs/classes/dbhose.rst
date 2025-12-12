DBHose
======

.. py:class:: DBHose(
        table_dest,
        connection_dest,
        connection_src=None,
        dq_skip_check=[],
        filter_by=[],
        drop_temp_table=True,
        move_method=MoveMethod.replace,
        custom_move=None,
        compress_method=CompressionMethod.ZSTD,
        timeout=DBMS_DEFAULT_TIMEOUT_SEC,
    )

   Основной класс DBHose для переноса данных между СУБД.
   
   .. versionadded:: 0.1.0
   
   **Назначение:**
   
   Класс предоставляет унифицированный интерфейс для переноса данных между
   различными системами управления базами данных (СУБД) в Apache Airflow DAGs.
   Поддерживает ClickHouse, PostgreSQL и Greenplum.
   
   .. rubric:: Параметры инициализации
   
   .. py:attribute:: table_dest
      :type: str
      
      Имя целевой таблицы для записи данных.
      
      **Примеры:**
      
      - ``"target_table"``
      - ``"schema.target_table"``
      - ``"database.schema.table"``
   
   .. py:attribute:: connection_dest
      :type: str
      
      ID соединения Airflow для целевой СУБД.
      
      **Примеры:**
      
      - ``"target_postgres"``
      - ``"clickhouse_prod"``
      - ``"greenplum_warehouse"``
   
   .. py:attribute:: connection_src
      :type: Optional[str]
      :value: None
      
      ID соединения Airflow для исходной СУБД.
      Если ``None``, используется только целевое соединение (например,
      для выполнения SQL запросов в целевой БД).
      
      **Примеры:**
      
      - ``"source_postgres"``
      - ``None`` (если источник не нужен)
   
   .. py:attribute:: dq_skip_check
      :type: List[str]
      :value: []
      
      Список проверок качества данных, которые нужно пропустить.
      См. :class:`DQCheck` для доступных проверок.
      
      **Примеры:**
      
      .. code-block:: python
         
         # Пропустить проверку на дубликаты и будущие даты
         dq_skip_check = ["uniq", "future"]
         
         # Пропустить все проверки
         dq_skip_check = list(DQCheck.__members__.keys())
   
   .. py:attribute:: filter_by
      :type: List[str]
      :value: []
      
      Список колонок для фильтрации данных при использовании
      метода ``delete``.
      
      **Примеры:**
      
      .. code-block:: python
         
         # Фильтрация по дате
         filter_by = ["date_column"]
         
         # Фильтрация по нескольким колонкам
         filter_by = ["date_column", "region_id", "user_id"]
         
         # Без фильтрации
         filter_by = []
      
      **Примечание:** Для метода ``delete`` фильтрация обязательна.
   
   .. py:attribute:: drop_temp_table
      :type: bool
      :value: True
      
      Удаление промежуточной таблицы после завершения операции.
      
      **Значения:**
      
      - ``True``: Промежуточная таблица удаляется
      - ``False``: Промежуточная таблица остается (для отладки)
   
   .. py:attribute:: move_method
      :type: MoveMethod
      :value: MoveMethod.replace
      
      Метод перемещения данных из промежуточной таблицы в целевую.
      См. :class:`MoveMethod` для всех доступных методов.
      
      **Примеры:**
      
      .. code-block:: python
         
         from dbhose_airflow import MoveMethod
         
         # Заменить данные полностью (по умолчанию)
         move_method = MoveMethod.replace
         
         # Добавить новые данные
         move_method = MoveMethod.append
         
         # Удалить старые и добавить новые
         move_method = MoveMethod.delete
   
   .. py:attribute:: custom_move
      :type: Optional[str]
      :value: None
      
      Пользовательский SQL запрос для перемещения данных.
      Используется только с ``move_method=MoveMethod.custom``.
      
      **Примеры:**
      
      .. code-block:: python
         
         # Пользовательский INSERT
         custom_move = """
         INSERT INTO {target_table}
         SELECT * FROM {temp_table}
         WHERE date >= '2024-01-01'
         """
         
         # Пользовательский MERGE
         custom_move = """
         MERGE INTO {target_table} AS target
         USING {temp_table} AS source
         ON target.id = source.id
         WHEN MATCHED THEN UPDATE SET
           target.value = source.value,
           target.updated_at = NOW()
         WHEN NOT MATCHED THEN INSERT VALUES
           (source.id, source.value, NOW())
         """
   
   .. py:attribute:: compress_method
      :type: CompressionMethod
      :value: CompressionMethod.ZSTD
      
      Метод сжатия данных при передаче.
      См. :class:`CompressionMethod` для всех методов.
      
      **Примеры:**
      
      .. code-block:: python
         
         from light_compressor import CompressionMethod
         
         # Сбалансированное сжатие (по умолчанию)
         compress_method = CompressionMethod.ZSTD
         
         # Быстрое сжатие
         compress_method = CompressionMethod.LZ4
         
         # Без сжатия (не рекомендуется)
         compress_method = CompressionMethod.NONE
   
   .. py:attribute:: timeout
      :type: int
      :value: DBMS_DEFAULT_TIMEOUT_SEC
      
      Таймаут операций с СУБД в секундах.
      См. :data:`DBMS_DEFAULT_TIMEOUT_SEC` (300 секунд).
      
      **Примеры:**
      
      .. code-block:: python
         
         # Стандартный таймаут (5 минут)
         timeout = 300
         
         # Для больших таблиц (10 минут)
         timeout = 600
         
         # Для очень больших таблиц (30 минут)
         timeout = 1800

   .. rubric:: Атрибуты экземпляра
   
   После инициализации создаются следующие атрибуты:
   
   .. py:attribute:: logger
      :type: Logger
      
      Логгер для записи событий и ошибок.
   
   .. py:attribute:: dumper_dest
      :type: Union[NativeDumper, PGPackDumper]
      
      Объект дампера для целевой СУБД.
      Создается функцией :func:`dbhose_dumper`.
   
   .. py:attribute:: dumper_src
      :type: Optional[Union[NativeDumper, PGPackDumper]]
      
      Объект дампера для исходной СУБД (если указан ``connection_src``).
   
   .. py:attribute:: ddl
      :type: Optional[str]
      
      DDL (Data Definition Language) целевой таблицы.
      Заполняется при вызове методов класса.
   
   .. py:attribute:: temp_ddl
      :type: Optional[str]
      
      DDL промежуточной таблицы.
      Заполняется при вызове методов класса.
   
   .. py:attribute:: table_temp
      :type: Optional[str]
      
      Имя промежуточной таблицы.
      Генерируется автоматически.
   
   .. py:attribute:: filter_by
      :type: str
      
      Строковое представление колонок фильтрации (преобразуется из списка).
   
   .. rubric:: Примеры инициализации
   
   .. code-block:: python
      
      from dbhose_airflow import DBHose, MoveMethod
      from light_compressor import CompressionMethod
      
      # Пример 1: Простая инициализация для PostgreSQL → PostgreSQL
      dbhose = DBHose(
          table_dest="public.target_table",
          connection_dest="target_postgres",
          connection_src="source_postgres",
          move_method=MoveMethod.replace,
      )
      
      # Пример 2: Инициализация с фильтрацией для ClickHouse
      dbhose = DBHose(
          table_dest="default.analytics_data",
          connection_dest="clickhouse_prod",
          connection_src="postgres_source",
          filter_by=["event_date", "user_id"],  # Фильтрация по дате и пользователю
          move_method=MoveMethod.delete,  # Удаление с фильтрацией
          compress_method=CompressionMethod.LZ4,  # Быстрое сжатие
          timeout=600,  # 10 минут таймаут
      )
      
      # Пример 3: Только целевое соединение (без источника)
      dbhose = DBHose(
          table_dest="staging.temp_data",
          connection_dest="staging_postgres",
          connection_src=None,  # Только целевая БД
          drop_temp_table=False,  # Оставить таблицу для отладки
          dq_skip_check=["future", "nan"],  # Пропустить некоторые проверки
      )
      
      # Пример 4: Пользовательский метод перемещения
      dbhose = DBHose(
          table_dest="data_warehouse.fact_sales",
          connection_dest="dw_postgres",
          connection_src="oltp_postgres",
          move_method=MoveMethod.custom,  # Пользовательский метод
          custom_move="""
          INSERT INTO {target_table}
          SELECT 
              s.*,
              NOW() as loaded_at
          FROM {temp_table} s
          WHERE s.sale_date >= CURRENT_DATE - INTERVAL '7 days'
          """,
          filter_by=["sale_date"],  # Фильтрация для оптимизации
      )
   
   .. rubric:: Рекомендации по инициализации
   
   .. tabs::
      
      .. tab:: PostgreSQL → ClickHouse
         
         .. code-block:: python
            
            dbhose = DBHose(
                table_dest="clickhouse_table",
                connection_dest="clickhouse_target",
                connection_src="postgres_source",
                move_method=MoveMethod.replace,  # Полная замена
                compress_method=CompressionMethod.ZSTD,  # Сжатие для сети
                timeout=600,  # Увеличенный таймаут
            )
      
      .. tab:: Ежедневное обновление
         
         .. code-block:: python
            
            dbhose = DBHose(
                table_dest="daily_report",
                connection_dest="reporting_db",
                connection_src="source_db",
                filter_by=["report_date"],  # Фильтрация по дате
                move_method=MoveMethod.delete,  # Удаление старых данных
                dq_skip_check=["sum"],  # Пропустить тяжелую проверку сумм
            )
      
      .. tab:: Быстрая репликация
         
         .. code-block:: python
            
            dbhose = DBHose(
                table_dest="replica_table",
                connection_dest="replica_db",
                connection_src="primary_db",
                move_method=MoveMethod.append,  # Простое добавление
                compress_method=CompressionMethod.NONE,  # Без сжатия для скорости
                drop_temp_table=True,  # Автоматическая очистка
            )

   .. rubric:: Валидация параметров
   
   .. code-block:: python
      
      def validate_dbhose_params(params: dict) -> bool:
          """Валидация параметров DBHose."""
          
          # Проверка обязательных параметров
          required = ['table_dest', 'connection_dest']
          for param in required:
              if param not in params or not params[param]:
                  raise ValueError(f"Обязательный параметр {param} отсутствует")
          
          # Проверка move_method и custom_move
          if params.get('move_method') == MoveMethod.custom:
              if not params.get('custom_move'):
                  raise ValueError("custom_move обязателен для MoveMethod.custom")
          
          # Проверка filter_by для delete метода
          if params.get('move_method') == MoveMethod.delete:
              if not params.get('filter_by'):
                  raise ValueError("filter_by обязателен для MoveMethod.delete")
          
          return True
      
      # Использование
      params = {
          'table_dest': 'my_table',
          'connection_dest': 'my_conn',
          'move_method': MoveMethod.delete,
          'filter_by': ['date_column'],
      }
      
      if validate_dbhose_params(params):
          dbhose = DBHose(**params)

   .. rubric:: Логирование
   
   При инициализации класса выводится логотип DBHose и информация о подключенных СУБД.

   .. note::
      
      - Для метода ``delete`` обязательна фильтрация (``filter_by``)
      - Промежуточная таблица имеет название ``имя основной таблицы``_temp
   
   .. warning::
      
      - Не используйте ``drop_temp_table=False`` в production без необходимости
      - Для долгих запросов в Clickhouse требуется изменить ``timeout`` при инициализации
      - Используйте пропуск проверок качества (``dq_skip_check``) если данная проверка не требуется для конкретной таблицы
   
   .. seealso::
      
      - :class:`MoveMethod` - Методы перемещения данных
      - :class:`DQCheck` - Проверки качества данных
      - :class:`CompressionMethod` - Методы сжатия
      - :data:`DBMS_DEFAULT_TIMEOUT_SEC` - Стандартный таймаут
      - :doc:`../functions/dbhose_dumper` - Создание дамперов из соединений

Методы класса
-------------

.. toctree::
    :maxdepth: 1

    methods/create_temp
    methods/drop_temp
    methods/dq_check
    methods/to_table
    methods/from_dmbs
    methods/from_file
    methods/from_frame
    methods/from_iterable
