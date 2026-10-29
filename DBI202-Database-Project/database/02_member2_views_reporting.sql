/* Member 2: views and reporting. Run after 01. */
USE SmartSiteLab5;
GO
CREATE OR ALTER VIEW dbo.vw_DashboardOpenAlerts AS
SELECT a.AlertID, s.SiteCode, s.SiteName, z.ZoneCode, z.ZoneName, c.CameraCode,
       a.AlertType, a.Severity, a.AlertStatus, a.CreatedAt, a.Description
FROM dbo.SAFETY_ALERT a
JOIN dbo.ZONE z ON z.ZoneID = a.ZoneID
JOIN dbo.CONSTRUCTION_SITE s ON s.SiteID = z.SiteID
LEFT JOIN dbo.CAMERA c ON c.CameraID = a.CameraID
WHERE a.AlertStatus IN ('OPEN','ACKNOWLEDGED');
GO
CREATE OR ALTER VIEW dbo.vw_DashboardRecentDetections AS
SELECT m.MetadataID, c.CameraCode, z.ZoneName, s.SiteName, m.EventAt, m.EventType,
       m.DetectedLabel, m.Confidence, m.SourceMode, m.ImageReference
FROM dbo.AI_METADATA m
JOIN dbo.CAMERA c ON c.CameraID = m.CameraID
JOIN dbo.ZONE z ON z.ZoneID = c.ZoneID
JOIN dbo.CONSTRUCTION_SITE s ON s.SiteID = z.SiteID;
GO
CREATE OR ALTER VIEW dbo.vw_WorkerCertificateStatus AS
SELECT w.WorkerCode, w.FullName, w.JobRole, sc.CertificateType, sc.ExpiryDate,
       CASE WHEN sc.ExpiryDate < CAST(GETDATE() AS DATE) THEN 'EXPIRED' ELSE 'VALID' END AS CertificateStatus
FROM dbo.WORKER w LEFT JOIN dbo.SAFETY_CERTIFICATE sc ON sc.WorkerID = w.WorkerID;
GO
CREATE OR ALTER VIEW dbo.vw_CameraOperationalSummary AS
SELECT c.CameraCode, c.CameraName, c.CameraStatus, z.ZoneName, s.SiteName,
       MAX(m.EventAt) AS LastEventAt, COUNT(m.MetadataID) AS DetectionCount
FROM dbo.CAMERA c JOIN dbo.ZONE z ON z.ZoneID = c.ZoneID JOIN dbo.CONSTRUCTION_SITE s ON s.SiteID = z.SiteID
LEFT JOIN dbo.AI_METADATA m ON m.CameraID = c.CameraID
GROUP BY c.CameraCode, c.CameraName, c.CameraStatus, z.ZoneName, s.SiteName;
GO
-- Report 1: dashboard alert list
SELECT * FROM dbo.vw_DashboardOpenAlerts ORDER BY CreatedAt DESC;
-- Report 2: event volume and average confidence by camera
SELECT CameraCode, COUNT(*) AS EventCount, CAST(AVG(Confidence) AS DECIMAL(5,4)) AS AverageConfidence
FROM dbo.vw_DashboardRecentDetections GROUP BY CameraCode ORDER BY EventCount DESC;
-- Report 3: workers currently checked in
SELECT w.WorkerCode, w.FullName, s.SiteName, a.CheckInAt
FROM dbo.ATTENDANCE a JOIN dbo.WORKER w ON w.WorkerID = a.WorkerID JOIN dbo.CONSTRUCTION_SITE s ON s.SiteID = a.SiteID
WHERE a.CheckOutAt IS NULL ORDER BY a.CheckInAt DESC;
-- Report 4: incident summary by status
SELECT IncidentStatus, COUNT(*) AS IncidentCount FROM dbo.INCIDENT GROUP BY IncidentStatus;
GO
