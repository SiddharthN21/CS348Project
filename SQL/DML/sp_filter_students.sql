-- ============================================================
-- Drop procedure if it already exists
-- ============================================================
DROP PROCEDURE IF EXISTS sp_filter_students;
DELIMITER $$

-- ============================================================
-- Stored Procedure: sp_filter_students
-- Purpose:
--   Returns student report data based on ONE active filter:
--     1. Year + Term (from student_course.year + term_code)
--     2. GPA Range (from student.avg_gpa)
--     3. Course Taken (from student_course.course_id)
--
-- Output (same for all cases):
--   student_id, full_name, avg_gpa,
--   year, term_code,
--   course_code, course_title, grade
--
-- Notes:
--   - Only ONE filter is active at a time (frontend enforces this)
--   - Always returns one row per student-course (COMPLETED only)
--   - No GROUP_CONCAT; no summary rows
--   - Sorting: avg_gpa DESC, full_name ASC, year DESC, term_code DESC
-- ============================================================

CREATE PROCEDURE sp_filter_students (
    IN p_year VARCHAR(4),
    IN p_term_code VARCHAR(10),
    IN p_min_gpa DECIMAL(5,4),
    IN p_max_gpa DECIMAL(5,4),
    IN p_course_id INT
)
BEGIN

    -- -------------------------------------------------------------------
    -- CASE 1: Filter by YEAR + TERM
    -- Returns all COMPLETED courses taken in that year+term
    -- One row per student-course
    -- -------------------------------------------------------------------
 IF p_year IS NOT NULL AND p_term_code IS NOT NULL THEN

        SELECT 
            s.student_id,
            s.full_name,
            s.avg_gpa,
            sc.year,
            sc.term_code,
            CONCAT(c.subject_code, c.course_number) AS course_code,
            c.title AS course_title,
            sc.grade
        FROM student s
        JOIN student_course sc 
            ON s.student_id = sc.student_id
        JOIN course c
            ON sc.course_id = c.course_id
        WHERE sc.status = 'COMPLETED'
          AND sc.year = p_year
          AND sc.term_code = p_term_code
        ORDER BY 
            s.avg_gpa DESC,
            s.full_name ASC,
            sc.year DESC,
            sc.term_code DESC;

    -- -------------------------------------------------------------------
    -- CASE 2: Filter by GPA RANGE
    -- Returns all COMPLETED courses for students whose avg_gpa is in range
    -- One row per student-course
    -- -------------------------------------------------------------------
    ELSEIF p_min_gpa IS NOT NULL AND p_max_gpa IS NOT NULL THEN

        SELECT 
            s.student_id,
            s.full_name,
            s.avg_gpa,
            sc.year,
            sc.term_code,
            CONCAT(c.subject_code, c.course_number) AS course_code,
            c.title AS course_title,
            sc.grade
        FROM student s
        JOIN student_course sc 
            ON s.student_id = sc.student_id
        JOIN course c
            ON sc.course_id = c.course_id
        WHERE sc.status = 'COMPLETED'
          AND s.avg_gpa BETWEEN p_min_gpa AND p_max_gpa
        ORDER BY 
            s.avg_gpa DESC,
            s.full_name ASC,
            sc.year DESC,
            sc.term_code DESC;

    -- -------------------------------------------------------------------
    -- CASE 3: Filter by COURSE
    -- Returns all students who took that course (COMPLETED)
    -- One row per student-course
    -- -------------------------------------------------------------------
    ELSEIF p_course_id IS NOT NULL THEN

        SELECT 
            s.student_id,
            s.full_name,
            s.avg_gpa,
            sc.year,
            sc.term_code,
            CONCAT(c.subject_code, c.course_number) AS course_code,
            c.title AS course_title,
            sc.grade
        FROM student s
        JOIN student_course sc 
            ON s.student_id = sc.student_id
        JOIN course c
            ON sc.course_id = c.course_id
        WHERE sc.status = 'COMPLETED'
          AND sc.course_id = p_course_id
        ORDER BY 
            s.avg_gpa DESC,
            s.full_name ASC,
            sc.year DESC,
            sc.term_code DESC;

    -- -------------------------------------------------------------------
    -- CASE 4: No filter provided (fallback)
    -- Returns all COMPLETED courses for all students
    -- One row per student-course
    -- -------------------------------------------------------------------
    ELSE

        SELECT 
            s.student_id,
            s.full_name,
            s.avg_gpa,
            sc.year,
            sc.term_code,
            CONCAT(c.subject_code, c.course_number) AS course_code,
            c.title AS course_title,
            sc.grade
        FROM student s
        JOIN student_course sc 
            ON s.student_id = sc.student_id
        JOIN course c
            ON sc.course_id = c.course_id
        WHERE sc.status = 'COMPLETED'
        ORDER BY 
            s.avg_gpa DESC,
            s.full_name ASC,
            sc.year DESC,
            sc.term_code DESC;

    END IF;

END $$
DELIMITER ;