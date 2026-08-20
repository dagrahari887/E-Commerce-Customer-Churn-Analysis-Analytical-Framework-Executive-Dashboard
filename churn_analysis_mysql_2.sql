/* ====================================================================
   CUSTOMER CHURN ANALYSIS -- MySQL SCRIPT  (MySQL 8.0+ required for CTEs)
   Mirrors the same analysis built in the Excel workbook:
   Raw Data -> Lookup Tables -> Cleaned Data -> Summary Breakdowns
   ==================================================================== */

CREATE DATABASE IF NOT EXISTS churn_analysis;
USE churn_analysis;


/* ====================================================================
   1. RAW DATA TABLE
   ==================================================================== */
DROP TABLE IF EXISTS raw_customer_data;

CREATE TABLE raw_customer_data (
    customer_id                    INT PRIMARY KEY,
    churn                          TINYINT,          -- 0 = retained, 1 = churned
    tenure                         DECIMAL(10,2),
    preferred_login_device         VARCHAR(30),
    city_tier                      TINYINT,
    warehouse_to_home              DECIMAL(10,2),
    preferred_payment_mode         VARCHAR(30),
    gender                         VARCHAR(10),
    hour_spend_on_app              DECIMAL(10,2),
    number_of_device_registered    INT,
    prefered_order_cat             VARCHAR(30),
    satisfaction_score             TINYINT,
    marital_status                 VARCHAR(15),
    number_of_address              INT,
    complain                       TINYINT,          -- 0/1
    order_amount_hike_last_year    DECIMAL(10,2),
    coupon_used                    INT,
    order_count                    INT,
    day_since_last_order           DECIMAL(10,2),
    cashback_amount                DECIMAL(10,2)
);

-- Load the simulated dataset (adjust path as needed).
-- Requires local_infile=1 on both server and client:
--   SET GLOBAL local_infile = 1;
-- Connect with: mysql --local-infile=1 -u <user> -p churn_analysis
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/E Commerce Dataset.csv'
INTO TABLE raw_customer_data
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, churn, tenure, preferred_login_device, city_tier, @warehouse_to_home,
 preferred_payment_mode, gender, @hour_spend_on_app, number_of_device_registered,
 prefered_order_cat, satisfaction_score, marital_status, number_of_address, complain,
 @order_amount_hike_last_year, @coupon_used, order_count, @day_since_last_order, cashback_amount)
SET
    warehouse_to_home        = NULLIF(@warehouse_to_home, ''),
    hour_spend_on_app         = NULLIF(@hour_spend_on_app, ''),
    order_amount_hike_last_year = NULLIF(@order_amount_hike_last_year, ''),
    coupon_used                = NULLIF(@coupon_used, ''),
    day_since_last_order       = NULLIF(@day_since_last_order, '');
    
    /* ====================================================================
   2. LOOKUP TABLES  (same reference tables as the workbook's "Lookup Tables" sheet)
   ==================================================================== */
DROP TABLE IF EXISTS city_tier_lookup;
CREATE TABLE city_tier_lookup (
    city_tier       TINYINT PRIMARY KEY,
    city_tier_label VARCHAR(40)
);
INSERT INTO city_tier_lookup VALUES
    (1, 'Tier 1 (Metro)'),
    (2, 'Tier 2 (Urban)'),
    (3, 'Tier 3 (Semi-urban/Rural)');

DROP TABLE IF EXISTS satisfaction_lookup;
CREATE TABLE satisfaction_lookup (
    satisfaction_score TINYINT PRIMARY KEY,
    satisfaction_label VARCHAR(20)
);
INSERT INTO satisfaction_lookup VALUES
    (1, 'Very Low'), (2, 'Low'), (3, 'Neutral'), (4, 'High'), (5, 'Very High');


/* ====================================================================
   3. CLEANED DATA VIEW
   - Missing numeric values imputed with column average (same rule as the
     workbook's Cleaned Data sheet).
   - Derived fields: city_tier_label, tenure_bucket, risk_segment, churn_label.
   ==================================================================== */
DROP VIEW IF EXISTS cleaned_data;

CREATE VIEW cleaned_data AS
WITH col_averages AS (
    SELECT
        ROUND(AVG(warehouse_to_home), 1)           AS avg_warehouse_to_home,
        ROUND(AVG(hour_spend_on_app), 1)           AS avg_hour_spend_on_app,
        ROUND(AVG(order_amount_hike_last_year), 1) AS avg_order_amount_hike,
        ROUND(AVG(coupon_used))                    AS avg_coupon_used,
        ROUND(AVG(day_since_last_order))           AS avg_day_since_last_order
    FROM raw_customer_data
)
SELECT
    r.customer_id,
    r.churn,
    r.tenure,
    r.preferred_login_device,
    r.city_tier,
    COALESCE(r.warehouse_to_home, a.avg_warehouse_to_home)          AS warehouse_to_home,
    r.preferred_payment_mode,
    r.gender,
    COALESCE(r.hour_spend_on_app, a.avg_hour_spend_on_app)          AS hour_spend_on_app,
    r.number_of_device_registered,
    r.prefered_order_cat,
    r.satisfaction_score,
    r.marital_status,
    r.number_of_address,
    r.complain,
    COALESCE(r.order_amount_hike_last_year, a.avg_order_amount_hike) AS order_amount_hike_last_year,
    COALESCE(r.coupon_used, a.avg_coupon_used)                      AS coupon_used,
    r.order_count,
    COALESCE(r.day_since_last_order, a.avg_day_since_last_order)    AS day_since_last_order,
    r.cashback_amount,

    -- lookup: city tier label
    ct.city_tier_label,

    -- derived: tenure bucket (nested IF equivalent)
    CASE
        WHEN r.tenure <= 6  THEN '0-6 months'
        WHEN r.tenure <= 12 THEN '7-12 months'
        WHEN r.tenure <= 24 THEN '13-24 months'
        ELSE '25+ months'
    END AS tenure_bucket,
    -- derived: risk segment (same rule as the workbook)
    CASE
        WHEN r.complain = 1 AND r.satisfaction_score <= 2 THEN 'High Risk'
        WHEN r.satisfaction_score = 3
             OR COALESCE(r.day_since_last_order, a.avg_day_since_last_order) > 15 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_segment,

    CASE WHEN r.churn = 1 THEN 'Yes' ELSE 'No' END AS churn_label

FROM raw_customer_data r
CROSS JOIN col_averages a
LEFT JOIN city_tier_lookup ct ON ct.city_tier = r.city_tier;



/* ====================================================================
   4. DASHBOARD KPIs  (mirrors the Dashboard sheet's KPI cards)
   ==================================================================== */
SELECT
    COUNT(*)                                                     AS total_customers,
    SUM(churn)                                                    AS churned_customers,
    ROUND(AVG(churn) * 100, 1)                                     AS overall_churn_rate_pct,
    SUM(CASE WHEN risk_segment = 'High Risk' THEN 1 ELSE 0 END)   AS high_risk_customers,
    ROUND(AVG(satisfaction_score), 2)                              AS avg_satisfaction_score,
    SUM(complain)                                                  AS customers_with_complaints
FROM cleaned_data;


/* ====================================================================
   5. CHURN RATE BREAKDOWNS  (mirrors the Summary Calculations sheet, tables 1-9)
   ==================================================================== */

-- 5.1 Churn Rate by City Tier
SELECT
    city_tier_label,
    COUNT(*)                   AS customers,
    SUM(churn)                  AS churned,
    ROUND(AVG(churn) * 100, 1)   AS churn_rate_pct
FROM cleaned_data
GROUP BY city_tier_label
ORDER BY churn_rate_pct DESC;

-- 5.2 Churn Rate by Preferred Order Category
SELECT
    prefered_order_cat,
    COUNT(*)                   AS customers,
    SUM(churn)                  AS churned,
    ROUND(AVG(churn) * 100, 1)   AS churn_rate_pct
FROM cleaned_data
GROUP BY prefered_order_cat
ORDER BY churn_rate_pct DESC;

-- 5.3 Churn Rate by Preferred Payment Mode
SELECT
    preferred_payment_mode,
    COUNT(*)                   AS customers,
    SUM(churn)                  AS churned,
    ROUND(AVG(churn) * 100, 1)   AS churn_rate_pct
FROM cleaned_data
GROUP BY preferred_payment_mode
ORDER BY churn_rate_pct DESC;

-- 5.4 Churn Rate by Login Device
SELECT
    preferred_login_device,
    COUNT(*)                   AS customers,
    SUM(churn)                  AS churned,
    ROUND(AVG(churn) * 100, 1)   AS churn_rate_pct
FROM cleaned_data
GROUP BY preferred_login_device
ORDER BY churn_rate_pct DESC;

-- 5.5 Churn Rate by Marital Status
SELECT
    marital_status,
    COUNT(*)                   AS customers,
    SUM(churn)                  AS churned,
    ROUND(AVG(churn) * 100, 1)   AS churn_rate_pct
FROM cleaned_data
GROUP BY marital_status
ORDER BY churn_rate_pct DESC;

-- 5.6 Churn Rate by Satisfaction Score
SELECT
    satisfaction_score,
    COUNT(*)                   AS customers,
    SUM(churn)                  AS churned,
    ROUND(AVG(churn) * 100, 1)   AS churn_rate_pct
FROM cleaned_data
GROUP BY satisfaction_score
ORDER BY satisfaction_score;

-- 5.7 Churn Rate by Risk Segment
SELECT
    risk_segment,
    COUNT(*)                   AS customers,
    SUM(churn)                  AS churned,
    ROUND(AVG(churn) * 100, 1)   AS churn_rate_pct
FROM cleaned_data
GROUP BY risk_segment
ORDER BY churn_rate_pct DESC;

-- 5.8 Churn Rate by Tenure Bucket
SELECT
    tenure_bucket,
    COUNT(*)                   AS customers,
    SUM(churn)                  AS churned,
    ROUND(AVG(churn) * 100, 1)   AS churn_rate_pct
FROM cleaned_data
GROUP BY tenure_bucket
ORDER BY
    CASE tenure_bucket
        WHEN '0-6 months'   THEN 1
        WHEN '7-12 months'  THEN 2
        WHEN '13-24 months' THEN 3
        ELSE 4
    END;

-- 5.9 Churn Rate by Complaint Filed
SELECT
    CASE WHEN complain = 1 THEN 'Complaint Filed' ELSE 'No Complaint' END AS complaint_status,
    COUNT(*)                   AS customers,
    SUM(churn)                  AS churned,
    ROUND(AVG(churn) * 100, 1)   AS churn_rate_pct
FROM cleaned_data
GROUP BY complain
ORDER BY complain DESC;


/* ====================================================================
   6. BEHAVIOURAL AVERAGES: CHURNED VS RETAINED (mirrors Summary table 10)
   ==================================================================== */
SELECT
    churn_label,
    ROUND(AVG(tenure), 2)               AS avg_tenure,
    ROUND(AVG(satisfaction_score), 2)   AS avg_satisfaction_score,
    ROUND(AVG(day_since_last_order), 2) AS avg_day_since_last_order,
    ROUND(AVG(cashback_amount), 2)      AS avg_cashback_amount,
    ROUND(AVG(order_count), 2)          AS avg_order_count,
    ROUND(AVG(coupon_used), 2)          AS avg_coupon_used
FROM cleaned_data
GROUP BY churn_label;


/* ====================================================================
   7. HIGH-RISK CUSTOMER LIST  (for the Retention Team's "review at-risk list"
      step in the UML process)
   ==================================================================== */
SELECT
    customer_id,
    tenure,
    satisfaction_score,
    complain,
    day_since_last_order,
    cashback_amount,
    risk_segment
FROM cleaned_data
WHERE risk_segment = 'High Risk'
ORDER BY day_since_last_order DESC, satisfaction_score ASC;

    
    
    
    