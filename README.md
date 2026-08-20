# E-Commerce-Customer-Churn-Analysis-Analytical-Framework-Executive-Dashboard
A comprehensive end-to-end business analytics project that transforms raw e-commerce operational data into an executive-level decision engine. This framework equips retention and marketing teams with transparent risk segmentation, structured business requirements, and an automated Excel dashboard to reduce customer churn.
# E-Commerce Customer Churn Analysis — Analytical Framework & Executive Dashboard

A comprehensive end-to-end business analytics project that transforms raw e-commerce operational data into an executive-level decision engine. This framework equips retention and marketing teams with transparent risk segmentation, structured business requirements, and an automated Excel dashboard to reduce customer churn.

---

## Overview

E-commerce organizations frequently struggle to identify churn drivers and prioritize retention intervention without automated tools. Traditional, reactive retention approaches fail to reach high-risk customers before they disengage.

This project simulates a **1,500-customer e-commerce dataset** modeled after real-world retail behavioral metrics (tenure, satisfaction scores, order recency, and customer service complaints). Through dynamic formula-driven data cleansing, automated rule-based risk profiling, and pivot-free summary logic, the system isolates high-risk churn signals and serves them via a live executive dashboard.

---

## Features & Highlights

* **Realistic Data Simulation Model:** Features 1,500 customer records across 20 operational parameters (e.g., cashback amounts, preferred login devices, city tiers, and complaint logs). Includes deliberate missing data to demonstrate formulaic imputation techniques.
* **Automated Data Cleaning & Transformation:** Utilizes formula-driven imputation (`AVERAGE`-based backfills) and structured calculations (`INDEX/MATCH` lookup tables, nested `IF` risk logic) to handle cleaning without manual data manipulation.
* **Auditable Rule-Based Risk Segmentation:** Tagged into `High`, `Medium`, or `Low Risk` segments using explicit business logic (complaints filed, low satisfaction ratings, and long recency) to maintain full auditability for business stakeholders.
* **Full Requirements & Process Engineering:** Includes a formal Business Requirements Document (BRD) and a 3-swimlane UML Activity Diagram detailing closed-loop operations from raw extraction to retention dispatch.
* **Automated Excel Executive Dashboard:** Features 6 real-time KPI summary cards and 9 visual charts driven entirely by dynamic formulas (`COUNTIFS`/`AVERAGEIFS`), enabling instant recalculation upon raw data updates.

---

## Project Structure

```text
.
├── Customer_Churn_BRD.docx           # Formal Business Requirements Document (BRD)
├── Customer_Churn_Dashboard.xlsx     # Interactive Excel Workbook (Data, Cleansing, Summaries, Dashboard)
├── uml_activity_diagram.png          # Process Flowchart / Activity Diagram (Embedded in BRD)
├── ecommerce_churn_simulated.csv     # Raw simulated dataset (1,500 customer records)
└── README.md                         # Project documentation and execution guide+------------------------------------------+
|       Raw Data Extraction (1,500 rows)   |
| (Tenure, Satisfaction, Complaints, etc.) |
+------------------------------------------+
                     |
                     v
+------------------------------------------+
|  Formula-Driven Cleansing & Imputation   |
|  (AVERAGE Imputation & Lookup Backfills) |
+------------------------------------------+
                     |
                     v
+------------------------------------------+
|     Rule-Based Risk Segmentation         |
|  - High Risk: Complaint + Low Sat + Recency|
|  - Medium Risk: Single Negative Signal   |
|  - Low Risk: Highly Engaged / Satisfied  |
+------------------------------------------+
         /                        \
        v                          v
+-----------------------+  +----------------------------------+
| Summary Calculations  |  | Business Requirements (BRD)      |
| - COUNTIFS / AVERAGEIFS|  | - Process Mapping (UML Flow)     |
| - Segment Breakdowns  |  | - Stakeholder & KPI Alignment    |
+-----------------------+  +----------------------------------+
        \                          /
         v                        v
+------------------------------------------+
|        Executive Excel Dashboard         |
| (6 Live KPI Cards & 9 Visual Analytics)  |
+------------------------------------------+
Business Logic & Risk Rules
1. Risk Segment Definition
Customers are classified into actionable risk buckets based on key behavioral markers:

High Risk: Customers who filed a complaint, possess a low satisfaction score, and have high order recency gaps.

Medium Risk: Customers showing a single negative indicator (e.g., low satisfaction without a formal complaint).

Low Risk: Engaged customers with high tenure, high satisfaction scores, and no complaint logs.

2. Key Findings & Insights
Complaint Impact: Customers filing formal support complaints exhibit double the baseline churn rate compared to non-complainers.

Tenure Vulnerability: Churn is heavily concentrated in early customer lifecycles (0–6 months tenure) and drops substantially after 24 months of activity.

Category Variations: Mobile Phone and Computer login channels demonstrate slightly elevated churn levels relative to standard desktop usage.

Excel Workbook Architecture (Customer_Churn_Dashboard.xlsx)
The workbook is structured into sequential tabs from left to right:

README: Orientation and tab directory embedded directly in the workbook.

Raw Data: The unedited 1,500-row simulated dataset with deliberate missing values (shaded yellow for reference).

Lookup Tables: Categorical references (e.g., City Tier mappings) used by downstream lookup formulas.

Cleaned Data: Fully formula-driven transformation copy containing:

Imputed values using AVERAGE logic.

Category labels derived via INDEX/MATCH.

Risk Segment classifications derived using nested IF statements.

Summary Calculations: 10 aggregation tables built using COUNTIFS and AVERAGEIFS that act as a dynamic data feed for visual components.

Dashboard: Executive view containing 6 primary KPI cards and 9 interactive charts.

Instructions & Usage
1. Navigating the Excel Workbook
Open Customer_Churn_Dashboard.xlsx.

Move through the tabs from left to right.

To test dynamic updating: adjust any numerical or categorical value in the Raw Data tab to observe automated recalculations across Cleaned Data, Summary Calculations, and the Dashboard layer.

2. Reviewing Documentation
Open Customer_Churn_BRD.docx for the full Business Requirements Document, scope boundaries, stakeholder matrices, and process specifications.

Review uml_activity_diagram.png for a standalone high-resolution view of the closed-loop retention workflow.
