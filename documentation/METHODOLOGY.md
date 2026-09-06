# Methodology and quality checks

## Design choice

The dashboard ranks only Revenue-category metrics. This prevents a chart from comparing revenue, balance-sheet, headcount and risk measures as though they share a common economic meaning.

Quarter-on-quarter change is calculated as:

`(2Q26 − 1Q26) / ABS(1Q26)`

When the two periods have opposite signs, the model displays **N/M**. For example, investment-securities gains/(losses) moved from +$64mm to −$395mm; `−717%` is mathematically obtainable but is not a useful growth ranking.

## Audit results

| Check | Result |
| --- | --- |
| Summary metric mapping to `Raw_Data` | 37 / 37 PASS |
| Sign-change handling | N/M, excluded from rankings |
| Dashboard metric scope | Revenue only |
| External workbook links | None |
| VBA/macros | None |
| Local user/path metadata in distributable | Removed |

The pivot-cache calculated field follows the same sign-change convention. Excel may refresh internal PivotTable cache values when the workbook is opened; it does not need any external connection.

## How to defend the model

1. The raw sheet preserves metric IDs, units, basis and report-page references.
2. The summary uses lookup formulas rather than copied display numbers.
3. Reconciliation control cells test that the summary name and both quarterly values agree with the raw table.
4. The dashboard intentionally answers one question—*which revenue lines changed most quarter on quarter?*—rather than claiming a universal company ranking.
