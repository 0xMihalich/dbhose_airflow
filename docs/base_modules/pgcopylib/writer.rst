PGCopyWriter
============

.. py:class:: PGCopyWriter(file, pgtypes)

   :param file: Файловый объект для записи (или None для генерации)
   :type file: BufferedWriter | None
   :param pgtypes: Список OID типов данных колонок
   :type pgtypes: list[PGOid]

   Основной класс для записи данных в бинарный формат PGCOPY.

**Описание:**

Формирует корректный бинарный формат PGCOPY с заголовком и данными.
Поддерживает как запись в файл, так и генерацию байтовых данных для потоковой передачи.

**Атрибуты:**

.. py:attribute:: num_columns
   :type: int

   Количество колонок (определяется из pgtypes).

.. py:attribute:: num_rows
   :type: int

   Количество записанных строк.

.. py:attribute:: pos
   :type: int

   Позиция записи (количество записанных байт).

.. py:attribute:: postgres_dtype
   :type: list[PostgreSQLDtype]

   Список типов данных для каждой колонки.

**Методы:**

.. py:method:: write_row(dtype_values)

   :param dtype_values: Значения строки для записи
   :type dtype_values: Any
   :return: Генератор байтовых представлений колонок
   :rtype: Generator[Any, None, None]

   Формирует одну строку данных в бинарном формате.

.. py:method:: from_rows(dtype_values)

   :param dtype_values: Список строк для записи
   :type dtype_values: list[Any]
   :return: Генератор байтовых данных
   :rtype: Generator[bytes, None, None]

   Генерирует полный бинарный дамп для списка строк.

.. py:method:: write(dtype_values)

   :param dtype_values: Список строк для записи
   :type dtype_values: list[Any]

   Записывает данные непосредственно в файл.

.. py:method:: tell()

   :return: Количество записанных байт
   :rtype: int

   Получение позиции записи.

.. py:method:: close()

   Закрытие файлового объекта.

**Строковое представление:**

При выводе в консоли показывает таблицу с информацией о колонках:

.. code-block:: text

    <PGCopy dump writer>
    ┌─────────────────┬─────────────────┐
    │ Column Number   │ PostgreSQL Type │
    ╞═════════════════╪═════════════════╡
    │ Column_0        │ int4            │
    ├─────────────────┼─────────────────┤
    │ Column_1        │ text            │
    └─────────────────┴─────────────────┘
    Total columns: 2
    Total rows: 0

**Особенности:**

- Генерация корректного заголовка с сигнатурой ``PGCOPY\n\xff\r\n\x00``
- Поддержка NULL значений через ``nullable_writer``
- Автоматическое определение функций записи по OID
- Возможность записи как в файл, так и в память

**Использование:**

Для экспорта данных в бинарный формат PGCOPY.
