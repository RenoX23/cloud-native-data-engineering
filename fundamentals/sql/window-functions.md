# Window Functions

## Core Concept

A window function performs a calculation across a **set of rows related to the current row** — without collapsing those rows into a single output like `GROUP BY` does. Every input row keeps its identity in the result; the function just adds an extra computed column alongside it.

---

## Anatomy of a Window Function

```sql
function_name(expression)
OVER (
    PARTITION BY column(s)   -- defines the "window" (group boundary)
    ORDER BY column(s)       -- defines row order within the window
    frame_clause             -- optional: how many rows to include
)
```

| Clause | Purpose | Optional? |
|---|---|---|
| `PARTITION BY` | Resets the function for each group | Yes |
| `ORDER BY` | Determines row sequence inside the partition | Depends on function |
| Frame clause | Defines row range relative to current row | Yes |

> If you omit `PARTITION BY`, the entire result set is one window.
> If you omit `ORDER BY`, the frame is unbounded (all rows in partition).

---

## 1. Ranking Functions

### ROW_NUMBER()
Assigns a **unique sequential integer** to each row. No ties — duplicate values still get different numbers.

```sql
ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY total_sales DESC)
```

**Use when:** You want exactly 1 record per group (deduplication, top-1 per partition).

---

### RANK()
Assigns rank with **gaps** after ties. Two rows tied at rank 2 → next rank is 4.

```sql
RANK() OVER (PARTITION BY region ORDER BY revenue DESC)
```

**Use when:** You want to reflect true competition ranking (like leaderboards).

---

### DENSE_RANK()
Assigns rank **without gaps** after ties. Two rows tied at rank 2 → next rank is 3.

```sql
DENSE_RANK() OVER (ORDER BY salary DESC)
```

**Use when:** You want top-N filtering without skipping ranks (e.g., "top 3 salary bands").

---

### Key Difference — The Tie Scenario

| Employee | Salary | ROW_NUMBER | RANK | DENSE_RANK |
|---|---|---|---|---|
| A | 90000 | 1 | 1 | 1 |
| B | 75000 | 2 | 2 | 2 |
| C | 75000 | 3 | 2 | 2 |
| D | 60000 | 4 | 4 | 3 |

---

## 2. Offset Functions

### LAG(col, offset, default)
Returns value from **N rows before** the current row.

```sql
LAG(order_total, 1, 0) OVER (PARTITION BY customer_id ORDER BY order_date)
```

**Use when:** Day-over-day comparison, detecting previous state, churn detection.

---

### LEAD(col, offset, default)
Returns value from **N rows after** the current row.

```sql
LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date)
```

**Use when:** Next event prediction, time-to-next-purchase, session end detection.

---

### FIRST_VALUE(col) / LAST_VALUE(col)
Returns first or last value in the window frame.

```sql
FIRST_VALUE(price) OVER (PARTITION BY product_id ORDER BY order_date)
```

> ⚠️ `LAST_VALUE` requires explicit frame clause — default frame stops at current row, not partition end.

```sql
-- Correct LAST_VALUE usage
LAST_VALUE(price) OVER (
    PARTITION BY product_id
    ORDER BY order_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
```

---

## 3. Aggregate Window Functions

Standard aggregates become window functions when paired with `OVER()`. Unlike `GROUP BY`, they don't collapse rows.

```sql
-- Running total
SUM(order_total) OVER (PARTITION BY customer_id ORDER BY order_date)

-- Running average (moving average)
AVG(daily_sales) OVER (ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)

-- Count of orders so far
COUNT(order_id) OVER (PARTITION BY customer_id ORDER BY order_date)

-- Max in partition (same for all rows in group)
MAX(salary) OVER (PARTITION BY department_id)
```

---

## 4. Frame Clauses

Defines which rows relative to the current row are included in the calculation.

```
ROWS BETWEEN <start> AND <end>
RANGE BETWEEN <start> AND <end>
```

**Boundary keywords:**

| Keyword | Meaning |
|---|---|
| `UNBOUNDED PRECEDING` | First row of the partition |
| `N PRECEDING` | N rows before current row |
| `CURRENT ROW` | Current row only |
| `N FOLLOWING` | N rows after current row |
| `UNBOUNDED FOLLOWING` | Last row of the partition |

### ROWS vs RANGE

| | ROWS | RANGE |
|---|---|---|
| Operates on | Physical rows | Logical value range |
| Tie handling | Each row independently | Rows with same ORDER BY value treated as a group |
| Default behavior | Precise | Can include unexpected rows on ties |

**Default frame (when ORDER BY is present):** `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`

---

## 5. Common DE Patterns

### Pattern 1: Top-N Per Group (Deduplication)
```sql
-- Get top 2 products by sales per category
WITH ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY total_sold DESC) AS rn
    FROM products
)
SELECT * FROM ranked WHERE rn <= 2;
```

### Pattern 2: Running Total
```sql
SUM(revenue) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
```

### Pattern 3: 7-Day Moving Average
```sql
AVG(daily_sales) OVER (ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
```

### Pattern 4: Month-over-Month Growth %
```sql
ROUND(
    (revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0
    / NULLIF(LAG(revenue) OVER (ORDER BY month), 0),
2) AS mom_growth_pct
```

### Pattern 5: Sessionization / Time Between Events
```sql
EXTRACT(EPOCH FROM (
    order_date - LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)
)) / 86400 AS days_since_last_order
```

---

## 6. System-Specific Behavior

| System | Notes |
|---|---|
| **PostgreSQL** | Full support. `FILTER` clause works with window functions. `ROWS` is default over `RANGE` when tied values exist. |
| **Spark SQL** | Full support. Use `ROWS BETWEEN` for performance — `RANGE` triggers shuffle. |
| **BigQuery** | Full support. Use `QUALIFY` clause to filter on window function results (no subquery needed). |
| **Snowflake** | Full support. `QUALIFY` available. `RATIO_TO_REPORT()` is a Snowflake-specific window function. |
| **Redshift** | Limited frame support. Avoid `RANGE` with large datasets — prefer `ROWS`. `MEDIAN` not a window function. |

---

## 7. Window vs GROUP BY — When to Use Which

| Situation | Use |
|---|---|
| Need aggregate + original rows together | Window function |
| Need only summarized output | GROUP BY |
| Ranking within a group | Window function |
| Comparing current row to previous | Window function (LAG/LEAD) |
| Calculating subtotals + grand totals | GROUP BY + ROLLUP |

---

## 8. Interview Questions

**Q1. What's the difference between ROW_NUMBER, RANK, and DENSE_RANK?**
ROW_NUMBER always gives unique sequential numbers with no ties. RANK gives the same rank to ties but skips subsequent ranks (gaps). DENSE_RANK gives the same rank to ties but does not skip ranks.

**Q2. Can you use a window function in a WHERE clause?**
No. Window functions are evaluated after WHERE. To filter on window function results, wrap in a CTE or subquery first, then filter in the outer query.

**Q3. What does PARTITION BY do? Is it the same as GROUP BY?**
PARTITION BY divides rows into logical groups for the window function but doesn't collapse them — all rows are returned. GROUP BY collapses rows into one row per group.

**Q4. What is the default frame when ORDER BY is present?**
`RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` — includes all rows from partition start to current row, treating ties as a group.

**Q5. How would you get the second highest salary per department?**
Use `DENSE_RANK()` partitioned by department, ordered by salary descending, then filter where rank = 2 in an outer query/CTE.

**Q6. What's the difference between ROWS and RANGE in frame clauses?**
ROWS operates on physical row positions — precise. RANGE operates on logical value ranges — rows with the same ORDER BY value are treated as a group. RANGE can give unexpected results when there are ties.

**Q7. How would you calculate a 7-day moving average?**
```sql
AVG(sales) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
```

**Q8. Why does LAST_VALUE sometimes give unexpected results?**
Because the default frame is `RANGE UNBOUNDED PRECEDING TO CURRENT ROW`, so LAST_VALUE returns the current row's value, not the partition's last. Fix with `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`.

**Q9. How is LAG useful in a data pipeline context?**
LAG is used to detect previous state — finding customers who churned (last order > 90 days ago), computing day-over-day metric changes, flagging status transitions (e.g., order went from pending to cancelled).

**Q10. Can window functions be used in UPDATE or DELETE?**
Not directly in the SET or WHERE clause. Use a CTE or subquery to compute the window result first, then reference it in the UPDATE/DELETE.

---

## My Implementation
→ See companion file: [`window-functions.sql`](./window-functions.sql)
→ Schema used: TechMart (Indian e-commerce — customers, orders, order_items, products, categories)
→ Projects using this: [InternIQ](https://github.com/RenoX23/interniq-multiagent-analyst) — SQL Agent uses window functions for ranking and trend analysis
