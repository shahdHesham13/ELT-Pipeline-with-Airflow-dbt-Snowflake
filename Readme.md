# ELT Pipeline with Airflow, dbt & Snowflake

This project reflects a learning journey in data engineering and pipeline development using modern cloud tooling. While it began as an exploration, it turned into a hands-on implementation of Orchestration, Transformation, and Cloud Data Warehousing.

The work involved setting up a Snowflake environment, configuring and connecting DBT locally to model and transform the data, and orchestrating the workflow using Apache Airflow to schedule and automate the execution of DBT jobs.

## Navigation

- [Project Structure](#project-structure)
- [Tech-Stack](#tech-stack)
- [Project Setup](#project-setup)
- [Highlights](#highlights)
- [Notes](#notes)



## Project Structure

<details> <summary><strong>Directories</strong></summary>
	
```
AirflowDBT/
├── dags/
│   └── dbt_dag.py
│   └── data_pipeline/
│       ├── dbt_project.yml
│       ├── profiles.yml
│       ├── packages.yml
│       ├── packages-lock.yml
│       ├── .user.yml
│       ├── models/
│       │   ├── staging/
│       │   │   ├── stg_tpch_line_items.sql
│       │   │   ├── stg_tpch_orders.sql
│       │   │   └── tpch_sources.yml
│       │   └── marts/
│       │       ├── fct_orders.sql
│       │       ├── int_order_items_summary.sql
│       │       ├── int_order_items.sql
│       │       └── genericTests.yml
│       ├── macros/
│       │   └── pricing.sql
│       └── tests/
│           ├── fct_orders_date_valid.sql
│           └── fct_orders_discount.sql
├── .gitignore
├── docker-compose.yaml
├── dockerfile
└── .env

```
</details>

## Tech-Stack

- **Snowflake**: Cloud data warehouse used for data storage.
- **DBT (Data Build Tool)**: Transformation tool handles the SQL transformations in a modular, testable way.
- **Apache Airflow**: Orchestration tool to schedule and automate DBT runs.
- **Docker**: Makes the whole setup portable and easy to spin up.
- **Raw source data**: Snowflake's built-in TPCH sample dataset.

## Project Setup

1. **Snowflake Environment**:
   - Manually set up: `Warehouse`, `Database`, `Schema`, and access `Role`.
   - Granted permissions to ensure DBT could execute models securely.
   - Queried the `SNOWFLAKE_SAMPLE_DATA.TPCH_SF1` schema to access sample TPCH tables as raw input.

2. **DBT Local Setup**:
   - Installed DBT within a Python virtual environment.
		```bash
		python -m venv dbt-env
		dbt-env\Scripts\activate
		pip install dbt-core dbt-snowflake
		```

   - Created the `profiles.yml` file to securely connect DBT to Snowflake.
   - Defined `models` into two main layers:
     - `staging`: Raw data was cleaned and renamed.
     - `marts`: Fact tables were built by joining cleaned staging models.
   - Explored the DBT documentation site (`dbt docs serve`) to visualize the **lineage graph**. This helped understand data flow, and ensure each transformation step was correctly linked.

	<a href="https://imgur.com/vBQD1K7"><img src="https://i.imgur.com/vBQD1K7.png" title="source: imgur.com" /></a>

2. **Apache Airflow Integration**:
   - Used Airflow DAG to automate the execution of DBT models.
   - Ensure DBT is installed inside Airflow's environment or Docker.


## Highlights

- Practiced end-to-end development of a data pipeline.
- Automated transformation runs with Apache Airflow.
- Developed a better understanding of how DBT handles compilation, dependencies, and testing.


## Notes

- I used the Snowflake TPCH dataset, a free sample dataset provided by Snowflake. It was available in a read-only format and used as the raw source data for querying and transformation.
- Airflow is used just for **orchestration**, not transformation.
- Airflow was configured to trigger `dbt run` and `dbt test` from a Python DAG using `BashOperator`.
- Opening the **DBT Docs UI** and exploring the **lineage graph** helped visualize dependencies and the flow.
- Changing or renaming models required running `dbt clean && dbt deps` and sometimes `dbt run --full-refresh` to avoid stale metadata.
- Future ideas: add CI/CD with GitHub Actions, and dimensional modeling.