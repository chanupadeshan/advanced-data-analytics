USE DataWarehouseAnalytics;
GO

-- segment products into cost ranges and count how many products fall into each segment

WITH product_segments AS (
SELECT product_key,product_name,cost,
CASE WHEN cost < 100 THEN 'Below 100'
     WHEN cost >= 100 AND cost < 500 THEN '100-499'
     WHEN cost >= 500 AND cost < 1000 THEN '500-999'
     ELSE '1000 and above' 
END AS cost_range
FROM gold.dim_products)

SELECT cost_range , COUNT(product_key) AS product_count
FROM product_segments
GROUP BY cost_range
ORDER BY 
    CASE 
        WHEN cost_range = 'Below 100' THEN 1
        WHEN cost_range = '100-499' THEN 2
        WHEN cost_range = '500-999' THEN 3
        WHEN cost_range = '1000 and above' THEN 4
    END;


/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH customer_lifespan AS (
SELECT 
c.customer_key,
SUM(s.sales_amount) AS total_spent,
MIN(s.order_date) AS first_order_date,
MAX(s.order_date) AS last_order_date,
DATEDIFF(MONTH, MIN(s.order_date), MAX(s.order_date)) AS lifespan_months
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key)


SELECT 
COUNT(customer_key) AS customer_count,
customer_segment
FROM (
    SELECT 
    customer_key,
    total_spent,
    lifespan_months,
    CASE
        WHEN lifespan_months >= 12 AND total_spent > 5000 THEN 'VIP'
        WHEN lifespan_months >= 12 AND total_spent <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment
    FROM customer_lifespan
) AS segmented_customers
GROUP BY customer_segment
ORDER BY 
    CASE 
        WHEN customer_segment = 'VIP' THEN 1
        WHEN customer_segment = 'Regular' THEN 2
        WHEN customer_segment = 'New' THEN 3
    END;
