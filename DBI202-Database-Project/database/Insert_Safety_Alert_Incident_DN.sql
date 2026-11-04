/*
    SmartSite - Lab 5
    Sample INSERT script for Duy Nhan's scope
    Tables: SAFETY_ALERT, INCIDENT
    DBMS: Microsoft SQL Server

    IMPORTANT:
    - Column names match database/CreateTable.sql.
    - Run after CreateTable.sql on a clean SmartSiteLab5 database.
    - Run this script only once unless the inserted rows are removed first.
*/
USE SmartSiteLab5;
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;

    /* 1. SAFETY_ALERT: 6 rows */
    INSERT INTO dbo.SAFETY_ALERT
        (CameraID, ZoneID, AlertType, Severity, AlertStatus, CreatedAt, Description)
    VALUES
        (2, 2, 'PPE_VIOLATION', 'HIGH', 'CLOSED',
         '2026-10-25T09:30:00', N'Worker was detected without a safety helmet in the scaffold area.'),
        (3, 3, 'RESTRICTED_ZONE', 'CRITICAL', 'ACKNOWLEDGED',
         '2026-10-26T14:10:00', N'A person was detected inside the restricted material yard.'),
        (1, 1, 'WORKER_COUNT', 'MEDIUM', 'OPEN',
         '2026-10-27T08:15:00', N'Worker count exceeded the expected limit at the entrance.'),
        (2, 2, 'NO_VEST', 'HIGH', 'OPEN',
         '2026-10-28T10:20:00', N'Worker was detected without a reflective safety vest near the scaffold.'),
        (1, 1, 'UNKNOWN_PERSON', 'LOW', 'CLOSED',
         '2026-10-29T16:40:00', N'Unidentified person was detected at the construction site entrance.'),
        (3, 3, 'EQUIPMENT_DANGER', 'HIGH', 'ACKNOWLEDGED',
         '2026-10-30T11:05:00', N'Unsafe activity was detected near stored construction materials.');

    /* 2. INCIDENT: 6 rows */
    /* CreateTable.sql inserts one historical alert and incident first,
       so these new alerts receive AlertID 2 through 7. */
    INSERT INTO dbo.INCIDENT
        (AlertID, SiteID, IncidentType, IncidentStatus, OccurredAt, Notes)
    VALUES
        (2, 1, 'PPE_NONCOMPLIANCE', 'RESOLVED',
         '2026-10-25T09:45:00', N'Safety briefing completed and PPE compliance was restored.'),
        (3, 1, 'INTRUSION', 'INVESTIGATING',
         '2026-10-26T14:20:00', N'Safety team investigated unauthorized access to the restricted zone.'),
        (3, 1, 'PPE_NONCOMPLIANCE', 'OPEN',
         '2026-10-26T15:00:00', N'Follow-up inspection was scheduled for the affected area.'),
        (5, 1, 'PPE_NONCOMPLIANCE', 'OPEN',
         '2026-10-28T10:35:00', N'Supervisor was asked to verify the worker safety equipment.'),
        (6, 1, 'OTHER', 'RESOLVED',
         '2026-10-29T16:55:00', N'Visitor identity was confirmed before site access was allowed.'),
        (7, 1, 'EQUIPMENT_FAILURE', 'INVESTIGATING',
         '2026-10-30T11:20:00', N'Maintenance team started checking the equipment storage area.');

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO

/* Verification 1: row counts */
SELECT 'SAFETY_ALERT' AS TableName, COUNT(*) AS TotalRows
FROM dbo.SAFETY_ALERT
WHERE AlertID BETWEEN 2 AND 7
UNION ALL
SELECT 'INCIDENT', COUNT(*)
FROM dbo.INCIDENT
WHERE IncidentID BETWEEN 2 AND 7;
GO

/* Verification 2: alert -> incident */
SELECT
    a.AlertID,
    a.CameraID,
    a.ZoneID,
    a.AlertType,
    a.Severity,
    a.AlertStatus,
    i.IncidentID,
    i.IncidentType,
    i.IncidentStatus,
    i.OccurredAt
FROM dbo.SAFETY_ALERT AS a
LEFT JOIN dbo.INCIDENT AS i
    ON i.AlertID = a.AlertID
WHERE a.AlertID BETWEEN 2 AND 7
ORDER BY a.AlertID, i.IncidentID;
GO

/* Verification 3: incidents grouped by status */
SELECT IncidentStatus, COUNT(*) AS IncidentCount
FROM dbo.INCIDENT
WHERE IncidentID BETWEEN 2 AND 7
GROUP BY IncidentStatus
ORDER BY IncidentStatus;
GO
