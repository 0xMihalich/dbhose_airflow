auto_detector
=============

.. py:function:: auto_detector(fileobj)

   :param fileobj: Файловый объект для проверки
   :type fileobj: BufferedReader
   :return: Определенный метод сжатия
   :rtype: CompressionMethod

   Автоматическое определение метода сжатия по сигнатуре файла.

**Описание:**

Читает первые 4 байта файла для определения формата сжатия по сигнатурам:
- ``\x04\"M\x18`` - LZ4 Frame
- ``(\xb5/\xfd`` - ZSTD Frame
- Другое - без сжатия (NONE)

**Важно:**

Работает только с файлами, а не с потоковыми объектами.

**См. также:**

- :class:`CompressionMethod` - Перечисление методов сжатия
