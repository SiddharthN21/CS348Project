-- ============================================================
-- Helper function: promote grade one notch upward
-- ============================================================
DROP FUNCTION IF EXISTS next_grade;
DELIMITER $$

CREATE FUNCTION next_grade(old_grade CHAR(2))
RETURNS CHAR(2)
DETERMINISTIC
BEGIN
    RETURN CASE old_grade
        WHEN 'F'  THEN 'D'
        WHEN 'D'  THEN 'D+'
        WHEN 'D+' THEN 'C-'
        WHEN 'C-' THEN 'C'
        WHEN 'C'  THEN 'C+'
        WHEN 'C+' THEN 'B-'
        WHEN 'B-' THEN 'B'
        WHEN 'B'  THEN 'B+'
        WHEN 'B+' THEN 'A-'
        WHEN 'A-' THEN 'A'
        WHEN 'A'  THEN 'A+'
        ELSE old_grade
    END;
END$$

DELIMITER ;


-- ============================================================
-- Procedure: promote ONE non-A+ course per student
-- ============================================================
DROP PROCEDURE IF EXISTS promote_one_course_per_student;
DELIMITER $$

CREATE PROCEDURE promote_one_course_per_student()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE sid INT;

    DECLARE cur CURSOR FOR SELECT student_id FROM student;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    promote_loop: LOOP
        FETCH cur INTO sid;
        IF done THEN
            LEAVE promote_loop;
        END IF;

        -- Pick ONE course for this student that is NOT A+
        SELECT student_course_id, course_id, term_code, year, credits, grade
        INTO @scid, @cid, @term, @yr, @cr, @old_grade
        FROM student_course
        WHERE student_id = sid
          AND grade <> 'A+'
        -- ORDER BY RAND()
        ORDER BY grade DESC
        LIMIT 1;

        -- If student has only A+ grades, skip
        IF @scid IS NULL THEN
            ITERATE promote_loop;
        END IF;

        -- Compute next grade
        SET @new_grade = next_grade(@old_grade);

        -- Call your existing stored procedure
        CALL sp_manage_student_course(
            'UPDATE',
            @scid,     -- student_course_id
            sid,       -- student_id (for GPA recalculation)
            NULL,      -- course_id not needed for UPDATE
            @term,     -- term_code
            @yr,       -- year
            @cr,       -- credits
            @new_grade,
            @msg
        );
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;


-- ============================================================
-- Execute the promotion procedure
-- ============================================================
CALL promote_one_course_per_student();

SELECT 'Grade promotion completed for all students' AS status;