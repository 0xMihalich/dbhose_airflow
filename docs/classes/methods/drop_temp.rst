drop_temp
=========

.. py:method:: DBHose.drop_temp()

   Удаляет промежуточную таблицу, если это разрешено настройками.
   
   .. contents:: Содержание
      :local:
      :depth: 2
   
   **Описание:**
   
   Метод удаляет промежуточную таблицу, созданную ранее методом :meth:`create_temp`.
   Удаление выполняется только если атрибут :attr:`drop_temp_table` имеет значение ``True``.
   В противном случае метод логирует предупреждение о пропуске операции.
   
   **Сигнатура:**
   
   .. code-block:: python
      
      def drop_temp(self) -> None:
          """Drop temp table."""
   
   **Примеры использования:**
   
   .. code-block:: python
      :caption: Базовый пример с удалением
      
      from dbhose_airflow import DBHose
      
      # Создаем объект с разрешением удаления (по умолчанию True)
      dbhose = DBHose(
          table_dest="public.users",
          connection_dest="postgres_target",
          drop_temp_table=True,  # Разрешить удаление
      )
      
      # Создаем временную таблицу
      dbhose.create_temp()
      
      # ... выполняем операции с данными ...
      
      # Удаляем временную таблицу
      dbhose.drop_temp()
   
   .. code-block:: python
      :caption: Пример с отключенным удалением (для отладки)
      
      dbhose = DBHose(
          table_dest="analytics.events",
          connection_dest="clickhouse_analytics",
          drop_temp_table=False,  # Запретить автоматическое удаление
      )
      
      dbhose.create_temp()
      # ... операции ...
      dbhose.drop_temp()  # Таблица НЕ будет удалена
      # Таблица останется в БД для последующего анализа
   
   **Обработка ошибок:**
   
   Метод использует ``DROP TABLE IF EXISTS``, который:
   
   - Не вызывает ошибку, если таблица не существует
   - Безопасен для многократного вызова
   - Совместим со всеми поддерживаемыми СУБД
   
   **Рекомендации по использованию:**
   
   1. **Для production:**
      
      .. code-block:: python
         
         # Всегда удаляйте временные таблицы
         dbhose = DBHose(..., drop_temp_table=True)
         try:
             dbhose.create_temp()
             # ... операции ...
         finally:
             dbhose.drop_temp()  # Гарантированная очистка
   
   2. **Для разработки/отладки:**
      
      .. code-block:: python
         
         # Оставляйте таблицы для анализа
         dbhose = DBHose(..., drop_temp_table=False)
         dbhose.create_temp()
         # ... анализируйте созданную таблицу ...
         # Удалите вручную когда нужно
         # dbhose.drop_temp_table = True
         # dbhose.drop_temp()
   
   **См. также:**
   
   - :doc:`../methods/create_temp` - Создание временной таблицы
   - :doc:`../classes/dbhose` - Основной класс DBHose
   - :attr:`DBHose.drop_temp_table` - Атрибут управления удалением
   
   **Часто задаваемые вопросы:**
   
   .. dropdown:: Что делать, если метод не удаляет таблицу?
      
      Проверьте:
      
      1. Значение ``drop_temp_table`` (должно быть ``True``)
      2. Существование таблицы ``table_temp``
      3. Права доступа пользователя БД
      4. Логи на наличие ошибок
      
      Для принудительного удаления:
      
      .. code-block:: python
         
         dbhose.drop_temp_table = True
         dbhose.drop_temp()
   
   .. dropdown:: Как узнать, была ли таблица удалена?
      
      Проверьте логи:
      
      .. code-block:: text
         
         # При успешном удалении
         INFO:root:Table <название>_temp dropped
         
         # При пропуске удаления  
         WARNING:root:Drop temp table operation skipped by user
   
   .. dropdown:: Можно ли восстановить удаленную таблицу?
      
      Нет, ``DROP TABLE`` удаляет таблицу безвозвратно.
      Для возможности восстановления используйте:
      
      - Переименование вместо удаления
      - Резервное копирование перед удалением
      - Транзакции с откатом для PostgreSQL
