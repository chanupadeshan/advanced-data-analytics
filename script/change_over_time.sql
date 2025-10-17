USE DataWarehouseAnalytics;
GO


SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales ,
    COUNT(DISTINCT customer_key) AS total_orders,
    AVG(sales_amount) AS avg_sales_per_order,
    COUNT(quantity) AS total_items_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);


SELECT
    FORMAT(order_date,'yyyy-MMM') AS order_date,
    SUM(sales_amount) AS total_sales ,
    COUNT(DISTINCT customer_key) AS total_orders,
    AVG(sales_amount) AS avg_sales_per_order,
    COUNT(quantity) AS total_items_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date,'yyyy-MMM')
ORDER BY FORMAT(order_date,'yyyy-MMM');