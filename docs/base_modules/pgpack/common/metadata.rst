metadata
========

Модуль для работы с метаданными в формате PGPack.

metadata_reader
---------------

.. py:function:: metadata_reader(metadata)

   :param metadata: Распакованные метаданные в формате JSON
   :type metadata: bytes
   :return: Кортеж (имена_колонок, OID_типы, параметры_типов)
   :rtype: tuple[list[str], list[PGOid], list[PGParam]]

   Чтение и разбор метаданных из JSON формата.

**Описание:**

Преобразует бинарные метаданные (после распаковки zlib) в структурированную
информацию о таблице: имена колонок, типы данных PostgreSQL и их параметры.

**Формат входных данных:**

.. code-block:: python

    [
        [column_number, [column_name, oid, length, scale, nested]],
        ...
    ]

**Выходные данные:**

1. Список имен колонок в правильном порядке
2. Список OID типов данных для каждой колонки
3. Список параметров типов (PGParam) для каждой колонки

metadata_from_frame
-------------------

.. py:function:: metadata_from_frame(frame)

   :param frame: DataFrame pandas или polars
   :type frame: PdFrame | PlFrame
   :return: Сериализованные метаданные в формате JSON
   :rtype: bytes

   Генерация метаданных из DataFrame.

**Описание:**

Анализирует структуру DataFrame и создает метаданные PGPack, определяя
соответствующие типы данных PostgreSQL для каждой колонки.

**Алгоритм работы:**

1. Для каждой колонки DataFrame определяет соответствующий OID PostgreSQL
2. Определяет параметры типов (длина, масштаб, вложенность)
3. Сериализует в JSON формат с кодировкой UTF-8

**Использование:**

Для автоматического создания метаданных при экспорте данных из pandas/polars в PGPack формат.
