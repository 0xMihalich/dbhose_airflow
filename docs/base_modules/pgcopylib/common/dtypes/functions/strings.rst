strings
=======

Модуль для работы со строковыми и бинарными типами данных в бинарном формате PostgreSQL/Greenplum.

**Поддерживаемые типы:**

- текстовые
- MAC-адреса
- битовые строки
- бинарные данные

read_text
---------

.. py:function:: read_text(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Текстовая строка
   :rtype: str

   Распаковка текстовых типов (``text``, ``varchar``, ``bpchar``, ``char``, ``xml``) из бинарного формата.

write_text
----------

.. py:function:: write_text(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Текстовая строка
   :type dtype_value: str
   :return: Байтовое представление в UTF-8
   :rtype: bytes

   Упаковка текстовых типов в бинарный формат.

read_macaddr
------------

.. py:function:: read_macaddr(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: MAC-адрес в формате строки
   :rtype: str

   Распаковка типов ``macaddr`` (6 байт) и ``macaddr8`` (8 байт) из бинарного формата.

write_macaddr
-------------

.. py:function:: write_macaddr(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: MAC-адрес в формате строки
   :type dtype_value: str
   :return: Байтовое представление
   :rtype: bytes

   Упаковка типов ``macaddr`` или ``macaddr8`` в бинарный формат.

read_bits
---------

.. py:function:: read_bits(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Битовая строка
   :rtype: str

   Распаковка типов ``bit`` (фиксированной длины) и ``varbit`` (переменной длины) из бинарного формата.

write_bits
----------

.. py:function:: write_bits(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Битовая строка
   :type dtype_value: str
   :return: Байтовое представление
   :rtype: bytes

   Упаковка типов ``bit`` или ``varbit`` в бинарный формат.

read_bytea
----------

.. py:function:: read_bytea(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: Бинарные данные
   :rtype: bytes

   Распаковка типа ``bytea`` из бинарного формата (с учетом escape-последовательностей).

write_bytea
-----------

.. py:function:: write_bytea(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Бинарные данные
   :type dtype_value: bytes
   :return: Байтовое представление с escape-последовательностями
   :rtype: bytes

   Упаковка типа ``bytea`` в бинарный формат.

**Особенности:**

Правильная обработка escape-последовательностей для ``bytea`` и кодировок для текстовых типов.
