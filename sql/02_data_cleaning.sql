USE E_Commerce_risk_analysis;
-- E-COMMERCE RETURN & REFUND RISK ANALYSIS
-- 03_DATA_CLEANING.SQL

-- Check row counts
SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_returns
FROM returns;

SELECT COUNT(*) AS total_refunds
FROM refunds;


-- Check duplicate Customer IDs
SELECT
    Customer_ID,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;


-- Check duplicate Order IDs
SELECT
    Order_ID,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;


-- Check duplicate Return IDs
SELECT
    Return_ID,
    COUNT(*) AS duplicate_count
FROM returns
GROUP BY Return_ID
HAVING COUNT(*) > 1;


-- Check duplicate Product IDs
SELECT
    Product_ID,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY Product_ID
HAVING COUNT(*) > 1;


-- Check duplicate Refund IDs
SELECT
    Refund_ID,
    COUNT(*) AS duplicate_count
FROM refunds
GROUP BY Refund_ID
HAVING COUNT(*) > 1;

--null values check

SELECT
    SUM(Customer_ID IS NULL) AS missing_customer_id,
    SUM(Customer_Name IS NULL) AS missing_customer_name,
    SUM(Gender IS NULL) AS missing_gender,
    SUM(City IS NULL) AS missing_city,
    SUM(Customer_Type IS NULL) AS missing_customer_type,
    SUM(Signup_Date IS NULL) AS missing_signup_date
FROM customers;


SELECT
    SUM(Order_ID IS NULL) AS missing_order_id,
    SUM(Customer_ID IS NULL) AS missing_customer_id,
    SUM(Product_ID IS NULL) AS missing_product_id,
    SUM(Order_Date IS NULL) AS missing_order_date,
    SUM(Quantity IS NULL) AS missing_quantity,
    SUM(Unit_Price IS NULL) AS missing_unit_price,
    SUM(Discount_Pct IS NULL) AS missing_discount,
    SUM(Payment_Method IS NULL) AS missing_payment_method,
    SUM(Shipping_Method IS NULL) AS missing_shipping_method
FROM orders;


SELECT
    SUM(Return_ID IS NULL) AS missing_return_id,
    SUM(Order_ID IS NULL) AS missing_order_id,
    SUM(Return_Date IS NULL) AS missing_return_date,
    SUM(Return_Reason IS NULL) AS missing_return_reason,
    SUM(Return_Status IS NULL) AS missing_return_status,
    SUM(Refund_Method IS NULL) AS missing_refund_method,
    SUM(Refund_Amount IS NULL) AS missing_refund_amount
FROM returns;


--create backup tables

CREATE TABLE customers_clean AS
SELECT *
FROM customers;

CREATE TABLE orders_clean AS
SELECT *
FROM orders;

--remove duplicates

SET SQL_SAFE_UPDATES = 0;


-- Create cleaned customer table
CREATE TABLE customers_clean AS
SELECT
    Customer_ID,
    Customer_Name,
    Gender,
    City,
    Customer_Type,
    Signup_Date
FROM
(
    SELECT
        c.*,
        ROW_NUMBER() OVER
        (
            PARTITION BY Customer_ID
            ORDER BY Signup_Date
        ) AS rn
    FROM customers c
) AS customer_data
WHERE rn = 1;


-- Verify duplicates were removed
SELECT
    Customer_ID,
    COUNT(*) AS duplicate_count
FROM customers_clean
GROUP BY Customer_ID
HAVING COUNT(*) > 1;


--standarize customer data
-- Clean Gender
UPDATE customers_clean
SET Gender =
    CASE
        WHEN LOWER(TRIM(Gender)) IN ('m', 'male')
            THEN 'Male'

        WHEN LOWER(TRIM(Gender)) IN ('f', 'female')
            THEN 'Female'

        WHEN LOWER(TRIM(Gender)) = 'other'
            THEN 'Other'

        ELSE 'Unknown'
    END;


-- Clean City
UPDATE customers_clean
SET City =
    CASE
        WHEN LOWER(TRIM(City)) = 'mumbai'
            THEN 'Mumbai'

        WHEN LOWER(TRIM(City)) = 'delhi'
            THEN 'Delhi'

        WHEN LOWER(TRIM(City)) = 'pune'
            THEN 'Pune'

        WHEN LOWER(TRIM(City)) IN ('banglore', 'bengaluru')
            THEN 'Bangalore'

        WHEN LOWER(TRIM(City)) = 'hyderabad'
            THEN 'Hyderabad'

        WHEN LOWER(TRIM(City)) = 'kolkata'
            THEN 'Kolkata'

        WHEN LOWER(TRIM(City)) = 'chennai'
            THEN 'Chennai'

        WHEN LOWER(TRIM(City)) = 'ahmedabad'
            THEN 'Ahmedabad'

        ELSE 'Unknown'
    END;


-- Clean Customer Type
UPDATE customers_clean
SET Customer_Type =
    CASE
        WHEN LOWER(TRIM(Customer_Type)) = 'new'
            THEN 'New'

        WHEN LOWER(TRIM(Customer_Type)) = 'returning'
            THEN 'Returning'

        WHEN LOWER(TRIM(Customer_Type)) = 'vip'
            THEN 'VIP'

        ELSE 'Unknown'
    END;

--create clean tables

CREATE TABLE orders_clean AS
SELECT
    Order_ID,
    Customer_ID,
    Product_ID,
    Order_Date,
    Quantity,
    Unit_Price,
    Discount_Pct,
    Payment_Method,
    Shipping_Method,
    Order_Status
FROM
(
    SELECT
        o.*,
        ROW_NUMBER() OVER
        (
            PARTITION BY Order_ID
            ORDER BY Order_Date
        ) AS rn
    FROM orders o
) AS order_data
WHERE rn = 1;


-- Verify duplicate orders
SELECT
    Order_ID,
    COUNT(*) AS duplicate_count
FROM orders_clean
GROUP BY Order_ID
HAVING COUNT(*) > 1;


--clean invalid values
-- Check invalid quantities
SELECT *
FROM orders_clean
WHERE Quantity <= 0
   OR Quantity > 10;


-- Check invalid prices
SELECT *
FROM orders_clean
WHERE Unit_Price <= 0
   OR Unit_Price > 50000;


-- Check invalid discounts
SELECT *
FROM orders_clean
WHERE Discount_Pct < 0
   OR Discount_Pct > 100;


-- Remove invalid order records
DELETE FROM orders_clean
WHERE Quantity <= 0
   OR Quantity > 10
   OR Unit_Price <= 0
   OR Unit_Price > 50000
   OR Discount_Pct < 0
   OR Discount_Pct > 100;


--standarized order text values
UPDATE orders_clean
SET Payment_Method =
    CASE
        WHEN LOWER(TRIM(Payment_Method)) = 'upi'
            THEN 'UPI'

        WHEN LOWER(TRIM(Payment_Method)) = 'credit card'
            THEN 'Credit Card'

        WHEN LOWER(TRIM(Payment_Method)) = 'debit card'
            THEN 'Debit Card'

        WHEN LOWER(TRIM(Payment_Method)) = 'net banking'
            THEN 'Net Banking'

        WHEN LOWER(TRIM(Payment_Method)) = 'cash on delivery'
            THEN 'Cash On Delivery'

        ELSE 'Unknown'
    END;


UPDATE orders_clean
SET Shipping_Method =
    CASE
        WHEN LOWER(TRIM(Shipping_Method)) = 'standard'
            THEN 'Standard'

        WHEN LOWER(TRIM(Shipping_Method)) = 'express'
            THEN 'Express'

        WHEN LOWER(TRIM(Shipping_Method)) = 'same day'
            THEN 'Same Day'

        WHEN LOWER(TRIM(Shipping_Method)) = 'next day'
            THEN 'Next Day'

        ELSE 'Unknown'
    END;


-- =========================================================
-- PHASE 9: CREATE CLEAN RETURNS TABLE
-- =========================================================

CREATE TABLE returns_clean AS
SELECT
    Return_ID,
    Order_ID,
    Return_Date,
    Return_Reason,
    Return_Status,
    Refund_Method,
    Refund_Amount
FROM
(
    SELECT
        r.*,
        ROW_NUMBER() OVER
        (
            PARTITION BY Return_ID
            ORDER BY Return_Date
        ) AS rn
    FROM returns r
) AS return_data
WHERE rn = 1;


-- Verify duplicate returns
SELECT
    Return_ID,
    COUNT(*) AS duplicate_count
FROM returns_clean
GROUP BY Return_ID
HAVING COUNT(*) > 1;


--clean invalid return values
-- Invalid refund amounts
SELECT *
FROM returns_clean
WHERE Refund_Amount <= 0;


-- Invalid return dates
SELECT
    r.Return_ID,
    r.Order_ID,
    o.Order_Date,
    r.Return_Date
FROM returns_clean r
JOIN orders_clean o
    ON r.Order_ID = o.Order_ID
WHERE r.Return_Date < o.Order_Date;


-- Remove invalid refund records
DELETE FROM returns_clean
WHERE Refund_Amount <= 0;


-- Remove returns that happened before the order
DELETE r
FROM returns_clean r
JOIN orders_clean o
    ON r.Order_ID = o.Order_ID
WHERE r.Return_Date < o.Order_Date;


--standarized return text values
UPDATE returns_clean
SET Return_Reason =
    CASE
        WHEN LOWER(TRIM(Return_Reason)) = 'size issue'
            THEN 'Size Issue'

        WHEN LOWER(TRIM(Return_Reason)) = 'damaged'
            THEN 'Damaged'

        WHEN LOWER(TRIM(Return_Reason)) = 'wrong item'
            THEN 'Wrong Item'

        WHEN LOWER(TRIM(Return_Reason)) = 'quality issue'
            THEN 'Quality Issue'

        WHEN LOWER(TRIM(Return_Reason)) = 'not as expected'
            THEN 'Not As Expected'

        ELSE 'Other'
    END;


UPDATE returns_clean
SET Return_Status =
    CASE
        WHEN LOWER(TRIM(Return_Status)) = 'approved'
            THEN 'Approved'

        WHEN LOWER(TRIM(Return_Status)) = 'pending'
            THEN 'Pending'

        WHEN LOWER(TRIM(Return_Status)) = 'rejected'
            THEN 'Rejected'

        ELSE 'Unknown'
    END;


UPDATE returns_clean
SET Refund_Method =
    CASE
        WHEN LOWER(TRIM(Refund_Method)) = 'upi'
            THEN 'UPI'

        WHEN LOWER(TRIM(Refund_Method)) = 'credit card'
            THEN 'Credit Card'

        WHEN LOWER(TRIM(Refund_Method)) = 'debit card'
            THEN 'Debit Card'

        WHEN LOWER(TRIM(Refund_Method)) = 'bank transfer'
            THEN 'Bank Transfer'

        ELSE 'Unknown'
    END;


--check product data
SELECT
    Product_ID,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY Product_ID
HAVING COUNT(*) > 1;


SELECT *
FROM products
WHERE Unit_Price <= 0
   OR Unit_Price > 50000;

--refund data validation
SELECT
    Refund_ID,
    COUNT(*) AS duplicate_count
FROM refunds
GROUP BY Refund_ID
HAVING COUNT(*) > 1;


SELECT *
FROM refunds
WHERE Refund_Amount <= 0;


-- Check refunds without matching returns
SELECT DISTINCT
    r.Refund_ID,
    r.Return_ID
FROM refunds r
LEFT JOIN returns_clean rc
    ON r.Return_ID = rc.Return_ID
WHERE rc.Return_ID IS NULL;


-- add primary keys
ALTER TABLE customers_clean
ADD PRIMARY KEY (Customer_ID);

ALTER TABLE orders_clean
ADD PRIMARY KEY (Order_ID);

ALTER TABLE products
ADD PRIMARY KEY (Product_ID);

ALTER TABLE returns_clean
ADD PRIMARY KEY (Return_ID);

ALTER TABLE refunds
ADD PRIMARY KEY (Refund_ID);


--add foreign keys
ALTER TABLE orders_clean
ADD CONSTRAINT fk_order_customer
FOREIGN KEY (Customer_ID)
REFERENCES customers_clean(Customer_ID);


ALTER TABLE orders_clean
ADD CONSTRAINT fk_order_product
FOREIGN KEY (Product_ID)
REFERENCES products(Product_ID);


ALTER TABLE returns_clean
ADD CONSTRAINT fk_return_order
FOREIGN KEY (Order_ID)
REFERENCES orders_clean(Order_ID);


ALTER TABLE refunds
ADD CONSTRAINT fk_refund_return
FOREIGN KEY (Return_ID)
REFERENCES returns_clean(Return_ID);


--final data quality check
-- Customers
SELECT COUNT(*) AS clean_customers
FROM customers_clean;


-- Orders
SELECT COUNT(*) AS clean_orders
FROM orders_clean;


-- Products
SELECT COUNT(*) AS clean_products
FROM products;


-- Returns
SELECT COUNT(*) AS clean_returns
FROM returns_clean;


-- Refunds
SELECT COUNT(*) AS total_refunds
FROM refunds;


-- Final duplicate check
SELECT Customer_ID, COUNT(*)
FROM customers_clean
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

SELECT Order_ID, COUNT(*)
FROM orders_clean
GROUP BY Order_ID
HAVING COUNT(*) > 1;

SELECT Return_ID, COUNT(*)
FROM returns_clean
GROUP BY Return_ID
HAVING COUNT(*) > 1;

