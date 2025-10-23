# advanced-data-analytics

This repository contains SQL Server examples that build a small analytics warehouse and explore richer BI-style reporting. It expands on the basic project with customer, product, segmentation, and part-to-whole analyses. For the foundational setup, see Part 1, **Basic Data Analytics**, at https://github.com/chanupadeshan/basic-data-analytics.

## Contents

- `datasets/` — sample CSV files (`gold.dim_customers.csv`, `gold.dim_products.csv`, `gold.fact_sales.csv`)
- `script/` — SQL scripts that create and analyze the `DataWarehouseAnalytics` database:
  - `initialize_database.sql` — creates the database, `gold` schema, tables, and bulk-loads the CSV files (drops the database if it already exists).
  - `change_over_time.sql` — monthly sales trends covering totals, orders, averages, and items sold.
  - `cumulative_analysis.sql` — cumulative sales by month/year plus a yearly moving average.
  - `performance_analysis.sql` — product performance compared to the category average and the previous year.
  - `part_to_whole.sql` — breaks down sales contribution by product category and returns percentage-of-total metrics.
  - `Data_segmentation.sql` — segments products into cost ranges and buckets customers (VIP, Regular, New) based on lifetime value and tenure.
  - `customer_report.sql` — materializes `gold.report_customers` with KPIs such as total orders, sales, recency, lifespan, and spend segmentation.
  - `product_report.sql` — materializes `gold.report_products` with sales KPIs, product segmentation, pricing insights, and recency tracking.
