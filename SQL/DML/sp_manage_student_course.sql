DELIMITER $$
DROP PROCEDURE IF EXISTS sp_manage_student_course;

CREATE PROCEDURE sp_manage_student_course(
    IN p_action VARCHAR(10),          -- 'ADD', 'UPDATE', or 'DELETE'
    IN p_student_course_id INT,       -- PK for update/delete operations
    IN p_student_id INT,              -- Always required (used for GPA recalculation)
    IN p_course_id INT,               -- Required only for ADD
    IN p_term_code VARCHAR(10),       -- Term (FALL, SPRING) for ADD/UPDATE
    IN p_year INT,                    -- Academic year for ADD/UPDATE
    IN p_credits INT,                 -- Credits for ADD only
    IN p_grade_letter CHAR(2),        -- Letter grade (A, A-, B+, etc.) for ADD/UPDATE
    OUT p_message VARCHAR(255)        -- Success message for UI/backend
)
BEGIN
	 DECLARE v_new_gpa DECIMAL(4,3);

   /* ----------------------------------------------------------------------
    -- ACTION: ADD
    -- Inserts a new student_course record.
    -- Status is ALWAYS defaulted to 'COMPLETED' (UI/backend do not send it).
    ----------------------------------------------------------------------  */
		
	IF p_action = 'ADD' THEN

		-- Duplicate check
		IF EXISTS (
			SELECT 1 FROM student_course
			WHERE student_id = p_student_id
			  AND course_id = p_course_id
		) THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Duplicate course: student already enrolled.';
		END IF;

		INSERT INTO student_course(
			student_id, course_id, term_code, year, credits, status, grade
		)
		VALUES (
			p_student_id, p_course_id, p_term_code, p_year,
			p_credits, 'COMPLETED', p_grade_letter
		);

		IF ROW_COUNT() = 1 THEN
			SET p_message = 'Course added successfully.';
		ELSE
			SET p_message = 'Course not added.';
		END IF;

	END IF;


    /* ----------------------------------------------------------------------
    -- ACTION: UPDATE
    -- Only term_code, year, and grade can be updated.
    -- Credits, course_id, and student_id remain immutable.
    ---------------------------------------------------------------------- */
    
	IF p_action = 'UPDATE' THEN

		UPDATE student_course
		SET term_code = p_term_code,
			year = p_year,
			grade = p_grade_letter
		WHERE student_course_id = p_student_course_id;

		IF ROW_COUNT() = 1 THEN
			SET p_message = 'Course updated successfully.';
		ELSE
			SET p_message = 'No course updated (invalid student_course_id).';
		END IF;

	END IF;

    /* ----------------------------------------------------------------------
    -- ACTION: DELETE
    -- Removes a student_course record entirely.
    ---------------------------------------------------------------------- */
	IF p_action = 'DELETE' THEN

		DELETE FROM student_course
		WHERE student_course_id = p_student_course_id;

		IF ROW_COUNT() = 1 THEN
			SET p_message = 'Course deleted successfully.';
		ELSE
			SET p_message = 'No course deleted (invalid student_course_id).';
		END IF;

	END IF;

    /*----------------------------------------------------------------------
    -- GPA RECALCULATION
    -- After ANY change (ADD/UPDATE/DELETE), recompute the student's GPA.
    -- GPA formula:
    --     SUM(credits * grade_value) / SUM(credits)
    -- grade_value is retrieved from grade_scale table.
    ---------------------------------------------------------------------- */

    SELECT 
        SUM(sc.credits * gs.grade_value) / SUM(sc.credits)
    INTO v_new_gpa
    FROM student_course sc
    JOIN grade_scale gs ON sc.grade = gs.grade_letter
    WHERE sc.student_id = p_student_id;

   /* ----------------------------------------------------------------------
    -- Update the student's avg_gpa in the student table.
    -- If the student has no courses left (after delete), v_new_gpa becomes NULL.
    -- In that case, set avg_gpa to NULL or 0.0 depending on your preference.
    ---------------------------------------------------------------------- */
    
    UPDATE student
    SET avg_gpa = v_new_gpa
    WHERE student_id = p_student_id;

END$$

DELIMITER ;