# student_course_routes.py
# Add, Edit/Update, Deletion of student_course data for logged in student.

from flask import Blueprint, request, jsonify
from sqlalchemy import text
from db import db

student_course_bp = Blueprint("student_course_bp", __name__)

# ---------------------------------------------------------
# ADD COURSE
# ---------------------------------------------------------
@student_course_bp.route("/api/student-course/add", methods=["POST"])
def add_student_course():
    data = request.get_json()

    student_id = data.get("student_id")
    course_id = data.get("course_id")
    term_code = data.get("term_code")
    year = data.get("year")
    credits = data.get("credits")
    grade = data.get("grade")

    if not all([student_id, course_id, term_code, year, credits, grade]):
        return jsonify({"status": "error", "message": "Missing required fields"}), 400

    try:
        # OUT parameter
        result = db.session.execute(text("SET @msg = ''"))
        db.session.execute(
            text("""
                CALL sp_manage_student_course(
                    'ADD',
                    NULL,
                    :student_id,
                    :course_id,
                    :term_code,
                    :year,
                    :credits,
                    :grade,
                    @msg
                )
            """),
            {
                "student_id": student_id,
                "course_id": course_id,
                "term_code": term_code,
                "year": year,
                "credits": credits,
                "grade": grade
            }
        )

        msg = db.session.execute(text("SELECT @msg")).fetchone()[0]
        db.session.commit()

        return jsonify({"status": "success", "message": msg})

    except Exception as e:
        db.session.rollback()
        return jsonify({"status": "error", "message": str(e)}), 500


# ---------------------------------------------------------
# UPDATE COURSE
# ---------------------------------------------------------
@student_course_bp.route("/api/student-course/update/<int:student_course_id>", methods=["PUT"])
def update_student_course(student_course_id):
    data = request.get_json()

    student_id = data.get("student_id")
    term_code = data.get("term_code")
    year = data.get("year")
    grade = data.get("grade")

    if not all([student_id, term_code, year, grade]):
        return jsonify({"status": "error", "message": "Missing required fields"}), 400

    try:
        db.session.execute(text("SET @msg = ''"))
        db.session.execute(
            text("""
                CALL sp_manage_student_course(
                    'UPDATE',
                    :student_course_id,
                    :student_id,
                    NULL,
                    :term_code,
                    :year,
                    NULL,
                    :grade,
                    @msg
                )
            """),
            {
                "student_course_id": student_course_id,
                "student_id": student_id,
                "term_code": term_code,
                "year": year,
                "grade": grade
            }
        )

        msg = db.session.execute(text("SELECT @msg")).fetchone()[0]
        db.session.commit()

        return jsonify({"status": "success", "message": msg})

    except Exception as e:
        db.session.rollback()
        return jsonify({"status": "error", "message": str(e)}), 500


# ---------------------------------------------------------
# DELETE COURSE
# ---------------------------------------------------------
@student_course_bp.route("/api/student-course/delete/<int:student_course_id>", methods=["DELETE"])
def delete_student_course(student_course_id):
    data = request.get_json()
    student_id = data.get("student_id")

    if not student_id:
        return jsonify({"status": "error", "message": "student_id is required"}), 400

    try:
        db.session.execute(text("SET @msg = ''"))
        db.session.execute(
            text("""
                CALL sp_manage_student_course(
                    'DELETE',
                    :student_course_id,
                    :student_id,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    @msg
                )
            """),
            {
                "student_course_id": student_course_id,
                "student_id": student_id
            }
        )

        msg = db.session.execute(text("SELECT @msg")).fetchone()[0]
        db.session.commit()

        return jsonify({"status": "success", "message": msg})

    except Exception as e:
        db.session.rollback()
        return jsonify({"status": "error", "message": str(e)}), 500