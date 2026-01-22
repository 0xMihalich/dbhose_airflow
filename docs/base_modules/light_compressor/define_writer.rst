define_writer
=============

.. py:function:: define_writer(bytes_data, compressor_method=CompressionMethod.NONE)

   :param bytes_data: Итерируемый объект с чанками данных
   :type bytes_data: Iterable[bytes]
   :param compressor_method: Метод сжатия
   :type compressor_method: CompressionMethod
   :return: Генератор сжатых чанков
   :rtype: Generator[bytes, None, None]

   Создает потоковый компрессор для данных.

**Описание:**

Принимает чанки данных и возвращает генератор сжатых версий этих чанков.
Позволяет осуществлять потоковое сжатие данных без загрузки всего объема в память.

**Логика работы:**

1. NONE → возвращает исходные данные без изменений
2. LZ4 → ``LZ4Compressor.send_chunks()``
3. ZSTD → ``ZSTDCompressor.send_chunks()``

**Использование:**

Для сжатия данных перед записью в файл или отправкой по сети.
