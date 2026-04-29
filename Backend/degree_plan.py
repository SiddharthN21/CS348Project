"""
degree_plan.py
-----
"""

from flask import Blueprint, request, jsonify
from sqlalchemy import text
from app import db

degree_plan_bp = Blueprint("degree_plan", __name__)

@degree_plan_bp.route("/api/degree-plan/generate", methods=["POST"])
def generate_degree_plan():
    data = request.get_json()

    print("Incoming JSON:", data) 

    student_id = data.get("student_id")
    if not student_id:
        return jsonify({"error": "student_id is required"}), 400

    # 1. Call stored procedure
    db.session.execute(text("CALL sp_generate_degree_plan(:sid)"), {"sid": student_id})
    db.session.commit()

    # 2. Fetch latest snapshot
    snapshot_row = db.session.execute(text("""
        SELECT snapshot_id
        FROM degree_plan_snapshot
        WHERE student_id = :sid
        ORDER BY snapshot_id DESC
        LIMIT 1
    """), {"sid": student_id}).fetchone()

    if not snapshot_row:
        return jsonify({"error": "Snapshot not generated"}), 500

    snapshot_id = snapshot_row.snapshot_id

    # 3. Fetch completed credits BEFORE the plan
    completed_row = db.session.execute(text("""
        SELECT COALESCE(SUM(c.max_credit), 0) AS completed_credits
        FROM student_course sc
        JOIN course c ON c.course_id = sc.course_id
        WHERE sc.student_id = :sid
    """), {"sid": student_id}).fetchone()

    completed_before = completed_row.completed_credits

    # 4. Fetch snapshot detail rows with requirement type
    rows = db.session.execute(text("""
        SELECT 
            d.semester_name,
            d.semester_order,
            d.course_id,
            d.course_name,
            d.credits,
            (
                SELECT r.requirement_name
                FROM requirement_course rc
                JOIN requirement r ON r.requirement_id = rc.requirement_id
                WHERE rc.course_id = d.course_id
                LIMIT 1
            ) AS requirement_type
        FROM degree_plan_snapshot_detail d
        WHERE d.snapshot_id = :sid
        ORDER BY d.semester_order, d.course_id
    """), {"sid": snapshot_id}).fetchall()

    # 5. Group by semester
    semesters = {}
    for r in rows:
        key = (r.semester_order, r.semester_name)
        if key not in semesters:
            semesters[key] = {
                "semester_order": r.semester_order,
                "semester_name": r.semester_name,
                "courses": []
            }
        semesters[key]["courses"].append({
            "course_id": r.course_id,
            "course_name": r.course_name,
            "credits": r.credits,
            "requirement_type": r.requirement_type
        })

    # 6. Compute semester credits + cumulative credits
    cumulative = completed_before
    semester_list = []

    for (order, name), sem in sorted(semesters.items()):
        sem_credits = sum(c["credits"] for c in sem["courses"])
        cumulative += sem_credits

        semester_list.append({
            "semester_order": order,
            "semester_name": name,
            "semester_credits": sem_credits,
            "cumulative_credits": cumulative,
            "courses": sem["courses"]
        })

    return jsonify({
        "snapshot_id": snapshot_id,
        "student_id": student_id,
        "completed_credits_before_plan": completed_before,
        "semesters": semester_list
    })

@degree_plan_bp.route("/api/degree-plan/snapshot/<int:student_id>", methods=["GET"])
def get_latest_snapshot(student_id):

    # 1. Get latest snapshot_id
    snapshot_row = db.session.execute(text("""
        SELECT snapshot_id
        FROM degree_plan_snapshot
        WHERE student_id = :sid
        ORDER BY snapshot_id DESC
        LIMIT 1
    """), {"sid": student_id}).fetchone()

    if not snapshot_row:
        return jsonify({"error": "No snapshot found"}), 404

    snapshot_id = snapshot_row.snapshot_id

    # 2. Completed credits BEFORE plan
    completed_row = db.session.execute(text("""
        SELECT COALESCE(SUM(c.max_credit), 0) AS completed_credits
        FROM student_course sc
        JOIN course c ON c.course_id = sc.course_id
        WHERE sc.student_id = :sid
    """), {"sid": student_id}).fetchone()

    completed_before = completed_row.completed_credits

    # 3. Snapshot detail rows
    rows = db.session.execute(text("""
        SELECT 
            d.semester_name,
            d.semester_order,
            d.course_id,
            d.course_name,
            d.credits,
            (
                SELECT r.requirement_name
                FROM requirement_course rc
                JOIN requirement r ON r.requirement_id = rc.requirement_id
                WHERE rc.course_id = d.course_id
                LIMIT 1
            ) AS requirement_type
        FROM degree_plan_snapshot_detail d
        WHERE d.snapshot_id = :sid
        ORDER BY d.semester_order, d.course_id
    """), {"sid": snapshot_id}).fetchall()

    # 4. Group by semester
    semesters = {}
    for r in rows:
        key = (r.semester_order, r.semester_name)
        if key not in semesters:
            semesters[key] = {
                "semester_order": r.semester_order,
                "semester_name": r.semester_name,
                "courses": []
            }
        semesters[key]["courses"].append({
            "course_id": r.course_id,
            "course_name": r.course_name,
            "credits": r.credits,
            "requirement_type": r.requirement_type
        })

    # 5. Compute credits
    cumulative = completed_before
    semester_list = []

    for (order, name), sem in sorted(semesters.items()):
        sem_credits = sum(c["credits"] for c in sem["courses"])
        cumulative += sem_credits

        semester_list.append({
            "semester_order": order,
            "semester_name": name,
            "semester_credits": sem_credits,
            "cumulative_credits": cumulative,
            "courses": sem["courses"]
        })

    return jsonify({
        "snapshot_id": snapshot_id,
        "student_id": student_id,
        "completed_credits_before_plan": completed_before,
        "semesters": semester_list
    })

