GO
CREATE PROC usp_CreateIncidentFromAlert
    @INCIDENT_ID VARCHAR(20),
    @ALERT_ID VARCHAR(20),
    @INCIDENT_TYPE NVARCHAR(80),
    @DESCRIPTION NVARCHAR(500) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT alert_id FROM SAFETY_ALERT WHERE alert_id = @ALERT_ID)
    BEGIN
        PRINT N'KHONG TIM THAY SAFETY ALERT'
        RETURN
    END

    INSERT INTO INCIDENT (incident_id, alert_id, incident_type, description)
    VALUES (@INCIDENT_ID, @ALERT_ID, @INCIDENT_TYPE, @DESCRIPTION)
END
GO

EXEC usp_CreateIncidentFromAlert
    @INCIDENT_ID = 'INC001',
    @ALERT_ID = 'ALT001',
    @INCIDENT_TYPE = N'Cháy nổ',
    @DESCRIPTION = N'Phát hiện khói tại khu vực kho';