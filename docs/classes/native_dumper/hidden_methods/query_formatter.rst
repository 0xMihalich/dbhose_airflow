query_formatter
===============

.. py:method:: NativeDumper.query_formatter(query)

   :param query: SQL-запрос для форматирования
   :type query: str
   :return: Отформатированный SQL-запрос или ``None`` если запрос пустой
   :rtype: str | None

   Форматирование и нормализация SQL-запросов для ClickHouse.

**Описание:**

Метод выполняет очистку и форматирование SQL-запросов с использованием библиотеки
``sqlparse``. Он удаляет комментарии, лишние пробелы и точки с запятой в конце запроса,
приводя запрос к стандартизированному виду.

**Что делает метод:**

1. **Проверяет входные данные** - возвращает ``None`` для пустых запросов
2. **Удаляет комментарии** - убирает однострочные (``--``) и многострочные (``/* */``) комментарии
3. **Форматирует SQL** - приводит к стандартному форматированию
4. **Удаляет лишние символы** - убирает пробелы и точки с запятой в начале/конце
5. **Возвращает чистый запрос** - готовый к использованию в ClickHouse

**Параметры:**

.. list-table:: Параметры метода query_formatter
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``query``
     - ``str``
     - SQL-запрос для форматирования. Может содержать комментарии и лишние пробелы.

**Возвращаемое значение:**

* ``str`` - отформатированный SQL-запрос без комментариев и лишних символов
* ``None`` - если входной запрос пустой (``None``, ``""``, или состоящий только из пробелов)

**Примеры использования:**

.. code-block:: python

    # Пример 1: Базовое форматирование запроса
    from native_dumper import NativeDumper
    
    dumper = NativeDumper(connector)
    
    raw_query = """
        SELECT  -- это комментарий
            id,
            name,
            /* многострочный
               комментарий */
            age
        FROM users
        WHERE active = 1;
    """
    
    formatted = dumper.query_formatter(raw_query)
    print(formatted)
    # Вывод:
    # SELECT id,
    #     name,
    #     age
    # FROM users
    # WHERE active = 1

.. code-block:: python

    # Пример 2: Форматирование сложного запроса
    complex_query = """
    INSERT INTO analytics.events
    SELECT 
        user_id,
        event_type,
        toDateTime(timestamp) AS event_time,
        JSONExtractString(properties, 'page') AS page,
        count() OVER (PARTITION BY user_id ORDER BY timestamp) AS event_seq
    FROM raw.events
    WHERE timestamp >= '2024-01-01'
      AND timestamp < '2024-02-01'
      AND event_type IN ('page_view', 'click', 'submit')
    GROUP BY user_id, event_type, timestamp, properties
    ORDER BY timestamp DESC
    LIMIT 1000;
    """
    
    formatted = dumper.query_formatter(complex_query)
    print("Отформатированный запрос:")
    print(formatted)

.. code-block:: python

    # Пример 3: Обработка пустых запросов
    from native_dumper import NativeDumper
    
    dumper = NativeDumper(connector)
    
    # Пустые запросы возвращают None
    empty_result = dumper.query_formatter("")
    print(f"Пустая строка: {empty_result}")  # None
    
    null_result = dumper.query_formatter(None)
    print(f"None: {null_result}")  # None
    
    whitespace_result = dumper.query_formatter("   \n  \t  ")
    print(f"Пробелы: {whitespace_result}")  # None

.. code-block:: python

    # Пример 4: Использование в цепочке методов
    from native_dumper import NativeDumper, CHConnector
    
    connector = CHConnector(host="localhost", port=8123)
    dumper = NativeDumper(connector)
    
    # Запрос с форматированием перед выполнением
    user_query = "select * from users where active=1; -- активные пользователи"
    
    # Форматируем и выполняем
    clean_query = dumper.query_formatter(user_query)
    
    if clean_query:
        # Использование в cursor.execute()
        result = dumper.cursor.execute(clean_query)
        print(f"Найдено {len(result)} записей")
    else:
        print("Запрос пустой, выполнение пропущено")

.. code-block:: python

    # Пример 5: Интеграция с write_between
    raw_query = """
        /* Выборка данных для миграции */
        SELECT 
            id::UInt64 as user_id,
            email,
            created_at::DateTime as registration_date,
            CASE 
                WHEN status = 'active' THEN 1 
                ELSE 0 
            END as is_active
        FROM postgres.public.users  -- исходная таблица
        WHERE created_at >= '2023-01-01'
        ORDER BY id;
    """
    
    # Форматирование перед использованием
    clean_query = dumper.query_formatter(raw_query)
    
    # Использование в write_between
    success = dumper.write_between(
        table_dest="clickhouse.users",
        query_src=clean_query,
        dumper_src=source_dumper
    )

**Преобразования, выполняемые методом:**

.. list-table:: Преобразования запросов
   :widths: 40 60
   :header-rows: 1

   * - Входной запрос
     - Результат форматирования
   * - ``SELECT * FROM t;``
     - ``SELECT * FROM t``
   * - ``SELECT  -- комментарий\n id FROM t;``
     - ``SELECT id FROM t``
   * - ``  SELECT *   FROM   t   WHERE   x=1   ;   ``
     - ``SELECT * FROM t WHERE x = 1``
   * - ``SELECT/*коммент*/id FROM t;``
     - ``SELECT id FROM t``
   * - ``SELECT a,b,c FROM t1; SELECT x,y FROM t2;``
     - ``SELECT a, b, c FROM t1`` (только первый запрос)

**Внутренняя работа метода:**

Метод использует функцию ``sqlparse.format()`` со следующими параметрами:

.. code-block:: python

    # Эквивалент внутренней реализации
    from sqlparse import format as sql_format
    
    def query_formatter(query):
        if not query:
            return None
        
        # Основные параметры форматирования:
        formatted = sql_format(
            sql=query,
            strip_comments=True,      # Удаление комментариев
            reindent=True,            # Автоматический отступ
            keyword_case='upper',     # Ключевые слова в верхнем регистре
            use_space_around_operators=True,  # Пробелы вокруг операторов
            indent_width=2,           # Ширина отступа
            wrap_after=80             # Перенос строк после 80 символов
        )
        
        # Дополнительная очистка
        return formatted.strip().strip(";")

**Использование в других методах NativeDumper:**

Метод ``query_formatter`` используется внутренне в других методах для
обеспечения корректности SQL-запросов:

1. **read_dump()** - форматирование запросов для выборки данных
2. **write_between()** - нормализация SQL для источника данных
3. **to_reader()** - подготовка запросов для потокового чтения

**См. также:**

- :doc:`../methods/read_dump` - Метод, использующий форматирование запросов для выборки
- :doc:`../methods/write_between` - Использование SQL-запросов для переноса данных
