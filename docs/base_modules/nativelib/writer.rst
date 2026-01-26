NativeWriter
============

.. py:class:: NativeWriter(column_list, block_size=DEFAULT_BLOCK_SIZE)

   :param column_list: Список колонок для записи
   :type column_list: list[Column]
   :param block_size: Максимальный размер блока
   :type block_size: int

   Основной класс для записи данных в ClickHouse Native формат.

**Описание:**

Преобразует данные из различных источников (Python строки, pandas/polars DataFrame)
в Native формат ClickHouse. Поддерживает потоковую запись с контролем размера блоков.

**Атрибуты:**

.. py:attribute:: total_blocks
   :type: int

   Количество записанных блоков данных.

.. py:attribute:: total_rows
   :type: int

   Общее количество записанных строк.

**Методы:**

.. py:method:: from_rows(dtype_data)

   :param dtype_data: Итерируемый объект с данными
   :type dtype_data: Iterable[Any]
   :return: Генератор блоков в Native формате
   :rtype: Generator[bytes, None, None]

   Потоковое преобразование Python строк в Native формат.

.. py:method:: from_pandas(data_frame)

   :param data_frame: DataFrame pandas
   :type data_frame: pandas.DataFrame
   :return: Генератор блоков в Native формате
   :rtype: Generator[bytes, None, None]

   Конвертация pandas DataFrame в Native формат.

.. py:method:: from_polars(data_frame)

   :param data_frame: DataFrame polars
   :type data_frame: polars.DataFrame
   :return: Генератор блоков в Native формате
   :rtype: Generator[bytes, None, None]

   Конвертация polars DataFrame в Native формат.

**Строковое представление:**

При выводе в консоли показывает таблицу с информацией о колонках:

.. code-block:: text

    <Clickhouse Native dump writer>
    ┌─────────────────┬─────────────────┐
    │ Column Name     │ Clickhouse Type │
    ╞═════════════════╪═════════════════╡
    │ id              │ Int32           │
    ├─────────────────┼─────────────────┤
    │ name            │ String          │
    └─────────────────┴─────────────────┘
    Total columns: 2
    Total blocks: 0
    Total rows: 0

**Использование:**

Для подготовки данных к записи в ClickHouse через Native формат.
