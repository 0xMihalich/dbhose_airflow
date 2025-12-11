.. _quickstart:

Быстрый старт
*************

Установка библиотеки
====================

.. literalinclude:: ./install.sh
   :language: bash

При установке основного модуля будут так же установлены дополнительные пакеты.

Опционально можно установить дополнительный пакет dbhose-utils для работы с дампами:

.. literalinclude:: ./install_utils.sh
   :language: bash

Сборка в Docker контейнере для образа Airflow
=============================================

Требования
^^^^^^^^^^

- **Версия Airflow не ниже 2.4.3**
- **Отсутствие в constraints жесткой привязки к версии ниже чем требуется для следующих модулей:**

.. code-block:: text

    cffi>=1.17.1
    lz4>=4.4.3
    zstandard>=0.23.0
    pandas>=2.1.0
    polars>=0.20.31
    psycopg_binary>=3.3.2
    psycopg>=3.3.2
    sqlparse>=0.5.4
    backports.zoneinfo==0.2.1;python_version<"3.9"

Для установки актуальной версии dbhose-airflow добавьте в ``requirements.txt`` актуальную версию пакета:

.. code-block:: text

    dbhose-airflow==0.1.0.1
    dbhose-utils==0.0.2.4

Выполните пересборку образа:

.. literalinclude:: ./rebuild_docker.sh
   :language: bash

Пример простого DAG, выполняющего выгрузку таблицы из PostgreSQL в ClickHouse
=============================================================================

.. literalinclude:: ./simple_dag.py
   :language: python
