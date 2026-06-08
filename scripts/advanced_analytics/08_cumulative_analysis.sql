/*
===============================================================================================================================
8. Cumulative Analysis: (Understanding cumulative growth and long-term business performance)
===============================================================================================================================
Purpose:
    • Analyze cumulative business performance over time
    • Calculate running totals and running averages
    • Evaluate Year-to-Date (YTD) business growth
    • Compare monthly performance against running benchmarks
    • Measure progressive sales and pricing trends
    • Identify periods of growth, decline, or stable performance
===============================================================================================================================
*/

-- Running Total of Annual Sales & Running Average of Annual Average Unit Price
-- Grain: One row per year
WITH sales_by_year AS
(
    SELECT
    YEAR(order_date) order_year,
    SUM(sales_amount) total_sales,   -- Total sales revenue for the year
    AVG(unit_price) avg_price        -- Average unit price for the year
    FROM gold.fact_sales_info
    WHERE YEAR(order_date) IS NOT NULL
    GROUP BY YEAR(order_date)
)

SELECT
order_year,
total_sales,
avg_price,
SUM(total_sales) OVER(ORDER BY order_year) running_total_sales,   -- Running total of annual sales
AVG(avg_price) OVER(ORDER BY order_year) running_avg_price        -- Running average of annual average unit price
FROM sales_by_year
ORDER BY order_year;

-- Running Total of Monthly Sales & Running Average of Monthly Average Unit Price
-- Grain: One row per month
SELECT
t.*,
SUM(total_sales) OVER(ORDER BY order_date) running_total_sales,   -- Running total of monthly sales across all years
AVG(avg_price) OVER(ORDER BY order_date) running_avg_price        -- Running average of monthly average unit price across all years
FROM (
    SELECT
    DATETRUNC(MONTH, order_date) order_date,
    SUM(sales_amount) total_sales,   -- Total sales revenue for the month
    AVG(unit_price) avg_price        -- Average unit price for the month
    FROM gold.fact_sales_info
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)t
ORDER BY order_date;

-- Year-to-Date Running Total of Monthly Sales & Running Average of Monthly Average Unit Price (Resets each year)
-- Grain: One row per year
SELECT
DATETRUNC(MONTH, order_date) order_date,
SUM(sales_amount) total_sales,   -- Total sales revenue for the month
AVG(unit_price) avg_price,       -- Average unit price for the month
SUM(SUM(sales_amount)) OVER(PARTITION BY DATETRUNC(YEAR, order_date) ORDER BY DATETRUNC(MONTH, order_date)) running_total_sales,   -- YTD running sales total
AVG(AVG(unit_price)) OVER(PARTITION BY DATETRUNC(YEAR, order_date) ORDER BY DATETRUNC(MONTH, order_date)) running_avg_price        -- YTD running average of monthly average unit price
FROM gold.fact_sales_info
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date), DATETRUNC(YEAR, order_date)
ORDER BY DATETRUNC(MONTH, order_date);

-- Year-to-Date Running Sales & Unweighted Catalog Price Trend
-- Grain: One row per month
SELECT
order_date,
SUM(sales_per_product) total_sales,                -- Total monthly sales across all products
AVG(avg_price_per_product) unweighted_avg_price,   -- Unweighted average product price across products
SUM(SUM(sales_per_product)) OVER(PARTITION BY DATETRUNC(YEAR, order_date) ORDER BY order_date) running_total_sales,               -- YTD running sales total
AVG(AVG(avg_price_per_product)) OVER(PARTITION BY DATETRUNC(YEAR, order_date) ORDER BY order_date) running_unweighted_avg_price   -- YTD running average of monthly unweighted catalog price
FROM (
    SELECT
    DATETRUNC(MONTH, order_date) order_date,
    SUM(sales_amount) sales_per_product,    -- Total sales for each product in the month
    AVG(unit_price) avg_price_per_product   -- Average unit price for each product in the month
    FROM gold.fact_sales_info
    WHERE order_date IS NOT NULL
    GROUP BY product_key, DATETRUNC(MONTH, order_date)   --product level granularity
)t
GROUP BY order_date
ORDER BY order_date;

-- Year-to-Date Running Average of Monthly Product Average Sales per Order
-- Grain: One row per month
WITH monthly_product_sales AS
(
    SELECT
    DATETRUNC(MONTH, s.order_date) order_month,
    p.product_name,
    AVG(s.sales_amount) avg_product_sales_per_order   -- Average sales amount of a product per order within the month
    FROM gold.fact_sales_info s
    LEFT JOIN gold.dim_product_info p
    ON s.product_key = p.product_key
    WHERE s.order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, s.order_date), p.product_name
)

SELECT
order_month,
AVG(avg_product_sales_per_order) avg_product_sales,   -- Average product sales per order across all products in the month
AVG(AVG(avg_product_sales_per_order)) OVER(PARTITION BY YEAR(order_month) ORDER BY order_month) running_avg_product_sales,   -- YTD running average of monthly product average sales
CASE WHEN AVG(avg_product_sales_per_order) > AVG(AVG(avg_product_sales_per_order)) OVER(PARTITION BY YEAR(order_month) ORDER BY order_month) THEN 'Above Average'
     WHEN AVG(avg_product_sales_per_order) = AVG(AVG(avg_product_sales_per_order)) OVER(PARTITION BY YEAR(order_month) ORDER BY order_month) THEN 'Average'
     ELSE 'Below Average' END sales_performance   -- Compare current month's average product sales against YTD benchmark
FROM monthly_product_sales
GROUP BY order_month, YEAR(order_month)
ORDER BY order_month;