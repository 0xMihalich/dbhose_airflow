enums
=====

Модуль для работы с перечислимыми типами (Enum) в Native формате.

**Поддерживаемые типы:**

``Enum8`` (1 байт), ``Enum16`` (2 байта).

**Особенности:**

Хранит соответствие целочисленных значений строковым константам.

read_enum
---------

.. py:function:: read_enum(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :param length: Длина типа (8 или 16)
   :type length: int
   :param enumcase: Словарь {число: строка}
   :type enumcase: dict[int, str] | None
   :return: Строковое значение enum
   :rtype: str

   Чтение Enum8/Enum16 из Native формата.

write_enum
----------

.. py:function:: write_enum(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: Значение enum
   :type dtype_value: int | str | Enum
   :param length: Длина типа (8 или 16)
   :type length: int
   :param enumcase: Словарь {число: строка}
   :type enumcase: dict[int, str] | None
   :return: Байтовое представление
   :rtype: bytes

   Запись Enum8/Enum16 в Native формат.

**Примечание:**

Может принимать значения как в виде строк, так и целых чисел.
