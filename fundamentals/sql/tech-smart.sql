-- ============================================================
-- 00_techmart_setup.sql
-- TechMart — Indian E-commerce Study Database
-- Schema + Seed Data for SQL Interview Prep
-- ============================================================
-- HOW TO RUN:
--   1. Open Git Bash / terminal
--   2. psql -U postgres -d postgres -f 00_techmart_setup.sql
--   OR connect first: psql -U postgres
--      then: \i /d/Project/cloud-native-data-engineering/fundamentals/sql/00_techmart_setup.sql
-- ============================================================

-- Create and connect to database
DROP DATABASE IF EXISTS techmart;
CREATE DATABASE techmart;
\c techmart

-- ============================================================
-- DROP TABLES (clean slate on re-run)
-- ============================================================
DROP TABLE IF EXISTS order_items  CASCADE;
DROP TABLE IF EXISTS orders       CASCADE;
DROP TABLE IF EXISTS products     CASCADE;
DROP TABLE IF EXISTS sellers      CASCADE;
DROP TABLE IF EXISTS customers    CASCADE;
DROP TABLE IF EXISTS categories   CASCADE;

-- ============================================================
-- CREATE TABLES
-- ============================================================

CREATE TABLE categories (
    category_id   INTEGER PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE sellers (
    seller_id   INTEGER PRIMARY KEY,
    seller_name VARCHAR(100) NOT NULL,
    city        VARCHAR(50),
    rating      NUMERIC(3,2)
);

CREATE TABLE customers (
    customer_id       INTEGER PRIMARY KEY,
    name              VARCHAR(100) NOT NULL,
    email             VARCHAR(100) UNIQUE,
    city              VARCHAR(50),
    state             VARCHAR(50),
    registration_date DATE
);

CREATE TABLE products (
    product_id   INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id  INTEGER REFERENCES categories(category_id),
    seller_id    INTEGER REFERENCES sellers(seller_id),
    price        NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id     INTEGER PRIMARY KEY,
    customer_id  INTEGER REFERENCES customers(customer_id),
    order_date   DATE NOT NULL,
    status       VARCHAR(20) CHECK (status IN ('delivered','shipped','pending','cancelled','returned')),
    total_amount NUMERIC(10,2)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id      INTEGER REFERENCES orders(order_id),
    product_id    INTEGER REFERENCES products(product_id),
    quantity      INTEGER NOT NULL,
    unit_price    NUMERIC(10,2) NOT NULL
);

-- ============================================================
-- INDEXES (for query performance + indexing.md study)
-- ============================================================
CREATE INDEX idx_orders_customer_id  ON orders(customer_id);
CREATE INDEX idx_orders_order_date   ON orders(order_date);
CREATE INDEX idx_order_items_order   ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_products_category   ON products(category_id);

-- ============================================================
-- SEED DATA
-- ============================================================

-- CATEGORIES (6)
INSERT INTO categories VALUES
    (1, 'Electronics'),
    (2, 'Fashion'),
    (3, 'Home & Kitchen'),
    (4, 'Books'),
    (5, 'Sports & Fitness'),
    (6, 'Beauty & Personal Care');

-- SELLERS (6)
INSERT INTO sellers VALUES
    (1, 'TechWorld',       'Bangalore', 4.5),
    (2, 'FashionHub',      'Mumbai',    4.2),
    (3, 'HomeEssentials',  'Delhi',     4.7),
    (4, 'BookStore India', 'Chennai',   4.8),
    (5, 'SportZone',       'Hyderabad', 4.3),
    (6, 'BeautyMart',      'Pune',      4.1);

-- PRODUCTS (20)
-- NOTE: Products 4 (Smart Watch) and 5 (Gaming Headset) have NO orders
--       Used for RIGHT JOIN / anti-join demos
INSERT INTO products VALUES
    (1,  'Wireless Earbuds',                    1, 1, 2499.00),
    (2,  'USB-C Hub',                           1, 1, 1299.00),
    (3,  'Mechanical Keyboard',                 1, 1, 3999.00),
    (4,  'Smart Watch',                         1, 1, 8999.00),  -- NO ORDERS
    (5,  'Gaming Headset',                      1, 1, 4999.00),  -- NO ORDERS
    (6,  'Mens Formal Shirt',                   2, 2,  799.00),
    (7,  'Womens Kurta',                        2, 2,  599.00),
    (8,  'Running Shoes',                       2, 2, 1499.00),
    (9,  'Pressure Cooker',                     3, 3, 1299.00),
    (10, 'Air Fryer',                           3, 3, 3999.00),
    (11, 'Steel Water Bottle',                  3, 3,  299.00),
    (12, 'Clean Code',                          4, 4,  499.00),
    (13, 'Designing Data-Intensive Applications', 4, 4, 799.00),
    (14, 'The Pragmatic Programmer',            4, 4,  549.00),
    (15, 'Yoga Mat',                            5, 5,  699.00),
    (16, 'Resistance Bands Set',                5, 5,  449.00),
    (17, 'Protein Supplement',                  5, 5, 1299.00),
    (18, 'Sunscreen SPF 50',                    6, 6,  349.00),
    (19, 'Face Wash',                           6, 6,  199.00),
    (20, 'Hair Serum',                          6, 6,  449.00);

-- CUSTOMERS (20)
-- NOTE: Customers 18 (Siddharth), 19 (Divya), 20 (Manish) have NO orders
--       Used for LEFT JOIN / anti-join demos
INSERT INTO customers VALUES
    (1,  'Arjun Sharma',       'arjun.sharma@gmail.com',       'Bangalore', 'Karnataka',      '2023-06-15'),
    (2,  'Priya Nair',         'priya.nair@gmail.com',         'Chennai',   'Tamil Nadu',      '2023-08-22'),
    (3,  'Rahul Gupta',        'rahul.gupta@gmail.com',        'Delhi',     'Delhi',           '2023-11-10'),
    (4,  'Anjali Singh',       'anjali.singh@gmail.com',       'Mumbai',    'Maharashtra',     '2024-01-05'),
    (5,  'Vikram Reddy',       'vikram.reddy@gmail.com',       'Hyderabad', 'Telangana',       '2023-09-18'),
    (6,  'Sneha Iyer',         'sneha.iyer@gmail.com',         'Bangalore', 'Karnataka',       '2024-02-14'),
    (7,  'Rohit Kumar',        'rohit.kumar@gmail.com',        'Pune',      'Maharashtra',     '2023-07-30'),
    (8,  'Deepa Mehta',        'deepa.mehta@gmail.com',        'Jaipur',    'Rajasthan',       '2024-03-08'),
    (9,  'Kiran Pillai',       'kiran.pillai@gmail.com',       'Kochi',     'Kerala',          '2023-12-20'),
    (10, 'Aditya Joshi',       'aditya.joshi@gmail.com',       'Mumbai',    'Maharashtra',     '2024-01-18'),
    (11, 'Meera Rao',          'meera.rao@gmail.com',          'Bangalore', 'Karnataka',       '2023-10-05'),
    (12, 'Suresh Patil',       'suresh.patil@gmail.com',       'Pune',      'Maharashtra',     '2024-02-28'),
    (13, 'Kavitha Krishnan',   'kavitha.krishnan@gmail.com',   'Chennai',   'Tamil Nadu',      '2023-11-15'),
    (14, 'Nikhil Sharma',      'nikhil.sharma@gmail.com',      'Delhi',     'Delhi',           '2024-01-01'),
    (15, 'Pooja Verma',        'pooja.verma@gmail.com',        'Lucknow',   'Uttar Pradesh',   '2023-08-12'),
    (16, 'Rajesh Nair',        'rajesh.nair@gmail.com',        'Kochi',     'Kerala',          '2024-03-22'),
    (17, 'Ananya Bose',        'ananya.bose@gmail.com',        'Kolkata',   'West Bengal',     '2023-09-05'),
    (18, 'Siddharth Malhotra', 'siddharth.malhotra@gmail.com', 'Delhi',     'Delhi',           '2024-04-10'),  -- NO ORDERS
    (19, 'Divya Sundaram',     'divya.sundaram@gmail.com',     'Chennai',   'Tamil Nadu',      '2024-05-18'),  -- NO ORDERS
    (20, 'Manish Agarwal',     'manish.agarwal@gmail.com',     'Bangalore', 'Karnataka',       '2024-06-02');  -- NO ORDERS

-- ORDERS (45)
-- Statuses: delivered, shipped, pending, cancelled, returned
-- Orders 44 & 45 share date 2024-01-05 with order 1 (for ROWS vs RANGE demo)
INSERT INTO orders VALUES
    (1,  1,  '2024-01-05', 'delivered', 3097.00),
    (2,  1,  '2024-03-12', 'delivered',  699.00),
    (3,  1,  '2024-06-20', 'delivered', 1798.00),
    (4,  1,  '2024-09-15', 'shipped',   3999.00),
    (5,  1,  '2024-11-25', 'delivered', 2197.00),
    (6,  2,  '2024-01-18', 'delivered', 1198.00),
    (7,  2,  '2024-04-22', 'delivered', 1048.00),
    (8,  2,  '2024-08-10', 'cancelled', 1499.00),
    (9,  2,  '2024-12-01', 'returned',  2499.00),
    (10, 3,  '2024-02-14', 'delivered', 2897.00),
    (11, 3,  '2024-05-30', 'delivered', 2499.00),
    (12, 3,  '2024-10-08', 'shipped',   4896.00),
    (13, 4,  '2024-01-29', 'delivered', 1797.00),
    (14, 4,  '2024-03-15', 'delivered',  698.00),
    (15, 4,  '2024-07-04', 'delivered', 3999.00),
    (16, 4,  '2024-11-11', 'pending',   1495.00),
    (17, 5,  '2024-02-20', 'delivered', 1148.00),
    (18, 5,  '2024-06-08', 'delivered', 3999.00),
    (19, 5,  '2024-09-22', 'delivered', 2598.00),
    (20, 6,  '2024-03-05', 'delivered',  747.00),
    (21, 6,  '2024-08-18', 'delivered', 1198.00),
    (22, 7,  '2024-01-10', 'delivered', 1048.00),
    (23, 7,  '2024-07-25', 'shipped',   2598.00),
    (24, 8,  '2024-02-28', 'delivered', 1299.00),
    (25, 8,  '2024-09-12', 'delivered', 1594.00),
    (26, 9,  '2024-04-14', 'delivered', 1348.00),
    (27, 9,  '2024-10-30', 'pending',   2499.00),
    (28, 10, '2024-01-22', 'delivered', 2298.00),
    (29, 10, '2024-06-15', 'delivered', 3999.00),
    (30, 11, '2024-03-20', 'delivered', 1048.00),
    (31, 11, '2024-08-05', 'delivered', 1047.00),
    (32, 12, '2024-02-10', 'delivered', 1897.00),
    (33, 12, '2024-11-20', 'shipped',   3999.00),
    (34, 13, '2024-04-08', 'delivered', 1298.00),
    (35, 13, '2024-09-30', 'delivered', 1198.00),
    (36, 14, '2024-01-15', 'delivered', 3798.00),
    (37, 14, '2024-07-10', 'cancelled', 3999.00),
    (38, 15, '2024-03-25', 'delivered', 1597.00),
    (39, 15, '2024-10-14', 'delivered',  747.00),
    (40, 16, '2024-02-05', 'delivered', 1499.00),
    (41, 16, '2024-08-22', 'delivered', 1748.00),
    (42, 17, '2024-05-12', 'delivered', 1348.00),
    (43, 17, '2024-11-08', 'pending',   2246.00),
    (44, 6,  '2024-01-05', 'delivered',  499.00),  -- same date as order 1
    (45, 7,  '2024-01-05', 'delivered',  598.00);  -- same date as order 1

-- ORDER_ITEMS (67 rows)
INSERT INTO order_items VALUES
    (1,  1,  1,  1, 2499.00),   -- order 1:  Wireless Earbuds x1
    (2,  1,  11, 2,  299.00),   -- order 1:  Steel Water Bottle x2
    (3,  2,  15, 1,  699.00),   -- order 2:  Yoga Mat x1
    (4,  3,  2,  1, 1299.00),   -- order 3:  USB-C Hub x1
    (5,  3,  12, 1,  499.00),   -- order 3:  Clean Code x1
    (6,  4,  3,  1, 3999.00),   -- order 4:  Mechanical Keyboard x1
    (7,  5,  16, 2,  449.00),   -- order 5:  Resistance Bands x2
    (8,  5,  17, 1, 1299.00),   -- order 5:  Protein Supplement x1
    (9,  6,  7,  2,  599.00),   -- order 6:  Womens Kurta x2
    (10, 7,  14, 1,  549.00),   -- order 7:  Pragmatic Programmer x1
    (11, 7,  12, 1,  499.00),   -- order 7:  Clean Code x1
    (12, 8,  8,  1, 1499.00),   -- order 8:  Running Shoes x1
    (13, 9,  1,  1, 2499.00),   -- order 9:  Wireless Earbuds x1
    (14, 10, 6,  2,  799.00),   -- order 10: Mens Formal Shirt x2
    (15, 10, 9,  1, 1299.00),   -- order 10: Pressure Cooker x1
    (16, 11, 1,  1, 2499.00),   -- order 11: Wireless Earbuds x1
    (17, 12, 10, 1, 3999.00),   -- order 12: Air Fryer x1
    (18, 12, 11, 3,  299.00),   -- order 12: Steel Water Bottle x3
    (19, 13, 7,  3,  599.00),   -- order 13: Womens Kurta x3
    (20, 14, 18, 2,  349.00),   -- order 14: Sunscreen SPF 50 x2
    (21, 15, 10, 1, 3999.00),   -- order 15: Air Fryer x1
    (22, 16, 19, 3,  199.00),   -- order 16: Face Wash x3
    (23, 16, 20, 2,  449.00),   -- order 16: Hair Serum x2
    (24, 17, 15, 1,  699.00),   -- order 17: Yoga Mat x1
    (25, 17, 16, 1,  449.00),   -- order 17: Resistance Bands x1
    (26, 18, 3,  1, 3999.00),   -- order 18: Mechanical Keyboard x1
    (27, 19, 17, 2, 1299.00),   -- order 19: Protein Supplement x2
    (28, 20, 18, 1,  349.00),   -- order 20: Sunscreen SPF 50 x1
    (29, 20, 19, 2,  199.00),   -- order 20: Face Wash x2
    (30, 21, 7,  2,  599.00),   -- order 21: Womens Kurta x2
    (31, 22, 12, 1,  499.00),   -- order 22: Clean Code x1
    (32, 22, 14, 1,  549.00),   -- order 22: Pragmatic Programmer x1
    (33, 23, 2,  2, 1299.00),   -- order 23: USB-C Hub x2
    (34, 24, 9,  1, 1299.00),   -- order 24: Pressure Cooker x1
    (35, 25, 11, 4,  299.00),   -- order 25: Steel Water Bottle x4
    (36, 25, 19, 2,  199.00),   -- order 25: Face Wash x2
    (37, 26, 14, 1,  549.00),   -- order 26: Pragmatic Programmer x1
    (38, 26, 13, 1,  799.00),   -- order 26: DDIA x1
    (39, 27, 1,  1, 2499.00),   -- order 27: Wireless Earbuds x1
    (40, 28, 6,  1,  799.00),   -- order 28: Mens Formal Shirt x1
    (41, 28, 8,  1, 1499.00),   -- order 28: Running Shoes x1
    (42, 29, 10, 1, 3999.00),   -- order 29: Air Fryer x1
    (43, 30, 7,  1,  599.00),   -- order 30: Womens Kurta x1
    (44, 30, 20, 1,  449.00),   -- order 30: Hair Serum x1
    (45, 31, 18, 3,  349.00),   -- order 31: Sunscreen SPF 50 x3
    (46, 32, 9,  1, 1299.00),   -- order 32: Pressure Cooker x1
    (47, 32, 11, 2,  299.00),   -- order 32: Steel Water Bottle x2
    (48, 33, 3,  1, 3999.00),   -- order 33: Mechanical Keyboard x1
    (49, 34, 13, 1,  799.00),   -- order 34: DDIA x1
    (50, 34, 12, 1,  499.00),   -- order 34: Clean Code x1
    (51, 35, 7,  2,  599.00),   -- order 35: Womens Kurta x2
    (52, 36, 1,  1, 2499.00),   -- order 36: Wireless Earbuds x1
    (53, 36, 2,  1, 1299.00),   -- order 36: USB-C Hub x1
    (54, 37, 3,  1, 3999.00),   -- order 37: Mechanical Keyboard x1
    (55, 38, 15, 1,  699.00),   -- order 38: Yoga Mat x1
    (56, 38, 16, 2,  449.00),   -- order 38: Resistance Bands x2
    (57, 39, 19, 2,  199.00),   -- order 39: Face Wash x2
    (58, 39, 18, 1,  349.00),   -- order 39: Sunscreen SPF 50 x1
    (59, 40, 8,  1, 1499.00),   -- order 40: Running Shoes x1
    (60, 41, 17, 1, 1299.00),   -- order 41: Protein Supplement x1
    (61, 41, 16, 1,  449.00),   -- order 41: Resistance Bands x1
    (62, 42, 13, 1,  799.00),   -- order 42: DDIA x1
    (63, 42, 14, 1,  549.00),   -- order 42: Pragmatic Programmer x1
    (64, 43, 7,  3,  599.00),   -- order 43: Womens Kurta x3
    (65, 43, 20, 1,  449.00),   -- order 43: Hair Serum x1
    (66, 44, 12, 1,  499.00),   -- order 44: Clean Code x1
    (67, 45, 11, 2,  299.00);   -- order 45: Steel Water Bottle x2

-- ============================================================
-- VERIFY DATA LOAD
-- ============================================================
SELECT 'categories'  AS table_name, COUNT(*) AS row_count FROM categories
UNION ALL
SELECT 'sellers',      COUNT(*) FROM sellers
UNION ALL
SELECT 'customers',    COUNT(*) FROM customers
UNION ALL
SELECT 'products',     COUNT(*) FROM products
UNION ALL
SELECT 'orders',       COUNT(*) FROM orders
UNION ALL
SELECT 'order_items',  COUNT(*) FROM order_items;

-- Expected output:
-- categories  | 6
-- sellers     | 6
-- customers   | 20
-- products    | 20
-- orders      | 45
-- order_items | 67
