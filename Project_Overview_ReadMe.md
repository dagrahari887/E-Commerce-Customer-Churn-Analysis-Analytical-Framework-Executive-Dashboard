# Project Overview — Dashboards for Customer Churn Analysis

A plain-English guide to what this project is, what was built, and how the pieces fit together. Read this first, then open the other files.

---

## 1. What this project is

Your capstone brief asked you to demonstrate the full Business Analytics workflow — stakeholder analysis, requirements engineering, process mapping (UML), a BRD, and an Excel dashboard — using a **simulated dataset** modeled on a real Kaggle dataset.

The scenario: an e-commerce company wants to know **who is churning, why, and who to prioritize for retention** — and currently has no systematic way to answer that.

---

## 2. The four files you have

| File | What it is | When you'd open it |
|---|---|---|
| **Customer_Churn_BRD.docx** | The formal Business Requirements Document | To read/edit the written analysis, or submit as-is |
| **Customer_Churn_Dashboard.xlsx** | The Excel workbook: data, formulas, and dashboard | To explore the data, tweak formulas, or demo the dashboard |
| **uml_activity_diagram.png** | The process diagram (also embedded in the BRD) | If you want it standalone, e.g. for slides |
| **ecommerce_churn_simulated.csv** | The raw simulated dataset by itself | If you want the data outside Excel |

---

## 3. How the dataset was built

The real Kaggle dataset ("Ecommerce Customer Churn Analysis and Prediction") has ~5,630 customers across 20 columns (tenure, satisfaction score, complaints, payment mode, etc.). Rather than downloading it, I **simulated a new dataset with the same structure** — 1,500 customers, same 20 columns, realistic distributions, and churn logic wired so that churn is genuinely driven by satisfaction, complaints, and recency (not random). This is exactly what your brief asks for ("create a suitable simulated dataset").

Result: **14.3% overall churn rate**, with a small % of missing values injected on purpose (like a real data extract would have), so the workbook has something real to clean.

---

## 4. How the Excel workbook is organized

Open the workbook and move through the tabs left to right — each one builds on the last:

1. **README** — orientation tab inside the workbook itself.
2. **Raw Data** — the 1,500-row dataset exactly as "extracted," including gaps. This is the only tab meant to be edited directly (shaded yellow).
3. **Lookup Tables** — small reference tables (e.g. City Tier 1/2/3 → readable labels) used by lookup formulas elsewhere.
4. **Cleaned Data** — a full formula-driven copy of Raw Data:
   - Missing values are filled in using `AVERAGE`-based formulas (not typed in manually).
   - Extra columns are calculated: **City Tier Label** (`INDEX`/`MATCH`), **Tenure Bucket** and **Risk Segment** (nested `IF`).
   - The **Risk Segment** is the key output: every customer is tagged High / Medium / Low Risk based on whether they complained, how satisfied they are, and how long since their last order.
5. **Summary Calculations** — ten breakdown tables using `COUNTIFS`/`AVERAGEIFS`, e.g. "churn rate by City Tier," "churn rate by Risk Segment," "average cashback: churned vs retained." This is the pivot-style layer that feeds the dashboard.
6. **Dashboard** — the presentation layer: 6 KPI cards (Total Customers, Churn Rate, High-Risk Count, etc.) and 9 charts, all pulling live from Summary Calculations.

**The important part:** everything downstream of Raw Data is a formula. If you edit a value in Raw Data, the cleaning, the segment tables, and the dashboard all recalculate automatically — nothing is hardcoded.

---

## 5. What the data actually shows

- Customers who **filed a complaint** churn at a noticeably higher rate than those who didn't.
- **High Risk** customers (complaint + low satisfaction) churn at roughly double the rate of Low Risk customers.
- Churn is highest among customers with **short tenure** (0–6 months) and drops off sharply after 24 months — newer customers are the most fragile.
- **Mobile Phone** category and **Computer** login device show slightly elevated churn versus other segments — worth a closer look operationally, though the differences are modest.

These are the findings the BRD's Executive Summary and the dashboard both point to — use them as your talking points in the viva.

---

## 6. How the BRD is structured

The Word document follows a standard BRD shape, each section mapping directly to a learning outcome from your brief:

| BRD Section | Learning outcome it demonstrates |
|---|---|
| 1. Executive Summary | Business problem framing |
| 2. Business Problem & Objectives | Problem decomposition |
| 3. Scope (in/out) | Requirement engineering / boundaries |
| 4. Stakeholder Analysis + Constraints & Trade-offs | Stakeholder analysis, constraints, trade-offs |
| 5. Functional & Non-Functional Requirements | Requirement engineering |
| 6. Business Process Mapping + UML Activity Diagram | Process mapping / UML |
| 7. Data Requirements & Measurable Variables | Identification of measurable variables |
| 8. Success Metrics | Ties requirements back to outcomes |
| 9. Assumptions, Constraints & Risks | Trade-off reasoning |

---

## 7. The UML diagram, in one paragraph

Three swimlanes: **Data Team** (extract → clean → load), **Dashboard System** (calculate KPIs → refresh → flag high-risk customers, with a decision point for "any high-risk customers this cycle?"), and **Retention Team** (review the list → check budget feasibility → reach out → log whether the customer was retained, churned, or declined). It's a closed loop: every outcome gets logged, which is what makes the process repeatable rather than a one-off.

---

## 8. If you get asked in the viva...

- **"Why simulated data, not the real Kaggle file?"** — The brief explicitly asks for a simulated dataset; this also means no data-privacy concern and full control over demonstrating the cleaning/formula logic.
- **"Why rule-based Risk Segment instead of a machine-learning model?"** — Explainability. A retention manager can audit *why* someone is flagged (complaint + low satisfaction + recency), which a black-box model wouldn't offer, and predictive modeling is explicitly out of scope per Section 3.2 of the BRD.
- **"What happens if you add more rows to Raw Data?"** — Everything recalculates automatically, because Cleaned Data, Summary Calculations, and the Dashboard are all formulas, not pasted values. (Note: the Excel Tables and chart ranges are sized to 1,500 rows — if you add rows beyond that, extend the table ranges first.)
- **"What's the trade-off you're most proud of identifying?"** — Probably the budget-feasibility decision point in the UML diagram: it acknowledges that not every at-risk customer can realistically be reached, which is a constraint stakeholders explicitly raised (Finance / Retention headcount).

---

## 9. Before you submit

- Everything is unlocked — no protected sheets, no hidden formulas — so open it up and make it yours: adjust colors, tone, thresholds, or wording.
- Recalculation was verified with 0 formula errors across the whole workbook.
- If you want a shorter or longer BRD, different chart types, or a slide deck version for the viva, just ask.
