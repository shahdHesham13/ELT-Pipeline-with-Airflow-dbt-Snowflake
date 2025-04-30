import os
from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    'start_date': datetime(2023, 9, 10),
    'retries': 1,
}

with DAG(
    dag_id="dbt_dag",
    default_args=default_args,
    schedule_interval="@daily",
    catchup=False,
) as dag:
    
    run_dbt = BashOperator(
    task_id="run_dbt",
    bash_command="cd /opt/***/dags/data_pipeline && /home/airflow/.local/bin/dbt run",
    env={
        'DBT_USER': '{{ conn.snowflake_conn.login }}',
        'DBT_PASSWORD': '{{ conn.snowflake_conn.password }}',
        'DBT_ACCOUNT': '{{ conn.snowflake_conn.extra_dejson.account }}',
        'DBT_DATABASE': 'dbt_db',
        'DBT_SCHEMA': 'dbt_schema',
        'DBT_WAREHOUSE': '{{ conn.snowflake_conn.extra_dejson.warehouse }}',
        'DBT_ROLE': '{{ conn.snowflake_conn.extra_dejson.role }}',
    }
)