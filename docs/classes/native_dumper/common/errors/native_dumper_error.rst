NativeDumperError
=================

.. py:exception:: NativeDumperError

   **Родитель:** ``Exception``

   Базовое исключение для всех ошибок NativeDumper.

   **Когда возникает:**
   - Общие проблемы работы NativeDumper
   - Непредвиденные ошибки внутри методов
   - Проблемы с подключением к ClickHouse

   **Особенности:**
   - Логируется с префиксом ``NativeDumperError:``
   - Содержит детальное описание проблемы
