# Phase 3 with MySQL 8.0 Command Line Client

## Purpose

Use the installed **MySQL 8.0 Command Line Client** to build and validate the JPMC database. MySQL Workbench is not required. Rimjhim enters her password privately; neither Codex nor any committed file stores it.

## Files used

From the JPMC repository:

- `sql/01_create_schema.sql`
- `sql/02_seed_data.sql`
- `sql/03_create_views.sql`
- `sql/04_analysis_queries.sql`
- `sql/05_validation_queries.sql`
- `sql/00_phase3_runner.template.sql`

`06_power_bi_queries.sql` is a readable reference for Phase 4 and is not executed during database construction.

## Codex preparation

1. Confirm Phase 2 is complete and `git status --short` shows only the expected additive project files.
2. Re-run the source-workbook hash and shared package validator before database work.
3. Find a writable absolute folder whose path contains no spaces. Prefer `C:\Rimjhim_MySQL_Phase3`; if Windows rejects it, use another short, writable no-space location.
4. Copy the five numbered SQL files above and the runner template into that staging folder. These are disposable execution copies; the repository files remain authoritative.
5. Create `00_phase3_runner.sql` from the template. Replace every `__PHASE3_DIR__` with the staging folder written with forward slashes, such as `C:/Rimjhim_MySQL_Phase3`.
6. Verify the generated runner contains no placeholder and that all five referenced SQL files exist.
7. Do not place a password, password-bearing command-line flag, token or connection string in any file or command.

## Rimjhim's interactive steps

1. Open **MySQL 8.0 Command Line Client** from the Windows Start menu.
2. Enter the MySQL password directly in the client. Do not send it to Codex or paste it into chat.
3. At the `mysql>` prompt, run the generated runner using its forward-slash path and no trailing semicolon:

   `source C:/Rimjhim_MySQL_Phase3/00_phase3_runner.sql`

   If Codex selected a different staging path, use the exact command it provides.
4. Wait until the prompt returns. Do not close the window during execution.
5. Run `exit` after Codex confirms that the output file exists.

## Codex validation after execution

Read `phase3_validation_output.txt` from the staging folder and require all of the following:

- MySQL major version is 8.
- No line begins with or contains `ERROR`.
- No validation row has status `FAIL`.
- `Metric rows`, `Quarter rows`, `Fact rows`, `Unique metric-quarter keys`, `Latest QoQ rows` and `Revenue metrics` show PASS.
- Null dimensional fields, orphan facts, observation-per-metric and observation-per-period failures are all zero and show PASS.
- M026 shows prior value 64, current value -395, percentage NULL and status N/M.
- Revenue comparability is 9 comparable and 1 N/M.
- M021 and M029 validation rows show PASS.
- Final counts are 37 metrics, 5 periods, 185 facts and 37 latest-QoQ rows.
- Active database is `jpmc_finance_analytics`.

Do not accept a partial run merely because the final prompt returned. The saved text output is the evidence.

## Common errors

- `ERROR 2003`: MySQL Server is not running. Inspect the Windows `MySQL80` service and ask Rimjhim to start it if needed.
- `ERROR 1045`: authentication failed. Rimjhim should retry the correct account/password privately.
- Access denied for `CREATE DATABASE`: use an authorized local MySQL account; do not weaken permissions or embed credentials.
- `Failed to open file`: the staging path or filename is wrong. Use forward slashes, a no-space path and confirm the files exist.
- SQL syntax or validation `FAIL`: stop Phase 3, preserve the output file and diagnose the exact statement. Do not edit expected values just to obtain PASS.

## Phase 4 handoff

The Command Line Client proves that the MySQL server and database work. It does not prove that Power BI's MySQL connector is installed. In Phase 4, connect Power BI to server `localhost`, database `jpmc_finance_analytics`, using Import mode. If Power BI requests a connector, install the MySQL Connector/NET version indicated by Power BI and restart Power BI.

## Official MySQL references

- [MySQL 8.0 client commands (`source`, `tee`, `notee`)](https://dev.mysql.com/doc/refman/8.0/en/mysql-commands.html)
- [Executing SQL statements from a text file](https://dev.mysql.com/doc/refman/8.0/en/mysql-batch-commands.html)
