from datetime import datetime

from airflow import DAG
from airflow.operators.python import PythonOperator
from dbhose_airflow import (
    DBHose,
    MoveMethod,
)


def transfer_data():

    dbhose = DBHose(
        table_dest="target_table",
        connection_dest="clickhouse_conn",
        connection_src="postgres_conn",
        move_method=MoveMethod.replace,
    )

    dbhose.from_dmbs(table="default.source_table")


with DAG(
    'data_transfer_dag',
    start_date=datetime(2025, 10, 27),
) as dag:

    transfer_task = PythonOperator(
        task_id='transfer_data',
        python_callable=transfer_data,
    )
