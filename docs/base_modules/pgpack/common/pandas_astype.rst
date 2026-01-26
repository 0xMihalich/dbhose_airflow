pandas_astype
=============

.. py:function:: pandas_astype(columns, postgres_dtype)

   :param columns: Список имен колонок
   :type columns: list[str]
   :param postgres_dtype: Список типов данных PostgreSQL
   :type postgres_dtype: list[PostgreSQLDtype]
   :return: Словарь соответствий для pandas dtype
   :rtype: dict[str, str]

   Генерация типов данных pandas из типов PostgreSQL.

**Описание:**

Преобразует типы данных PostgreSQL в соответствующие типы pandas для
корректного создания DataFrame. Используется при конвертации данных
из PGPack формата в pandas DataFrame.

**Словарь соответствий PANDAS_TYPE:**

.. list-table:: Соответствие типов PostgreSQL → pandas dtype
   :widths: 30 30
   :header-rows: 1

   * - Тип Python
     - Тип pandas
   * - ``NoneType``
     - ``"nan"``
   * - ``bool``
     - ``"?"``
   * - ``date``
     - ``"datetime64[ns]"``
   * - ``float``
     - ``"float64"``
   * - ``str``
     - ``"string"``

**Возвращает:**

Словарь, где ключ - имя колонки, значение - pandas dtype или ``None``
если соответствие не найдено.

**Пример использования:**

.. code-block:: python

    columns = ["id", "name", "price"]
    pg_types = [PostgreSQLDtype.Int4, PostgreSQLDtype.Text, PostgreSQLDtype.Numeric]
    
    astype_dict = pandas_astype(columns, pg_types)
    # {'id': None, 'name': 'string', 'price': None}
    
    df = pd.DataFrame(data).astype(astype_dict)

**Примечание:**

Для типов, не включенных в словарь ``PANDAS_TYPE``, возвращается ``None``.
