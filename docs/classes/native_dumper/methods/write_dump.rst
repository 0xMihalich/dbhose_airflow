write_dump
==========

.. py:method:: NativeDumper.write_dump(
    fileobj,
    table_name,
    compression_method=None,
   )

   :param fileobj: Файловый объект с данными дампа
   :type fileobj: BufferedReader | BinaryIO
   :param table_name: Имя целевой таблицы в ClickHouse
   :type table_name: str
   :param compression_method: Метод сжатия данных в файле
   :type compression_method: CompressionMethod | None
   :raises NativeDumperValueError: Если не указано имя таблицы
   :raises ClickhouseServerError: Ошибка сервера ClickHouse
   :raises NativeDumperWriteError: Другие ошибки записи
   :raises ValueError: Если файл пустой после обработки

   Запись данных из Native формата дампа в таблицу ClickHouse.

**Описание:**

Метод выполняет загрузку данных из Native формата дампа в указанную таблицу ClickHouse.
Поддерживает автоматическое определение метода сжатия, конвертацию между разными методами
сжатия и потоковую передачу данных для эффективной работы с большими объемами.

**Основные этапы работы:**

1. **Валидация параметров** - проверка имени таблицы
2. **Определение сжатия** - автоматическое определение или использование указанного метода
3. **Чтение данных** - декомпрессия и подготовка потока данных
4. **Загрузка в ClickHouse** - потоковая передача данных через HTTP курсор
5. **Очистка и логирование** - освобождение ресурсов и запись результатов

**Параметры:**

.. list-table:: Параметры метода write_dump
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``fileobj``
     - ``BufferedReader | BinaryIO``
     - **Обязательный.** Файловый объект, открытый в бинарном режиме чтения, содержащий дамп в Native формате ClickHouse.
   * - ``table_name``
     - ``str``
     - **Обязательный.** Имя таблицы в ClickHouse, куда будут загружены данные. Формат: ``"database.table_name"`` или ``"table_name"`` (если используется база данных по умолчанию).
   * - ``compression_method``
     - ``CompressionMethod | None``
     - Метод сжатия данных в файле. Если ``None``, метод автоматически определит сжатие. По умолчанию: ``None``.

**Работа с методами сжатия:**

Метод автоматически обрабатывает различные сценарии:

1. **Автоопределение сжатия** - если ``compression_method=None``, используется функция ``auto_detector()``
2. **Совпадение методов** - если метод сжатия файла совпадает с настройками NativeDumper, данные передаются напрямую
3. **Конвертация сжатия** - если методы различаются, данные перекодируются ``define_reader()`` → ``define_writer()``

**Поддерживаемые методы сжатия:**
- ``CompressionMethod.ZSTD``
- ``CompressionMethod.LZ4``
- ``CompressionMethod.NONE`` (без сжатия)

**Примеры использования:**

.. code-block:: python

    # Пример 1: Базовая загрузка дампа
    from native_dumper import NativeDumper, CHConnector
    
    connector = CHConnector(host="localhost", port=8123)
    dumper = NativeDumper(connector=connector)
    
    with open("data_dump.bin", "rb") as f:
        dumper.write_dump(
            fileobj=f,
            table_name="analytics.user_events"
        )
    
    # Пример 2: Загрузка с указанием метода сжатия
    from native_dumper import CompressionMethod
    
    with open("compressed_dump.zst", "rb") as f:
        dumper.write_dump(
            fileobj=f,
            table_name="logs.application_logs",
            compression_method=CompressionMethod.ZSTD
        )
    
    # Пример 3: Загрузка из памяти (BytesIO)
    import io
    from native_dumper import CompressionMethod
    
    # Данные в памяти (например, полученные по сети)
    data_bytes = b"...binary dump data..."
    buffer = io.BytesIO(data_bytes)
    
    dumper.write_dump(
        fileobj=buffer,
        table_name="temp.import_data",
        compression_method=CompressionMethod.LZ4
    )

**Обработка ошибок и валидация:**

.. code-block:: python

    # Пример 1: Проверка обязательных параметров
    try:
        with open("data.bin", "rb") as f:
            dumper.write_dump(f, table_name="")  # Вызовет NativeDumperValueError
    except NativeDumperValueError as e:
        print(f"Ошибка валидации: {e}")
        # Вывод: NativeDumperValueError: Table name not defined.
    
    # Пример 2: Обработка ошибок сервера
    try:
        with open("data.bin", "rb") as f:
            dumper.write_dump(f, table_name="nonexistent.table")
    except ClickhouseServerError as e:
        print(f"Ошибка ClickHouse: {e.code} - {e.message}")
    
    # Пример 3: Общая обработка ошибок
    try:
        with open("corrupted.bin", "rb") as f:
            dumper.write_dump(f, table_name="test.data")
    except NativeDumperWriteError as e:
        print(f"Ошибка записи: {e}")
    except Exception as e:
        print(f"Неожиданная ошибка: {e}")

**Логирование и мониторинг:**

Метод подробно логирует процесс загрузки:

1. **Информационное сообщение** при начале загрузки
2. **Предупреждение** если загружены пустые данные
3. **Информация о размере** переданных данных
4. **Финальное сообщение** об успешном завершении

Пример вывода в лог:
.. code-block:: text

    INFO: Start write into localhost.analytics.user_events.
    INFO: Successfully sending 1048576 bytes.
    INFO: Write into localhost.analytics.user_events done.

**Особенности и рекомендации:**

1. **Производительность:** Используйте ZSTD для лучшего соотношения скорости/сжатия
2. **Память:** Метод работает в потоковом режиме, не загружая весь файл в память
3. **Сетевые прерывания:** При обрыве соединения потребуется повторная загрузка
4. **Очистка ресурсов:** Используется ``collect()`` для освобождения памяти
5. **Обновление соединения:** После загрузки вызывается ``refresh()`` для обновления HTTP курсора

**Примечания:**

* Таблица должна существовать в ClickHouse перед загрузкой
* Структура данных в дампе должна соответствовать структуре целевой таблицы
* Метод автоматически закрывает файловый объект после использования

**См. также:**

- :doc:`read_dump` - Создание дампа из ClickHouse
- :class:`CompressionMethod` - Методы сжатия данных
- :doc:`auto_detector` - Автоматическое определение сжатия
- :doc:`httpcursor` - Курсор для загрузки данных в ClickHouse
- :doc:`native_format` - Описание Native формата ClickHouse
- :doc:`clickhouse_errors` - Ошибки ClickHouse
