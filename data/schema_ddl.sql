-- File: data/schema_ddl.sql
-- Enterprise Practice: Elsamag IT Solutions
-- Author & Lead Technical Consultant: Samuel Chinwendu Agu
-- Objective: Relational Schema DDL Definition for Marketing Attribution Model

CREATE TABLE campaigns (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(100) NOT NULL,
    channel_source VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE
);

CREATE TABLE ad_spend_daily (
    spend_id SERIAL PRIMARY KEY,
    campaign_id INT NOT NULL REFERENCES campaigns(campaign_id),
    spend_date DATE NOT NULL,
    spend_amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00
);

CREATE TABLE conversions (
    conversion_id SERIAL PRIMARY KEY,
    campaign_id INT NOT NULL REFERENCES campaigns(campaign_id),
    conversion_timestamp TIMESTAMP NOT NULL,
    revenue_generated NUMERIC(12, 2) NOT NULL DEFAULT 0.00
);

CREATE INDEX idx_ad_spend_campaign ON ad_spend_daily(campaign_id);
CREATE INDEX idx_conversions_campaign ON conversions(campaign_id);
