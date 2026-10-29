/* Member 3: stored procedures and functions. Run after 01. */
USE SmartSiteLab5;
GO
CREATE OR ALTER FUNCTION dbo.ufn_SeverityFromConfidence (@Confidence DECIMAL(5,4))
RETURNS VARCHAR(10) AS
BEGIN
    RETURN CASE WHEN @Confidence >= 0.9000 THEN 'CRITICAL' WHEN @Confidence >= 0.8000 THEN 'HIGH' WHEN @Confidence >= 0.6500 THEN 'MEDIUM' ELSE 'LOW' END;
END;
GO
CREATE OR ALTER FUNCTION dbo.ufn_IsCertificateValid (@WorkerID INT, @CertificateType NVARCHAR(100), @AsOfDate DATE)
RETURNS BIT AS
BEGIN
    DECLARE @Result BIT = 0;
    IF EXISTS (SELECT 1 FROM dbo.SAFETY_CERTIFICATE WHERE WorkerID=@WorkerID AND CertificateType=@CertificateType AND ExpiryDate >= @AsOfDate) SET @Result = 1;
    RETURN @Result;
END;
GO
CREATE OR ALTER PROCEDURE dbo.usp_RecordDetectionEvent
    @CameraCode VARCHAR(30), @EventType VARCHAR(40), @DetectedLabel VARCHAR(100) = NULL,
    @Confidence DECIMAL(5,4), @EventAt DATETIME2 = NULL, @ImageReference NVARCHAR(300) = NULL,
    @SourceMode VARCHAR(10) = 'MOCK', @MetadataID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    DECLARE @CameraID INT, @ZoneID INT;
    SELECT @CameraID=c.CameraID, @ZoneID=c.ZoneID FROM dbo.CAMERA c WHERE c.CameraCode=@CameraCode AND c.CameraStatus <> 'OFFLINE';
    IF @CameraID IS NULL THROW 50001, 'Camera code is invalid or offline.', 1;
    IF @SourceMode NOT IN ('AI','MOCK') THROW 50002, 'SourceMode must be AI or MOCK.', 1;
    IF @EventAt IS NULL SET @EventAt = SYSUTCDATETIME();
    BEGIN TRANSACTION;
    INSERT dbo.AI_METADATA (CameraID, EventAt, EventType, DetectedLabel, Confidence, ImageReference, SourceMode)
    VALUES (@CameraID,@EventAt,@EventType,@DetectedLabel,@Confidence,@ImageReference,@SourceMode);
    SET @MetadataID = SCOPE_IDENTITY();
    IF @EventType IN ('NO_HELMET','NO_VEST','PERSON_IN_RESTRICTED_ZONE') AND @Confidence >= 0.8000
        INSERT dbo.SAFETY_ALERT (CameraID,ZoneID,AlertType,Severity,Description)
        VALUES (@CameraID,@ZoneID,@EventType,dbo.ufn_SeverityFromConfidence(@Confidence),CONCAT('Auto-created from ',@SourceMode,' detection metadata ',@MetadataID));
    COMMIT TRANSACTION;
END;
GO
CREATE OR ALTER PROCEDURE dbo.usp_AcknowledgeSafetyAlert @AlertID INT, @Note NVARCHAR(300) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.SAFETY_ALERT SET AlertStatus='ACKNOWLEDGED', Description=CONCAT(COALESCE(Description,N''), CASE WHEN @Note IS NULL THEN N'' ELSE N' | Acknowledged: '+@Note END)
    WHERE AlertID=@AlertID AND AlertStatus='OPEN';
    IF @@ROWCOUNT=0 THROW 50003, 'Open alert was not found.', 1;
END;
GO
CREATE OR ALTER PROCEDURE dbo.usp_CheckInWorker @WorkerCode VARCHAR(20), @SiteCode VARCHAR(20), @CheckInAt DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @WorkerID INT=(SELECT WorkerID FROM dbo.WORKER WHERE WorkerCode=@WorkerCode AND IsActive=1), @SiteID INT=(SELECT SiteID FROM dbo.CONSTRUCTION_SITE WHERE SiteCode=@SiteCode AND IsActive=1);
    IF @WorkerID IS NULL OR @SiteID IS NULL THROW 50004, 'Worker or site was not found or is inactive.', 1;
    IF @CheckInAt IS NULL SET @CheckInAt=SYSUTCDATETIME();
    INSERT dbo.ATTENDANCE(WorkerID,SiteID,CheckInAt) VALUES (@WorkerID,@SiteID,@CheckInAt);
END;
GO
