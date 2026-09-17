USE jpmc_finance_analytics;

-- Every query should return PASS before Power BI is published.
SELECT 'Metric rows' AS test_name, 37 AS expected, COUNT(*) AS observed,
       IF(COUNT(*) = 37, 'PASS', 'FAIL') AS status
FROM dim_metric
UNION ALL
SELECT 'Quarter rows', 5, COUNT(*), IF(COUNT(*) = 5, 'PASS', 'FAIL')
FROM dim_period
UNION ALL
SELECT 'Fact rows', 185, COUNT(*), IF(COUNT(*) = 185, 'PASS', 'FAIL')
FROM fact_metric_value
UNION ALL
SELECT 'Unique metric-quarter keys', 185,
       COUNT(DISTINCT CONCAT(metric_id, '|', period_id)),
       IF(COUNT(DISTINCT CONCAT(metric_id, '|', period_id)) = 185, 'PASS', 'FAIL')
FROM fact_metric_value
UNION ALL
SELECT 'Latest QoQ rows', 37, COUNT(*), IF(COUNT(*) = 37, 'PASS', 'FAIL')
FROM vw_latest_qoq
UNION ALL
SELECT 'Revenue metrics', 10, COUNT(*), IF(COUNT(*) = 10, 'PASS', 'FAIL')
FROM vw_revenue_latest_qoq;

SELECT
  '2Q26 Total Net Revenue' AS test_name,
  57347.0000 AS expected,
  metric_value AS observed,
  IF(metric_value = 57347.0000, 'PASS', 'FAIL') AS status
FROM vw_latest_qoq
WHERE metric_id = 'M030';

SELECT
  '2Q26 Investment Banking Fees' AS test_name,
  3208.0000 AS expected,
  metric_value AS observed,
  IF(metric_value = 3208.0000, 'PASS', 'FAIL') AS status
FROM vw_latest_qoq
WHERE metric_id = 'M021';

SELECT
  'Null dimensional fields' AS test_name,
  COUNT(*) AS failures,
  IF(COUNT(*) = 0, 'PASS', 'FAIL') AS status
FROM dim_metric
WHERE category IS NULL OR metric_name IS NULL OR unit IS NULL
   OR basis IS NULL OR source_page IS NULL;

SELECT
  'Orphan fact rows' AS test_name,
  COUNT(*) AS failures,
  IF(COUNT(*) = 0, 'PASS', 'FAIL') AS status
FROM fact_metric_value AS f
LEFT JOIN dim_metric AS m ON m.metric_id = f.metric_id
LEFT JOIN dim_period AS q ON q.period_id = f.period_id
WHERE m.metric_id IS NULL OR q.period_id IS NULL;

SELECT
  'Observations per metric' AS test_name,
  COUNT(*) AS failures,
  IF(COUNT(*) = 0, 'PASS', 'FAIL') AS status
FROM (
  SELECT metric_id
  FROM fact_metric_value
  GROUP BY metric_id
  HAVING COUNT(*) <> 5
) AS exceptions;

SELECT
  'Observations per period' AS test_name,
  COUNT(*) AS failures,
  IF(COUNT(*) = 0, 'PASS', 'FAIL') AS status
FROM (
  SELECT period_id
  FROM fact_metric_value
  GROUP BY period_id
  HAVING COUNT(*) <> 37
) AS exceptions;

SELECT
  'M026 sign-change treatment' AS test_name,
  previous_value,
  metric_value,
  qoq_change_pct,
  qoq_status,
  IF(previous_value = 64 AND metric_value = -395
     AND qoq_change_pct IS NULL AND qoq_status = 'N/M', 'PASS', 'FAIL') AS status
FROM vw_latest_qoq
WHERE metric_id = 'M026';

SELECT
  'Revenue comparability split' AS test_name,
  SUM(qoq_status = 'COMPARABLE') AS comparable_rows,
  SUM(qoq_status = 'N/M') AS nm_rows,
  IF(SUM(qoq_status = 'COMPARABLE') = 9 AND SUM(qoq_status = 'N/M') = 1,
     'PASS', 'FAIL') AS status
FROM vw_revenue_latest_qoq;

SELECT
  metric_id,
  previous_value,
  metric_value,
  qoq_change_pct,
  CASE
    WHEN metric_id = 'M021' AND ABS(qoq_change_pct - 0.1224632610) < 0.0000001 THEN 'PASS'
    WHEN metric_id = 'M029' AND ABS(qoq_change_pct - 3.5176540993) < 0.0000001 THEN 'PASS'
    ELSE 'FAIL'
  END AS status
FROM vw_latest_qoq
WHERE metric_id IN ('M021', 'M029')
ORDER BY metric_id;
