/**
 * App.jsx
 * CS348 Project – React Client
 *
 * This component implements the full client-side login workflow:
 *  - Displays a styled login page using React-Bootstrap
 *  - Sends POST requests to the Flask backend for authentication
 *  - Shows success or error messages based on backend response
 *  - Provides a password visibility toggle (eye icon)
 *  - Uses gradient backgrounds for a modern UI experience
 *  - Renders a success screen with logout functionality
 *
 * State variables manage:
 *  - username/password input
 *  - login errors
 *  - authenticated user's full name
 *  - password visibility toggle
 *
 * This file represents the main UI logic for the CS348 project frontend.
 */

import { useState } from "react";
import { Card, Form, Button } from "react-bootstrap";
import DashboardLayout from "./DashboardLayout";
import CoursesPage from "./CoursesPage";
import PageContainer from "./PageContainer";
import ReportsPage from "./ReportsPage";
import DegreePlanCriteria from "./DegreePlanCriteria";
import DegreePlanSnapshot from "./DegreePlanSnapshot";
import "./App.css";


function App() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [fullName, setFullName] = useState("");
  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = async () => {
    setError("");

    try {
      const response = await fetch("http://localhost:5000/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username, password })
      });

      const data = await response.json();

      if (data.status === "success") {
        setFullName(data.full_name);
        localStorage.setItem("student_id", data.student_id);
        localStorage.setItem("username", data.username);
        localStorage.setItem("full_name", data.full_name);
      } else {
        setError(data.message);
      }
    // eslint-disable-next-line no-unused-vars
    } catch (err) {
      setError("Unable to reach server. Please try again later.");
    }
  };

  const handleLogout = () => {
    setUsername("");
    setPassword("");
    setFullName("");
    setError("");
  };

  // ------------------------------------------------------------
  // SUCCESS PAGE
  // ------------------------------------------------------------
  const [activePage, setActivePage] = useState("home");

  // ------------------------------------------------------------
// SUCCESS PAGE → NOW DASHBOARD LAYOUT
// ------------------------------------------------------------
/**
 * Logged-in section of App.jsx
 *
 * Replaces the old success screen with:
 *  - DashboardLayout (sidebar + content area)
 *  - PageContainer for consistent page formatting
 *  - Dynamic page switching based on activePage state
 */
if (fullName) {
  return (
    <DashboardLayout
      fullName={fullName}
      onLogout={handleLogout}
      activePage={activePage}
      setActivePage={setActivePage}
    >
      {/* ---------------- HOME PAGE ---------------- */}
      {activePage === "home" && (
        <PageContainer>
          <div style={{ width: "100%" }}>
            <h1 style={{ color: "#003366" }}>
              Welcome, {fullName} to the Degree Planner System!
            </h1>
            <p style={{ fontSize: "18px", color: "#444" }}>
              Use the navigation menu on the left to manage your courses and degree plan.
            </p>
          </div>
        </PageContainer>
      )}

      {/* ---------------- COURSES PAGE ---------------- */}
      {activePage === "courses" && <CoursesPage />}

      {/* ---------------- REPORTS PAGE ---------------- */}
      {activePage === "reports" && <ReportsPage />}

      {/* ---------------- CRITERIA PAGE ---------------- */}
      {activePage === "criteria" && (
        <PageContainer>
          <DegreePlanCriteria />
        </PageContainer>
      )}

      {/* ---------------- SNAPSHOT PAGE ---------------- */}
      {activePage === "snapshot" && (
        <PageContainer>
          <h2>Degree Plan Snapshot </h2>
          <DegreePlanSnapshot />
        </PageContainer>
      )}
    </DashboardLayout>
  );
}

  // ------------------------------------------------------------
  // LOGIN PAGE
  // ------------------------------------------------------------
  return (
    <div
      style={{
        height: "100vh",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        background: "linear-gradient(135deg, #89f7fe 0%, #66a6ff 100%)"
      }}
    >
      <Card style={{ width: "350px", padding: "20px", boxShadow: "0 4px 12px rgba(0,0,0,0.2)" }}>
        <h2
          style={{
            textAlign: "center",
            marginBottom: "20px",
            color: "#004085",
            fontSize: "28px"
          }}
        >
          Welcome to CS348 Project Site
        </h2>

        <Form>
          {/* Username */}
          <Form.Group className="mb-3">
            <Form.Control
              type="text"
              placeholder="Student Name"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
            />
          </Form.Group>

          {/* Password with eye icon */}
          <Form.Group className="mb-3" style={{ position: "relative" }}>
            <Form.Control
              type={showPassword ? "text" : "password"}
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />

            <span
              onClick={() => setShowPassword(!showPassword)}
              style={{
                position: "absolute",
                right: "12px",
                top: "50%",
                transform: "translateY(-50%)",
                cursor: "pointer",
                fontSize: "18px"
              }}
            >
              {showPassword ? "🙈" : "👁️"}
            </span>
          </Form.Group>

          {/* Error message */}
          {error && (
            <p style={{ color: "red", textAlign: "center" }}>{error}</p>
          )}

          {/* Submit */}
          <Button
            variant="primary"
            style={{ width: "100%", marginTop: "10px" }}
            onClick={handleLogin}
          >
            Submit
          </Button>
        </Form>
      </Card>
    </div>
  );
}

export default App;

