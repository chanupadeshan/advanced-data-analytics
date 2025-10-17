USE DataWarehouseAnalytics;
GO


/* analyse the yearly performance of products by comparing their sales to 
both the average sales performance of the product and the previous year's sales */

WITH yearly_product_sales AS (
    SELECT 
        YEAR(fs.order_date) AS order_year,
        dp.product_name,
        SUM(fs.sales_amount) AS current_sales
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_products AS dp
        ON fs.product_key = dp.product_key
    WHERE fs.order_date IS NOT NULL
    GROUP BY YEAR(fs.order_date), dp.product_name
)
SELECT 
    yps.order_year,
    yps.product_name,
    yps.current_sales,
    AVG(yps.current_sales) OVER (PARTITION BY yps.product_name) AS avg_product_sales,
    yps.current_sales - AVG(yps.current_sales) OVER (PARTITION BY yps.product_name) AS sales_vs_avg,
    CASE 
        WHEN  yps.current_sales -  AVG(yps.current_sales) OVER (PARTITION BY yps.product_name) > AVG(yps.current_sales) OVER (PARTITION BY yps.product_name) THEN 'Above Average'
        WHEN  yps.current_sales -  AVG(yps.current_sales) OVER (PARTITION BY yps.product_name) < AVG(yps.current_sales) OVER (PARTITION BY yps.product_name) THEN 'Below Average'
        ELSE 'Average'
    END AS performance_vs_avg,
    LAG(yps.current_sales) OVER (PARTITION BY yps.product_name ORDER BY yps.order_year) AS previous_year_sales,
    yps.current_sales - LAG(yps.current_sales) OVER (PARTITION BY yps.product_name ORDER BY yps.order_year) AS sales_vs_previous_year,
    CASE
        WHEN yps.current_sales - LAG(yps.current_sales) OVER (PARTITION BY yps.product_name ORDER BY yps.order_year) > 0 THEN 'Increase'
        WHEN yps.current_sales - LAG(yps.current_sales) OVER (PARTITION BY yps.product_name ORDER BY yps.order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS performance_vs_previous_year
FROM yearly_product_sales as yps
ORDER BY yps.product_name, yps.order_year;