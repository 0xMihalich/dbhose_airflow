define_reader
=============

.. py:function:: define_reader(fileobj, compressor_method=None)

   :param fileobj: Файловый объект или поток
   :type fileobj: BufferedReader
   :param compressor_method: Метод сжатия (опционально)
   :type compressor_method: CompressionMethod | None
   :return: Буферизированный поток для чтения
   :rtype: BufferedReader

   Создает декомпрессирующий поток для чтения сжатых данных.

**Описание:**

Определяет или принимает метод сжатия и создает соответствующий декомпрессор.
Для файлов можно использовать автоопределение, для потоков метод указывается явно.

**Логика работы:**

1. Если метод не указан → ``auto_detector()`` для файлов
2. NONE → возвращает исходный поток без изменений
3. LZ4 → ``LZ4Decompressor``
4. ZSTD → ``ZSTDDecompressor``

**Возвращает:**

``BufferedReader`` поверх ``DecompressReader`` для эффективного чтения.
