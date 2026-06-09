/*
==============================================================================================================================
12. Business Problem Solving Analysis: (Solving real-world business questions using analytical SQL techniques)
==============================================================================================================================
Purpose:
    • Solve business-oriented analytical problems using SQL
    • Identify high-performing and low-performing business areas
    • Analyze sales, orders, products, and category performance across time
    • Discover peak-performing years, months, and product categories
    • Detect unsold product categories and sales distribution patterns
    • Extract actionable business insights from historical sales and customer data
==============================================================================================================================
*/

-- Product categories that have not been sold
SELECT DISTINCT
category
FROM gold.dim_product_info dp
WHERE NOT EXISTS (
    SELECT 1 
    FROM (
        SELECT
        p.category,
        p.product_key
        FROM gold.fact_sales_info s
        LEFT JOIN gold.dim_product_info p
        ON s.product_key = p.product_key
    )t
    WHERE t.category = dp.category
);


-- Year that received the highest number of orders
SELECT
YEAR(order_date) order_year,
COUNT(DISTINCT order_id) total_orders
FROM gold.fact_sales_info
GROUP BY YEAR(order_date)
HAVING COUNT(DISTINCT order_id) = 
    (
    SELECT
    MAX(orders_by_year)
    FROM (
        SELECT
        COUNT(DISTINCT order_id) orders_by_year
        FROM gold.fact_sales_info
        GROUP BY YEAR(order_date)
    )t
);


-- Year that generated the highest overall revenue
WITH sales_by_year AS
(
    SELECT
    YEAR(order_date) order_year,
    SUM(sales_amount) total_sales
    FROM gold.fact_sales_info
    GROUP BY YEAR(order_date)
)

SELECT 
order_year,
total_sales
FROM sales_by_year
WHERE total_sales = (SELECT MAX(total_sales) FROM sales_by_year);


-- Product category with the highest quantity sold in the year that received the maximum customer orders
WITH category_quantity AS
(
    SELECT
    YEAR(order_date) sales_year,
    category,
    COUNT(DISTINCT order_id) total_orders,   -- Total unique orders for each category within the year
    SUM(quantity) total_quantity,            -- Total quantity sold for each category within the year
    SUM(COUNT(DISTINCT order_id)) OVER(PARTITION BY YEAR(order_date)) yearly_total_orders   -- Total orders received in the year
    FROM gold.fact_sales_info s
    LEFT JOIN gold.dim_product_info p
    ON s.product_key = p.product_key
    WHERE order_date IS NOT NULL
    GROUP BY category, YEAR(order_date)
),
    -- Extract categories belonging to the year with maximum customer orders
peak_order_year_categories AS
(
    SELECT
    sales_year,
    category,
    total_quantity
    FROM category_quantity
    WHERE yearly_total_orders = (SELECT MAX(yearly_total_orders) FROM category_quantity)
)
    -- Return the category with highest quantity sold within the peak order year
SELECT
sales_year,
category,
total_quantity
FROM peak_order_year_categories
WHERE total_quantity = (SELECT MAX(total_quantity) FROM peak_order_year_categories);


-- Product category with the highest revenue generated in the year with the highest overall revenue
WITH category_sales AS
(
    SELECT
    YEAR(order_date) sales_year,
    category,
    SUM(sales_amount) total_sales,   -- Total sales by each category within the year
    SUM(SUM(sales_amount)) OVER(PARTITION BY YEAR(order_date)) yearly_total_sales   -- Total sales generated in the year
    FROM gold.fact_sales_info s
    LEFT JOIN gold.dim_product_info p
    ON s.product_key = p.product_key
    WHERE order_date IS NOT NULL
    GROUP BY category, YEAR(order_date)
),
    -- Extract categories belonging to the year with highest revenue
peak_revenue_year_categories AS
(
    SELECT
    sales_year,
    category,
    total_sales
    FROM category_sales
    WHERE yearly_total_sales = (SELECT MAX(yearly_total_sales) FROM category_sales)
)
    -- Return the category with highest revenue generated within the peak revenue year
SELECT
sales_year,
category,
total_sales
FROM peak_revenue_year_categories
WHERE total_sales = (SELECT MAX(total_sales) FROM peak_revenue_year_categories);


-- Monthly orders within the year that received the highest number of customer orders
WITH monthly_orders AS
(
    SELECT
    DATETRUNC(MONTH, order_date) order_month,
    COUNT(DISTINCT order_id) total_orders_by_month,
    SUM(COUNT(DISTINCT order_id)) OVER(PARTITION BY YEAR(order_date)) total_orders_by_year
    FROM gold.fact_sales_info
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date), YEAR(order_date)
)

SELECT
order_month,
total_orders_by_month
FROM monthly_orders
WHERE total_orders_by_year = (SELECT MAX(total_orders_by_year) FROM monthly_orders)
ORDER BY order_month;


-- Total monthly revenue within the year that generated the highest overall revenue
WITH monthly_sales AS
(
    SELECT
    DATETRUNC(MONTH, order_date) sales_month,
    SUM(sales_amount) total_sales_by_month,
    SUM(SUM(sales_amount)) OVER(PARTITION BY YEAR(order_date)) total_sales_by_year
    FROM gold.fact_sales_info
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date), YEAR(order_date)
)

SELECT
sales_month,
total_sales_by_month
FROM monthly_sales
WHERE total_sales_by_year = (SELECT MAX(total_sales_by_year) FROM monthly_sales)
ORDER BY sales_month;
