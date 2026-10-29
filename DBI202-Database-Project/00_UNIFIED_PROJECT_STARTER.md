# SmartSite DBI202 Unified Project Starter

Use this file as the first team meeting document. Complete the bracketed fields together before writing SQL. Its purpose is to ensure that four separate contributions can be merged into one working project.

## 1. Project identity

| Item | Team decision |
|---|---|
| Project title | SmartSite Safety Monitoring System |
| Course | DBI202 |
| Group | [Group number] |
| Database name | `SmartSiteDB` |
| Platform | Microsoft SQL Server and SSMS |
| Main demo mode | [Mock event / webcam plus mock / webcam plus AI] |
| Scope statement | Store and report construction-site safety events from cameras. |

### Honest boundary for the presentation

SQL Server does not read a webcam or recognize an image. A camera app, AI app, or manual mock action creates an event. SQL Server stores the event and supports queries and reports.

## 2. One agreed demo flow

The group demonstrates exactly this scenario.

```text
1. A camera at Scaffold Area is selected: CAM-002.
2. A mock button or camera app detects NO_HELMET.
3. The group inserts one event into AI_METADATA.
4. The group inserts one matching OPEN record into SAFETY_ALERT.
5. A query joins CAMERA, ZONE, AI_METADATA, and SAFETY_ALERT.
6. The dashboard/report query shows the new open alert.
7. The group updates that alert from OPEN to CLOSED.
8. A final query proves that the number of open alerts changed.
```

Use the same event in every demo:

| Field | Fixed demo value |
|---|---|
| Camera | `CAM-002` |
| Site | `SITE-001` |
| Zone | `ZONE-002` |
| Zone name | Scaffold Area |
| Event type | `NO_HELMET` |
| Confidence | `0.92` |
| Alert status before handling | `OPEN` |
| Alert status after handling | `CLOSED` |
| Demo mode | `MOCK` unless the team has a working AI model |

## 3. Final table list and ownership

Do not add a table without group agreement. Do not rename a table or column after the schema merge.

| Owner | Tables | Purpose |
|---|---|---|
| Member 1 | `CONTRACTOR`, `WORKER` | Who works at the construction site |
| Member 2 | `CONSTRUCTION_SITE`, `ZONE`, `CAMERA` | Where monitoring happens and which camera is used |
| Member 3 | `ASSIGNMENT`, `ATTENDANCE` | Which worker is assigned to a zone and present at a site |
| Member 4 | `AI_METADATA`, `SAFETY_ALERT`, `INCIDENT` | Camera event, warning, and resulting incident |

### Required relationships

```text
CONTRACTOR 1 --- many WORKER
CONSTRUCTION_SITE 1 --- many ZONE
ZONE 1 --- many CAMERA
WORKER many --- many ZONE through ASSIGNMENT
CAMERA 1 --- many AI_METADATA
CAMERA 1 --- many SAFETY_ALERT
SAFETY_ALERT 0 --- many INCIDENT
```

## 4. Shared keys and column rules

Use `INT IDENTITY(1,1)` for every primary key. Use clear foreign-key names that match the parent table.

| Table | Primary key | Required foreign keys | Example business code |
|---|---|---|---|
| CONTRACTOR | `ContractorID` | none | `CTR-001` |
| WORKER | `WorkerID` | `ContractorID` | `WRK-001` |
| CONSTRUCTION_SITE | `SiteID` | none | `SITE-001` |
| ZONE | `ZoneID` | `SiteID` | `ZONE-002` |
| CAMERA | `CameraID` | `ZoneID` | `CAM-002` |
| ASSIGNMENT | `AssignmentID` | `WorkerID`, `ZoneID` | none |
| ATTENDANCE | `AttendanceID` | `WorkerID`, `SiteID` | none |
| AI_METADATA | `MetadataID` | `CameraID` | none |
| SAFETY_ALERT | `AlertID` | `CameraID`, `ZoneID` | `ALT-001` |
| INCIDENT | `IncidentID` | `AlertID`, `SiteID` | `INC-001` |

### Minimum columns to agree before coding

| Table | Minimum non-key columns |
|---|---|
| CONTRACTOR | `ContractorCode`, `ContractorName` |
| WORKER | `WorkerCode`, `FullName`, `JobRole` |
| CONSTRUCTION_SITE | `SiteCode`, `SiteName` |
| ZONE | `ZoneCode`, `ZoneName`, `RiskLevel` |
| CAMERA | `CameraCode`, `CameraName`, `CameraStatus` |
| ASSIGNMENT | `StartDate`, `EndDate` |
| ATTENDANCE | `CheckInAt`, `CheckOutAt` |
| AI_METADATA | `EventType`, `Confidence`, `EventAt`, `SourceMode` |
| SAFETY_ALERT | `AlertCode`, `AlertType`, `Severity`, `AlertStatus`, `CreatedAt` |
| INCIDENT | `IncidentCode`, `IncidentType`, `IncidentStatus`, `OccurredAt` |

## 5. Fixed sample data required by every member

Member 1 creates the final combined script, but each owner supplies their own rows below.

```text
CONTRACTOR: CTR-001 BuildRight Demo Co
WORKER:     WRK-001 Alex Nguyen, WRK-002 Bao Tran
SITE:       SITE-001 SmartSite Demo Tower
ZONE:       ZONE-001 Entrance, ZONE-002 Scaffold Area
CAMERA:     CAM-001 Entrance Camera, CAM-002 Scaffold Camera
ALERT:      ALT-001 historical closed alert; new demo alert created by Member 4
```

Every owner prepares at least three rows for their main table(s), so that `JOIN`, `LEFT JOIN`, `GROUP BY`, and `HAVING` return useful results.

## 6. Stage A individual draft template

Each member creates only their draft file in `drafts/`. Use this structure.

```sql
-- Member [number] draft: [business area]
-- Tables owned: [table names]

-- CREATE TABLE statements here

-- INSERT sample data here

-- Quick verification
SELECT * FROM [OwnedTable];
```

Before a member gives the draft to the integrator, they check:

- [ ] The table name and column names match this starter file.
- [ ] Each primary key is defined.
- [ ] Each foreign key points to the correct agreed parent table.
- [ ] Sample records use the fixed codes above where applicable.
- [ ] The file contains no query owned by another member.

## 7. Stage B combined schema template

Only after all drafts are reviewed, assemble `01_member1_schema_data.sql` in this order.

```sql
CREATE DATABASE SmartSiteDB;
GO
USE SmartSiteDB;
GO

-- Member 1 tables: CONTRACTOR, WORKER
-- Member 2 tables: CONSTRUCTION_SITE, ZONE, CAMERA
-- Member 3 tables: ASSIGNMENT, ATTENDANCE
-- Member 4 tables: AI_METADATA, SAFETY_ALERT, INCIDENT

-- Insert approved sample data in parent-to-child order.

-- Final schema verification
SELECT * FROM CONTRACTOR;
SELECT * FROM CAMERA;
SELECT * FROM SAFETY_ALERT;
```

Run this file in SSMS. Do not move to the query stage until it succeeds on a clean database.

## 8. Stage C file responsibilities

| File | Owner | Content |
|---|---|---|
| `02_member2_basic_queries.sql` | Member 2 | `SELECT`, `WHERE`, `JOIN`, and one `UPDATE` for alert handling |
| `03_member3_reports.sql` | Member 3 | `COUNT`, `GROUP BY`, `HAVING`, `MIN`, `MAX`, `ALL`, and subqueries |
| `04_member4_demo_queries.sql` | Member 4 | Mock inserts, event-to-alert join, dashboard/open-alert query, and final update demo |

Member 1 checks that these files use only the frozen schema names. Members 2 to 4 do not add or alter tables in their files.

## 9. Minimum demonstration queries

The final project must demonstrate these six questions.

1. Which cameras are located in each zone and construction site?
2. Which workers belong to each contractor?
3. Which safety alerts are currently open, and which camera produced them?
4. How many alerts has each camera recorded, including cameras with zero alerts?
5. Which camera has the highest number of alerts?
6. After the mock `NO_HELMET` event is inserted, how does the open-alert report change?

## 10. Final run order and approval

```text
01_member1_schema_data.sql
02_member2_basic_queries.sql
03_member3_reports.sql
04_member4_demo_queries.sql
```

| Check | Person confirming | Status |
|---|---|---|
| ERD matches tables and foreign keys | [Name] | [ ] |
| Combined schema runs without error | [Name] | [ ] |
| Basic queries return results | [Name] | [ ] |
| Aggregate reports return results | [Name] | [ ] |
| Mock event creates visible alert data | [Name] | [ ] |
| Screenshots are captured | [Name] | [ ] |
| Every member can explain their contribution | [Name] | [ ] |
