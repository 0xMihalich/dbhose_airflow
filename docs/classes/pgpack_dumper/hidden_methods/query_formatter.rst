query_formatter
===============

.. py:method:: PGPackDumper.query_formatter(query)

   :param query: SQL-запрос для форматирования
   :type query: str
   :return: Отформатированный SQL-запрос или ``None`` если запрос пустой
   :rtype: str | None

   Форматирование и нормализация SQL-запросов для PostgreSQL/GreenPlum.

**Описание:**

Метод выполняет очистку и форматирование SQL-запросов с использованием библиотеки
``sqlparse``. Он удаляет комментарии, лишние пробелы и точки с запятой в конце запроса,
приводя запрос к стандартизированному виду.

**Что делает метод:**

1. **Проверяет входные данные** - возвращает ``None`` для пустых запросов
2. **Удаляет комментарии** - убирает однострочные (``--``) и многострочные (``/* */``) комментарии
3. **Форматирует SQL** - приводит к стандартному форматированию
4. **Удаляет лишние символы** - убирает пробелы и точки с запятой в начале/конце
5. **Возвращает чистый запрос** - готовый к использованию в PostgreSQL/GreenPlum

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
    from pgpack_dumper import PGPackDumper
    
    dumper = PGPackDumper(connector)
    
    raw_query = """
        SELECT  -- это комментарий
            id,
            name,
            /* многострочный
               комментарий */
            age
        FROM users
        WHERE active = TRUE;
    """
    
    formatted = dumper.query_formatter(raw_query)
    print(formatted)
    # Вывод:
    # SELECT id,
    #     name,
    #     age
    # FROM users
    # WHERE active = TRUE

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

**Использование в других методах PGPackDumper:**

Метод ``query_formatter`` используется внутренне в других методах для
обеспечения корректности SQL-запросов:

1. **read_dump()** - форматирование запросов для выборки данных
2. **write_between()** - нормализация SQL для источника данных
3. **to_reader()** - подготовка запросов для потокового чтения

**См. также:**

- :doc:`../methods/read_dump` - Метод, использующий форматирование запросов для выборки
- :doc:`../methods/write_between` - Использование SQL-запросов для переноса данных
