NativeDumper
============

**Описание:**

Внешний модуль ``native-dumper`` входит в состав ``dbhose-airflow``, но может быть установлен отдельно.

Установка модуля native-dumper без установки dbhose-airflow
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ./install_module.sh
   :language: bash

.. toctree::
   :caption: Линки на проект:

   GitHub <https://github.com/0xMihalich/native_dumper>
   PyPI <https://pypi.org/project/native-dumper/>

Часть кода написана на языке ``Rust``, что обеспечивает более быструю работу по сравнению с языком ``Python``.

Назначение класса NativeDumper - обмен данными с сервером Clickhouse по http/https протоколу.

Импорт модуля
^^^^^^^^^^^^^

.. literalinclude:: ./import_module.py
   :language: python

.. note::
    Статья находится в разработке. Полная документация будет доступна позже.
