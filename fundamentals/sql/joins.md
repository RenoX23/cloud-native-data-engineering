# Joins

## Core Concept

A join combines rows from two or more tables based on a related column. The type of join controls what happens to rows that **don't match** the join condition — that's the only real decision you're making every time.

---

## Visual Map of All Join Types

```
Table A (Customers)     Table B (Orders)
┌────────────┐          ┌────────────┐
│ 1 Arjun    │──────────│ order 1    │  INNER: only matched rows
│ 2 Priya    │──────────│ order 6    │
│ ...        │          │ ...        │
│ 18 Siddharth│         │            │  LEFT:  A rows with no match → NULLs
│ 19 Divya   │         │            │
│ 20 Manish  │         │            │
└────────────┘          └────────────┘

INNER JOIN  → only rows that match in BOTH tables
LEFT JOIN   → all of A + matched B (unmatched B = NULL)
RIGHT JOIN  → all of B + matched A (unmatched A = NULL)
FULL OUTER  → all of A + all of B (unmatched sides = NULL)
CROSS JOIN  → every row in A × every row in B (Cartesian product)
SELF JOIN   → table joined to itself
```

---

## TechMart Data Facts (for join demos)

| Scenario | Who |
|---|---|
| Customers with NO orders | Siddharth (18), Divya (19), Manish (20) |
| Products with NO sales | Smart Watch (4), Gaming Headset (5) |
| Cancelled/returned orders | Orders 8, 9, 37 |
| Customers in same city | Arjun, Sneha, Meera, Manish → Bangalore |
| Two sellers in same city | None — each seller city is unique |

---

## 1. INNER JOIN

Returns only rows where the join condition matches in **both** tables. Non-matching rows on either side are excluded.

**Syntax:**
```sql
SELECT columns
FROM table_a
INNER JOIN table_b ON table_a.key = table_b.key;
```

**Result in TechMart:** 17 customers (excludes Siddharth, Divya, Manish who have no orders).

**Use when:** You only care about records that exist on both sides. Most common join in analytics.

---

## 2. LEFT JOIN (LEFT OUTER JOIN)

Returns **all rows from the left table** + matched rows from right. Unmatched right-side columns return NULL.

**Syntax:**
```sql
SELECT columns
FROM table_a
LEFT JOIN table_b ON table_a.key = table_b.key;
```

**Result in TechMart:** 20 customers returned — Siddharth, Divya, Manish appear with NULL order columns.

**Use when:**
- Finding unregistered/inactive records (customers with no orders)
- Keeping source records even if dimension lookup fails
- Building reports that should show all entities regardless of activity

---

## 3. RIGHT JOIN (RIGHT OUTER JOIN)

Returns **all rows from the right table** + matched rows from left. Logically identical to LEFT JOIN with tables swapped — most engineers prefer LEFT JOIN for readability.

**Syntax:**
```sql
SELECT columns
FROM table_a
RIGHT JOIN table_b ON table_a.key = table_b.key;
```

**Result in TechMart:** All products returned — Smart Watch and Gaming Headset appear with NULL order columns.

**Use when:** You want to preserve all rows from the right table. Rarely used; rewrite as LEFT JOIN by swapping table order instead.

---

## 4. FULL OUTER JOIN

Returns **all rows from both tables**. Unmatched rows on either side get NULLs on the opposite side.

**Syntax:**
```sql
SELECT columns
FROM table_a
FULL OUTER JOIN table_b ON table_a.key = table_b.key;
```

**Use when:**
- Data reconciliation between two sources
- Finding records that exist in A but not B, and vice versa, in one query
- Comparing two datasets for discrepancies (pipeline validation)

> ⚠️ Not supported in some older MySQL versions. Works in PostgreSQL, Spark, BigQuery, Snowflake.

---

## 5. CROSS JOIN

Returns the **Cartesian product** — every row in A paired with every row in B. No join condition.

**Syntax:**
```sql
SELECT columns
FROM table_a
CROSS JOIN table_b;
```

**Volume warning:** 20 customers × 6 categories = 120 rows. 1000 × 1000 = 1,000,000 rows.

**Use when:**
- Generating all possible combinations (product × region matrix, date × metric grid)
- Creating a date spine (cross join with a calendar table)
- Seeding test data

---

## 6. SELF JOIN

A table joined to **itself** using an alias. Used when rows within the same table are related to each other.

**Syntax:**
```sql
SELECT a.column, b.column
FROM table_a a
JOIN table_a b ON a.key = b.related_key;
```

**Use when:**
- Hierarchical data (employee → manager, category → parent_category)
- Finding pairs within a dataset (customers in same city)
- Sequential event comparison without LAG (though LAG is usually cleaner)

---

## 7. Anti-Join (NOT IN / NOT EXISTS / LEFT JOIN WHERE NULL)

Finds rows in table A that have **no match** in table B. Three ways to write it — each with trade-offs.

### Method 1: LEFT JOIN WHERE NULL (fastest in most engines)
```sql
SELECT a.*
FROM table_a a
LEFT JOIN table_b b ON a.key = b.key
WHERE b.key IS NULL;
```

### Method 2: NOT EXISTS (readable, handles NULLs safely)
```sql
SELECT a.*
FROM table_a a
WHERE NOT EXISTS (
    SELECT 1 FROM table_b b WHERE b.key = a.key
);
```

### Method 3: NOT IN (⚠️ dangerous with NULLs)
```sql
SELECT * FROM table_a
WHERE key NOT IN (SELECT key FROM table_b);
-- If table_b.key has ANY NULL, this returns 0 rows — silent bug!
```

**Rule:** Prefer `LEFT JOIN WHERE NULL` or `NOT EXISTS`. Never use `NOT IN` on a column that might have NULLs.

---

## 8. Multi-Table Joins

Chaining multiple joins. The query optimizer builds a join tree — order matters for performance.

```sql
-- Full purchase trail: 6 tables
SELECT
    c.name,
    o.order_date,
    p.product_name,
    cat.category_name,
    s.seller_name,
    oi.quantity,
    oi.unit_price
FROM customers c
JOIN orders o        ON c.customer_id  = o.customer_id
JOIN order_items oi  ON o.order_id     = oi.order_id
JOIN products p      ON oi.product_id  = p.product_id
JOIN categories cat  ON p.category_id  = cat.category_id
JOIN sellers s       ON p.seller_id    = s.seller_id;
```

**Performance tip:** Filter early. Apply WHERE on large tables before the join engine processes them.

---

## 9. Join Performance Rules

| Rule | Reason |
|---|---|
| Index the join column on the larger table | Turns O(n²) nested loop into O(n log n) |
| Filter before joining (WHERE or subquery) | Reduces rows entering the join |
| Put the smaller table on the left in INNER JOIN | Some engines use left table as the probe side |
| Avoid functions on join columns | `ON YEAR(a.date) = YEAR(b.date)` kills index usage |
| Use EXPLAIN / EXPLAIN ANALYZE | Verify the planner is using your index |

---

## 10. System-Specific Notes

| System | Notes |
|---|---|
| **PostgreSQL** | Hash join, merge join, nested loop — optimizer chooses. Use `EXPLAIN ANALYZE` to see which. |
| **Spark SQL** | Broadcast join for small tables (`BROADCAST(small_table)` hint). Large joins → shuffle join. |
| **BigQuery** | Broadcast join automatic for tables < 1GB. Avoid joining two large tables without filters. |
| **Snowflake** | Micro-partition pruning reduces scan. Cluster keys help range joins on dates. |
| **Redshift** | Distribution key matters — co-locate joined tables on the same node to avoid redistribution. |

---

## 11. Join Type Decision Tree

```
Do you want rows from BOTH tables (matched only)?
  └── YES → INNER JOIN

Do you want ALL rows from one side + matches from other?
  ├── Keep ALL from left side → LEFT JOIN
  └── Keep ALL from right side → RIGHT JOIN (or swap + LEFT JOIN)

Do you want ALL rows from BOTH sides?
  └── FULL OUTER JOIN

Are rows in the same table related to each other?
  └── SELF JOIN

Do you want every possible combination?
  └── CROSS JOIN

Do you want rows in A that DON'T exist in B?
  └── Anti-join (LEFT JOIN WHERE NULL / NOT EXISTS)
```

---

## 12. Interview Questions

**Q1. What is the difference between INNER JOIN and LEFT JOIN?**
INNER JOIN returns only rows where there is a match on both sides. LEFT JOIN returns all rows from the left table — if there's no match on the right side, those columns are NULL.

**Q2. When would you use FULL OUTER JOIN in a data pipeline?**
When reconciling two data sources — for example, comparing records from a source database against a warehouse to find rows that exist in one but not the other. Common in data quality checks and pipeline validation.

**Q3. What's the problem with NOT IN when the subquery column has NULLs?**
SQL uses three-valued logic (TRUE, FALSE, UNKNOWN). `value NOT IN (1, 2, NULL)` evaluates as UNKNOWN for any value — returning 0 rows silently. Always use NOT EXISTS or LEFT JOIN WHERE NULL instead.

**Q4. How does a SELF JOIN work? Give a real example.**
A table is aliased twice and joined to itself. Example: finding all pairs of customers from the same city — `JOIN customers b ON a.city = b.city AND a.customer_id < b.customer_id`.

**Q5. What is a Cartesian product and when is CROSS JOIN dangerous?**
Every row in table A is paired with every row in table B. Dangerous when both tables are large — 1M rows × 1M rows = 1 trillion row output. Use only for intentional combination generation.

**Q6. What is the difference between LEFT JOIN and LEFT ANTI JOIN?**
LEFT JOIN returns all left rows (matched + unmatched). Left anti-join (LEFT JOIN WHERE right_key IS NULL) returns only unmatched left rows — rows in A with no corresponding row in B.

**Q7. In a DE context, when would you use a CROSS JOIN?**
Creating a date spine — CROSS JOIN a calendar table with a list of metrics or dimensions to ensure every date × metric combination exists in the output, even if there's no data for that day.

**Q8. How do you optimize a slow join query?**
Check EXPLAIN output for sequential scans on join columns → add an index. Filter rows before the join using a subquery or CTE. For distributed engines, ensure the join key is the distribution key to avoid data shuffle.

**Q9. Can you join on multiple columns?**
Yes: `ON a.order_id = b.order_id AND a.product_id = b.product_id`. Composite indexes on both columns improve performance in this case.

**Q10. Why do most engineers prefer LEFT JOIN over RIGHT JOIN?**
Readability. The "primary" or "driving" table is always on the left — easier to reason about which table preserves all rows. RIGHT JOIN is logically equivalent to swapping table positions and using LEFT JOIN.

---

## My Implementation
→ See companion file: [`joins.sql`](./joins.sql)
→ Schema used: TechMart — run [`00_techmart_setup.sql`](./00_techmart_setup.sql) first
→ Projects using this: [InternIQ](https://github.com/RenoX23/interniq-multiagent-analyst) — multi-table joins across jobs, skills, companies
