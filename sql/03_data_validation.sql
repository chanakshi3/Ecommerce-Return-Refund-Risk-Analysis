```sql
USE E_Commerce_risk_analysis;
--basic table validation
-- Total customer records
SELECT COUNT(*) AS total_customers
FROM customers;

-- Check table structures
SHOW CREATE TABLE customers;
SHOW CREATE TABLE orders_clean;
SHOW CREATE TABLE products;
SHOW CREATE TABLE returns;
SHOW CREATE TABLE refunds;


--customer data validation
-- Check duplicate Customer_IDs
SELECT
    Customer_ID,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

-- Display duplicate customer records
SELECT *
FROM customers
WHERE Customer_ID IN
(
    SELECT Customer_ID
    FROM customers
    GROUP BY Customer_ID
    HAVING COUNT(*) > 1
)
ORDER BY Customer_ID;

-- Check customer records marked as duplicate
SELECT *
FROM customers
WHERE Customer_Name LIKE '%_duplicate';

-- Validate duplicate count after cleaning
SELECT
    Customer_ID,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

-- Check NULL Customer_ID
SELECT *
FROM customers
WHERE Customer_ID IS NULL;

-- Check NULL Signup_Date
SELECT *
FROM customers
WHERE Signup_Date IS NULL;

-- Validate Gender values after standardization
SELECT
    Gender,
    COUNT(*) AS record_count
FROM customers
GROUP BY Gender;

--orders data validation

-- Check duplicate Order_IDs
SELECT
    Order_ID,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Display duplicate order records
SELECT *
FROM orders
WHERE Order_ID IN
(
    SELECT Order_ID
    FROM
    (
        SELECT
            Order_ID
        FROM orders
        GROUP BY Order_ID
        HAVING COUNT(*) > 1
    ) AS d
)
ORDER BY Order_ID;

-- Validate duplicate Order_IDs after creating orders_clean
SELECT
    Order_ID,
    COUNT(*) AS record_count
FROM orders_clean
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Validate number of cleaned orders
SELECT COUNT(*) AS total_clean_orders
FROM orders_clean;

-- Check payment-method values after standardization
SELECT
    Payment_Method,
    COUNT(*) AS record_count
FROM orders_clean
GROUP BY Payment_Method;

-- Validate order date range
SELECT
    MIN(Order_Date) AS earliest_order_date,
    MAX(Order_Date) AS latest_order_date
FROM orders_clean;

-- Display cleaned order records for inspection
SELECT *
FROM orders_clean;


--returns data validation
-- Check duplicate Return_IDs
SELECT
    Return_ID,
    COUNT(*) AS duplicate_count
FROM returns
GROUP BY Return_ID
HAVING COUNT(*) > 1;

-- Display duplicate return records
SELECT *
FROM returns
WHERE Return_ID IN
(
    SELECT Return_ID
    FROM
    (
        SELECT
            Return_ID
        FROM returns
        GROUP BY Return_ID
        HAVING COUNT(*) > 1
    ) AS dd
)
ORDER BY Return_ID;

-- Validate NULL values in return-related fields
SELECT
    SUM(Order_ID IS NULL) AS missing_order,
    SUM(Return_Reason IS NULL) AS missing_reason,
    SUM(Return_Status IS NULL) AS missing_status,
    SUM(Refund_Method IS NULL) AS missing_refund_method
FROM returns;

-- Display return records for inspection
SELECT *
FROM returns;


--product data validation

-- Check duplicate Product_IDs
SELECT
    Product_ID,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY Product_ID
HAVING COUNT(*) > 1;

-- Display product records for inspection
SELECT *
FROM products;


--refund data validation
-- Check duplicate Refund_IDs
SELECT
    Refund_ID,
    COUNT(*) AS duplicate_count
FROM refunds
GROUP BY Refund_ID
HAVING COUNT(*) > 1;

-- Display refund records for inspection
SELECT *
FROM refunds;

-- Check refunds whose Return_ID does not exist
-- in the returns table
SELECT DISTINCT
    r.Return_ID
FROM refunds r
LEFT JOIN returns ret
    ON r.Return_ID = ret.Return_ID
WHERE ret.Return_ID IS NULL;

--primary key/relationship validation

-- Add primary keys
ALTER TABLE orders_clean
ADD PRIMARY KEY (Order_ID);

ALTER TABLE customers
ADD PRIMARY KEY (Customer_ID);

ALTER TABLE products
ADD PRIMARY KEY (Product_ID);

ALTER TABLE returns
ADD PRIMARY KEY (Return_ID);

ALTER TABLE refunds
ADD PRIMARY KEY (Refund_ID);


-- Add foreign keys
ALTER TABLE orders_clean
ADD CONSTRAINT fk_order_customer
FOREIGN KEY (Customer_ID)
REFERENCES customers(Customer_ID);

ALTER TABLE orders_clean
ADD CONSTRAINT fk_order_product
FOREIGN KEY (Product_ID)
REFERENCES products(Product_ID);

ALTER TABLE returns
ADD CONSTRAINT fk_return_order
FOREIGN KEY (Order_ID)
REFERENCES orders_clean(Order_ID);

ALTER TABLE refunds
ADD CONSTRAINT fk_refunds_returns
FOREIGN KEY (Return_ID)
REFERENCES returns(Return_ID);

-- Validate orders table structure after relationships
SHOW CREATE TABLE orders_clean;

--basic data validation
-- Total orders
SELECT COUNT(*) AS total_orders
FROM orders_clean;

-- Total returns
SELECT COUNT(*) AS total_returns
FROM returns;

-- Total refund amount
SELECT SUM(Refund_Amount) AS total_refunds
FROM refunds;

-- Overall return-rate check
SELECT
    COUNT(DISTINCT r.Order_ID) * 100 /
    COUNT(DISTINCT o.Order_ID) AS return_rate
FROM orders_clean o
LEFT JOIN returns r
    ON o.Order_ID = r.Order_ID;
```
