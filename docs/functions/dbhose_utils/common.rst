common
======

Общие утилиты для преобразования метаданных между форматами.

**Назначение:**

Преобразование метаданных между различными форматами данных
(Native, PGCopy, PGPack) для обеспечения совместимости в рамках ETL процессов.

**Особенности:**

- Написан на Cython для максимальной производительности
- Поддерживает взаимное преобразование метаданных между форматами
- Обеспечивает консистентность типов данных при конвертации
- Помогает восстановлению данных из поврежденных файлов

pgoid_from_metadata
-------------------

.. py:function:: pgoid_from_metadata(metadata)

   :param metadata: Метаданные PGPack в байтах
   :type metadata: bytes
   :return: Список OID типов PostgreSQL
   :rtype: list[PGOid]

   Извлечение списка OID типов PostgreSQL из метаданных PGPack формата.

**Использование:**

Для подготовки метаданных при конвертации PGPack → PGCopy.

columns_from_metadata
---------------------

.. py:function:: columns_from_metadata(metadata, is_nullable=True)

   :param metadata: Метаданные PGPack в байтах
   :type metadata: bytes
   :param is_nullable: Флаг поддержки NULL значений
   :type is_nullable: bool
   :return: Список объектов Column для Native формата
   :rtype: list[Column]

   Преобразование метаданных PGPack в структуру колонок Native формата ClickHouse.

**Использование:**

Для конвертации метаданных при загрузке данных из PostgreSQL в ClickHouse.

metadata_from_columns
---------------------

.. py:function:: metadata_from_columns(column_list)

   :param column_list: Список колонок Native формата
   :type column_list: list[Column]
   :return: Метаданные в формате PGPack
   :rtype: bytes

   Генерация метаданных PGPack из структуры колонок Native формата.

**Использование:**

Для сохранения метаданных при экспорте данных из ClickHouse.

recover_rows
------------

.. py:function:: recover_rows(reader)

   :param reader: Объект читателя (NativeReader, PGCopyReader, PGPackReader)
   :type reader: NativeReader | PGCopyReader | PGPackReader
   :return: Генератор восстановленных строк
   :rtype: Generator[Any, None, None]

   Попытка восстановления данных из частично поврежденного файла.

**Особенности:**

- Пропускает поврежденные блоки данных
- Пытается извлечь максимально возможное количество данных
- Логирует ошибки чтения для последующего анализа
- Возвращает только корректно прочитанные строки

**Использование:**

Для операций восстановления при повреждении файлов дампов.
