pgcopylib
=========

Библиотека для чтения данных из бинарного формата PostgreSQL (PG COPY), написанная на Cython.

.. toctree::
   :caption: Линки на проект:

   GitHub <https://github.com/0xMihalich/pgcopylib>
   PyPI <https://pypi.org/project/pgcopylib/>

Установка модуля pgcopylib без установки dbhose-airflow
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ./install_module.sh
   :language: bash

**Назначение:**

Парсинг выходного формата команды ``COPY table TO STDOUT WITH (FORMAT binary)`` без зависимостей от внешних библиотек PostgreSQL.
Оптимизирована для миграции и ETL процессов.

**Особенности:**

- Чистая Python реализация без системных зависимостей
- Автоматическое определение типов данных PostgreSQL
- Поддержка большинства встроенных типов данных
- Чтение как отдельных значений, так и массивов (типы с префиксом `_`)
- Возможность чтения сырых байтов без преобразования типов

**Поддерживаемые типы данных PostgreSQL/Greenplum:**

- Числовые: int2-8, float4/8, numeric, serial, money
- Строковые: text, varchar, bpchar, xml
- Бинарные: bytea, bit, varbit
- Временные: date, time, timestamp, timestamptz, interval
- Специальные: bool, uuid, json/jsonb, oid
- Сетевые: inet, cidr, macaddr
- Геометрические: point, line, box, circle, path, polygon, lseg

**Неподдерживаемые типы (на данный момент):**

- tsquery
- tsvector

**Типы данных PostgreSQL/Greenplum ↔ Python в виде таблицы:**

.. list-table:: Поддерживаемые типы данных
   :widths: 30 10 10 50
   :header-rows: 1

   * - Тип PostgreSQL/Greenplum
     - Чтение
     - Запись
     - Тип Python (Чтение/Запись)
   * - **Массивы (с префиксом _)**
     - 
     - 
     -
   * - ``_bit``
     - +
     - +
     - ``list[str]``
   * - ``_bool``
     - +
     - +
     - ``list[bool]``
   * - ``_box``
     - +
     - +
     - ``list[tuple[tuple[float, float], tuple[float, float]]]``
   * - ``_bpchar``
     - +
     - +
     - ``list[str]``
   * - ``_bytea``
     - +
     - +
     - ``list[bytes]``
   * - ``_char``
     - +
     - +
     - ``list[str]``
   * - ``_cidr``
     - +
     - +
     - ``list[ipaddress.IPv4Network / ipaddress.IPv6Network]``
   * - ``_circle``
     - +
     - +
     - ``list[tuple[float, float, float]]``
   * - ``_date``
     - +
     - +
     - ``list[datetime.date]``
   * - ``_float4``
     - +
     - +
     - ``list[float]``
   * - ``_float8``
     - +
     - +
     - ``list[float]``
   * - ``_inet``
     - +
     - +
     - ``list[ipaddress.IPv4Address / ipaddress.IPv6Address]``
   * - ``_int2``
     - +
     - +
     - ``list[int]``
   * - ``_int4``
     - +
     - +
     - ``list[int]``
   * - ``_int8``
     - +
     - +
     - ``list[int]``
   * - ``_interval``
     - +
     - +
     - ``list[dateutil.relativedelta.relativedelta]``
   * - ``_json``
     - +
     - +
     - ``list[dict / list / str / int / float / bool / None]``
   * - ``_jsonb``
     - +
     - +
     - ``list[dict / list / str / int / float / bool / None]``
   * - ``_line``
     - +
     - +
     - ``list[tuple[float, float, float]]``
   * - ``_lseg``
     - +
     - +
     - ``list[list[tuple[float, float]]]``
   * - ``_macaddr``
     - +
     - +
     - ``list[str]``
   * - ``_macaddr8``
     - +
     - +
     - ``list[str]``
   * - ``_money``
     - +
     - +
     - ``list[float]``
   * - ``_numeric``
     - +
     - +
     - ``list[decimal.Decimal]``
   * - ``_oid``
     - +
     - +
     - ``list[int]``
   * - ``_path``
     - +
     - +
     - ``list[list[tuple[float, float]] / tuple[tuple[float, float]]]``
   * - ``_point``
     - +
     - +
     - ``list[tuple[float, float]]``
   * - ``_polygon``
     - +
     - +
     - ``list[tuple[tuple[float, float]]]``
   * - ``_serial2``
     - +
     - +
     - ``list[int]``
   * - ``_serial4``
     - +
     - +
     - ``list[int]``
   * - ``_serial8``
     - +
     - +
     - ``list[int]``
   * - ``_text``
     - +
     - +
     - ``list[str]``
   * - ``_time``
     - +
     - +
     - ``list[datetime.time]``
   * - ``_timestamp``
     - +
     - +
     - ``list[datetime.datetime]``
   * - ``_timestamptz``
     - +
     - +
     - ``list[datetime.datetime]``
   * - ``_timetz``
     - +
     - +
     - ``list[datetime.time]``
   * - ``_uuid``
     - +
     - +
     - ``list[uuid.UUID]``
   * - ``_varbit``
     - +
     - +
     - ``list[str]``
   * - ``_varchar``
     - +
     - +
     - ``list[str]``
   * - ``_xml``
     - +
     - +
     - ``list[str]``
   * - **Скалярные типы**
     - 
     - 
     -
   * - ``bit``
     - +
     - +
     - ``str``
   * - ``bool``
     - +
     - +
     - ``bool``
   * - ``box``
     - +
     - +
     - ``tuple[tuple[float, float], tuple[float, float]]``
   * - ``bpchar``
     - +
     - +
     - ``str``
   * - ``bytea``
     - +
     - +
     - ``bytes``
   * - ``char``
     - +
     - +
     - ``str``
   * - ``cidr``
     - +
     - +
     - ``ipaddress.IPv4Network / ipaddress.IPv6Network``
   * - ``circle``
     - +
     - +
     - ``tuple[float, float, float]``
   * - ``date``
     - +
     - +
     - ``datetime.date``
   * - ``float4``
     - +
     - +
     - ``float``
   * - ``float8``
     - +
     - +
     - ``float``
   * - ``inet``
     - +
     - +
     - ``ipaddress.IPv4Address / ipaddress.IPv6Address``
   * - ``int2``
     - +
     - +
     - ``int``
   * - ``int4``
     - +
     - +
     - ``int``
   * - ``int8``
     - +
     - +
     - ``int``
   * - ``interval``
     - +
     - +
     - ``dateutil.relativedelta.relativedelta``
   * - ``json``
     - +
     - +
     - ``dict / list / str / int / float / bool / None``
   * - ``jsonb``
     - +
     - +
     - ``dict / list / str / int / float / bool / None``
   * - ``line``
     - +
     - +
     - ``tuple[float, float, float]``
   * - ``lseg``
     - +
     - +
     - ``list[tuple[float, float]]``
   * - ``macaddr``
     - +
     - +
     - ``str``
   * - ``macaddr8``
     - +
     - +
     - ``str``
   * - ``money``
     - +
     - +
     - ``float``
   * - ``numeric``
     - +
     - +
     - ``decimal.Decimal``
   * - ``oid``
     - +
     - +
     - ``int``
   * - ``path``
     - +
     - +
     - ``list[tuple[float, float]] / tuple[tuple[float, float]]``
   * - ``point``
     - +
     - +
     - ``tuple[float, float]``
   * - ``polygon``
     - +
     - +
     - ``tuple[tuple[float, float]]``
   * - ``serial2``
     - +
     - +
     - ``int``
   * - ``serial4``
     - +
     - +
     - ``int``
   * - ``serial8``
     - +
     - +
     - ``int``
   * - ``text``
     - +
     - +
     - ``str``
   * - ``time``
     - +
     - +
     - ``datetime.time``
   * - ``timestamp``
     - +
     - +
     - ``datetime.datetime``
   * - ``timestamptz``
     - +
     - +
     - ``datetime.datetime``
   * - ``timetz``
     - +
     - +
     - ``datetime.time``
   * - ``uuid``
     - +
     - +
     - ``uuid.UUID``
   * - ``varbit``
     - +
     - +
     - ``str``
   * - ``varchar``
     - +
     - +
     - ``str``
   * - ``xml``
     - +
     - +
     - ``str``

\*Префикс ``_`` обозначает массивы соответствующих типов

\*\*Для типа ``interval`` требуется установленный ``dateutil``

**Зависимости:**

Отсутствуют

**Производительность:**

Использует эффективное columnar представление данных, избегая преобразования столбцов в строки.
Подходит для быстрой генерации дампов и обмена между серверами PostgreSQL/Greenplum.

**Классы**

.. toctree::
    :maxdepth: 1

    reader
    writer

**Внутренние компоненты**

.. toctree::
    :maxdepth: 1

    common/index
