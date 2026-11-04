/* Member 1: schema, constraints, indexes, seed data. SQL Server 2019+ recommended. */
USE master;
GO
IF DB_ID(N'SmartSiteLab5') IS NOT NULL
BEGIN
    ALTER DATABASE SmartSiteLab5 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SmartSiteLab5;
END
GO
CREATE DATABASE SmartSiteLab5;
GO
USE SmartSiteLab5;
GO
/*
    SmartSite schema aligned to Contractor_worker_assignment-Page ERD.
    Run in an empty SmartSiteLab5 database.
    All business identifiers are VARCHAR(20) codes supplied by INSERT scripts.
    This file defines ERD entities only; AI_METADATA and ATTENDANCE are not in the ERD.
*/
USE SmartSiteLab5;
GO

CREATE TABLE dbo.CONTRACTOR (
    contractor_id VARCHAR(20) NOT NULL,
    company_name NVARCHAR(120) NOT NULL,
    contact_person NVARCHAR(150) NULL,
    status NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_CONTRACTOR PRIMARY KEY (contractor_id)
);
GO

CREATE TABLE dbo.CONSTRUCTION_SITE (
    site_id VARCHAR(20) NOT NULL,
    site_name NVARCHAR(150) NOT NULL,
    address NVARCHAR(250) NULL,
    status NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_CONSTRUCTION_SITE PRIMARY KEY (site_id)
);
GO

CREATE TABLE dbo.VISITOR (
    visitor_id VARCHAR(20) NOT NULL,
    full_name NVARCHAR(120) NOT NULL,
    phone VARCHAR(20) NULL,
    email VARCHAR(254) NULL,
    company NVARCHAR(150) NULL,
    id_number VARCHAR(30) NULL,
    status NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_VISITOR PRIMARY KEY (visitor_id)
);
GO

CREATE TABLE dbo.WORKER (
    worker_id VARCHAR(20) NOT NULL,
    contractor_id VARCHAR(20) NOT NULL,
    full_name NVARCHAR(120) NOT NULL,
    trade NVARCHAR(80) NOT NULL,
    id_status NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_WORKER PRIMARY KEY (worker_id),
    CONSTRAINT FK_WORKER_CONTRACTOR
        FOREIGN KEY (contractor_id) REFERENCES dbo.CONTRACTOR(contractor_id)
);
GO

CREATE TABLE dbo.ZONE (
    zone_id VARCHAR(20) NOT NULL,
    site_id VARCHAR(20) NOT NULL,
    zone_status NVARCHAR(50) NOT NULL,
    zone_name NVARCHAR(120) NOT NULL,
    zone_type NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_ZONE PRIMARY KEY (zone_id),
    CONSTRAINT FK_ZONE_SITE
        FOREIGN KEY (site_id) REFERENCES dbo.CONSTRUCTION_SITE(site_id)
);
GO

CREATE TABLE dbo.CAMERA (
    camera_id VARCHAR(20) NOT NULL,
    zone_id VARCHAR(20) NOT NULL,
    camera_status NVARCHAR(50) NOT NULL,
    camera_name NVARCHAR(120) NOT NULL,
    CONSTRAINT PK_CAMERA PRIMARY KEY (camera_id),
    CONSTRAINT FK_CAMERA_ZONE
        FOREIGN KEY (zone_id) REFERENCES dbo.ZONE(zone_id)
);
GO

CREATE TABLE dbo.ASSIGNMENT (
    assignment_id VARCHAR(20) NOT NULL,
    worker_id VARCHAR(20) NOT NULL,
    site_id VARCHAR(20) NOT NULL,
    status NVARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    CONSTRAINT PK_ASSIGNMENT PRIMARY KEY (assignment_id),
    CONSTRAINT FK_ASSIGNMENT_WORKER
        FOREIGN KEY (worker_id) REFERENCES dbo.WORKER(worker_id),
    CONSTRAINT FK_ASSIGNMENT_SITE
        FOREIGN KEY (site_id) REFERENCES dbo.CONSTRUCTION_SITE(site_id),
    CONSTRAINT CK_ASSIGNMENT_DATES
        CHECK (end_date IS NULL OR end_date >= start_date)
);
GO

CREATE TABLE dbo.SAFETY_CERTIFICATE (
    certificate_id VARCHAR(20) NOT NULL,
    worker_id VARCHAR(20) NOT NULL,
    certificate_type NVARCHAR(100) NOT NULL,
    status NVARCHAR(50) NOT NULL,
    expiry_date DATE NOT NULL,
    issue_date DATE NOT NULL,
    CONSTRAINT PK_SAFETY_CERTIFICATE PRIMARY KEY (certificate_id),
    CONSTRAINT FK_CERTIFICATE_WORKER
        FOREIGN KEY (worker_id) REFERENCES dbo.WORKER(worker_id),
    CONSTRAINT CK_CERTIFICATE_DATES
        CHECK (expiry_date >= issue_date)
);
GO

CREATE TABLE dbo.VISIT (
    visit_id VARCHAR(20) NOT NULL,
    visitor_id VARCHAR(20) NOT NULL,
    site_id VARCHAR(20) NOT NULL,
    status NVARCHAR(50) NOT NULL,
    visit_date DATE NOT NULL,
    purpose NVARCHAR(250) NULL,
    approval_status NVARCHAR(50) NOT NULL,
    check_in_time TIME(0) NULL,
    check_out_time TIME(0) NULL,
    CONSTRAINT PK_VISIT PRIMARY KEY (visit_id),
    CONSTRAINT FK_VISIT_VISITOR
        FOREIGN KEY (visitor_id) REFERENCES dbo.VISITOR(visitor_id),
    CONSTRAINT FK_VISIT_SITE
        FOREIGN KEY (site_id) REFERENCES dbo.CONSTRUCTION_SITE(site_id),
    CONSTRAINT CK_VISIT_TIMES
        CHECK (check_in_time IS NULL OR check_out_time IS NULL OR check_out_time >= check_in_time)
);
GO

CREATE TABLE dbo.SAFETY_ALERT (
    alert_id VARCHAR(20) NOT NULL,
    camera_id VARCHAR(20) NOT NULL,
    alert_type NVARCHAR(80) NOT NULL,
    detected_at DATETIME2(0) NOT NULL,
    status NVARCHAR(50) NOT NULL,
    severity NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_SAFETY_ALERT PRIMARY KEY (alert_id),
    CONSTRAINT FK_ALERT_CAMERA
        FOREIGN KEY (camera_id) REFERENCES dbo.CAMERA(camera_id)
);
GO

CREATE TABLE dbo.INCIDENT (
    incident_id VARCHAR(20) NOT NULL,
    alert_id VARCHAR(20) NOT NULL,
    incident_type NVARCHAR(80) NOT NULL,
    description NVARCHAR(500) NULL,
    CONSTRAINT PK_INCIDENT PRIMARY KEY (incident_id),
    CONSTRAINT FK_INCIDENT_ALERT
        FOREIGN KEY (alert_id) REFERENCES dbo.SAFETY_ALERT(alert_id)
);
GO
