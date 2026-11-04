/*
    SmartSite Lab 5 - SQL Queries: Basic, Intermediate and Advanced
    SQL Server 2022; matches database/CreateTable.sql and database/FileValue.sql.
    Run CreateTable.sql and FileValue.sql first, then run this file in SSMS.

    Select one query block at a time and press F5 to capture its result.
    Required counts in the course handout were not included in the template;
    compare the inventory below with the actual handout and add rows if needed.
*/
USE SmartSiteLab5;
GO

/* ======================== BASIC QUERIES ========================
   Inventory:
   Q-BAS-01 SELECT all
   Q-BAS-02 WHERE
   Q-BAS-03 ORDER BY
   Q-BAS-04 Aggregate functions
*/

-- Q-BAS-01 | SELECT all
-- Business question: What workers are currently recorded?
SELECT *
FROM dbo.WORKER;
GO

-- Q-BAS-02 | WHERE
-- Business question: Which visits are scheduled at SITE-001?
SELECT visit_id, visitor_id, site_id, visit_date, purpose,
       approval_status, check_in_time, check_out_time
FROM dbo.VISIT
WHERE site_id = 'SITE-001';
GO

-- Q-BAS-03 | ORDER BY
-- Business question: What are the visits from newest to oldest?
SELECT visit_id, visitor_id, site_id, visit_date, status
FROM dbo.VISIT
ORDER BY visit_date DESC, visit_id ASC;
GO

-- Q-BAS-04 | Aggregate functions
-- Business question: How many rows exist in each main operational table?
SELECT
    (SELECT COUNT(*) FROM dbo.WORKER) AS worker_count,
    (SELECT COUNT(*) FROM dbo.VISIT) AS visit_count,
    (SELECT COUNT(*) FROM dbo.SAFETY_ALERT) AS alert_count,
    (SELECT COUNT(*) FROM dbo.INCIDENT) AS incident_count;
GO

/* =========================== JOINS ============================= */

-- Q-JOIN-01 | INNER JOIN
-- Business question: Which contractor employs each worker?
SELECT w.worker_id, w.full_name, w.trade,
       c.contractor_id, c.company_name
FROM dbo.WORKER AS w
INNER JOIN dbo.CONTRACTOR AS c
    ON w.contractor_id = c.contractor_id
ORDER BY c.contractor_id, w.worker_id;
GO

-- Q-JOIN-02 | INNER JOIN across three tables
-- Business question: Who visited each site, on what date, and why?
SELECT v.visit_id, visitor.full_name AS visitor_name,
       site.site_name, v.visit_date, v.purpose, v.approval_status
FROM dbo.VISIT AS v
INNER JOIN dbo.VISITOR AS visitor
    ON v.visitor_id = visitor.visitor_id
INNER JOIN dbo.CONSTRUCTION_SITE AS site
    ON v.site_id = site.site_id
ORDER BY v.visit_date, v.visit_id;
GO

-- Q-JOIN-03 | LEFT JOIN
-- Business question: Which cameras belong to each zone, including zones with no camera?
SELECT site.site_name, z.zone_id, z.zone_name,
       cam.camera_id, cam.camera_name, cam.camera_status
FROM dbo.ZONE AS z
INNER JOIN dbo.CONSTRUCTION_SITE AS site
    ON z.site_id = site.site_id
LEFT JOIN dbo.CAMERA AS cam
    ON z.zone_id = cam.zone_id
ORDER BY site.site_id, z.zone_id, cam.camera_id;
GO

/* ====================== GROUP BY / HAVING ====================== */

-- Q-GROUP-01 | GROUP BY and HAVING
-- Business question: Which contractors employ more than one worker?
SELECT c.contractor_id, c.company_name,
       COUNT(w.worker_id) AS worker_count
FROM dbo.CONTRACTOR AS c
INNER JOIN dbo.WORKER AS w
    ON c.contractor_id = w.contractor_id
GROUP BY c.contractor_id, c.company_name
HAVING COUNT(w.worker_id) > 1
ORDER BY worker_count DESC, c.contractor_id;
GO

-- Q-GROUP-02 | GROUP BY and HAVING
-- Business question: Which sites have at least two recorded visits?
SELECT site.site_id, site.site_name,
       COUNT(v.visit_id) AS visit_count
FROM dbo.CONSTRUCTION_SITE AS site
LEFT JOIN dbo.VISIT AS v
    ON site.site_id = v.site_id
GROUP BY site.site_id, site.site_name
HAVING COUNT(v.visit_id) >= 2
ORDER BY visit_count DESC, site.site_id;
GO

-- Q-GROUP-03 | GROUP BY aggregate report
-- Business question: How many alerts exist for each status and severity?
SELECT status, severity, COUNT(alert_id) AS alert_count
FROM dbo.SAFETY_ALERT
GROUP BY status, severity
ORDER BY status, severity;
GO

/* ========================= SUBQUERIES ========================== */

-- Q-SUB-01 | IN subquery
-- Business question: Which workers hold a certificate marked as currently valid?
SELECT worker_id, full_name, trade
FROM dbo.WORKER
WHERE worker_id IN (
    SELECT worker_id
    FROM dbo.SAFETY_CERTIFICATE
    WHERE status = N'Còn hiệu lực'
)
ORDER BY worker_id;
GO

-- Q-SUB-02 | Nested subqueries
-- Business question: Which sites have more visits than the average visit count per site?
SELECT site.site_id, site.site_name,
       (SELECT COUNT(*)
        FROM dbo.VISIT AS v
        WHERE v.site_id = site.site_id) AS visit_count
FROM dbo.CONSTRUCTION_SITE AS site
WHERE (SELECT COUNT(*)
       FROM dbo.VISIT AS v
       WHERE v.site_id = site.site_id)
      >
      (SELECT AVG(site_visit_counts.visit_count * 1.0)
       FROM (
           SELECT site2.site_id, COUNT(v2.visit_id) AS visit_count
           FROM dbo.CONSTRUCTION_SITE AS site2
           LEFT JOIN dbo.VISIT AS v2
               ON site2.site_id = v2.site_id
           GROUP BY site2.site_id
       ) AS site_visit_counts)
ORDER BY visit_count DESC;
GO

/* ====================== EXISTS / ANY / ALL ===================== */

-- Q-EXISTS-01 | EXISTS
-- Business question: Which sites have at least one visit?
SELECT site.site_id, site.site_name
FROM dbo.CONSTRUCTION_SITE AS site
WHERE EXISTS (
    SELECT visit_id
    FROM dbo.VISIT AS v
    WHERE v.site_id = site.site_id
)
ORDER BY site.site_id;
GO

-- Q-EXISTS-02 | NOT EXISTS
-- Business question: Which workers do not yet have a safety certificate?
SELECT w.worker_id, w.full_name, w.trade
FROM dbo.WORKER AS w
WHERE NOT EXISTS (
    SELECT cert.certificate_id
    FROM dbo.SAFETY_CERTIFICATE AS cert
    WHERE cert.worker_id = w.worker_id
)
ORDER BY w.worker_id;
GO

-- Q-ANY-01 | ANY
-- Business question: Which assignments started later than at least one assignment at SITE-001?
SELECT assignment_id, worker_id, site_id, start_date
FROM dbo.ASSIGNMENT
WHERE start_date > ANY (
    SELECT start_date
    FROM dbo.ASSIGNMENT
    WHERE site_id = 'SITE-001'
)
ORDER BY start_date, assignment_id;
GO

-- Q-ALL-01 | ALL
-- Business question: Which assignments started on or after every assignment start date at SITE-001?
SELECT assignment_id, worker_id, site_id, start_date
FROM dbo.ASSIGNMENT
WHERE start_date >= ALL (
    SELECT start_date
    FROM dbo.ASSIGNMENT
    WHERE site_id = 'SITE-001'
)
ORDER BY start_date, assignment_id;
GO

/* ======================== SET OPERATIONS ======================== */

-- Q-SET-01 | UNION
-- Business question: Show one combined name list for workers and visitors.
SELECT full_name AS person_name, N'Worker' AS person_type
FROM dbo.WORKER
UNION
SELECT full_name, N'Visitor'
FROM dbo.VISITOR
ORDER BY person_type, person_name;
GO

-- Q-SET-02 | INTERSECT
-- Business question: Which workers have both an assignment and a safety certificate?
SELECT worker_id
FROM dbo.ASSIGNMENT
INTERSECT
SELECT worker_id
FROM dbo.SAFETY_CERTIFICATE
ORDER BY worker_id;
GO

-- Q-SET-03 | EXCEPT
-- Business question: Which workers have no safety certificate?
SELECT worker_id
FROM dbo.WORKER
EXCEPT
SELECT worker_id
FROM dbo.SAFETY_CERTIFICATE
ORDER BY worker_id;
GO
