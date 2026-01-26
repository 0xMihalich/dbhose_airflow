DumpType
========

.. py:class:: DumpType

   Перечисление поддерживаемых форматов дампов данных.

**Описание:**

Enum, определяющий все форматы данных, поддерживаемые системой DBHose.
Каждый вариант содержит полное описание формата через ``DumpClass``.

**Значения:**

.. py:data:: NATIVE
   :value: DumpClass("native", NativeReader, NativeWriter, False)

   Native формат ClickHouse.

   **Характеристики:**

   - Чтение: ``NativeReader``
   - Запись: ``NativeWriter``
   - Сжатие: нет (встроено в формат)
   - Использование: Работа с ClickHouse серверами

.. py:data:: PGCOPY
   :value: DumpClass("pgcopy", PGCopyReader, PGCopyWriter, False)

   Бинарный формат PostgreSQL COPY.

   **Характеристики:**

   - Чтение: ``PGCopyReader``
   - Запись: ``PGCopyWriter``
   - Сжатие: нет
   - Использование: Импорт/экспорт данных PostgreSQL

.. py:data:: PGPACK
   :value: DumpClass("pgpack", PGPackReader, PGPackWriter, True)

   Упакованный формат PGPack (PGCopy + сжатие).

   **Характеристики:**

   - Чтение: ``PGPackReader``
   - Запись: ``PGPackWriter``
   - Сжатие: да (LZ4/ZSTD)
   - Использование: Архивация и передача данных

**Пример использования:**

.. code-block:: python

    # Определение формата по имени
    format_type = DumpType.NATIVE
    print(format_type.name)        # "NATIVE"
    print(format_type.reader)      # <class 'NativeReader'>
    print(format_type.have_compress)  # False
    
    # Получение класса читателя для формата
    reader_class = DumpType.PGPACK.reader
    writer_class = DumpType.PGCOPY.writer

**Использование:**

Для типобезопасного выбора форматов данных
и автоматического получения соответствующих классов для операций.
