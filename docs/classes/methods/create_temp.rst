create_temp
===========

.. py:method:: DBHose.create_temp()

   Создает таблицу для промежуточного хранения данных.
   
   .. contents:: Содержание
      :local:
      :depth: 2
   
   **Описание:**
   
   Метод создает таблицу в целевой СУБД, которая используется
   как промежуточное хранилище данных перед их переносом в целевую таблицу.
   Таблица создается на основе DDL (Data Definition Language) целевой таблицы.
   
   **Сигнатура:**
   
   .. code-block:: python
      
      def create_temp(self) -> None:
          """Create temporary table."""
   
   **Процесс выполнения:**
   
   1. **Получение DDL целевой таблицы:**
      
      .. code-block:: python
         
         query_ddl = read_text(ddl_path.format(self.dumper_dest.dbname))
         reader = self.dumper_dest.to_reader(
             query_ddl.format(table=self.table_dest)
         )
   
   2. **Извлечение метаданных:**
      
      .. code-block:: python
         
         self.ddl, self.temp_ddl, self.table_temp = tuple(*reader.to_rows())
   
   3. **Валидация:**
      
      .. code-block:: python
         
         if not self.ddl:
             msg = f"Table {self.table_dest} not found!"
             raise ValueError(msg)
   
   4. **Создание таблицы:**
      
      .. code-block:: python
         
         self.dumper_dest.cursor.execute(self.temp_ddl)
         
         # Для PostgreSQL/Greenplum - коммит транзакции
         if self.dumper_dest.__class__ is not NativeDumper:
             self.dumper_dest.connect.commit()
             self.dumper_dest.copy_buffer.query = None
   
   **Атрибуты, обновляемые методом:**
   
   .. list-table:: Обновляемые атрибуты
      :widths: 30 70
      :header-rows: 1
      
      * - Атрибут
        - Описание
      * - ``ddl``
        - DDL (Data Definition Language) целевой таблицы
      * - ``temp_ddl``
        - DDL временной таблицы
      * - ``table_temp``
        - Имя созданной временной таблицы
   
   **Примеры использования:**
   
   .. code-block:: python
      :caption: Базовый пример
      
      from dbhose_airflow import DBHose
      
      dbhose = DBHose(
          table_dest="public.users",
          connection_dest="postgres_target",
      )
      
      # Создание временной таблицы
      dbhose.create_temp()
      
      print(f"Имя временной таблицы: {dbhose.table_temp}")
      print(f"DDL целевой таблицы: {dbhose.ddl[:100]}...")
      print(f"DDL временной таблицы: {dbhose.temp_ddl[:100]}...")
   
   **Логирование:**
   
   Метод логирует ключевые этапы выполнения.
   
   **Особенности для разных СУБД:**
   
   .. tabs::
      
      .. tab:: ClickHouse
         
         - Использует :class:`NativeDumper`
         - Не требует коммита транзакции
         - Промежуточные таблицы создаются с движком `MergeTree`
         - DDL выполняется немедленно
      
      .. tab:: PostgreSQL
         
         - Использует :class:`PGPackDumper`
         - Требует коммита транзакции
      
      .. tab:: Greenplum
         
         - Использует :class:`PGPackDumper`
         - Требует коммита транзакции
         - Может создавать распределенные таблицы
         - Учитывает распределение данных
   
   **Ошибки и исключения:**
   
   .. list-table:: Возможные исключения
      :widths: 40 60
      :header-rows: 1
      
      * - Исключение
        - Причина
      * - :class:`ValueError`
        - Целевая таблица не существует
   
   **Практические рекомендации:**
   
   1. **Проверка прав доступа:**
      
      .. code-block:: python
         
         # Перед созданием проверьте права
         if not has_table_create_permission(dbhose.connection_dest):
             raise PermissionError("Нет прав на создание таблиц")
   
   2. **Отладка с сохранением таблицы:**
      
      .. code-block:: python
         
         # Для отладки оставьте таблицу
         dbhose = DBHose(
             table_dest="my_table",
             connection_dest="my_db",
             drop_temp_table=False,  # Не удалять автоматически
         )
         dbhose.create_temp()
         # Проверьте созданную таблицу в БД
   
   **Примечания:**
   
   - Имя промежуточной таблицы наследуюется от целевой с постфиксом _temp
   - Убедитесь в достаточности дискового пространства
   - Для больших таблиц PostgreSQL/Greenplum с партиционированием процесс может занимать больше времени

   **См. также:**
   
   - :doc:`../methods/drop_temp` - Удаление промежуточной таблицы
