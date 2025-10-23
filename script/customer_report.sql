/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================


USE DataWarehouseAnalytics;
GO


CREATE VIEW gold.report_customers AS
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
WITH base_query AS(
SELECT 
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
c.birthdate,
DATEDIFF(year, c.birthdate, GETDATE()) AS age
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE s.order_date IS NOT NULL),

customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/

SELECT 
customer_key,
customer_number,
customer_name,
birthdate,
age,
COUNT(DISTINCT order_number) AS total_orders,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT product_key) AS total_products,
MAX(order_date) AS last_order_date,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_months
FROM base_query
GROUP BY customer_key, customer_number, customer_name, birthdate, age
)

SELECT 

customer_key,
customer_number,
customer_name,
birthdate,
age,
CASE 
    WHEN age < 18 THEN 'Under 18'
    WHEN age BETWEEN 18 AND 25 THEN '18-25'
    WHEN age BETWEEN 26 AND 35 THEN '26-35'
    WHEN age BETWEEN 36 AND 45 THEN '36-45'
    WHEN age BETWEEN 46 AND 55 THEN '46-55'
    WHEN age BETWEEN 56 AND 65 THEN '56-65'
    ELSE '66 and above'
END AS age_group,
CASE
    WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
    WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'Regular'
    ELSE 'New'
END AS customer_segment,
total_orders,
total_sales,
total_quantity,
total_products,
last_order_date,
DATEDIFF(MONTH,last_order_date,GETDATE()) AS recency_months,
lifespan_months,

---compute average order value (AOV)
CASE 
    WHEN total_orders = 0 THEN 0
    ELSE total_sales/total_orders 
END AS average_order_value,


---compute average monthly spend
CASE
    WHEN lifespan_months = 0 THEN total_sales
    ELSE total_sales / lifespan_months
END AS average_monthly_spend
FROM customer_aggregation;



