// -------------------------------------------------------------
// ReportFilters.jsx
// UI for selecting:
// - Year + Semester
// - GPA range
// - Single course
// Includes:
// - Clear Filters button
// - Generate Report button
// - Only ONE filter group active at a time
// -------------------------------------------------------------

import React, { useState, useEffect } from "react";
import { Form, Button, Row, Col } from "react-bootstrap";

const ReportFilters = ({ minGPA, maxGPA, courseList, onGenerate }) => {
  // Selected filter values
  const [selectedYear, setSelectedYear] = useState("");
  const [selectedTerm, setSelectedTerm] = useState("");
  const [selectedMinGPA, setSelectedMinGPA] = useState("");
  const [selectedMaxGPA, setSelectedMaxGPA] = useState("");
  const [selectedCourse, setSelectedCourse] = useState("");

  // Track which filter group is active: "year", "gpa", "course", or null
  const [activeFilter, setActiveFilter] = useState(null);

  const [yearOptions, setYearOptions] = useState([]);

  // ---------------------------------------------------------
  // BUILD VALID YEARS (only years with at least one completed semester)
  // ---------------------------------------------------------
  const buildValidYears = () => {
    const today = new Date();
    const currentYear = today.getFullYear();
    const month = today.getMonth() + 1;

    const years = [];

    for (let y = currentYear - 5; y <= currentYear; y++) {
      let hasPassedSemester = false;

      if (y < currentYear) {
        hasPassedSemester = true; // all semesters passed in past years
      } else {
        // y == currentYear → check if ANY semester has ended
        if (month > 5) hasPassedSemester = true; // SPRING ended
        if (month > 8) hasPassedSemester = true; // SUMMER ended
        if (month > 12) hasPassedSemester = true; // FALL ended
      }

      if (hasPassedSemester) years.push(y);
    }

    return years;
  };

  // -------------------------------------------------------------
  // Determine valid terms for selected year
  // -------------------------------------------------------------
  const getValidTermsForYear = (year) => {
    const currentYear = new Date().getFullYear();
    const currentMonth = new Date().getMonth() + 1;

    if (year < currentYear) return ["SPRING", "SUMMER", "FALL"];
    if (year > currentYear) return [];

    if (currentMonth <= 5) return [];
    if (currentMonth > 5 && currentMonth <= 8) return ["SPRING"];
    if (currentMonth > 8 && currentMonth <= 12) return ["SPRING", "SUMMER"];
    return ["SPRING", "SUMMER", "FALL"];
  };

  useEffect(() => {
    setYearOptions(buildValidYears());
  }, []);

  // -------------------------------------------------------------
  // Clear all filters
  // -------------------------------------------------------------
  const clearFilters = () => {
    setSelectedYear("");
    setSelectedTerm("");
    setSelectedMinGPA("");
    setSelectedMaxGPA("");
    setSelectedCourse("");
    setActiveFilter(null); // reset filter mode
  };

  // -------------------------------------------------------------
  // Send selected filters to parent component
  // -------------------------------------------------------------
  const handleGenerate = () => {
    const filters = {
      year: selectedYear || null,
      term_code: selectedTerm || null,
      min_gpa: selectedMinGPA || null,
      max_gpa: selectedMaxGPA || null,
      course_id: selectedCourse ? parseInt(selectedCourse) : null
    };
    onGenerate(filters);
  };

  return (
    <div className="p-2 border rounded bg-light" style={{ maxWidth: "650px" }}>
      {/* ---------------- GUIDANCE BOX ---------------- */}
      <div className="alert alert-info py-2 mb-2" style={{ fontSize: "0.85rem" }}>
        <strong>Filter Rules:</strong> Select <strong>only one</strong> filter type.
        Choosing one disables the others. If you need to select <strong> different filter </strong> then <strong> clear </strong>earlier selection.
      </div>

      {/* ---------------- YEAR + SEMESTER ---------------- */}
      <h6 className="mt-2 mb-1">Year & Semester</h6>
      <Row className="g-2 mb-2">
        <Col xs={6}>
          <Form.Select
            size="sm"
            disabled={activeFilter && activeFilter !== "year"}
            value={selectedYear}
            onChange={(e) => {
              setSelectedYear(parseInt(e.target.value));
              setSelectedTerm("");
              setActiveFilter("year");
            }}
          >
            <option value="">Year</option>
            {yearOptions.map((y) => (
              <option key={y} value={y}>{y}</option>
            ))}
          </Form.Select>
        </Col>

        <Col xs={6}>
          <Form.Select
            size="sm"
            disabled={!selectedYear || (activeFilter && activeFilter !== "year")}
            value={selectedTerm}
            onChange={(e) => {
              setSelectedTerm(e.target.value);
              setActiveFilter("year");
            }}
          >
            <option value="">Semester</option>
            {selectedYear &&
              getValidTermsForYear(selectedYear).map((t) => (
                <option key={t} value={t}>{t}</option>
              ))}
          </Form.Select>
        </Col>
      </Row>

      <hr className="my-2" />

      {/* ---------------- GPA RANGE ---------------- */}
      <h6 className="mt-2 mb-1">GPA Range</h6>
      <Row className="g-2 mb-2">
        <Col xs={6}>
          <Form.Control
            size="sm"
            type="number"
            step="0.01"
            min={minGPA}
            max={maxGPA}
            disabled={activeFilter && activeFilter !== "gpa"}
            value={selectedMinGPA}
            placeholder={`Min (${minGPA})`}
            onChange={(e) => {
              const val = parseFloat(e.target.value);
              if (val >= minGPA && val <= maxGPA) {
                setSelectedMinGPA(val);
                setActiveFilter("gpa");
              }
            }}
          />
        </Col>

        <Col xs={6}>
          <Form.Control
            size="sm"
            type="number"
            step="0.01"
            min={minGPA}
            max={maxGPA}
            disabled={activeFilter && activeFilter !== "gpa"}
            value={selectedMaxGPA}
            placeholder={`Max (${maxGPA})`}
            onChange={(e) => {
              const val = parseFloat(e.target.value);
              if (val >= minGPA && val <= maxGPA) {
                setSelectedMaxGPA(val);
                setActiveFilter("gpa");
              }
            }}
          />
        </Col>
      </Row>

      <hr className="my-2" />

      {/* ---------------- COURSE FILTER ---------------- */}
      <h6 className="mt-2 mb-1">Course Taken</h6>
      <Row className="g-2 mb-2">
        <Col xs={12}>
          <Form.Select
            size="sm"
            disabled={activeFilter && activeFilter !== "course"}
            value={selectedCourse}
            onChange={(e) => {
              setSelectedCourse(parseInt(e.target.value));
              setActiveFilter("course");
            }}
          >
            <option value="">Select Course</option>
            {courseList.map((c) => (
              <option key={c.course_id} value={c.course_id}>
                {c.subject}{c.number} — {c.title}
              </option>
            ))}
          </Form.Select>
        </Col>
      </Row>

      {/* ---------------- BUTTONS ---------------- */}
      <Row className="mt-2">
        <Col>
          <Button size="sm" variant="secondary" onClick={clearFilters}>
            Clear
          </Button>
        </Col>

        <Col className="text-end">
          <Button size="sm" variant="primary" onClick={handleGenerate}>
            Generate Report
          </Button>
        </Col>
      </Row>
    </div>
  );
};

export default ReportFilters;