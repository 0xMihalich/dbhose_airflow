base
====

Базовые функции для работы с бинарным форматом PostgreSQL COPY.

**Описание:**

Низкоуровневые функции для чтения и записи структурированных данных в формате
PostgreSQL COPY binary. Обеспечивают работу с заголовками, записями и типами данных.

read_num_columns
----------------

.. py:function:: read_num_columns(fileobj, column_length)

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :param column_length: Длина колонки
   :type column_length: int
   :return: Количество колонок
   :rtype: int

   Чтение количества колонок из заголовка бинарного формата.

read_record
-----------

.. py:function:: read_record(fileobj, reader, pgoid_function, buffer_object, pgoid)

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :param reader: Функция чтения типа данных
   :type reader: object
   :param pgoid_function: Функция преобразования OID
   :type pgoid_function: object
   :param buffer_object: Объект буфера
   :type buffer_object: object
   :param pgoid: OID типа данных PostgreSQL
   :type pgoid: int
   :return: Прочитанная запись
   :rtype: Any

   Чтение одной записи (строки) из бинарного формата.

skip_all
--------

.. py:function:: skip_all(fileobj, column_length, num_columns, num_rows)

   :param fileobj: Файловый объект
   :type fileobj: BufferedReader
   :param column_length: Длина колонки
   :type column_length: int
   :param num_columns: Количество колонок
   :type num_columns: int
   :param num_rows: Количество строк
   :type num_rows: int
   :return: Размер пропущенных данных
   :rtype: int

   Пропуск всех записей без чтения данных.

writer
------

.. py:function:: writer(fileobj, write_row, dtype_values, num_columns)

   :param fileobj: Файловый объект для записи
   :type fileobj: BufferedReader
   :param write_row: Функция записи строки
   :type write_row: object
   :param dtype_values: Значения для записи
   :type dtype_values: Any
   :param num_columns: Количество колонок
   :type num_columns: int
   :return: Количество записанных байт
   :rtype: int

   Запись данных в бинарный формат PostgreSQL COPY.

nullable_writer
---------------

.. py:function:: nullable_writer(write_dtype, dtype_value, pgoid_function, buffer_object, pgoid)

   :param write_dtype: Функция записи типа данных
   :type write_dtype: object
   :param dtype_value: Значение для записи
   :type dtype_value: Any
   :param pgoid_function: Функция преобразования OID
   :type pgoid_function: object
   :param buffer_object: Объект буфера
   :type buffer_object: object
   :param pgoid: OID типа данных PostgreSQL
   :type pgoid: int
   :return: Байтовое представление с учетом NULL
   :rtype: bytes

   Запись значений с поддержкой NULL для nullable типов.

make_rows
---------

.. py:function:: make_rows(write_row, dtype_values, num_columns)

   :param write_row: Функция записи строки
   :type write_row: object
   :param dtype_values: Значения для записи
   :type dtype_values: Any
   :param num_columns: Количество колонок
   :type num_columns: int
   :return: Генератор байтовых строк
   :rtype: Generator[bytes, None, None]

   Генерация строк в бинарном формате PostgreSQL COPY.

**Использование:**

Как основа для реализации парсеров и сериализаторов формата COPY.
