-- ============================================================
-- AUTO‑GENERATE STUDENT COURSE HISTORY
-- For every student:
--   Insert 15–20 random courses
--   Random grade, term, year, credits
-- ============================================================

SET SQL_SAFE_UPDATES = 0;
DELETE FROM student_course;
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE student_course AUTO_INCREMENT = 1;

DROP PROCEDURE IF EXISTS populate_student_courses;
DELIMITER $$

CREATE PROCEDURE populate_student_courses()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE sid INT;

    DECLARE cur CURSOR FOR SELECT student_id FROM student;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO sid;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Random number of courses (15–20)
        SET @course_count = FLOOR(15 + RAND() * 6);

        -- Drop temp table
        DROP TEMPORARY TABLE IF EXISTS tmp_courses;

        -- Build dynamic SQL to allow LIMIT @course_count
        SET @sql = CONCAT(
            'CREATE TEMPORARY TABLE tmp_courses AS ',
            'SELECT course_id, max_credit FROM course ORDER BY RAND() LIMIT ',
            @course_count
        );

        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        -- Insert unique courses for this student
        INSERT INTO student_course (student_id, course_id, term_code, year, credits, status, grade)
        SELECT
            sid,
            course_id,
            ELT(FLOOR(1 + RAND() * 3), 'SPRING','SUMMER','FALL') AS term_code,
            FLOOR(2022 + RAND() * 4) AS year,
            max_credit AS credits,
            'COMPLETED' AS status,
            ELT(
                FLOOR(1 + RAND() * 12),
                'A+','A','A-','B+','B','B-','C+','C','C-','D+','D','F'
            ) AS grade
        FROM tmp_courses;

    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;

CALL populate_student_courses();

SELECT COUNT(*) AS total_rows FROM student_course;