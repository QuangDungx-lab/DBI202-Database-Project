# SmartSite Lab 5 team workflow

Use the integrated schema in `database/01_schema/CreateTable.sql` as the shared reference for all Lab 5 work. Do not create duplicate tables in member files. If the team approves a schema change, Minh Khang updates the integrated schema and tells every member before query or object work continues.

## Shared run order

1. `database/01_schema/CreateTable.sql`
2. `database/02_seed_data/01_Core_Sample_Data.sql`
3. `database/02_seed_data/02_Visitor_Visit_Sample_Data.sql`
4. `database/04_views_reports/views_reporting.sql`
5. `database/03_database_objects/procedures_functions.sql`
6. `database/05_triggers_demo/triggers_integration_demo.sql`

Files under `database/_team_drafts/` are for review only. Several were written against a different schema and must not be run until reconciled with the integrated schema.

## Work allocation

| Member | Main responsibility | Deliverable |
|---|---|---|
| Trần Minh Khang | Integrate schema and data; own `CONTRACTOR`, `WORKER`, and certificate queries | Schema/seed integration, query matrix, final run guide |
| Nguyễn Ngọc Minh Như | Own `ASSIGNMENT`, `VISITOR`, and `VISIT` queries | Query file for work assignment and visitor history |
| Phạm Quang Dũng | Own `CONSTRUCTION_SITE`, `ZONE`, and `CAMERA` queries | Query file for site and camera reporting |
| Nguyễn Văn Duy Nhân | Own `SAFETY_ALERT` and `INCIDENT` queries and demo scenario | Query file for safety and incident reporting |

Each member also contributes one function, one stored procedure, and one trigger draft. The group must review all business rules against Lab 4 before integrating triggers. Lab 5 requires at least four of each object type, so the integrator tracks the total and resolves duplicates.

## Query tracking

Create a shared matrix with one row per Lab 4 table and columns for each Lab 5 query category: basic `SELECT`, `WHERE`, `ORDER BY`, aggregation, joins, `GROUP BY/HAVING`, subqueries, nested subqueries, `EXISTS`/`IN`/`ANY`/`ALL`, and set operations. Give every query a unique ID and record its owner, status, expected result, and evidence path.

The Lab 5 handout uses “per table” for several minimums. Confirm the intended interpretation with the lecturer. Until clarified, track the written counts explicitly and do not silently reduce them.

## SQL conventions

- Use the exact table and column names in the integrated schema.
- Qualify objects with `dbo.` (for example, `dbo.VISIT`).
- Label each query and explain the business question it answers.
- Keep sample inserts separate from table definitions.
- Do not run draft INSERT files until their columns, keys, and FK values match the integrated schema.
- Capture successful results and negative-test errors for the report.

## Integration checklist

- Run the shared scripts in order on a clean class database.
- Confirm each seed file inserts the expected rows without FK errors.
- Run all member queries and reconcile the query matrix.
- Test each function, procedure, trigger, view, and index contribution.
- Capture screenshots and let each member explain their contribution during the demo.

## Demo rule

The camera app, AI app, or an explicitly labelled mock action creates the event. SQL Server stores and reports it; it does not process the webcam stream itself.
