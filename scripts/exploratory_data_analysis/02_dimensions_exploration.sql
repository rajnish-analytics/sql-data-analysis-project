/*
=======================================================================================================================
2. Dimensions Exploration: (Recognizing how data can be grouped or segmented for analysis)
=======================================================================================================================
Purpose:
    • Explore customer and product dimensions
    • Identify unique categories and business segments
    • Understand how the data can be grouped for analysis
=======================================================================================================================
*/

-- Explore all countries where our customers come from
SELECT DISTINCT
country
FROM gold.dim_customer_info;

-- Explore gender and marital status of the customers
SELECT
gender,
marital_status
FROM gold.dim_customer_info
GROUP BY gender, marital_status
ORDER BY 1, 2;

-- Explore all categories "The Major Divisions" of the products
SELECT DISTINCT
category
FROM gold.dim_product_info;

-- Explore categories, subcategories, and product name of the products
SELECT DISTINCT
category,
subcategory,
product_name
FROM gold.dim_product_info
ORDER BY 1, 2, 3;