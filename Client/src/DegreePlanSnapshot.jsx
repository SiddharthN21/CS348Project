import React, { useState, useEffect } from "react";
import axios from "axios";

const requirementColors = {
  "Math": "#1e90ff",
  "Science": "#2ecc71",
  "CS Core": "#9b59b6",
  "University Core": "#7f8c8d",
  "CS Elective": "#e67e22"
};

export default function DegreePlanSnapshot() {
  const [loading, setLoading] = useState(false);
  const [semesters, setSemesters] = useState([]);
  const [completedBefore, setCompletedBefore] = useState(0);

  // Load snapshot when page opens
  useEffect(() => {
    loadSnapshot();
  }, []);

  const loadSnapshot = async () => {
    const studentId = localStorage.getItem("student_id");

    const res = await axios.get(
      `http://localhost:5000/api/degree-plan/snapshot/${studentId}`
    );

    setCompletedBefore(res.data.completed_credits_before_plan);
    setSemesters(res.data.semesters);
  };

  const regeneratePlan = async () => {
    setLoading(true);
    try {
      const studentId = localStorage.getItem("student_id");
      const res = await axios.post("http://localhost:5000/api/degree-plan/generate", {
        student_id: studentId
      });

      setCompletedBefore(res.data.completed_credits_before_plan);
      setSemesters(res.data.semesters);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <button
        className="btn btn-primary"
        onClick={regeneratePlan}
        disabled={loading}
      >
        {loading ? "Generating..." : "Regenerate Plan"}
      </button>

      <div style={{ marginTop: "20px", fontSize: "16px" }}>
        <strong>Completed Credits Before Plan:</strong> {completedBefore}
      </div>

      <div className="degree-plan-grid">
        {semesters.map(sem => (
          <div key={sem.semester_order} className="semester-card">
            <h4>{sem.semester_name}</h4>

            <div style={{ fontSize: "14px", marginBottom: "10px" }}>
              Semester Credits: <strong>{sem.semester_credits}</strong><br />
              Cumulative Credits: <strong>{sem.cumulative_credits}</strong>
            </div>

            {sem.courses.map(course => (
              <div
                key={course.course_id}
                style={{
                  padding: "8px",
                  borderRadius: "6px",
                  marginBottom: "6px",
                  background: requirementColors[course.requirement_type] || "#bbb",
                  color: "white"
                }}
              >
                <div style={{ fontWeight: "bold" }}>{course.course_name}</div>
                <div style={{ fontSize: "13px" }}>
                  {course.credits} credits — {course.requirement_type}
                </div>
              </div>
            ))}
          </div>
        ))}
      </div>
    </div>
  );
}
