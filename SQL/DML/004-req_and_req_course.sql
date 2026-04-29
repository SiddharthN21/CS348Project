ALTER TABLE requirement AUTO_INCREMENT = 1;
INSERT INTO requirement (requirement_name, requirement_type, min_credits, notes) VALUES
('CS Core', 'CS Core', 30, 'Required core CS courses'),
('Math Core', 'Math', 12, 'Required math sequence'),
('Science Core', 'Science', 6, 'Required science sequence'),
('University Core', 'University Core', 18, 'Required university core courses'),
('CS Electives', 'Elective', 9, 'Upper-level CS electives'),
('CS Full', 'CS Full', 120, 'Total credit requirement');

-- CS CORE (requirement_id = 1)  */
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 1, course_id FROM course WHERE subject_code='CS' AND course_number='18000';
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 1, course_id FROM course WHERE subject_code='CS' AND course_number='18200';
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 1, course_id FROM course WHERE subject_code='CS' AND course_number='24000';
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 1, course_id FROM course WHERE subject_code='CS' AND course_number='25000';
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 1, course_id FROM course WHERE subject_code='CS' AND course_number='25100';
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 1, course_id FROM course WHERE subject_code='CS' AND course_number='25200';

-- MATH CORE (requirement_id = 2)
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 2, course_id FROM course WHERE subject_code='MA' AND course_number='16100';
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 2, course_id FROM course WHERE subject_code='MA' AND course_number='16200';
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 2, course_id FROM course WHERE subject_code='MA' AND course_number='26100';
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 2, course_id FROM course WHERE subject_code='MA' AND course_number='26500';

-- SCIENCE CORE (requirement_id = 3)
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 3, course_id FROM course WHERE subject_code='PHYS' AND course_number='17200';
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 3, course_id FROM course WHERE subject_code='PHYS' AND course_number='27200';
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 3, course_id FROM course WHERE subject_code='BIOL' AND course_number='11000';
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 3, course_id FROM course WHERE subject_code='CHM' AND course_number='11500';

-- UNIVERSITY CORE (requirement_id = 4)
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 4, course_id FROM course WHERE subject_code='ENGL' AND course_number='10600';
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 4, course_id FROM course WHERE subject_code='COM' AND course_number='11400';

-- CS ELECTIVES (requirement_id = 5)
INSERT INTO requirement_course (requirement_id, course_id)
SELECT 5, course_id FROM course WHERE subject_code='CS' AND course_number IN (
    '30700','31400','33400','34800','35200','35300','35400','35500',
    '37300','38100','40800','42200','42600','44000','44800','45600',
    '47100','47300','47500','47800','48300','48900','49000'
);




