-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema cs348proj
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cs348proj` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `cs348proj` ;

-- -----------------------------------------------------
-- Table `cs348proj`.`course`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs348proj`.`course` ;

CREATE TABLE IF NOT EXISTS `cs348proj`.`course` (
  `course_id` INT NOT NULL AUTO_INCREMENT,
  `subject_code` VARCHAR(10) NOT NULL,
  `course_number` VARCHAR(10) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `min_credit` INT NOT NULL,
  `max_credit` INT NOT NULL,
  `is_variable_credit` TINYINT(1) NOT NULL DEFAULT '0',
  `description_summary` TEXT NULL DEFAULT NULL,
  `department` VARCHAR(100) NOT NULL,
  `level` INT NOT NULL,
  PRIMARY KEY (`course_id`),
  UNIQUE INDEX `uq_course_subject_number` (`subject_code` ASC, `course_number` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cs348proj`.`course_prerequisite`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs348proj`.`course_prerequisite` ;

CREATE TABLE IF NOT EXISTS `cs348proj`.`course_prerequisite` (
  `prereq_id` INT NOT NULL AUTO_INCREMENT,
  `course_id` INT NOT NULL,
  `expression_json` JSON NOT NULL,
  `min_grade` VARCHAR(5) NULL DEFAULT NULL,
  `is_concurrent_allowed` TINYINT(1) NOT NULL DEFAULT '0',
  `is_external_prereq` TINYINT(1) NOT NULL DEFAULT '0',
  `notes` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`prereq_id`),
  INDEX `idx_course_id` (`course_id` ASC) VISIBLE,
  CONSTRAINT `fk_prereq_course`
    FOREIGN KEY (`course_id`)
    REFERENCES `cs348proj`.`course` (`course_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cs348proj`.`student`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs348proj`.`student` ;

CREATE TABLE `student` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `catalog_year` year DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `birth_date` datetime NOT NULL DEFAULT '2100-01-01 00:00:00',
  `avg_gpa` decimal(5,4) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `uq_username` (`username`),
  UNIQUE KEY `uq_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cs348proj`.`degree_plan_criteria`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs348proj`.`degree_plan_criteria` ;

CREATE TABLE IF NOT EXISTS `cs348proj`.`degree_plan_criteria` (
  `criteria_id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `selected_major` VARCHAR(50) NOT NULL,
  `selected_tracks` JSON NULL DEFAULT NULL,
  `selected_minors` JSON NULL DEFAULT NULL,
  `selected_certifications` JSON NULL DEFAULT NULL,
  `preferred_credits` INT NULL DEFAULT NULL,
  `min_credits` INT NULL DEFAULT NULL,
  `max_credits` INT NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`criteria_id`),
  UNIQUE INDEX `uq_student` (`student_id` ASC) VISIBLE,
  CONSTRAINT `fk_criteria_student`
    FOREIGN KEY (`student_id`)
    REFERENCES `cs348proj`.`student` (`student_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cs348proj`.`degree_plan_snapshot`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs348proj`.`degree_plan_snapshot` ;

CREATE TABLE IF NOT EXISTS `cs348proj`.`degree_plan_snapshot` (
  `snapshot_id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `plan_json` JSON NOT NULL,
  `generated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`snapshot_id`),
  UNIQUE INDEX `uq_snapshot_student` (`student_id` ASC) VISIBLE,
  CONSTRAINT `fk_snapshot_student`
    FOREIGN KEY (`student_id`)
    REFERENCES `cs348proj`.`student` (`student_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cs348proj`.`requirement`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs348proj`.`requirement` ;

CREATE TABLE IF NOT EXISTS `cs348proj`.`requirement` (
  `requirement_id` INT NOT NULL AUTO_INCREMENT,
  `requirement_name` VARCHAR(255) NOT NULL,
  `requirement_type` ENUM('CS Core', 'Math', 'Science', 'University Core', 'Elective', 'CS Full') NOT NULL,
  `min_credits` INT NULL DEFAULT NULL,
  `notes` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`requirement_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cs348proj`.`requirement_course`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs348proj`.`requirement_course` ;

CREATE TABLE IF NOT EXISTS `cs348proj`.`requirement_course` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `requirement_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `is_optional` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `idx_req` (`requirement_id` ASC) VISIBLE,
  INDEX `idx_course` (`course_id` ASC) VISIBLE,
  CONSTRAINT `fk_req_course_course`
    FOREIGN KEY (`course_id`)
    REFERENCES `cs348proj`.`course` (`course_id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_req_course_req`
    FOREIGN KEY (`requirement_id`)
    REFERENCES `cs348proj`.`requirement` (`requirement_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cs348proj`.`student_course`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs348proj`.`student_course` ;

CREATE TABLE IF NOT EXISTS `cs348proj`.`student_course` (
  `student_course_id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `term_code` VARCHAR(10) NOT NULL,
  `year` YEAR NOT NULL,
  `credits` INT NOT NULL,
  `status` ENUM('COMPLETED', 'PLANNED') NOT NULL,
  `grade` CHAR(2) NOT NULL,
  PRIMARY KEY (`student_course_id`),
  INDEX `idx_course_id` (`course_id` ASC) VISIBLE,
  INDEX `idx_student_term` (`student_id` ASC, `year` ASC, `term_code` ASC) VISIBLE,
  UNIQUE KEY `uq_student_course` (`student_id` ASC, `course_id` ASC) VISIBLE,
  CONSTRAINT `fk_student_course_course`
    FOREIGN KEY (`course_id`)
    REFERENCES `cs348proj`.`course` (`course_id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_student_course_student`
    FOREIGN KEY (`student_id`)
    REFERENCES `cs348proj`.`student` (`student_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cs348proj`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cs348proj`.`users` ;

CREATE TABLE IF NOT EXISTS `cs348proj`.`users` (
  `userid` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `full_name` VARCHAR(150) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  `address` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`userid`),
  UNIQUE INDEX `username` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email` (`email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `cs348proj`.`grade_scale` ;
-- Grade scale table for grade and corresponding values.
CREATE TABLE grade_scale (
    id INT AUTO_INCREMENT PRIMARY KEY,
    grade_letter VARCHAR(3) NOT NULL UNIQUE,
    grade_value DECIMAL(3,2) NOT NULL
);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
