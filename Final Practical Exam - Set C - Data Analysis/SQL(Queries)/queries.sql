-- ============================================================================
-- SQL Analytical Queries - Set C
-- Execute setup.sql first, then this file
-- ============================================================================

-- ============================================================================
-- S2a: Average Score by Department (ordered by avg_score ascending)
-- ============================================================================
.mode csv
.output outputs/sql/s2a_avg_score_by_department.csv

SELECT 
    c.department,
    ROUND(AVG(a.score), 2) as avg_score
FROM assessments a
JOIN courses c ON a.course_id = c.course_id
GROUP BY c.department
ORDER BY avg_score ASC;

.output stdout
.mode list

-- ============================================================================
-- S2b: Underperforming Courses (average score < 60)
-- ============================================================================
.mode csv
.output outputs/sql/s2b_underperforming_courses.csv

SELECT 
    c.course_id,
    c.course,
    c.department,
    ROUND(AVG(a.score), 2) as avg_score,
    COUNT(a.assessment_id) as assessment_count
FROM assessments a
JOIN courses c ON a.course_id = c.course_id
GROUP BY c.course_id, c.course, c.department
HAVING AVG(a.score) < 60
ORDER BY avg_score ASC;

.output stdout
.mode list

-- ============================================================================
-- S2c: Top Two Batches by Average Score (alphabetical tie-break)
-- ============================================================================
.mode csv
.output outputs/sql/s2c_top_two_batches.csv

SELECT 
    batch,
    ROUND(AVG(score), 2) as avg_score,
    COUNT(assessment_id) as assessment_count
FROM assessments
GROUP BY batch
ORDER BY avg_score DESC, batch ASC
LIMIT 2;

.output stdout
.mode list

-- ============================================================================
-- DIAGNOSTIC: Data Integrity Check
-- Verify that all course_ids in assessments match the courses table
-- Expected result: 0 unmatched keys
-- ============================================================================
.mode csv
.output outputs/sql/s3_data_integrity_check.csv

SELECT 
    'Data Integrity Check' as check_type,
    COUNT(*) as unmatched_keys
FROM assessments a
LEFT JOIN courses c ON a.course_id = c.course_id
WHERE c.course_id IS NULL;

.output stdout
.mode list
