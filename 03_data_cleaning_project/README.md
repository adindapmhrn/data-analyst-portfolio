# 🧹 Data Cleaning Project – Cafe Sales (SQL)

## 📊 Project Overview
This project focuses on cleaning a deliberately “dirty” cafe sales dataset to simulate common issues found in real-world data. Using SQL, I standardized values, handled missing and invalid entries, removed duplicates, and ensured data consistency so the dataset is ready for downstream analysis and reporting.

The main goal of this project is to demonstrate practical SQL data-cleaning techniques that are commonly required before any meaningful analysis can be performed.

---

## 📂 Dataset Information
- **Dataset Name:** Cafe Sales – Dirty Data for Cleaning Training  
- **Number of Rows:** 10,000  
- **Number of Columns:** 8  

The dataset contains transactional sales data for a cafe, including menu items and pricing. The reference pricing below was used during validation and cleaning:

| Item       | Price ($) |
|------------|----------:|
| Coffee     | 2.0 |
| Tea        | 1.5 |
| Sandwich   | 4.0 |
| Salad      | 5.0 |
| Cake       | 3.0 |
| Cookie     | 1.0 |
| Smoothie   | 4.0 |
| Juice      | 3.0 |

---

## 🧰 Tools Used
- **SQL**
  - Data cleaning
  - Data validation
  - Exploratory checks

---

## 📎 Files Included
- **`dirty_cafe_sales_rawdata.xlsx`**  
  Raw dataset containing missing values, duplicates, inconsistent formats, and invalid entries.

- **`dirty_cafe_sales_queries.sql`**  
  SQL scripts used for data cleaning, transformation, and validation.

---

## 🔍 Data Cleaning Steps
The following steps were performed using SQL:
- Standardized text values for consistency  
- Ensured correct data types for numeric and date columns  
- Trimmed unnecessary whitespace from string fields  
- Replaced invalid values such as `ERROR` and `NULL` with `UNKNOWN` 
- Identified and removed duplicate records  
- Handled missing values in key columns:
  - Item  
  - Price  
  - Total Spent  
- Validated pricing accuracy using known menu price references  

---

## ✅ Outcome
After cleaning, the dataset is consistent, reliable, and ready for analysis or visualization. This project demonstrates a realistic SQL data-cleaning workflow that mirrors common data quality challenges in real business environments.
