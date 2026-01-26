from_dtype
==========

.. py:function:: from_dtype(
    dtype,
    is_array=False,
    is_lowcardinality=False,
    is_nullable=False,
    length=None,
    precision=None,
    scale=None,
    tzinfo=None,
    enumcase=None,
    nested=0,
   )

   :param dtype: Строковое представление типа ClickHouse
   :type dtype: str
   :param is_array: Флаг массива
   :type is_array: bool
   :param is_lowcardinality: Флаг LowCardinality
   :type is_lowcardinality: bool
   :param is_nullable: Флаг Nullable
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
   :param nested: Уровень вложенности для массивов
   :type nested: int
   :return: Кортеж с распарсенными параметрами типа
   :rtype: tuple[
        ClickhouseDtype,
        bool,
        bool,
        bool,
        int | None,
        int | None,
        int | None,
        str | None,
        dict[int, str] | None,
        int,
    ]

**Описание:**

Парсит строковое представление типа данных ClickHouse и возвращает структурированную информацию,
необходимую для корректной работы функций чтения/записи.

**Пример входных данных:**

- ``"DateTime64(3, 'UTC')"``
- ``"Decimal(10, 2)"``
- ``"Array(String)"``
- ``"Nullable(Int32)"``

**Возвращаемое значение:**

Кортеж с типом данных и всеми параметрами для его обработки.
