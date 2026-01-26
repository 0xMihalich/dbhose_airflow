dbhose_utils
============

Внешний модуль ``dbhose-utils`` входит в состав ``dbhose-airflow``, но может быть установлен отдельно.
Большая часть функций написана на языке ``Cython``, что обеспечивает более быструю работу по сравнению с языком ``Python``.
Основное назначение инструментов - работа с дампами и методами сжатия.

.. toctree::
   :caption: Линки на проект:

   GitHub <https://github.com/0xMihalich/dbhose_utils>
   PyPI <https://pypi.org/project/dbhose_utils/>

Установка модуля dbhose_utils без установки dbhose-airflow
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ./install_module.sh
   :language: bash

Импорт модуля
^^^^^^^^^^^^^

.. literalinclude:: ./import_module.py
   :language: python

**Зависимости:**

- ``light_compressor`` - высокоскоростное сжатие LZ4/ZSTD
- ``nativelib`` - работа с бинарным форматом Clickhouse Native
- ``pgcopylib`` - работа с бинарным форматом PostgreSQL COPY
- ``pgpack`` - работа с PGPack форматом - упакованным бинарным форматом PostgreSQL COPY.

**Состав библиотеки**

.. toctree::
    :maxdepth: 1

    common
    convertor/index
