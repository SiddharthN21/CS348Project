
INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='18200'),
    '{"AND": ["CS 18000", "MA 16100"]}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='24000'),
    '{"course": "CS 18000"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='25000'),
    '{"AND": ["CS 18200", "CS 24000"]}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='25100'),
    '{"AND": ["CS 18200", "CS 24000"]}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='25200'),
    '{"AND": ["CS 25000", "CS 25100"]}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='30700'),
    '{"course": "CS 25200"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='34800'),
    '{"course": "CS 25200"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='MA' AND course_number='35100'),
    '{"course": "CS 25100"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='35200'),
    '{"course": "CS 25100"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='35300'),
    '{"course": "CS 35100"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='35400'),
    '{"course": "CS 25100"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='37300'),
    '{"course": "CS 25200"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='40800'),
    '{"course": "CS 25200"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='44800'),
    '{"course": "CS 25200"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='45600'),
    '{"course": "CS 35100"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='47100'),
    '{"course": "CS 25200"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='47300'),
    '{"course": "CS 25200"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='47500'),
    '{"course": "CS 25200"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='48300'),
    '{"course": "CS 38100"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='48900'),
    '{"course": "CS 25100"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='31400'),
    '{"course": "MA 26500"}',
    'C',
    FALSE,
    TRUE,
    'External prereq (Math)'
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='31400'),
    '{"course": "To Be Identified"}',
    'C',
    FALSE,
    TRUE,
    'External prereq placeholder'
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='35500'),
    '{"course": "CS 25100"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='35500'),
    '{"course": "To Be Identified"}',
    'C',
    FALSE,
    TRUE,
    'External prereq placeholder'
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='38100'),
    '{"course": "CS 25100"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='38100'),
    '{"course": "To Be Identified"}',
    'C',
    FALSE,
    TRUE,
    'External prereq placeholder'
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='44000'),
    '{"course": "CS 37300"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='44000'),
    '{"course": "To Be Identified"}',
    'C',
    FALSE,
    TRUE,
    'External prereq placeholder'
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='47800'),
    '{"course": "CS 25200"}',
    'C',
    FALSE,
    FALSE,
    ''
);

INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='47800'),
    '{"course": "To Be Identified"}',
    'C',
    FALSE,
    TRUE,
    'External prereq placeholder'
);
INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='CS' AND course_number='33400'),
    '{"course": "CS 25100"}',
    'C',
    FALSE,
    FALSE,
    ''
);

