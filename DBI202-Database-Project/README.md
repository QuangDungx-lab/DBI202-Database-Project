# SmartSite DBI202 Lab 5

This project contains the SQL Server schema, sample data, database objects, reports, and demo workflow for the SmartSite construction-site scenario.

## Project structure

```text
database/
  01_schema/              Database and table definitions
  02_seed_data/            Sample data, split by data area
  03_database_objects/     Functions and stored procedures
  04_views_reports/        Views and report queries
  05_triggers_demo/        Triggers and mock-event demonstration
  06_queries/              Lab 5 query scripts
  07_testing/               Repeatable SQL integration tests
  _team_drafts/            Member drafts; not part of the run sequence
diagrams/                  ERD and design diagrams
docs/                      Test checklist and report template
```

## SQL run order

Run the scripts in SQL Server Management Studio in this order:

1. `database/01_schema/CreateTable.sql`
2. `database/02_seed_data/01_Core_Sample_Data.sql`
3. `database/02_seed_data/02_Visitor_Visit_Sample_Data.sql`
4. `database/03_database_objects/procedures_functions.sql`
5. `database/04_views_reports/views_reporting.sql`
6. `database/05_triggers_demo/triggers_integration_demo.sql`
7. Run the approved query scripts under `database/06_queries/`.
8. Run the SQL tests under `database/07_testing/` and capture evidence.

The schema script creates `SmartSiteLab5` from scratch and drops an existing database of that name. Use it only for the class demo database. Run the core seed once on a fresh schema; it uses the initial identity values. The visitor/visit seed skips matching demo records and can be rerun.

## Draft files

Files under `database/_team_drafts/` are preserved for review and are not included in the run order. They contain different column names and key conventions from the current integrated schema. Reconcile each draft against `01_schema/CreateTable.sql` before promoting it into the run sequence.

## Demo boundary

SQL Server stores and reports events. A webcam app, AI app, or clearly labelled mock action must create the event. Do not describe SQL Server as performing image detection.

## Documentation

- `TEAM_WORKFLOW_4_MEMBERS.md`: team responsibilities and integration workflow.
- `docs/Test_Cases_and_Evidence_Checklist.md`: tests and evidence to capture.
- `docs/SmartSite_Lab5_Report_Template.docx`: report template; edit separately when the team is ready.
- `00_UNIFIED_PROJECT_STARTER.md`: earlier planning notes; use the integrated schema and this README for current file names and run order.
