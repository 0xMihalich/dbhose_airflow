integers
========

Модуль для работы с целочисленными типами в Native формате.

**Поддерживаемые типы:**

- ``Int8``
- ``Int16``
- ``Int32``
- ``Int64``
- ``Int128``
- ``Int256``
- ``UInt8``
- ``UInt16``
- ``UInt32``
- ``UInt64``
- ``UInt128``
- ``UInt256``

read_int
--------

.. py:function:: read_int(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :param length: Размер типа в битах
   :type length: int
   :return: Знаковое целое число
   :rtype: int

   Чтение знакового целого числа из Native формата.

write_int
---------

.. py:function:: write_int(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: Знаковое целое число
   :type dtype_value: int
   :param length: Размер типа в битах
   :type length: int
   :return: Байтовое представление
   :rtype: bytes

   Запись знакового целого числа в Native формат.

read_uint
---------

.. py:function:: read_uint(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :param length: Размер типа в битах
   :type length: int
   :return: Беззнаковое целое число
   :rtype: int

   Чтение беззнакового целого числа из Native формата.

write_uint
----------

.. py:function:: write_uint(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: Беззнаковое целое число
   :type dtype_value: int
   :param length: Размер типа в битах
   :type length: int
   :return: Байтовое представление
   :rtype: bytes

   Запись беззнакового целого числа в Native формат.

r_uint
------

.. py:function:: r_uint(fileobj, length)

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :param length: Размер типа в битах
   :type length: int
   :return: Беззнаковое целое число
   :rtype: int

   Cython-оптимизированное чтение беззнакового целого.

w_uint
------

.. py:function:: w_uint(dtype_value, length)

   :param dtype_value: Беззнаковое целое число
   :type dtype_value: int
   :param length: Размер типа в битах
   :type length: int
   :return: Байтовое представление
   :rtype: bytes

   Cython-оптимизированная запись беззнакового целого.

**Особенности:**

Поддержка больших целых чисел (до 256 бит) и оптимизация через Cython.
