-- ============================================================================
-- SQL Setup - Set C Data Analysis Exam
-- SQL Dialect: SQLite 3.40+
-- ============================================================================
-- This script creates the courses and assessments tables and loads 12 clean rows
-- (duplicate row removed before INSERT)

-- Drop existing tables if present
DROP TABLE IF EXISTS assessments;
DROP TABLE IF EXISTS courses;

-- ============================================================================
-- COURSES (Lookup Table) - 4 rows
-- ============================================================================
CREATE TABLE courses (
    course_id TEXT PRIMARY KEY,
    course TEXT NOT NULL,
    department TEXT NOT NULL
);

INSERT INTO courses (course_id, course, department) VALUES
('C1', 'Excel', 'Business'),
('C2', 'PowerBI', 'Business'),
('C3', 'SQL', 'Technology'),
('C4', 'Python', 'Technology');

-- ============================================================================
-- ASSESSMENTS (Fact Table) - 12 rows (duplicate removed)
-- ============================================================================
CREATE TABLE assessments (
    assessment_id INTEGER PRIMARY KEY,
    month TEXT NOT NULL,
    course_id TEXT NOT NULL,
    batch TEXT NOT NULL,
    score NUMERIC NOT NULL,
    attendance_pct NUMERIC NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO assessments (assessment_id, month, course_id, batch, score, attendance_pct) VALUES
(1, 'Jan', 'C1', 'Morning', 72, 90),
(2, 'Jan', 'C2', 'Evening', 45, 70),
(3, 'Jan', 'C3', 'Morning', 65, 85),
(4, 'Jan', 'C4', 'Weekend', 38, 60),
(5, 'Feb', 'C1', 'Evening', 80, 95),
(6, 'Feb', 'C2', 'Weekend', 55, 80),
(7, 'Feb', 'C3', 'Morning', 48, 75),
(8, 'Feb', 'C4', 'Evening', 68, 88),
(9, 'Mar', 'C1', 'Weekend', 90, 98),
(10, 'Mar', 'C2', 'Morning', 60, 82),
(11, 'Mar', 'C3', 'Evening', 75, 92),
(12, 'Mar', 'C4', 'Weekend', 42, 65);

-- ============================================================================
-- VERIFICATION: Check row counts
-- ============================================================================
SELECT 'Courses loaded' as status, COUNT(*) as row_count FROM courses;
SELECT 'Assessments loaded (12 clean)' as status, COUNT(*) as row_count FROM assessments;
