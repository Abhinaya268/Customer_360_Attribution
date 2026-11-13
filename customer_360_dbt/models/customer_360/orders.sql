
{{ config(materialized='view') }}

SELECT
    event_date,
    user_pseudo_id,
    ecommerce.transaction_id AS transaction_id,
    ecommerce.purchase_revenue_in_usd AS revenue_usd,
    traffic_source.source AS marketing_source,
    traffic_source.medium AS marketing_medium,
    traffic_source.name AS campaign_name
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
    event_name = 'purchase'
    AND ecommerce.transaction_id IS NOT NULL
