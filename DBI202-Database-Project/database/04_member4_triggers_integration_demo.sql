/* Member 4: triggers, integration log, and demo calls. Run after 01 and 03. */
USE SmartSiteLab5;
GO
CREATE TABLE dbo.INTEGRATION_EVENT_LOG (
    IntegrationLogID BIGINT IDENTITY(1,1) CONSTRAINT PK_INTEGRATION_EVENT_LOG PRIMARY KEY,
    MetadataID BIGINT NOT NULL,
    LoggedAt DATETIME2 NOT NULL CONSTRAINT DF_INTEGRATION_LOG_LoggedAt DEFAULT (SYSUTCDATETIME()),
    LogMessage NVARCHAR(500) NOT NULL
);
GO
CREATE OR ALTER TRIGGER dbo.trg_AI_METADATA_WriteIntegrationLog
ON dbo.AI_METADATA AFTER INSERT AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.INTEGRATION_EVENT_LOG (MetadataID, LogMessage)
    SELECT i.MetadataID, CONCAT('Detection accepted: ', i.EventType, '; source=', i.SourceMode, '; confidence=', CONVERT(VARCHAR(10), i.Confidence)) FROM inserted i;
END;
GO
CREATE OR ALTER TRIGGER dbo.trg_SAFETY_ALERT_PreventClosedReopen
ON dbo.SAFETY_ALERT AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON d.AlertID=i.AlertID WHERE d.AlertStatus='CLOSED' AND i.AlertStatus<>'CLOSED')
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50005, 'Closed alerts cannot be reopened in this demo.', 1;
    END;
END;
GO
-- Demo A: mock fallback (works without any webcam or AI model)
DECLARE @NewMetadataID BIGINT;
EXEC dbo.usp_RecordDetectionEvent @CameraCode='CAM-002', @EventType='NO_HELMET', @DetectedLabel='person_without_helmet', @Confidence=0.9200,
    @ImageReference=N'demo://frame-001 (no raw video stored)', @SourceMode='MOCK', @MetadataID=@NewMetadataID OUTPUT;
SELECT @NewMetadataID AS NewMetadataID;
-- Demo B: interface/app integration example. Replace values with request payload from a local app.
-- EXEC dbo.usp_RecordDetectionEvent @CameraCode='CAM-001', @EventType='PERSON_IN_RESTRICTED_ZONE', @DetectedLabel='person', @Confidence=0.8500, @SourceMode='AI', @MetadataID=@NewMetadataID OUTPUT;
-- Evidence queries
SELECT TOP (10) * FROM dbo.INTEGRATION_EVENT_LOG ORDER BY LoggedAt DESC;
SELECT TOP (10) * FROM dbo.vw_DashboardRecentDetections ORDER BY EventAt DESC;
SELECT TOP (10) * FROM dbo.vw_DashboardOpenAlerts ORDER BY CreatedAt DESC;
GO
