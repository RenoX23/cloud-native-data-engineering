# SQL Basics

## What is SQL

## Why SQL Matters in Data Engineering

## Types of SQL Commands
- DDL
- DML
- DQL
- DCL
- TCL

## Core Database Concepts
- Tables
- Rows
- Columns
- Primary Keys
- Foreign Keys

## Basic Queries
- SELECT
- WHERE
- ORDER BY
- GROUP BY
- HAVING

## Aggregate Functions
- COUNT
- SUM
- AVG
- MAX
- MIN

## NULL Handling

## Constraints

## Real-world Use Cases

## Engineering Notes

## Common Mistakes

## Interview Questions
What Must Be Inside
1️⃣ What is SQL

Explain:

Structured Query Language
relational databases
querying/manipulating data
2️⃣ Why SQL Matters in DE

Critical section.

Mention:

warehouses are SQL-driven
dbt uses SQL
analytics depends on SQL
Spark SQL exists
optimization requires SQL understanding
3️⃣ Types of Commands
DDL
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);
DML
INSERT INTO employees VALUES (1, 'Renold');
DQL
SELECT * FROM employees;
TCL
COMMIT;
ROLLBACK;
4️⃣ Basic Queries
SELECT
SELECT name FROM employees;
WHERE
SELECT * FROM employees
WHERE salary > 50000;
ORDER BY
SELECT * FROM employees
ORDER BY salary DESC;
GROUP BY
SELECT department,
       COUNT(*)
FROM employees
GROUP BY department;
5️⃣ Aggregate Functions

Explain:

aggregation
analytics usage
reporting systems
6️⃣ Engineering Notes ⚡

VERY important.

## Engineering Notes

SQL is not just a querying language.

In production data systems:
- SQL powers transformations
- SQL drives dashboards
- SQL is heavily used in dbt
- SQL optimization impacts warehouse cost
- Poor SQL design can severely degrade performance

At scale:
- inefficient queries increase compute cost
- full table scans become dangerous
- bad joins create distributed shuffle overhead

THIS is what separates engineers from tutorial learners.
