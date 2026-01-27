make_columns
============

.. py:function:: make_columns(column_list)

   :param column_list: Список колонок ClickHouse
   :type column_list: list[Column]
   :return: Словарь {имя_колонки: тип_данных}
   :rtype: OrderedDict[str, str]

   Форматирует типы данных колонок ClickHouse для отображения.

**Описание:**

Преобразует список колонок ClickHouse в упорядоченный словарь, дополняя
специфичные типы данных (FixedString, Decimal и др.) их параметрами.

**Пример преобразования:**

.. code-block:: python

    # Column(name="price", dtype="Decimal", info=DecimalInfo(precision=10, scale=2))
    # → "price": "Decimal(10, 2)"

**Поддерживаемые типы:**

- FixedString
- Decimal
- DateTime64
- Enum8
- Enum16
- Time64
