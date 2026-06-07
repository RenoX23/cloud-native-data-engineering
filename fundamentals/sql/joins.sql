-- ============================================================
-- joins.sql
-- Schema: TechMart — run 00_techmart_setup.sql first
-- psql -U postgres -d techmart -f joins.sql
-- ============================================================


-- ============================================================
-- SECTION 1: INNER JOIN
-- Returns only rows with a match in BOTH tables
-- ============================================================

-- 1a. Customers and their orders (excludes customers with no orders)
-- Expected: 17 distinct customers (Siddharth, Divya, Manish excluded)
SELECT
    c.customer_id,
    c.name,
    c.city,
    o.order_id,
    o.order_date,
    o.status,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;


-- 1b. Full purchase trail: customer → order → item → product → category → seller
-- The most common multi-table join in analytics
SELECT
    c.name                              AS customer_name,
    c.city,
    o.order_date,
    o.status,
    p.product_name,
    cat.category_name,
    s.seller_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price)       AS line_total
FROM customers c
JOIN orders o       ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
JOIN sellers s      ON p.seller_id   = s.seller_id
ORDER BY o.order_date, c.name;


-- 1c. Top 5 customers by total spend (INNER JOIN + GROUP BY)
SELECT
    c.customer_id,
    c.name,
    c.city,
    COUNT(DISTINCT o.order_id)  AS total_orders,
    SUM(o.total_amount)         AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_spend DESC
LIMIT 5;


-- 1d. Revenue by category (3-table join + aggregation)
SELECT
    cat.category_name,
    COUNT(DISTINCT o.order_id)          AS total_orders,
    SUM(oi.quantity)                    AS units_sold,
    SUM(oi.quantity * oi.unit_price)    AS total_revenue,
    ROUND(AVG(oi.unit_price), 2)        AS avg_unit_price
FROM categories cat
JOIN products p      ON cat.category_id = p.category_id
JOIN order_items oi  ON p.product_id    = oi.product_id
JOIN orders o        ON oi.order_id     = o.order_id
GROUP BY cat.category_name
ORDER BY total_revenue DESC;


-- ============================================================
-- SECTION 2: LEFT JOIN
-- All rows from left table + matched rows from right (NULL if no match)
-- ============================================================

-- 2a. ALL customers including those with no orders
-- Expected: 20 rows — Siddharth(18), Divya(19), Manish(20) have NULL order columns
SELECT
    c.customer_id,
    c.name,
    c.city,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;


-- 2b. Count orders per customer — show 0 for customers with no orders
-- COALESCE handles NULL (no orders → show 0, not NULL)
SELECT
    c.customer_id,
    c.name,
    c.city,
    COUNT(o.order_id)           AS order_count,
    COALESCE(SUM(o.total_amount), 0) AS total_spend
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY order_count DESC;


-- 2c. ALL products with their total sales (NULL for unsold products)
-- Expected: Smart Watch and Gaming Headset appear with NULL/0 sales
SELECT
    p.product_id,
    p.product_name,
    cat.category_name,
    p.price                             AS list_price,
    COALESCE(SUM(oi.quantity), 0)       AS total_units_sold,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN categories cat ON p.category_id = cat.category_id
GROUP BY p.product_id, p.product_name, cat.category_name, p.price
ORDER BY total_revenue DESC;


-- 2d. Customer engagement report — last order date per customer
-- NULL last_order_date means they've never ordered
SELECT
    c.customer_id,
    c.name,
    c.registration_date,
    MAX(o.order_date)   AS last_order_date,
    CASE
        WHEN MAX(o.order_date) IS NULL THEN 'Never Ordered'
        WHEN MAX(o.order_date) < CURRENT_DATE - INTERVAL '90 days' THEN 'Churned'
        ELSE 'Active'
    END AS customer_status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.registration_date
ORDER BY last_order_date DESC NULLS LAST;


-- ============================================================
-- SECTION 3: RIGHT JOIN
-- All rows from right table + matched from left (NULL if no match)
-- ============================================================

-- 3a. All products even if no one ordered them (RIGHT preserves products)
-- Expected: Smart Watch(4) and Gaming Headset(5) appear with NULL order columns
SELECT
    oi.order_item_id,
    oi.order_id,
    p.product_id,
    p.product_name,
    p.price,
    oi.quantity,
    oi.unit_price
FROM order_items oi
RIGHT JOIN products p ON oi.product_id = p.product_id
ORDER BY p.product_id;

-- NOTE: This is equivalent to the LEFT JOIN version (just swapped):
-- SELECT ... FROM products p LEFT JOIN order_items oi ON ...
-- Prefer LEFT JOIN for consistency and readability.


-- ============================================================
-- SECTION 4: FULL OUTER JOIN
-- All rows from BOTH tables; NULLs where no match
-- ============================================================

-- 4a. Reconcile customers vs orders — spot orphaned orders or inactive customers
-- Orphaned order = order with no matching customer (data quality issue)
-- Inactive customer = customer with no orders
SELECT
    c.customer_id,
    c.name,
    o.order_id,
    o.total_amount,
    CASE
        WHEN c.customer_id IS NULL THEN 'Orphaned Order'
        WHEN o.order_id    IS NULL THEN 'No Orders'
        ELSE 'Matched'
    END AS reconciliation_status
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id
ORDER BY reconciliation_status, c.customer_id;


-- 4b. Pipeline validation: compare two revenue snapshots
-- Real DE use case: did staging and warehouse totals match after load?
WITH staging_revenue AS (
    -- Simulates source system totals
    SELECT customer_id, SUM(total_amount) AS revenue
    FROM orders
    WHERE status = 'delivered'
    GROUP BY customer_id
),
warehouse_revenue AS (
    -- Simulates warehouse totals (using all statuses for mismatch demo)
    SELECT customer_id, SUM(total_amount) AS revenue
    FROM orders
    GROUP BY customer_id
)
SELECT
    COALESCE(s.customer_id, w.customer_id) AS customer_id,
    s.revenue   AS staging_revenue,
    w.revenue   AS warehouse_revenue,
    CASE
        WHEN s.customer_id IS NULL THEN 'Missing in Staging'
        WHEN w.customer_id IS NULL THEN 'Missing in Warehouse'
        WHEN s.revenue <> w.revenue THEN 'Revenue Mismatch'
        ELSE 'Match'
    END AS status
FROM staging_revenue s
FULL OUTER JOIN warehouse_revenue w ON s.customer_id = w.customer_id
WHERE s.revenue IS DISTINCT FROM w.revenue   -- only show discrepancies
ORDER BY status;


-- ============================================================
-- SECTION 5: CROSS JOIN
-- Cartesian product — every row × every row
-- ============================================================

-- 5a. Customer × Category interest matrix
-- Use case: initialise a recommendation system with all possible combinations
-- Result: 20 customers × 6 categories = 120 rows
SELECT
    c.customer_id,
    c.name,
    cat.category_id,
    cat.category_name
FROM customers c
CROSS JOIN categories cat
ORDER BY c.customer_id, cat.category_id;


-- 5b. Generate a date spine (all dates in 2024) × category
-- Real DE pattern: ensures every date shows in a report even with no sales
WITH date_spine AS (
    SELECT generate_series(
        '2024-01-01'::DATE,
        '2024-12-31'::DATE,
        INTERVAL '1 day'
    )::DATE AS report_date
)
SELECT
    ds.report_date,
    cat.category_name,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS daily_revenue
FROM date_spine ds
CROSS JOIN categories cat
LEFT JOIN orders o       ON o.order_date  = ds.report_date
LEFT JOIN order_items oi ON oi.order_id   = o.order_id
LEFT JOIN products p     ON oi.product_id = p.product_id
                        AND p.category_id = cat.category_id
GROUP BY ds.report_date, cat.category_name
ORDER BY ds.report_date, cat.category_name
LIMIT 30;  -- limit for demo; remove for full year


-- ============================================================
-- SECTION 6: SELF JOIN
-- A table joined to itself
-- ============================================================

-- 6a. Find all pairs of customers from the same city
-- AND a.customer_id < b.customer_id prevents (A,B) and (B,A) duplicates
SELECT
    a.customer_id   AS customer_1_id,
    a.name          AS customer_1,
    b.customer_id   AS customer_2_id,
    b.name          AS customer_2,
    a.city
FROM customers a
JOIN customers b
    ON  a.city = b.city
    AND a.customer_id < b.customer_id
ORDER BY a.city, a.customer_id;
-- Expected: Bangalore (Arjun-Sneha, Arjun-Meera, Arjun-Manish, Sneha-Meera,
--           Sneha-Manish, Meera-Manish), Mumbai (Anjali-Aditya),
--           Pune (Rohit-Suresh), Chennai (Priya-Kavitha-Divya), etc.


-- 6b. Find customers who ordered within 30 days of a previous order
-- (repeat purchase detection without using LAG)
SELECT
    a.customer_id,
    a.order_id      AS first_order,
    a.order_date    AS first_order_date,
    b.order_id      AS next_order,
    b.order_date    AS next_order_date,
    (b.order_date - a.order_date) AS days_between
FROM orders a
JOIN orders b
    ON  a.customer_id = b.customer_id
    AND b.order_date > a.order_date
    AND b.order_date <= a.order_date + INTERVAL '90 days'
ORDER BY a.customer_id, a.order_date;


-- ============================================================
-- SECTION 7: ANTI-JOIN
-- Rows in A with NO match in B
-- ============================================================

-- 7a. Customers who have NEVER placed an order
-- Method 1: LEFT JOIN WHERE NULL (preferred)
SELECT
    c.customer_id,
    c.name,
    c.city,
    c.registration_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
-- Expected: Siddharth(18), Divya(19), Manish(20)


-- 7b. Same query — Method 2: NOT EXISTS
SELECT
    c.customer_id,
    c.name,
    c.city,
    c.registration_date
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);


-- 7c. Products that have NEVER been sold
SELECT
    p.product_id,
    p.product_name,
    p.price,
    cat.category_name
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;
-- Expected: Smart Watch(4), Gaming Headset(5)


-- 7d. Customers who ordered Electronics but NEVER bought Books
-- Anti-join on a filtered subset
WITH electronics_buyers AS (
    SELECT DISTINCT o.customer_id
    FROM orders o
    JOIN order_items oi ON o.order_id    = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    JOIN categories cat ON p.category_id = cat.category_id
    WHERE cat.category_name = 'Electronics'
),
book_buyers AS (
    SELECT DISTINCT o.customer_id
    FROM orders o
    JOIN order_items oi ON o.order_id    = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    JOIN categories cat ON p.category_id = cat.category_id
    WHERE cat.category_name = 'Books'
)
SELECT
    c.customer_id,
    c.name,
    c.city
FROM customers c
JOIN electronics_buyers eb ON c.customer_id = eb.customer_id
LEFT JOIN book_buyers bb   ON c.customer_id = bb.customer_id
WHERE bb.customer_id IS NULL;


-- ============================================================
-- SECTION 8: REAL DE PATTERNS
-- ============================================================

-- 8a. Slowly Changing Dimension (SCD) lookup join
-- Real DE pattern: join fact table to dimension with date range validity
-- Simulated: orders joined to seller "version" within order date window
-- (TechMart doesn't have SCD, so we simulate the pattern)
SELECT
    o.order_id,
    o.order_date,
    p.product_name,
    s.seller_name,
    s.rating            AS seller_rating_at_sale
FROM orders o
JOIN order_items oi ON o.order_id    = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
JOIN sellers s      ON p.seller_id   = s.seller_id
-- In real SCD: AND o.order_date BETWEEN s.valid_from AND s.valid_to
ORDER BY o.order_date;


-- 8b. Deduplication via JOIN (pipeline pattern)
-- Identify duplicate order entries (same customer, same date, same amount)
SELECT
    a.order_id      AS order_a,
    b.order_id      AS order_b,
    a.customer_id,
    a.order_date,
    a.total_amount
FROM orders a
JOIN orders b
    ON  a.customer_id  = b.customer_id
    AND a.order_date   = b.order_date
    AND a.total_amount = b.total_amount
    AND a.order_id     < b.order_id   -- prevent mirror duplicates
ORDER BY a.customer_id;


-- 8c. Category-level performance with seller info (5-table join)
SELECT
    cat.category_name,
    s.seller_name,
    s.rating                                AS seller_rating,
    COUNT(DISTINCT o.order_id)              AS total_orders,
    SUM(oi.quantity)                        AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM categories cat
JOIN products p      ON cat.category_id = p.category_id
JOIN sellers s       ON p.seller_id     = s.seller_id
JOIN order_items oi  ON p.product_id    = oi.product_id
JOIN orders o        ON oi.order_id     = o.order_id
WHERE o.status = 'delivered'
GROUP BY cat.category_name, s.seller_name, s.rating
ORDER BY revenue DESC;


-- 8d. Month-over-month active customers (join + window)
WITH monthly_actives AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        COUNT(DISTINCT customer_id)     AS active_customers
    FROM orders
    GROUP BY 1
)
SELECT
    month,
    active_customers,
    LAG(active_customers) OVER (ORDER BY month) AS prev_month,
    active_customers - LAG(active_customers) OVER (ORDER BY month) AS mom_change
FROM monthly_actives
ORDER BY month;
