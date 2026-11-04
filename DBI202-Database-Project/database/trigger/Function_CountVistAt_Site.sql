GO
CREATE FUNCTION dbo.ufn_CountVisitsBySite
    (@SITE_ID VARCHAR(20))
RETURNS INT
AS
BEGIN
    DECLARE @TOTAL INT

    SET @TOTAL = (
        SELECT COUNT(visit_id)
        FROM dbo.VISIT
        WHERE site_id = @SITE_ID
    )

    RETURN @TOTAL
END
GO