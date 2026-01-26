uuids
=====

Модуль для работы с UUID в Native формате.

**Поддерживаемый тип:**

- ``UUID`` (Universally Unique Identifier)

**Особенности:**

Хранит UUID в 16-байтовом бинарном формате согласно RFC 4122.

read_uuid
---------

.. py:function:: read_uuid(
    fileobj,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :return: UUID объект
   :rtype: UUID

   Чтение UUID из Native формата.

write_uuid
----------

.. py:function:: write_uuid(
    dtype_value,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
   )

   :param dtype_value: UUID объект
   :type dtype_value: UUID
   :return: 16-байтовое представление
   :rtype: bytes

   Запись UUID в Native формат.

**Примечание:**

Сохраняет порядок байтов (big-endian) как в ClickHouse.
