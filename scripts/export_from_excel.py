"""Export the existing JPMC Raw_Data sheet into Power BI/MySQL-ready CSV files.

Usage:
  python export_from_excel.py <repository-root> [--workbook <refreshed-copy.xlsx>]

The script reads only the existing workbook and writes only to the additive data folder.
"""

from __future__ import annotations

import csv
import json
import argparse
from pathlib import Path

from openpyxl import load_workbook


QUARTERS = [
    ("2Q25", "2025-06-30", 2025, 2, 1),
    ("3Q25", "2025-09-30", 2025, 3, 2),
    ("4Q25", "2025-12-31", 2025, 4, 3),
    ("1Q26", "2026-03-31", 2026, 1, 4),
    ("2Q26", "2026-06-30", 2026, 2, 5),
]


def write_csv(path: Path, headers: list[str], rows: list[list[object]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8-sig") as stream:
        writer = csv.writer(stream)
        writer.writerow(headers)
        writer.writerows(rows)


def sql_text(value: object) -> str:
    return "'" + str(value).replace("'", "''") + "'"


def sql_number(value: object) -> str:
    number = float(value)
    return str(int(number)) if number.is_integer() else format(number, ".15g")


def write_seed_sql(path: Path, metrics: list[list[object]], facts: list[list[object]]) -> None:
    """Keep the database seed synchronized with the workbook-derived CSV snapshot."""
    metric_rows = []
    for metric_id, category, metric_name, unit, basis, source_page in metrics:
        metric_rows.append(
            "  (" + ", ".join([
                sql_text(metric_id), sql_text(category), sql_text(metric_name),
                sql_text(unit), sql_text(basis), str(int(source_page)),
            ]) + ")"
        )
    period_rows = []
    for label, date, year, quarter, order in QUARTERS:
        period_rows.append(
            f"  ({order}, {sql_text(label)}, {sql_text(date)}, {year}, {quarter}, {order})"
        )
    fact_rows = [
        f"  ({sql_text(metric_id)}, {period_id}, {sql_number(value)})"
        for metric_id, period_id, value in facts
    ]
    sql = (
        "USE jpmc_finance_analytics;\n\n"
        "START TRANSACTION;\n"
        "DELETE FROM fact_metric_value;\n"
        "DELETE FROM dim_period;\n"
        "DELETE FROM dim_metric;\n\n"
        "INSERT INTO dim_metric (metric_id, category, metric_name, unit, basis, source_page) VALUES\n"
        + ",\n".join(metric_rows) + ";\n\n"
        "INSERT INTO dim_period (period_id, period_label, period_end_date, fiscal_year, quarter_number, period_sort) VALUES\n"
        + ",\n".join(period_rows) + ";\n\n"
        "INSERT INTO fact_metric_value (metric_id, period_id, metric_value) VALUES\n"
        + ",\n".join(fact_rows) + ";\n\n"
        "COMMIT;\n"
    )
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(sql, encoding="utf-8")


def main(repo_root: Path, workbook_override: Path | None = None) -> None:
    workbook = (workbook_override.resolve() if workbook_override else
                repo_root / "workbook" / "JPMorganChase_Financial_Benchmarking_Dashboard.xlsx")
    output = repo_root / "data" / "sql_powerbi"
    if not workbook.exists():
        raise FileNotFoundError(f"Workbook not found: {workbook}")

    wb = load_workbook(workbook, data_only=True, read_only=True)
    ws = wb["Raw_Data"]
    columns = {str(ws.cell(1, col).value): col for col in range(1, ws.max_column + 1)}
    required = ({"Metric_ID", "Category", "Metric_Name", "Unit", "Basis", "Source_Page"}
                | {label for label, *_ in QUARTERS})
    missing = required - columns.keys()
    if missing:
        raise ValueError(f"Raw_Data is missing columns: {sorted(missing)}")

    metrics: list[list[object]] = []
    facts: list[list[object]] = []
    for row in range(2, ws.max_row + 1):
        metric_id = ws.cell(row, columns["Metric_ID"]).value
        metrics.append([
            metric_id,
            ws.cell(row, columns["Category"]).value,
            ws.cell(row, columns["Metric_Name"]).value,
            ws.cell(row, columns["Unit"]).value,
            ws.cell(row, columns["Basis"]).value,
            ws.cell(row, columns["Source_Page"]).value,
        ])
        for label, _, _, _, order in QUARTERS:
            facts.append([metric_id, order, ws.cell(row, columns[label]).value])

    if len(metrics) != 37 or len({row[0] for row in metrics}) != 37:
        raise ValueError("Expected exactly 37 unique metrics.")
    if len(facts) != 185 or any(row[2] is None for row in facts):
        raise ValueError("Expected 185 populated metric-quarter observations.")

    write_csv(output / "dim_metric.csv",
              ["metric_id", "category", "metric_name", "unit", "basis", "source_page"], metrics)
    write_csv(output / "dim_period.csv",
              ["period_id", "period_label", "period_end_date", "fiscal_year", "quarter_number", "period_sort"],
              [[order, label, date, year, quarter, order] for label, date, year, quarter, order in QUARTERS])
    write_csv(output / "fact_metric_value.csv",
              ["metric_id", "period_id", "metric_value"], facts)
    write_seed_sql(repo_root / "sql" / "02_seed_data.sql", metrics, facts)

    result = {
        "source_workbook": "workbook/JPMorganChase_Financial_Benchmarking_Dashboard.xlsx",
        "source_sheet": "Raw_Data",
        "metric_count": len(metrics),
        "quarter_count": len(QUARTERS),
        "fact_count": len(facts),
        "unique_metric_ids": len({row[0] for row in metrics}),
        "null_fact_values": sum(row[2] is None for row in facts),
        "expected_latest_quarter": QUARTERS[-1][0],
    }
    (output / "export_validation.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("repository_root", type=Path)
    parser.add_argument("--workbook", type=Path,
                        help="Optional recalculated copy; the tracked workbook is never edited.")
    args = parser.parse_args()
    main(args.repository_root.resolve(), args.workbook)
