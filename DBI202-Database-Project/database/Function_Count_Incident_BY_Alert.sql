GO
CREATE FUNCTION dbo.ufn_CountIncidentsByAlert
    (@ALERT_ID VARCHAR(20))
RETURNS INT
AS
BEGIN
    DECLARE @TOTAL INT

    SET @TOTAL = (
        SELECT COUNT(incident_id)
        FROM dbo.INCIDENT
        WHERE alert_id = @ALERT_ID
    )

    RETURN @TOTAL
END
GO