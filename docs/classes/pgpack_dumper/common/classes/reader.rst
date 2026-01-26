CopyReader
==========

.. py:class:: CopyReader(copyobj)

   Класс для чтения данных из Copy объекта.

   :param copyobj: Итерируемый Copy объект для чтения данных
   :type copyobj: Iterable[Copy]

**Описание:**

Класс, написанный на Cython, для потокового чтения данных из объектов 
``psycopg.Copy``. Предоставляет интерфейс, аналогичный файловым объектам.

**Атрибуты экземпляра:**

.. py:attribute:: copyobj
   :type: Iterable[Copy]

   Исходный Copy объект.

.. py:attribute:: closed
   :type: bool

   Флаг закрытия ридера.

.. py:attribute:: total_read
   :type: int

   Общее количество прочитанных байт.

**Методы:**

.. py:method:: read(size) -> bytes

   Чтение данных из Copy объекта.

   :param size: Количество байт для чтения
   :type size: int
   :return: Прочитанные данные
   :rtype: bytes

.. py:method:: tell() -> int

   Возвращает текущую позицию в потоке.

   :return: Количество прочитанных байт
   :rtype: int

.. py:method:: close() -> None

   Закрывает CopyReader и освобождает ресурсы.
