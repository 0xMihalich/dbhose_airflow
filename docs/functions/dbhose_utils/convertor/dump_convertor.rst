dump_convertor
==============

.. py:function:: dump_convertor(
    source,
    destination,
    dump_type,
    compression_method=CompressionMethod.NONE,
   )

   :param source: Путь к исходному файлу дампа
   :type source: str
   :param destination: Путь к целевому файлу
   :type destination: str
   :param dump_type: Тип целевого формата дампа
   :type dump_type: DumpType | str
   :param compression_method: Метод сжатия для выходного файла
   :type compression_method: CompressionMethod | str
   :raises TypeError: Если PGCopy не поддерживает конвертацию в другие форматы
   :raises ValueError: Если исходный и целевой пути совпадают

   Конвертация дампов данных между различными форматами.

**Описание:**

Универсальная функция для преобразования файлов дампов между поддерживаемыми
форматами: Native (ClickHouse), PGCopy (PostgreSQL), PGPack. Автоматически
определяет исходный формат и выполняет соответствующую конвертацию.

**Поддерживаемые преобразования:**

.. code-block:: text

    +-----------------+----------------+
    | Исходный формат | Целевой формат |
    +=================+================+
    | Native          | PGPack         |
    +-----------------+----------------+
    | Native          | PGCopy         |
    +-----------------+----------------+
    | PGPack          | Native         |
    +-----------------+----------------+
    | PGPack          | PGCopy         |
    +-----------------+----------------+
    | PGCopy          | PGCopy         |
    +-----------------+----------------+

**Ограничения:**

- PGCopy → Native: не поддерживается
- PGCopy → PGPack: не поддерживается
- Native → Native: простое сжатие/распаковка
- PGPack → PGPack: простое сжатие/распаковка

**Алгоритм работы:**

1. Автоматическое определение формата исходного файла (``detective``)
2. Проверка совместимости форматов
3. Чтение данных из исходного файла
4. Преобразование метаданных и данных
5. Запись в целевой формат с указанным сжатием

**Примеры использования:**

.. code-block:: python

    # Конвертация Native в PGPack со сжатием ZSTD
    dump_convertor(
        source="data.native",
        destination="data.pgpack",
        dump_type="pgpack",
        compression_method="zstd"
    )
    
    # Распаковка PGPack в Native
    dump_convertor(
        source="archive.pgpack",
        destination="data.native",
        dump_type="native"
    )

**Особенности:**

- Автоматическое определение исходного формата
- Сохранение метаданных при конвертации
- Поддержка различных методов сжатия
- Оптимизированная потоковая обработка больших файлов

**Использование:**

Для миграции данных между системами, архивации и изменения формата хранения дампов.
