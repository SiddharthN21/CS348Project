"""
app.py
------
Main Flask application entry point. Implements the application factory
(create_app) to configure Flask, initialize SQLAlchemy, and register models.

IMPORTANT:
- SQLAlchemy does NOT create or modify tables automatically.
- All schema creation and updates are done manually using MySQL Workbench.
- DDL scripts are stored in the project's /sql directory for version control.

Responsibilities:
- Load configuration from config.py
- Initialize SQLAlchemy (db)
- Register models
- Provide optional test route (/test-db) to validate DB connectivity

Run this file to start the development server:
    python app.py
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
from sqlalchemy import text
from config import SQLALCHEMY_DATABASE_URI, SQLALCHEMY_TRACK_MODIFICATIONS
from db import db

def create_app():
    app = Flask(__name__)

    # Enable CORS for all routes
    CORS(app)

    # Configure database
    app.config["SQLALCHEMY_DATABASE_URI"] = SQLALCHEMY_DATABASE_URI
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = SQLALCHEMY_TRACK_MODIFICATIONS

    # Initialize SQLAlchemy
    db.init_app(app)

    # Import models so SQLAlchemy knows them
    from models import Student, Course, StudentCourse
    from student_course_routes import student_course_bp
    app.register_blueprint(student_course_bp)
    from course_dropdown_routes import course_bp
    app.register_blueprint(course_bp)

    from reports_blueprint import reports_bp
    app.register_blueprint(reports_bp)

    from degree_plan import degree_plan_bp
    app.register_blueprint(degree_plan_bp)

    # -------------------------------------------------
    # REGISTER DEGREE PLAN ROUTES/CRITERIA API BLUEPRINT
    # -------------------------------------------------
    from degree_plan_api import degree_plan_api
    app.register_blueprint(degree_plan_api)

    # ---------------------------------------------------------
    # TEST ROUTE
    # ---------------------------------------------------------
    @app.route("/test-db")
    def test_db():
        try:
            result = db.session.execute(text("SELECT 1"))
            return {"status": "ok", "result": [row[0] for row in result]}
        except Exception as e:
            return {"status": "error", "message": str(e)}

    # ---------------------------------------------------------
    # LOGIN ROUTE
    # ---------------------------------------------------------
    @app.route("/login", methods=["POST"])
    def login():
        data = request.get_json()

        username = data.get("username")
        password = data.get("password")

        if not username or not password:
            return jsonify({
                "status": "error",
                "message": "Username and Password is required"
            })

        result = db.session.execute(
            text("""
                SELECT student_id, username, full_name
                FROM student
                WHERE username = :username AND password = :password
            """),
            {"username": username, "password": password}
        ).fetchall()

        if len(result) == 1:
            row = result[0]
            return jsonify({
                "status": "success",
                "student_id":row.student_id,
                "username": row.username,
                "full_name": row.full_name
            })

        return jsonify({
            "status": "error",
            "message": "User Name and/or Password is incorrect. Please try again."
        })

    # ---------------------------------------------------------
    # NEW ROUTE: COURSES TAKEN BY STUDENT
    # ---------------------------------------------------------
    @app.route("/api/courses-taken/<int:student_id>", methods=["GET"])
    def get_courses_taken(student_id):

        # 1. Find student by username
        student = Student.query.filter_by(student_id=student_id).first()

        if not student:
            return jsonify({"error": "Student not found"}), 404

        # 2. Join student_course + course
        results = (
            db.session.query(StudentCourse, Course)
            .join(Course, StudentCourse.course_id == Course.course_id)
            .filter(StudentCourse.student_id == student.student_id)
            .order_by(StudentCourse.year.desc(), StudentCourse.term_code.desc())
            .all()
        )

        # 3. Format JSON response
        output = []
        for sc, c in results:
            output.append({
                "student_course_id": sc.student_course_id,
                "course_id": sc.course_id,

                "subject": c.subject_code,
                "number": c.course_number,
                "title": c.title,
                "department": c.department,

                "term": sc.term_code,
                "year": sc.year,
                "credits": sc.credits,
                "status": sc.status,
                "grade": sc.grade
            })

        return jsonify(output)

    return app


if __name__ == "__main__":
    app = create_app()
    app.run(debug=True)