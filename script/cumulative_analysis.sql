USE DataWarehouseAnalytics;
GO

-- calculate the total sales per month cumulatively

SELECT
    t.order_date,
    t.total_sales,
    SUM(t.total_sales) OVER (ORDER BY t.order_date) AS cumulative_sales
FROM
    (
    SELECT
        DateTrunc(month, order_date) as order_date,
        SUM(sales_amount) as total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DateTrunc(month, order_date)
    ) AS t


-- calculate the total sales per year cumulatively

SELECT
    t.order_date,
    t.total_sales,
    SUM(t.total_sales) OVER (ORDER BY t.order_date) AS cumulative_sales,
    AVG(t.total_sales) OVER (ORDER BY t.order_date ) AS moving_avg_sales
FROM
    (
    SELECT
        DateTrunc(year, order_date) as order_date,
        SUM(sales_amount) as total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DateTrunc(year, order_date)
    ) AS t
