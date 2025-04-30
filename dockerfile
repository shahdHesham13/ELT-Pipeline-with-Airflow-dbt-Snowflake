FROM apache/airflow:2.8.1-python3.8

USER root
RUN pip install dbt-core dbt-postgres dbt-snowflake

USER airflow