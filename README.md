# JPMorganChase Financial Benchmarking Dashboard

An Excel analysis of selected JPMorganChase & Co. financial and risk metrics from public filings. The workbook holds five quarterly observations, from 2Q25 through 2Q26, for 37 metrics and uses a formula-linked 1Q26-to-2Q26 revenue dashboard for the quarter-on-quarter comparison.

## What this project demonstrates

- Financial-statement extraction from a public earnings supplement, with reported/managed-basis labels, units and source pages retained alongside each metric.
- Quarter-on-quarter variance analysis using formulas, PivotTables and charts.
- A traceable control design: every displayed summary line maps back to a stable `Metric_ID` in the raw-data table.
- Judgment around non-comparable percentage changes. A move across zero is shown as **N/M** (not meaningful), rather than ranked as a misleading growth rate.

## Review the workbook in one minute

Open [JPMorganChase_Financial_Benchmarking_Dashboard.xlsx](workbook/JPMorganChase_Financial_Benchmarking_Dashboard.xlsx) in desktop Excel, then follow this path:

1. **`Dashboard`** - review the revenue-only QoQ comparison and charts.
2. **`QoQ_Summary`** - see the 37 metric lines, their 1Q26 and 2Q26 values, and the row-level reconciliation control.
3. **`Raw_Data`** - inspect the five-quarter history, units, reporting basis and source-page references.
4. **`Source_Notes`** - see the source-document and scope notes.

## Scope and interpretation

The dashboard intentionally ranks only revenue-category metrics. Balance-sheet, headcount and risk measures remain available in the underlying analysis but are not mixed into a single ranking because their percentage movements are not economically comparable. The workbook is an educational portfolio project, not investment research or a recommendation.

`Other income` rose sharply in 2Q26, partly because JPMorganChase disclosed one-off Visa-related and equity-investment gains in the earnings supplement. That result should therefore be interpreted as an event-driven variance, not a recurring revenue trend.

## Data lineage and checks

| Control | Result |
| --- | --- |
| Raw-data metrics | 37, each with a stable ID, unit, basis and report-page reference |
| Quarterly history | 2Q25 to 2Q26 |
| Summary-to-raw reconciliation | 37 / 37 PASS |
| External workbook links | None |
| VBA/macros | None |

## Primary sources

- [JPMorganChase 2Q26 Earnings Supplement (official PDF)](https://www.jpmorganchase.com/content/dam/jpmc/jpmorgan-chase-and-co/investor-relations/documents/quarterly-earnings/2026/2nd-quarter/c9c097af-34e9-4aae-92d2-909a2ab7c083.pdf), released July 14, 2026.
- [SEC Exhibit 99.2 filing](https://www.sec.gov/Archives/edgar/data/19617/000162828026048078/a2q26erfex992supplement.htm), an independently accessible filing copy.

See the [methodology and checks](documentation/METHODOLOGY.md) and [data dictionary](documentation/DATA_DICTIONARY.md) for formulas, controls and field definitions.

## SQL and Power BI extension

The portfolio extension preserves the source workbook and adds a reproducible SQL-style model with a two-page Power BI report:

- **Revenue Variance** compares the latest quarter with the prior quarter using the `vw_revenue_latest_qoq` view.
- **Financial and Risk Trends** provides a five-quarter, single-metric explorer with current value, prior value, absolute change, QoQ change, unit, basis, and source-page context.

Open the [Power BI build guide](powerbi/POWER_BI_BUILD_GUIDE.md) for refresh and rebuild steps, or review the [SQL/Power BI extension note](documentation/SQL_POWER_BI_EXTENSION.md) for lineage and validation details.

For a command-line MySQL rebuild, use the [Phase 3 MySQL guide](documentation/MYSQL_COMMAND_LINE_PHASE3.md) with the [runner template](sql/00_phase3_runner.template.sql). The template contains placeholders only; credentials are entered privately in the MySQL client and are never stored in the project.

### Power BI evidence

- [Two-page report preview](powerbi/JPMC_Financial_Benchmarking_SQL_PowerBI_Preview.pdf)
- [Revenue variance page](powerbi/screenshots/revenue_variance.png)
- [Five-quarter metric explorer](powerbi/screenshots/metric_explorer.png)
- [Power BI data model](powerbi/screenshots/data_model.png)
- [Final validation report](documentation/VALIDATION_REPORT.md)
