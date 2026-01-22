file_writer
===========

.. py:function:: file_writer(fileobj)

   :param fileobj: Файловый объект для чтения
   :type fileobj: BufferedReader
   :return: Генератор байтовых чанков
   :rtype: Generator[bytes, None, None]

   Потоковое чтение файла с разбиением на чанки фиксированного размера.

**Описание:**

Функция читает файл порциями фиксированного размера (``CHUNK_SIZE``) и возвращает
генератор, который последовательно отдает чанки. Это позволяет обрабатывать
большие файлы без загрузки всего содержимого в память.

**Ключевые особенности:**

* **Потоковая обработка** - файл читается по частям
* **Фиксированный размер чанков** - определяется константой ``CHUNK_SIZE``
* **Генератор** - ленивая загрузка данных
* **Эффективность памяти** - не загружает весь файл в память

**Примеры использования:**

.. code-block:: python

    # Пример 1: Базовое использование
    from io import BufferedReader
    from native_dumper.common import file_writer
    
    with open("large_file.bin", "rb") as f:
        buffered = BufferedReader(f)
        
        for chunk in file_writer(buffered):
            # Обработка каждого чанка
            process_chunk(chunk)
    
    # Пример 2: Использование в конвейере обработки
    with open("data.bin", "rb") as f:
        # Чтение -> Сжатие -> Запись
        compressed = compress_stream(file_writer(BufferedReader(f)))
        
        with open("compressed.bin", "wb") as out_f:
            for chunk in compressed:
                out_f.write(chunk)
    
    # Пример 3: Подсчет статистики
    with open("log_file.txt", "rb") as f:
        total_size = 0
        chunk_count = 0
        
        for chunk in file_writer(BufferedReader(f)):
            total_size += len(chunk)
            chunk_count += 1
        
        print(f"Файл разбит на {chunk_count} чанков")
        print(f"Общий размер: {total_size} байт")

**Примечания:**

* Размер чанка определяется глобальной константой ``CHUNK_SIZE``
* Функция ожидает ``BufferedReader``, но может работать с любым файловым объектом
* Генератор завершается, когда достигается конец файла
* Рекомендуется использовать для файлов больших размеров

**См. также:**

- :doc:`../defines/chunk_size` - Константа ``CHUNK_SIZE``
