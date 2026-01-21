close
=====

.. py:method:: NativeDumper.close()

   :return: Ничего не возвращает (``None``)
   :rtype: None

   Корректное закрытие сессии и освобождение всех ресурсов NativeDumper.

**Описание:**

Метод выполняет полное закрытие соединения с сервером ClickHouse и освобождение
всех связанных ресурсов. Это финальная операция в жизненном цикле NativeDumper,
после которой объект не может быть использован для дальнейших операций.

**Что делает метод:**

1. **Закрывает курсор** - вызывает ``cursor.close()`` для освобождения соединения
2. **Освобождает сетевые ресурсы** - закрывает сокеты и HTTP-соединения
3. **Очищает внутренние буферы** - освобождает память от временных данных
4. **Логирует завершение** - записывает информационное сообщение о закрытии
5. **Делает объект непригодным для использования** - последующие вызовы методов вызовут ошибки

**Когда использовать close():**

1. **Завершение работы приложения** - при выходе из программы
2. **Освобождение ресурсов** - когда NativeDumper больше не нужен
3. **Пересоздание соединения** - перед созданием нового экземпляра
4. **Обработка исключений** - гарантированное освобождение ресурсов при ошибках

**Сообщения в логе:**

При успешном выполнении метода в лог записывается сообщение:

.. code-block:: text

    INFO: Connection to host localhost closed.

**Поведение после close():**

После вызова ``close()`` объект NativeDumper переходит в нерабочее состояние:

.. code-block:: python

    dumper = NativeDumper(connector)
    dumper.close()
    
    # Последующие вызовы вызовут исключения
    try:
        dumper.write_dump(open("data.bin", "rb"), "test.table")
    except Exception as e:
        print(f"Ошибка: {e}")  # "Operation on closed NativeDumper"
    
    try:
        dumper.refresh()
    except Exception as e:
        print(f"Ошибка: {e}")  # "NativeDumper is closed"

**Рекомендации по использованию:**

1. **Всегда закрывайте NativeDumper** - предотвращение утечек ресурсов
2. **Закрывайте в finally** - гарантия освобождения ресурсов при ошибках
3. **Не используйте после close()** - создавайте новый экземпляр при необходимости
4. **Документируйте время жизни** - в больших приложениях

**Сценарии когда close() критически важен:**

* **Долгоживущие процессы** - сервисы, демоны, которые создают много подключений
* **Приложения с ограничениями памяти** - предотвращение утечек
* **Сервисы с ограничениями на количество соединений** - освобождение лимитов
* **Тестовые среды** - очистка между тестами
* **Контейнеризированные приложения** - корректное завершение работы

**Лучшие практики:**

1. **Шаблон RAII (Resource Acquisition Is Initialization):**

.. code-block:: python

    class ManagedNativeDumper:
        """Управляемый NativeDumper с автоматическим закрытием."""
        
        def __init__(self, connector):
            self._dumper = NativeDumper(connector)
        
        def __enter__(self):
            return self._dumper
        
        def __exit__(self, exc_type, exc_val, exc_tb):
            self._dumper.close()
        
        # Делегирование методов
        def write_dump(self, *args, **kwargs):
            return self._dumper.write_dump(*args, **kwargs)
    
    # Использование
    with ManagedNativeDumper(connector) as dumper:
        dumper.write_dump(fileobj, "test.table")

2. **Декоратор для автоматического закрытия:**

.. code-block:: python

    from functools import wraps
    
    def with_native_dumper(connector_factory):
        """Декоратор для автоматического создания и закрытия NativeDumper."""
        def decorator(func):
            @wraps(func)
            def wrapper(*args, **kwargs):
                connector = connector_factory()
                dumper = NativeDumper(connector)
                try:
                    # Передаем dumper как первый аргумент
                    return func(dumper, *args, **kwargs)
                finally:
                    dumper.close()
            return wrapper
        return decorator
    
    # Использование
    @with_native_dumper(lambda: CHConnector(host="localhost", port=8123))
    def process_data(dumper, filename, table_name):
        with open(filename, "rb") as f:
            dumper.write_dump(f, table_name)

**Примечания:**

* После ``close()`` объект нельзя использовать повторно
* Метод идемпотентен - multiple calls are safe
* Не вызывает исключений при повторном вызове
* Рекомендуется вызывать даже если были ошибки в работе NativeDumper
* В сочетании с ``refresh()`` обеспечивает полный контроль над жизненным циклом

**См. также:**

- :doc:`refresh` - Обновление сессии без закрытия
