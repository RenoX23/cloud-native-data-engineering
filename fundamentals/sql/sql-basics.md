# SQL Basics

## Introduction

SQL (Structured Query Language) is the standard language used to interact with relational databases.
It is used for:

- Storing data
- Retrieving data
- Updating records
- Deleting records
- Managing database structures
- Performing analytical operations

SQL is one of the most important skills for Data Engineering because almost every data system relies on querying structured data.

---

# Why SQL Matters in Data Engineering

Data Engineers use SQL for:

- ETL/ELT pipelines
- Data transformation
- Data cleaning
- Building dashboards
- Query optimization
- Data warehousing
- Analytics
- Reporting
- Data validation

Strong SQL skills are often more important than coding skills in many DE roles.

---

# Types of SQL Commands

| Category | Purpose |
|---|---|
| DDL | Data Definition Language |
| DML | Data Manipulation Language |
| DQL | Data Query Language |
| DCL | Data Control Language |
| TCL | Transaction Control Language |

---

# 1. DDL (Data Definition Language)

Used to define and modify database structures.

## CREATE TABLE

```sql
CREATE TABLE employees (
    emp_id INT,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);
```

### Explanation

- `INT` → Integer values
- `VARCHAR` → Variable length string
- `DECIMAL` → Decimal numbers

---

## ALTER TABLE

Add a new column:

```sql
ALTER TABLE employees
ADD email VARCHAR(100);
```

---

## DROP TABLE

Deletes entire table permanently.

```sql
DROP TABLE employees;
```

⚠️ Dangerous operation. Cannot be undone in most systems.

---

# 2. DML (Data Manipulation Language)

Used to manipulate data inside tables.

---

## INSERT

```sql
INSERT INTO employees
(emp_id, name, department, salary)
VALUES
(101, 'John', 'Engineering', 75000);
```

---

## UPDATE

```sql
UPDATE employees
SET salary = 80000
WHERE emp_id = 101;
```

⚠️ Always use `WHERE` carefully.

Without WHERE:

```sql
UPDATE employees
SET salary = 80000;
```

This updates ALL rows.

---

## DELETE

```sql
DELETE FROM employees
WHERE emp_id = 101;
```

---

# 3. DQL (Data Query Language)

Used to retrieve data.

---

## SELECT

```sql
SELECT * FROM employees;
```

### Explanation

- `SELECT` → retrieves data
- `*` → all columns

---

## Selecting Specific Columns

```sql
SELECT name, salary
FROM employees;
```

---

# WHERE Clause

Filters records.

```sql
SELECT *
FROM employees
WHERE salary > 50000;
```

---

# Comparison Operators

| Operator | Meaning |
|---|---|
| = | Equal |
| != | Not Equal |
| > | Greater Than |
| < | Less Than |
| >= | Greater Than Equal |
| <= | Less Than Equal |

---

# Logical Operators

## AND

```sql
SELECT *
FROM employees
WHERE department = 'Engineering'
AND salary > 70000;
```

---

## OR

```sql
SELECT *
FROM employees
WHERE department = 'Engineering'
OR department = 'HR';
```

---

## NOT

```sql
SELECT *
FROM employees
WHERE NOT department = 'HR';
```

---

# ORDER BY

Sorts results.

## Ascending Order

```sql
SELECT *
FROM employees
ORDER BY salary ASC;
```

---

## Descending Order

```sql
SELECT *
FROM employees
ORDER BY salary DESC;
```

---

# LIMIT

Restricts number of rows returned.

```sql
SELECT *
FROM employees
LIMIT 5;
```

Useful for:
- Sampling data
- Debugging queries
- Previewing datasets

---

# DISTINCT

Removes duplicates.

```sql
SELECT DISTINCT department
FROM employees;
```

---

# Aggregate Functions

Used for calculations.

| Function | Purpose |
|---|---|
| COUNT() | Count rows |
| SUM() | Total sum |
| AVG() | Average |
| MAX() | Maximum value |
| MIN() | Minimum value |

---

## COUNT

```sql
SELECT COUNT(*)
FROM employees;
```

---

## AVG

```sql
SELECT AVG(salary)
FROM employees;
```

---

## MAX

```sql
SELECT MAX(salary)
FROM employees;
```

---

# GROUP BY

Groups rows with similar values.

```sql
SELECT department, AVG(salary)
FROM employees
GROUP BY department;
```

### Workflow

1. Group rows by department
2. Calculate average salary per group

---

# HAVING

Filters grouped data.

```sql
SELECT department, AVG(salary)
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;
```

---

# SQL Execution Order

Important concept for interviews.

```sql
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT
```

Actual execution order:

```text
FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
LIMIT
```

Understanding this explains many SQL errors.

---

# NULL Values

NULL means missing or unknown value.

---

## IS NULL

```sql
SELECT *
FROM employees
WHERE email IS NULL;
```

---

## IS NOT NULL

```sql
SELECT *
FROM employees
WHERE email IS NOT NULL;
```

---

# LIKE Operator

Used for pattern matching.

---

## Starts With

```sql
SELECT *
FROM employees
WHERE name LIKE 'J%';
```

---

## Ends With

```sql
SELECT *
FROM employees
WHERE name LIKE '%n';
```

---

## Contains

```sql
SELECT *
FROM employees
WHERE name LIKE '%oh%';
```

---

# IN Operator

Checks multiple values.

```sql
SELECT *
FROM employees
WHERE department IN ('Engineering', 'HR');
```

---

# BETWEEN Operator

Range filtering.

```sql
SELECT *
FROM employees
WHERE salary BETWEEN 50000 AND 90000;
```

---

# Aliases

Temporary names for columns or tables.

```sql
SELECT name AS employee_name
FROM employees;
```

---

# Basic Joins Introduction

Joins combine data from multiple tables.

---

## INNER JOIN

Returns matching rows.

```sql
SELECT e.name, d.department_name
FROM employees e
INNER JOIN departments d
ON e.department = d.department_id;
```

---

# Primary Key

Uniquely identifies each row.

```sql
emp_id
```

Characteristics:
- Unique
- Cannot be NULL
- One per table

---

# Foreign Key

Creates relationship between tables.

Example:

```sql
department_id
```

Links:
- employees table
- departments table

---

# Constraints

Rules applied on columns.

| Constraint | Purpose |
|---|---|
| PRIMARY KEY | Unique row identifier |
| FOREIGN KEY | Relationship |
| NOT NULL | Prevent NULL values |
| UNIQUE | No duplicates |
| CHECK | Validate conditions |
| DEFAULT | Default values |

---

# Example Table with Constraints

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2) CHECK (salary > 0),
    department VARCHAR(50) DEFAULT 'General'
);
```

---

# Common Beginner Mistakes

## 1. Forgetting WHERE in UPDATE/DELETE

Dangerous because it affects all rows.

---

## 2. Using SELECT *

Avoid in production systems because:
- slower queries
- unnecessary data transfer
- schema dependency issues

Prefer:

```sql
SELECT name, salary
FROM employees;
```

---

## 3. Ignoring NULL Handling

NULL comparisons require:

```sql
IS NULL
```

NOT:

```sql
= NULL
```

---

# SQL Best Practices

## Use Meaningful Names

Good:

```sql
employee_salary
```

Bad:

```sql
es1
```

---

## Write Readable Queries

Use indentation.

Good:

```sql
SELECT name, salary
FROM employees
WHERE salary > 50000;
```

---

## Avoid Hardcoding

Bad:

```sql
WHERE department = 'Engineering'
```

Prefer parameterized queries in applications.

---

# Real-World Data Engineering Use Cases

| Use Case | SQL Usage |
|---|---|
| ETL Pipelines | Data transformation |
| Warehousing | Analytical queries |
| Reporting | KPI generation |
| Monitoring | Data quality checks |
| Analytics | Business insights |
| Data Validation | Detect anomalies |

---

# Recommended Next Topics

After mastering SQL basics, move to:

1. Joins
2. Window Functions
3. Common Table Expressions (CTEs)
4. Subqueries
5. Indexing
6. Query Optimization
7. Partitioning
8. Analytical SQL
9. Execution Plans
10. Distributed SQL Engines

---

# Summary

SQL forms the foundation of Data Engineering.

Core concepts covered:
- CRUD operations
- Filtering
- Aggregations
- Grouping
- Sorting
- Constraints
- NULL handling
- Basic joins

Strong SQL fundamentals directly improve:
- pipeline development
- debugging ability
- analytical thinking
- query optimization
- interview performance

Master SQL deeply before moving heavily into Spark, Kafka, or large-scale distributed systems.
