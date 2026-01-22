# World Layoffs Data Cleaning — SQL Portfolio Project

## Overview
This project demonstrates a structured SQL-based data cleaning workflow applied to a global layoffs dataset. The objective is to transform raw, inconsistent records into a clean, standardized, and analysis-ready table suitable for business intelligence, reporting, and trend analysis.

All transformations were performed using MySQL, following industry-standard data engineering practices to ensure data integrity, reproducibility, and analytical reliability.

---

## Dataset
- **Source Table:** `world_layoffs.layoffs`
- **Geographic Scope:** Global
- **Data Type:** Company layoff events
- **Key Columns:**
  - `company`
  - `location`
  - `industry`
  - `total_laid_off`
  - `percentage_laid_off`
  - `date`
  - `stage`
  - `country`
  - `funds_raised_millions`

---

## Tools & Technologies
- **Database:** MySQL
- **SQL Concepts Used:**
  - Window functions (`ROW_NUMBER`)
  - Data staging tables
  - Deduplication logic
  - String standardization
  - Date conversion and formatting
  - Self-joins for data enrichment
  - Null value handling

---

## Data Cleaning Process

### 1. Data Staging
To protect the raw dataset, a staging table was created before applying any transformations.

**Steps:**
- Duplicated the original table schema.
- Inserted all source records into a staging table.
- Performed all cleaning operations on staging tables only.

**Result:**  
The original dataset remained intact, enabling a safe and repeatable workflow.

---

### 2. Duplicate Detection and Removal
Duplicate records were identified using a composite key across all descriptive columns.

**Approach:**
- Applied `ROW_NUMBER()` with `PARTITION BY` on company, location, industry, layoff metrics, date, stage, country, and funds raised.
- Retained the first occurrence of each duplicate group.
- Removed records where `row_num > 1`.

**Result:**  
Exact duplicate entries were eliminated, ensuring one authoritative record per layoff event.

---

### 3. Data Standardization

#### Company Names
- Removed leading and trailing whitespace using `TRIM()`.

#### Industry Values
- Consolidated inconsistent industry labels (e.g., Crypto-related values) into a single standardized category: `Crypto`.

#### Country Names
- Removed trailing punctuation to ensure consistency across country values.

#### Date Formatting
- Converted string-based dates (`MM/DD/YYYY`) into native `DATE` format.
- Updated the column data type to support time-series analysis.

**Result:**  
Improved consistency, reliable grouping, and accurate date-based analysis.

---

### 4. Null Value Management

#### Industry Backfilling
- Identified rows with missing industry values.
- Used self-joins on company and location to infer industry from valid records.
- Updated missing values only when reliable matches were found.

#### Record Removal
- Deleted rows where both `total_laid_off` and `percentage_laid_off` were NULL, as these records provided no analytical value.

**Result:**  
Enhanced data completeness and removal of non-informative records.

---

### 5. Final Cleanup
- Removed temporary helper columns used during cleaning.
- Validated the final table structure and contents.

**Final Clean Table:** `layoffs_staging_2`

---

## Final Outcome
The cleaned dataset is:
- Free of duplicate records
- Standardized across text and date fields
- Optimized for analytical use
- Ready for visualization, reporting, and advanced analysis

---

## Use Cases
- Global layoff trend analysis
- Industry-wise workforce impact
- Country-level comparisons
- Economic cycle analysis
- BI dashboard development (Power BI / Tableau)

---

## Author
**Minhajul Hoque**  
SQL • Data Analytics • Data Cleaning Portfolio Project

---
