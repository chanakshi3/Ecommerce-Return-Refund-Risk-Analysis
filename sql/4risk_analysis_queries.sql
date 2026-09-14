-- CUSTOMER RISK CLASSIFICATION

SELECT
    c.customer_id,
    c.customer_name,

    COUNT(o.order_id) * 100 /
    COUNT(r.return_id) AS return_rate,

    COALESCE(SUM(r.refund_amount), 0) AS total_refund,

    CASE
        WHEN COUNT(r.return_id) >= 5
             AND COUNT(r.return_id) * 100 /
                 NULLIF(COUNT(o.order_id), 0) >= 40
            THEN 'High Risk'

        WHEN COUNT(r.return_id) >= 3
             AND COUNT(r.return_id) * 100 /
                 NULLIF(COUNT(o.order_id), 0) >= 20
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS risk_level

FROM customers c

JOIN orders_clean o
    ON c.customer_id = o.customer_id

LEFT JOIN returns r
    ON r.order_id = o.order_id

GROUP BY
    c.customer_id,
    c.customer_name;

-- PRODUCT RISK CLASSIFICATION

SELECT
    p.product_id,
    p.product_name,
    p.category,

    COUNT(o.order_id) * 100 /
    COUNT(r.return_id) AS return_rate,

    COALESCE(SUM(r.refund_amount), 0) AS total_refund,

    CASE
        WHEN COUNT(o.order_id) >= 20
             AND COUNT(r.return_id) * 100 /
                 NULLIF(COUNT(o.order_id), 0) >= 30
             AND COALESCE(SUM(r.refund_amount), 0) >= 50000
            THEN 'High Risk'

        WHEN COUNT(o.order_id) > 10
             AND COUNT(r.return_id) * 100 /
                 NULLIF(COUNT(o.order_id), 0) >= 20
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS risk_level

FROM products p

JOIN orders_clean o
    ON p.product_id = o.product_id

LEFT JOIN returns r
    ON o.order_id = r.order_id

GROUP BY
    p.product_id,
    p.product_name,
    p.category;

-- CUSTOMER RETURN RISK SCORE

SELECT
    customer_id,
    customer_name,
    total_orders,
    total_returns,
    return_rate,

    CASE
        WHEN return_rate > 40
             AND total_returns >= 5
            THEN 'High Risk'

        WHEN return_rate >= 20
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS risk_level

FROM
(
    SELECT
        c.customer_id,
        c.customer_name,

        COUNT(DISTINCT o.order_id) AS total_orders,

        COUNT(DISTINCT r.return_id) AS total_returns,

        ROUND(
            COUNT(DISTINCT o.order_id) * 100 /
            COUNT(DISTINCT r.return_id),
            2
        ) AS return_rate

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    LEFT JOIN returns r
        ON o.order_id = r.order_id

    GROUP BY
        c.customer_id,
        c.customer_name

) AS customer_data;

-- IDENTIFY HIGH RETURN CUSTOMERS

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(r.return_id) AS total_returns

FROM customers c

JOIN orders_clean o
    ON c.customer_id = o.customer_id

JOIN returns r
    ON r.order_id = o.order_id

GROUP BY
    c.customer_id,
    c.customer_name

HAVING COUNT(r.return_id) > 2

ORDER BY total_returns DESC;
