# SmartSite Lab 5 Test Cases and Evidence Checklist

Run tests after all four SQL scripts. Replace Expected Result with Actual Result and paste screenshots into the report.

| ID | Test | Action | Expected result | Evidence |
|---|---|---|---|---|
| TC01 | Schema setup | Run Member 1 script | Eleven agreed core tables, constraints, indexes, and demo rows are created | SSMS Object Explorer and SELECT screenshots |
| TC02 | Reporting views | Run Member 2 report queries | Dashboard views return alert, detection, attendance, and incident data | Query result screenshots |
| TC03 | Valid mock detection | Run Demo A in Member 4 script | One `AI_METADATA` row, one integration log row, and a high-confidence safety alert appear | Before/after results |
| TC04 | Offline camera validation | Set a camera offline and call `usp_RecordDetectionEvent` | Procedure rejects the event with a clear error | Error message screenshot |
| TC05 | Low-confidence event | Call procedure with `NO_HELMET` and confidence `0.5000` | Metadata is stored but no safety alert is created | Count/query screenshot |
| TC06 | Alert acknowledgement | Execute `usp_AcknowledgeSafetyAlert` for an open alert | Alert status changes to ACKNOWLEDGED | Row before/after screenshot |
| TC07 | Closed alert protection | Attempt to update a CLOSED alert to OPEN | Trigger rejects the update | Error message screenshot |
| TC08 | Attendance | Execute `usp_CheckInWorker 'WRK-001','SITE-001'` | Attendance record is created | Attendance query screenshot |
| TC09 | Dashboard | Refresh UI or rerun views after Demo A | New event/alert is visible in dashboard | UI screenshot plus query result |

## Evidence checklist

- [ ] ERD with entities, PKs, FKs, and relationship cardinalities
- [ ] Folder tree and each member's assigned SQL file
- [ ] SQL Server database and successful run sequence
- [ ] Camera/webcam preview or explicitly labelled mock-event screen
- [ ] Detection payload or stored-procedure call, with no sensitive video retained
- [ ] `AI_METADATA` record and `INTEGRATION_EVENT_LOG` record
- [ ] Alert appears in `vw_DashboardOpenAlerts`
- [ ] At least two dashboard/report queries
- [ ] One negative test and its expected error
- [ ] Team contribution table and final conclusion

## Suggested live-demo script

Open the webcam preview, then state whether the detection is live AI or a mock. Trigger one event. Show the procedure call or application log, refresh the database query, then refresh the dashboard alert tile. Finish with the event trace: camera code -> metadata -> integration log -> safety alert -> dashboard. Never claim that SQL Server itself detected the image.
