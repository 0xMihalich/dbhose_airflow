query_template
==============

.. py:function:: query_template(query_name)

   :param query_name: Имя SQL-шаблона
   :type query_name: str
   :return: Содержимое SQL-шаблона
   :rtype: str

**Описание:**

Загружает содержимое SQL-шаблона из файла по его имени.

**Работа функции:**

1. Формирует путь к файлу: ``queryes/<query_name>.sql``
2. Читает файл с кодировкой UTF-8
3. Возвращает строку с SQL-шаблоном

**Пример использования:**

.. code-block:: python

    template = query_template("copy_to")
    # Возвращает: "copy {table_name}\nto stdout with (format binary);"
