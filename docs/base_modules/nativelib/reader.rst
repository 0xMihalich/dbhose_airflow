NativeReader
============

.. py:class:: NativeReader(fileobj)

   :param fileobj: Файловый объект с данными в Native формате
   :type fileobj: BufferedReader

   Основной класс для чтения данных из ClickHouse Native формата.

**Описание:**

Предоставляет интерфейс для чтения и преобразования данных из Native формата
ClickHouse в различные Python структуры: строки, pandas DataFrame, polars DataFrame.
Поддерживает потоковое чтение больших объемов данных.

**Атрибуты:**

.. py:attribute:: total_blocks
   :type: int

   Количество прочитанных блоков данных.

.. py:attribute:: total_rows
   :type: int

   Общее количество прочитанных строк.

**Методы:**

.. py:method:: read_info()

   Чтение метаинформации о данных без загрузки самих данных.

.. py:method:: to_rows()

   :return: Генератор строк данных
   :rtype: Generator[Any, None, None]

   Потоковое преобразование в строки Python.

.. py:method:: to_pandas()

   :return: DataFrame pandas
   :rtype: pandas.DataFrame

   Конвертация в pandas DataFrame с сохранением типов данных.

.. py:method:: to_polars()

   :return: DataFrame polars
   :rtype: polars.DataFrame

   Конвертация в polars DataFrame.

.. py:method:: tell()

   :return: Текущая позиция в файле
   :rtype: int

   Получение позиции чтения.

.. py:method:: close()

   Закрытие файлового объекта.

**Строковое представление:**

При выводе в консоли показывает таблицу с информацией о колонках:

.. code-block:: text

    <Clickhouse Native dump reader>
    ┌─────────────────┬─────────────────┐
    │ Column Name     │ Clickhouse Type │
    ╞═════════════════╪═════════════════╡
    │ id              │ Int32           │
    ├─────────────────┼─────────────────┤
    │ name            │ String          │
    └─────────────────┴─────────────────┘
    Total columns: 2
    Total blocks: 1
    Total rows: 1000

**Использование:**

Для декомпрессии и разбора Native формата из файлов или потоков.
