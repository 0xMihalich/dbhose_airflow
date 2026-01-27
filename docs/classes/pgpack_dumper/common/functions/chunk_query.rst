chunk_query
===========

.. py:function:: chunk_query(query)

   :param query: SQL-запрос для разделения
   :type query: str | None
   :return: Кортеж из двух списков запросов
   :rtype: tuple[list[str], list[str]]

   Разделяет мультизапрос на части: до и после SELECT/WITH операций.

**Описание:**

Функция разбивает SQL-запрос, содержащий несколько операторов, на две части:
- ``first_part`` - запросы, выполняемые до основной операции
- ``second_part`` - запросы, выполняемые после основной операции

Разделение происходит по точкам с запятым, с учетом строковых литералов.

**Пример:**

.. code-block:: python

    query = "CREATE TABLE t; SELECT * FROM t; DROP TABLE t"
    first, second = chunk_query(query)
    # first: ["CREATE TABLE t"]
    # second: ["DROP TABLE t"] (SELECT не включается)

**Логика работы:**

1. Разделяет запрос по ``;``, игнорируя точки с запятой внутри кавычек
2. Ищет первую операцию ``SELECT`` или ``WITH``
3. Все до нее - в ``first_part``
4. Все после нее - в ``second_part``
5. Сама операция ``SELECT`` / ``WITH`` не включается ни в одну из частей

**Примечание:**

Используется в декораторе ``@multiquery``.
