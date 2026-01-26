uuids
=====

Модуль для работы с UUID в бинарном формате PostgreSQL/Greenplum.

**Поддерживаемые типы:**

- ``uuid``

read_uuid
---------

.. py:function:: read_uuid(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные (16 байт)
   :type binary_data: bytes
   :return: UUID объект
   :rtype: UUID

   Распаковка значения типа ``uuid`` из бинарного формата PostgreSQL/Greenplum.

   **Особенности:**

   - Ожидает ровно 16 байт входных данных
   - Сохраняет порядок байтов (big-endian) как в PostgreSQL/Greenplum
   - Валидирует корректность UUID

write_uuid
----------

.. py:function:: write_uuid(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: UUID объект
   :type dtype_value: UUID
   :return: 16-байтовое представление
   :rtype: bytes

   Упаковка значения типа ``uuid`` в бинарный формат PostgreSQL/Greenplum.

   **Особенности:**

   - Генерирует ровно 16 байт выходных данных
   - Сохраняет порядок байтов (big-endian)
   - Поддерживает любой валидный UUID

**Использование:**

Для работы с уникальными идентификаторами в миграциях и ETL процессах.
