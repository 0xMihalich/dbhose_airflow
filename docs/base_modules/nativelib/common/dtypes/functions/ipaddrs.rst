ipaddrs
=======

Модуль для работы с IP-адресами в Native формате.

**Поддерживаемые типы:**

``IPv4Address``, ``IPv6Address``.

**Особенности:**

Хранит IP-адреса в компактном бинарном формате ClickHouse.

read_ipv4
---------

.. py:function:: read_ipv4(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :return: IPv4 адрес
   :rtype: IPv4Address

   Чтение IPv4 адреса из Native формата.

write_ipv4
----------

.. py:function:: write_ipv4(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: IPv4 адрес
   :type dtype_value: IPv4Address
   :return: Байтовое представление
   :rtype: bytes

   Запись IPv4 адреса в Native формат.

read_ipv6
---------

.. py:function:: read_ipv6(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :return: IPv6 адрес
   :rtype: IPv6Address

   Чтение IPv6 адреса из Native формата.

write_ipv6
----------

.. py:function:: write_ipv6(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: IPv6 адрес
   :type dtype_value: IPv6Address
   :return: Байтовое представление
   :rtype: bytes

   Запись IPv6 адреса в Native формат.

**Примечание:**

Сохраняет полную семантику IP-адресов, включая валидацию и преобразование форматов.
