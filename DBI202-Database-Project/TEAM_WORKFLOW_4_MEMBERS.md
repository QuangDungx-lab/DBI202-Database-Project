# SmartSite DBI202 Team Workflow for Four Members

This guide divides the SmartSite Safety Monitoring System into four compatible parts. The project uses database concepts appropriate for DBI202: tables, primary keys, foreign keys, `INSERT`, `UPDATE`, `SELECT`, `JOIN`, `GROUP BY`, `HAVING`, and subqueries. Camera or AI is optional extra evidence; it must not replace the database work.

## 1. One team agreement before coding

Meet once and write these decisions at the top of the shared group chat or document.

| Decision                  | Team standard                                                                                                          |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Database name             | `SmartSiteDB`                                                                                                          |
| SQL Server schema         | `dbo`                                                                                                                  |
| Main project idea         | Construction-site safety monitoring                                                                                    |
| Data received from camera | A simple event: camera, alert type, confidence, time                                                                   |
| Camera claim              | The camera/AI or mock creates data; SQL Server stores and reports it                                                   |
| Core tables               | `CONTRACTOR`, `WORKER`, `CONSTRUCTION_SITE`, `ZONE`, `CAMERA`, `ASSIGNMENT`, `SAFETY_ALERT`, `INCIDENT`, `AI_METADATA` |
| Naming rule               | Table and column names use the agreed names exactly; no member renames another member's table                          |
| Date format               | `YYYY-MM-DD` such as `2026-10-28`                                                                                      |

If the group chooses `SITE` instead of `CONSTRUCTION_SITE`, change it in every file before anyone starts. Do not mix both names.

## 2. Recommended team workflow

The earlier division, where Member 1 creates all tables, is simple but does not show equal database-design work. Use this two-stage workflow instead.

```text
Stage A  Four members design separate business areas and draft their tables
        ↓
Stage B  Combine and freeze one shared 01_member1_schema_data.sql
        ↓
Stage C  Split queries and demo work into 02, 03, and 04
        ↓
Stage D  Run all files from a clean database and capture evidence
```

`01_member1_schema_data.sql` is a **combined team deliverable**, not Member 1's personal work. Member 1 is only the designated integrator who assembles the team-approved drafts.

## 3. Shared folder layout

Create one shared folder with exactly this layout.

```text
SmartSite_Project/
  00_team_notes.md
  drafts/
    member1_tables.sql
    member2_tables.sql
    member3_tables.sql
    member4_tables.sql
  01_member1_schema_data.sql
  02_member2_basic_queries.sql
  03_member3_reports.sql
  04_member4_demo_queries.sql
  05_run_all.sql
  evidence/
  screenshots/
```

The `drafts` files are working files for Stage A and are kept as evidence of contribution. They are not run together in the final demo. After review, their approved content is merged into `01_member1_schema_data.sql`. `05_run_all.sql` is edited only when the team combines the final work.

## 4. Stage A table design work for all four members

Each member drafts only the tables in their assigned business area. Their draft contains `CREATE TABLE`, primary key, foreign key where needed, and 3 to 5 `INSERT` records. They do not duplicate another member's table or create the database independently.

| Member | Draft file | Business area | Tables proposed |
|---|---|---|---|
| Member 1 | `drafts/member1_tables.sql` | Company and people | `CONTRACTOR`, `WORKER` |
| Member 2 | `drafts/member2_tables.sql` | Construction location | `CONSTRUCTION_SITE`, `ZONE`, `CAMERA` |
| Member 3 | `drafts/member3_tables.sql` | Work management | `ASSIGNMENT`, optionally `ATTENDANCE` |
| Member 4 | `drafts/member4_tables.sql` | Safety monitoring | `AI_METADATA`, `SAFETY_ALERT`, `INCIDENT` |

### Merge dependency order

Members may draft independently, but the final schema must create the referenced tables first:

```text
CONTRACTOR -> WORKER
CONSTRUCTION_SITE -> ZONE -> CAMERA
WORKER + ZONE -> ASSIGNMENT
CAMERA -> AI_METADATA and SAFETY_ALERT -> INCIDENT
```

Before merging, agree on one stable set of sample codes, for example `CTR-001`, `WRK-001`, `SITE-001`, `ZONE-001`, and `CAM-001`.

## 5. Stage B merge into the shared schema file

Member 1, as integrator, copies only approved content from the four drafts into `01_member1_schema_data.sql` in this order:

```sql
-- 1. Create database SmartSiteDB
-- 2. Member 1: CONTRACTOR, WORKER
-- 3. Member 2: CONSTRUCTION_SITE, ZONE, CAMERA
-- 4. Member 3: ASSIGNMENT, ATTENDANCE
-- 5. Member 4: AI_METADATA, SAFETY_ALERT, INCIDENT
-- 6. Final verification SELECT statements
```

Place an owner comment before each group, for example `-- Designed by Member 2: site, zone, and camera management`. The whole team then runs only `01_member1_schema_data.sql` on a clean database. Once it succeeds, table and column names are frozen; later changes need group agreement.

## 6. Stage C division of queries and demo work

### Member 1: schema integrator and verification

**File:** `01_member1_schema_data.sql`

**Owns:** merging the team-approved drafts, checking foreign-key order, and adding final verification `SELECT` statements. All members remain responsible for the tables they designed in Stage A.

**Deliverables:**

- Final ERD with table names, primary keys, foreign keys, and cardinalities
- One combined `01_member1_schema_data.sql`
- A run log or screenshot proving all tables and sample data were created

**Must not do:** silently rename or redesign tables after the Stage B agreement.

### Member 2: basic operational queries

**File:** `02_member2_basic_queries.sql`

**Owns:** simple queries that use `SELECT`, `WHERE`, and `JOIN`.

**Required query ideas:**

1. List cameras with their zone and construction site.
2. List workers with contractor names.
3. List open safety alerts with camera and zone.
4. List incidents with their related alert.
5. List AI/camera metadata ordered by newest event.
6. Update one alert from `OPEN` to `CLOSED` for the demo.

**Rule:** start every query with a numbered comment, for example `-- Q2.1 List cameras by zone`.

### Member 3: aggregate reports and subqueries

**File:** `03_member3_reports.sql`

**Owns:** reports using `COUNT`, `GROUP BY`, `HAVING`, `MIN`, `MAX`, `ALL`, or subqueries.

**Required query ideas:**

1. Count alerts for each camera, including cameras with zero alerts.
2. Count alerts for each zone.
3. Find the camera with the most alerts.
4. Find the zone with the most open alerts.
5. Count incidents by status.
6. Find workers assigned to high-risk zones.

**Rule:** do not create tables or insert records. Use only the team's confirmed table and column names from Stage B.

### Member 4: demo data flow and final presentation queries

**File:** `04_member4_demo_queries.sql`

**Owns:** simple camera/mock data entry, test scenarios, and the SQL queries shown during the live demo.

**Required work:**

1. Insert one mock camera event into `AI_METADATA`.
2. Insert one matching alert into `SAFETY_ALERT`.
3. Write a query that shows the full path: camera -> zone -> event -> alert.
4. Write a query for the dashboard screen: current open alerts.
5. Prepare one error/negative test, such as a camera code that does not exist or a missing required value.
6. Write the exact demo run order in comments at the end of the file.

**Camera demo rule:** if no AI model exists, use a visible button or a manual `INSERT` labelled `MOCK`. Never claim the database detected the image.

## 7. Database object ownership

| Object type                           | Owner      | Rule                                                            |
| ------------------------------------- | ---------- | --------------------------------------------------------------- |
| Draft tables                           | All members | Each member owns the tables in their Stage A business area      |
| Combined schema file                  | Member 1 as integrator | Merges only team-approved table definitions and data |
| Sample master data                    | All members, merged by Member 1 | Codes must stay stable after sharing, for example `CAM-001` |
| Basic queries                         | Member 2   | Prefix comments with `Q2`                                       |
| Aggregate queries                     | Member 3   | Prefix comments with `Q3`                                       |
| Demo inserts and presentation queries | Member 4   | Prefix comments with `Q4`                                       |
| ERD and report merge                  | Whole team | One person merges after group review                            |

## 8. Rules that prevent merge conflicts

1. Do not create the same table in more than one file.
2. Do not change a shared column name without telling all members.
3. Use fixed sample codes shared by everyone: `SITE-001`, `ZONE-001`, `CAM-001`, `WRK-001`, `ALT-001`.
4. Member 2, 3, and 4 must use only data in the approved combined schema file, except Member 4's clearly labelled mock event.
5. Each query needs a comment explaining the business question it answers.
6. Do not use `DROP DATABASE`, `DROP TABLE`, or `DELETE FROM` in Member 2, 3, or 4 files.
7. Do not use procedures, triggers, functions, or views unless they are explicitly required by the lecturer.
8. Before combining, each member must run the approved schema script first, then their own file, and fix every error.

## 9. Final integration procedure

The appointed integrator creates `05_run_all.sql` with this exact order.

```sql
-- SmartSite final run order
:r .\01_member1_schema_data.sql
:r .\02_member2_basic_queries.sql
:r .\03_member3_reports.sql
:r .\04_member4_demo_queries.sql
```

If SQLCMD mode is unavailable in SSMS, open and run the four files manually in the same order.

Before the final demo, use this checklist.

- [ ] Run the combined schema file on a clean database without errors.
- [ ] Run Member 2's queries; confirm each returns meaningful rows.
- [ ] Run Member 3's report queries; confirm totals and max/min results.
- [ ] Run Member 4's mock event; confirm the new event and alert appear.
- [ ] Confirm that no query refers to a missing table or misspelled column.
- [ ] Capture screenshots for the ERD, tables, inserts, joins, reports, and demo result.
- [ ] Let every member explain their own SQL file in 30 to 60 seconds.

## 10. Suggested live demo order

1. Each member briefly presents the tables they designed; Member 1 shows the combined schema file and final ERD.
2. Member 2 shows camera, zone, worker, and alert joins.
3. Member 3 shows counts and the camera/zone with the highest number of alerts.
4. Member 4 creates a mock `NO_HELMET` event, then re-runs the open-alert query.
5. The group states the limitation honestly: the event is generated by a camera app, AI app, or mock; SQL Server manages the stored data and reports.

## 11. Minimum quality standard for submission

The final project should contain a clear ERD, valid keys, enough sample data for all queries, at least 5 basic queries, at least 5 aggregate/subquery reports, one insert/update demo, screenshots, and a short explanation of each team member's work.
