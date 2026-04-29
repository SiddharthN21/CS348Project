DROP PROCEDURE IF EXISTS sp_generate_degree_plan;
DELIMITER $$

CREATE PROCEDURE sp_generate_degree_plan(IN p_student_id INT)
BEGIN
    DECLARE v_snapshot_id INT;
    DECLARE v_semester_order INT DEFAULT 1;
    DECLARE v_semester_name VARCHAR(20) DEFAULT 'Fall 2026';
    DECLARE v_sem_credits INT DEFAULT 0;
    DECLARE v_course_id INT;
    DECLARE v_course_credits INT;

    -- 1. Remove existing snapshot + details (only one snapshot per student)
    DELETE FROM degree_plan_snapshot_detail
    WHERE snapshot_id IN (
        SELECT snapshot_id FROM degree_plan_snapshot WHERE student_id = p_student_id
    );

    DELETE FROM degree_plan_snapshot
    WHERE student_id = p_student_id;

    -- 2. Create new snapshot header
    INSERT INTO degree_plan_snapshot (student_id)
    VALUES (p_student_id);

    SET v_snapshot_id = LAST_INSERT_ID();

    -- 3. TEMP TABLES

    -- 3.1 Completed courses
    DROP TEMPORARY TABLE IF EXISTS tmp_completed;
    CREATE TEMPORARY TABLE tmp_completed (course_id INT PRIMARY KEY);

    INSERT INTO tmp_completed (course_id)
    SELECT course_id
    FROM student_course
    WHERE student_id = p_student_id;

    -- 3.2 Required courses (CS Core, Math Core, Science Core, University Core, CS Electives)
    DROP TEMPORARY TABLE IF EXISTS tmp_required;
    CREATE TEMPORARY TABLE tmp_required (course_id INT PRIMARY KEY);

    INSERT INTO tmp_required (course_id)
    SELECT DISTINCT course_id
    FROM requirement_course
    WHERE requirement_id IN (1,2,3,4,5);

    -- 3.3 Remaining courses
    DROP TEMPORARY TABLE IF EXISTS tmp_remaining;
    CREATE TEMPORARY TABLE tmp_remaining (course_id INT PRIMARY KEY);

    INSERT INTO tmp_remaining (course_id)
    SELECT course_id
    FROM tmp_required
    WHERE course_id NOT IN (SELECT course_id FROM tmp_completed);

    -- 3.4 Prerequisites
    DROP TEMPORARY TABLE IF EXISTS tmp_prereq;
    CREATE TEMPORARY TABLE tmp_prereq (course_id INT, prereq_id INT);

    INSERT INTO tmp_prereq (course_id, prereq_id)
    SELECT course_id, prereq_id
    FROM course_prerequisite;

    -- 4. SEMESTER PLANNING LOOP
    semester_loop: WHILE EXISTS (SELECT 1 FROM tmp_remaining) DO

        -- 4.1 Determine eligible courses for this semester
        --     Only real prereqs (in course table) are enforced.
        --     Missing / external prereqs are ignored.
        DROP TEMPORARY TABLE IF EXISTS tmp_eligible;
        CREATE TEMPORARY TABLE tmp_eligible (course_id INT PRIMARY KEY);

        INSERT INTO tmp_eligible (course_id)
        SELECT r.course_id
        FROM tmp_remaining r
        WHERE NOT EXISTS (
            SELECT 1
            FROM tmp_prereq p
            WHERE p.course_id = r.course_id
              AND p.prereq_id IN (SELECT course_id FROM course)
              AND p.prereq_id NOT IN (SELECT course_id FROM tmp_completed)
        );

        -- If nothing is eligible, break to avoid infinite loop
        IF NOT EXISTS (SELECT 1 FROM tmp_eligible) THEN
            LEAVE semester_loop;
        END IF;

        -- 4.2 Select courses up to 15 credits with priority:
        --     1) Requirement priority: Math → Science → CS Core → Univ Core → CS Electives
        --     2) Fewer prereqs first (shallower depth)
        --     3) Higher max_credit first
        --     4) Lower course_id as tie-breaker
        DROP TEMPORARY TABLE IF EXISTS tmp_selected;
        CREATE TEMPORARY TABLE tmp_selected (course_id INT PRIMARY KEY);

        SET v_sem_credits = 0;

        inner_loop: WHILE v_sem_credits < 15
            AND EXISTS (
                SELECT 1
                FROM tmp_eligible e
                WHERE NOT EXISTS (
                    SELECT 1 FROM tmp_selected s WHERE s.course_id = e.course_id
                )
            )
        DO
            SELECT e.course_id,
                   c.max_credit
            INTO v_course_id, v_course_credits
            FROM tmp_eligible e
            JOIN course c ON c.course_id = e.course_id
            WHERE NOT EXISTS (
                SELECT 1 FROM tmp_selected s WHERE s.course_id = e.course_id
            )
            ORDER BY
                -- Requirement priority
                (
                    SELECT MIN(
                        CASE rc.requirement_id
                            WHEN 2 THEN 1  -- Math Core
                            WHEN 3 THEN 2  -- Science Core
                            WHEN 1 THEN 3  -- CS Core
                            WHEN 4 THEN 4  -- University Core
                            WHEN 5 THEN 5  -- CS Electives
                            ELSE 9
                        END
                    )
                    FROM requirement_course rc
                    WHERE rc.course_id = e.course_id
                ) ASC,
                -- Prereq depth (zero-prereq first)
                (
                    SELECT COUNT(*)
                    FROM tmp_prereq p
                    WHERE p.course_id = e.course_id
                      AND p.prereq_id IN (SELECT course_id FROM course)
                ) ASC,
                -- Heavier courses first
                c.max_credit DESC,
                -- Stable tie-breaker
                e.course_id ASC
            LIMIT 1;

            -- If adding this course would exceed 15 credits, stop selecting
            IF v_sem_credits + v_course_credits > 15 THEN
                LEAVE inner_loop;
            END IF;

            INSERT INTO tmp_selected (course_id) VALUES (v_course_id);
            SET v_sem_credits = v_sem_credits + v_course_credits;
        END WHILE inner_loop;

        -- Safety: if nothing selected this semester, break to avoid infinite loop
        IF NOT EXISTS (SELECT 1 FROM tmp_selected) THEN
            LEAVE semester_loop;
        END IF;

        -- 4.3 Insert selected courses into snapshot detail
        INSERT INTO degree_plan_snapshot_detail (
            snapshot_id, semester_name, semester_order,
            course_id, course_name, credits
        )
        SELECT
            v_snapshot_id,
            v_semester_name,
            v_semester_order,
            c.course_id,
            CONCAT(c.subject_code, ' ', c.course_number, ' - ', c.title),
            c.max_credit
        FROM tmp_selected s
        JOIN course c ON c.course_id = s.course_id;

        -- 4.4 Mark selected courses as completed
        INSERT IGNORE INTO tmp_completed (course_id)
        SELECT course_id FROM tmp_selected;

        -- 4.5 Remove selected courses from remaining
        DELETE FROM tmp_remaining
        WHERE course_id IN (SELECT course_id FROM tmp_selected);

        -- 4.6 Move to next semester (Fall <-> Spring, increment year)
        SET v_semester_order = v_semester_order + 1;

        IF v_semester_name LIKE 'Fall%' THEN
            -- Fall YYYY -> Spring YYYY
            SET v_semester_name = CONCAT('Spring ', SUBSTRING(v_semester_name, 6));
        ELSE
            -- Spring YYYY -> Fall (YYYY + 1)
            SET v_semester_name = CONCAT(
                'Fall ',
                CAST(SUBSTRING(v_semester_name, 8) AS UNSIGNED) + 1
            );
        END IF;

    END WHILE semester_loop;

END$$
DELIMITER ;
