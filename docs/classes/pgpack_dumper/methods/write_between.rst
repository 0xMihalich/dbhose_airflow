write_between
==============

.. py:method:: PGPackDumper.write_between(
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
   :param dumper_src: Экземпляр PGPackDumper или другой объект-ридер для источника данных
   :type dumper_src: PGPackDumper | object | None
   :return: ``None``
   :rtype: None
   :raises PGPackDumperWriteBetweenError: При ошибках переноса данных

   Перенос данных между PostgreSQL/GreenPlum серверами или из других источников. Поддерживает передачу данных между разными серверами, между таблицами на одном сервере, а также из внешних источников через StreamReader.

**Описание:**

Метод выполняет перенос данных из источника в целевую таблицу PostgreSQL/GreenPlum. Поддерживает несколько сценариев использования:

1. **Межсерверный перенос** - передача данных между разными серверами PostgreSQL/GreenPlum
2. **Внутрисерверное копирование** - копирование данных между таблицами на одном сервере
3. **Перенос из внешних источников** - загрузка данных из StreamReader или совместимых объектов
4. **Копирование по запросу** - передача результатов SQL-запроса вместо всей таблицы

Метод использует COPY протокол PostgreSQL для эффективной потоковой передачи данных и автоматически обрабатывает метаданные таблиц.

**Параметры:**

.. list-table:: Параметры метода write_between
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``table_dest``
     - ``str``
     - **Обязательный.** Имя таблицы на целевом сервере куда будут записаны данные. Формат: ``"schema.table_name"`` или ``"table_name"``
   * - ``table_src``
     - ``str | None``
     - Имя таблицы на исходном сервере для чтения данных. Используется, если не указан ``query_src``.
   * - ``query_src``
     - ``str | None``
     - SQL-запрос для выборки данных из источника. Имеет приоритет над ``table_src``.
   * - ``dumper_src``
     - ``PGPackDumper | object | None``
     - Источник данных. Может быть экземпляром PGPackDumper (для PostgreSQL/GreenPlum), StreamReader или другого совместимого объекта. Если ``None``, используется новое соединение к текущему серверу.

**Режимы работы:**

1. **Совместимый PGPackDumper источник** - когда ``dumper_src`` является PGPackDumper, используется его соединение и буфер
2. **StreamReader источник** - когда ``dumper_src`` имеет метод ``to_reader()``, данные читаются через StreamReader
3. **Автономное соединение** - когда ``dumper_src=None``, создается новое соединение к текущему серверу

**Примеры использования:**

.. code-block:: python

    # Пример 1: Копирование таблицы между серверами PostgreSQL
    from pgpack_dumper import PGPackDumper, PGConnector
    
    # Подключение к целевому серверу
    dest_connector = PGConnector(host="target-host", port=5432, dbname="target_db")
    dest_dumper = PGPackDumper(dest_connector)
    
    # Подключение к исходному серверу
    src_connector = PGConnector(host="source-host", port=5432, dbname="source_db")
    src_dumper = PGPackDumper(src_connector)
    
    # Копирование всей таблицы между серверами
    dest_dumper.write_between(
        table_dest="public.users_backup",
        table_src="public.users",
        dumper_src=src_dumper
    )
    
    # Пример 2: Внутрисерверное копирование с фильтрацией
    dest_dumper.write_between(
        table_dest="archive.old_orders",
        query_src="SELECT * FROM sales.orders WHERE order_date < '2023-01-01'",
        dumper_src=None  # Используется тот же сервер
    )
    
    # Пример 3: Перенос данных между схемами на одном сервере
    dest_dumper.write_between(
        table_dest="reporting.monthly_summary",
        table_src="staging.daily_data",
        dumper_src=None
    )
    
    # Пример 4: Перенос из другого источника данных
    # Предположим, что other_reader - совместимый объект с методом to_reader()
    dest_dumper.write_between(
        table_dest="import.external_data",
        dumper_src=other_reader
    )
    
    # Пример 5: Копирование с преобразованием данных
    dest_dumper.write_between(
        table_dest="analytics.user_stats",
        query_src="""
            SELECT 
                user_id,
                COUNT(*) as total_orders,
                SUM(amount) as total_amount,
                AVG(amount) as avg_order_value
            FROM sales.orders
            WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
            GROUP BY user_id
        """,
        dumper_src=src_dumper
    )

**Обработка ошибок:**

.. code-block:: python

    # Пример 1: Обработка ошибок соединения
    try:
        dest_dumper.write_between(
            table_dest="public.target_table",
            table_src="public.source_table",
            dumper_src=src_dumper
        )
    except PGPackDumperWriteBetweenError as e:
        print(f"Ошибка переноса данных: {e}")
        # Возможные причины: таблица не существует, проблема с правами доступа,
        # несоответствие структуры таблиц, ошибка сети
    
    # Пример 2: Проверка доступности источника
    if dumper_src is None:
        print("Используется автономное соединение к текущему серверу")
    elif hasattr(dumper_src, 'dbname'):
        print(f"Источник: {dumper_src.dbname}")

**Метаданные и логирование:**

Метод автоматически логирует информацию о передаче данных:

1. **Диаграмма передачи** - показывает источник и назначение с метаданными
2. **Информация о соединениях** - детали подключения к серверам
3. **Размер переданных данных** - при использовании StreamReader источников

**Особенности и рекомендации:**

1. **COPY протокол** - используется для максимальной производительности
2. **Автоматический commit** - транзакция фиксируется после успешного переноса
3. **Обновление соединения** - целевое соединение обновляется после операции
4. **Сборка мусора** - вызывается для освобождения памяти
5. **Метаданные** - автоматически извлекаются и сравниваются структуры таблиц

**Требования к данным:**

1. **Структурная совместимость** - структура данных источника должна быть совместима с целевой таблицей
2. **Типы данных** - типы должны быть преобразуемы или идентичны
3. **Права доступа** - пользователь должен иметь права на чтение из источника и запись в цель

**Производительность:**

1. **Потоковая передача** - данные передаются потоково без загрузки в память целиком
2. **Буферизация** - используется эффективная буферизация через CopyBuffer
3. **Параллелизм** - можно выполнять несколько переносов параллельно
4. **Сжатие** - поддерживается если источник и цель используют сжатие PGPack

**Примечания:**

* Для GreenPlum требуется учет особенностей распределенных таблиц
* При переносе между разными версиями PostgreSQL могут быть особенности
* Большие таблицы рекомендуется переносить частями для избежания блокировок
* Метод не поддерживает DDL операции - таблицы должны существовать заранее

**См. также:**

- :doc:`read_dump` - Чтение данных в PGPack формат
- :doc:`write_dump` - Запись данных из PGPack формата
- :doc:`to_reader` - Получение StreamReader для данных
- :class:`CopyBuffer` - Буфер для операций COPY
