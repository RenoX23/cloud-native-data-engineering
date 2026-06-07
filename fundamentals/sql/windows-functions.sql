-- ============================================================
-- window-functions.sql
-- Schema: TechMart (Indian e-commerce)
-- Purpose: Practical window function queries for DE interview prep
-- ============================================================

-- SCHEMA REFERENCE
-- customers   (customer_id, name, city, state, registration_date)
-- orders      (order_id, customer_id, order_date, status, total_amount)
-- order_items (order_item_id, order_id, product_id, quantity, unit_price)
-- products    (product_id, product_name, category_id, price, seller_id)
-- categories  (category_id, category_name)
-- sellers     (seller_id, seller_name, city, rating)


-- ============================================================
-- SECTION 1: RANKING FUNCTIONS
-- ============================================================

-- 1a. ROW_NUMBER — Deduplicate: keep latest order per customer
WITH latest_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        total_amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS rn
    FROM orders
)
SELECT customer_id, order_id, order_date, total_amount
FROM latest_orders
WHERE rn = 1;


-- 1b. RANK vs DENSE_RANK — Top customers by total spend
-- Observe the gap in RANK vs no gap in DENSE_RANK
SELECT
    customer_id,
    SUM(total_amount) AS total_spend,
    RANK()       OVER (ORDER BY SUM(total_amount) DESC) AS rank_with_gap,
    DENSE_RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rank_no_gap
FROM orders
GROUP BY customer_id
ORDER BY total_spend DESC;


-- 1c. Top 3 products by revenue per category
WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        c.category_name,
        SUM(oi.quantity * oi.unit_price) AS revenue,
        DENSE_RANK() OVER (
            PARTITION BY p.category_id
            ORDER BY SUM(oi.quantity * oi.unit_price) DESC
        ) AS category_rank
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    GROUP BY p.product_id, p.product_name, p.category_id, c.category_name
)
SELECT product_id, product_name, category_name, revenue, category_rank
FROM product_revenue
WHERE category_rank <= 3
ORDER BY category_name, category_rank;


-- ============================================================
-- SECTION 2: OFFSET FUNCTIONS (LAG / LEAD)
-- ============================================================

-- 2a. LAG — Month-over-month revenue comparison
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(total_amount)               AS revenue
    FROM orders
    GROUP BY 1
)
SELECT
    month,
    revenue,
    LAG(revenue, 1, 0) OVER (ORDER BY month)  AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0),
    2)                                          AS mom_growth_pct
FROM monthly_revenue
ORDER BY month;


-- 2b. LEAD — Days until a customer's next order (purchase frequency)
SELECT
    customer_id,
    order_id,
    order_date,
    LEAD(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS next_order_date,
    LEAD(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) - order_date AS days_to_next_order
FROM orders
ORDER BY customer_id, order_date;


-- 2c. LAG — Detect customers whose spend dropped vs previous order
SELECT
    customer_id,
    order_id,
    order_date,
    total_amount                                                      AS current_order,
    LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order,
    CASE
        WHEN total_amount < LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date)
        THEN 'SPEND_DROPPED'
        ELSE 'STABLE_OR_INCREASED'
    END AS spend_trend
FROM orders
ORDER BY customer_id, order_date;


-- 2d. FIRST_VALUE / LAST_VALUE — First and last purchase amount per customer
SELECT
    customer_id,
    order_id,
    order_date,
    total_amount,
    FIRST_VALUE(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_order_amount,
    LAST_VALUE(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING  -- explicit frame required
    ) AS last_order_amount
FROM orders
ORDER BY customer_id, order_date;


-- ============================================================
-- SECTION 3: AGGREGATE WINDOW FUNCTIONS
-- ============================================================

-- 3a. Running total of revenue (cumulative sum)
SELECT
    order_date,
    order_id,
    total_amount,
    SUM(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM orders
ORDER BY order_date;


-- 3b. Running total per customer (resets per customer)
SELECT
    customer_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS customer_cumulative_spend
FROM orders
ORDER BY customer_id, order_date;


-- 3c. 7-day moving average of daily sales
WITH daily_sales AS (
    SELECT
        order_date::DATE AS sale_date,
        SUM(total_amount) AS daily_revenue
    FROM orders
    GROUP BY 1
)
SELECT
    sale_date,
    daily_revenue,
    ROUND(
        AVG(daily_revenue) OVER (
            ORDER BY sale_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg_7d
FROM daily_sales
ORDER BY sale_date;


-- 3d. Each order's % contribution to customer's total spend
SELECT
    customer_id,
    order_id,
    total_amount,
    SUM(total_amount) OVER (PARTITION BY customer_id) AS customer_total,
    ROUND(
        total_amount * 100.0
        / SUM(total_amount) OVER (PARTITION BY customer_id),
    2) AS pct_of_customer_spend
FROM orders
ORDER BY customer_id, total_amount DESC;


-- 3e. Seller rating percentile ranking
SELECT
    seller_id,
    seller_name,
    rating,
    ROUND(
        PERCENT_RANK() OVER (ORDER BY rating) * 100, 2
    ) AS percentile_rank,
    NTILE(4) OVER (ORDER BY rating) AS quartile  -- 1=bottom, 4=top
FROM sellers
ORDER BY rating DESC;


-- ============================================================
-- SECTION 4: FRAME CLAUSE DEMONSTRATION
-- ============================================================

-- 4a. ROWS vs RANGE — Spot the difference with tied dates
-- When multiple orders share the same date:
-- ROWS CURRENT ROW: only the current physical row
-- RANGE CURRENT ROW: all rows with the same ORDER BY value

WITH tied_dates AS (
    SELECT
        order_date::DATE AS sale_date,
        total_amount
    FROM orders
    WHERE order_date::DATE = '2024-01-15'  -- replace with a date with multiple orders
)
SELECT
    sale_date,
    total_amount,
    SUM(total_amount) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  AS rows_running_total,
    SUM(total_amount) OVER (ORDER BY sale_date RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS range_running_total
FROM tied_dates;


-- 4b. Bounded frame: 3-order moving average per customer
SELECT
    customer_id,
    order_date,
    total_amount,
    ROUND(
        AVG(total_amount) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW  -- current + 2 before = 3 rows
        ), 2
    ) AS moving_avg_3_orders
FROM orders
ORDER BY customer_id, order_date;


-- ============================================================
-- SECTION 5: DE REAL-WORLD PATTERNS
-- ============================================================

-- 5a. Sessionization — Flag new sessions (gap > 30 min between events)
-- (adapted to orders: new "session" if gap > 7 days from last order)
SELECT
    customer_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date,
    CASE
        WHEN order_date - LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) > 7
          OR LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) IS NULL
        THEN 1 ELSE 0
    END AS is_new_session
FROM orders
ORDER BY customer_id, order_date;


-- 5b. Customer lifetime value cohort — spend per acquisition month
SELECT
    DATE_TRUNC('month', c.registration_date) AS cohort_month,
    DATE_TRUNC('month', o.order_date)         AS order_month,
    COUNT(DISTINCT o.customer_id)             AS active_customers,
    SUM(o.total_amount)                       AS cohort_revenue,
    SUM(SUM(o.total_amount)) OVER (
        PARTITION BY DATE_TRUNC('month', c.registration_date)
        ORDER BY DATE_TRUNC('month', o.order_date)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_cohort_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY 1, 2
ORDER BY 1, 2;


-- 5c. Pipeline use case — Deduplicate duplicate ingestion events
-- Real DE scenario: source system sends duplicate records, keep latest by updated_at
WITH deduped AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY order_id          -- natural key
            ORDER BY order_date DESC       -- keep the latest version
        ) AS rn
    FROM orders  -- imagine this is a raw/staging table with dupes
)
SELECT * FROM deduped WHERE rn = 1;


-- 5d. Year-over-year comparison at product level
WITH yearly_product_revenue AS (
    SELECT
        EXTRACT(YEAR FROM o.order_date)       AS year,
        p.product_id,
        p.product_name,
        SUM(oi.quantity * oi.unit_price)      AS revenue
    FROM order_items oi
    JOIN orders o   ON oi.order_id   = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY 1, 2, 3
)
SELECT
    year,
    product_id,
    product_name,
    revenue,
    LAG(revenue) OVER (PARTITION BY product_id ORDER BY year) AS prev_year_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (PARTITION BY product_id ORDER BY year)) * 100.0
        / NULLIF(LAG(revenue) OVER (PARTITION BY product_id ORDER BY year), 0),
    2) AS yoy_growth_pct
FROM yearly_product_revenue
ORDER BY product_id, year;
