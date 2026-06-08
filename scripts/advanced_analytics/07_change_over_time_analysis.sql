/*
====================================================================================================================================
7. Changes Over Time Analysis: (Tracking business trends and seasonality over time)
====================================================================================================================================
Purpose:
    • Analyze how sales, orders, customers, and quantity change over time
    • Identify yearly and monthly business trends
    • Detect seasonality patterns and growth behavior
    • Compare low-granularity and high-granularity time analysis
    • Understand chronological performance progression
====================================================================================================================================
*/

-- Total sales, orders, customers & product quantity in each year (i.e. low granularity)
SELECT
YEAR(order_date) order_year,
SUM(sales_amount) total_sales,
COUNT(DISTINCT order_id) total_orders,
COUNT(DISTINCT customer_key) total_customers,
SUM(quantity) total_quantity 
FROM gold.fact_sales_info
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Total sales, orders, customers & product quantity in each month (detailed insight to discover seasonality i.e. high granularity)
SELECT
FORMAT(order_date, 'MMM yyyy') order_month,   -- Returns abbreviated month name (useful for reporting)
DATETRUNC(MONTH, order_date) order_date,
SUM(sales_amount) total_sales,
COUNT(DISTINCT order_id) total_orders,
COUNT(DISTINCT customer_key) total_customers,
SUM(quantity) total_quantity
FROM gold.fact_sales_info
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date), FORMAT(order_date, 'MMM yyyy')
ORDER BY order_date;

-- Note: Using MONTH(), aggegates identical months across different years if we dont have WHERE clause to filter out specific year.
--       DATETRUNC() is superior in deciding granularity for chronological timelines as it truncates the date/timestamp safely to 
--       the specific date part, preserving continuity.