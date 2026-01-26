Column
======

.. py:class:: Column(column, dtype, fileobj=None, total_rows=0)

   :param column: Имя колонки
   :type column: str
   :param dtype: Строковое описание типа данных
   :type dtype: str
   :param fileobj: Файловый объект (опционально)
   :type fileobj: BufferedReader | None
   :param total_rows: Количество строк
   :type total_rows: int

   Основной класс для работы с колонками данных в Native формате.

**Описание:**

Представляет отдельную колонку таблицы ClickHouse с поддержкой чтения, записи,
итерации и управления данными. Инкапсулирует логику работы с различными типами
данных через соответствующие объекты (DType, Array, LowCardinality).

**Атрибуты:**

.. py:attribute:: info
   :type: ColumnInfo

   Метаданные колонки.

.. py:attribute:: dtype
   :type: Array | DType | LowCardinality

   Объект для работы с конкретным типом данных.

.. py:attribute:: data
   :type: list[Any] | None

   Прочитанные данные колонки.

.. py:attribute:: iter_data
   :type: Iterator[Any] | None

   Итератор по данным.

**Свойства:**

.. py:attribute:: total_rows

   :type: int

   Получение общего количества строк в колонке.

**Методы:**

.. py:method:: skip()

   Пропуск чтения колонки.

.. py:method:: read()

   :return: Список всех значений колонки
   :rtype: list[Any]

   Чтение всех данных колонки.

.. py:method:: write(data)

   :param data: Значение для записи
   :type data: Any
   :return: Количество записанных байт
   :rtype: int

   Запись значения в колонку.

.. py:method:: tell()

   :return: Размер данных колонки
   :rtype: int

   Получение текущего размера.

.. py:method:: clear()

   :return: Собранные данные колонки
   :rtype: bytes

   Извлечение данных и очистка буферов.

**Итерация:**

Поддерживает протокол итератора для последовательного чтения значений.

**Использование:**

Основной интерфейс для работы с колонками в NativeReader/NativeWriter.
