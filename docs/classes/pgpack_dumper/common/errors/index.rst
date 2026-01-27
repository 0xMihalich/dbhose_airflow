errors
======

Иерархия исключений
-------------------

.. code-block:: text

    Exception
    ├── CopyBufferError
    ├── TypeError
    │   └── CopyBufferObjectError
    ├── ValueError
    │   └── CopyBufferTableNotDefined
    └── PGPackDumperError
        ├── PGPackDumperReadError
        └── PGPackDumperWriteError
            └── PGPackDumperWriteBetweenError

.. toctree::
    :maxdepth: 1

   copy_buffer_error
   copy_buffer_object_error
   copy_buffer_table_not_defined
   pgpack_dumper_error
   pgpack_dumper_read_error
   pgpack_dumper_write_error
   pgpack_dumper_write_between_error

Обработка ошибок
----------------

Все исключения логируются с соответствующими префиксами и могут быть
перехвачены для обработки в приложении.
