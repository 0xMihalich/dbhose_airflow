arrays
======

Модуль для работы с массивами в бинарном формате PostgreSQL/Greenplum.

**Поддерживаемые типы:**

Все типы с префиксом `_` (например, `_int4`, `_text`).

read_array
----------

.. py:function:: read_array(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные массива
   :type binary_data: bytes
   :param pgoid_function: Функция для определения типа элементов
   :type pgoid_function: object
   :param buffer_object: Объект буфера
   :type buffer_object: object
   :param pgoid: OID типа элементов массива
   :type pgoid: int
   :return: Список значений
   :rtype: list[Any]

   Распаковка массива любого типа из бинарного формата PostgreSQL/Greenplum.

   **Особенности:**

   - Поддерживает многомерные массивы
   - Определяет размерность массива из заголовка
   - Рекурсивно вызывает соответствующие функции чтения для элементов

write_array
-----------

.. py:function:: write_array(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: Список значений
   :type dtype_value: list[Any]
   :param pgoid_function: Функция для определения типа элементов
   :type pgoid_function: object
   :param buffer_object: Объект буфера
   :type buffer_object: object
   :param pgoid: OID типа элементов массива
   :type pgoid: int
   :return: Байтовое представление массива
   :rtype: bytes

   Упаковка массива любого типа в бинарный формат PostgreSQL/Greenplum.

   **Особенности:**

   - Определяет размерность входного списка
   - Генерирует корректный заголовок массива
   - Рекурсивно вызывает соответствующие функции записи для элементов

**Примечание:**

Функции автоматически определяют тип элементов массива по OID и используют соответствующие функции чтения/записи.
