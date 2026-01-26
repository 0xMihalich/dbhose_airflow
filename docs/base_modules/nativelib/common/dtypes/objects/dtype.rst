DType
=====

.. py:class:: DType(
    fileobj,
    dtype,
    is_nullable,
    length,
    precision,
    scale,
    tzinfo,
    enumcase,
    total_rows=0,
   )

   :param fileobj: Файловый объект для чтения/записи
   :type fileobj: BufferedReader
   :param dtype: Тип данных ClickHouse
   :type dtype: ClickhouseDtype
   :param is_nullable: Флаг Nullable типа
   :type is_nullable: bool
   :param length: Длина для FixedString
   :type length: int | None
   :param precision: Точность для Decimal/DateTime64
   :type precision: int | None
   :param scale: Масштаб для Decimal
   :type scale: int | None
   :param tzinfo: Временная зона
   :type tzinfo: str | None
   :param enumcase: Словарь значений Enum
   :type enumcase: dict[int, str] | None
   :param total_rows: Общее количество строк
   :type total_rows: int

   Класс для работы с колонками данных в Native формате.

**Описание:**

Управляет чтением и записью значений определенного типа данных из/в колонку
ClickHouse Native формата. Поддерживает Nullable типы, буферизацию и пропуск данных.

**Атрибуты:**

.. py:attribute:: nullable_map
   :type: list[bool]

   Карта NULL значений для Nullable типов.

.. py:attribute:: nullable_buffer
   :type: list[bytes]

   Буфер NULL индикаторов.

.. py:attribute:: writable_buffer
   :type: list[bytes]

   Буфер данных для записи.

**Методы:**

.. py:method:: read_dtype(row)

   :param row: Номер строки
   :type row: int
   :return: Значение указанного типа
   :rtype: Any

   Чтение одного значения из колонки.

.. py:method:: write_dtype(dtype_value)

   :param dtype_value: Значение для записи
   :type dtype_value: Any

   Запись одного значения в буфер.

.. py:method:: skip()

   Пропуск чтения текущей колонки.

.. py:method:: read()

   :return: Список всех значений колонки
   :rtype: list[Any]

   Чтение всех значений колонки.

.. py:method:: write(dtype_value)

   :param dtype_value: Значение для записи
   :type dtype_value: Any
   :return: Количество записанных байт
   :rtype: int

   Запись значения с обновлением буферов.

.. py:method:: tell()

   :return: Размер буферов записи
   :rtype: int

   Получение текущего размера данных.

.. py:method:: clear()

   :return: Собранные данные колонки
   :rtype: bytes

   Извлечение данных и очистка буферов.

**Использование:**

Внутри ``NativeReader`` и ``NativeWriter`` для обработки отдельных колонок.
