
{{ config(materialized='view') }}

WITH events AS (
    SELECT
        user_pseudo_id,
        event_timestamp,
        event_name,
        ecommerce.purchase_revenue_in_usd AS revenue_usd,

        (
            SELECT value.int_value
            FROM UNNEST(event_params)
            WHERE key = 'ga_session_id'
        ) AS ga_session_id,

        (
            SELECT value.string_value
            FROM UNNEST(event_params)
            WHERE key = 'source'
        ) AS source,

        (
            SELECT value.string_value
            FROM UNNEST(event_params)
            WHERE key = 'medium'
        ) AS medium,

        (
            SELECT value.string_value
            FROM UNNEST(event_params)
            WHERE key = 'campaign'
        ) AS campaign

    FROM
        `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE
        user_pseudo_id IS NOT NULL
),

sessions AS (
    SELECT
        user_pseudo_id,
        ga_session_id,

        MIN(event_timestamp) AS session_start_timestamp,
        MAX(event_timestamp) AS session_end_timestamp,

        ARRAY_AGG(
            STRUCT(
                source AS source,
                medium AS medium,
                campaign AS campaign
            )
            ORDER BY
                CASE
                    WHEN source IS NOT NULL
                      OR medium IS NOT NULL
                      OR campaign IS NOT NULL
                    THEN 0
                    ELSE 1
                END,
                event_timestamp
            LIMIT 1
        )[OFFSET(0)] AS touchpoint,

        COUNT(*) AS total_events,
        COUNTIF(event_name = 'purchase') AS purchase_events,

        SUM(
            IF(
                event_name = 'purchase',
                COALESCE(revenue_usd, 0),
                0
            )
        ) AS revenue_usd

    FROM events
    WHERE ga_session_id IS NOT NULL
    GROUP BY
        user_pseudo_id,
        ga_session_id
)

SELECT
    user_pseudo_id,
    ga_session_id,

    TIMESTAMP_MICROS(session_start_timestamp) AS session_start,
    TIMESTAMP_MICROS(session_end_timestamp) AS session_end,

    COALESCE(touchpoint.source, '(not set)') AS marketing_source,
    COALESCE(touchpoint.medium, '(not set)') AS marketing_medium,
    COALESCE(touchpoint.campaign, '(not set)') AS campaign_name,

    total_events,
    purchase_events,
    revenue_usd

FROM sessions
