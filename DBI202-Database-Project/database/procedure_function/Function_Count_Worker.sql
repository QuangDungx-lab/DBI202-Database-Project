GO
CREATE FUNCTION dbo.ufn_CountWorkersByContractor
    (@CONTRACTOR_ID VARCHAR(20))
RETURNS INT
AS
BEGIN
    DECLARE @TOTAL INT

    SET @TOTAL = (
        SELECT COUNT(worker_id)
        FROM dbo.WORKER
        WHERE contractor_id = @CONTRACTOR_ID
    )

    RETURN @TOTAL
END
GO

-- ThucThi
DECLARE @KQ INT
EXECUTE @KQ = dbo.ufn_CountWorkersByContractor 'CTR-001'
PRINT N'SO WORKER: ' + CONVERT(CHAR(5), @KQ)