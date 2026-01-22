length
======

Модуль для работы с длинами последовательностей в Native формате ClickHouse.

Импорт модуля (внутренние функции, написано только как пример)
--------------------------------------------------------------

.. code-block:: python

    # Весь модуль
    from nativelib.common import length

    # Только функции
    from nativelib.common.length import (
        read_length,
        write_length,
    )

read_length
-----------

.. py:function:: read_length(fileobj)

   :param fileobj: Файловый объект для чтения
   :type fileobj: BufferedReader
   :return: Декодированная длина
   :rtype: int

   Чтение закодированной длины из Native формата.

**Описание:**

Декодирует специальный формат хранения длины, используемый в ClickHouse Native
для представления количества колонок, строк или размеров данных.

write_length
------------

.. py:function:: write_length(length)

   :param length: Длина для кодирования
   :type length: int
   :return: Закодированная длина в байтах
   :rtype: bytes

   Кодирование длины в формат ClickHouse Native.

**Описание:**

Преобразует целочисленную длину в бинарный формат, используемый ClickHouse для
передачи метаданных в Native формате.

**Использование:**

В низкоуровневой работе с Native форматом для сериализации/десериализации.
