/*
=======================================================================================================
Script: 1) Create DataWarehouseAnalysis Database and raw/gold Schemas
        2) Create Tables and Load Data into raw Schema
=======================================================================================================
Objective: This script initializes the DataWarehouseAnalysis database by creating it from scratch and 
setting up the raw and gold schemas for data analysis.
 
Warning: This script is destructive as it drops the existing DataWarehouseAnalysis database if it 
exists. This will result in permanent data loss. Use with caution and ensure you have proper backups 
before running this script.

This script performs the following tasks:
1. Checks for the existence of the DataWarehouseAnalysis database and drops it if found.
2. Creates a new DataWarehouseAnalysis database and switches to it.
3. Creates two schemas within the DataWarehouseAnalysis database: raw and gold.
4. Creates tables in the raw schema for customer info, product info, and sales info.
5. Loads data into the raw schema tables from CSV files using BULK INSERT.
=======================================================================================================
*/

-- Switch to the master database
USE master;
GO

-- ==============================================================
-- Drop Database If Exists And Creating Database & Schemas...
-- ==============================================================

-- Drop the database 'DataWarehouseAnalysis' if it already exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalysis')
BEGIN
    ALTER DATABASE DataWarehouseAnalysis SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalysis;
END;
GO

-- Create the new database 'DataWarehouseAnalysis'
CREATE DATABASE DataWarehouseAnalysis;
GO

-- Switch to the new database
USE DataWarehouseAnalysis;
GO

-- Create schemas raw and gold
CREATE SCHEMA raw;
GO

CREATE SCHEMA gold;
GO

-- ==============================================================
-- Creating Tables In raw Schema (Fresh Database Container)...
-- ==============================================================

CREATE TABLE raw.dim_customer_info (
    customer_key INT,
    customer_id INT,
    customer_number NVARCHAR(50),
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    country NVARCHAR(50),
    gender NVARCHAR(50),
    marital_status NVARCHAR(50),
    birthdate NVARCHAR(50),
    create_date DATE
);
GO

CREATE TABLE raw.dim_product_info (
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

CREATE TABLE raw.fact_sales_info (
    order_id NVARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date NVARCHAR(50),
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity INT,
    unit_price INT
);
GO

-- ==============================================================
-- Loading Data Into raw Schema...
-- ==============================================================

-- Bulk Inserting Data Into Table: raw.dim_customer_info
BULK INSERT raw.dim_customer_info
FROM '/var/opt/mssql/shared/DataAnalysis/datasets/dim_customer_info.csv'

WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- Bulk Inserting Data Into Table: raw.dim_product_info
BULK INSERT raw.dim_product_info
FROM '/var/opt/mssql/shared/DataAnalysis/datasets/dim_product_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- Bulk Inserting Data Into Table: raw.fact_sales_info
BULK INSERT raw.fact_sales_info
FROM '/var/opt/mssql/shared/DataAnalysis/datasets/fact_sales_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
