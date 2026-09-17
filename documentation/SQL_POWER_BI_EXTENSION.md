# SQL and Power BI extension

## Scope

This additive extension normalizes the existing `Raw_Data` sheet into a MySQL 8 star schema and uses it as the source for a two-page Power BI report. The original Excel workbook and its calculations are unchanged.

## Data model

- `dim_metric`: metric identity, category, unit, reporting basis and source page.
- `dim_period`: chronological period label, end date and sort fields.
- `fact_metric_value`: one metric-period observation.

Expected row counts are 37, 5 and 185 respectively. The fact-table primary key is `(metric_id, period_id)`.

## Transformation and controls

The export script reads only `Raw_Data`. It rejects missing columns, duplicate metric IDs, a metric count other than 37, a fact count other than 185 and missing observations. It regenerates both the three CSV tables and `sql/02_seed_data.sql` from the same workbook-derived rows, preventing the database seed from drifting from the exported data.

The SQL layer preserves the workbook's quarter-on-quarter rule:

- Prior value zero: N/M.
- Current and prior values have different signs: N/M.
- Otherwise: `(current - prior) / ABS(prior)`.

The quality script tests row counts, key uniqueness, foreign-key coverage, observations per metric and period, and selected filing values.

## Power BI scope

- Revenue variance page: reported `$mm` Revenue metrics only.
- Metric explorer: mandatory single-selected metric and five-quarter history.

Metrics with different units or economic meanings are never aggregated into a universal total or ranking.

## Known source limitation

Several legacy pivot tabs in the original workbook contain cached Revenue rows despite category-specific names. They are outside this extension's source path. `Raw_Data` is the sole source for the SQL and Power BI layers.

## Reproduction

1. Run `scripts/export_from_excel.py`.
2. Run the SQL files in numeric order.
3. Require every validation query to pass.
4. Refresh the Power BI Import model.
5. Compare the preview PDF and screenshots with the final PBIX.
