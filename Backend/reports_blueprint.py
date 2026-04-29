"""
reports_blueprint.py
-----
"""

# -------------------------------------------------------------
# /api/students/gpa-range
# Returns minimum and maximum GPA from the student table.
# Used by Reports/Filtering page to set GPA bounds.
# -------------------------------------------------------------

from flask import Blueprint, request, jsonify
from sqlalchemy import text
from db import db

# -------------------------------------------------------------
# Blueprint for Reports / Filtering
# URL prefix ensures all routes start with /api/reports
# -------------------------------------------------------------
reports_bp = Blueprint("reports_bp", __name__, url_prefix="/api/reports")


@reports_bp.route("/gpa-range", methods=["GET"])
def get_gpa_range():
    try:
        # -----------------------------------------------------
        # Query database for MIN and MAX GPA
        # -----------------------------------------------------
        result = db.session.execute(
            text("SELECT MIN(avg_gpa) AS min_gpa, MAX(avg_gpa) AS max_gpa FROM student")
        ).fetchone()

        # -----------------------------------------------------
        # Extract values safely
        # If DB is empty, default to 0.0 and 4.0
        # -----------------------------------------------------
        min_gpa = float(result.min_gpa) if result.min_gpa is not None else 0.0
        max_gpa = float(result.max_gpa) if result.max_gpa is not None else 4.0

        # -----------------------------------------------------
        # Return JSON response
        # -----------------------------------------------------
        return jsonify({
            "status": "success",
            "min_gpa": min_gpa,
            "max_gpa": max_gpa
        })

    except Exception as e:
        print("Error fetching GPA range:", str(e))
        return jsonify({"status": "error", "message": str(e)}), 500
    
# -------------------------------------------------------------
# /api/reports/courses
# Returns list of all courses for dropdown:
# Format:
# [
#   { "course_id": 1, "subject": "CS", "number": "37300", "title": "Data Mining" },
#   ...
# ]
# -------------------------------------------------------------
@reports_bp.route("/courses", methods=["GET"])
def get_courses_for_reports():
    try:
        # -----------------------------------------------------
        # Query all courses from the course table
        # -----------------------------------------------------
        result = db.session.execute(
            text("""
                SELECT 
                    course_id,
                    subject_code,
                    course_number,
                    title
                FROM course
                ORDER BY subject_code, course_number
            """)
        ).fetchall()

        # -----------------------------------------------------
        # Convert SQL rows → list of dicts
        # -----------------------------------------------------
        courses = [
            {
                "course_id": row.course_id,
                "subject": row.subject_code,
                "number": row.course_number,
                "title": row.title
            }
            for row in result
        ]

        # -----------------------------------------------------
        # Return JSON response
        # -----------------------------------------------------
        return jsonify({
            "status": "success",
            "courses": courses
        })

    except Exception as e:
        print("Error fetching courses:", str(e))
        return jsonify({"status": "error", "message": str(e)}), 500

# ============================================================
# POST /api/reports/filter
# Calls stored procedure sp_filter_students
# Returns one row per student-course for all filters
# ============================================================
@reports_bp.route("/filter", methods=["POST"])
def filter_students():
    try:
        data = request.get_json()

        # Extract filter parameters
        year = str(data.get("year")) if data.get("year") is not None else None
        term_code = data.get("term_code")
        min_gpa = data.get("min_gpa")
        max_gpa = data.get("max_gpa")
        course_id = data.get("course_id")

        print("DEBUG INPUT:", data)
        print("DEBUG PARAMS:", year, term_code, min_gpa, max_gpa, course_id)

        # ------------------------------------------------------------
        # Call stored procedure
        # ------------------------------------------------------------
        result = db.session.execute(
            text("""
                CALL sp_filter_students(
                    :year,
                    :term_code,
                    :min_gpa,
                    :max_gpa,
                    :course_id
                )
            """),
            {
                "year": year,
                "term_code": term_code,
                "min_gpa": min_gpa,
                "max_gpa": max_gpa,
                "course_id": course_id
            }
        )

        rows = result.fetchall()

        # MySQL stored procedures sometimes leave unread result sets
        db.session.execute(text("SELECT 1"))

        # ------------------------------------------------------------
        # Convert SQL rows → JSON rows
        # ------------------------------------------------------------
        results = []
        for r in rows:
            results.append({
                "student_id": r.student_id,
                "full_name": r.full_name,
                "avg_gpa": float(r.avg_gpa) if r.avg_gpa is not None else None,
                "year": int(r.year) if r.year is not None else None,
                "term_code": r.term_code,
                "course_code": r.course_code,
                "course_title": r.course_title,
                "grade": r.grade
            })

        return jsonify({
            "status": "success",
            "results": results
        })

    except Exception as e:
        print("Error in /api/reports/filter:", e)
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500