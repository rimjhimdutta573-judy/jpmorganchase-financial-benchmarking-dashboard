-- MySQL 8.0 Command Line Client runner template.
-- Do not execute this template while __PHASE3_DIR__ is still present.
-- Rimjhim's Codex must replace every placeholder with one writable,
-- no-space absolute folder path using forward slashes, for example:
-- C:/Rimjhim_MySQL_Phase3

tee __PHASE3_DIR__/phase3_validation_output.txt

SELECT VERSION() AS mysql_version;
SELECT CURRENT_USER() AS connected_user;

source __PHASE3_DIR__/01_create_schema.sql
source __PHASE3_DIR__/02_seed_data.sql
source __PHASE3_DIR__/03_create_views.sql
source __PHASE3_DIR__/05_validation_queries.sql
source __PHASE3_DIR__/04_analysis_queries.sql

SELECT DATABASE() AS active_database;
SELECT COUNT(*) AS metric_rows FROM jpmc_finance_analytics.dim_metric;
SELECT COUNT(*) AS period_rows FROM jpmc_finance_analytics.dim_period;
SELECT COUNT(*) AS fact_rows FROM jpmc_finance_analytics.fact_metric_value;
SELECT COUNT(*) AS latest_qoq_rows FROM jpmc_finance_analytics.vw_latest_qoq;

notee
