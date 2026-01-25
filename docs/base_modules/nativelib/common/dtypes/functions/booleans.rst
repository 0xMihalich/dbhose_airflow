booleans
========

Модуль для работы с логическими типами и Nothing в Native формате.

read_bool
---------

.. py:function:: read_bool(
    fileobj,
    length=None,
    precision=None,
    scale=None,
    tzinfo=None,
    enumcase=None,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :return: Логическое значение
   :rtype: bool

   Чтение Bool/Nullable(Bool) из Native формата.

write_bool
----------

.. py:function:: write_bool(
    dtype_value,
    length=None,
    precision=None,
    scale=None,
    tzinfo=None,
    enumcase=None,
   )

   :param dtype_value: Логическое значение
   :type dtype_value: bool
   :return: Байтовое представление
   :rtype: bytes

   Запись Bool/Nullable(Bool) в Native формат.

read_nothing
------------

.. py:function:: read_nothing(
    fileobj,
    length=None,
    precision=None,
    scale=None,
    tzinfo=None,
    enumcase=None,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :return: None
   :rtype: None

   Чтение Nullable(Nothing) из Native формата.

write_nothing
-------------

.. py:function:: write_nothing(
    dtype_value,
    length=None,
    precision=None,
    scale=None,
    tzinfo=None,
    enumcase=None,
   )

   :param dtype_value: None
   :type dtype_value: NoneType
   :return: Байтовое представление
   :rtype: bytes

   Запись Nullable(Nothing) в Native формат.

**Использование:**

Обработка логических и пустых значений в ClickHouse.
