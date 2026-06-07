/*
=============================================================================================================
Script: Create Tables and Load Data into gold Schema
=============================================================================================================
Objective: This script creates the necessary tables in the gold schema of the DataWarehouseAnalysis database 
and loads data into them from the raw schema.
    
The script performs the following tasks:
1. Checks if each table already exists in the 'gold' schema and drops it if it does.
2. Creates new tables with the specified schema for customer info, product info, and sales info.
3. Inserts data into the gold schema tables by selecting from the corresponding tables in the raw schema.
4. This script is intended to be run after the initial setup of the DataWarehouseAnalysis database and 
   after loading data into the raw schema tables.
=============================================================================================================
*/

-- ==============================================================
-- Drop Table If Exists And Creating Tables In gold Schema...
-- ==============================================================

IF OBJECT_ID ('gold.dim_customer_info', 'U') IS NOT NULL
    DROP TABLE gold.dim_customer_info;
GO

CREATE TABLE gold.dim_customer_info (
    customer_key INT,
    customer_id INT,
    customer_number NVARCHAR(50),
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    country NVARCHAR(50),
    gender NVARCHAR(50),
    marital_status NVARCHAR(50),
    birthdate DATE,
    create_date DATE
);
GO

IF OBJECT_ID ('gold.dim_product_info', 'U') IS NOT NULL
    DROP TABLE gold.dim_product_info;
GO

CREATE TABLE gold.dim_product_info (
    product_key INT,
    product_id INT,
    product_number NVARCHAR(50),
    product_name NVARCHAR(50),
    category_id NVARCHAR(50),
    category NVARCHAR(50),
    subcategory NVARCHAR(50),
    cost INT,
    maintenance NVARCHAR(50),
    product_line NVARCHAR(50),
    start_date DATE 
);
GO

IF OBJECT_ID ('gold.fact_sales_info', 'U') IS NOT NULL
    DROP TABLE gold.fact_sales_info;
GO

CREATE TABLE gold.fact_sales_info (
    order_id NVARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity INT,
    unit_price INT
);
GO

-- ==============================================================
-- Inserting Data Into gold Schema...
-- ==============================================================

-- Inserting Data Into Table: gold.dim_customer_info
INSERT INTO gold.dim_customer_info (
    customer_key,
    customer_id,
    customer_number,
    first_name,
    last_name,
    country,
    gender,
    marital_status,
    birthdate,
    create_date
)
SELECT
    customer_key,
    customer_id,
    customer_number,
    first_name,
    last_name,
    country,
    gender,
    marital_status,
    CAST(NULLIF(birthdate, 'NULL') AS DATE) AS birthdate,
    create_date
FROM raw.dim_customer_info;
GO

-- Inserting Data Into Table: gold.dim_product_info
INSERT INTO gold.dim_product_info (
    product_key,
    product_id,
    product_number,
    product_name,
    category_id,
    category,
    subcategory,
    cost,
    maintenance,
    product_line,
    start_date
)
SELECT
    product_key,
    product_id,
    product_number,
    product_name,
    category_id,
    category,
    subcategory,
    cost,
    maintenance,
    product_line,
    start_date
FROM raw.dim_product_info;
GO

-- Inserting Data Into Table: gold.fact_sales_info
INSERT INTO gold.fact_sales_info (
    order_id,
    product_key,
    customer_key,
    order_date,
    shipping_date,
    due_date,
    sales_amount,
    quantity,
    unit_price
)
SELECT
    order_id,
    product_key,
    customer_key,
    CASE WHEN order_date = 'NULL' THEN NULL ELSE CAST(order_date AS DATE) END AS order_date,
    shipping_date,
    due_date,
    sales_amount,
    quantity,
    unit_price
FROM raw.fact_sales_info;
GO
