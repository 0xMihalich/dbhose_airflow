# DBHose для Apache Airflow

```ascii
                                                                 (                )
 (  (                                                 )          )\ )     (    ( /(
 )\))(   '   (    (                   )       (     ( /(        (()/(   ( )\   )\())               (
((_)()\ )   ))\   )\    (     (      (       ))\    )\())   (    /(_))  )((_) ((_)\    (    (     ))\
_(())\_)() /((_) (( )   )\    )\     )\  '  /((_)  (_))/    )\   (_))_  ((_)_   _((_)   )\   )\   /((_)
\ \((_)/ /(_))   | |   ((_)  ((_)  _((_))  (_))    | |_    ((_)   |   \  | _ ) | || |  ((_) ((_) (_))
 \ \/\/ / / -_)  | |  / _|  / _ \ | '  \() / -_)   |  _|  / _ \   | |) | | _ \ | __ | / _ \ (_-< / -_)
  \_/\_/  \___|  |_|  \__|  \___/ |_|_|_|  \___|    \__|  \___/   |___/  |___/ |_||_| \___/ /__/ \___|
```

Класс `DBHose` предоставляет универсальный интерфейс для переноса данных между различными источниками в Apache Airflow DAGs.

## ⚠️ Статус проекта

**Проект находится в стадии альфа-тестирования** и может содержать ошибки. Используйте с осторожностью в production-средах.

## Поддерживаемые СУБД

На данный момент работа с СУБД поддерживается только между следующими базами данных:

- **ClickHouse**
- **Greenplum** 
- **PostgreSQL**

## Описание

DBHose - это инструмент для безопасного и эффективного перемещения данных между:
- Файлами дампов
- Python итераторами
- DataFrame (Pandas/Polars)
- Поддерживаемыми СУБД (ClickHouse, Greenplum, PostgreSQL)

Класс включает встроенные проверки качества данных (Data Quality) и поддерживает различные методы перемещения данных.

## Инициализация

```python
DBHose(
    table_dest: str,
    connection_dest: str,
    connection_src: str | None = None,
    dq_skip_check: list[str] = [],
    filter_by: list[str] = [],
    drop_temp_table: bool = True,
    move_method: MoveMethod = MoveMethod.replace,
    custom_move: str | None = None,
    compress_method: CompressionMethod = CompressionMethod.ZSTD,
    timeout: int = DBMS_DEFAULT_TIMEOUT_SEC,
)
```

## Параметры

- **`table_dest`** (`str`) - целевая таблица для загрузки данных
- **`connection_dest`** (`str`) - подключение к целевой БД (должна быть одной из поддерживаемых: ClickHouse, Greenplum, PostgreSQL)
- **`connection_src`** (`str`, optional) - подключение к исходной БД (если отличается от целевой)
- **`dq_skip_check`** (`list[str]`) - список проверок качества данных для пропуска
- **`filter_by`** (`list[str]`) - список колонок для фильтрации при перемещении данных
- **`drop_temp_table`** (`bool`) - удалять ли временную таблицу после операции (по умолчанию `True`)
- **`move_method`** (`MoveMethod`) - метод перемещения данных (по умолчанию `MoveMethod.replace`)
- **`custom_move`** (`str`, optional) - пользовательский SQL запрос для перемещения данных
- **`compress_method`** (`CompressionMethod`) - метод сжатия для дампов (по умолчанию `CompressionMethod.ZSTD`)
- **`timeout`** (`int`) - таймаут операций с БД в секундах (по умолчанию `DBMS_DEFAULT_TIMEOUT_SEC` = 300)

## Методы

### Основные методы загрузки данных

#### `from_file(fileobj: BufferedReader)`
Загрузка данных из файла дампа.

**Параметры:**
- `fileobj` (`BufferedReader`) - файловый объект для чтения дампа

#### `from_iterable(dtype_data: Iterable[Any])`
Загрузка данных из Python итератора.

**Параметры:**
- `dtype_data` (`Iterable[Any]`) - итерируемый объект с данными

#### `from_frame(data_frame: PDFrame | PLFrame)`
Загрузка данных из DataFrame (Pandas или Polars).

**Параметры:**
- `data_frame` (`PDFrame | PLFrame`) - DataFrame в формате Pandas или Polars

#### `from_dmbs(query: str | None = None, table: str | None = None)`
Загрузка данных из СУБД с использованием SQL запроса или прямой выгрузки из таблицы.

**Параметры:**
- `query` (`str`, optional) - SQL запрос для выборки данных
- `table` (`str`, optional) - имя таблицы для прямой выгрузки

### Вспомогательные методы

#### `create_temp()`
Создание временной таблицы для промежуточного хранения данных.

#### `drop_temp()`
Удаление временной таблицы.

#### `dq_check(table: str | None = None)`
Запуск проверок качества данных.

**Параметры:**
- `table` (`str`, optional) - имя исходной таблицы для сравнения данных

#### `to_table()`
Перемещение данных из временной таблицы в целевую.

## Пример использования в DAG

```python
from datetime import datetime

from airflow import DAG
from airflow.operators.python import PythonOperator
from dbhose_airflow import (
    DBHose,
    MoveMethod,
)

def transfer_data():
    # Перенос данных из PostgreSQL в ClickHouse
    dbhose = DBHose(
        table_dest="target_table",
        connection_dest="clickhouse_conn",
        connection_src="postgres_conn",
        move_method=MoveMethod.replace
    )
    
    dbhose.from_dmbs(table="source_table")

with DAG('data_transfer_dag', start_date=datetime(2025, 10, 27)) as dag:
    transfer_task = PythonOperator(
        task_id='transfer_data',
        python_callable=transfer_data
    )
```

## Ограничения альфа-версии

- Поддерживаются только ClickHouse, Greenplum и PostgreSQL
- Возможны ошибки при работе с большими объемами данных
- API может изменяться в будущих версиях
- Не все функции могут быть полностью протестированы
- Документация может быть неполной

## Особенности

- **Автоматическое создание временных таблиц** - данные сначала загружаются во временную таблицу
- **Проверки качества данных** - встроенные проверки перед финальным перемещением
- **Гибкие методы перемещения** - поддержка различных стратегий обновления данных
- **Поддержка множества источников** - файлы, DataFrame, СУБД
- **Логирование операций** - детальное логирование всех этапов процесса

## Требования

- Apache Airflow
- Подключения к поддерживаемым БД, настроенные в Airflow
- Соответствующие драйверы БД (clickhouse-driver, psycopg2, etc.)
- Файлы SQL шаблонов для DDL и операций перемещения

## Примечания

- Класс использует временные таблицы для обеспечения целостности данных
- Все операции включают проверки качества данных, которые можно кастомизировать
- Поддерживаются различные методы сжатия для оптимизации передачи данных
- **В альфа-версии рекомендуется тщательно тестировать все сценарии использования**

## Сообщения об ошибках

При обнаружении ошибок или неожиданного поведения, пожалуйста, сообщайте о них для улучшения стабильности проекта
