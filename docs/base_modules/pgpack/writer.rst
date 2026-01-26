PGPackWriter
============

.. py:class:: PGPackWriter(
    fileobj,
    metadata=None,
    compression_method=CompressionMethod.ZSTD,
   )

   :param fileobj: Файловый объект для записи
   :type fileobj: BufferedWriter
   :param metadata: Метаданные в байтах (опционально)
   :type metadata: bytes | None
   :param compression_method: Метод сжатия данных
   :type compression_method: CompressionMethod

   Основной класс для записи файлов формата PGPack.

**Описание:**

Осуществляет полный цикл создания PGPack файлов: генерацию метаданных,
сжатие данных, формирование заголовка и запись в файл. Поддерживает
различные источники данных и методы сжатия.

**Атрибуты:**

.. py:attribute:: metadata
   :type: bytes | None

   Метаданные в JSON формате (генерируются автоматически или предоставляются).

.. py:attribute:: columns
   :type: list[str]

   Список имен колонок (извлекается из метаданных).

.. py:attribute:: pgtypes
   :type: list[PGOid]

   Список OID типов данных PostgreSQL.

.. py:attribute:: compression_method
   :type: CompressionMethod

   Используемый метод сжатия данных.

.. py:attribute:: pgcopy_data_length
   :type: int

   Размер несжатых данных (-1 до записи).

.. py:attribute:: pgcopy_compressed_length
   :type: int

   Размер сжатых данных (0 до записи).

**Методы:**

.. py:method:: from_rows(dtype_values)

   :param dtype_values: Итерируемый объект с данными
   :type dtype_values: Iterable[Any]
   :return: Строковое представление созданного файла
   :rtype: str

   Запись данных из Python итерируемого объекта.

.. py:method:: from_pandas(data_frame)

   :param data_frame: DataFrame pandas
   :type data_frame: pandas.DataFrame
   :return: Строковое представление созданного файла
   :rtype: str

   Запись данных из pandas DataFrame (метаданные генерируются автоматически).

.. py:method:: from_polars(data_frame)

   :param data_frame: DataFrame polars
   :type data_frame: polars.DataFrame
   :return: Строковое представление созданного файла
   :rtype: str

   Запись данных из polars DataFrame (метаданные генерируются автоматически).

.. py:method:: from_bytes(bytes_data)

   :param bytes_data: Итерируемый объект с байтовыми данными PGCopy
   :type bytes_data: Iterable[bytes]
   :return: Строковое представление созданного файла
   :rtype: str

   Запись готовых байтовых данных PGCopy.

.. py:method:: tell()

   :return: Текущая позиция записи
   :rtype: int

   Получение позиции в файле.

.. py:method:: close()

   Закрытие файлового объекта и освобождение ресурсов.

**Процесс записи:**

1. Генерация/проверка метаданных
2. Сжатие метаданных zlib
3. Запись заголовка и метаданных
4. Сжатие данных выбранным методом (LZ4/ZSTD/NONE)
5. Запись данных
6. Обновление размеров в заголовке

**Особенности:**

- Автоматическая генерация метаданных для pandas/polars DataFrame
- Поддержка потоковой записи больших объемов данных
- Корректное обновление размеров данных после записи
- Оптимизация памяти при сжатии

**Использование:**

Для создания архивов данных в формате PGPack.
