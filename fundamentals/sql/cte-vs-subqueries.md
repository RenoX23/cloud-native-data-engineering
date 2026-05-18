# CTE vs Subqueries

# Introduction

Both CTEs (Common Table Expressions) and Subqueries are used to break complex SQL queries into smaller logical parts.

They help:
- simplify query logic
- improve readability
- structure transformations
- build analytical workflows

Understanding when to use:
- CTEs
- subqueries
- derived tables

is an important SQL engineering skill.

This topic is heavily used in:
- Data Engineering
- Analytics Engineering
- ETL Pipelines
- Data Warehousing
- SQL Interviews

---

# What is a Subquery?

A subquery is a query written inside another query.

It is also called:
```text
Nested Query
```

---

# Basic Syntax

```sql
SELECT column_name
FROM table_name
WHERE column_name IN (
    SELECT column_name
    FROM another_table
);
```

---

# Example

Find employees earning above average salary.

```sql
SELECT name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

---

# Execution Flow

1. Inner query executes first:

```sql
SELECT AVG(salary)
FROM employees
```

2. Outer query uses result.

---

# Output Example

| name | salary |
|---|---|
| John | 90000 |
| Alice | 85000 |

---

# What is a CTE?

CTE stands for:
```text
Common Table Expression
```

A CTE creates a temporary named result set usable within the query.

---

# Basic Syntax

```sql
WITH cte_name AS (
    SELECT ...
)
SELECT *
FROM cte_name;
```

---

# Example

Same query using CTE:

```sql
WITH avg_salary_cte AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
)

SELECT name, salary
FROM employees
WHERE salary > (
    SELECT avg_salary
    FROM avg_salary_cte
);
```

---

# Key Idea

CTEs improve:
- readability
- modularity
- maintainability

Especially for large analytical queries.

---

# CTE vs Subquery Overview

| Feature | CTE | Subquery |
|---|---|---|
| Readability | High | Lower in complex queries |
| Reusability | Reusable | Usually one-time use |
| Complexity Handling | Better | Harder |
| Recursive Support | Yes | No |
| Debugging | Easier | Harder |
| Query Nesting | Cleaner | Deep nesting possible |
| Performance | Depends on optimizer | Depends on optimizer |

---

# Types of Subqueries

| Type | Description |
|---|---|
| Scalar Subquery | Returns one value |
| Multi-row Subquery | Returns multiple rows |
| Correlated Subquery | Depends on outer query |
| Nested Subquery | Subquery inside another |

---

# Scalar Subquery

Returns single value.

---

# Example

```sql
SELECT name
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

AVG returns:
```text
single value
```

---

# Multi-Row Subquery

Returns multiple rows.

---

# Example

```sql
SELECT name
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location = 'Bangalore'
);
```

---

# Correlated Subquery

Depends on outer query values.

More expensive computationally.

---

# Example

```sql
SELECT e1.name, e1.salary
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e1.department_id = e2.department_id
);
```

---

# Explanation

For each employee:
- subquery recalculates department average

Potentially slow on large datasets.

---

# Equivalent CTE Version

```sql
WITH dept_avg AS (
    SELECT
        department_id,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)

SELECT
    e.name,
    e.salary
FROM employees e
JOIN dept_avg d
ON e.department_id = d.department_id
WHERE e.salary > d.avg_salary;
```

---

# Why CTE is Better Here

Advantages:
- clearer logic
- avoids repeated calculations
- easier optimization
- more maintainable

---

# Deeply Nested Subquery Problem

Subqueries become difficult when nested heavily.

---

# Example

```sql
SELECT *
FROM (
    SELECT *
    FROM (
        SELECT *
        FROM employees
    ) a
) b;
```

Readable?
```text
No
```

Maintainable?
```text
Poor
```

---

# Equivalent CTE

```sql
WITH employee_data AS (
    SELECT *
    FROM employees
)

SELECT *
FROM employee_data;
```

Much cleaner.

---

# Multiple CTEs

CTEs can chain transformations.

---

# Example

```sql
WITH department_salary AS (
    SELECT
        department_id,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
),

high_salary_departments AS (
    SELECT *
    FROM department_salary
    WHERE avg_salary > 70000
)

SELECT *
FROM high_salary_departments;
```

---

# Why Data Engineers Prefer CTEs

Large ETL queries often contain:
- joins
- aggregations
- filters
- transformations
- ranking
- window functions

CTEs organize logic step-by-step.

This resembles:
```text
pipeline stages
```

---

# Recursive CTEs

Major feature unavailable in standard subqueries.

Used for:
- hierarchies
- trees
- graphs
- organizational structures

---

# Recursive CTE Syntax

```sql
WITH RECURSIVE cte_name AS (
    anchor_query

    UNION ALL

    recursive_query
)
SELECT *
FROM cte_name;
```

---

# Example: Employee Hierarchy

| emp_id | employee | manager_id |
|---|---|---|
| 1 | CEO | NULL |
| 2 | Manager | 1 |
| 3 | Engineer | 2 |

---

# Query

```sql
WITH RECURSIVE employee_hierarchy AS (

    SELECT
        emp_id,
        employee,
        manager_id,
        1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.emp_id,
        e.employee,
        e.manager_id,
        eh.level + 1
    FROM employees e
    JOIN employee_hierarchy eh
    ON e.manager_id = eh.emp_id
)

SELECT *
FROM employee_hierarchy;
```

---

# Use Cases of Recursive CTEs

| Use Case | Example |
|---|---|
| Organizational charts | Manager hierarchy |
| Folder structures | File systems |
| Graph traversal | Network paths |
| Bill of materials | Manufacturing |
| Dependency chains | Build systems |

---

# Performance Considerations

Very important topic.

---

# Myth

```text
CTEs are always faster
```

False.

---

# Reality

Performance depends on:
- database optimizer
- execution planner
- query structure
- indexing
- materialization strategy

---

# Some Databases Materialize CTEs

Meaning:
```text
CTE result stored temporarily
```

Can improve or hurt performance.

---

# Some Databases Inline CTEs

Optimizer treats CTE like normal subquery.

Modern databases often do this.

---

# Database Behavior Differences

| Database | CTE Optimization |
|---|---|
| PostgreSQL | Historically materialized |
| SQL Server | Usually optimized inline |
| Snowflake | Optimizer handles automatically |
| BigQuery | Highly optimized |
| Spark SQL | Catalyst optimizer rewrites |

---

# Subquery Performance Issues

Correlated subqueries can become expensive.

---

# Example

```sql
SELECT *
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e1.department_id = e2.department_id
);
```

Potential issue:
```text
subquery executes repeatedly
```

---

# Better Alternative

Use:
- CTE
- JOIN
- window function

---

# CTE + Window Function Alternative

```sql
WITH employee_avg AS (
    SELECT
        name,
        salary,
        department_id,
        AVG(salary) OVER (
            PARTITION BY department_id
        ) AS dept_avg
    FROM employees
)

SELECT *
FROM employee_avg
WHERE salary > dept_avg;
```

Much more scalable.

---

# Derived Tables

Another related concept.

---

# Example

```sql
SELECT *
FROM (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) dept_avg;
```

Derived tables:
- temporary result sets
- inside FROM clause

---

# CTE vs Derived Table

| Feature | CTE | Derived Table |
|---|---|---|
| Readability | Better | Worse for complex logic |
| Reusability | Yes | No |
| Multi-step Logic | Easy | Hard |
| Nesting | Cleaner | Messy |

---

# Real-World Data Engineering Example

---

# ETL Pipeline

Suppose pipeline requires:

1. Clean raw data
2. Aggregate transactions
3. Join customer info
4. Filter anomalies
5. Generate report

CTEs naturally structure these stages.

---

# Example

```sql
WITH cleaned_data AS (
    ...
),

aggregated_sales AS (
    ...
),

customer_metrics AS (
    ...
)

SELECT *
FROM customer_metrics;
```

This resembles production ETL workflows.

---

# Common Interview Questions

1. Difference between CTE and subquery
2. What is correlated subquery?
3. What are recursive CTEs?
4. Are CTEs faster than subqueries?
5. What is materialization?
6. When to prefer CTE?
7. Can CTE reference another CTE?
8. Difference between CTE and temporary table
9. What is derived table?
10. How to optimize correlated subqueries?

---

# Best Practices

---

# Use CTEs for Complex Logic

Especially:
- multi-step transformations
- analytics queries
- reporting pipelines

---

# Avoid Deep Nested Subqueries

They become:
- unreadable
- difficult to debug
- hard to maintain

---

# Avoid Correlated Subqueries on Large Tables

Can cause:
```text
massive performance degradation
```

Prefer:
- joins
- window functions
- aggregated CTEs

---

# Use Meaningful CTE Names

Bad:

```sql
WITH temp1 AS (...)
```

Good:

```sql
WITH monthly_sales AS (...)
```

---

# Keep CTEs Modular

Each CTE should represent:
```text
one logical transformation
```

---

# CTE vs Temporary Tables

| Feature | CTE | Temporary Table |
|---|---|---|
| Lifetime | Single query | Session |
| Storage | Usually memory | Physical temp storage |
| Reusability | Within query | Across queries |
| Performance | Lightweight | Better for repeated reuse |

---

# Summary

Both CTEs and subqueries are essential SQL tools.

Core concepts covered:
- subqueries
- correlated subqueries
- CTEs
- recursive CTEs
- derived tables
- performance tradeoffs
- ETL structuring

General guideline:

Use:
- subqueries for small/simple logic
- CTEs for complex/multi-step transformations

Modern Data Engineering heavily favors:
- modular SQL
- readable pipelines
- maintainable transformations

CTEs align strongly with those goals.
