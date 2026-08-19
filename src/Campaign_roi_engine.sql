-- File: src/campaign_roi_engine.sql
-- Enterprise Practice: Elsamag IT Solutions
-- Author & Lead Technical Consultant: Samuel Chinwendu Agu
-- Objective: Production Join Engine for Multi-Channel Campaign Attribution and ROI Aggregation

WITH aggregated_spend AS (
    SELECT
        campaign_id,
        SUM(spend_amount) AS total_spend
    FROM ad_spend_daily
    GROUP BY campaign_id
),
aggregated_conversions AS (
    SELECT
        campaign_id,
        COUNT(conversion_id) AS total_conversions,
        SUM(revenue_generated) AS total_revenue
    FROM conversions
    GROUP BY campaign_id
)
SELECT
    c.campaign_id,
    c.campaign_name,
    c.channel_source,
    COALESCE(s.total_spend, 0.00) AS total_spend,
    COALESCE(v.total_conversions, 0) AS total_conversions,
    COALESCE(v.total_revenue, 0.00) AS total_revenue,
    CASE 
        WHEN COALESCE(v.total_conversions, 0) > 0 
        THEN ROUND(COALESCE(s.total_spend, 0.00) / v.total_conversions, 2)
        ELSE 0.00 
    END AS cac,
    CASE 
        WHEN COALESCE(s.total_spend, 0.00) > 0 
        THEN ROUND(COALESCE(v.total_revenue, 0.00) / s.total_spend, 2)
        ELSE 0.00 
    END AS roas
FROM campaigns c
LEFT JOIN aggregated_spend s
    ON c.campaign_id = s.campaign_id
LEFT JOIN aggregated_conversions v
    ON c.campaign_id = v.campaign_id
ORDER BY roas DESC;
