errors
======

Иерархия исключений
-------------------

.. code-block:: text

    Exception
    ├── ValueError
    │   ├── ClickhouseServerError
    │   └── NativeDumperValueError
    └── NativeDumperError
        ├── NativeDumperReadError
        └── NativeDumperWriteError

.. toctree::
    :maxdepth: 1

   clickhouse_server_error
   native_dumper_error
   native_dumper_read_error
   native_dumper_write_error
   native_dumper_value_error

Обработка ошибок
----------------

Все исключения логируются с соответствующими префиксами и могут быть
перехвачены для обработки в приложении.
