pandas_astype
=============

.. py:function:: pandas_astype(column_list)

   :param column_list: Список колонок ClickHouse
   :type column_list: list[Column]
   :return: Словарь соответствий для pandas
   :rtype: dict[str, str | None]

   Генерация типов данных pandas из структуры ClickHouse.

Импорт модуля (внутренняя функция, написано только как пример)
--------------------------------------------------------------

.. code-block:: python

    from nativelib.common import pandas_astype

**Описание:**

Преобразует типы данных колонок ClickHouse в соответствующие типы pandas
для корректного создания DataFrame. Используется при конвертации данных
из Native формата в pandas структуры.

**Возвращает:**

Словарь, где ключ - имя колонки, значение - pandas dtype или ``None``.
