strings
=======

Модуль для работы со строковыми типами в Native формате.

**Поддерживаемые типы:** ``String``, ``FixedString(N)``.

**Особенности:**

- ``String`` - строки переменной длины с кодировкой UTF-8
- ``FixedString(N)`` - строки фиксированной длины, дополненные нулевыми байтами

read_string
-----------

.. py:function:: read_string(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :param length: Длина для FixedString (None для String)
   :type length: int | None
   :return: Строка в UTF-8
   :rtype: str

   Чтение String/FixedString из Native формата.

write_string
------------

.. py:function:: write_string(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: Строка
   :type dtype_value: str
   :param length: Длина для FixedString (None для String)
   :type length: int | None
   :return: Байтовое представление в UTF-8
   :rtype: bytes

   Запись String/FixedString в Native формат.

**Примечание:**

Корректная обработка Unicode и управляющих символов.
