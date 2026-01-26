geometrics
==========

Модуль для работы с геометрическими типами данных в бинарном формате PostgreSQL/Greenplum.

**Поддерживаемые типы:**

- ``point``
- ``line``
- ``lseg``
- ``box``
- ``path``
- ``polygon``
- ``circle``

read_point
----------

.. py:function:: read_point(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Точка (x, y)
   :rtype: tuple[float, float]

   Распаковка значения типа ``point`` из бинарного формата.

write_point
-----------

.. py:function:: write_point(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Точка (x, y)
   :type dtype_value: tuple[float, float]
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``point`` в бинарный формат.

read_line
---------

.. py:function:: read_line(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Прямая (A, B, C)
   :rtype: tuple[float, float, float]

   Распаковка значения типа ``line`` из бинарного формата.

write_line
----------

.. py:function:: write_line(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Прямая (A, B, C)
   :type dtype_value: tuple[float, float, float]
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``line`` в бинарный формат.

read_lseg
---------

.. py:function:: read_lseg(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Отрезок [(x1, y1), (x2, y2)]
   :rtype: list[tuple[float, float], tuple[float, float]]

   Распаковка значения типа ``lseg`` из бинарного формата.

write_lseg
----------

.. py:function:: write_lseg(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Отрезок [(x1, y1), (x2, y2)]
   :type dtype_value: list[tuple[float, float], tuple[float, float]]
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``lseg`` в бинарный формат.

read_box
--------

.. py:function:: read_box(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Прямоугольник ((x1, y1), (x2, y2))
   :rtype: tuple[tuple[float, float], tuple[float, float]]

   Распаковка значения типа ``box`` из бинарного формата.

write_box
---------

.. py:function:: write_box(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Прямоугольник ((x1, y1), (x2, y2))
   :type dtype_value: tuple[tuple[float, float], tuple[float, float]]
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``box`` в бинарный формат.

read_path
---------

.. py:function:: read_path(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Путь (замкнутый/открытый)
   :rtype: list[tuple[float, ...]] | tuple[tuple[float, ...]]

   Распаковка значения типа ``path`` из бинарного формата.

write_path
----------

.. py:function:: write_path(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Путь (замкнутый/открытый)
   :type dtype_value: list[tuple[float, ...]] | tuple[tuple[float, ...]]
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``path`` в бинарный формат.

read_polygon
------------

.. py:function:: read_polygon(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Многоугольник
   :rtype: tuple[float, ...]

   Распаковка значения типа ``polygon`` из бинарного формата.

write_polygon
-------------

.. py:function:: write_polygon(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Многоугольник
   :type dtype_value: tuple[float, ...]
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значения типа ``polygon`` в бинарный формат.

**Примечание:**

Тип ``circle`` использует функции ``read_line`` / ``write_line``.
