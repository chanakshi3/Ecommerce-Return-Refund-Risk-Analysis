USE E_Commerce_risk_analysis;


-- 1. OVERALL RETURN PERFORMANCE
-- Total Orders
SELECT
    COUNT(*) AS total_orders
FROM orders_clean;


-- Total Returns
SELECT
    COUNT(*) AS total_returns
FROM returns;


-- Total Refund Amount
SELECT
    ROUND(SUM(Refund_Amount), 2) AS total_refunds
FROM refunds;


-- Overall Return Rate
SELECT
    ROUND(
        COUNT(DISTINCT r.Order_ID) * 100.0 /
        COUNT(DISTINCT o.Order_ID),
        2
    ) AS return_rate
FROM orders_clean o
LEFT JOIN returns r
    ON o.Order_ID = r.Order_ID;


-- 2. RETURN REASONS
-- Most Common Return Reasons
SELECT
    Return_Reason,
    COUNT(*) AS return_count
FROM returns
GROUP BY Return_Reason
ORDER BY return_count DESC;


-- Refund Amount by Return Reason
SELECT
    Return_Reason,
    COUNT(*) AS return_count,
    ROUND(SUM(Refund_Amount), 2) AS total_refund
FROM returns
GROUP BY Return_Reason
ORDER BY total_refund DESC;


-- 3. CATEGORY RETURN RISK
-- Return Rate by Category
SELECT
    p.Category,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Return_ID) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        COUNT(DISTINCT o.Order_ID),
        2
    ) AS return_rate
FROM products p
JOIN orders_clean o
    ON p.Product_ID = o.Product_ID
LEFT JOIN returns r
    ON r.Order_ID = o.Order_ID
GROUP BY p.Category
ORDER BY return_rate DESC;


-- Return Rate by Subcategory
SELECT
    p.Subcategory,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Return_ID) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        COUNT(DISTINCT o.Order_ID),
        2
    ) AS return_rate
FROM products p
JOIN orders_clean o
    ON p.Product_ID = o.Product_ID
LEFT JOIN returns r
    ON r.Order_ID = o.Order_ID
GROUP BY p.Subcategory
ORDER BY return_rate DESC;


-- 4. PRODUCT RETURN RISK
-- Products with Highest Return Rate
SELECT
    p.Product_ID,
    p.Product_Name,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Return_ID) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        COUNT(DISTINCT o.Order_ID),
        2
    ) AS return_rate
FROM products p
JOIN orders_clean o
    ON p.Product_ID = o.Product_ID
LEFT JOIN returns r
    ON r.Order_ID = o.Order_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
HAVING COUNT(DISTINCT o.Order_ID) >= 10
ORDER BY return_rate DESC;


-- Top Products by Refund Amount
SELECT
    p.Product_ID,
    p.Product_Name,
    ROUND(SUM(r.Refund_Amount), 2) AS total_refund
FROM products p
JOIN orders_clean o
    ON p.Product_ID = o.Product_ID
JOIN returns r
    ON r.Order_ID = o.Order_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY total_refund DESC
LIMIT 10;


-- 5. CUSTOMER RETURN BEHAVIOUR
-- Customer Return Behaviour
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Return_ID) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        COUNT(DISTINCT o.Order_ID),
        2
    ) AS return_rate
FROM customers c
JOIN orders_clean o
    ON c.Customer_ID = o.Customer_ID
LEFT JOIN returns r
    ON r.Order_ID = o.Order_ID
GROUP BY
    c.Customer_ID,
    c.Customer_Name
ORDER BY return_rate DESC;


-- High Return Customers
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(DISTINCT r.Return_ID) AS total_returns
FROM customers c
JOIN orders_clean o
    ON c.Customer_ID = o.Customer_ID
JOIN returns r
    ON r.Order_ID = o.Order_ID
GROUP BY
    c.Customer_ID,
    c.Customer_Name
HAVING COUNT(DISTINCT r.Return_ID) > 2
ORDER BY total_returns DESC;


-- 6. DISCOUNT VS RETURN BEHAVIOUR
SELECT
    CASE
        WHEN Discount_Pct = 0 THEN 'No Discount'
        WHEN Discount_Pct <= 10 THEN '1-10%'
        WHEN Discount_Pct <= 20 THEN '11-20%'
        ELSE '21%+'
    END AS discount_range,

    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Return_ID) AS total_returns,

    ROUND(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        COUNT(DISTINCT o.Order_ID),
        2
    ) AS return_rate

FROM orders_clean o
LEFT JOIN returns r
    ON o.Order_ID = r.Order_ID

GROUP BY discount_range
ORDER BY return_rate DESC;


-- 7. PAYMENT & SHIPPING ANALYSIS
-- Return Rate by Payment Method
SELECT
    o.Payment_Method,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Return_ID) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        COUNT(DISTINCT o.Order_ID),
        2
    ) AS return_rate
FROM orders_clean o
LEFT JOIN returns r
    ON o.Order_ID = r.Order_ID
GROUP BY o.Payment_Method
ORDER BY return_rate DESC;


-- Return Rate by Shipping Method
SELECT
    o.Shipping_Method,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Return_ID) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        COUNT(DISTINCT o.Order_ID),
        2
    ) AS return_rate
FROM orders_clean o
LEFT JOIN returns r
    ON o.Order_ID = r.Order_ID
GROUP BY o.Shipping_Method
ORDER BY return_rate DESC;



-- 8. GEOGRAPHIC ANALYSIS
-- Return Rate by City
SELECT
    c.City,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Return_ID) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        COUNT(DISTINCT o.Order_ID),
        2
    ) AS return_rate
FROM customers c
JOIN orders_clean o
    ON c.Customer_ID = o.Customer_ID
LEFT JOIN returns r
    ON r.Order_ID = o.Order_ID
GROUP BY c.City
ORDER BY return_rate DESC;



-- 9. MONTHLY RETURN & REFUND TRENDS
-- Monthly Return Trend
SELECT
    YEAR(Return_Date) AS return_year,
    MONTH(Return_Date) AS return_month,
    COUNT(*) AS total_returns,
    ROUND(SUM(Refund_Amount), 2) AS total_refund
FROM returns
GROUP BY
    YEAR(Return_Date),
    MONTH(Return_Date)
ORDER BY
    return_year,
    return_month;


-- Monthly Refund Trend
SELECT
    DATE_FORMAT(Return_Date, '%Y-%m') AS month,
    ROUND(SUM(Refund_Amount), 2) AS refund_amount
FROM returns
GROUP BY DATE_FORMAT(Return_Date, '%Y-%m')
ORDER BY month;


-- 10. ADVANCED CUSTOMER ANALYSIS
-- Rank Customers by Return Rate
SELECT
    customer_id,
    customer_name,
    total_orders,
    total_returns,
    return_rate,
    RANK() OVER (
        ORDER BY return_rate DESC
    ) AS customer_rank
FROM
(
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT r.return_id) AS total_returns,
        ROUND(
            COUNT(DISTINCT r.return_id) * 100.0 /
            COUNT(DISTINCT o.order_id),
            2
        ) AS return_rate
    FROM customers c
    JOIN orders_clean o
        ON c.customer_id = o.customer_id
    LEFT JOIN returns r
        ON r.order_id = o.order_id
    GROUP BY
        c.customer_id,
        c.customer_name
    HAVING COUNT(DISTINCT o.order_id) >= 5
) AS customer_analysis
ORDER BY customer_rank;


-- Return Rate by Customer Type
SELECT
    c.Customer_Type,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Return_ID) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        COUNT(DISTINCT o.Order_ID),
        2
    ) AS return_rate
FROM customers c
JOIN orders_clean o
    ON c.Customer_ID = o.Customer_ID
LEFT JOIN returns r
    ON r.Order_ID = o.Order_ID
GROUP BY c.Customer_Type
ORDER BY return_rate DESC;



-- 11. REFUND IMPACT
-- Average Refund Amount by Category
SELECT
    p.Category,
    COUNT(r.Return_ID) AS total_returns,
    ROUND(AVG(r.Refund_Amount), 2) AS avg_refund,
    ROUND(SUM(r.Refund_Amount), 2) AS total_refund
FROM products p
JOIN orders_clean o
    ON p.Product_ID = o.Product_ID
JOIN returns r
    ON o.Order_ID = r.Order_ID
GROUP BY p.Category
ORDER BY total_refund DESC;


-- Return Reasons by Category
SELECT
    p.Category,
    r.Return_Reason,
    COUNT(*) AS return_count
FROM products p
JOIN orders_clean o
    ON p.Product_ID = o.Product_ID
JOIN returns r
    ON o.Order_ID = r.Order_ID
GROUP BY
    p.Category,
    r.Return_Reason
ORDER BY
    p.Category,
    return_count DESC;


-- Customers Generating Most Refund Value
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(DISTINCT r.Return_ID) AS total_returns,
    ROUND(SUM(r.Refund_Amount), 2) AS total_refund
FROM customers c
JOIN orders_clean o
    ON c.Customer_ID = o.Customer_ID
JOIN returns r
    ON r.Order_ID = o.Order_ID
GROUP BY
    c.Customer_ID,
    c.Customer_Name
ORDER BY total_refund DESC
LIMIT 10;


-- 12. CUSTOMER RISK CLASSIFICATION
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Return_ID) AS total_returns,

    ROUND(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        NULLIF(COUNT(DISTINCT o.Order_ID), 0),
        2
    ) AS return_rate,

    COALESCE(SUM(r.Refund_Amount), 0) AS total_refund,

    CASE
        WHEN COUNT(DISTINCT r.Return_ID) >= 5
             AND COUNT(DISTINCT r.Return_ID) * 100.0 /
                 NULLIF(COUNT(DISTINCT o.Order_ID), 0) >= 40
            THEN 'High Risk'

        WHEN COUNT(DISTINCT r.Return_ID) >= 3
             AND COUNT(DISTINCT r.Return_ID) * 100.0 /
                 NULLIF(COUNT(DISTINCT o.Order_ID), 0) >= 20
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS risk_level

FROM customers c
JOIN orders_clean o
    ON c.Customer_ID = o.Customer_ID
LEFT JOIN returns r
    ON r.Order_ID = o.Order_ID

GROUP BY
    c.Customer_ID,
    c.Customer_Name;



-- 13. PRODUCT RISK CLASSIFICATION
SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,

    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Return_ID) AS total_returns,

    ROUND(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        NULLIF(COUNT(DISTINCT o.Order_ID), 0),
        2
    ) AS return_rate,

    COALESCE(SUM(r.Refund_Amount), 0) AS total_refund,

    CASE
        WHEN COUNT(DISTINCT o.Order_ID) >= 20
             AND COUNT(DISTINCT r.Return_ID) * 100.0 /
                 NULLIF(COUNT(DISTINCT o.Order_ID), 0) >= 30
             AND COALESCE(SUM(r.Refund_Amount), 0) >= 50000
            THEN 'High Risk'

        WHEN COUNT(DISTINCT o.Order_ID) >= 10
             AND COUNT(DISTINCT r.Return_ID) * 100.0 /
                 NULLIF(COUNT(DISTINCT o.Order_ID), 0) >= 20
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS risk_level

FROM products p
JOIN orders_clean o
    ON p.Product_ID = o.Product_ID
LEFT JOIN returns r
    ON o.Order_ID = r.Order_ID

GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category;



-- 14. DISCOUNT VS RETURN ANALYSIS
SELECT
    o.Discount_Pct,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Return_ID) AS total_returns,

    ROUND(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        COUNT(DISTINCT o.Order_ID),
        2
    ) AS return_rate

FROM orders_clean o
LEFT JOIN returns r
    ON o.Order_ID = r.Order_ID

GROUP BY o.Discount_Pct
ORDER BY o.Discount_Pct;



-- 15. PAYMENT METHOD VS REFUNDS
SELECT
    o.Payment_Method,
    COUNT(DISTINCT r.Return_ID) AS total_returns,
    ROUND(SUM(r.Refund_Amount), 2) AS total_refunds
FROM orders_clean o
JOIN returns r
    ON o.Order_ID = r.Order_ID
GROUP BY o.Payment_Method
ORDER BY total_refunds DESC;


-- 16. CITY-LEVEL RETURN RISK
SELECT
    c.City,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Return_ID) AS total_returns,

    ROUND(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        COUNT(DISTINCT o.Order_ID),
        2
    ) AS return_rate

FROM customers c
JOIN orders_clean o
    ON o.Customer_ID = c.Customer_ID
LEFT JOIN returns r
    ON o.Order_ID = r.Order_ID

GROUP BY c.City
ORDER BY return_rate DESC;
