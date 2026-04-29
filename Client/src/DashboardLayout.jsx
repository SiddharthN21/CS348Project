/**
 * DashboardLayout.jsx
 *
 * This component defines the main application shell after login:
 *  - Left navigation sidebar (Home, Courses, Criteria, Snapshot)
 *  - Right content area where pages are rendered
 *  - Logout button
 *
 * Props:
 *  - fullName: Logged-in student's name
 *  - onLogout: Logout handler from App.jsx
 *  - activePage: Current page selected
 *  - setActivePage: Function to switch pages
 *  - children: The page content to render on the right side
 */

import { Button } from "react-bootstrap";
import axios from "axios";

export default function DashboardLayout({
  fullName,
  onLogout,
  activePage,
  setActivePage,
  children
}) {

  const handleSnapshotClick = async () => {
  const studentId = localStorage.getItem("student_id");

  // 1. Generate plan BEFORE navigating
  await axios.post("http://localhost:5000/api/degree-plan/generate", {
    student_id: studentId
  });

  // 2. Navigate to snapshot page
  setActivePage("snapshot");
  };
  
  return (
    <div style={{ display: "flex" }}>

      {/* FIXED SIDEBAR */}
      <div
        style={{
          position: "fixed",
          top: 0,
          left: 0,
          width: "250px",
          height: "100vh",
          background: "#003366",
          color: "white",
          padding: "20px",
          display: "flex",
          flexDirection: "column",
          gap: "15px",
          overflowY: "auto"   // sidebar scrolls ONLY if sidebar itself overflows
        }}
      >
        <h3 style={{ color: "white" }}>Degree Planner</h3>
        <p style={{ marginBottom: "30px" }}>Welcome, {fullName}</p>

        <button className="btn btn-light" onClick={() => setActivePage("home")}>
          Home
        </button>

        <button className="btn btn-light" onClick={() => setActivePage("courses")}>
          Courses
        </button>

        <button className="btn btn-light" onClick={() => setActivePage("reports")}>
          Reports / Filtering
        </button>

        <button className="btn btn-light" onClick={() => setActivePage("criteria")}>
          Degree Plan Criteria
        </button>

        <button
          className={`btn btn-light ${activePage === "snapshot" ? "active" : ""}`}
          onClick={handleSnapshotClick}
        >
          Degree Plan Snapshot
        </button>

        <Button
          variant="danger"
          onClick={onLogout}
          style={{ marginTop: "auto" }}
        >
          Logout
        </Button>
      </div>

      {/* MAIN CONTENT */}
      <div
        style={{
          marginLeft: "250px",   // push content to the right of fixed sidebar
          padding: "40px",
          width: "100%",
          minHeight: "100vh",
          background: "var(--color-bg)",
          boxSizing: "border-box",
          overflowY: "auto"      // ONLY main content scrolls
        }}
      >
        {children}
      </div>

    </div>
  );
}