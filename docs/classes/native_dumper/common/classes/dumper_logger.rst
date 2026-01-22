DumperLogger
============

.. py:class:: DumperLogger(level=DEBUG, use_console=True)

   :param level: Уровень логирования
   :type level: int
   :param use_console: Вывод в консоль
   :type use_console: bool

   Кастомный логгер для NativeDumper с записью в файл и консоль.

**Описание:**

Наследует стандартный ``Logger``, добавляет:
- Запись в файлы формата ``native_logs/ГГГГ-ММ-ДД_NativeDumper.log``
- Вывод в консоль (опционально)
- Подробный формат с версией, функцией, файлом и строкой
- Автосоздание директории логов

**Пример записи:**

.. code-block:: text

    2024-12-17 14:30:25 | INFO     | ver 1.0.0 | write_dump-dumper.py-0123 <Start write into localhost.analytics.table>
