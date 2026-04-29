"""
models.py
---------
Defines all SQLAlchemy ORM models for the backend. Each model corresponds
to a database table and specifies its schema, constraints, and relationships.

IMPORTANT:
- Tables are NOT created automatically by SQLAlchemy.
- All DDL (CREATE TABLE, ALTER TABLE, etc.) is managed manually using
  MySQL Workbench and stored as versioned SQL scripts in the project's
  /sql directory.

Current Models:
- Student: authentication + profile
- Course: catalog of courses
- StudentCourse: courses taken or planned by a student
"""

from db import db

# ---------------------------------------------------------
# STUDENT MODEL (used for login + profile)
# ---------------------------------------------------------
class Student(db.Model):
    __tablename__ = "student"

    student_id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # Authentication fields
    username = db.Column(db.String(50), unique=True, nullable=False)
    password = db.Column(db.String(50), nullable=False)
    # Note: store hashed passwords in production

    # Additional user details
    full_name = db.Column(db.String(100), nullable=True)
    email = db.Column(db.String(100), unique=True, nullable=True)
    phone = db.Column(db.String(20), nullable=True)
    address = db.Column(db.String(255), nullable=True)

    # Additional fields from schema
    catalog_year = db.Column(db.Integer, nullable=True)
    created_at = db.Column(db.DateTime, nullable=True)
    birth_date = db.Column(db.DateTime, nullable=False)
    avg_gpa = db.Column(db.Numeric(3,2), nullable=False, default=0.00)

    # Relationship: one student → many student_course rows
    courses_taken = db.relationship("StudentCourse", back_populates="student")

    def __repr__(self):
        return f"<Student {self.username}>"


# ---------------------------------------------------------
# COURSE MODEL (matches MySQL schema)
# ---------------------------------------------------------
class Course(db.Model):
    __tablename__ = "course"

    course_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    subject_code = db.Column(db.String(10), nullable=False)
    course_number = db.Column(db.String(10), nullable=False)
    title = db.Column(db.String(255), nullable=False)
    min_credit = db.Column(db.Integer, nullable=False)
    max_credit = db.Column(db.Integer, nullable=False)
    is_variable_credit = db.Column(db.Boolean, default=False)
    description_summary = db.Column(db.Text)
    department = db.Column(db.String(100), nullable=False)
    level = db.Column(db.Integer, nullable=False)

    # Relationship: one course → many student_course rows
    taken_by_students = db.relationship("StudentCourse", back_populates="course")

    def __repr__(self):
        return f"<Course {self.subject_code} {self.course_number}>"


# ---------------------------------------------------------
# STUDENT_COURSE MODEL (courses taken or planned)
# ---------------------------------------------------------
class StudentCourse(db.Model):
    __tablename__ = "student_course"

    student_course_id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    student_id = db.Column(db.Integer, db.ForeignKey("student.student_id"), nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey("course.course_id"), nullable=False)

    term_code = db.Column(db.String(10), nullable=False)
    year = db.Column(db.Integer, nullable=False)
    credits = db.Column(db.Integer, nullable=False)
    status = db.Column(db.Enum("COMPLETED", "PLANNED"), nullable=False)
    grade = db.Column(db.Numeric(3,2), default=0.00)

    # Relationships
    student = db.relationship("Student", back_populates="courses_taken")
    course = db.relationship("Course", back_populates="taken_by_students")

    def __repr__(self):
        return f"<StudentCourse student={self.student_id} course={self.course_id}>"