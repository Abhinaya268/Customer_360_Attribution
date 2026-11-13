
{{ config(materialized='view') }}

WITH campaign_revenue AS (
    SELECT
        marketing_source,
        marketing_medium,
        campaign_name,
        SUM(attributed_conversions) AS conversions,
        SUM(attributed_revenue_usd) AS revenue_usd

    FROM {{ ref('attribution_models') }}

    WHERE attribution_model = 'last_touch'

    GROUP BY
        marketing_source,
        marketing_medium,
        campaign_name
)

SELECT
    s.marketing_source,
    s.marketing_medium,
    s.campaign_name,
    s.spend_usd,
    s.spend_type,

    COALESCE(r.conversions, 0) AS conversions,
    COALESCE(r.revenue_usd, 0) AS revenue_usd,

    ROUND(
        SAFE_DIVIDE(s.spend_usd, r.conversions),
        2
    ) AS cpa_usd,

    ROUND(
        SAFE_DIVIDE(
            r.revenue_usd - s.spend_usd,
            s.spend_usd
        ) * 100,
        2
    ) AS roi_percent,

    ROUND(
        SAFE_DIVIDE(r.revenue_usd, s.spend_usd),
        2
    ) AS roas

FROM
    `customer-360-analytics-513215.customer360_raw.campaign_ad_spend` s

LEFT JOIN campaign_revenue r
    ON s.marketing_source = r.marketing_source
    AND s.marketing_medium = r.marketing_medium
    AND s.campaign_name = r.campaign_name
