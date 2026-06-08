/*
=========================================================================================================================
6. Ranking Analysis: (Top N performers | Bottom N performers)
=========================================================================================================================
Purpose:
    • Identify top and bottom performing customers and products
    • Rank entities based on revenue, sales, and order activity
    • Analyze best-selling and least-selling products
    • Highlight high-value customers and product segments
=========================================================================================================================
*/

-- Top 10 customers who have generated highest revenue (Purpose: Target audience for layalty rewards)
SELECT
*
FROM (
    SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(s.sales_amount) total_revenue,
    ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) rank
    FROM gold.fact_sales_info s
    LEFT JOIN gold.dim_customer_info c
    ON s.customer_key = c.customer_key
    GROUP BY c.customer_key, c.first_name, c.last_name
)t
WHERE rank <= 10;

-- Top 3 customers with few orders
SELECT TOP 3
c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT s.order_id) total_orders
FROM gold.fact_sales_info s
LEFT JOIN gold.dim_customer_info c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY 4, 1;

-- Top 3 customers from each country who have generated highest revenue
SELECT
*
FROM (
    SELECT
    c.country,
    c.first_name + ' ' + c.last_name customer_name,
    SUM(s.sales_amount) total_revenue,
    ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY SUM(s.sales_amount) DESC) rank
    FROM gold.fact_sales_info s
    LEFT JOIN gold.dim_customer_info c
    ON s.customer_key = c.customer_key
    WHERE country <> 'N/A'
    GROUP BY c.customer_key, c.country, c.first_name, c.last_name
)t
WHERE rank <= 3
ORDER BY 1;

-- Top 5 products which generate highest revenue (Best performing)
SELECT TOP 5
p.product_name,
SUM(s.sales_amount) total_revenue
FROM gold.fact_sales_info s
LEFT JOIN gold.dim_product_info p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY 2 DESC;

-- Top 5 products which generate lowest revenue (Worst performing)
SELECT TOP 5
p.product_name,
SUM(s.sales_amount) total_revenue
FROM gold.fact_sales_info s
LEFT JOIN gold.dim_product_info p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY 2 ASC;

-- Top 5 product sub-categories which generate highest revenue (Best performing)
SELECT TOP 5
p.subcategory,
SUM(s.sales_amount) total_revenue
FROM gold.fact_sales_info s
LEFT JOIN gold.dim_product_info p
ON s.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY 2 DESC;

-- Top 5 product sub-categories which generate lowest revenue (Worst performing)
SELECT TOP 5
p.subcategory,
SUM(s.sales_amount) total_revenue
FROM gold.fact_sales_info s
LEFT JOIN gold.dim_product_info p
ON s.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY 2 ASC;

-- Top 3 products which generate highest revenue from each category (Best performing category-wise)
SELECT
*
FROM (
    SELECT
    p.category,
    p.product_name,
    SUM(s.sales_amount) total_revenue,
    ROW_NUMBER() OVER(PARTITION BY p.category ORDER BY SUM(s.sales_amount) DESC) rank
    FROM gold.fact_sales_info s
    LEFT JOIN gold.dim_product_info p
    ON s.product_key = p.product_key
    GROUP BY p.category, p.product_name
)t
WHERE rank <= 3;

-- Top 3 products which generate lowest revenue from each category (Worst performing category-wise)
SELECT
*
FROM (
    SELECT
    p.category,
    p.product_name,
    SUM(s.sales_amount) total_revenue,
    ROW_NUMBER() OVER(PARTITION BY p.category ORDER BY SUM(s.sales_amount) ASC) rank
    FROM gold.fact_sales_info s
    LEFT JOIN gold.dim_product_info p
    ON s.product_key = p.product_key
    GROUP BY p.category, p.product_name
)t
WHERE rank <= 3;

-- Three most sold products
SELECT TOP 3
p.product_name,
SUM(s.quantity) total_sold_quantity
FROM gold.fact_sales_info s
LEFT JOIN gold.dim_product_info p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY 2 DESC;

-- Three least sold products
SELECT TOP 3
p.product_name,
SUM(s.quantity) total_sold_quantity
FROM gold.fact_sales_info s
LEFT JOIN gold.dim_product_info p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY 2;
