pgpack
======

Библиотека для работы с PGPack форматом - упакованным бинарным форматом PostgreSQL COPY.

.. toctree::
   :caption: Линки на проект:

   GitHub <https://github.com/0xMihalich/pgpack>
   PyPI <https://pypi.org/project/pgpack/>

Установка модуля pgpack без установки dbhose-airflow
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ./install_module.sh
   :language: bash

**Назначение:**

Эффективное хранение и передача дампов PGCOPY с поддержкой сжатия и метаданных.
Формат оптимизирован для архивации, миграции и обмена данными между системами.

**Особенности формата PGPack:**

1. **Заголовок:** ``PGPACK\n\x00`` (8 байт)
2. **Контрольная сумма:** CRC32 упакованных метаданных (4 байта)
3. **Размер метаданных:** Длина сжатых метаданных (4 байта)
4. **Метаданные:** Zlib-сжатые метаданные структуры
5. **Метод сжатия:** 1 байт (NONE, LZ4, ZSTD)
6. **Размеры данных:** Длина сжатых и несжатых данных PGCopy (2×8 байт)
7. **Данные:** Упакованный дамп PostgreSQL COPY

**Структура метаданных (после распаковки zlib):**

.. code-block:: python

    list[
        list[
            column_number: int,
            list[
                column_name: str,
                column_oid: int,
                column_lengths: int,
                column_scale: int,
                column_nested: int,
            ]
        ]
    ]

**Поддерживаемые методы сжатия:**

- ``CompressionMethod.NONE`` (0x02) - без сжатия
- ``CompressionMethod.LZ4`` (0x82) - LZ4 сжатие
- ``CompressionMethod.ZSTD`` (0x90) - ZSTD сжатие (по умолчанию)

**Основные классы:**

* **PGPackReader** - чтение PGPack файлов
  * Автоматическая распаковка метаданных и данных
  * Конвертация в Python строки, pandas/polars DataFrame
  * Потоковое чтение больших файлов

* **PGPackWriter** - запись PGPack файлов
  * Упаковка метаданных в zlib
  * Сжатие данных выбранным методом
  * Запись из различных источников (Python, pandas, polars, байты)

**Зависимости:**

- ``pandas>=2.1.0`` - для работы с DataFrame
- ``polars>=0.20.31`` - альтернативная обработка данных
- ``pgcopylib`` - работа с бинарным форматом PostgreSQL COPY
- ``light_compressor`` - высокоскоростное сжатие LZ4/ZSTD

**Исключения:**

- ``PGPackError`` - базовое исключение
- ``PGPackHeaderError`` - ошибка сигнатуры заголовка
- ``PGPackMetadataCrcError`` - ошибка контрольной суммы метаданных
- ``PGPackModeError`` - ошибка режима файлового объекта

**Использование:**

Для долгосрочного хранения дампов PostgreSQL/Greenplum и передачи данных
между системами и создания резервных копий с сохранением типов данных и структуры таблиц.

**Классы**

.. toctree::
    :maxdepth: 1

    reader
    writer

**Внутренние компоненты**

.. toctree::
    :maxdepth: 1

    common/index
