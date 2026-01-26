BlockReader
===========

.. py:class:: BlockReader(fileobj)

   :param fileobj: Файловый объект для чтения
   :type fileobj: BufferedReader

   Чтение блоков данных из Native формата ClickHouse.

**Описание:**

Обрабатывает блоки данных Native формата, состоящие из заголовка (количество колонок,
количество строк) и данных колонок. Поддерживает чтение построчно и пакетную обработку.

**Атрибуты:**

.. py:attribute:: total_columns
   :type: int

   Количество колонок в блоке.

.. py:attribute:: total_rows
   :type: int

   Количество строк в блоке.

.. py:attribute:: column_list
   :type: list[Column]

   Список объектов колонок.

.. py:attribute:: columns
   :type: list[str]

   Список имен колонок.

**Методы:**

.. py:method:: read_column()

   Чтение одной колонки из блока.

.. py:method:: skip()

   :return: Размер пропущенного блока
   :rtype: int

   Пропуск всего блока данных.

.. py:method:: read()

   :return: Генератор кортежей значений строк
   :rtype: Generator[tuple[Any], None, None]

   Построчное чтение блока данных.

**Использование:**

В ``NativeReader`` для декомпозиции Native формата на отдельные блоки.
