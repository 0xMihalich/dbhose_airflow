write_dump
==========

.. py:method:: PGPackDumper.write_dump(
    fileobj,
    table_name,
   )

   :param fileobj: Файловый объект с данными дампа
   :type fileobj: BufferedReader
   :param table_name: Имя целевой таблицы в PostgreSQL/GreenPlum
   :type table_name: str
   :raises PGPackDumperWriteError: Ошибки записи данных

   Запись данных из PGPack формата дампа в таблицу PostgreSQL/GreenPlum.

**Описание:**

Метод выполняет загрузку данных из PGPack формата дампа в указанную таблицу PostgreSQL/GreenPlum.
Использует COPY протокол для потоковой передачи данных, обеспечивая высокую производительность
при работе с большими объемами данных.

**Основные этапы работы:**

1. **Инициализация буфера** - настройка имени целевой таблицы в copy_buffer
2. **Чтение PGPack файла** - создание PGPackReader для обработки формата
3. **Извлечение метаданных** - получение информации о структуре данных из дампа
4. **Логирование диаграммы передачи** - отображение информации о source и destination
5. **Потоковая загрузка** - передача данных через COPY протокол
6. **Фиксация транзакции** - выполнение commit() для сохранения данных
7. **Очистка ресурсов** - закрытие reader и обновление соединения

**Параметры:**

.. list-table:: Параметры метода write_dump
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``fileobj``
     - ``BufferedReader``
     - **Обязательный.** Файловый объект, открытый в бинарном режиме чтения, содержащий дамп в PGPack формате.
   * - ``table_name``
     - ``str``
     - **Обязательный.** Имя таблицы в PostgreSQL/GreenPlum, куда будут загружены данные. Формат: ``"schema.table_name"`` или ``"table_name"`` (если используется схема по умолчанию).

**Примеры использования:**

.. code-block:: python

    # Пример 1: Базовая загрузка дампа
    from pgpack_dumper import PGPackDumper, PGConnector
    
    connector = PGConnector(host="localhost", port=5432, dbname="mydb")
    dumper = PGPackDumper(connector=connector)
    
    with open("data_dump.pgpack", "rb") as f:
        dumper.write_dump(
            fileobj=f,
            table_name="public.user_events"
        )
    
    # Пример 2: Загрузка в таблицу в конкретной схеме
    with open("products_dump.pgpack", "rb") as f:
        dumper.write_dump(
            fileobj=f,
            table_name="inventory.products"
        )
    
    # Пример 3: Загрузка из различных источников
    import gzip
    
    # Загрузка из сжатого файла
    with gzip.open("compressed_dump.pgpack.gz", "rb") as f:
        dumper.write_dump(
            fileobj=f,
            table_name="archive.old_data"
        )

**Обработка ошибок и валидация:**

.. code-block:: python

    # Пример 1: Обработка ошибок загрузки
    try:
        with open("data.pgpack", "rb") as f:
            dumper.write_dump(f, table_name="nonexistent.table")
    except PGPackDumperWriteError as e:
        print(f"Ошибка записи: {e}")
        # Возможные причины: таблица не существует, несоответствие структуры данных
    
    # Пример 2: Проверка существования файла
    import os
    
    file_path = "data.pgpack"
    if not os.path.exists(file_path):
        print(f"Файл {file_path} не существует")
    else:
        with open(file_path, "rb") as f:
            try:
                dumper.write_dump(f, table_name="import.data")
            except PGPackDumperWriteError as e:
                print(f"Ошибка: {e}")

**Метаданные и логирование:**

Метод автоматически извлекает и логирует метаданные:

1. **Источник (Source):** Информация о файле дампа
2. **Назначение (Destination):** Информация о целевой базе данных и таблице
3. **Диаграмма передачи:** Визуальное представление процесса передачи данных

Пример вывода в лог:
.. code-block:: text

    INFO: file:data_dump.pgpack → mydb:public.user_events
    INFO: Connection to host localhost updated.

**Особенности и рекомендации:**

1. **COPY протокол:** Используется для максимальной производительности загрузки данных
2. **Автоматический commit:** Транзакция фиксируется автоматически после успешной загрузки
3. **Обновление соединения:** После загрузки вызывается ``refresh()`` для обновления курсора
4. **Сборка мусора:** Используется ``collect()`` для освобождения памяти после чтения данных
5. **Закрытие ресурсов:** PGPackReader автоматически закрывается после использования

**Требования к данным:**

1. **Структурное соответствие:** Структура данных в дампе должна соответствовать целевой таблице
2. **Типы данных:** Типы данных в дампе должны быть совместимы с типами в таблице
3. **Кодировка:** Данные должны быть в корректной кодировке для базы данных
4. **Ограничения:** Данные должны удовлетворять ограничениям таблицы (NOT NULL, UNIQUE и т.д.)

**Производительность:**

1. **Потоковая обработка:** Данные обрабатываются потоково, не загружая весь файл в память
2. **Буферизация:** Используется эффективная буферизация данных
3. **Сжатие:** Поддерживается сжатие данных в PGPack формате (ZSTD, LZ4, NONE)

**Примечания:**

* Таблица должна существовать в базе данных перед загрузкой
* Пользователь должен иметь права на запись в целевую таблицу
* Метод работает в рамках транзакции, которая автоматически фиксируется
* Для отката изменений при ошибках используйте внешнюю транзакцию
* Поддерживаются как PostgreSQL, так и GreenPlum

**См. также:**

- :doc:`read_dump` - Создание дампа из PostgreSQL/GreenPlum
- :class:`PGPackReader` - Класс для чтения PGPack формата
- :class:`CopyBuffer` - Буфер для операций COPY
- :doc:`transfer_diagram` - Функция логирования передачи данных
- :doc:`metadata_reader` - Извлечение метаданных из буфера
- :doc:`make_columns` - Создание описания колонок
