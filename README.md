# JPMorganChase Financial Benchmarking Dashboard

An Excel dashboard that organizes selected JPMorganChase & Co. 2Q26 public financial metrics, reconciles them to a structured raw-data sheet, and presents a focused quarter-on-quarter revenue view.

## Open the model

Open [JPMorganChase_Financial_Benchmarking_Dashboard.xlsx](workbook/JPMorganChase_Financial_Benchmarking_Dashboard.xlsx) in desktop Excel. Start with the `Dashboard` tab, then use `QoQ_Summary` to trace each displayed value back to `Raw_Data`.

## What was improved

- Rebuilt the 37-line summary so each value is formula-linked to the correct raw-data metric.
- Added a row-level reconciliation control; all 37 rows pass.
- Made the dashboard revenue-only, so its comparisons are economically consistent.
- Treated the move from positive to negative investment-securities gains/(losses) as **N/M** (not meaningful), rather than presenting a misleading percentage rank.
- Removed local-path and user metadata from the distributable workbook.

## Scope and caveats

This is an educational portfolio analysis, not investment research or a recommendation. Amounts, basis and source-page references are retained in `Raw_Data`. The underlying source report is not redistributed; use the official link below.

## Source

- [JPMorganChase 2Q26 Earnings Supplement (official PDF)](https://www.jpmorganchase.com/content/dam/jpmc/jpmorgan-chase-and-co/investor-relations/documents/quarterly-earnings/2026/2nd-quarter/c9c097af-34e9-4aae-92d2-909a2ab7c083.pdf), released July 14, 2026.
- [SEC Exhibit 99.2 filing](https://www.sec.gov/Archives/edgar/data/19617/000162828026048078/a2q26erfex992supplement.htm), an independently accessible filing copy.

See [methodology and checks](documentation/METHODOLOGY.md) and the [data dictionary](documentation/DATA_DICTIONARY.md) for audit detail.
