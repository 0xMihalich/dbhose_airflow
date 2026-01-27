search_object
=============

.. py:function:: search_object(table, query="")

   :param table: Имя таблицы или выражение
   :type table: str
   :param query: SQL-запрос
   :type query: str
   :return: Описание объекта для логирования
   :rtype: str

**Описание:**

Определяет строковое представление объекта для логирования.

**Возвращаемые значения:**

- ``"query"`` - если указан query (любое непустое значение)
- Имя таблицы - если table имеет формат ``"(select * from ...)"``
- Исходное значение table - в остальных случаях
