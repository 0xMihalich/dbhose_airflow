write_between
==============

.. py:method:: NativeDumper.write_between(
    table_dest,
    table_src=None,
    query_src=None,
    dumper_src=None,
   )

   :param table_dest: Имя целевой таблицы для записи данных
   :type table_dest: str
   :param table_src: Имя исходной таблицы для чтения данных
   :type table_src: str | None
   :param query_src: SQL-запрос для выборки данных из источника
   :type query_src: str | None
   :param dumper_src: Экземпляр NativeDumper для источника данных
   :type dumper_src: NativeDumper | PGPackDumper | None
   :return: ``True`` если данные успешно перенесены
   :rtype: bool
   :raises ValueError: Если не указаны необходимые параметры
   :raises NativeDumperValueError: При ошибках работы с данными

   Перенос данных между БД через Native формат. Целевая таблица должна быть на сервере Clickhouse, источником может быть Postgres/Greenplum/Clickhouse сервер.

**Описание:**

Метод выполняет перенос данных из Postgres/Greenplum/Clickhouse-сервера на ClickHouse-сервер с использованием
Native формата. Поддерживает два режима работы: прямое копирование таблицы и выборку данных через SQL-запрос.

Метод особенно полезен для:
* Миграции данных между серверами
* Репликации данных в реальном времени
* Создания резервных копий
* Переноса данных между разными версиями ClickHouse
* Переноса данных из Postgres/Greenplum в ClickHouse

**Параметры:**

.. list-table:: Параметры метода write_between
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``table_dest``
     - ``str``
     - **Обязательный.** Имя таблицы на целевом сервере куда будут записаны данные. Формат: ``"database.table_name"``
   * - ``table_src``
     - ``str | None``
     - Имя таблицы на исходном сервере. Используется, если не указан ``query_src``. Формат: ``"database.table_name"``
   * - ``query_src``
     - ``str | None``
     - SQL-запрос для выборки данных из источника. SQL-запрос имеет приоритет, поэтому, в случае передачи обоих параметров, метод проигнорирует ``table_src``.
   * - ``dumper_src``
     - ``NativeDumper | PGPackDumper | None``
     - Экземпляр NativeDumper | PGPackDumper, подключенный к исходному серверу. Если ``None``, используется текущий экземпляр.

**Режимы работы:**

1. **Копирование таблицы целиком** - когда указан только ``table_src``
2. **Выборка по запросу** - когда указан ``query_src``
3. **Кросс-серверный перенос** - когда указан ``dumper_src`` (другой сервер)
4. **Внутрисерверный перенос** - когда ``dumper_src=None`` (тот же сервер)

**Примеры использования:**

.. code-block:: python

    # Пример 1: Копирование таблицы между серверами
    from native_dumper import NativeDumper, CHConnector
    
    # Подключение к целевому серверу
    dest_connector = CHConnector(host="target-host", port=8123)
    dest_dumper = NativeDumper(dest_connector)
    
    # Подключение к исходному серверу
    src_connector = CHConnector(host="source-host", port=8123)
    src_dumper = NativeDumper(src_connector)
    
    # Копирование всей таблицы
    dest_dumper.write_between(
        table_dest="analytics.user_data",
        table_src="production.users",
        dumper_src=src_dumper
    )
    
    # Пример 2: Перенос с фильтрацией данных
    dest_dumper.write_between(
        table_dest="archive.old_users",
        query_src="SELECT * FROM production.users WHERE created_at < '2023-01-01'",
        dumper_src=src_dumper
    )
    
    # Пример 3: Внутрисерверное копирование (изменение структуры)
    dest_dumper.write_between(
        table_dest="users_new_schema",
        table_src="users_old_schema",
        dumper_src=None  # Используется текущий dumper (тот же сервер)
    )
    
    # Пример 4: Агрегация и перенос данных
    dest_dumper.write_between(
        table_dest="daily_stats.summary",
        query_src="""
            SELECT 
                toDate(event_time) as date,
                count() as events,
                uniq(user_id) as unique_users
            FROM production.events
            WHERE event_time >= now() - INTERVAL 7 DAY
            GROUP BY date
            ORDER BY date
        """,
        dumper_src=src_dumper
    )
    
    # Пример 5: Инкрементальный перенос
    dest_dumper.write_between(
        table_dest="incremental.updates",
        query_src="""
            SELECT * 
            FROM production.updates 
            WHERE processed = 0 
            AND update_time >= now() - INTERVAL 1 HOUR
        """,
        dumper_src=src_dumper
    )

**Обработка ошибок:**

.. code-block:: python

    # Пример 1: Проверка обязательных параметров
    try:
        # Ошибка: не указана ни таблица-источник, ни запрос
        dest_dumper.write_between(
            table_dest="target.table",
            dumper_src=src_dumper
        )
    except ValueError as e:
        print(f"Ошибка параметров: {e}")
    
    # Пример 2: Обработка ошибок соединения
    try:
        dest_dumper.write_between(
            table_dest="target.table",
            table_src="source.table",
            dumper_src=src_dumper
        )
    except NativeDumperError as e:
        print(f"Ошибка NativeDumper: {e}")
    except Exception as e:
        print(f"Неожиданная ошибка: {e}")

**Внутренняя работа метода:**

1. **Валидация параметров** - проверка что указан либо ``table_src``, либо ``query_src``
2. **Создание временного буфера** - использование BytesIO для хранения данных в памяти
3. **Чтение из источника** - вызов ``read_dump()`` на исходном dumper
4. **Запись в назначение** - вызов ``write_dump()`` на целевом dumper
5. **Очистка ресурсов** - закрытие буфера и освобождение памяти

**Рекомендации по использованию:**

1. **Для больших объемов** - используйте фильтрацию в ``query_src``
2. **Сетевое соединение** - убедитесь в стабильности сети между серверами
3. **Память** - метод передает данные в потоке, используя небольшой буфер для хранения промежуточных результатов
4. **Консистентность** - для консистентного пероса используйте условия по времени

**Ограничения:**

* Конечный сервер должен поддерживать Native формат
* Для очень больших таблиц может потребоваться разбивка на части
* Нет встроенной проверки целостности данных после переноса

**Производительность:**

* Используется Native формат для максимальной скорости
* По умолчанию данные передаются в сжатом виде
* Потоковая обработка минимизирует использование памяти
* Можно параллелизировать для нескольких таблиц

**Примечания:**

* Метод автоматически определяет метод сжатия исходных данных
* Для мониторинга прогресса используйте логи NativeDumper
* После переноса рекомендуется проверить количество строк

**См. также:**

- :doc:`read_dump` - Чтение данных из ClickHouse
- :doc:`write_dump` - Запись данных в ClickHouse
- :doc:`native_format` - Формат передачи данных
