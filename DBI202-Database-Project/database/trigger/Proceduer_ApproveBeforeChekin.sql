GO
CREATE PROC dbo.usp_CreateSafetyAlert
    @ALERT_ID VARCHAR(20),
    @CAMERA_ID VARCHAR(20),
    @ALERT_TYPE NVARCHAR(80),
    @DETECTED_AT DATETIME2(0),
    @STATUS NVARCHAR(50),
    @SEVERITY NVARCHAR(50)
AS
BEGIN
    IF NOT EXISTS (SELECT camera_id FROM dbo.CAMERA WHERE camera_id = @CAMERA_ID)
    BEGIN
        PRINT N'KHONG TIM THAY CAMERA'
        RETURN
    END

    IF NOT EXISTS (
        SELECT camera_id
        FROM dbo.CAMERA
        WHERE camera_id = @CAMERA_ID AND camera_status = N'ONLINE'
    )
    BEGIN
        PRINT N'CAMERA KHONG HOAT DONG'
        RETURN
    END

    INSERT INTO dbo.SAFETY_ALERT
        (alert_id, camera_id, alert_type, detected_at, status, severity)
    VALUES
        (@ALERT_ID, @CAMERA_ID, @ALERT_TYPE, @DETECTED_AT, @STATUS, @SEVERITY)
END
GO

GO

-- THUC THI:
EXEC dbo.usp_CreateSafetyAlert
    @ALERT_ID = 'ALT-TEST-001',
    @CAMERA_ID = 'CAM-001',
    @ALERT_TYPE = N'Phát hiện vi phạm',
    @DETECTED_AT = '2026-11-04 14:30:00',
    @STATUS = N'NEW',
    @SEVERITY = N'HIGH';

GO

-- KIEM TRA:
SELECT *
FROM dbo.SAFETY_ALERT
WHERE alert_id = 'ALT-TEST-001';