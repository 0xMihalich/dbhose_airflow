PGPackReader
============

.. py:class:: PGPackReader(fileobj)

   :param fileobj: Файловый объект для чтения
   :type fileobj: BufferedReader

   Основной класс для чтения файлов формата PGPack.

**Описание:**

Осуществляет полный цикл чтения PGPack файлов: проверку сигнатуры,
распаковку метаданных, декомпрессию данных и предоставление интерфейса
для доступа к данным в различных форматах.

**Алгоритм инициализации:**

1. Проверка сигнатуры ``PGPACK\n\x00``
2. Чтение и проверка CRC32 метаданных
3. Распаковка zlib метаданных
4. Разбор структуры колонок и типов данных
5. Чтение параметров сжатия
6. Инициализация декомпрессора данных
7. Создание объекта ``PGCopyReader`` для чтения данных

**Атрибуты:**

.. py:attribute:: metadata
   :type: bytes

   Распакованные метаданные в JSON формате.

.. py:attribute:: columns
   :type: list[str]

   Список имен колонок.

.. py:attribute:: pgtypes
   :type: list[PGOid]

   Список OID типов данных PostgreSQL/GreenPlum.

.. py:attribute:: pgparam
   :type: list[PGParam]

   Список параметров типов данных.

.. py:attribute:: compression_method
   :type: CompressionMethod

   Метод сжатия данных (NONE, LZ4, ZSTD).

.. py:attribute:: pgcopy_data_length
   :type: int

   Размер несжатых данных в байтах.

.. py:attribute:: pgcopy_compressed_length
   :type: int

   Размер сжатых данных в байтах.

**Методы:**

.. py:method:: to_rows()

   :return: Генератор строк данных
   :rtype: Generator[list[Any], None, None]

   Преобразование в Python объекты (списки значений).

.. py:method:: to_pandas()

   :return: DataFrame pandas с корректными типами
   :rtype: pandas.DataFrame

   Конвертация в pandas DataFrame.

.. py:method:: to_polars()

   :return: DataFrame polars
   :rtype: polars.DataFrame

   Конвертация в polars DataFrame.

.. py:method:: to_bytes()

   :return: Генератор несжатых байтовых данных
   :rtype: Generator[bytes, None, None]

   Получение сырых несжатых данных PGCopy.

.. py:method:: tell()

   :return: Текущая позиция чтения
   :rtype: int

   Получение позиции в потоке данных.

.. py:method:: close()

   Закрытие файлового объекта и освобождение ресурсов.

**Строковое представление:**

При выводе в консоли показывает таблицу с информацией о структуре данных:

.. code-block:: text

    <PostgreSQL/GreenPlum compressed dump>
    ┌─────────────────┬─────────────────┐
    │ Column Name     │ PostgreSQL Type │
    ╞═════════════════╪═════════════════╡
    │ id              │ int4            │
    ├─────────────────┼─────────────────┤
    │ name            │ text            │
    └─────────────────┴─────────────────┘
    Total columns: 2
    Compression method: ZSTD
    Unpacked size: 1048576 bytes
    Compressed size: 262144 bytes
    Compression rate: 25.00 %

**Использование:**

Для чтения архивов данных PostgreSQL/GreenPlum в формате PGPack.
