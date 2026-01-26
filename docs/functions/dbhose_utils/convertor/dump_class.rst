DumpClass
=========

.. py:class:: DumpClass(name, reader, writer, have_compress)

   :param name: Название формата дампа
   :type name: str
   :param reader: Класс для чтения формата
   :type reader: object
   :param writer: Класс для записи формата
   :type writer: object
   :param have_compress: Флаг поддержки сжатия
   :type have_compress: bool

   Дескриптор формата дампа данных.

**Описание:**

Именованный кортеж, описывающий поддержку определенного формата данных
в системе. Используется для регистрации и управления доступными форматами
дампов в DBHose.

**Поля:**

- ``name`` - человекочитаемое название формата (например, "Native", "PGCopy", "PGPack")
- ``reader`` - класс, реализующий чтение формата (например, ``NativeReader``)
- ``writer`` - класс, реализующий запись формата (например, ``NativeWriter``)
- ``have_compress`` - поддерживает ли формат сжатие данных

**Пример использования:**

.. code-block:: python

    native_format = DumpClass(
        name="Native",
        reader=NativeReader,
        writer=NativeWriter,
        have_compress=True
    )
    
    pgcopy_format = DumpClass(
        name="PGCopy",
        reader=PGCopyReader,
        writer=PGCopyWriter,
        have_compress=False
    )

**Использование:**

Для динамического определения доступных форматов
и автоматического выбора соответствующих классов для операций чтения/записи.
