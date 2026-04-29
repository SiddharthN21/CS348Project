-- How do you evaluate CS Full in your degree audit?
SELECT SUM(c.min_credit)
FROM student_course sc
JOIN course c ON sc.course_id = c.course_id
WHERE sc.student_id = 10  -- pass student id
  AND sc.status = 'COMPLETED';
-- Compare total_credits >= 120
