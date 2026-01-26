floats
======

Модуль для работы с вещественными типами данных в Native формате.

**Поддерживаемые типы:**

- ``BFloat16``
- ``Float32``
- ``Float64``

read_bfloat16
-------------

.. py:function:: read_bfloat16(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :param length: Размер типа (16)
   :type length: int
   :return: Вещественное число
   :rtype: float

   Чтение BFloat16 (brain floating point) из Native формата.

write_bfloat16
--------------

.. py:function:: write_bfloat16(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: Вещественное число
   :type dtype_value: float
   :param length: Размер типа (16)
   :type length: int
   :return: Байтовое представление
   :rtype: bytes

   Запись BFloat16 в Native формат.

read_float
----------

.. py:function:: read_float(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :param length: Размер типа (32 или 64)
   :type length: int
   :return: Вещественное число
   :rtype: float

   Чтение Float32/Float64 из Native формата.

write_float
-----------

.. py:function:: write_float(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: Вещественное число
   :type dtype_value: float
   :param length: Размер типа (32 или 64)
   :type length: int
   :return: Байтовое представление
   :rtype: bytes

   Запись Float32/Float64 в Native формат.

**Особенности:**

Точное сохранение IEEE 754 формата для всех типов с плавающей точкой.
