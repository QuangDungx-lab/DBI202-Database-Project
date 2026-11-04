GO
CREATE FUNCTION dbo.ufn_CountAlertsByCamera
    (@CAMERA_ID VARCHAR(20))
RETURNS INT
AS
BEGIN
    DECLARE @TOTAL INT

    SET @TOTAL = (
        SELECT COUNT(alert_id)
        FROM dbo.SAFETY_ALERT
        WHERE camera_id = @CAMERA_ID
    )

    RETURN @TOTAL
END
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
-- THỰC THI Kiểm tra số cảnh báo ban đầu của CAM-001
SELECT dbo.ufn_CountAlertsByCamera('CAM-001') AS AlertsBeforeInsert;
-- THỰC THI Gọi Stored Procedure thêm mới 1 cảnh báo
EXEC dbo.usp_CreateSafetyAlert
    @ALERT_ID = 'ALT-TEST-001',
    @CAMERA_ID = 'CAM-001',
    @ALERT_TYPE = N'Không đội mũ bảo hộ (No Helmet)',
    @DETECTED_AT = '2026-11-04 14:30:00',
    @STATUS = N'NEW',
    @SEVERITY = N'HIGH';

-- Kiểm tra lại dữ liệu trong bảng sau khi thêm:
SELECT * 
FROM dbo.SAFETY_ALERT 
WHERE alert_id = 'ALT-TEST-001';

--THỰC THI Kiểm tra lại Function để xác nhận số lượng đã tăng thêm 1
SELECT dbo.ufn_CountAlertsByCamera('CAM-001') AS AlertsBeforeInsert;

