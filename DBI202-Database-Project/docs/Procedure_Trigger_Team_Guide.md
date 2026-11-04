# SmartSite procedure and trigger work allocation

This guide supplements the four-member allocation for Lab 5. Use the ERD-aligned names and string IDs (`WK001`, `SITE-001`, `CAM-001`, and so on). The earlier object files in the outer `Project/03_database_objects` and `Project/05_triggers_demo` folders use a different schema (`AI_METADATA`, `ATTENDANCE`, integer IDs, and `SiteCode`); do not copy their statements unchanged into the ERD version.

## 1. Team assignment

| Member | Procedure | Function | Trigger draft | Area |
|---|---|---|---|---|
| Trần Minh Khang | `usp_CreateAssignment` | `ufn_CountWorkersByContractor` | `TRIG_VISIT_SITE_OPEN` (trigger thứ tư, cần nhóm thống nhất) | Assignment; kiểm tra visit và site |
| Nguyễn Ngọc Minh Như | `usp_RegisterVisit` | `ufn_CountVisitsBySite` | `TRIG_VISIT_APPROVED_CHECKIN` | Visitor, visit, site |
| Phạm Quang Dũng | `usp_CreateSafetyAlert` | `ufn_CountAlertsByCamera` | `TRIG_ALERT_CAMERA_STATUS` | Camera, zone, safety alert |
| Nguyễn Văn Duy Nhân | `usp_CreateIncidentFromAlert` | `ufn_CountIncidentsByAlert` | `TRIG_ALERT_CLOSED_REOPEN` | Safety alert, incident |

Each person submits one draft of each assigned object, one valid test, one invalid test, and a short explanation of the inputs and expected result. The group must agree on trigger business rules before the integrator combines them. Lab 5 requires at least four functions, four procedures, and four triggers.

## 2. Proposed rules to approve before coding

The ERD defines entities and relationships; it does not define every operational rule below. Confirm the rules and status values with the group, then keep the same values in sample data, procedures, triggers, and tests.

1. An assignment requires an existing worker and site, and a valid date range. Kiểm tra chứng chỉ có thể là quy tắc mở rộng nếu nhóm thống nhất; ERD không yêu cầu trigger này.
2. A visit may have a check-in time only after its approval status is `Đã duyệt`.
3. A safety alert may be created only for a camera whose status is `ONLINE`.
4. A safety alert in status `CLOSED` cannot be changed back to another status.
5. Trigger thứ tư đề xuất: không cho đăng ký visit tại site có `status = N'Đã đóng'`. Nhóm xác nhận giá trị trạng thái đóng thực tế trước khi dùng.

The class trigger example reads one row from `inserted` into a scalar variable. To keep this style, test one row at a time. If the group needs to support multi-row INSERT/UPDATE statements, rewrite the trigger using set-based checks against all rows in `inserted` and `deleted`.

## 3. Classroom-style object layout

Keep each object separated by `GO`, and use the SQL Server syntax introduced in class. The following patterns show the structure; members should complete the checks using their assigned ERD tables and approved rules.

### Function pattern

```sql
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

-- Test scalar function
SELECT dbo.ufn_CountWorkersByContractor('CTR-001') AS WorkerCount
```

### Stored procedure pattern

```sql
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

### Trigger pattern in the lecture style

```sql
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

-- Test the trigger with one row at a time.
INSERT INTO dbo.VISIT
    (visit_id, visitor_id, site_id, status, visit_date, purpose,
     approval_status, check_in_time, check_out_time)
VALUES
    ('VST-TEST01', 'VIS-001', 'SITE-001', N'Chờ xử lý', '2026-11-05',
     N'Test trigger', N'Chờ duyệt', '08:00', NULL)
```

For the `CLOSED` alert rule, follow the lecture's `inserted`/`deleted` pattern: read the old status from `deleted`, the new status from `inserted`, then `PRINT` a message and `ROLLBACK` when an old `CLOSED` alert is changed to another status. Run the test UPDATE separately and select the row afterward to show it stayed `CLOSED`.

## 4. What each assigned object should do

- `usp_CreateAssignment`: check that worker and site exist, validate date range, then insert one assignment.
- `usp_RegisterVisit`: check visitor and site exist, then insert a visit. The trigger checks approval before check-in.
- `usp_CreateSafetyAlert`: check that camera exists and has the approved operational status, then insert an alert with an explicit alert ID.
- `usp_CreateIncidentFromAlert`: check that alert exists, insert an incident linked to it, then update the alert status if that is the group's approved workflow.
- `ufn_CountWorkersByContractor`: return a scalar count for a contractor code.
- `ufn_CountVisitsBySite`: return a scalar count for a site ID.
- `ufn_CountAlertsByCamera`: return a scalar count for a camera ID.
- `ufn_CountIncidentsByAlert`: return a scalar count for an alert ID.
- `TRIG_VISIT_SITE_OPEN`: reject a new visit if its construction site has status `N'Đã đóng'`.
- `TRIG_VISIT_APPROVED_CHECKIN`: reject a visit row that has check-in time but is not approved.
- `TRIG_ALERT_CAMERA_STATUS`: reject an alert if the related camera is not in the approved active status.
- `TRIG_ALERT_CLOSED_REOPEN`: reject changing a `CLOSED` alert to another status.

## 5. Trigger thứ tư đề xuất: site đã đóng

Giao phần này cho Khang để mỗi thành viên có một trigger. Cú pháp dưới đây theo kiểu bài giảng: `CREATE TRIGGER`, `FOR INSERT`, đọc dữ liệu từ `inserted`, `PRINT`, rồi `ROLLBACK` nếu vi phạm. Trigger này kiểm tra khi tạo visit mới; nếu nhóm muốn chặn cả việc đổi `site_id` sang site đã đóng thì đổi thành `FOR INSERT, UPDATE` và kiểm tra các dòng trong `inserted`.

```sql
GO
CREATE TRIGGER dbo.TRIG_VISIT_SITE_OPEN
ON dbo.VISIT
FOR INSERT
AS
BEGIN
    DECLARE @SITE_ID VARCHAR(20)
    DECLARE @SITE_STATUS NVARCHAR(50)

    SELECT @SITE_ID = INS.site_id
    FROM inserted INS

    SELECT @SITE_STATUS = SITE.status
    FROM dbo.CONSTRUCTION_SITE SITE
    WHERE SITE.site_id = @SITE_ID

    IF (@SITE_STATUS = N'Đã đóng')
    BEGIN
        PRINT N'KHONG THE DANG KY VISIT TAI SITE DA DONG'
        ROLLBACK
    END
END
GO
```

Test một dòng mỗi lần, dùng mã site tồn tại và trạng thái `Đã đóng`:

```sql
INSERT INTO dbo.VISIT
    (visit_id, visitor_id, site_id, status, visit_date, purpose,
     approval_status, check_in_time, check_out_time)
VALUES
    ('VST-TEST-CLOSED', 'VIS-001', 'SITE-003', N'Đã đăng ký',
     '2026-11-05', N'Test site đã đóng', N'Chờ duyệt', NULL, NULL)

SELECT visit_id, site_id
FROM dbo.VISIT
WHERE visit_id = 'VST-TEST-CLOSED'
```

Trong seed data hiện tại, `VIS-001` là visitor có sẵn và `SITE-003` có trạng thái `N'Đã đóng'`. Nếu insert bị rollback, SELECT không trả về dòng đó. Nếu nhóm đổi trạng thái đóng, sửa điều kiện theo đúng dữ liệu đã thống nhất.

## 6. Phân công và đầu ra cần nộp

1. **Khang:** viết `usp_CreateAssignment`, `ufn_CountWorkersByContractor`, `TRIG_VISIT_SITE_OPEN`; chuẩn bị một lần tạo assignment hợp lệ và một lần thử visit ở site đóng.
2. **Như:** viết `usp_RegisterVisit`, `ufn_CountVisitsBySite`, `TRIG_VISIT_APPROVED_CHECKIN`; chuẩn bị visit đã duyệt có check-in và visit chưa duyệt có check-in.
3. **Dũng:** viết `usp_CreateSafetyAlert`, `ufn_CountAlertsByCamera`, `TRIG_ALERT_CAMERA_STATUS`; thử camera `ONLINE` và camera không hoạt động.
4. **Nhân:** viết `usp_CreateIncidentFromAlert`, `ufn_CountIncidentsByAlert`, `TRIG_ALERT_CLOSED_REOPEN`; tạo incident từ alert hợp lệ và thử đổi alert `CLOSED` trở lại trạng thái khác.

Mỗi người gửi định nghĩa object, cách gọi/test, kết quả mong đợi và vài câu giải thích. Thực thi `EXEC` cho procedure; trigger tự chạy khi `INSERT`/`UPDATE`, không gọi trigger bằng `EXEC`. Chạy từng test độc lập, rồi truy vấn bảng để chụp kết quả.

> Lưu ý cú pháp lớp học ở đây lấy một dòng từ `inserted` vào biến scalar, nên chỉ an toàn khi test từng dòng. Khi chạy nhiều dòng một lần, trigger cần viết lại theo kiểu xử lý tập hợp.

## 7. File contents and run order

Full classroom-style SQL definitions are in [procedures_functions.sql](../database/03_database_objects/procedures_functions.sql) and [triggers_integration_demo.sql](../database/05_triggers_demo/triggers_integration_demo.sql). The first file contains all four members' procedures and functions; the second contains the four assigned triggers and commented test examples.

`procedures_functions.sql` should contain functions first, then procedures, with each definition separated by `GO`. `triggers_integration_demo.sql` should contain trigger definitions and comments; put test INSERT/UPDATE statements in a test/demo section that runs only after all objects are created.

Run in this order:

1. ERD-aligned table definitions.
2. ERD-aligned sample data.
3. Functions and procedures.
4. Views, if they use functions or the final column names.
5. Triggers.
6. One-row-at-a-time valid and invalid tests, then screenshots.

The style is intentionally close to the course examples. Each member should be able to explain the trigger event, the `inserted`/`deleted` values, and why the test is accepted or rolled back.
