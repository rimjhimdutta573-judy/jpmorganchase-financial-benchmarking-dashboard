USE jpmc_finance_analytics;

-- 1. Latest quarter-on-quarter revenue movements.
SELECT
  metric_name,
  metric_value AS current_value,
  previous_value,
  qoq_status,
  qoq_change_pct
FROM vw_revenue_latest_qoq
ORDER BY qoq_change_pct DESC, metric_name;

-- 2. Five-quarter history for a selected metric.
SELECT period_label, metric_value, unit
FROM vw_metric_trend
WHERE metric_id = 'M021'
ORDER BY period_sort;

-- 3. Latest values by category without mixing units in one total.
SELECT category, unit, COUNT(*) AS metric_count
FROM vw_latest_qoq
GROUP BY category, unit
ORDER BY category, unit;

-- 4. Metrics that are not meaningful for percentage-growth ranking.
SELECT metric_id, metric_name, previous_value, metric_value, qoq_status
FROM vw_latest_qoq
WHERE qoq_status <> 'COMPARABLE'
ORDER BY category, metric_name;

-- 5. Source-page trace for every dashboard metric.
SELECT metric_id, metric_name, basis, unit, source_page
FROM dim_metric
ORDER BY source_page, metric_id;
