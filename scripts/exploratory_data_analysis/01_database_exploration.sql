/*
==================================================================================================================
1. Database Exploration: (Understanding the structure of the database and its tables)
==================================================================================================================
Purpose:
    • Explore database schemas, tables, and columns
    • Understand the structure of the analytical dataset
    • Inspect metadata of the gold layer tables
==================================================================================================================
*/

-- Explore all objects in the database DataWarehouseAnalysis
SELECT * FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_TYPE;

-- Explore all columns across the gold Schema
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold';

-- Explore columns of the table dim_customer_info
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold' AND TABLE_NAME = 'dim_customer_info';

-- Explore columns of the table dim_product_info
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold' AND TABLE_NAME = 'dim_product_info';

-- Explore columns of the table fact_sales_info
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold' AND TABLE_NAME = 'fact_sales_info';