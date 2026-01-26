make_columns
============

.. py:function:: make_columns(list_columns, pgtypes, pgparam)

   :param list_columns: Список имен колонок
   :type list_columns: list[str]
   :param pgtypes: Список типов данных PGOid
   :type pgtypes: list[PGOid]
   :param pgparam: Список параметров типов PGParam
   :type pgparam: list[PGParam]
   :return: Упорядоченный словарь "имя_колонки: тип_данных"
   :rtype: OrderedDict[str, str]

**Описание:**

Создает упорядоченный словарь колонок для ``DBMetadata.columns`` с учетом 
специфичных параметров типов данных PostgreSQL.

**Обработка типов:**

* ``bpchar`` - добавляет длину: ``bpchar(length)``
* ``numeric`` - добавляет точность и масштаб: ``numeric(length, scale)``
* Остальные типы - используются как есть
