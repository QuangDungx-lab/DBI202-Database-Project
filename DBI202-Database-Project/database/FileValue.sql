/*
    SmartSite sample data matching 01_schema/SmartSite_ERD_Tables.sql.
    Run once after creating the ERD-aligned tables in a clean SmartSiteLab5 database.
    Insert order follows the foreign-key dependencies.
*/
USE SmartSiteLab5;
GO

-- CONTRACTOR: five contractors used by WORKER rows below.
INSERT INTO dbo.CONTRACTOR
    (contractor_id, company_name, contact_person, status)
VALUES
    ('CTR-001', N'Công ty Xây dựng An Phát', N'Nguyễn Văn An', N'Đang hoạt động'),
    ('CTR-002', N'Công ty Xây dựng Hòa Bình', N'Trần Minh Bình', N'Đang hoạt động'),
    ('CTR-003', N'Công ty Xây dựng Đại Phát', N'Lê Quốc Thành', N'Đang hoạt động'),
    ('CTR-004', N'Công ty Cơ khí và Giàn giáo Thành Công', N'Phạm Văn Công', N'Đang hoạt động'),
    ('CTR-005', N'Công ty Thiết bị Công trình An Toàn', N'Võ Minh Tuấn', N'Đang hoạt động');
GO

-- CONSTRUCTION_SITE: SiteID is the business key; there is no SiteCode column.
INSERT INTO dbo.CONSTRUCTION_SITE
    (site_id, site_name, address, status)
VALUES
    ('SITE-001', N'Riverside Residential Complex', N'Thu Duc City, Ho Chi Minh City', N'Hoạt động'),
    ('SITE-002', N'Harbor Logistics Warehouse', N'Hai Phong Port Area, Hai Phong', N'Hoạt động'),
    ('SITE-003', N'Old Town Renovation Project', N'Hoi An, Quang Nam', N'Đã đóng'),
    ('SITE-004', N'Green Valley Apartment', N'District 7, Ho Chi Minh City', N'Hoạt động'),
    ('SITE-005', N'Central Business Tower', N'District 1, Ho Chi Minh City', N'Tạm ngưng'),
    ('SITE-006', N'Northern Industrial Complex', N'Bac Ninh Province, Vietnam', N'Hoạt động');
GO

-- VISITOR: visitor IDs are explicit business codes, not identity values.
INSERT INTO dbo.VISITOR
    (visitor_id, full_name, phone, email, company, id_number, status)
VALUES
    ('VIS-001', N'Nguyễn Hoàng Anh', '0910137531', 'visitor01@example.demo', N'Công ty TNHH Tư vấn Giám sát An Phát', '079201000001', N'Hợp lệ'),
    ('VIS-002', N'Trần Thị Bích Ngọc', '0910275062', 'visitor02@example.demo', N'Ban QLDA Đầu tư Xây dựng Khu vực 1', '079201000002', N'Hợp lệ'),
    ('VIS-003', N'Lê Quang Huy', '0910412593', 'visitor03@example.demo', N'Công ty CP Vật liệu Xây dựng Hòa Bình', '079201000003', N'Hợp lệ'),
    ('VIS-004', N'Phạm Thị Thu Hà', '0910550124', 'visitor04@example.demo', N'Công ty TNHH Thiết bị Xây dựng Nam Việt', '079201000004', N'Hợp lệ'),
    ('VIS-005', N'Võ Minh Châu', '0910687655', 'visitor05@example.demo', N'Sở Xây dựng TP. Hồ Chí Minh', '079201000005', N'Hợp lệ'),
    ('VIS-006', N'Đặng Văn Khải', '0910825186', 'visitor06@example.demo', N'Công ty CP Bê tông Sài Gòn', '079201000006', N'Hợp lệ'),
    ('VIS-007', N'Bùi Thị Ngân', '0910962717', 'visitor07@example.demo', N'Công ty TNHH Kiểm định Xây dựng Đại Nam', '079201000007', N'Hợp lệ'),
    ('VIS-008', N'Huỳnh Gia Phúc', '0911100248', 'visitor08@example.demo', N'Tập đoàn Phú Gia', '079201000008', N'Tạm khóa'),
    ('VIS-009', N'Ngô Thị Hồng Nhung', '0911237779', 'visitor09@example.demo', N'Công ty CP Thép Việt Đạt', '079201000009', N'Hợp lệ'),
    ('VIS-010', N'Dương Quốc Thái', '0911375310', 'visitor10@example.demo', N'Công ty TNHH Nội thất Minh Long', '079201000010', N'Hợp lệ'),
    ('VIS-011', N'Trương Văn Bình', '0911512841', 'visitor11@example.demo', N'Công ty TNHH Tư vấn Giám sát An Phát', '079201000011', N'Hợp lệ'),
    ('VIS-012', N'Lý Thị Kim Chi', '0911650372', 'visitor12@example.demo', N'Ban QLDA Đầu tư Xây dựng Khu vực 1', '079201000012', N'Hợp lệ'),
    ('VIS-013', N'Phan Anh Dũng', '0911787903', 'visitor13@example.demo', N'Công ty CP Vật liệu Xây dựng Hòa Bình', '079201000013', N'Hợp lệ'),
    ('VIS-014', N'Đỗ Minh Nhật', '0911925434', 'visitor14@example.demo', N'Công ty TNHH Thiết bị Xây dựng Nam Việt', '079201000014', N'Hợp lệ'),
    ('VIS-015', N'Hồ Thị Thanh Tâm', '0912062965', 'visitor15@example.demo', N'Sở Xây dựng TP. Hồ Chí Minh', '079201000015', N'Hợp lệ'),
    ('VIS-016', N'Mai Xuân Trường', '0912200496', 'visitor16@example.demo', N'Công ty CP Bê tông Sài Gòn', '079201000016', N'Hợp lệ'),
    ('VIS-017', N'Cao Thị Diễm My', '0912338027', 'visitor17@example.demo', N'Công ty TNHH Kiểm định Xây dựng Đại Nam', '079201000017', N'Hợp lệ'),
    ('VIS-018', N'Tạ Đình Khôi', '0912475558', 'visitor18@example.demo', N'Tập đoàn Phú Gia', '079201000018', N'Hợp lệ'),
    ('VIS-019', N'Lâm Thị Yến', '0912613089', 'visitor19@example.demo', N'Công ty CP Thép Việt Đạt', '079201000019', N'Tạm khóa'),
    ('VIS-020', N'Châu Văn Tiến', '0912750620', 'visitor20@example.demo', N'Công ty TNHH Nội thất Minh Long', '079201000020', N'Hợp lệ');
GO

-- WORKER: WorkerID and ContractorID use the business codes defined above.
INSERT INTO dbo.WORKER
    (worker_id, contractor_id, full_name, trade, id_status)
VALUES
    ('WK001', 'CTR-001', N'Nguyễn Văn Hùng', N'Thợ hồ', N'Đã xác minh'),
    ('WK002', 'CTR-001', N'Trần Minh Tuấn', N'Thợ hồ', N'Đã xác minh'),
    ('WK003', 'CTR-003', N'Lê Văn Đức', N'Thợ sắt', N'Đã xác minh'),
    ('WK004', 'CTR-003', N'Phạm Quốc Bảo', N'Thợ cốp pha', N'Chờ xác minh'),
    ('WK005', 'CTR-002', N'Võ Thanh Sơn', N'Thợ điện', N'Đã xác minh'),
    ('WK006', 'CTR-002', N'Đặng Hoàng Nam', N'Thợ điện', N'Đã xác minh'),
    ('WK007', 'CTR-004', N'Bùi Văn Long', N'Thợ hàn', N'Đã xác minh'),
    ('WK008', 'CTR-004', N'Huỳnh Minh Khoa', N'Thợ hàn', N'Đã xác minh'),
    ('WK009', 'CTR-004', N'Ngô Thành Đạt', N'Thợ giàn giáo', N'Đã xác minh'),
    ('WK010', 'CTR-004', N'Dương Văn Phúc', N'Thợ giàn giáo', N'Đã xác minh'),
    ('WK011', 'CTR-005', N'Trương Quang Vinh', N'Thợ lái máy', N'Đã xác minh'),
    ('WK012', 'CTR-005', N'Lý Văn Thắng', N'Thợ lái máy', N'Đã xác minh'),
    ('WK013', 'CTR-005', N'Phan Thị Lan', N'Thợ sơn', N'Đã xác minh'),
    ('WK014', 'CTR-005', N'Đỗ Thị Mai', N'Thợ sơn', N'Đã xác minh'),
    ('WK015', 'CTR-002', N'Hồ Văn Tâm', N'Thợ nước', N'Đã xác minh'),
    ('WK016', 'CTR-002', N'Mai Văn Hải', N'Thợ nước', N'Hết hạn'),
    ('WK017', 'CTR-003', N'Cao Minh Trí', N'Thợ sắt', N'Đã xác minh'),
    ('WK018', 'CTR-001', N'Tạ Văn Lộc', N'Thợ hồ', N'Đã xác minh'),
    ('WK019', 'CTR-003', N'Lâm Quốc Việt', N'Thợ cốp pha', N'Đã xác minh'),
    ('WK020', 'CTR-001', N'Châu Thị Hạnh', N'Thợ hồ', N'Đã xác minh');
GO

-- ZONE: each site can contain multiple zones, as shown in the ERD.
INSERT INTO dbo.ZONE
    (zone_id, site_id, zone_status, zone_name, zone_type)
VALUES
    ('ZONE-001', 'SITE-001', N'Hoạt động', N'Cổng chính', N'ENTRANCE'),
    ('ZONE-002', 'SITE-001', N'Hoạt động', N'Khu móng phía Bắc', N'RESTRICTED'),
    ('ZONE-003', 'SITE-001', N'Hoạt động', N'Kho vật liệu', N'STORAGE'),
    ('ZONE-004', 'SITE-002', N'Hoạt động', N'Khu bốc dỡ hàng', N'GENERAL'),
    ('ZONE-005', 'SITE-002', N'Hoạt động', N'Lối đi kệ hàng A', N'STORAGE'),
    ('ZONE-006', 'SITE-002', N'Hoạt động', N'Cổng an ninh', N'ENTRANCE'),
    ('ZONE-007', 'SITE-003', N'Tạm ngưng', N'Khu cải tạo', N'RESTRICTED'),
    ('ZONE-008', 'SITE-004', N'Hoạt động', N'Sảnh tòa nhà', N'ENTRANCE'),
    ('ZONE-009', 'SITE-005', N'Tạm ngưng', N'Tầng văn phòng', N'GENERAL'),
    ('ZONE-010', 'SITE-006', N'Hoạt động', N'Khu cổng nhà máy', N'ENTRANCE');
GO

-- CAMERA: each camera belongs to one zone.
INSERT INTO dbo.CAMERA
    (camera_id, zone_id, camera_status, camera_name)
VALUES
    ('CAM-001', 'ZONE-001', N'ONLINE', N'Main Gate Camera 1'),
    ('CAM-002', 'ZONE-001', N'ONLINE', N'Main Gate Camera 2'),
    ('CAM-003', 'ZONE-002', N'ONLINE', N'Foundation North Camera'),
    ('CAM-004', 'ZONE-002', N'INACTIVE', N'Foundation South Camera'),
    ('CAM-005', 'ZONE-003', N'ERROR', N'Material Storage Camera'),
    ('CAM-006', 'ZONE-004', N'ONLINE', N'Loading Dock Camera 1'),
    ('CAM-007', 'ZONE-004', N'ONLINE', N'Loading Dock Camera 2'),
    ('CAM-008', 'ZONE-005', N'INACTIVE', N'Storage Aisle Camera'),
    ('CAM-009', 'ZONE-006', N'ONLINE', N'Security Entrance Camera'),
    ('CAM-010', 'ZONE-007', N'ONLINE', N'Renovation Area Camera');
GO

-- ASSIGNMENT follows the ERD: a worker is assigned to a construction site.
INSERT INTO dbo.ASSIGNMENT
    (assignment_id, worker_id, site_id, status, start_date, end_date)
VALUES
    ('ASG001', 'WK001', 'SITE-001', N'Đang thực hiện', '2026-03-01', '2026-12-31'),
    ('ASG002', 'WK002', 'SITE-001', N'Đang thực hiện', '2026-03-01', '2026-12-31'),
    ('ASG003', 'WK003', 'SITE-001', N'Đang thực hiện', '2026-04-10', '2026-11-30'),
    ('ASG004', 'WK004', 'SITE-001', N'Đang thực hiện', '2026-04-10', '2026-11-30'),
    ('ASG005', 'WK005', 'SITE-001', N'Đang thực hiện', '2026-05-05', '2026-12-15'),
    ('ASG006', 'WK006', 'SITE-001', N'Đang thực hiện', '2026-05-05', '2026-12-15'),
    ('ASG007', 'WK007', 'SITE-002', N'Hoàn thành', '2026-02-01', '2026-08-31'),
    ('ASG008', 'WK008', 'SITE-002', N'Hoàn thành', '2026-02-01', '2026-08-31'),
    ('ASG009', 'WK009', 'SITE-002', N'Đang thực hiện', '2026-06-01', '2026-12-31'),
    ('ASG010', 'WK010', 'SITE-002', N'Đang thực hiện', '2026-06-01', '2026-12-31'),
    ('ASG011', 'WK011', 'SITE-001', N'Hoàn thành', '2026-01-15', '2026-06-30'),
    ('ASG012', 'WK012', 'SITE-001', N'Đang thực hiện', '2026-07-01', '2026-12-31'),
    ('ASG013', 'WK013', 'SITE-003', N'Đang thực hiện', '2026-09-01', '2027-01-31'),
    ('ASG014', 'WK014', 'SITE-004', N'Đang thực hiện', '2026-09-01', '2027-01-31'),
    ('ASG015', 'WK015', 'SITE-002', N'Hoàn thành', '2026-08-01', '2026-10-15'),
    ('ASG016', 'WK016', 'SITE-001', N'Tạm dừng', '2026-08-01', '2026-12-31'),
    ('ASG017', 'WK017', 'SITE-004', N'Đang thực hiện', '2026-09-15', '2026-12-31'),
    ('ASG018', 'WK018', 'SITE-003', N'Hoàn thành', '2026-03-01', '2026-09-30'),
    ('ASG019', 'WK019', 'SITE-005', N'Đang thực hiện', '2026-10-01', '2027-02-28'),
    ('ASG020', 'WK020', 'SITE-001', N'Đang thực hiện', '2026-04-01', '2026-12-31');
GO

-- SAFETY_CERTIFICATE: certificate IDs and worker IDs are explicit codes.
INSERT INTO dbo.SAFETY_CERTIFICATE
    (certificate_id, worker_id, certificate_type, status, expiry_date, issue_date)
VALUES
    ('CERT001', 'WK001', N'An toàn lao động nhóm 3', N'Còn hiệu lực', '2027-03-10', '2025-03-10'),
    ('CERT002', 'WK002', N'An toàn lao động nhóm 3', N'Hết hạn', '2026-05-20', '2024-05-20'),
    ('CERT003', 'WK003', N'An toàn lao động nhóm 3', N'Còn hiệu lực', '2027-06-01', '2025-06-01'),
    ('CERT004', 'WK004', N'An toàn lao động nhóm 3', N'Còn hiệu lực', '2028-02-15', '2026-02-15'),
    ('CERT005', 'WK005', N'An toàn điện', N'Còn hiệu lực', '2027-01-12', '2025-01-12'),
    ('CERT006', 'WK006', N'An toàn điện', N'Hết hạn', '2026-09-09', '2024-09-09'),
    ('CERT007', 'WK007', N'Chứng chỉ hàn', N'Còn hiệu lực', '2028-04-18', '2025-04-18'),
    ('CERT008', 'WK008', N'Chứng chỉ hàn', N'Còn hiệu lực', '2027-12-01', '2024-12-01'),
    ('CERT009', 'WK009', N'Làm việc trên cao', N'Còn hiệu lực', '2027-07-07', '2025-07-07'),
    ('CERT010', 'WK010', N'Làm việc trên cao', N'Hết hạn', '2026-10-25', '2024-10-25'),
    ('CERT011', 'WK011', N'Vận hành máy xây dựng', N'Còn hiệu lực', '2028-02-20', '2025-02-20'),
    ('CERT012', 'WK012', N'Vận hành máy xây dựng', N'Còn hiệu lực', '2029-01-05', '2026-01-05'),
    ('CERT013', 'WK013', N'Làm việc trên cao', N'Còn hiệu lực', '2027-08-30', '2025-08-30'),
    ('CERT014', 'WK014', N'An toàn lao động nhóm 3', N'Còn hiệu lực', '2027-11-11', '2025-11-11'),
    ('CERT015', 'WK015', N'An toàn lao động nhóm 3', N'Hết hạn', '2026-06-06', '2024-06-06'),
    ('CERT016', 'WK016', N'An toàn lao động nhóm 3', N'Còn hiệu lực', '2028-03-03', '2026-03-03'),
    ('CERT017', 'WK017', N'Sơ cấp cứu', N'Còn hiệu lực', '2027-09-14', '2025-09-14'),
    ('CERT018', 'WK018', N'Làm việc trên cao', N'Còn hiệu lực', '2028-05-22', '2026-05-22'),
    ('CERT019', 'WK019', N'An toàn lao động nhóm 3', N'Còn hiệu lực', '2027-10-01', '2025-10-01'),
    ('CERT020', 'WK007', N'Làm việc trên cao', N'Còn hiệu lực', '2027-05-05', '2025-05-05');
GO

-- VISIT: each visit references an existing visitor and site.
INSERT INTO dbo.VISIT
    (visit_id, visitor_id, site_id, status, visit_date, purpose,
     approval_status, check_in_time, check_out_time)
VALUES
    ('VST001', 'VIS-001', 'SITE-001', N'Đã ra', '2026-09-15', N'Giám sát tiến độ', N'Đã duyệt', '08:00', '11:30'),
    ('VST002', 'VIS-001', 'SITE-001', N'Đã ra', '2026-09-16', N'Họp với chủ đầu tư', N'Đã duyệt', '09:00', '12:00'),
    ('VST003', 'VIS-002', 'SITE-001', N'Đã ra', '2026-09-18', N'Giao vật tư', N'Đã duyệt', '07:30', '09:00'),
    ('VST004', 'VIS-002', 'SITE-001', N'Đã ra', '2026-09-20', N'Kiểm tra an toàn', N'Đã duyệt', '08:30', '16:00'),
    ('VST005', 'VIS-003', 'SITE-001', N'Đã ra', '2026-09-22', N'Nghiệm thu', N'Đã duyệt', '08:00', '15:30'),
    ('VST006', 'VIS-003', 'SITE-001', N'Đã ra', '2026-09-25', N'Giao vật tư', N'Đã duyệt', '06:45', '08:15'),
    ('VST007', 'VIS-004', 'SITE-002', N'Đã ra', '2026-09-28', N'Kiểm định chất lượng', N'Đã duyệt', '08:00', '14:00'),
    ('VST008', 'VIS-004', 'SITE-002', N'Đã hủy', '2026-09-30', N'Tham quan công trường', N'Từ chối', NULL, NULL),
    ('VST009', 'VIS-005', 'SITE-001', N'Đã ra', '2026-10-02', N'Giám sát tiến độ', N'Đã duyệt', '08:00', '11:00'),
    ('VST010', 'VIS-005', 'SITE-001', N'Đã ra', '2026-10-05', N'Giao vật tư', N'Đã duyệt', '07:00', '08:30'),
    ('VST011', 'VIS-006', 'SITE-001', N'Đã ra', '2026-10-08', N'Kiểm tra an toàn', N'Đã duyệt', '08:30', '12:00'),
    ('VST012', 'VIS-007', 'SITE-001', N'Đã ra', '2026-10-12', N'Họp với chủ đầu tư', N'Đã duyệt', '09:00', '11:45'),
    ('VST013', 'VIS-008', 'SITE-001', N'Đã ra', '2026-10-15', N'Nghiệm thu', N'Đã duyệt', '08:00', '16:30'),
    ('VST014', 'VIS-009', 'SITE-002', N'Đã ra', '2026-10-19', N'Giao vật tư', N'Đã duyệt', '07:15', '09:00'),
    ('VST015', 'VIS-010', 'SITE-002', N'Đã ra', '2026-10-22', N'Giám sát tiến độ', N'Đã duyệt', '08:00', '10:45'),
    ('VST016', 'VIS-015', 'SITE-001', N'Đã hủy', '2026-10-26', N'Tham quan công trường', N'Từ chối', NULL, NULL),
    ('VST017', 'VIS-016', 'SITE-001', N'Đã ra', '2026-10-29', N'Kiểm định chất lượng', N'Đã duyệt', '08:30', '15:00'),
    ('VST018', 'VIS-017', 'SITE-001', N'Đang trong công trường', '2026-10-31', N'Giao vật tư', N'Đã duyệt', '07:30', NULL),
    ('VST019', 'VIS-018', 'SITE-001', N'Chờ xử lý', '2026-11-03', N'Kiểm tra an toàn', N'Chờ duyệt', NULL, NULL),
    ('VST020', 'VIS-020', 'SITE-001', N'Chờ xử lý', '2026-11-05', N'Họp với chủ đầu tư', N'Chờ duyệt', NULL, NULL);
GO

-- SAFETY_ALERT: each alert is produced by one camera.
INSERT INTO dbo.SAFETY_ALERT
    (alert_id, camera_id, alert_type, detected_at, status, severity)
VALUES
    ('ALT-001', 'CAM-002', N'PPE_VIOLATION', '2026-10-25T09:30:00', N'CLOSED', N'HIGH'),
    ('ALT-002', 'CAM-003', N'RESTRICTED_ZONE', '2026-10-26T14:10:00', N'ACKNOWLEDGED', N'CRITICAL'),
    ('ALT-003', 'CAM-001', N'WORKER_COUNT', '2026-10-27T08:15:00', N'OPEN', N'MEDIUM'),
    ('ALT-004', 'CAM-002', N'NO_VEST', '2026-10-28T10:20:00', N'OPEN', N'HIGH'),
    ('ALT-005', 'CAM-001', N'UNKNOWN_PERSON', '2026-10-29T16:40:00', N'CLOSED', N'LOW'),
    ('ALT-006', 'CAM-005', N'EQUIPMENT_DANGER', '2026-10-30T11:05:00', N'ACKNOWLEDGED', N'HIGH');
GO

-- INCIDENT: each incident is linked to an existing safety alert.
INSERT INTO dbo.INCIDENT
    (incident_id, alert_id, incident_type, description)
VALUES
    ('INC-001', 'ALT-001', N'PPE_NONCOMPLIANCE', N'Safety briefing completed and PPE compliance was restored.'),
    ('INC-002', 'ALT-002', N'INTRUSION', N'Safety team investigated unauthorized access to the restricted zone.'),
    ('INC-003', 'ALT-002', N'FOLLOW_UP', N'Follow-up inspection was scheduled for the affected area.'),
    ('INC-004', 'ALT-004', N'PPE_NONCOMPLIANCE', N'Supervisor was asked to verify worker safety equipment.'),
    ('INC-005', 'ALT-005', N'IDENTITY_CHECK', N'Visitor identity was confirmed before site access.'),
    ('INC-006', 'ALT-006', N'EQUIPMENT_FAILURE', N'Maintenance team started checking the equipment storage area.');
GO

-- Row-count summary for a quick review after loading the sample data.
SELECT 'CONTRACTOR' AS table_name, COUNT(*) AS row_count FROM dbo.CONTRACTOR
UNION ALL SELECT 'CONSTRUCTION_SITE', COUNT(*) FROM dbo.CONSTRUCTION_SITE
UNION ALL SELECT 'VISITOR', COUNT(*) FROM dbo.VISITOR
UNION ALL SELECT 'WORKER', COUNT(*) FROM dbo.WORKER
UNION ALL SELECT 'ZONE', COUNT(*) FROM dbo.ZONE
UNION ALL SELECT 'CAMERA', COUNT(*) FROM dbo.CAMERA
UNION ALL SELECT 'ASSIGNMENT', COUNT(*) FROM dbo.ASSIGNMENT
UNION ALL SELECT 'SAFETY_CERTIFICATE', COUNT(*) FROM dbo.SAFETY_CERTIFICATE
UNION ALL SELECT 'VISIT', COUNT(*) FROM dbo.VISIT
UNION ALL SELECT 'SAFETY_ALERT', COUNT(*) FROM dbo.SAFETY_ALERT
UNION ALL SELECT 'INCIDENT', COUNT(*) FROM dbo.INCIDENT;
GO

SELECT *FROM WORKER
SELECT *FROM CONTRACTOR
SELECT *FROM CONSTRUCTION_SITE
SELECT *FROM ASSIGNMENT
SELECT *FROM CAMERA
SELECT *FROM ZONE
SELECT *FROM SAFETY_CERTIFICATE
SELECT *FROM SAFETY_ALERT
SELECT *FROM INCIDENT
