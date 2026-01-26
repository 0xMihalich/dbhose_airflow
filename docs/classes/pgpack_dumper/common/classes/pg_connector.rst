PGConnector
===========

.. py:class:: PGConnector(host, dbname, user, password, port)

   Коннектор для подключения к PostgreSQL/GreenPlum.

   :param host: Хост сервера
   :type host: str
   :param dbname: Имя базы данных
   :type dbname: str
   :param user: Имя пользователя
   :type user: str
   :param password: Пароль
   :type password: str
   :param port: Порт подключения
   :type port: int

**Описание:**

NamedTuple с параметрами подключения к серверу PostgreSQL или GreenPlum.

**Атрибуты:**

.. py:attribute:: host
   :type: str

   Адрес сервера.

.. py:attribute:: dbname
   :type: str

   Название базы данных.

.. py:attribute:: user
   :type: str

   Имя пользователя для аутентификации.

.. py:attribute:: password
   :type: str

   Пароль пользователя.

.. py:attribute:: port
   :type: int

   Порт подключения (обычно 5432 для PostgreSQL).
