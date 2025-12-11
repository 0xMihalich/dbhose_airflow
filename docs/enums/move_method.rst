MoveMethod
==========

.. py:class:: MoveMethod

   Методы перемещения данных из промежуточной таблицы в целевую таблицу

   .. py:data:: append

      Инкрементальная загрузка данных. Данные добавляются без предварительной очистки.

      **Атрибуты:** name="append", have_sql=False, need_filter=False, is_custom=False

   .. py:data:: delete

      Удаление старых записей по фильтрующим колонкам.

      **Атрибуты:** name="delete", have_sql=True, need_filter=True, is_custom=False

   .. py:data:: replace

      Замена партиций (только для партиционированных таблиц).

      **Атрибуты:** name="replace", have_sql=True, need_filter=False, is_custom=False

   .. py:data:: rewrite

      Полная перезапись таблицы.

      **Атрибуты:** name="rewrite", have_sql=False, need_filter=False, is_custom=False

   .. py:data:: custom

      Удаление на основе пользовательского запроса. Требуется SQL запрос.

      **Атрибуты:** name="custom", have_sql=False, need_filter=False, is_custom=True

**Пример использования:**

.. code-block:: python

   from dbhose_airflow import MoveMethod

   # Выбор метода в зависимости от задачи
   if needs_filtering:
       method = MoveMethod.delete
   elif full_refresh:
       method = MoveMethod.rewrite
   else:
       method = MoveMethod.append

   # Использование в DBHoseOperator
   task = DBHoseOperator(
       task_id='transfer_data',
       move_method=method,
       # ... другие параметры
   )

.. note::

    Является внутренним объектом DBHose и не предназначен внешнего использования.
