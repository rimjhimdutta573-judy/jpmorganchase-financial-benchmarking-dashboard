# JPMC Power BI model specification

## Tables

### dim_metric

Primary key: `metric_id`.

Fields: category, metric name, unit, basis and source page. Do not aggregate `source_page`.

### dim_period

Primary key: `period_id`.

Sort `period_label` by `period_sort`. The five periods run chronologically from 2Q25 to 2Q26.

### fact_metric_value

Composite grain: one `metric_id` and one `period_id`.

`metric_value` is Decimal Number. Its display format depends on the selected metric's unit.

### vw_revenue_latest_qoq

Disconnected import of the validated SQL view for Page 1 only. It contains the ten latest reported `$mm` Revenue records, including SQL-calculated prior value, absolute change, comparability status and percentage change. Do not relate it to the star schema.

## Relationships

- `dim_metric[metric_id]` 1 -> * `fact_metric_value[metric_id]`
- `dim_period[period_id]` 1 -> * `fact_metric_value[period_id]`

Both relationships use single-direction filtering from dimension to fact. There is no direct relationship between the dimensions.

## Measures

The complete copy-ready definitions are in `JPMC_DAX_MEASURES.dax`.

- Metric Value returns blank unless one metric is selected.
- Metric Plot Value scales ratio values by 100 for the numeric trend axis while preserving all other units.
- Latest and Previous Value use the maximum period sort and the immediately preceding sort.
- Comparable QoQ Change returns blank when the denominator is zero or signs differ.
- QoQ Display returns N/M for those non-comparable cases.
- Display measures format percentage, currency and headcount cards without changing stored values.
- Metadata measures expose unit, basis and source page.
- Revenue-prefixed measures read Page 1 directly from the SQL view, proving that the SQL comparison logic materially feeds the report.

## Visual-level restrictions

- Revenue page filters: category Revenue, unit `$mm`, basis Reported.
- Metric explorer slicer: Single select enabled.
- Cross-zero values excluded from percentage ranking.
- No grand total across metrics.
- No chart combines currency, percentage, headcount or `$bn` values on one axis.

## Validation targets

- 37 metrics, 5 periods and 185 facts.
- 9 comparable Revenue changes and 1 N/M Revenue change.
- M026: 64 to -395, N/M.
- M021: 2,858 to 3,208, 12.2463%.
- M029: 1,671 to 7,549, 351.7654%.
- M030: 49,836 to 57,347, 15.0714%.
