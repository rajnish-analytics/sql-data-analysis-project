/*
=====================================================================================================================
Script: Create Report View for Customer Insights
=====================================================================================================================
Objective: This report consolidates key customer metrics and behaviors.

This script performs the following operations:
1. Gathers essential fields such as customer names, birthdates, and transaction details.
2. Aggregates data to compute total orders, products, quantity, and purchase amounts for each customer.
3. Calculates customer lifespan and last order date to understand engagement levels.
4. Segmentation:
    - Classifies customers into VIP, Regular, and New based on purchase history and lifespan.
    - Categorizes customers into age groups for demographic analysis.
5. Key Metrics:
    - Recency Analysis: Measures how recently customers have made purchases to identify active vs. dormant customers.
    - Average Order Value: Calculates the average revenue generated per order for each customer.
    - Average Monthly Spend: Evaluates the average monthly expenditure of customers to understand spending patterns.
6. This report provides a comprehensive view of customer behavior, including metrics, segmentation, and preferences.

Usage: This view can be used for customer analysis, targeted marketing campaigns, and understanding customer 
lifetime value.
=====================================================================================================================
*/

--->>> Create Report View: gold.report_customer_info
IF OBJECT_ID ('gold.report_customer_info', 'V') IS NOT NULL
    DROP VIEW gold.report_customer_info;
GO

CREATE VIEW gold.report_customer_info AS
    WITH customer_details AS
    (
    SELECT
        s.order_id,
        s.product_key,
        s.order_date,
        s.sales_amount,
        s.quantity,
        c.customer_key,
        c.customer_number,
        c.first_name,
        c.last_name,
        c.birthdate
    FROM gold.fact_sales_info s
    LEFT JOIN gold.dim_customer_info c
    ON s.customer_key = c.customer_key
    ),

    customer_details_aggregation AS
    (
    SELECT
        customer_key,
        customer_number,
        first_name + ' ' + last_name AS customer_name,
        DATEDIFF(YEAR, birthdate, GETDATE()) AS age,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT product_key) AS total_products,   -- Total distinct products
        SUM(quantity) AS total_quantity,                 -- Total quantity of products purchased
        SUM(sales_amount) AS total_purchases,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_months
    FROM customer_details
    GROUP BY customer_key, customer_number, first_name, last_name, birthdate
    )

    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        CASE WHEN age < 30 THEN '30 and Below'
             WHEN age <= 40 THEN '31-40'
             WHEN age <= 50 THEN '41-50'
             WHEN age <= 60 THEN '51-60'
             WHEN age > 60 THEN 'Above 60' END AS age_group,
        CASE WHEN total_purchases > 5000 AND lifespan_months >= '12' THEN 'VIP'
             WHEN total_purchases <= 5000 AND lifespan_months >= '12' THEN 'REGULAR'
             ELSE 'NEW' END AS customer_segment,
        total_orders,
        total_products,
        total_quantity,
        total_purchases,
        lifespan_months,
        last_order,
        DATEDIFF(MONTH, last_order, GETDATE()) AS recency_in_months,   -- Months since last order (Customer Inactivity)
        total_purchases / NULLIF(total_orders, 0) AS average_order_value,
        CASE WHEN lifespan_months = 0 THEN total_purchases
             ELSE total_purchases / lifespan_months END AS average_monthly_spend
    FROM customer_details_aggregation;
GO