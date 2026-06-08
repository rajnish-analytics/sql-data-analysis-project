/*
==============================================================================================================================
11. Data Segmentation: (Grouping data into meaningful business segments for deeper analysis)
==============================================================================================================================
Purpose:
    • Segment products and customers into meaningful business groups
    • Analyze customer behavior based on spending patterns and purchase history
    • Categorize products using pricing tiers
    • Group customers into age-based and loyalty-based segments
    • Compare revenue distribution, customer concentration, and product contribution across segments
    • Understand patterns and trends within defined customer and product groups
==============================================================================================================================
*/

-- Products segmented into cost-based ranges
WITH product_segmentation AS
(
    SELECT
    product_id,
    product_name,
    CASE WHEN cost > 1000 THEN 'Above 1000'
         WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
         WHEN cost BETWEEN 100 AND 500 THEN '100-500'
         ELSE 'Below 100' END cost_range,
    CASE WHEN cost > 1000 THEN 4
         WHEN cost BETWEEN 500 AND 1000 THEN 3
         WHEN cost BETWEEN 100 AND 500 THEN 2
         ELSE 1 END segment_order   -- For sequential appearance of segment in the result
    FROM gold.dim_product_info
)

SELECT
cost_range,
COUNT(*) total_products
FROM product_segmentation
GROUP BY cost_range, segment_order
ORDER BY segment_order;

-- Customers grouped into spending-based segments using purchase behavior & engagement duration
WITH customer_segmentation AS
(
    SELECT
    s.customer_key,
    CASE WHEN SUM(sales_amount) > 5000 AND DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) >= '12' THEN 'VIP'
         WHEN SUM(sales_amount) <= 5000 AND DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) >= '12' THEN 'REGULAR'
         ELSE 'NEW' END customer_segment
    FROM gold.fact_sales_info s
    LEFT JOIN gold.dim_customer_info c
    ON s.customer_key = c.customer_key
    GROUP BY s.customer_key
)

SELECT
customer_segment,
COUNT(*) total_customers
FROM customer_segmentation
GROUP BY customer_segment
ORDER BY 2 DESC;

-- Products segmented into cost-based ranges with sales quantity & revenue contribution
WITH product_segmentation AS
(
    SELECT
    s.product_key,
    sales_amount,
    quantity,
    CASE WHEN cost > 1000 THEN 'Above 1000'
         WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
         WHEN cost BETWEEN 100 AND 500 THEN '100-500'
         ELSE 'Below 100' END cost_range,
    CASE WHEN cost > 1000 THEN 4
         WHEN cost BETWEEN 500 AND 1000 THEN 3
         WHEN cost BETWEEN 100 AND 500 THEN 2
         ELSE 1 END segment_order   -- For sequential appearance of segment in the result
    FROM gold.fact_sales_info s
    LEFT JOIN gold.dim_product_info p
    ON s.product_key = p.product_key
)

SELECT
cost_range,
SUM(quantity) total_quantity_sold,
SUM(sales_amount) total_revenue
FROM product_segmentation
GROUP BY cost_range, segment_order
ORDER BY segment_order;

-- Customers segmented into age-based ranges with customer & revenue distribution
WITH customer_segmentation AS
(
    SELECT
    CASE WHEN DATEDIFF(YEAR, birthdate, GETDATE()) < 30 THEN '30 and Below'
         WHEN DATEDIFF(YEAR, birthdate, GETDATE()) <= 40 THEN '31-40'   -- We can also use BETWEEN 31 AND 40 instead of '<=40'
         WHEN DATEDIFF(YEAR, birthdate, GETDATE()) <= 50 THEN '41-50'
         WHEN DATEDIFF(YEAR, birthdate, GETDATE()) <= 60 THEN '51-60'
         ELSE 'Above 60' END age_group,
    s.customer_key,
    s.sales_amount,
    CASE WHEN DATEDIFF(YEAR, birthdate, GETDATE()) < 30 THEN 1
         WHEN DATEDIFF(YEAR, birthdate, GETDATE()) <= 40 THEN 2
         WHEN DATEDIFF(YEAR, birthdate, GETDATE()) <= 50 THEN 3
         WHEN DATEDIFF(YEAR, birthdate, GETDATE()) <= 60 THEN 4
         ELSE 5 END segment_order   -- For sequential appearance of segment in the result
    FROM gold.fact_sales_info s
    LEFT JOIN gold.dim_customer_info c
    ON s.customer_key = c.customer_key
    WHERE birthdate IS NOT NULL
)

SELECT
age_group,
SUM(sales_amount) total_revenue,
COUNT(DISTINCT customer_key) total_customers
FROM customer_segmentation
GROUP BY age_group, segment_order
ORDER BY segment_order;

-- Alternate approach: Customers segmented into age-based ranges with customer & revenue distribution
WITH customer_segmentation AS
(
    SELECT
    s.customer_key,
    s.sales_amount,
    DATEDIFF(YEAR, c.birthdate, GETDATE()) age
    FROM gold.fact_sales_info s
    LEFT JOIN gold.dim_customer_info c
    ON s.customer_key = c.customer_key
    WHERE birthdate IS NOT NULL
)

SELECT
age_group,
SUM(sales_amount) total_revenue,
COUNT(DISTINCT customer_key) total_customers
FROM (
    SELECT
    customer_key,
    sales_amount,
    CASE WHEN age < 30 THEN '30 and Below'
         WHEN age <= 40 THEN '31-40'
         WHEN age <= 50 THEN '41-50'
         WHEN age <= 60 THEN '51-60'
         ELSE 'Above 60' END age_group,
    CASE WHEN age < 30 THEN 1
         WHEN age <= 40 THEN 2
         WHEN age <= 50 THEN 3
         WHEN age <= 60 THEN 4
         ELSE 5 END segment_order
    FROM customer_segmentation
)t
GROUP BY age_group, segment_order
ORDER BY segment_order;