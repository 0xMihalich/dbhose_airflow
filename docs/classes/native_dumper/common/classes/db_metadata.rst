DBMetadata
==========

.. py:class:: DBMetadata(name, version, columns)

   :param name: Название базы данных или источника
   :type name: str
   :param version: Версия базы данных
   :type version: str
   :param columns: Колонки с типами данных
   :type columns: OrderedDict[str, str]

   Метаданные базы данных для отображения в диаграммах передачи.

**Описание:**

Именованный кортеж, хранящий информацию о структуре базы данных или источника.
Используется для генерации информационных сообщений о передаче данных.

**Пример:**

.. code-block:: python

    meta = DBMetadata(
        name="postgresql",
        version="15.0",
        columns=OrderedDict([("id", "integer"), ("name", "text")])
    )

**Использование:** В методах ``from_rows``, ``from_pandas``, ``from_polars``.
