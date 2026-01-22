ZSTDDecompressor
================

.. py:class:: ZSTDDecompressor()

   Декомпрессор для потоковой распаковки ZSTD фреймов.

**Описание:**

Обрабатывает ZSTD фреймы с поддержкой контекстных менеджеров и контроля памяти.
Работает с форматом Zstandard Frame, включая многофреймовые потоки.

**Атрибуты:**

.. py:attribute:: eof
   :type: bool

   Флаг достижения конца ZSTD фрейма.

.. py:attribute:: needs_input
   :type: bool

   Указывает, требуется ли больше входных данных.

.. py:attribute:: unused_data
   :type: bytes

   Данные после завершения ZSTD фрейма.

**Методы:**

.. py:method:: decompress(data, max_length=-1)

   :param data: Сжатые ZSTD данные
   :type data: bytes | bytearray
   :param max_length: Лимит выходных данных
   :type max_length: int
   :return: Распакованные данные
   :rtype: bytes

   Распаковывает ZSTD фрейм с контролем размера вывода.

.. py:method:: reset()

   Сбрасывает контекст декомпрессии для нового потока.

**Особенности:**

* Поддержка контекстных менеджеров
* Работа с многофреймовыми ZSTD потоками
* Контроль памяти через ``max_length``
* Эффективная буферизация входных данных
