Array
=====

.. py:class:: Array(fileobj, dtype, total_rows=0)

   :param fileobj: Файловый объект для чтения/записи
   :type fileobj: BufferedReader
   :param dtype: Базовый тип данных или вложенный массив
   :type dtype: DType | Array
   :param total_rows: Общее количество строк
   :type total_rows: int

   Класс для работы с массивами данных в Native формате.

**Описание:**

Обрабатывает массивы ClickHouse (``Array(T)``), где T может быть любым простым типом
или другим массивом (многомерные массивы). Управляет чтением и записью массивов
переменной длины для каждой строки.

**Атрибуты:**

.. py:attribute:: row_elements
   :type: list

   Количество элементов для каждой строки массива.

.. py:attribute:: writable_buffer
   :type: list

   Буфер данных массива для записи.

**Методы:**

.. py:method:: skip()

   Пропуск чтения текущего массива.

.. py:method:: read()

   :return: Список массивов (по одному на строку)
   :rtype: list[Any]

   Чтение всех массивов из колонки.

.. py:method:: write(dtype_value)

   :param dtype_value: Список значений для записи
   :type dtype_value: list[Any]
   :return: Количество записанных байт
   :rtype: int

   Запись массива значений.

.. py:method:: tell()

   :return: Размер буферов записи
   :rtype: int

   Получение текущего размера данных массива.

.. py:method:: clear()

   :return: Собранные данные массива
   :rtype: bytes

   Извлечение данных и очистка буферов.

**Особенности:**

Поддержка массивов переменной длины и вложенных (многомерных) массивов.

**Использование:**

Для обработки колонок типа ``Array(T)`` в Native формате.
