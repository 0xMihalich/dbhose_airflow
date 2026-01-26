PGParam
=======

.. py:class:: PGParam(length, scale, nested)

   :param length: Длина параметра
   :type length: int
   :param scale: Масштаб (для числовых типов)
   :type scale: int
   :param nested: Уровень вложенности (для массивов)
   :type nested: int

   Параметры типа данных PostgreSQL.

**Описание:**

Именованный кортеж для хранения дополнительных параметров типов данных
PostgreSQL, которые не могут быть выражены только через OID.

**Поля:**

- ``length`` - длина для строк фиксированной длины, точность для numeric
- ``scale`` - масштаб для типов numeric (количество знаков после запятой)
- ``nested`` - уровень вложенности для массивов (0 для скаляров, 1 для одномерных массивов и т.д.)

**Примеры использования:**

- ``numeric(10, 2)`` → ``PGParam(length=10, scale=2, nested=0)``
- ``varchar(255)`` → ``PGParam(length=255, scale=0, nested=0)``
- ``_int4[]`` → ``PGParam(length=0, scale=0, nested=2)``

**Использование:**

В метаданных PGPack формата для точного описания структуры колонок.
