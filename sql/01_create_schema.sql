-- JPMorganChase public-filings analytics extension
-- MySQL 8.0. Existing Excel workbook remains unchanged.

CREATE DATABASE IF NOT EXISTS jpmc_finance_analytics
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE jpmc_finance_analytics;

CREATE TABLE IF NOT EXISTS dim_metric (
  metric_id VARCHAR(10) PRIMARY KEY,
  category VARCHAR(40) NOT NULL,
  metric_name VARCHAR(160) NOT NULL,
  unit VARCHAR(20) NOT NULL,
  basis VARCHAR(40) NOT NULL,
  source_page INT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_period (
  period_id TINYINT PRIMARY KEY,
  period_label VARCHAR(10) NOT NULL UNIQUE,
  period_end_date DATE NOT NULL UNIQUE,
  fiscal_year SMALLINT NOT NULL,
  quarter_number TINYINT NOT NULL,
  period_sort TINYINT NOT NULL UNIQUE,
  CONSTRAINT chk_quarter_number CHECK (quarter_number BETWEEN 1 AND 4)
);

CREATE TABLE IF NOT EXISTS fact_metric_value (
  metric_id VARCHAR(10) NOT NULL,
  period_id TINYINT NOT NULL,
  metric_value DECIMAL(18,4) NOT NULL,
  PRIMARY KEY (metric_id, period_id),
  CONSTRAINT fk_fact_metric
    FOREIGN KEY (metric_id) REFERENCES dim_metric(metric_id),
  CONSTRAINT fk_fact_period
    FOREIGN KEY (period_id) REFERENCES dim_period(period_id)
);
