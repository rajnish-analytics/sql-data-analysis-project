# 🚀 SQL Data Analysis Project

> This project focuses on performing Exploratory Data Analysis (EDA), Advanced Analytical SQL, Business Problem Solving, and Reporting Analysis using SQL Server.

---

# 📌 Project Overview

The project simulates a real-world analytics environment where raw transactional data is transformed into actionable business insights through layered architecture, dimensional modeling, and analytical SQL.

---

# 🏗️ Data Architecture

The project follows below architecture:

```text
Initial Data → Raw Layer → Gold Layer → Analytics & Reporting
```

### 🔹 Layer Breakdown

| Layer        | Description                                    |
| ------------ | ---------------------------------------------- |
| 🥈 Raw       | Raw ingestion of source CSV files              |
| 🥇 Gold      | Business-ready fact and dimension tables       |
| 📊 Analytics | Exploratory and advanced analytical SQL        |
| 📈 Reporting | Customer and product reporting queries         |

---

# 🛠️ Tech Stack

| Technology           | Purpose                          |
| -------------------- | -------------------------------- |
| SQL Server           | Database engine                  |
| T-SQL                | Data transformation & analytics  |
| Window Functions     | Advanced analytical calculations |
| CTEs                 | Query modularization             |
| Dimensional Modeling | Warehouse design                 |
| Git & GitHub         | Version control                  |

---

# 📂 Repository Structure

```text
sql-data-analysis-project/
│
├── datasets/
│   ├── customers.csv
│   ├── products.csv
│   └── sales.csv
│
├── scripts/
│   │
│   ├── 00a_raw_ingestion.sql
│   ├── 00b_gold_transform.sql
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
└── README.md
```

---

# 🧱 Data Model

The warehouse follows a **Dimensional Modeling** approach.

## 📌 Fact Table

### `gold.fact_sales_info`

Contains transactional sales-level data.

---

## 📌 Dimension Tables

### `gold.dim_customer_info`

Stores customer demographic and profile information.

### `gold.dim_product_info`

Stores product hierarchy, category, pricing, and product details.

---

# 🔍 Exploratory Data Analysis (EDA)

The EDA section focuses on understanding the overall structure, quality, and business characteristics of the dataset.

### 📌 Analysis Areas

* Database exploration
* Dimension analysis
* Date and time exploration
* Measure exploration
* Magnitude analysis
* Ranking analysis

### 📈 Key Insights

* Customer distribution across countries
* Product category analysis
* Revenue distribution
* Top and bottom performers
* Order and sales behavior

---

# 📊 Advanced Analytical SQL

The project includes advanced business-oriented SQL analysis.

---

## 📈 Changes Over Time Analysis

* Sales trends
* Customer growth
* Seasonal patterns
* Order trends

---

## 📈 Cumulative Analysis

* Running totals
* Running averages
* Year-to-Date (YTD) analysis
* Growth benchmarking

---

## 📈 Performance Analysis

* Product performance benchmarking
* Year-over-Year (YoY) analysis
* Growth vs decline tracking

---

## 📈 Part-to-Whole Analysis

* Revenue contribution analysis
* Percentage distribution by category and country

---

## 📈 Data Segmentation

* Customer segmentation
* Product pricing segmentation
* Age-based segmentation
* Loyalty-based grouping

---

## 📈 Business Problem Solving

* Peak-performing years
* Highest revenue-generating categories
* Unsold product categories
* Monthly order trend analysis
* Business-focused analytical scenarios

---

# 🧠 SQL Concepts Demonstrated

This project demonstrates extensive usage of:

* Window Functions
* Aggregate Functions
* CTEs (Common Table Expressions)
* Subqueries
* Correlated Subqueries
* CASE Expressions
* Analytical Functions
* Ranking Functions
* Date Functions
* Joins
* Business-Oriented SQL Logic

---

# 📌 Key Business Insights Generated

✔️ Identified top-performing product categories
✔️ Analyzed customer purchasing behavior
✔️ Detected seasonal sales patterns
✔️ Compared yearly and monthly business growth
✔️ Segmented customers based on demographics and loyalty
✔️ Measured category-wise revenue contribution
✔️ Discovered unsold product categories

---

# 🎯 Learning Outcomes

Through this project, the following concepts were strengthened:

* Advanced T-SQL
* Business Analytics
* Analytical Problem Solving
* Query Structuring
* Reporting-Oriented SQL Development
* Dimensional Modeling

---

# 👨‍💻 Author

## Rajnish

Chemical Engineering graduate transitioning into Data & Analytics with strong interest in:

* 📊 Data Analytics
* 🏗️ Data Warehousing
* 📈 Business Intelligence
* 🧠 Analytical Problem Solving
* 🛢️ SQL Engineering

---
