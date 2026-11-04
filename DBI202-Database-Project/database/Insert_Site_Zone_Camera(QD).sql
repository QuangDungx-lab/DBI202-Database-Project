USE SmartSiteLab5;

INSERT INTO dbo.CONSTRUCTION_SITE (SiteCode, SiteName, SiteAddress, IsActive) VALUES
    ('SITE-002', N'Riverside Residential Complex', N'Thu Duc City, Ho Chi Minh City', 1),
    ('SITE-003', N'Harbor Logistics Warehouse', N'Hai Phong Port Area, Hai Phong', 1),
    ('SITE-004', N'Old Town Renovation Project', N'Hoi An, Quang Nam', 0),
    ('SITE-005', N'Green Valley Apartment', N'District 7, Ho Chi Minh City', 1),
    ('SITE-006', N'Central Business Tower', N'District 1, Ho Chi Minh City', 0),
    ('SITE-007', N'Northern Industrial Complex', N'Bac Ninh Province, Vietnam', 1);
 
/* 2. ZONE: 12 rows (ZoneID 4-15). SiteID: 2 = SITE-002 ... 7 = SITE-007 */
INSERT INTO dbo.ZONE (SiteID, ZoneCode, ZoneName, RiskLevel) VALUES
    (2, 'ZONE-001', N'Main Gate', 'LOW'),
    (2, 'ZONE-002', N'Foundation Area', 'HIGH'),
    (2, 'ZONE-003', N'Material Storage', 'MEDIUM'),
    (3, 'ZONE-004', N'Loading Dock', 'LOW'),
    (3, 'ZONE-005', N'Storage Rack Aisle', 'MEDIUM'),
    (3, 'ZONE-006', N'Security Entrance', 'LOW'),
    (4, 'ZONE-007', N'Renovation Work Area', 'HIGH'),
    (5, 'ZONE-008', N'Building Entrance', 'LOW'),
    (5, 'ZONE-009', N'Underground Parking', 'HIGH'),
    (6, 'ZONE-010', N'Office Floor Area', 'LOW'),
    (6, 'ZONE-011', N'Equipment Storage', 'MEDIUM'),
    (7, 'ZONE-012', N'Factory Security Gate', 'LOW');
 
/* 3. CAMERA: 10 rows (CameraID 4-13). ZoneID 4 = ZONE-001 ... 15 = ZONE-012 */
INSERT INTO dbo.CAMERA (ZoneID, CameraCode, CameraName, CameraStatus) VALUES
    (4, 'CAM-004', N'Main Gate Camera 1', 'ONLINE'),
    (4, 'CAM-005', N'Main Gate Camera 2', 'ONLINE'),
    (5, 'CAM-006', N'Foundation North Camera', 'ONLINE'),
    (5, 'CAM-007', N'Foundation South Camera', 'OFFLINE'),
    (6, 'CAM-008', N'Material Storage Camera', 'MAINTENANCE'),
    (7, 'CAM-009', N'Loading Dock Camera 1', 'ONLINE'),
    (7, 'CAM-010', N'Loading Dock Camera 2', 'ONLINE'),
    (8, 'CAM-011', N'Storage Aisle Camera', 'OFFLINE'),
    (9, 'CAM-012', N'Security Entrance Camera', 'ONLINE'),
    (10, 'CAM-013', N'Renovation Area Camera', 'ONLINE');
GO