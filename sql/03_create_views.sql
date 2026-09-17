USE jpmc_finance_analytics;

CREATE OR REPLACE VIEW vw_metric_trend AS
SELECT
  m.metric_id,
  m.category,
  m.metric_name,
  m.unit,
  m.basis,
  m.source_page,
  q.period_label,
  q.period_end_date,
  q.fiscal_year,
  q.quarter_number,
  q.period_sort,
  f.metric_value
FROM fact_metric_value AS f
JOIN dim_metric AS m ON m.metric_id = f.metric_id
JOIN dim_period AS q ON q.period_id = f.period_id;

CREATE OR REPLACE VIEW vw_metric_qoq AS
SELECT
  x.*,
  CASE
    WHEN x.previous_value IS NULL THEN NULL
    ELSE x.metric_value - x.previous_value
  END AS absolute_change,
  CASE
    WHEN x.previous_value IS NULL THEN 'NO PRIOR PERIOD'
    WHEN x.previous_value = 0 THEN 'N/M'
    WHEN SIGN(x.previous_value) <> SIGN(x.metric_value) THEN 'N/M'
    ELSE 'COMPARABLE'
  END AS qoq_status,
  CASE
    WHEN x.previous_value IS NULL THEN NULL
    WHEN x.previous_value = 0 THEN NULL
    WHEN SIGN(x.previous_value) <> SIGN(x.metric_value) THEN NULL
    ELSE (x.metric_value - x.previous_value) / ABS(x.previous_value)
  END AS qoq_change_pct
FROM (
  SELECT
    t.*,
    LAG(t.metric_value) OVER (
      PARTITION BY t.metric_id
      ORDER BY t.period_sort
    ) AS previous_value
  FROM vw_metric_trend AS t
) AS x;

CREATE OR REPLACE VIEW vw_latest_qoq AS
SELECT q.*
FROM vw_metric_qoq AS q
WHERE q.period_sort = (SELECT MAX(period_sort) FROM dim_period);

CREATE OR REPLACE VIEW vw_revenue_latest_qoq AS
SELECT *
FROM vw_latest_qoq
WHERE category = 'Revenue' AND unit = '$mm' AND basis = 'Reported';
