USE SmartSiteLab5;
INSERT INTO dbo.CONSTRUCTION_SITE (site_id, site_name, address, status)
    VALUES
        ('SITE-001', N'Riverside Residential Complex',
         N'Thu Duc City, Ho Chi Minh City', 'ACTIVE'),
        ('SITE-002', N'Harbor Logistics Warehouse',
         N'Hai Phong Port Area, Hai Phong', 'ACTIVE'),
        ('SITE-003', N'Old Town Renovation Project',
         N'Hoi An, Quang Nam', 'CLOSED'),
         ('SITE-004', N'Green Valley Apartment',
         N'District 7, Ho Chi Minh City', 'ACTIVE'),

        ('SITE-005', N'Central Business Tower',
         N'District 1, Ho Chi Minh City', 'SUSPENDED'),

        ('SITE-006', N'Northern Industrial Complex',
         N'Bac Ninh Province, Vietnam', 'ACTIVE');

    /* 2. ZONE: 7 rows */
INSERT INTO dbo.ZONE (zone_id, site_id, zone_name, zone_type)
VALUES
    ('ZONE-001', 'SITE-001', N'Main Gate', 'ENTRANCE'),
    ('ZONE-002', 'SITE-001', N'Foundation Area', 'RESTRICTED'),
    ('ZONE-003', 'SITE-001', N'Material Storage', 'STORAGE'),
    ('ZONE-004', 'SITE-002', N'Loading Dock', 'GENERAL'),
    ('ZONE-005', 'SITE-002', N'Storage Rack Aisle', 'STORAGE'),
    ('ZONE-006', 'SITE-002', N'Security Entrance', 'ENTRANCE'),
    ('ZONE-007', 'SITE-003', N'Renovation Work Area', 'RESTRICTED'),
    ('ZONE-006', 'SITE-004', N'Building Entrance', 'ENTRANCE'),
    ('ZONE-007', 'SITE-004', N'Underground Parking', 'RESTRICTED'),
    ('ZONE-008', 'SITE-005', N'Office Floor Area', 'GENERAL'),
    ('ZONE-009', 'SITE-005', N'Equipment Storage', 'STORAGE'),
    ('ZONE-010', 'SITE-006', N'Factory Security Gate', 'ENTRANCE');
/* 3. CAMERA: 10 rows */
INSERT INTO dbo.CAMERA (camera_id, zone_id, camera_name, status)
    VALUES
        ('CAM-001', 'ZONE-001', N'Main Gate Camera 1', 'ACTIVE'),
        ('CAM-002', 'ZONE-001', N'Main Gate Camera 2', 'ACTIVE'),
        ('CAM-003', 'ZONE-002', N'Foundation North Camera', 'ACTIVE'),
        ('CAM-004', 'ZONE-002', N'Foundation South Camera', 'INACTIVE'),
        ('CAM-005', 'ZONE-003', N'Material Storage Camera', 'ERROR'),
        ('CAM-006', 'ZONE-004', N'Loading Dock Camera 1', 'ACTIVE'),
        ('CAM-007', 'ZONE-004', N'Loading Dock Camera 2', 'ACTIVE'),
        ('CAM-008', 'ZONE-005', N'Storage Aisle Camera', 'INACTIVE'),
        ('CAM-009', 'ZONE-006', N'Security Entrance Camera', 'ACTIVE'),
        ('CAM-010', 'ZONE-007', N'Renovation Area Camera', 'ACTIVE');
