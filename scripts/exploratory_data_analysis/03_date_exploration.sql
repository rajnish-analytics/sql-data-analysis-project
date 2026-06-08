/*
=================================================================================================================
3. Date Exploration: (Understanding the scope and timespan of the data)
=================================================================================================================
Purpose:
    • Determine the historical range of the dataset
    • Identify the first and last order dates
    • Analyze customer age distribution
    • Understand the timeline of business activities
=================================================================================================================
*/

-- Explore dates of the first and the last order
SELECT
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS range_years,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS range_months,
DATEDIFF(QUARTER, MIN(order_date), MAX(order_date)) AS range_quarters
FROM gold.fact_sales_info;

-- Explore the oldest and youngest customer
SELECT
MIN(birthdate) AS oldest_birthdate,
DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS age,
MAX(birthdate) AS youngest_birthdate,
DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS age
FROM gold.dim_customer_info;
