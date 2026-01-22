HTTPCursor
==========

.. py:class:: HTTPCursor(connector, compression_method, logger, timeout)

   :param connector: Параметры подключения к ClickHouse
   :type connector: CHConnector
   :param compression_method: Метод сжатия данных
   :type compression_method: CompressionMethod
   :param logger: Логгер для записи событий
   :type logger: Logger
   :param timeout: Таймаут операций в секундах
   :type timeout: int

   Курсор для HTTP взаимодействия с ClickHouse сервером.

**Описание:**

Основной класс для выполнения запросов и передачи данных через HTTP протокол.
Поддерживает Native формат ClickHouse, сжатие данных и управление сессиями.

**Принцип работы:**

1. Устанавливает HTTP соединение с использованием ``HttpSession`` (Rust)
2. Отправляет запросы с необходимыми заголовками (сжатие, авторизация)
3. Обрабатывает ответы, декодирует ошибки
4. Преобразует данные в ``NativeReader`` для работы с Native форматом

**Ключевые методы:**

* ``get_stream(query)`` - получение данных как NativeReader
* ``upload_data(table, data)`` - загрузка данных в таблицу
* ``metadata(table)`` - получение структуры таблицы
* ``execute(query)`` - выполнение запроса без возврата данных
* ``send_hello()`` - проверка соединения и получение версии сервера

**Особенности:**

* Автоматическое определение схемы URL (http/https)
* Поддержка сжатия через заголовки HTTP
* Уникальный session_id для каждой сессии
* Валидация ошибок сервера ClickHouse
* Потоковая обработка больших ответов

**Использование:** Как низкоуровневый транспорт для ``NativeDumper``.

**См. также:**

- :doc:`ch_connector` - Контейнер ``CHConnector`` с параметрами подключения к ClickHouse
- :class:`CompressionMethod` - Перечисление методов сжатия ``CompressionMethod``
- :doc:`ch_connector` - Контейнер ``CHConnector`` с параметрами подключения к ClickHouse
- :doc:`dumper_logger` - Логгер по умолчанию ``DumperLogger``
- :doc:`../defines/dbms_default_timeout_sec` - Константа ``DBMS_DEFAULT_TIMEOUT_SEC``
- :doc:`pyo3http/index` - Модуль ``pyo3http`` для работы с Clickhouse через HTTP/HTTPS интерфейс
