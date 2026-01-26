BlockWriter
===========

.. py:class:: BlockWriter(column_list, max_block_size=DEFAULT_BLOCK_SIZE)

   :param column_list: Список колонок для записи
   :type column_list: list[Column]
   :param max_block_size: Максимальный размер блока
   :type max_block_size: int

   Запись блоков данных в Native формат ClickHouse.

**Описание:**

Формирует блоки данных Native формата, контролируя размер каждого блока согласно
лимиту. Буферизирует данные и выдает готовые блоки для записи.

**Атрибуты:**

.. py:attribute:: max_block_size
   :type: int

   Максимальный размер блока в байтах.

.. py:attribute:: total_columns
   :type: int

   Количество колонок.

.. py:attribute:: total_rows
   :type: int

   Количество строк в текущем блоке.

.. py:attribute:: block_size
   :type: int

   Текущий размер блока.

.. py:attribute:: headers_size
   :type: int

   Размер заголовков блока.

.. py:attribute:: data_iterator
   :type: Iterator[Any] | None

   Итератор по входным данным.

**Методы:**

.. py:method:: write_row()

   Запись одной строки данных в буфер.

.. py:method:: clear_block()

   :return: Данные сформированного блока
   :rtype: bytes

   Извлечение готового блока и очистка буферов.

.. py:method:: init_dataset(dtype_values)

   :param dtype_values: Итерируемый объект с данными
   :type dtype_values: Iterable[Any]

   Инициализация источника данных.

.. py:method:: write()

   :return: Генератор блоков данных
   :rtype: Generator[bytes, None, None]

   Поточная запись данных в виде блоков.

**Особенности:**

Автоматическое разбиение больших объемов данных на блоки согласно ``DEFAULT_BLOCK_SIZE``.

**Использование:**

В ``NativeWriter`` для преобразования строк данных в Native формат.
