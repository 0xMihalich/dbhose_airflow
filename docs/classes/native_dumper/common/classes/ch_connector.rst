CHConnector
===========

.. py:class:: CHConnector(
    host,
    dbname=DEFAULT_DATABASE,
    user=DEFAULT_USER,
    password=DEFAULT_PASSWORD,
    port=DEFAULT_PORT,
   )

   :param host: Хост сервера ClickHouse
   :type host: str
   :param dbname: Имя базы данных
   :type dbname: str
   :param user: Имя пользователя
   :type user: str
   :param password: Пароль
   :type password: str
   :param port: Порт сервера
   :type port: int

   Контейнер с параметрами подключения к ClickHouse.

**Описание:**

Именованный кортеж, хранящий настройки подключения. Используется всеми классами
для соединения с ClickHouse сервером.

**Пример:**

.. code-block:: python

    connector = CHConnector(
        host="localhost",
        dbname="analytics",
        user="admin",
        password="secret",
        port=8123
    )

**См. также:**

- :doc:`../defines/default_database` - Константа ``DEFAULT_DATABASE``
- :doc:`../defines/default_user` - Константа ``DEFAULT_USER``
- :doc:`../defines/default_port` - Константа ``DEFAULT_PORT``
