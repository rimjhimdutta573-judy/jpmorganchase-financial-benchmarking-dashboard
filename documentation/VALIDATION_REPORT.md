# Final validation report

## Scope

This report records the final validation of the SQL and Power BI portfolio extension. It does not replace or modify the original Excel workbook.

## Results

| Check | Result |
| --- | --- |
| Reproducible exports match the validated kit output | PASS |
| Metrics / periods / facts | 37 / 5 / 185 |
| Metric-period keys and dimension links | PASS |
| Five observations exist for every metric | PASS |
| Latest-quarter reconciliation checks (M021, M026, M029, M030) | PASS |
| Original workbook SHA-256 | `615C263C9C17F7309721468471707FAF8B3459D169CA20395611E2A16B5BA2D1` |
| No credentials or personal absolute paths in distributable files | PASS |

## Report evidence

The final Power BI package contains the two-page PBIX report, a PDF preview, report-page screenshots and a data-model screenshot. The Revenue Variance page uses `vw_revenue_latest_qoq`; the Financial and Risk Trends page uses a single-metric five-quarter explorer.
