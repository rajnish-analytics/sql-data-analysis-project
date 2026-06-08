/*
=================================================================================================================================
10. Part-to-Whole / Proportional Analysis: (Understanding the contribution of individual segments to overall business performance)
=================================================================================================================================
Purpose:
    • Analyze the proportional contribution of categories, countries, and years to overall business performance
    • Identify the highest contributing business segments and key revenue drivers
    • Compare category-wise, country-wise, and yearly contribution to overall sales and orders
    • Measure percentage contribution using proportional and window-based calculations
    • Understand business concentration across products, customers, and time periods
=================================================================================================================================
*/

-- Categories that contribute the most to overall sales
SELECT
p.category,
SUM(s.sales_amount) total_sales,
SUM(SUM(s.sales_amount)) OVER() overall_sales,
CONCAT(CAST((SUM(s.sales_amount)*100.0 / SUM(SUM(s.sales_amount)) OVER()) AS DECIMAL(10, 2)), '%') sales_percentage
FROM gold.fact_sales_info s
LEFT JOIN gold.dim_product_info p
ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY 2 DESC;

-- Countries that contribute the most to orders and customers
WITH cust_by_cntry AS
(
    SELECT
    country,
    COUNT(DISTINCT order_id) total_orders,
    COUNT(DISTINCT customer_id) total_customers
    FROM gold.fact_sales_info s
    LEFT JOIN gold.dim_customer_info c
    ON s.customer_key = c.customer_key
    GROUP BY country
)

SELECT
country,
total_orders,
total_customers,
CONCAT(CAST((total_orders*100.0 / SUM(total_orders) OVER()) AS DECIMAL(10, 2)), '%') orders_percentage,
CONCAT(CAST((total_customers*100.0 / SUM(total_customers) OVER()) AS DECIMAL(10, 2)), '%') customers_percentage
FROM cust_by_cntry
ORDER BY total_orders DESC;

-- Years that contribute the most to the revenue (Historization)
SELECT
YEAR(order_date) sales_year,
SUM(sales_amount) total_sales,
(SELECT SUM(sales_amount) FROM gold.fact_sales_info) overall_sales,   -- Scalar Subquery for total sales
CONCAT(CAST(SUM(sales_amount) * 100.0 / (SELECT SUM(sales_amount) FROM gold.fact_sales_info) AS DECIMAL(10,2)), '%') sales_percentage
FROM gold.fact_sales_info
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY 1;

-- Note: We used (SELECT SUM(sales_amount) FROM gold.fact_sales_info), a scalar subquery, because it gives total sales 
--       including where order_date is NULL but window function method SUM(SUM(sales_amount)) OVER() would exclude 
--       revenue from rows where order_date is NULL which we don't want.