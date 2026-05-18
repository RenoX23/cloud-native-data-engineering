# SQL Window Functions

# Introduction

Window Functions are advanced SQL functions that perform calculations across a set of rows related to the current row without collapsing rows.

Unlike:
```sql
GROUP BY
```

Window functions:
- preserve original rows
- add analytical calculations alongside row-level data

They are heavily used in:
- Data Engineering
- Analytics Engineering
- Data Warehousing
- Financial analytics
- Business intelligence
- Reporting systems

Window functions are one of the most important advanced SQL topics.

---

# Why Window Functions Matter

Without window functions:
- complex subqueries become necessary
- analytical queries become inefficient
- ranking logic becomes difficult
- running calculations become messy

Window functions simplify:
- rankings
- cumulative sums
- moving averages
- lead/lag analysis
- partition-based analytics

---

# Basic Syntax

```sql
function_name() OVER (
    PARTITION BY column
    ORDER BY column
)
```

---

# Key Components

| Component | Purpose |
|---|---|
| OVER() | Defines window |
| PARTITION BY | Splits data into groups |
| ORDER BY | Defines row order |
| Window Frame | Defines calculation range |

---

# Sample Table

| emp_id | name | department | salary |
|---|---|---|---|
| 101 | John | Engineering | 90000 |
| 102 | Alice | HR | 70000 |
| 103 | Bob | Engineering | 85000 |
| 104 | David | HR | 75000 |
| 105 | Emma | Engineering | 95000 |

---

# GROUP BY vs Window Functions

---

# GROUP BY

```sql
SELECT department, AVG(salary)
FROM employees
GROUP BY department;
```

Result:

| department | avg_salary |
|---|---|
| Engineering | 90000 |
| HR | 72500 |

Rows collapse.

---

# Window Function

```sql
SELECT
    name,
    department,
    salary,
    AVG(salary) OVER (
        PARTITION BY department
    ) AS dept_avg
FROM employees;
```

Result:

| name | department | salary | dept_avg |
|---|---|---|---|
| John | Engineering | 90000 | 90000 |
| Bob | Engineering | 85000 | 90000 |
| Emma | Engineering | 95000 | 90000 |
| Alice | HR | 70000 | 72500 |
| David | HR | 75000 | 72500 |

Rows preserved.

This is the key difference.

---

# OVER() Clause

Defines the window for calculation.

---

# Example

```sql
AVG(salary) OVER ()
```

Calculates average across entire dataset.

---

# PARTITION BY

Divides rows into logical groups.

Similar to:
```sql
GROUP BY
```

but without collapsing rows.

---

# Example

```sql
AVG(salary) OVER (
    PARTITION BY department
)
```

Each department becomes separate analytical window.

---

# ORDER BY in Window Functions

Defines row sequence inside partitions.

Critical for:
- rankings
- running totals
- lead/lag operations

---

# Example

```sql
SUM(salary) OVER (
    ORDER BY salary
)
```

---

# Ranking Functions

Very important interview topic.

---

# ROW_NUMBER()

Assigns unique sequential number.

---

# Example

```sql
SELECT
    name,
    salary,
    ROW_NUMBER() OVER (
        ORDER BY salary DESC
    ) AS rank_num
FROM employees;
```

---

# Output

| name | salary | rank_num |
|---|---|---|
| Emma | 95000 | 1 |
| John | 90000 | 2 |
| Bob | 85000 | 3 |
| David | 75000 | 4 |
| Alice | 70000 | 5 |

---

# RANK()

Handles ties differently.

Tied rows receive same rank.

---

# Example

```sql
SELECT
    name,
    salary,
    RANK() OVER (
        ORDER BY salary DESC
    ) AS salary_rank
FROM employees;
```

---

# Example with Tie

| salary | rank |
|---|---|
| 95000 | 1 |
| 90000 | 2 |
| 90000 | 2 |
| 85000 | 4 |

Notice skipped rank:
```text
3 missing
```

---

# DENSE_RANK()

Similar to RANK but no gaps.

---

# Example

| salary | dense_rank |
|---|---|
| 95000 | 1 |
| 90000 | 2 |
| 90000 | 2 |
| 85000 | 3 |

No skipped numbers.

---

# ROW_NUMBER vs RANK vs DENSE_RANK

| Function | Duplicate Ranks | Gaps |
|---|---|---|
| ROW_NUMBER | No | No |
| RANK | Yes | Yes |
| DENSE_RANK | Yes | No |

---

# NTILE()

Divides rows into buckets.

---

# Example

```sql
SELECT
    name,
    salary,
    NTILE(4) OVER (
        ORDER BY salary DESC
    ) AS quartile
FROM employees;
```

Useful for:
- quartiles
- percentiles
- segmentation

---

# Aggregate Window Functions

Standard aggregates work as window functions.

---

# AVG()

```sql
SELECT
    name,
    salary,
    AVG(salary) OVER (
        PARTITION BY department
    ) AS dept_avg
FROM employees;
```

---

# SUM()

Running totals.

---

# Example

```sql
SELECT
    name,
    salary,
    SUM(salary) OVER (
        ORDER BY emp_id
    ) AS running_total
FROM employees;
```

---

# Output

| emp_id | salary | running_total |
|---|---|---|
| 101 | 90000 | 90000 |
| 102 | 70000 | 160000 |
| 103 | 85000 | 245000 |

---

# MIN() and MAX()

---

# Example

```sql
SELECT
    name,
    salary,
    MAX(salary) OVER (
        PARTITION BY department
    ) AS max_salary
FROM employees;
```

---

# LEAD()

Accesses next row value.

---

# Example

```sql
SELECT
    name,
    salary,
    LEAD(salary) OVER (
        ORDER BY salary
    ) AS next_salary
FROM employees;
```

---

# Use Cases

- trend analysis
- time-series comparisons
- future value comparison

---

# LAG()

Accesses previous row value.

---

# Example

```sql
SELECT
    name,
    salary,
    LAG(salary) OVER (
        ORDER BY salary
    ) AS previous_salary
FROM employees;
```

---

# Real-World Use Cases

| Use Case | Function |
|---|---|
| Compare previous sales | LAG |
| Compare future forecasts | LEAD |
| Detect trends | LEAD/LAG |
| Time-series analysis | LAG |

---

# FIRST_VALUE()

Returns first value in window.

---

# Example

```sql
SELECT
    name,
    salary,
    FIRST_VALUE(name) OVER (
        ORDER BY salary DESC
    ) AS top_earner
FROM employees;
```

---

# LAST_VALUE()

Returns last value in window.

---

# Example

```sql
SELECT
    name,
    salary,
    LAST_VALUE(name) OVER (
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS lowest_paid
FROM employees;
```

---

# Window Frames

Advanced but important topic.

Defines calculation boundaries.

---

# Common Frame Syntax

```sql
ROWS BETWEEN ...
```

---

# Types of Frames

| Frame | Meaning |
|---|---|
| UNBOUNDED PRECEDING | Start from first row |
| CURRENT ROW | Current row |
| UNBOUNDED FOLLOWING | Till last row |

---

# Example

Running total:

```sql
SUM(salary) OVER (
    ORDER BY emp_id
    ROWS BETWEEN UNBOUNDED PRECEDING
    AND CURRENT ROW
)
```

---

# Moving Average Example

```sql
SELECT
    emp_id,
    salary,
    AVG(salary) OVER (
        ORDER BY emp_id
        ROWS BETWEEN 2 PRECEDING
        AND CURRENT ROW
    ) AS moving_avg
FROM employees;
```

---

# Explanation

Calculates average using:
- current row
- previous 2 rows

Useful for:
- stock analysis
- metrics smoothing
- trend analysis

---

# Window Functions with PARTITION BY

Very common pattern.

---

# Example

```sql
SELECT
    department,
    name,
    salary,
    RANK() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS dept_rank
FROM employees;
```

---

# Output

Engineering ranking and HR ranking calculated separately.

---

# Real-World Data Engineering Use Cases

---

# 1. Top N Records Per Group

Example:
```text
Top 3 customers per region
```

Uses:
```sql
ROW_NUMBER()
```

---

# 2. Running Revenue

Example:
```text
Daily cumulative sales
```

Uses:
```sql
SUM()
```

---

# 3. Trend Detection

Example:
```text
Compare today's sales with yesterday
```

Uses:
```sql
LAG()
```

---

# 4. Percentile Analysis

Example:
```text
Top 10% customers
```

Uses:
```sql
NTILE()
```

---

# Common Interview Questions

1. Difference between GROUP BY and window functions
2. ROW_NUMBER vs RANK vs DENSE_RANK
3. What is PARTITION BY?
4. Explain LEAD and LAG
5. What are window frames?
6. Running total query
7. Top N per category query
8. Difference between aggregate and window functions
9. How window functions execute
10. Performance considerations

---

# Performance Considerations

Window functions are powerful but expensive.

Especially:
- large partitions
- sorting operations
- distributed systems

---

# Expensive Operations

| Operation | Cost |
|---|---|
| ORDER BY | High |
| Large partitions | Memory heavy |
| Multiple windows | Computationally expensive |

---

# Optimization Tips

---

# Partition Wisely

Avoid massive partitions.

Bad:

```sql
PARTITION BY country
```

when country has:
```text
millions of rows
```

---

# Minimize Sorting

Sorting is expensive.

Indexes may help in traditional databases.

---

# Avoid Multiple Similar Windows

Combine logic where possible.

---

# Use CTEs for Clarity

Window queries become complex quickly.

CTEs improve readability.

---

# Example

```sql
WITH ranked_employees AS (
    SELECT
        name,
        salary,
        ROW_NUMBER() OVER (
            ORDER BY salary DESC
        ) AS rank_num
    FROM employees
)

SELECT *
FROM ranked_employees
WHERE rank_num <= 3;
```

---

# Window Functions in Data Warehousing

Extremely common in:
- Snowflake
- BigQuery
- Redshift
- Spark SQL

Used for:
- analytics
- BI reports
- KPI calculations
- customer segmentation

---

# Window Functions in Spark SQL

Spark heavily optimizes window operations using:
```text
Catalyst Optimizer
```

But large window operations can trigger:
- expensive shuffles
- memory pressure
- skew issues

Critical in big data engineering.

---

# Common Mistakes

---

# Confusing GROUP BY with Window Functions

GROUP BY collapses rows.

Window functions preserve rows.

---

# Forgetting ORDER BY

Functions like:
- ROW_NUMBER
- LEAD
- LAG

require proper ordering.

---

# Using Large Unbounded Windows

Can create:
- huge memory usage
- slow queries

---

# Summary

Window functions are among the most powerful SQL analytical features.

Core concepts covered:
- OVER()
- PARTITION BY
- ORDER BY
- ranking functions
- LEAD/LAG
- running totals
- moving averages
- window frames

Window functions are essential for:
- advanced analytics
- ETL transformations
- reporting systems
- time-series analysis
- large-scale data engineering

Mastering window functions significantly improves:
- SQL interview performance
- analytical thinking
- production query design
- warehouse engineering capability
