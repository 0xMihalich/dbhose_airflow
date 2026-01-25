decimals
========

Модуль для работы с десятичными типами (Decimal) в Native формате.

**Особенности реализации:**

Все Decimal в ClickHouse хранятся как целые числа со знаком:

- ``P ∈ [1:9]`` → ``Int32``
- ``P ∈ [10:18]`` → ``Int64``
- ``P ∈ [19:38]`` → ``Int128``
- ``P ∈ [39:76]`` → ``Int256``

Для преобразования в Decimal: ``целое_число / 10^S``.

read_decimal
------------

.. py:function:: read_decimal(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :param precision: Точность (P)
   :type precision: int
   :param scale: Масштаб (S)
   :type scale: int
   :return: Десятичное число
   :rtype: Decimal

   Чтение Decimal(P, S) из Native формата.

write_decimal
-------------

.. py:function:: write_decimal(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: Десятичное число
   :type dtype_value: Decimal
   :param precision: Точность (P)
   :type precision: int
   :param scale: Масштаб (S)
   :type scale: int
   :return: Байтовое представление
   :rtype: bytes

   Запись Decimal(P, S) в Native формат.

**Примечание:**

Гарантирует точное хранение десятичных дробей без потери данных.
