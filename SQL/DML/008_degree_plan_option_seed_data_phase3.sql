-- ============================================
-- SEED DATA FOR DEGREE PLAN OPTION TABLES
-- ============================================

-- Majors
INSERT INTO major (major_name) VALUES
('Computer Science'),
('Data Science');

-- Tracks (linked to majors)
INSERT INTO track (major_id, track_name) VALUES
-- Computer Science (major_id = 1)
(1, 'Artificial Intelligence'),
(1, 'Systems'),
(1, 'Software Engineering'),
(1, 'Cyber Security'),

-- Data Science (major_id = 2)
(2, 'Machine Learning'),
(2, 'Data Engineering'),
(2, 'Business Analytics');

-- Minors
INSERT INTO minor (minor_name) VALUES
('Mathematics'),
('Statistics'),
('Business'),
('Physics'),
('Economics');

-- Certifications
INSERT INTO certification (certification_name) VALUES
('Entrepreneurship'),
('Cloud Computing'),
('AI Foundations'),
('Data Analytics'),
('Software Quality Assurance');
