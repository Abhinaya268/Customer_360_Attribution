
{{ config(materialized='view') }}

WITH events AS (
    SELECT
        user_pseudo_id,
        event_timestamp,
        ecommerce.transaction_id AS transaction_id,
        ecommerce.purchase_revenue_in_usd AS revenue_usd,

        (
            SELECT value.int_value
            FROM UNNEST(event_params)
            WHERE key = 'ga_session_id'
        ) AS ga_session_id

    FROM
        `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

    WHERE
        user_pseudo_id IS NOT NULL
        AND event_name = 'purchase'
),

purchases AS (
    SELECT
        user_pseudo_id,
        ga_session_id,
        TIMESTAMP_MICROS(event_timestamp) AS conversion_timestamp,
        COALESCE(revenue_usd, 0) AS conversion_revenue_usd,
        transaction_id,

        TO_JSON_STRING(
            STRUCT(
                user_pseudo_id,
                event_timestamp,
                ga_session_id,
                transaction_id
            )
        ) AS conversion_id

    FROM events
    WHERE ga_session_id IS NOT NULL
),

journey AS (
    SELECT
        p.conversion_id,
        p.user_pseudo_id,
        p.conversion_timestamp,
        p.conversion_revenue_usd,
        p.transaction_id,

        s.ga_session_id AS touchpoint_session_id,
        s.session_start,
        s.marketing_source,
        s.marketing_medium,
        s.campaign_name,

        ROW_NUMBER() OVER (
            PARTITION BY p.conversion_id
            ORDER BY s.session_start ASC
        ) AS first_rank,

        ROW_NUMBER() OVER (
            PARTITION BY p.conversion_id
            ORDER BY s.session_start DESC
        ) AS last_rank,

        COUNT(*) OVER (
            PARTITION BY p.conversion_id
        ) AS touchpoint_count,

        POW(
            0.5,
            TIMESTAMP_DIFF(
                p.conversion_timestamp,
                s.session_start,
                SECOND
            ) / 604800.0
        ) AS raw_decay_weight

    FROM purchases p

    INNER JOIN {{ ref('session_touchpoints') }} s
        ON p.user_pseudo_id = s.user_pseudo_id
        AND s.session_start <= p.conversion_timestamp
),

weighted AS (
    SELECT
        *,
        raw_decay_weight
        / SUM(raw_decay_weight) OVER (
            PARTITION BY conversion_id
        ) AS normalized_decay_weight

    FROM journey
),

attribution AS (

    SELECT
        'first_touch' AS attribution_model,
        conversion_id,
        user_pseudo_id,
        conversion_revenue_usd,
        marketing_source,
        marketing_medium,
        campaign_name,
        IF(first_rank = 1, 1.0, 0.0) AS attribution_weight
    FROM weighted

    UNION ALL

    SELECT
        'last_touch',
        conversion_id,
        user_pseudo_id,
        conversion_revenue_usd,
        marketing_source,
        marketing_medium,
        campaign_name,
        IF(last_rank = 1, 1.0, 0.0)
    FROM weighted

    UNION ALL

    SELECT
        'linear',
        conversion_id,
        user_pseudo_id,
        conversion_revenue_usd,
        marketing_source,
        marketing_medium,
        campaign_name,
        1.0 / touchpoint_count
    FROM weighted

    UNION ALL

    SELECT
        'time_decay_7d_half_life',
        conversion_id,
        user_pseudo_id,
        conversion_revenue_usd,
        marketing_source,
        marketing_medium,
        campaign_name,
        normalized_decay_weight
    FROM weighted
)

SELECT
    attribution_model,
    marketing_source,
    marketing_medium,
    campaign_name,

    ROUND(SUM(attribution_weight), 2)
        AS attributed_conversions,

    ROUND(
        SUM(conversion_revenue_usd * attribution_weight),
        2
    ) AS attributed_revenue_usd,

    COUNT(DISTINCT user_pseudo_id)
        AS attributed_users

FROM attribution

WHERE attribution_weight > 0

GROUP BY
    attribution_model,
    marketing_source,
    marketing_medium,
    campaign_name
