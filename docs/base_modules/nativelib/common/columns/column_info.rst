ColumnInfo
==========

.. py:class:: ColumnInfo(total_rows, column, dtype)

   :param total_rows: Количество строк в блоке
   :type total_rows: int
   :param column: Имя колонки
   :type column: str
   :param dtype: Строковое описание типа данных
   :type dtype: str

   Класс для хранения информации о колонке и создания объектов типов данных.

**Описание:**

Хранит метаданные колонки ClickHouse и создает соответствующие объекты для работы
с данными в Native формате. Парсит строковое описание типа на составляющие.

**Атрибуты:**

.. py:attribute:: column
   :type: str

   Имя колонки.

.. py:attribute:: dtype
   :type: ClickhouseDtype

   Базовый тип данных.

.. py:attribute:: is_array
   :type: bool

   Флаг массива.

.. py:attribute:: is_lowcardinality
   :type: bool

   Флаг LowCardinality.

.. py:attribute:: is_nullable
   :type: bool

   Флаг Nullable.

.. py:attribute:: length
   :type: int | None

   Длина для FixedString.

.. py:attribute:: precision
   :type: int | None

   Точность для Decimal/DateTime64.

.. py:attribute:: scale
   :type: int | None

   Масштаб для Decimal.

.. py:attribute:: tzinfo
   :type: str | None

   Временная зона.

.. py:attribute:: enumcase
   :type: dict[int, str] | None

   Словарь значений Enum.

.. py:attribute:: nested
   :type: int

   Уровень вложенности для массивов.

**Методы:**

.. py:method:: make_dtype(fileobj)

   :param fileobj: Файловый объект для чтения/записи
   :type fileobj: BufferedReader
   :return: Объект для работы с данными колонки
   :rtype: Array | DType | LowCardinality

   Создает объект соответствующего типа данных для обработки колонки.

**Использование:**

Для инициализации колонок в ``NativeReader`` и ``NativeWriter``.
