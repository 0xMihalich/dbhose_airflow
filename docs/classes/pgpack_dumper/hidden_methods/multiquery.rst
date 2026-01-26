multiquery
==========

.. py:decorator:: PGPackDumper.multiquery

   :param dump_method: Метод, который будет обернут декоратором
   :type dump_method: MethodType
   :return: Обернутая функция с поддержкой мультизапросов
   :rtype: Callable

   Декоратор для выполнения сложных операций, состоящих из нескольких SQL-запросов
   и одной операции с данными в PGPack формате.

**Описание:**

Декоратор ``multiquery`` предназначен для обработки сложных сценариев загрузки данных,
которые требуют выполнения последовательности SQL-запросов до и/или после основной
операции с данными. Он автоматически разделяет комплексный запрос на части, выполняет
их в правильном порядке и обеспечивает корректное логирование прогресса.
Перед разделением запрос предварительно очищается через метод ``query_formatter``

**Типичные сценарии использования:**

1. **Создание временных таблиц** перед загрузкой данных
2. **Очистка данных** после миграции
3. **Агрегация результатов** после основной загрузки
4. **Подготовка среды** для сложных ETL процессов
5. **Валидация данных** до и после операций

**Как работает декоратор:**

1. **Разделение запроса** - с помощью ``chunk_query()`` запрос делится на две части:
   * ``first_part`` - запросы, выполняемые ДО основной операции
   * ``second_part`` - запросы, выполняемые ПОСЛЕ основной операции
2. **Выполнение подготовительных запросов** - все запросы из ``first_part``
3. **Выполнение основной операции** - вызов обернутого метода (например, ``read_dump``)
4. **Выполнение завершающих запросов** - все запросы из ``second_part``
5. **Очистка и обновление** - ``collect()`` и ``refresh()``

**Параметры декоратора:**

.. list-table:: Параметры декоратора multiquery
   :widths: 20 30 50
   :header-rows: 1

   * - Параметр
     - Тип
     - Описание
   * - ``dump_method``
     - ``MethodType``
     - Метод PGPackDumper, который будет обернут декоратором.

**Поддерживаемые методы:**

Декоратор может применяться к следующим методам:

* ``read_dump()`` - для комплексной выгрузки данных
* ``write_between()`` - для комплексного переноса между серверами
* ``to_reader()`` - для получения объекта ``StreamReader``

**Логирование прогресса:**

Декоратор обеспечивает детальное логирование выполнения каждой части:

.. code-block:: text

    INFO: Execute query 1/4
    INFO: Execute query 2/4
    INFO: Execute stream 3/4 [pgcopy mode]
    INFO: Execute query 4/4

**Разделение запросов:**

Функция ``chunk_query()`` разделяет SQL-запрос на части по следующим правилам:

1. **Разделитель** - точка с запятой (``;``)
2. **Первая часть** - все запросы до PGCopy операции
3. **Вторая часть** - все запросы после PGCopy операции
4. **PGCopy операция** - определяется по ключевым словам (``SELECT``, ``INSERT`` и т.д.)

**Пример разделения:**

.. code-block:: sql

    -- Исходный запрос
    CREATE TABLE temp (id INT);      -- first_part[0]
    SELECT * FROM source;              -- PGCopy операция
    INSERT INTO dest SELECT * FROM temp;  -- second_part[0]
    DROP TABLE temp;                   -- second_part[1]

**Обработка параметров:**

Декоратор корректно обрабатывает различные комбинации параметров:

.. code-block:: python

    # Различные способы передачи запроса
    @PGPackDumper.multiquery
    def process_data(dumper_inst, **kwargs):
        return dumper_inst.read_dump(**kwargs)
    
    # Вариант 1: query_src (для write_between)
    process_data(
        dumper,
        fileobj=file,
        query_src="CREATE TABLE...; SELECT...; DROP TABLE..."
    )
    
    # Вариант 2: query (для read_dump)
    process_data(
        dumper,
        fileobj=file,
        query="CREATE TABLE...; SELECT...; DROP TABLE..."
    )
    
    # Вариант 3: table_name (без запроса)
    process_data(
        dumper,
        fileobj=file,
        table_name="existing_table"  # Простая загрузка всей таблицы
    )

**Особенности работы с курсорами:**

Декоратор автоматически определяет, какой курсор использовать:

1. **Локальный курсор** - если используется ``self.cursor``
2. **Внешний курсор** - если передан ``dumper_src`` в kwargs

.. code-block:: python

    # Пример: Использование внешнего dumper
    @PGPackDumper.multiquery
    def cross_server_operation(dumper_inst, **kwargs):
        return dumper_inst.write_between(**kwargs)
    
    cross_server_operation(
        dest_dumper,
        table_dest="dest.table",
        table_src="source.table",
        dumper_src=src_dumper,  # Курсор будет взят отсюда
        query_src="TRUNCATE TABLE dest.table; ..."
    )

**Управление памятью:**

После выполнения всех операций декоратор вызывает:

1. ``collect()`` - сборка мусора Python
2. ``refresh()`` - обновление сессии (только если операция успешна)

**Примечания:**

* Декоратор не изменяет сигнатуру оборачиваемого метода
* Все параметры передаются прозрачно через ``*args, **kwargs``
* Результат обернутого метода возвращается как есть
* Рекомендуется использовать для production ETL процессов

**См. также:**

- :doc:`../methods/read_dump` - Чтение данных с поддержкой мультизапросов
- :doc:`../methods/write_between` - Перенос данных с поддержкой мультизапросов
- :doc:`../methods/to_reader` - Чтение данных из PostgreSQL/GreenPlum в виде объекта StreamReader
- :doc:`query_formatter` - Форматирование и нормализация SQL-запросов для PostgreSQL/GreenPlum
- :doc:`chunk_query` - Функция разделения SQL запросов
