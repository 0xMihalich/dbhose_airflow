to_table
========

.. py:method:: DBHose.to_table()

   Переносит данные из промежуточной таблицы в целевую.

   .. contents:: Содержание
      :local:
      :depth: 2

   **Описание:**

   Метод выполняет финальный этап переноса данных - перемещение данных из
   промежуточной таблицы (:attr:`table_temp`) в целевую (:attr:`table_dest`).
   В зависимости от выбранного :attr:`move_method` применяется различная логика
   переноса данных.

   **Сигнатура:**

   .. code-block:: python

      def to_table(self) -> None:
          """Move data to destination table."""

   **Типы методов переноса:**

   .. list-table:: Типы методов переноса данных
      :widths: 20 15 15 50
      :header-rows: 1

      * - Метод
        - SQL
        - Фильтр
        - Логика выполнения
      * - **append**
        - ❌ Нет
        - ❌ Нет
        - Прямой перенос ``write_between``
      * - **delete**
        - ✅ Да
        - ✅ Да
        - Удаление по фильтру + вставка
      * - **replace**
        - ✅ Да
        - ❌ Нет
        - Полная замена таблицы
      * - **rewrite**
        - ❌ Нет
        - ❌ Нет
        - TRUNCATE + прямой перенос
      * - **custom**
        - ❌ Нет
        - ❌ Нет
        - Пользовательские SQL запросы

   **Валидация параметров:**

   Метод выполняет проверки перед выполнением:

   .. code-block:: python

      # 1. Проверка фильтрации для методов delete
      if self.move_method.need_filter and not self.filter_by:
          raise ValueError("You must specify columns in filter_by")

      # 2. Проверка custom запроса для custom метода
      if self.move_method.is_custom and not self.custom_move:
          raise ValueError("You must specify custom query")

      # 3. Проверка количества колонок для ClickHouse delete
      if (self.move_method is MoveMethod.delete and
          self.dumper_dest.__class__ is NativeDumper and
          len(self.filter_by.split(", ")) > 4):
          raise ValueError("Too many columns in filter_by (> 4)")

   **Примеры использования:**

   .. code-block:: python
      :caption: Базовый пример - метод replace

      from dbhose_airflow import DBHose, MoveMethod

      dbhose = DBHose(
          table_dest="public.users",
          connection_dest="postgres_target",
          connection_src="postgres_source",
          move_method=MoveMethod.replace,  # Полная замена
      )
      dbhose.create_temp()
      # ... загрузка данных ...
      dbhose.to_table()
      # Логи:
      # INFO:root:Move data with method replace
      # INFO:root:Data moved into public.users

   .. code-block:: python
      :caption: Пример с фильтрацией - метод delete

      dbhose = DBHose(
          table_dest="analytics.daily_sales",
          connection_dest="clickhouse_analytics",
          connection_src="postgres_sales",
          move_method=MoveMethod.delete,  # Удаление с фильтрацией
          filter_by=["sale_date", "region"],  # Обязательно для delete
      )
      dbhose.create_temp()
      # ... загрузка данных ...
      dbhose.to_table()  # Удалит старые данные по фильтру и вставит новые

   .. code-block:: python
      :caption: Пример с пользовательским запросом

      dbhose = DBHose(
          table_dest="data_warehouse.fact_orders",
          connection_dest="dw_postgres",
          connection_src="oltp_postgres",
          move_method=MoveMethod.custom,
          custom_move="""
          -- Удалить старые данные
          DELETE FROM {table_dest} 
          WHERE order_date >= CURRENT_DATE - INTERVAL '7 days';
          
          -- Вставить новые данные
          INSERT INTO {table_dest}
          SELECT *, NOW() as loaded_at 
          FROM {table_temp};
          """,
      )
      dbhose.create_temp()
      # ... загрузка данных ...
      dbhose.to_table()  # Выполнит пользовательские запросы

   .. code-block:: python
      :caption: Пример с методом rewrite (пересоздание)

      dbhose = DBHose(
          table_dest="cache.report_data",
          connection_dest="postgres_cache",
          connection_src="postgres_source",
          move_method=MoveMethod.rewrite,  # Полная перезапись
      )
      dbhose.create_temp()
      # ... загрузка данных ...
      dbhose.to_table()  # TRUNCATE таблицы и прямой перенос

   **Особенности для разных СУБД:**

   .. tabs::

      .. tab:: ClickHouse (NativeDumper)

         **Особенности:**

         - Не требует коммита транзакции
         - Для метода ``delete`` ограничение: ≤4 колонок в ``filter_by``
         - ``write_between`` использует нативный формат
         - ``TRUNCATE`` выполняется немедленно

         **Пример запроса delete:**

         .. code-block:: sql

            ALTER TABLE target_table DELETE 
            WHERE date IN (SELECT date FROM temp_table)

      .. tab:: PostgreSQL (PGPackDumper)

         **Особенности:**

         - Требует коммита транзакции
         - Нет ограничений на количество колонок в ``filter_by``
         - ``write_between`` использует COPY
         - ``TRUNCATE`` может быть в транзакции

         **Пример запроса delete:**

         .. code-block:: sql

            DELETE FROM target_table t
            USING temp_table s
            WHERE t.id = s.id
              AND t.date = s.date

      .. tab:: Greenplum (PGPackDumper)

         **Особенности:**

         - Аналогично PostgreSQL
         - Учитывает распределение данных
         - Оптимизированные распределенные операции
         - Может использовать сегментные операции

   **Логирование:**

   Метод детально логирует процесс:

   .. code-block:: text

      # Начало операции
      INFO:root:╔══════════════════════════════════════════════════════════╗
      INFO:root:║            Move data with method replace                 ║
      INFO:root:╚══════════════════════════════════════════════════════════╝
      
      # Для метода rewrite
      INFO:root:Clear table operation start
      INFO:root:Clear table operation done
      
      # Успешное завершение
      INFO:root:╔══════════════════════════════════════════════════════════╗
      INFO:root:║            Data moved into public.users                  ║
      INFO:root:╚══════════════════════════════════════════════════════════╝

   **Обработка ошибок:**

   Метод выбрасывает исключения при обнаружении проблем:

   .. list-table:: Типы ошибок
      :widths: 40 60
      :header-rows: 1

      * - Исключение
        - Условие возникновения
      * - :class:`ValueError`
        - ``move_method.need_filter=True``, но ``filter_by`` пустой
      * - :class:`ValueError`
        - ``move_method.is_custom=True``, но ``custom_move`` не указан
      * - :class:`ValueError`
        - ClickHouse + ``delete`` + >4 колонок в ``filter_by``
      * - :class:`ValueError`
        - Метод недоступен для таблицы (проверка ``is_avaliable``)
      * - Исключения СУБД
        - Ошибки выполнения SQL запросов

   **SQL шаблоны методов:**

   Методы с ``have_sql=True`` используют шаблоны из файлов:

   .. code-block:: python

      # Формат: {dbname}/{method_name}.sql
      mv_path = "path/to/sql/templates/{}/{}.sql"
      # Пример для PostgreSQL delete:
      move_query = read_text("postgres/delete.sql")

   **Примеры SQL шаблонов:**

   .. tabs::

      .. tab:: delete.sql (PostgreSQL)

         .. code-block:: sql

            SELECT 
                CASE 
                    WHEN COUNT(*) > 0 THEN true
                    ELSE false
                END as is_available,
                $sql$DELETE FROM $${table_dest}$$ t
                USING $${table_temp}$$ s
                WHERE $where_clause$$ as move_query
            FROM information_schema.columns 
            WHERE table_name = '{table_dest}'
              AND column_name IN ({filter_by})

      .. tab:: replace.sql (ClickHouse)

         .. code-block:: sql

            SELECT 
                is_available,
                'INSERT INTO {table_dest} SELECT * FROM {table_temp}' as move_query
            FROM system.tables 
            WHERE name = '{table_dest}'

   **Метод `write_between`:**

   Для методов без SQL (``append``, ``rewrite`` после TRUNCATE) используется:

   .. code-block:: python

      self.dumper_dest.write_between(self.table_dest, self.table_temp)

   Эта операция:

   1. Читает данные из промежуточной таблицы
   2. Конвертирует в нативный формат СУБД
   3. Записывает в целевую таблицу
   4. Оптимизирована для больших объемов данных

   **Завершающие операции:**

   После успешного переноса данных:

   .. code-block:: python

      # Удаление промежуточной таблицы
      self.drop_temp()

   **Рекомендации по выбору метода:**

   .. code-block:: python

      def select_move_method(table_type: str, data_freshness: str) -> MoveMethod:
          """Автоматический выбор метода переноса."""
          
          if table_type == 'fact_table' and data_freshness == 'incremental':
              return MoveMethod.delete  # Инкрементальное обновление
          
          elif table_type == 'dimension_table':
              return MoveMethod.replace  # Полная замена
          
          elif table_type == 'cache_table':
              return MoveMethod.rewrite  # Пересоздание
          
          elif table_type == 'staging_table':
              return MoveMethod.append  # Простое добавление
          
          else:
              return MoveMethod.replace  # По умолчанию

   **Связанные методы:**

   .. hlist::
      :columns: 2

      * - :meth:`create_temp`
        - Создание промежуточной таблицы
      * - :meth:`drop_temp`
        - Удаление промежуточной таблицы
      * - :meth:`dq_check`
        - Проверка качества данных

   **Примечания:**

   1. **Производительность:** Методы с SQL обычно медленнее, но точнее
   2. **Безопасность:** Все операции выполняются в рамках транзакций (для PostgreSQL)
   3. **Атомарность:** При ошибке данные не переносятся
   4. **Очистка:** Промежуточная таблица удаляется автоматически

   **См. также:**

   - :doc:`../../enums/move_method` - Объект перечислений MoveMethod
   - :doc:`create_temp` - Создание промежуточной таблицы
   - :doc:`drop_temp` - Удаление промежуточной таблицы
   - :doc:`dq_check` - Проверка качества данных
