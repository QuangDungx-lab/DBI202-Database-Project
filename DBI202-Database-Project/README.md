# SmartSite Lab 5 DBI202 Starter Pack

This starter pack supports a four-member SQL Server project demo for a SmartSite construction-safety scenario.

## Important boundary

SQL Server stores and queries events. It does **not** receive a webcam stream or perform object detection by itself. A local webcam application, an AI service, or the included mock-event workflow must send a detection event to SQL Server. The database then records, validates, reports, and displays the result through a dashboard or query screen.

## Contents

| Path                                        | Owner  | Purpose                                                   |
| ------------------------------------------- | ------ | --------------------------------------------------------- |
| `sql/CreateTable`                           |        | Database tables, constraints, indexes, and sample data    |
| `sql/views_reporting.sql`                   |        | Views and reporting queries                               |
| `sql/procedures_functions.sql`              |        | Stored procedures and scalar functions                    |
| `sql/triggers_integration_demo.sql`         |        | Triggers, integration logging, and webcam/mock demo calls |
| `docs/Test_Cases_and_Evidence_Checklist.md` | Group5 | Test plan and evidence to capture                         |
| `docs/SmartSite_Lab5_Report_Template.docx`  | Group5 | English report template to edit and submit                |

## Assumptions to confirm before submission

The agreed project vocabulary is used: `CONTRACTOR`, `WORKER`, `CONSTRUCTION_SITE`, `ZONE`, `CAMERA`, `ASSIGNMENT`, `ATTENDANCE`, `SAFETY_CERTIFICATE`, `SAFETY_ALERT`, `INCIDENT`, and `AI_METADATA`. If the team chooses `SITE` instead of `CONSTRUCTION_SITE`, rename it consistently in **all** scripts and report diagrams before running the project. This pack does not invent fields or business rules beyond demo-friendly examples; review them with the group.

## SQL Server run order

1. Open SQL Server Management Studio (SSMS) with an account allowed to create a database.
2. Run `01_member1_schema_seed.sql`.
3. Run `02_member2_views_reporting.sql`.
4. Run `03_member3_procedures_functions.sql`.
5. Run `04_member4_triggers_integration_demo.sql`.
6. Run the test cases in `docs/Test_Cases_and_Evidence_Checklist.md` and capture screenshots.

To reset the demo, re-run the complete four-script sequence from step 1. Do not run the first script on a production server because it drops only the demo database named `SmartSiteLab5` when it already exists.

## Demo workflow

1. Start a local webcam preview or use a prerecorded/mock detection.
2. Detection app sends event fields such as camera code, event type, confidence, detected label, timestamp, and optional safe image reference.
3. The app calls `dbo.usp_RecordDetectionEvent`. For the no-AI fallback, run the mock call in Member 4's script.
4. SQL Server saves `AI_METADATA`, creates a high-confidence safety alert where appropriate, and writes an integration log.
5. Refresh dashboard views or run the reporting queries to show results.

Use only non-sensitive demo identifiers and image references. Do not store raw video, faces, or private footage in this sample database.

## Suggested dashboard tiles

- Open safety alerts by site and severity
- Recent detections by camera
- Attendance today
- Incident status summary
- Camera health and last event time

## Team handoff rule

Each member works primarily in the assigned SQL file. Before merging, run all four scripts in order on a clean `SmartSiteLab5` database. Object names are deliberately unique by responsibility to avoid collisions.
