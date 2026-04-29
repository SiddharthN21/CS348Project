-- ============================================
-- DEGREE PLAN OPTION TABLES
-- majors, tracks, minors, certifications
-- ============================================

-- DROP tables if exist
DROP TABLE IF EXISTS minor;
DROP TABLE IF EXISTS track;
DROP TABLE IF EXISTS certification;
DROP TABLE IF EXISTS major;
DROP TABLE IF EXISTS degree_plan_snapshot_detail;
DROP TABLE IF EXISTS degree_plan_snapshot;

-- 1. Major Table
CREATE TABLE major (
    major_id INT NOT NULL AUTO_INCREMENT,
    major_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (major_id),
    UNIQUE KEY uq_major_name (major_name)
);

-- 2. Track Table (tracks belong to a major)
CREATE TABLE track (
    track_id INT NOT NULL AUTO_INCREMENT,
    major_id INT NOT NULL,
    track_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (track_id),
    UNIQUE KEY uq_track (major_id, track_name),
    CONSTRAINT fk_track_major FOREIGN KEY (major_id)
        REFERENCES major(major_id) ON DELETE CASCADE
);

-- 3. Minor Table
CREATE TABLE minor (
    minor_id INT NOT NULL AUTO_INCREMENT,
    minor_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (minor_id),
    UNIQUE KEY uq_minor_name (minor_name)
);

-- 4. Certification Table
CREATE TABLE certification (
    certification_id INT NOT NULL AUTO_INCREMENT,
    certification_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (certification_id),
    UNIQUE KEY uq_cert_name (certification_name)
);

-- 5. degree_plan_snapshot Table

CREATE TABLE degree_plan_snapshot (
    snapshot_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    criteria_id INT NULL,

    CONSTRAINT fk_snapshot_student
        FOREIGN KEY (student_id) REFERENCES student(student_id)
        ON DELETE CASCADE
);
-- 6. degree_plan_snapshot_detail Table

CREATE TABLE degree_plan_snapshot_detail (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    snapshot_id INT NOT NULL,

    semester_name VARCHAR(20) NOT NULL,   -- e.g., "Fall 2026"
    semester_order INT NOT NULL,          -- 1, 2, 3, 4...

    course_id INT NOT NULL,
    course_name VARCHAR(255) NOT NULL,
    credits INT NOT NULL,

    CONSTRAINT fk_detail_snapshot
        FOREIGN KEY (snapshot_id) REFERENCES degree_plan_snapshot(snapshot_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_detail_course
        FOREIGN KEY (course_id) REFERENCES course(course_id)
);
-- Indexes
CREATE INDEX idx_snapshot_student ON degree_plan_snapshot(student_id);
CREATE INDEX idx_detail_snapshot ON degree_plan_snapshot_detail(snapshot_id);
CREATE INDEX idx_detail_semester ON degree_plan_snapshot_detail(snapshot_id, semester_order);


