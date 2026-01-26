digits
======

Модуль для работы с числовыми и логическими типами данных в бинарном формате PostgreSQL/Greenplum.

**Поддерживаемые типы:**

- Логические
- целочисленные
- вещественные
- десятичные числа

read_bool
---------

.. py:function:: read_bool(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Логическое значение
   :rtype: bool

   Распаковка значения типа ``bool`` из бинарного формата.

write_bool
----------

.. py:function:: write_bool(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Логическое значение
   :type dtype_value: bool
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``bool`` в бинарный формат.

read_oid
--------

.. py:function:: read_oid(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: OID (идентификатор объекта)
   :rtype: int

   Распаковка значения типа ``oid`` из бинарного формата.

write_oid
---------

.. py:function:: write_oid(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: OID значение
   :type dtype_value: int
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``oid`` в бинарный формат.

read_int2
---------

.. py:function:: read_int2(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: 16-битное целое число
   :rtype: int

   Распаковка значения типа ``int2`` из бинарного формата.

write_int2
----------

.. py:function:: write_int2(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: 16-битное целое число
   :type dtype_value: int
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``int2`` в бинарный формат.

read_int4
---------

.. py:function:: read_int4(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: 32-битное целое число
   :rtype: int

   Распаковка значения типа ``int4`` из бинарного формата.

write_int4
----------

.. py:function:: write_int4(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: 32-битное целое число
   :type dtype_value: int
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``int4`` в бинарный формат.

read_int8
---------

.. py:function:: read_int8(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: 64-битное целое число
   :rtype: int

   Распаковка значения типа ``int8`` из бинарного формата.

write_int8
----------

.. py:function:: write_int8(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: 64-битное целое число
   :type dtype_value: int
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``int8`` в бинарный формат.

**Примечание:** Аналогичные функции для serial2/4/8 (читаются как int2/4/8).

read_money
----------

.. py:function:: read_money(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Денежное значение
   :rtype: float

   Распаковка значения типа ``money`` из бинарного формата.

write_money
-----------

.. py:function:: write_money(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Денежное значение
   :type dtype_value: float
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``money`` в бинарный формат.

read_float4
-----------

.. py:function:: read_float4(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: 32-битное вещественное число
   :rtype: float

   Распаковка значения типа ``float4`` из бинарного формата.

write_float4
------------

.. py:function:: write_float4(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: 32-битное вещественное число
   :type dtype_value: float
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``float4`` в бинарный формат.

read_float8
-----------

.. py:function:: read_float8(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: 64-битное вещественное число
   :rtype: float

   Распаковка значения типа ``float8`` из бинарного формата.

write_float8
------------

.. py:function:: write_float8(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: 64-битное вещественное число
   :type dtype_value: float
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``float8`` в бинарный формат.

read_numeric
------------

.. py:function:: read_numeric(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Десятичное число
   :rtype: Decimal

   Распаковка значения типа ``numeric`` из бинарного формата.

write_numeric
-------------

.. py:function:: write_numeric(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Десятичное число
   :type dtype_value: Decimal
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``numeric`` в бинарный формат.

**Особенности:**

Сохранение десятичных чисел без потери точности.
