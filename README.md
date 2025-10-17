# basic-data-analytics

This repository contains simple example SQL scripts and CSV datasets to explore a small data warehouse-style project using SQL Server (mssql).

Contents

- `datasets/` - sample CSV files (gold.dim_customers.csv, gold.dim_products.csv, gold.fact_sales.csv)

- `scripts/` - useful SQL scripts:
  - `initialize_database.sql` — creates the `DataWarehouseAnalytics` database, `gold` schema, tables, and bulk-loads data from CSV files (this will DROP the database if it exists)
  - `database_exploration.sql` — lists tables and columns
  - `date_exploration.sql` — date range and age queries
  - `dimentsions_exploration.sql` — (typo: "dimentions") explore dimension tables
  - `magnitute_analysis.sql` — aggregation and revenue queries
  - `measures_exploration.sql` — measures and summary report
  - `ranking_analysis.sql` — top/bottom ranking queries

