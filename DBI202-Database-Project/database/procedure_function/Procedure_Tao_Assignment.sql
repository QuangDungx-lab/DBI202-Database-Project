GO
CREATE PROC dbo.usp_CreateAssignment
    @ASSIGNMENT_ID VARCHAR(20),
    @WORKER_ID VARCHAR(20),
    @SITE_ID VARCHAR(20),
    @START_DATE DATE,
    @END_DATE DATE,
    @STATUS NVARCHAR(50)
AS
BEGIN
    IF NOT EXISTS (
        SELECT worker_id FROM dbo.WORKER
        WHERE worker_id = @WORKER_ID
    )
    BEGIN
        PRINT N'KHONG TIM THAY WORKER'
        RETURN
    END

    IF NOT EXISTS (
        SELECT site_id FROM dbo.CONSTRUCTION_SITE
        WHERE site_id = @SITE_ID
    )
    BEGIN
        PRINT N'KHONG TIM THAY SITE'
        RETURN
    END

    INSERT INTO dbo.ASSIGNMENT
        (assignment_id, worker_id, site_id, status, start_date, end_date)
    VALUES
        (@ASSIGNMENT_ID, @WORKER_ID, @SITE_ID, @STATUS, @START_DATE, @END_DATE)
END
GO

-- Test
EXEC dbo.usp_CreateAssignment
    'ASG-TEST01', 'WK001', 'SITE-001',
    '2026-11-01', NULL, N'Đang thực hiện'
```