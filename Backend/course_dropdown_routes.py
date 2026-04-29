"""
course_dropdown_routes.py
-------------------------

Provides backend API endpoints for dropdown data used in:
- Add Course modal
- Edit Course modal
- Any UI that needs subject, course number, title, credits, or grade scale.

Endpoints:
    GET /api/subjects
    GET /api/courses-by-subject/<subject>
    GET /api/grade-scale

These routes read from the `course` and `grade_scale` tables.
"""

from flask import Blueprint, jsonify
from sqlalchemy import text
from db import db

# Blueprint for dropdown-related routes
course_bp = Blueprint("course_bp", __name__)


# ---------------------------------------------------------
# 1. GET ALL SUBJECTS
# ---------------------------------------------------------
@course_bp.route("/api/subjects", methods=["GET"])
def get_subjects():
    """
    Returns a list of distinct subject codes from the course table.
    Example: ["CS", "MA", "PHYS"]
    """

    rows = db.session.execute(text("""
        SELECT DISTINCT subject_code
        FROM course
        ORDER BY subject_code
    """)).fetchall()

    subjects = [row.subject_code for row in rows]

    return jsonify(subjects)


# ---------------------------------------------------------
# 2. GET ALL COURSES FOR A SUBJECT
# ---------------------------------------------------------
@course_bp.route("/api/courses-by-subject/<subject>", methods=["GET"])
def get_courses_by_subject(subject):
    """
    Returns all courses for a given subject.
    Includes:
        - course_id
        - course_number
        - title
        - min_credit
        - max_credit
        - is_variable_credit

    Example response:
    [
        {
            "course_id": 21,
            "course_number": "44800",
            "title": "Intro to Relational Databases",
            "min_credit": 3,
            "max_credit": 3,
            "is_variable_credit": false
        }
    ]
    """

    rows = db.session.execute(text("""
        SELECT 
            course_id,
            course_number,
            title,
            min_credit,
            max_credit,
            is_variable_credit
        FROM course
        WHERE subject_code = :subject
        ORDER BY course_number
    """), {"subject": subject}).fetchall()

    courses = [
        {
            "course_id": row.course_id,
            "course_number": row.course_number,
            "title": row.title,
            "min_credit": row.min_credit,
            "max_credit": row.max_credit,
            "is_variable_credit": bool(row.is_variable_credit)
        }
        for row in rows
    ]

    return jsonify(courses)


# ---------------------------------------------------------
# 3. GET GRADE SCALE
# ---------------------------------------------------------
@course_bp.route("/api/grade-scale", methods=["GET"])
def get_grade_scale():
    """
    Returns all grade letters from grade_scale table.
    Sorted by grade_value descending (A first, F last).

    Example: ["A", "A-", "B+", "B", "C", "D", "F"]
    """

    rows = db.session.execute(text("""
        SELECT grade_letter
        FROM grade_scale
        ORDER BY grade_value DESC
    """)).fetchall()

    grades = [row.grade_letter for row in rows]

    return jsonify(grades)