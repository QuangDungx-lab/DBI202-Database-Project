/*
    SmartSite - Lab 5
    Corrected INSERT script for Quang Dung's Lab 4 scope
    Tables: CONSTRUCTION_SITE, ZONE, CAMERA
    DBMS: Microsoft SQL Server

    IMPORTANT:
    - Column names and data types follow Dung_Lab4_Corrected.docx.
    - This script inserts 3 sites, 7 zones, and 10 cameras.
    - Run after the three tables and their constraints have been created.
    - Run this script only once unless the inserted rows are removed first.

    Lab 4 schema:
      CONSTRUCTION_SITE(site_id, site_name, address, status)
      ZONE(zone_id, site_id, zone_name, zone_type)
      CAMERA(camera_id, zone_id, camera_name, status)

    Allowed values proposed in Lab 4:
      CONSTRUCTION_SITE.status: ACTIVE, SUSPENDED, CLOSED
      ZONE.zone_type: GENERAL, RESTRICTED, STORAGE, ENTRANCE
      CAMERA.status: ACTIVE, INACTIVE, ERROR

    Note: CAMERA.camera_name is optional in Lab 4, but sample values
    are supplied here. No site_id is stored in CAMERA because its site
    is derived through CAMERA -> ZONE -> CONSTRUCTION_SITE.
*/
USE SmartSiteLab5;
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;

    /* 1. CONSTRUCTION_SITE: 3 rows */
    INSERT INTO dbo.CONSTRUCTION_SITE
        (site_id, site_name, address, status)
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
    INSERT INTO dbo.ZONE
        (zone_id, site_id, zone_name, zone_type)
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
    INSERT INTO dbo.CAMERA
        (camera_id, zone_id, camera_name, status)
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
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO

/* Verification 1: row counts */
SELECT 'CONSTRUCTION_SITE' AS TableName, COUNT(*) AS TotalRows
FROM dbo.CONSTRUCTION_SITE
WHERE site_id IN ('SITE-001', 'SITE-002', 'SITE-003')
UNION ALL
SELECT 'ZONE', COUNT(*)
FROM dbo.ZONE
WHERE zone_id BETWEEN 'ZONE-001' AND 'ZONE-007'
UNION ALL
SELECT 'CAMERA', COUNT(*)
FROM dbo.CAMERA
WHERE camera_id BETWEEN 'CAM-001' AND 'CAM-010';
GO

/* Verification 2: site -> zone -> camera */
SELECT
    s.site_id,
    s.site_name,
    s.status AS site_status,
    z.zone_id,
    z.zone_name,
    z.zone_type,
    c.camera_id,
    c.camera_name,
    c.status AS camera_status
FROM dbo.CONSTRUCTION_SITE AS s
LEFT JOIN dbo.ZONE AS z
    ON z.site_id = s.site_id
LEFT JOIN dbo.CAMERA AS c
    ON c.zone_id = z.zone_id
WHERE s.site_id IN ('SITE-001', 'SITE-002', 'SITE-003')
ORDER BY s.site_id, z.zone_id, c.camera_id;
GO

/* Verification 3: cameras grouped by status */
SELECT status, COUNT(*) AS camera_count
FROM dbo.CAMERA
WHERE camera_id BETWEEN 'CAM-001' AND 'CAM-010'
GROUP BY status
ORDER BY status;
GO
