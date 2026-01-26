dump_recovery
=============

.. py:function:: dump_recovery(
     file_path: str,
     recovery_path: str | None = None,
   )

   :param file_path: Путь к повреждённому файлу дампа
   :type file_path: str
   :param recovery_path: Путь для сохранения восстановленного файла (по умолчанию ``file_path + ".recovery"``)
   :type recovery_path: str | None
   :rtype: None

   Восстанавливает повреждённый дамп файла.

**Описание:**

Функция анализирует и восстанавливает повреждённые дампы различных форматов 
(PGPack, PGCopy, Native). Автоматически определяет тип сжатия и формат исходного 
файла, затем воссоздаёт корректную структуру данных.

**Поддерживаемые форматы:**

- PGPack
- PGCopy  
- Native

**Возвращаемое значение:**

Восстановленный файл сохраняется по указанному пути ``recovery_path``.

**Пример использования:**

.. code-block:: python

    dump_recovery("backup.dump", "backup_recovered.dump")
