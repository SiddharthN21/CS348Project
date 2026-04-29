"""
degree_plan_api.py
-----
"""

from flask import Blueprint, request, jsonify
from sqlalchemy import text
from db import db
import json

degree_plan_api = Blueprint("degree_plan_api", __name__)

# ---------------------------------------------------------
# GET OPTIONS (majors, tracks, minors, certifications)
# ---------------------------------------------------------
@degree_plan_api.route("/api/degree-plan/options", methods=["GET"])
def get_degree_plan_options():
    try:
        majors = db.session.execute(text("SELECT major_id, major_name FROM major ORDER BY major_name")).mappings().all()
        tracks = db.session.execute(text("SELECT track_id, major_id, track_name FROM track ORDER BY track_name")).mappings().all()
        minors = db.session.execute(text("SELECT minor_id, minor_name FROM minor ORDER BY minor_name")).mappings().all()
        certs = db.session.execute(text("SELECT certification_id, certification_name FROM certification ORDER BY certification_name")).mappings().all()

        return jsonify({
            "majors": [dict(row) for row in majors],
            "tracks": [dict(row) for row in tracks],
            "minors": [dict(row) for row in minors],
            "certifications": [dict(row) for row in certs]
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ---------------------------------------------------------
# GET EXISTING CRITERIA FOR STUDENT
# ---------------------------------------------------------
@degree_plan_api.route("/api/degree-plan/criteria/<int:student_id>", methods=["GET"])
def get_degree_plan_criteria(student_id):
    try:
        result = db.session.execute(
            text("""
                SELECT criteria_id, student_id, selected_major,
                       selected_tracks, selected_minors, selected_certifications,
                       preferred_credits, min_credits, max_credits, updated_at
                FROM degree_plan_criteria
                WHERE student_id = :student_id
            """),
            {"student_id": student_id}
        ).mappings().first()

        return jsonify({"criteria": dict(result) if result else None})

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ---------------------------------------------------------
# UPSERT CRITERIA
# ---------------------------------------------------------
@degree_plan_api.route("/api/degree-plan/criteria", methods=["POST"])
def save_degree_plan_criteria():
    data = request.get_json()

    try:
        student_id = data["student_id"]
        selected_major = data["selected_major"]
        selected_tracks = json.dumps(data.get("selected_tracks", []))
        selected_minors = json.dumps(data.get("selected_minors", []))
        selected_certs = json.dumps(data.get("selected_certifications", []))
        preferred_credits = data.get("preferred_credits")
        min_credits = data.get("min_credits")
        max_credits = data.get("max_credits")

        # Check if exists
        existing = db.session.execute(
            text("SELECT criteria_id FROM degree_plan_criteria WHERE student_id = :student_id"),
            {"student_id": student_id}
        ).first()

        if existing:
            # UPDATE
            db.session.execute(
                text("""
                    UPDATE degree_plan_criteria
                    SET selected_major = :selected_major,
                        selected_tracks = :selected_tracks,
                        selected_minors = :selected_minors,
                        selected_certifications = :selected_certs,
                        preferred_credits = :preferred_credits,
                        min_credits = :min_credits,
                        max_credits = :max_credits
                    WHERE student_id = :student_id
                """),
                {
                    "student_id": student_id,
                    "selected_major": selected_major,
                    "selected_tracks": selected_tracks,
                    "selected_minors": selected_minors,
                    "selected_certs": selected_certs,
                    "preferred_credits": preferred_credits,
                    "min_credits": min_credits,
                    "max_credits": max_credits
                }
            )
        else:
            # INSERT
            db.session.execute(
                text("""
                    INSERT INTO degree_plan_criteria
                    (student_id, selected_major, selected_tracks, selected_minors,
                     selected_certifications, preferred_credits, min_credits, max_credits)
                    VALUES (:student_id, :selected_major, :selected_tracks, :selected_minors,
                            :selected_certs, :preferred_credits, :min_credits, :max_credits)
                """),
                {
                    "student_id": student_id,
                    "selected_major": selected_major,
                    "selected_tracks": selected_tracks,
                    "selected_minors": selected_minors,
                    "selected_certs": selected_certs,
                    "preferred_credits": preferred_credits,
                    "min_credits": min_credits,
                    "max_credits": max_credits
                }
            )

        db.session.commit()
        return jsonify({"message": "Criteria saved successfully"})

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500
