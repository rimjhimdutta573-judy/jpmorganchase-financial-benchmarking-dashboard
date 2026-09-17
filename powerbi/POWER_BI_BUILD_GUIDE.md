# JPMorganChase SQL + Power BI build guide

## Purpose

The existing Excel workbook remains the original analysis. This extension demonstrates a controlled relational model, SQL validation and a Power BI reporting layer. The dataset is small by design; do not describe it as a warehouse, real-time system or large-scale ETL.

## Preflight

1. Confirm MySQL Server 8.0 is running. MySQL Workbench alone is not enough.
2. In MySQL Workbench, run `SELECT VERSION();` and confirm the major version is 8.
3. Confirm Power BI Desktop is installed.
4. If Power BI cannot see MySQL, install the MySQL Connector/NET version recommended by the current Power BI prompt, restart Power BI, and retry.
5. Never save a password, connection string or personal Windows path in GitHub.

## Build the database

Run the SQL files in this exact order from the repository root:

1. `sql/01_create_schema.sql`
2. `sql/02_seed_data.sql`
3. `sql/03_create_views.sql`
4. `sql/05_validation_queries.sql`

Every validation must pass. Do not continue if a test fails.

The final model has:

- `dim_metric`: 37 rows
- `dim_period`: 5 rows
- `fact_metric_value`: 185 rows
- Fact-table grain: one metric in one quarter
- Primary key: `metric_id + period_id`

## Connect Power BI

1. Open Power BI Desktop.
2. Select **Get data > MySQL database**.
3. Server: `localhost` or the server name confirmed in Workbench.
4. Database: `jpmc_finance_analytics`.
5. Select **Import**, not DirectQuery.
6. Load `dim_metric`, `dim_period`, `fact_metric_value` and the SQL view `vw_revenue_latest_qoq`.
7. In Model view create two one-to-many, single-direction relationships:
   - `dim_metric[metric_id]` (1) to `fact_metric_value[metric_id]` (*)
   - `dim_period[period_id]` (1) to `fact_metric_value[period_id]` (*)
8. Sort `dim_period[period_label]` by `dim_period[period_sort]`.
9. Hide key columns from report view after relationships are working.
10. Add the measures from `JPMC_DAX_MEASURES.dax` one at a time.
11. Keep `vw_revenue_latest_qoq` disconnected. It is a validated, latest-quarter SQL result used only by Page 1; the star schema drives Page 2.
12. Select **View > Themes > Browse for themes** and import `powerbi/theme.json`.

## Page 1: Revenue variance

Use the disconnected `vw_revenue_latest_qoq` view. It is already filtered by SQL to reported `$mm` Revenue metrics.

Add:

1. Card: `[Revenue Current Value]`. Apply visual filter `metric_id = M030`.
2. Card: `[Revenue Current Value]`. Apply visual filter `metric_id = M021`.
3. Clustered bar chart:
   - Axis: `vw_revenue_latest_qoq[metric_name]`
   - Value: `[Revenue Comparable QoQ %]`
   - Filter: measure is not blank
   - Sort descending by the measure
4. Table using view fields: metric, previous value, latest value, absolute change and qoq_status. Set numeric columns to **Don't summarize**.
5. Text note: Other income includes event-driven Visa-related and equity-investment gains disclosed in the 2Q26 supplement.
6. Text note: Investment-securities gains/(losses) crosses zero and is shown as N/M, not ranked as growth.

Do not sum the revenue lines to recreate Total net revenue. Some lines are overlapping reported totals.

## Page 2: Financial and risk trends

1. Add a metric-name slicer and turn **Single select** on.
2. Add a five-quarter line chart:
   - X-axis: `dim_period[period_label]`
   - Y-axis: `[Metric Plot Value]`
   - Title or subtitle must include `[Selected Unit]`; percentage metrics are scaled from `0.57` to `57.0` for plotting.
3. Add cards: `[Latest Value Display]`, `[Previous Value Display]`, `[Absolute Change Display]`, `[QoQ Display]`.
4. Add metadata cards: `[Selected Unit]`, `[Selected Basis]`, `[Selected Source Page]`.
5. Default the slicer to Investment banking fees, then test at least one `%`, `$bn`, `#` and negative-value metric.
6. Never show totals across multiple selected metrics.

## Formatting and publication

- Currency charts must state `$mm` or `$bn` exactly as stored.
- Verify the loans-to-deposits ratio card displays `57.0%` and the trend plots it as `57.0` with `%` shown in the unit card/title.
- Use a restrained dark-blue theme and accessible contrast.
- Save as `powerbi/JPMC_Financial_Benchmarking_SQL_PowerBI.pbix`.
- Export the two report pages to `powerbi/JPMC_Financial_Benchmarking_SQL_PowerBI_Preview.pdf`.
- Add screenshots for both pages and the Model view.
- Before publication, clear cached credentials in **Data source settings** if any are stored.

## What Rimjhim must be able to explain

- Why 37 metrics × 5 quarters equals 185 fact rows.
- Why `Metric_ID` is the stable key.
- Why a real period date and sort field are needed.
- How `LAG()` retrieves the prior quarter.
- Why a cross-zero move is N/M.
- Why revenue, assets, ratios, risk and headcount cannot be aggregated together.
- Why Import mode is appropriate for a small static portfolio dataset.
