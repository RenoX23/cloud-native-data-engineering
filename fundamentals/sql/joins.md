# SQL Joins

# Introduction

SQL Joins are used to combine data from multiple tables based on related columns.

Joins are one of the most important SQL concepts in:
- Data Engineering
- Data Analytics
- Data Warehousing
- ETL Pipelines
- Reporting Systems

Most real-world datasets are normalized across multiple tables, so joins are required constantly.

---

# Why Joins Matter

Example:

You may have:
- employee details in one table
- department details in another
- salary information elsewhere

Joins allow combining them into a meaningful dataset.

Without joins, relational databases lose most of their power.

---

# Sample Tables

We will use two tables throughout this document.

---

# employees Table

| emp_id | name | department_id |
|---|---|---|
| 101 | John | 1 |
| 102 | Alice | 2 |
| 103 | Bob | 1 |
| 104 | David | 3 |
| 105 | Emma | NULL |

---

# departments Table

| department_id | department_name |
|---|---|
| 1 | Engineering |
| 2 | HR |
| 3 | Finance |
| 4 | Marketing |

---

# Types of SQL Joins

| Join Type | Purpose |
|---|---|
| INNER JOIN | Matching rows only |
| LEFT JOIN | All left table rows + matches |
| RIGHT JOIN | All right table rows + matches |
| FULL OUTER JOIN | All rows from both tables |
| CROSS JOIN | Cartesian product |
| SELF JOIN | Join table with itself |

---

# INNER JOIN

Returns only matching rows from both tables.

---

# Syntax

```sql
SELECT columns
FROM table1
INNER JOIN table2
ON table1.column = table2.column;
```

---

# Example

```sql
SELECT
    e.emp_id,
    e.name,
    d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;
```

---

# Output

| emp_id | name | department_name |
|---|---|---|
| 101 | John | Engineering |
| 102 | Alice | HR |
| 103 | Bob | Engineering |
| 104 | David | Finance |

---

# Explanation

- SQL matches rows where:

```text
employees.department_id = departments.department_id
```

- Emma is excluded because:

```text
department_id = NULL
```

- Marketing is excluded because no employee belongs to it.

---

# LEFT JOIN

Returns:
- all rows from LEFT table
- matching rows from RIGHT table

If no match exists:
- NULL values appear

---

# Syntax

```sql
SELECT columns
FROM table1
LEFT JOIN table2
ON table1.column = table2.column;
```

---

# Example

```sql
SELECT
    e.name,
    d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;
```

---

# Output

| name | department_name |
|---|---|
| John | Engineering |
| Alice | HR |
| Bob | Engineering |
| David | Finance |
| Emma | NULL |

---

# Key Insight

LEFT JOIN preserves all rows from:
```text
LEFT TABLE
```

Even if matches do not exist.

---

# RIGHT JOIN

Opposite of LEFT JOIN.

Returns:
- all rows from RIGHT table
- matching rows from LEFT table

---

# Example

```sql
SELECT
    e.name,
    d.department_name
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id;
```

---

# Output

| name | department_name |
|---|---|
| John | Engineering |
| Bob | Engineering |
| Alice | HR |
| David | Finance |
| NULL | Marketing |

---

# Explanation

Marketing appears even though:
- no employee belongs to it

---

# FULL OUTER JOIN

Returns:
- all rows from both tables
- matched where possible
- NULL where no match exists

---

# Example

```sql
SELECT
    e.name,
    d.department_name
FROM employees e
FULL OUTER JOIN departments d
ON e.department_id = d.department_id;
```

---

# Output

| name | department_name |
|---|---|
| John | Engineering |
| Alice | HR |
| Bob | Engineering |
| David | Finance |
| Emma | NULL |
| NULL | Marketing |

---

# CROSS JOIN

Creates Cartesian Product.

Every row from table1 combines with every row from table2.

---

# Formula

```text
Rows Returned =
(table1 rows) × (table2 rows)
```

---

# Example

```sql
SELECT
    e.name,
    d.department_name
FROM employees e
CROSS JOIN departments d;
```

---

# If:

- employees = 5 rows
- departments = 4 rows

Result:
```text
5 × 4 = 20 rows
```

---

# Use Cases

Rarely used directly.

Useful for:
- combinations
- matrix generation
- calendar tables
- testing datasets

---

# SELF JOIN

A table joined with itself.

Useful for:
- hierarchical relationships
- manager-employee mapping
- organizational structures

---

# Example Table

| emp_id | employee | manager_id |
|---|---|---|
| 1 | John | NULL |
| 2 | Alice | 1 |
| 3 | Bob | 1 |

---

# Query

```sql
SELECT
    e.employee AS employee_name,
    m.employee AS manager_name
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.emp_id;
```

---

# Output

| employee_name | manager_name |
|---|---|
| John | NULL |
| Alice | John |
| Bob | John |

---

# Visual Understanding of Joins

---

# INNER JOIN

```text
Only overlapping data
```

---

# LEFT JOIN

```text
All LEFT + matching RIGHT
```

---

# RIGHT JOIN

```text
All RIGHT + matching LEFT
```

---

# FULL OUTER JOIN

```text
Everything from both sides
```

---

# Join Conditions

The `ON` clause defines matching logic.

---

# Example

```sql
ON employees.department_id = departments.department_id
```

---

# Multiple Join Conditions

```sql
SELECT *
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
AND o.country = c.country;
```

---

# Joining Multiple Tables

Real-world queries often involve many tables.

---

# Example

```sql
SELECT
    o.order_id,
    c.customer_name,
    p.product_name
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN products p
ON o.product_id = p.product_id;
```

---

# Aliases

Aliases improve readability.

---

# Without Alias

```sql
SELECT employees.name
FROM employees;
```

---

# With Alias

```sql
SELECT e.name
FROM employees e;
```

Industry standard practice.

---

# NULL Behavior in Joins

NULL does NOT equal NULL.

This is critical.

---

# Example

```sql
NULL = NULL
```

Returns:
```text
UNKNOWN
```

Not TRUE.

---

# Therefore

Rows with NULL values may not match during joins.

---

# Common Join Mistakes

---

# 1. Missing Join Condition

Bad query:

```sql
SELECT *
FROM employees, departments;
```

This creates accidental Cartesian product.

Potentially catastrophic in production.

---

# 2. Joining Wrong Columns

Bad joins create:
- duplicate rows
- incorrect aggregations
- inflated metrics

Always validate relationships.

---

# 3. Using INNER JOIN Instead of LEFT JOIN

Can accidentally lose data.

Example:
- customers without orders disappear

Very common analytics mistake.

---

# Join Order Execution

SQL execution typically:

```text
FROM
JOIN
ON
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
LIMIT
```

Understanding execution order helps debugging.

---

# Performance Considerations

Joins are expensive operations at scale.

Especially:
- large tables
- distributed systems
- Spark joins
- warehouse queries

---

# Factors Affecting Join Performance

| Factor | Impact |
|---|---|
| Indexes | Faster lookups |
| Data size | Larger joins slower |
| Skewed data | Uneven processing |
| Join type | Some joins heavier |
| Partitioning | Better scalability |

---

# Indexing for Joins

Joining indexed columns improves performance significantly.

---

# Example

```sql
CREATE INDEX idx_department
ON employees(department_id);
```

---

# Join Types in Data Engineering

| Use Case | Join Type |
|---|---|
| Fact + Dimension Tables | INNER JOIN |
| Preserve incomplete records | LEFT JOIN |
| Data Validation | FULL OUTER JOIN |
| Hierarchies | SELF JOIN |
| Combinations | CROSS JOIN |

---

# Joins in Data Warehousing

Very common architecture:

---

# Fact Table

Contains:
- transactions
- metrics
- events

---

# Dimension Tables

Contains:
- customer info
- product details
- region info

---

# Example

```text
sales_fact
    JOIN
customer_dimension
```

This is foundational for analytics systems.

---

# Real-World Example

---

# E-Commerce Pipeline

Tables:
- orders
- customers
- products
- payments
- shipping

Joins combine them into:
- dashboards
- reports
- KPIs
- business analytics

---

# SQL Join Interview Questions

Common interview topics:

1. Difference between INNER and LEFT JOIN
2. Explain FULL OUTER JOIN
3. What causes duplicate rows?
4. How do joins affect performance?
5. What is Cartesian product?
6. Explain SELF JOIN
7. How does NULL behave in joins?
8. Difference between ON vs WHERE in joins
9. How to optimize joins
10. Star schema joins

---

# Best Practices

---

# Use Explicit JOIN Syntax

Prefer:

```sql
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id
```

Avoid old implicit syntax.

---

# Select Required Columns Only

Bad:

```sql
SELECT *
```

Good:

```sql
SELECT e.name, d.department_name
```

---

# Validate Row Counts

After joins:
- check duplicates
- verify totals
- validate metrics

Critical in production pipelines.

---

# Use Proper Aliases

Improves readability for large queries.

---

# Summary

SQL Joins are foundational for relational data processing.

Core concepts covered:
- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- FULL OUTER JOIN
- CROSS JOIN
- SELF JOIN
- NULL behavior
- Join optimization
- Real-world usage

Mastering joins is essential before moving to:
- window functions
- advanced analytics
- Spark SQL
- distributed query engines
- data warehousing
- large-scale ETL systems
