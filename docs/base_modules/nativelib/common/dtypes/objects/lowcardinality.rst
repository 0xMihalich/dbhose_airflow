LowCardinality
==============

.. py:class:: LowCardinality(
    fileobj,
    dtype,
    is_nullable,
    total_rows=0,
   )

   :param fileobj: Файловый объект для чтения/записи
   :type fileobj: BufferedReader
   :param dtype: Базовый тип данных
   :type dtype: DType
   :param is_nullable: Флаг Nullable типа
   :type is_nullable: bool
   :param total_rows: Общее количество строк
   :type total_rows: int

   Класс для работы с LowCardinality типами в Native формате.

**Описание:**

Обрабатывает оптимизированные LowCardinality типы ClickHouse, которые хранят
словарь уникальных значений для эффективного сжатия строк и повторяющихся данных.

**Поддерживаемые типы:**

- ``String``
- ``FixedString``
- ``Date``
- ``DateTime``
- ``Любые числовые типы`` (кроме Decimal)

**Алгоритм чтения:**

1. Пропуск 16-байтного заголовка
2. Чтение количества уникальных элементов (UInt64)
3. Определение размера индекса (UInt8/16/32/64)
4. Чтение словаря уникальных значений
5. Чтение индексов строк и преобразование в значения

**Атрибуты:**

.. py:attribute:: dictionary
   :type: list[Any]

   Словарь уникальных значений.

.. py:attribute:: index_elements
   :type: list[Any]

   Индексы строк для преобразования.

.. py:attribute:: index_size
   :type: int

   Размер индекса в байтах.

**Методы:**

.. py:method:: skip()

   Пропуск чтения LowCardinality колонки.

.. py:method:: read()

   :return: Список значений колонки
   :rtype: list[Any]

   Чтение всех значений с преобразованием через словарь.

.. py:method:: write(dtype_value)

   :param dtype_value: Значение для записи
   :type dtype_value: Any
   :return: Количество записанных байт
   :rtype: int

   Запись значения с обновлением словаря.

.. py:method:: tell()

   :return: Размер данных
   :rtype: int

   Получение текущего размера.

.. py:method:: clear()

   :return: Собранные данные колонки
   :rtype: bytes

   Извлечение данных и очистка буферов.

**Примечание:**

Первый элемент словаря всегда содержит значение по умолчанию для выбранного типа данных.
