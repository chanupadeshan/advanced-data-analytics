# basic-data-analytics

This repository contains simple example SQL scripts and CSV datasets to explore a small data warehouse-style project using SQL Server (mssql).

Contents

- `datasets/` - sample CSV files (gold.dim_customers.csv, gold.dim_products.csv, gold.fact_sales.csv)

- `script/` - useful SQL scripts:
  - `initialize_database.sql` — creates the `DataWarehouseAnalytics` database, `gold` schema, tables, and bulk-loads data from CSV files (this will DROP the database if it exists)
  - `change_over_time.sql` — monthly sales trends (totals, orders, average, items)
  - `cumulative_analysis.sql` — cumulative sales by month/year; yearly moving average
  - `performance_analysis.sql` — product performance vs average and previous year

