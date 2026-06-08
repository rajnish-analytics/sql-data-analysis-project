/*
====================================================================================================================
4. Measures Exploration: (Highest level of aggregation | Lowest level of details)
====================================================================================================================
Purpose:
    • Calculate key business metrics and KPIs (e.g., totals, averages)
    • Analyze overall sales and order performance
    • Generate summary-level business insights
====================================================================================================================
*/

-- Total number of customers
SELECT
'Total customers' AS dimension,
CAST(COUNT(*) AS VARCHAR) AS measure   -- COUNT(DISTINCT customer_key) can be used, but there is no duplicates in dim tables
FROM gold.dim_customer_info

UNION ALL

-- Average age of customers 
SELECT
'Average age of customers',
CAST(AVG(DATEDIFF(YEAR, birthdate, GETDATE())) AS VARCHAR)
FROM gold.dim_customer_info

UNION ALL

-- Total number of products
SELECT
'Total products',
CAST(COUNT(*) AS VARCHAR)   -- COUNT(DISTINCT product_key) can be used, but there is no duplicates in dim tables
FROM gold.dim_product_info

UNION ALL

-- Total number of categories of the products
SELECT
'Total categories of products',
CAST(COUNT(DISTINCT category) AS VARCHAR)
FROM gold.dim_product_info

UNION ALL

-- Total number of orders
SELECT
'Total orders',
CAST(COUNT(DISTINCT order_id) AS VARCHAR)
FROM gold.fact_sales_info

UNION ALL

-- Total number of customers who placed orders
SELECT
'Total customers who placed orders',
CAST(COUNT(DISTINCT customer_key) AS VARCHAR)
FROM gold.fact_sales_info

UNION ALL

-- Total number of products that have been sold
SELECT
'Total products that have been sold',
CAST(COUNT(DISTINCT product_key) AS VARCHAR)
FROM gold.fact_sales_info

UNION ALL

-- Total number of items sold
SELECT
'Total quantity sold',
CAST(SUM(quantity) AS VARCHAR)
FROM gold.fact_sales_info

UNION ALL

-- Average selling price of the products
SELECT
'Average selling price of products',
'Rs. ' + CAST(AVG(unit_price) AS VARCHAR)
FROM gold.fact_sales_info

UNION ALL

-- Average order price
SELECT
'Average order price',
'Rs. ' + CAST(AVG(order_price) AS VARCHAR)
FROM (
    SELECT
    SUM(sales_amount) AS order_price
    FROM gold.fact_sales_info
    GROUP BY order_id
)t

UNION ALL

-- Highest order price
SELECT
'Highest order price',
'Rs. ' + CAST(MAX(order_price) AS VARCHAR)
FROM (
    SELECT
    SUM(sales_amount) AS order_price
    FROM gold.fact_sales_info
    GROUP BY order_id
)t

UNION ALL

-- Lowest order price
SELECT
'Lowest order price',
'Rs. ' + CAST(MIN(order_price) AS VARCHAR)
FROM (
    SELECT
    SUM(sales_amount) AS order_price
    FROM gold.fact_sales_info
    GROUP BY order_id
)t

UNION ALL

-- Total sales generated
SELECT
'Total revenue generated',
CAST(SUM(sales_amount) AS VARCHAR) + ' INR'
FROM gold.fact_sales_info

UNION ALL

-- Average delivery period to fully deliver an entire order (If we have multiple rows for the same order_id)
SELECT
'Average delivery period per order',
CAST(CAST(AVG(max_order_delivery*1.0) AS DECIMAL(10, 1)) AS VARCHAR) + ' days'   -- Average time taken to fully deliver an entire order
FROM (
    SELECT
    order_id,
    DATEDIFF(DAY, order_date, MAX(shipping_date)) AS max_order_delivery   -- Finds date for any order when last item was delivered
    FROM gold.fact_sales_info
    WHERE order_date IS NOT NULL
    GROUP BY order_id, order_date
)t;
