dates
=====

Модуль для работы с временными типами данных в Native формате ClickHouse.

**Поддерживаемые типы:**

- ``Date``
- ``Date32``
- ``DateTime``
- ``DateTime64``
- ``Time``
- ``Time64``

read_date
---------

.. py:function:: read_date(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :return: Дата
   :rtype: date

   Чтение Date из Native формата.

write_date
----------

.. py:function:: write_date(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: Значение даты
   :type dtype_value: date | datetime | Timestamp
   :return: Байтовое представление
   :rtype: bytes

   Запись Date в Native формат.

read_date32
-----------

.. py:function:: read_date32(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :return: Дата
   :rtype: date

   Чтение Date32 из Native формата.

write_date32
------------

.. py:function:: write_date32(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: Значение даты
   :type dtype_value: date | datetime | Timestamp
   :return: Байтовое представление
   :rtype: bytes

   Запись Date32 в Native формат.

read_datetime
-------------

.. py:function:: read_datetime(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :return: Дата и время
   :rtype: datetime

   Чтение DateTime из Native формата.

write_datetime
--------------

.. py:function:: write_datetime(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: Значение даты и времени
   :type dtype_value: date | datetime | Timestamp
   :return: Байтовое представление
   :rtype: bytes

   Запись DateTime в Native формат.

read_datetime64
---------------

.. py:function:: read_datetime64(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :return: Дата и время с наносекундами
   :rtype: datetime

   Чтение DateTime64 из Native формата.

write_datetime64
----------------

.. py:function:: write_datetime64(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: Значение даты и времени
   :type dtype_value: date | datetime | Timestamp
   :return: Байтовое представление
   :rtype: bytes

   Запись DateTime64 в Native формат.

read_time
---------

.. py:function:: read_time(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :return: Интервал времени
   :rtype: timedelta

   Чтение Time из Native формата.

write_time
----------

.. py:function:: write_time(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: Интервал времени
   :type dtype_value: timedelta | time
   :return: Байтовое представление
   :rtype: bytes

   Запись Time в Native формат.

read_time64
-----------

.. py:function:: read_time64(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :return: Интервал времени с наносекундами
   :rtype: timedelta

   Чтение Time64 из Native формата.

write_time64
------------

.. py:function:: write_time64(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: Интервал времени
   :type dtype_value: timedelta | time
   :return: Байтовое представление
   :rtype: bytes

   Запись Time64 в Native формат.

**Особенности:**

Поддержка временных зон, наносекундной точности и преобразования между pandas Timestamp.
