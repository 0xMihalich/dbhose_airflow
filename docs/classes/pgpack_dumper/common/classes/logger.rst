DumperLogger
============

.. py:class:: DumperLogger(level=DEBUG, use_console=True)

   Логгер для PGPackDumper.

   :param level: Уровень логирования (по умолчанию DEBUG)
   :type level: int
   :param use_console: Вывод логов в консоль
   :type use_console: bool

**Описание:**

Кастомный логгер для модуля PGPackDumper. Наследуется от стандартного 
``Logger`` и добавляет файловое и консольное логирование.

**Формат логов:**

.. code-block:: text

    2024-01-01 12:00:00 | INFO     | ver 1.0.0 | method-file.py-0123 <message>

**Обработчики:**

1. **FileHandler** - запись в файл ``pgpack_logs/YYYY-MM-DD_PGPackDumper.log``
2. **StreamHandler** - вывод в консоль (если ``use_console=True``)

**Примечание:**

Логи сохраняются в директории ``pgpack_logs`` относительно корня проекта.
