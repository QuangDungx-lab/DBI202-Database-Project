GO
CREATE TRIGGER dbo.TRIG_VISIT_APPROVED_CHECKIN
ON dbo.VISIT
FOR INSERT
AS
BEGIN
    DECLARE @DUYET NVARCHAR(50)
    DECLARE @CHECKIN TIME(0)

    SELECT @DUYET = INS.approval_status,
           @CHECKIN = INS.check_in_time
    FROM inserted INS

    IF (@CHECKIN IS NOT NULL AND @DUYET <> N'Đã duyệt')
    BEGIN
        PRINT N'VISIT PHAI DUOC DUYET TRUOC KHI CHECK-IN'
        ROLLBACK
    END
END
GO


-- THUC THI: 

INSERT INTO dbo.VISIT
    (visit_id, visitor_id, site_id, status, visit_date, purpose,
     approval_status, check_in_time, check_out_time)
VALUES
    ('VST-TEST01', 'VIS-001', 'SITE-001',
     N'Chờ xử lý', '2026-11-05', N'Test trigger',
     N'Chờ duyệt', '08:00', NULL);

GO

-- KIEM TRA: 
SELECT *
FROM dbo.VISIT
WHERE visit_id = 'VST-TEST01';
