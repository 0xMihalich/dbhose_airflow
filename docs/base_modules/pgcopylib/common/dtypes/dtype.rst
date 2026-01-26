PostgreSQLDtype
===============

.. py:class:: PostgreSQLDtype

   Перечисление типов данных PostgreSQL/Greenplum с
   привязанными функциями чтения/записи.

**Описание:**

Enum, ассоциирующий каждый тип данных PostgreSQL/Greenplum с:

1. Именем типа в PostgreSQL/Greenplum
2. Соответствующим типом Python
3. Длиной данных в байтах (-1 для переменной длины)
4. Функцией чтения из бинарного формата COPY
5. Функцией записи в бинарный формат COPY

**Структура PGTypeFunc:**

.. py:class:: PGTypeFunc(name, pytype, length, read, write)

   :param name: Имя типа в PostgreSQL/Greenplum
   :type name: str
   :param pytype: Соответствующий тип Python
   :type pytype: type
   :param length: Длина данных в байтах
   :type length: int
   :param read: Функция чтения
   :type read: FunctionType
   :param write: Функция записи
   :type write: FunctionType

**Значения длины:**

- Положительное число: фиксированная длина типа
- ``-1``: переменная длина
- ``16``: UUID, интервал
- ``32``: box, lseg
- ``24``: line, circle

**Пример использования:**

.. code-block:: python

    dtype = PostgreSQLDtype.Int4
    print(dtype.name)      # "Int4"
    print(dtype.pytype)    # <class 'int'>
    print(dtype.length)    # 4
    value = dtype.read(binary_data, None, None, None)
    bytes_data = dtype.write(42, None, None, None)

**Особенности:**

- Объединяет чтение и запись для скалярных типов
- Для массивов использует ``read_array`` / ``write_array``
- Автоматическое определение по OID типа PostgreSQL/Greenplum

**Назначение:**

Централизованное управление функциями сериализации/десериализации
для всех поддерживаемых типов данных PostgreSQL/Greenplum.
