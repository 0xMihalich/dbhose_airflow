MoveMethod
==========

.. py:class:: MoveMethod

   Методы перемещения данных из временной в целевую таблицу.

   .. py:data:: append

      Простое добавление. Все данные добавляются без условий.
      **Атрибуты:** name="append", have_sql=False, need_filter=False, is_custom=False

   .. py:data:: delete

      Удаление с фильтрацией. Заменяет определенные строки.
      **Атрибуты:** name="delete", have_sql=True, need_filter=True, is_custom=False

   .. py:data:: replace

      Полная замена. Заменяет все данные в таблице.
      **Атрибуты:** name="replace", have_sql=True, need_filter=False, is_custom=False

   .. py:data:: rewrite

      Пересоздание. Удаляет и создает таблицу заново.
      **Атрибуты:** name="rewrite", have_sql=False, need_filter=False, is_custom=False

   .. py:data:: custom

      Пользовательский. Требует реализации в коде.
      **Атрибуты:** name="custom", have_sql=False, need_filter=False, is_custom=True

.. tabularcolumns:: |l|c|c|c|p{8cm}|

.. table:: Сравнение методов
   :widths: 15 10 10 10 55

   +------------+------+-----------+--------+----------------------------------------+
   | Метод      | SQL  | Фильтрация| Custom | Описание                               |
   +============+======+===========+========+========================================+
   | **append** | ❌   | ❌        | ❌     | Простое добавление всех данных        |
   +------------+------+-----------+--------+----------------------------------------+
   | **delete** | ✅   | ✅        | ❌     | Удаление строк по фильтру + вставка   |
   +------------+------+-----------+--------+----------------------------------------+
   | **replace**| ✅   | ❌        | ❌     | Полная замена данных в таблице        |
   +------------+------+-----------+--------+----------------------------------------+
   | **rewrite**| ❌   | ❌        | ❌     | Удаление и пересоздание таблицы       |
   +------------+------+-----------+--------+----------------------------------------+
   | **custom** | ❌   | ❌        | ✅     | Пользовательская реализация           |
   +------------+------+-----------+--------+----------------------------------------+

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
