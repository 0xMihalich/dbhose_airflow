ClickhouseDtype
===============

.. py:class:: ClickhouseDtype

   Перечисление типов данных ClickHouse с привязанными функциями чтения/записи.

**Описание:**

Enum, ассоциирующий каждый тип данных ClickHouse с:

1. Именем типа в ClickHouse
2. Соответствующим типом Python
3. Функцией чтения из Native формата
4. Функцией записи в Native формат

**Структура DTypeFunc:**

.. py:class:: DTypeFunc(name, pytype, read, write)

   :param name: Имя типа в ClickHouse
   :type name: str
   :param pytype: Соответствующий тип Python
   :type pytype: type
   :param read: Функция чтения
   :type read: FunctionType
   :param write: Функция записи
   :type write: FunctionType

**Пример использования:**

.. code-block:: python

    dtype = ClickhouseDtype.Int32
    print(dtype.name)      # "Int32"
    print(dtype.pytype)    # <class 'int'>
    value = dtype.read(fileobj, 32, None, None, None, None)
    bytes_data = dtype.write(42, 32, None, None, None, None)

**Назначение:**

Централизованное управление функциями сериализации/десериализации для всех поддерживаемых типов данных.
