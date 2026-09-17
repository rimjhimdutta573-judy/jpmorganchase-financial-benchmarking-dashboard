USE jpmc_finance_analytics;

-- Import these three base tables plus the validated Revenue view into Power BI.
SELECT * FROM dim_metric;
SELECT * FROM dim_period ORDER BY period_sort;
SELECT * FROM fact_metric_value;

-- Keep this result disconnected; it directly drives the Revenue variance page.
SELECT * FROM vw_revenue_latest_qoq;
