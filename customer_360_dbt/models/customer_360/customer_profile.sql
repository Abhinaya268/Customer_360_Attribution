
{{ config(materialized='view') }}

SELECT
    c.customer_id,
    c.full_name,
    c.email,
    c.phone,
    c.city,
    c.signup_date,
    c.customer_type,
    c.loyalty_tier,
    b.user_pseudo_id,
    b.mapping_type,
    COALESCE(a.total_events, 0) AS total_events,
    COALESCE(a.purchase_events, 0) AS purchase_events,
    COALESCE(a.cart_events, 0) AS cart_events,
    COALESCE(a.checkout_events, 0) AS checkout_events,
    COALESCE(r.purchase_count, 0) AS purchase_count,
    COALESCE(r.total_revenue_usd, 0) AS total_revenue_usd
FROM
    `customer-360-analytics-513215.customer360_raw.crm_customers` AS c
LEFT JOIN
    `customer-360-analytics-513215.customer360_raw.customer_360_base` AS b
    ON c.customer_id = b.customer_id
LEFT JOIN
    `customer-360-analytics-513215.customer360_raw.customer_360_activity` AS a
    ON c.customer_id = a.customer_id
LEFT JOIN
    `customer-360-analytics-513215.customer360_raw.customer_360_revenue` AS r
    ON c.customer_id = r.customer_id
