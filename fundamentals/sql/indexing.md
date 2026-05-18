# SQL Indexing

# Introduction

Indexing is a database optimization technique used to improve query performance.

An index helps the database locate rows faster without scanning the entire table.

Without indexes:
- databases perform full table scans
- query performance degrades as data grows

With indexes:
- lookups become significantly faster
- joins improve
- sorting becomes efficient
- filtering scales better

Indexes are one of the most important concepts in:
- SQL optimization
- Data Engineering
- Database Administration
- Large-scale analytics systems

---

# Real-World Analogy

Think of a book.

Without an index:
- finding a topic requires reading every page

With an index:
- jump directly to the required page

Database indexing works similarly.

---

# Why Indexing Matters

As tables grow to:
- millions of rows
- billions of rows

Query performance becomes critical.

Without indexing:
- dashboards slow down
- ETL jobs fail SLAs
- APIs become delayed
- warehouses become expensive

Indexes reduce lookup cost dramatically.

---

# Full Table Scan

Without an index, the database may scan every row.

---

# Example

```sql
SELECT *
FROM employees
WHERE emp_id = 101;
```

Without index:
```text
Database checks every row sequentially
```

Complexity:
```text
O(n)
```

Very slow for large tables.

---

# Creating an Index

---

# Syntax

```sql
CREATE INDEX index_name
ON table_name(column_name);
```

---

# Example

```sql
CREATE INDEX idx_emp_id
ON employees(emp_id);
```

Now the database can find rows much faster.

---

# How Indexes Work

Most relational databases use:
- B-Tree indexes

Some databases also support:
- Hash indexes
- Bitmap indexes
- GiST indexes
- BRIN indexes

---

# B-Tree Index

Most common index structure.

Optimized for:
- equality lookups
- range queries
- sorting

---

# Concept

Instead of scanning:
```text
1 → 2 → 3 → 4 → 5 → ...
```

Database navigates tree structure:
```text
root → branch → leaf
```

This reduces search complexity.

---

# Time Complexity

| Operation | Without Index | With B-Tree Index |
|---|---|---|
| Search | O(n) | O(log n) |
| Insert | O(1) | Slightly slower |
| Update | Fast | Slightly slower |
| Delete | Fast | Slightly slower |

Indexes improve reads but slightly slow writes.

---

# Types of Indexes

| Type | Purpose |
|---|---|
| Single Column Index | One column |
| Composite Index | Multiple columns |
| Unique Index | Prevent duplicates |
| Clustered Index | Physical row ordering |
| Non-Clustered Index | Separate structure |
| Full-Text Index | Text searching |
| Hash Index | Exact match lookups |

---

# Single Column Index

Index on one column.

---

# Example

```sql
CREATE INDEX idx_department
ON employees(department_id);
```

Optimizes queries like:

```sql
SELECT *
FROM employees
WHERE department_id = 1;
```

---

# Composite Index

Index on multiple columns.

---

# Example

```sql
CREATE INDEX idx_dept_salary
ON employees(department_id, salary);
```

Useful for:

```sql
SELECT *
FROM employees
WHERE department_id = 1
AND salary > 50000;
```

---

# Important Rule

Composite indexes follow:
```text
Leftmost Prefix Principle
```

---

# Example

Index:
```sql
(department_id, salary)
```

Efficient for:
```sql
WHERE department_id = 1
```

Efficient for:
```sql
WHERE department_id = 1
AND salary > 50000
```

NOT efficient for:
```sql
WHERE salary > 50000
```

Because index starts with:
```text
department_id
```

---

# Unique Index

Ensures uniqueness.

---

# Example

```sql
CREATE UNIQUE INDEX idx_email
ON employees(email);
```

Prevents duplicate emails.

---

# Clustered vs Non-Clustered Index

Critical interview topic.

---

# Clustered Index

Determines physical storage order of rows.

Characteristics:
- only one per table
- data physically sorted

---

# Example

```text
Rows stored ordered by primary key
```

---

# Non-Clustered Index

Separate structure containing:
- indexed values
- pointers to rows

Characteristics:
- multiple allowed
- data order unchanged

---

# Example

```text
Index points to actual row locations
```

---

# Clustered vs Non-Clustered

| Feature | Clustered | Non-Clustered |
|---|---|---|
| Physical sorting | Yes | No |
| Count per table | One | Multiple |
| Storage | Table itself | Separate structure |
| Lookup speed | Faster | Slightly slower |

---

# Primary Key and Indexing

Most databases automatically create indexes on:
- PRIMARY KEY
- UNIQUE constraints

---

# Example

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY
);
```

Automatically indexed in most systems.

---

# Index Usage Example

---

# Without Index

```sql
SELECT *
FROM transactions
WHERE customer_id = 1001;
```

Database scans:
```text
millions of rows
```

---

# With Index

```sql
CREATE INDEX idx_customer
ON transactions(customer_id);
```

Now database jumps directly to matching rows.

Massive performance improvement.

---

# Indexes and Joins

Indexes significantly improve JOIN performance.

---

# Example

```sql
SELECT *
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id;
```

Indexing:
```sql
customer_id
```

on both tables improves join efficiency.

---

# Indexes and ORDER BY

Indexes can optimize sorting.

---

# Example

```sql
SELECT *
FROM employees
ORDER BY salary;
```

Index:
```sql
CREATE INDEX idx_salary
ON employees(salary);
```

Database may avoid expensive sorting operations.

---

# Indexes and GROUP BY

Indexes may help grouping operations.

Especially:
- analytical queries
- warehouses
- aggregations

---

# Over-Indexing Problem

More indexes are NOT always better.

Each index adds:
- storage overhead
- insert overhead
- update overhead
- delete overhead

---

# Example

When inserting data:

```sql
INSERT INTO employees VALUES (...);
```

Database must:
1. insert row
2. update all indexes

Too many indexes slow writes heavily.

---

# Signs of Bad Indexing

| Problem | Cause |
|---|---|
| Slow inserts | Too many indexes |
| Large storage usage | Excessive indexing |
| Slow updates | Indexed columns frequently modified |
| Unused indexes | Poor index design |

---

# Index Selectivity

Very important concept.

---

# High Selectivity

Column contains many unique values.

Example:
```text
email
employee_id
transaction_id
```

Indexes work well.

---

# Low Selectivity

Column contains few distinct values.

Example:
```text
gender
status
boolean flags
```

Indexes may not help much.

---

# Example

Poor index:

```sql
CREATE INDEX idx_gender
ON employees(gender);
```

If:
```text
50% Male
50% Female
```

Database may prefer full scan instead.

---

# Query Execution Plans

Databases decide whether to use indexes using:
- query optimizer
- execution planner

---

# EXPLAIN Statement

Used to analyze queries.

---

# Example

```sql
EXPLAIN
SELECT *
FROM employees
WHERE emp_id = 101;
```

Shows:
- scan type
- index usage
- estimated rows
- query cost

Critical skill for performance tuning.

---

# Common Scan Types

| Scan Type | Meaning |
|---|---|
| Sequential Scan | Full table scan |
| Index Scan | Uses index |
| Bitmap Scan | Combined index strategy |

---

# Covering Index

Index contains all required query columns.

Database avoids accessing main table.

---

# Example

Index:

```sql
CREATE INDEX idx_covering
ON employees(department_id, salary);
```

Query:

```sql
SELECT department_id, salary
FROM employees
WHERE department_id = 1;
```

Database may answer entirely from index.

Very fast.

---

# Partial Index

Indexes only subset of rows.

---

# Example

```sql
CREATE INDEX idx_active_users
ON users(status)
WHERE status = 'active';
```

Reduces index size.

Useful in large datasets.

---

# Full-Text Index

Used for:
- text searching
- search engines
- document systems

---

# Example

```sql
CREATE FULLTEXT INDEX idx_description
ON products(description);
```

---

# Index Maintenance

Indexes require maintenance.

Over time:
- fragmentation occurs
- performance degrades

Databases may:
- rebuild indexes
- reorganize indexes
- vacuum storage

---

# Indexing in Data Warehousing

Warehouses often use:
- partitioning
- clustering
- columnar storage

Instead of traditional heavy indexing.

Reason:
- analytical workloads differ from OLTP systems

---

# OLTP vs OLAP Indexing

| Feature | OLTP | OLAP |
|---|---|---|
| Workload | Transactions | Analytics |
| Queries | Small lookups | Large scans |
| Indexing | Heavy indexing | Selective indexing |
| Updates | Frequent | Less frequent |

---

# Distributed Systems and Indexing

In distributed systems:
- indexes become more complex
- data partitioning matters
- network shuffling affects performance

Systems:
- Spark
- Snowflake
- BigQuery

optimize differently than traditional databases.

---

# Common Interview Questions

1. What is indexing?
2. Difference between clustered and non-clustered index
3. What is composite index?
4. What is index selectivity?
5. Why too many indexes are bad?
6. What is covering index?
7. Explain B-Tree index
8. How indexes improve joins?
9. Why indexes slow inserts?
10. What is EXPLAIN?

---

# Best Practices

---

# Index Frequently Queried Columns

Good candidates:
- WHERE clauses
- JOIN conditions
- ORDER BY columns
- GROUP BY columns

---

# Avoid Indexing Small Tables

Full scans may already be fast.

Indexes unnecessary.

---

# Avoid Over-Indexing

Each index has maintenance cost.

---

# Monitor Query Plans

Always validate:
```sql
EXPLAIN
```

Do not assume indexes are used.

---

# Use Composite Index Carefully

Column order matters.

Most selective columns often first.

---

# Real-World Example

---

# E-Commerce System

Common queries:

```sql
SELECT *
FROM orders
WHERE customer_id = 1001;
```

Index:
```sql
customer_id
```

---

Analytics query:

```sql
SELECT *
FROM orders
WHERE order_date BETWEEN '2025-01-01' AND '2025-01-31';
```

Index:
```sql
order_date
```

---

# Summary

Indexing is critical for scalable database performance.

Core concepts covered:
- B-Tree indexing
- Composite indexes
- Clustered vs non-clustered
- Query optimization
- Execution plans
- Covering indexes
- Selectivity
- Index maintenance

Strong understanding of indexing is essential for:
- SQL optimization
- scalable ETL systems
- high-performance APIs
- analytics platforms
- distributed data engineering systems

Master indexing before moving deeply into:
- query optimization
- partitioning
- distributed SQL engines
- Spark performance tuning
- warehouse optimization
