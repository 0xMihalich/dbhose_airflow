ipaddrs
=======

Модуль для работы с сетевыми адресами в бинарном формате PostgreSQL/Greenplum.

**Поддерживаемые типы:**

- ``inet`` (IPv4 и IPv6)
- ``cidr`` (IPv4 и IPv6)

read_network
------------

.. py:function:: read_network(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: IP-адрес или сеть
   :rtype: IPv4Address | IPv4Network | IPv6Address | IPv6Network

   Распаковка значений типов ``inet`` (адрес) или ``cidr`` (сеть) из бинарного формата.

   **Определение типа:**

   - ``inet`` → ``IPv4Address`` или ``IPv6Address``
   - ``cidr`` → ``IPv4Network`` или ``IPv6Network``

write_network
-------------

.. py:function:: write_network(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: IP-адрес или сеть
   :type dtype_value: IPv4Address | IPv4Network | IPv6Address | IPv6Network
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значений типов ``inet`` или ``cidr`` в бинарный формат.

   **Автоматическое определение:**

   - ``IPv4Address``/``IPv6Address`` → ``inet``
   - ``IPv4Network``/``IPv6Network`` → ``cidr``

**Особенности:**

- Поддержка как IPv4, так и IPv6 адресов
- Автоматическое определение типа (адрес/сеть)
- Сохранение маски сети для ``cidr``
- Валидация корректности адресов
