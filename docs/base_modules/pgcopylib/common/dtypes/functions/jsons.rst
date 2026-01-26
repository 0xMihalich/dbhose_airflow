jsons
=====

Модуль для работы с JSON типами данных в бинарном формате PostgreSQL.

**Поддерживаемые типы:**

- ``json``
- ``jsonb``

read_json
---------

.. py:function:: read_json(binary_data, pgoid_function, buffer_object, pgoid)

   :param binary_data: Бинарные данные
   :type binary_data: bytes
   :return: JSON объект
   :rtype: dict | list | str | int | float | bool | None

   Распаковка значений типов ``json`` или ``jsonb`` из бинарного формата.

   **Особенности:**
   - Автоматическая декодировка UTF-8
   - Поддержка всех JSON типов: объекты, массивы, строки, числа, булевы, null
   - Для ``jsonb`` используется бинарный формат хранения

write_json
----------

.. py:function:: write_json(dtype_value, pgoid_function, buffer_object, pgoid)

   :param dtype_value: JSON значение
   :type dtype_value: dict | list | str | int | float | bool | None
   :return: Байтовое представление
   :rtype: bytes

   Упаковка значений типов ``json`` или ``jsonb`` в бинарный формат.

   **Особенности:**

   - Автоматическая кодировка в UTF-8
   - Валидация структуры JSON
   - Для ``jsonb`` используется оптимизированный бинарный формат

**Примечание:**

Форматы ``json`` и ``jsonb`` различаются внутренним представлением,
но имеют одинаковый интерфейс чтения/записи.
