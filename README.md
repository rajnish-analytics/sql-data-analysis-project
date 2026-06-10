# 🚀 DataWarehouseAnalysis

> End-to-end SQL Data Warehousing, Exploratory Data Analysis (EDA), Advanced Analytics, and Reporting project built using SQL Server & T-SQL.

---

# 📌 Project Overview

**DataWarehouseAnalysis** is a complete SQL-based analytics project focused on transforming raw transactional data into meaningful business insights using structured data modeling, analytical SQL, and reporting techniques.

The project simulates a real-world analytics workflow where raw CSV datasets are ingested, transformed into business-ready tables, analyzed using advanced SQL, and finally converted into reusable reporting views for decision-making.

This project combines:

* 🏗️ Data Warehousing
* 📊 Exploratory Data Analysis (EDA)
* 📈 Advanced Analytical SQL
* 📑 Business Problem Solving
* 📋 Reporting & KPI Analysis

---

# 🏗️ Architecture Overview

The project follows a layered analytical architecture:

```text
CSV Datasets → Raw Layer → Gold Layer → Analytics → Reporting
```

---

# 🔹 Layer Breakdown

| Layer              | Description                                    |
| ------------------ | ---------------------------------------------- |
| 🥈 Raw Layer       | Raw ingestion of source CSV datasets           |
| 🥇 Gold Layer      | Cleaned and business-ready analytical tables   |
| 📊 Analytics Layer | Exploratory and advanced analytical SQL        |
| 📈 Reporting Layer | Reusable reporting views for business analysis |

---

# 🛠️ Tech Stack

| Technology                          | Purpose                          |
| ----------------------------------- | -------------------------------- |
| SQL Server                          | Database engine                  |
| T-SQL                               | Data transformation & analytics  |
| SQL Server Management Studio (SSMS) | Query development                |
| Window Functions                    | Advanced analytical calculations |
| CTEs                                | Modular query structuring        |
| Dimensional Modeling                | Analytical schema design         |
| Git & GitHub                        | Version control                  |

---

# 📂 Repository Structure

```text
DataWarehouseAnalysis/
│
├── datasets/
│   ├── customers.csv
│   ├── products.csv
│   └── sales.csv
│
├── scripts/
│   │
│   ├── 00_init_raw_ingest.sql
│   ├── 00_init_gold_transform.sql
│   │
│   ├── eda/
│   │   ├── 01_database_exploration.sql
│   │   ├── 02_dimension_exploration.sql
│   │   ├── 03_date_exploration.sql
│   │   ├── 04_measure_exploration.sql
│   │   ├── 05_magnitude_analysis.sql
│   │   └── 06_ranking_analysis.sql
│   │
│   ├── advanced/
│   │   ├── 07_change_over_time_analysis.sql
│   │   ├── 08_cumulative_analysis.sql
│   │   ├── 09_performance_analysis.sql
│   │   ├── 10_part_to_whole_analysis.sql
│   │   ├── 11_data_segmentation.sql
│   │   └── 12_business_problem_solving_analysis.sql
│   │
│   └── reporting/
│       ├── customer_report.sql
│       └── product_report.sql
│
├── LICENSE
├── .gitignore
└── README.md
```

---

# 🧱 Data Model

The project follows a dimensional modeling approach using fact and dimension tables for analytical reporting.

---

## 📌 Fact Table

### `gold.fact_sales_info`

Contains transactional sales-level data including:

* Orders
* Revenue
* Quantity sold
* Customer references
* Product references
* Order dates

---

## 📌 Dimension Tables

### `gold.dim_customer_info`

Stores customer-related information such as:

* Customer identifiers
* Demographics
* Country
* Gender
* Birthdate

### `gold.dim_product_info`

Stores product-related information such as:

* Product hierarchy
* Categories & subcategories
* Product pricing
* Product cost
* Product lifecycle information

---

# 🔍 Exploratory Data Analysis (EDA)

The EDA layer focuses on understanding the structure, quality, distribution, and business characteristics of the dataset.

---

## 📌 EDA Areas Covered

* Database Exploration
* Dimension Exploration
* Date Exploration
* Measure Exploration
* Magnitude Analysis
* Ranking Analysis

---

## 📈 Insights Generated

* Customer distribution across countries
* Product category analysis
* Revenue and order distribution
* Top and bottom performers
* Sales behavior trends
* Business distribution patterns

---

# 📊 Advanced Analytical SQL

The project includes advanced analytical SQL focused on solving business-oriented analytical problems.

---

## 📈 Changes Over Time Analysis

* Monthly and yearly sales trends
* Seasonal business patterns
* Customer growth tracking
* Order trend analysis

---

## 📈 Cumulative Analysis

* Running totals
* Running averages
* Year-to-Date (YTD) calculations
* Progressive growth analysis

---

## 📈 Performance Analysis

* Product benchmarking
* Year-over-Year (YoY) analysis
* Growth vs decline tracking
* Performance comparison against averages

---

## 📈 Part-to-Whole Analysis

* Revenue contribution analysis
* Country-wise contribution analysis
* Category-wise proportional impact

---

## 📈 Data Segmentation

* Customer segmentation
* Product pricing segmentation
* Age-group analysis
* Loyalty-based grouping
* Revenue distribution across segments

---

## 📈 Business Problem Solving

Business-focused analytical scenarios including:

* Peak-performing years
* Highest revenue-generating categories
* Unsold product categories
* Monthly revenue trend analysis
* Peak order period analysis
* Category performance within top-performing years

---

# 📑 Reporting Layer

The reporting section contains reusable SQL reporting views designed for business analysis and KPI tracking.

---

## 📌 Customer Report

### `gold.report_customer_info`

Customer-focused reporting view containing:

* Customer segmentation
* Age-group analysis
* Revenue contribution
* Customer lifespan
* Recency analysis
* Average order value
* Average monthly spend
* Purchase behavior metrics

---

## 📌 Product Report

### `gold.report_product_info`

Product-focused reporting view containing:

* Product segmentation
* Cost-group analysis
* Revenue contribution
* Product lifecycle metrics
* Recency analysis
* Average selling price
* Average order revenue
* Average monthly revenue
* Product performance KPIs

---

# 🧠 SQL Concepts Demonstrated

This project demonstrates practical usage of:

* Window Functions
* Aggregate Functions
* Common Table Expressions (CTEs)
* Subqueries
* Correlated Subqueries
* CASE Expressions
* Ranking Functions
* Date Functions
* Joins
* Analytical SQL Patterns
* Reporting Logic
* Business-Oriented SQL Design

---

# 📌 Key Business Insights Generated

✔️ Identified top-performing product categories
✔️ Analyzed customer purchasing behavior
✔️ Detected seasonal sales patterns
✔️ Compared yearly and monthly business growth
✔️ Measured category-wise revenue contribution
✔️ Segmented customers based on demographics and loyalty
✔️ Discovered unsold product categories
✔️ Analyzed business performance across different periods

---

# 🎯 Learning Outcomes

Through this project, the following concepts were strengthened:

* Advanced T-SQL
* Data Warehousing Fundamentals
* Business Analytics
* Analytical Problem Solving
* Query Structuring
* Reporting-Oriented SQL Development
* Dimensional Modeling
* Real-world SQL Analysis Techniques

---

# 🚀 Future Improvements

Potential future enhancements include:

* Power BI dashboard integration
* Query optimization
* Indexing strategies
* Stored procedures & automation
* KPI dashboard development

---

# 👨‍💻 Author

### Rajnish

Chemical Engineering graduate from **NIT Jalandhar** transitioning into **Data Analytics & Data Engineering** with strong interest in:

* 📊 Data Analytics
* ⚙️ Data Engineering
* 📈 Business Intelligence
* 🧠 Analytical Problem Solving
* 🛢️ Advanced SQL

<div align="center">

### ◈ ◈ ◈

</div>
