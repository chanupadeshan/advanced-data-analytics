USE DataWarehouseAnalytics;
GO


-- which categories contribute the most to overall sales?

WITH category_sales AS (
    SELECT p.category, SUM(s.sales_amount) AS total_sales
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    GROUP BY p.category
)
SELECT  
    category,
    total_sales,
    CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100.0,2), '%') AS sales_percentage
FROM category_sales
ORDER BY total_sales DESC;
