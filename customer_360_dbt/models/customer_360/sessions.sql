
{{ config(materialized='view') }}

WITH events AS (
    SELECT
        user_pseudo_id,
        event_timestamp,
        event_name,
        (
            SELECT value.int_value
            FROM UNNEST(event_params)
            WHERE key = 'ga_session_id'
        ) AS ga_session_id
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
        COUNT(*) AS total_events,
        COUNTIF(event_name = 'purchase') AS purchase_events
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
    total_events,
    purchase_events
FROM sessions
