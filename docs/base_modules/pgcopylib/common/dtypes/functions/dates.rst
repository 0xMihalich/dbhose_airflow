dates
=====

Модуль для работы с временными типами данных в бинарном формате PostgreSQL/Greenplum.

**Поддерживаемые типы:**

- ``date``
- ``timestamp``
- ``timestamptz``
- ``time``
- ``timetz``
- ``interval``

read_date
---------

.. py:function:: read_date(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Дата
   :rtype: date

   Распаковка значения типа ``date`` из бинарного формата.

write_date
----------

.. py:function:: write_date(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Значение даты
   :type dtype_value: date
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``date`` в бинарный формат.

read_timestamp
--------------

.. py:function:: read_timestamp(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Дата и время
   :rtype: datetime

   Распаковка значения типа ``timestamp`` из бинарного формата.

write_timestamp
---------------

.. py:function:: write_timestamp(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Значение даты и времени
   :type dtype_value: datetime
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``timestamp`` в бинарный формат.

read_timestamptz
----------------

.. py:function:: read_timestamptz(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Дата и время с часовым поясом
   :rtype: datetime

   Распаковка значения типа ``timestamptz`` из бинарного формата.

write_timestamptz
-----------------

.. py:function:: write_timestamptz(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Значение даты и времени с часовым поясом
   :type dtype_value: datetime
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``timestamptz`` в бинарный формат.

read_time
---------

.. py:function:: read_time(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Время
   :rtype: time

   Распаковка значения типа ``time`` из бинарного формата.

write_time
----------

.. py:function:: write_time(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Значение времени
   :type dtype_value: time | timedelta
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``time`` в бинарный формат.

read_timetz
-----------

.. py:function:: read_timetz(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Время с часовым поясом
   :rtype: time

   Распаковка значения типа ``timetz`` из бинарного формата.

write_timetz
------------

.. py:function:: write_timetz(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Значение времени с часовым поясом
   :type dtype_value: time | timedelta
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``timetz`` в бинарный формат.

read_interval
-------------

.. py:function:: read_interval(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Интервал времени
   :rtype: relativedelta

   Распаковка значения типа ``interval`` из бинарного формата.

write_interval
--------------

.. py:function:: write_interval(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Значение интервала
   :type dtype_value: relativedelta
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``interval`` в бинарный формат.

**Примечание:**

Для типа ``interval`` требуется ``dateutil.relativedelta``.
