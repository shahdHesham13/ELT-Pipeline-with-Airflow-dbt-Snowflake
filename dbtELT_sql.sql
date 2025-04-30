-- create accounts
use role accountadmin;

create warehouse dbt_wh with warehouse_size='x-small';
create database if not exists dbt_db;
create role if not exists dbt_role;

show grants on warehouse dbt_wh;

grant usage on warehouse dbt_wh to role dbt_role;
grant role dbt_role to user shahedhesham;
grant all on database dbt_db to role dbt_role;

use role dbt_role;

create schema if not exists dbt_db.dbt_schema;

-- clean up
use role accountadmin;

drop warehouse if exists dbt_wh;
drop database if exists dbt_db;
drop role if exists dbt_role;


-- to test
DROP VIEW stg_tpch_line_items
DROP VIEW stg_tpch_orders

DROP TABLE fct_orders;
DROP TABLE int_order_items;
DROP TABLE int_order_items_summary;

-- queries
SELECT
    o_orderkey AS order_key,
    o_custkey AS customer_key,
    o_orderstatus AS status_code,
    o_totalprice AS total_price,
    o_orderdate AS order_date
FROM
    snowflake_sample_data.tpch_sf1.orders;    

SELECT
    (ROW_NUMBER() OVER (PARTITION BY l_orderkey, l_linenumber ORDER BY l_orderkey)) AS order_item_key,
    l_orderkey AS order_key,
    l_partkey AS part_key,
    l_linenumber AS line_number,
    l_quantity AS quantity,
    l_extendedprice AS extended_price,
    l_discount AS discount_percentage,
    l_tax AS tax_rate
FROM
    snowflake_sample_data.tpch_sf1.lineitem;


SELECT
    l_orderkey AS order_item_key,
    l_partkey AS part_key,
    l_linenumber AS line_number,
    l_extendedprice AS extended_price,
    o_orderkey AS order_key,
    o_custkey AS customer_key,
    o_orderdate AS order_date,
    (l_extendedprice * (1 - l_discount)) AS item_discount_amount
FROM
    snowflake_sample_data.tpch_sf1.orders AS orders
JOIN
    snowflake_sample_data.tpch_sf1.lineitem AS line_item
        ON orders.o_orderkey = line_item.l_orderkey
ORDER BY
    orders.o_orderdate;