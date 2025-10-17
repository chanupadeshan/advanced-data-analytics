
/*
=============================================================
 Create Database and Schemas
=============================================================
 Script Purpose:
   - Creates a new database named 'DataWarehouseAnalytics'
   - Drops and recreates if it already exists
   - Creates schema 'gold'
   - Loads data from CSV files located in /var/opt/mssql/data/
 WARNING:
   Running this script will drop the entire 'DataWarehouseAnalytics' 
   database if it exists. All data will be permanently deleted. 
   Ensure you have backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-- Create Schemas
CREATE SCHEMA gold;
GO

-- Create Tables
CREATE TABLE gold.dim_customers(
    customer_key int,
    customer_id int,
    customer_number nvarchar(50),
    first_name nvarchar(50),
    last_name nvarchar(50),
    country nvarchar(50),
    marital_status nvarchar(50),
    gender nvarchar(50),
    birthdate date,
    create_date date
);
GO

CREATE TABLE gold.dim_products(
    product_key int,
    product_id int,
    product_number nvarchar(50),
    product_name nvarchar(50),
    category_id nvarchar(50),
    category nvarchar(50),
    subcategory nvarchar(50),
    maintenance nvarchar(50),
    cost int,
    product_line nvarchar(50),
    start_date date
);
GO

CREATE TABLE gold.fact_sales(
    order_number nvarchar(50),
    product_key int,
    customer_key int,
    order_date date,
    shipping_date date,
    due_date date,
    sales_amount int,
    quantity tinyint,
    price int
);
GO

-- ===============================================
-- Load Data from CSV files (Linux path version)
-- ===============================================

-- dim_customers
TRUNCATE TABLE gold.dim_customers;
GO
BULK INSERT gold.dim_customers
FROM '/var/opt/mssql/data/gold.dim_customers.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

-- dim_products
TRUNCATE TABLE gold.dim_products; -- TRUNCATE : removes all rows from the table
GO
BULK INSERT gold.dim_products --BULK insert : load data from a external files
FROM '/var/opt/mssql/data/gold.dim_products.csv'
WITH (
    FIRSTROW = 2, -- skip the 1st row for header and start from 2nd row
    FIELDTERMINATOR = ',', --columns are separated by comma
    ROWTERMINATOR = '0x0a', --each row ends with new line
    TABLOCK --lock the table during bulk insert for performance
);
GO

-- fact_sales
TRUNCATE TABLE gold.fact_sales;
GO
BULK INSERT gold.fact_sales
FROM '/var/opt/mssql/data/gold.fact_sales.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

-- ===============================================
-- Validation Queries
-- ===============================================
SELECT COUNT(*) AS total_customers FROM gold.dim_customers;
SELECT COUNT(*) AS total_products  FROM gold.dim_products;
SELECT COUNT(*) AS total_sales     FROM gold.fact_sales;
GO

