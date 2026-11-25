# Healthcare Data Analysis (MySQL)

SQL analysis of a hospital patient dataset. It answers 22 business questions about patients, medical conditions, hospitals, insurance and billing.

## Tools
MySQL · SQL (aggregations, window functions, subqueries, CASE, stored procedures, date functions)

## What I did
**Data preparation**
- Imported the dataset, renamed the table, and converted the admission and discharge dates from text to proper `DATE` columns using `STR_TO_DATE`.

**Patient analysis**
- Total records, maximum and average patient age
- Patient counts by age, and age ranked by number of admissions using `DENSE_RANK()`
- Blood type distribution, including patients aged 20–45

**Medical and hospital analysis**
- Most common medical conditions
- Most prescribed medication for each condition using `RANK() OVER (PARTITION BY ...)`
- Most preferred hospitals, and admissions per hospital for 2024 and 2025
- Length of stay with `DATEDIFF`, and the hospitals discharging the most patients with *Normal* test results

**Billing and insurance**
- Average billing amount by medical condition
- Average, minimum, maximum and total billing per insurance provider
- Most preferred insurance provider

**Advanced SQL**
- **Risk categorisation:** labelled patients as low, medium or high risk based on test results using `CASE`
- **Blood donor matching:** wrote a stored procedure, `Blood_Matcher`, that finds universal donors (O−, aged 20–40) for a universal recipient (AB+) by patient name

## Files
| File | Description |
|---|---|
| `healthcare_analysis.sql` | All queries, each with a comment describing the question |

## Dataset
Public healthcare dataset. It has patient name, age, blood type, medical condition, admission and discharge dates, hospital, insurance provider, billing amount, medication and test results.

---
*Project completed as part of the Data Analytics program at Topmentor (2026).*
