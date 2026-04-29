/**
 * CoursesPage.jsx
 *
 * Fully functional version with:
 *  - Fetch courses taken
 *  - Add Course modal with dynamic dropdowns
 *  - Subject → Course Number → Title/Credits auto-fill
 *  - Grade dropdown
 *  - Year-first selection
 *  - Year dropdown filtered (no future years)
 *  - Semester dropdown filtered based on year
 *  - Prevent future completed courses
 *  - Color-coded editable vs read-only fields
 *  - Compact 2-column layout
 */

import { useState, useEffect } from "react";
import { Table, Button, Modal, Form } from "react-bootstrap";
import PageContainer from "./PageContainer";

export default function CoursesPage() {
  // ---------------------------------------------------------
  // STATE
  // ---------------------------------------------------------
  const [courses, setCourses] = useState([]);

  const [showModal, setShowModal] = useState(false);
  const [editMode, setEditMode] = useState(false);

  // Dropdown data
  const [subjects, setSubjects] = useState([]);
  const [courseNumbers, setCourseNumbers] = useState([]);
  const [grades, setGrades] = useState([]);

  // Selected values
  const [selectedSubject, setSelectedSubject] = useState("");
  const [selectedCourse, setSelectedCourse] = useState(null);
  const [editingStudentCourseId, setEditingStudentCourseId] = useState(null);
  const [selectedGrade, setSelectedGrade] = useState("");
  const [selectedTerm, setSelectedTerm] = useState("FALL");
  const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());
  const [selectedCredits, setSelectedCredits] = useState("");

  const [yearOptions, setYearOptions] = useState([]);

  // ---------------------------------------------------------
  // HELPER: Determine if a term/year is in the future
  // ---------------------------------------------------------
  const isFutureTerm = (term, year) => {
    const today = new Date();
    const currentYear = today.getFullYear();
    const month = today.getMonth() + 1;

    if (year > currentYear) return true;
    if (year < currentYear) return false;

    // Same year → compare month to term end
    if (term === "SPRING") return month <= 5;
    if (term === "SUMMER") return month <= 8;
    if (term === "FALL") return month <= 12;

    return false;
  };

  // ---------------------------------------------------------
  // VALID TERMS FOR A GIVEN YEAR
  // ---------------------------------------------------------
  const getValidTermsForYear = (year) => {
    const today = new Date();
    const currentYear = today.getFullYear();
    const month = today.getMonth() + 1;

    if (year < currentYear) {
      return ["SPRING", "SUMMER", "FALL"]; // all valid
    }

    // year == currentYear
    const valid = [];
    if (month > 5) valid.push("SPRING");
    if (month > 8) valid.push("SUMMER");
    if (month > 12) valid.push("FALL");

    return valid;
  };

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

  // ---------------------------------------------------------
  // COMPUTED: Disable Add button until all required fields valid
  // ---------------------------------------------------------
  const isAddDisabled = !(
    selectedSubject &&
    selectedCourse &&
    selectedGrade &&
    selectedYear &&
    selectedTerm &&
    selectedCredits &&
    !isFutureTerm(selectedTerm, selectedYear)
  );

  // ---------------------------------------------------------
  // FETCH COURSES TAKEN
  // ---------------------------------------------------------
  const loadCourses = () => {
    const student_id = localStorage.getItem("student_id");
    if (!student_id) return;

    fetch(`http://localhost:5000/api/courses-taken/${student_id}`)
      .then((res) => res.json())
      .then((data) => setCourses(data))
      .catch((err) => console.error("Error fetching courses:", err));
  };

  useEffect(() => {
    loadCourses();
  }, []);

  // ---------------------------------------------------------
  // LOAD DROPDOWN DATA ON PAGE LOAD
  // ---------------------------------------------------------
  useEffect(() => {
    fetch("http://localhost:5000/api/subjects")
      .then((res) => res.json())
      .then(setSubjects);

    fetch("http://localhost:5000/api/grade-scale")
      .then((res) => res.json())
      .then(setGrades);

    const years = buildValidYears();
    // If editing, ensure the record's year is included
    if (editMode && !years.includes(selectedYear)) {
      years.push(selectedYear);
      years.sort((a, b) => b - a); // keep descending order
    }
    setYearOptions(years);

    if (!years.includes(selectedYear)) {
      setSelectedYear(years[years.length - 1]);
    }
  }, []);

  // ---------------------------------------------------------
  // SUBJECT CHANGE → LOAD COURSE NUMBERS
  // ---------------------------------------------------------
  const handleSubjectChange = (subject) => {
    setSelectedSubject(subject);
    setSelectedCourse(null);

    fetch(`http://localhost:5000/api/courses-by-subject/${subject}`)
      .then((res) => res.json())
      .then(setCourseNumbers);
  };

  // ---------------------------------------------------------
  // COURSE NUMBER CHANGE → AUTO-FILL TITLE + CREDITS
  // ---------------------------------------------------------
  const handleCourseNumberChange = (courseId) => {
    const course = courseNumbers.find(
      (c) => c.course_id === parseInt(courseId)
    );
    setSelectedCourse(course);

    if (course) {
      setSelectedCredits(course.min_credit);
    }
  };

  // ---------------------------------------------------------
  // EDIT BUTTON CLICK — POPULATE MODAL WITH ROW DATA
  // ---------------------------------------------------------
  const handleEditClick = (courseRecord) => {
    setEditMode(true);
    setShowModal(true);

    // IDs needed for update
    setEditingStudentCourseId(courseRecord.student_course_id);

    // READ-ONLY FIELDS
    setSelectedSubject(courseRecord.subject);

    setSelectedCourse({
      course_id: courseRecord.course_id,
      course_number: courseRecord.number,
      title: courseRecord.title,
      min_credit: courseRecord.credits,
      max_credit: courseRecord.credits,
      is_variable_credit: false
    });

    setSelectedCredits(courseRecord.credits);

    // EDITABLE FIELDS
    setSelectedYear(courseRecord.year);
    setSelectedTerm(courseRecord.term);
    setSelectedGrade(courseRecord.grade);
  };

  // ---------------------------------------------------------
  // SUBMIT ADD COURSE
  // ---------------------------------------------------------
  const handleAddCourse = () => {
    const student_id = localStorage.getItem("student_id");

    if (!selectedSubject || !selectedCourse || !selectedGrade) {
      alert("Please fill all required fields.");
      return;
    }

    if (isFutureTerm(selectedTerm, selectedYear)) {
      alert("Cannot add a completed course in a future term/year.");
      return;
    }

    fetch("http://localhost:5000/api/student-course/add", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        student_id,
        course_id: selectedCourse.course_id,
        term_code: selectedTerm,
        year: selectedYear,
        credits: selectedCredits,
        grade: selectedGrade,
      }),
    })
      .then((res) => res.json())
      .then((data) => {
        alert(data.message);
        setShowModal(false);
        loadCourses();
      })
      .catch((err) => console.error("Error adding course:", err));
  };

  // ---------------------------------------------------------
  // SUBMIT EDIT COURSE
  // ---------------------------------------------------------
  const handleEditCourse = () => {
    const student_id = localStorage.getItem("student_id");

    if (isFutureTerm(selectedTerm, selectedYear)) {
      alert("Cannot set a completed course in a future term/year.");
      return;
    }

    fetch(`http://localhost:5000/api/student-course/update/${editingStudentCourseId}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        student_id,
        term_code: selectedTerm,
        year: selectedYear,
        grade: selectedGrade,
      }),
    })
      .then((res) => res.json())
      .then((data) => {
        alert(data.message);
        setShowModal(false);
        loadCourses();
      })
      .catch((err) => console.error("Error updating course:", err));
  };

  // ---------------------------------------------------------
  // SUBMIT DELETE COURSE
  // ---------------------------------------------------------
  const handleDeleteCourse = (courseRecord) => {
  const student_id = localStorage.getItem("student_id");
  const courseLabel = `${courseRecord.subject}${' '}${courseRecord.number}`;

  if (!window.confirm(`Are you sure you want to delete course:${courseLabel}?`)) {
    return;
  }

  fetch(`http://localhost:5000/api/student-course/delete/${courseRecord.student_course_id}`, {
    method: "DELETE",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ student_id })
  })
    .then((res) => res.json())
    .then((data) => {
      alert(data.message);
      loadCourses(); // refresh table
    })
    .catch((err) => console.error("Error deleting course:", err));
  };

  // ---------------------------------------------------------
  // RENDER
  // ---------------------------------------------------------
  return (
    <PageContainer>
      <div style={{ width: "100%", display: "flex", flexDirection: "column" }}>
        <h2 style={{ color: "#003366" }}>Courses Taken</h2>

        <Button
          variant="primary"
          style={{ marginBottom: "20px" }}
          onClick={() => {
            setEditMode(false);
            setShowModal(true);
          }}
        >
          Add Course Taken
        </Button>

        {/* ------------------------------------------------------------
            COURSES TABLE
        ------------------------------------------------------------ */}
        <div
          style={{
            background: "white",
            padding: "20px",
            borderRadius: "8px",
            boxShadow: "0 2px 8px rgba(0,0,0,0.1)",
            width: "100%",
            boxSizing: "border-box",
          }}
        >
          <Table striped bordered hover style={{ width: "100%" }}>
            <thead>
              <tr>
                <th>Subject</th>
                <th>Number</th>
                <th>Term</th>
                <th>Year</th>
                <th>Credits</th>
                <th>Grade</th>
                <th>Department</th>
                <th>Course Title</th>
                <th>Actions</th>
              </tr>
            </thead>

            <tbody>
              {courses.map((c, idx) => (
                <tr key={idx}>
                  <td>{c.subject}</td>
                  <td>{c.number}</td>
                  <td>{c.term}</td>
                  <td>{c.year}</td>
                  <td>{c.credits}</td>
                  <td>{c.grade}</td>
                  <td>{c.department}</td>
                  <td>{c.title}</td>

                  <td>
                    <Button
                      size="sm"
                      variant="warning"
                      onClick={() => handleEditClick(c)}
                    >
                      Edit
                    </Button>{" "}
                    <Button
                      size="sm"
                      variant="danger"
                      className="ms-2"
                      onClick={() => handleDeleteCourse(c)}
                    >
                      Delete
                    </Button>
                  </td>
                </tr>
              ))}
            </tbody>
          </Table>
        </div>

        {/* ------------------------------------------------------------
            ADD / EDIT COURSE MODAL
        ------------------------------------------------------------ */}
        <Modal show={showModal} onHide={() => setShowModal(false)} size="lg">
          <Modal.Header
            closeButton
            style={{ backgroundColor: "#003366", color: "white" }}
          >
            <Modal.Title>{editMode ? "Edit Student Course" : "Add Student Course"}</Modal.Title>
          </Modal.Header>

          <Modal.Body style={{ backgroundColor: "#f8f9fc" }}>
            <Form>
              {/* 2‑COLUMN GRID */}
              <div
                style={{
                  display: "grid",
                  gridTemplateColumns: "1fr 1fr",
                  gap: "15px",
                }}
              >
                {/* SUBJECT */}
                <Form.Group>
                  <Form.Label>Subject</Form.Label>

                  {editMode ? (
                    // READ ONLY IN EDIT MODE
                    <Form.Control
                      type="text"
                      value={selectedSubject}
                      readOnly
                      style={{
                        backgroundColor: "#f2f2f2",
                        borderColor: "#cccccc",
                        color: "#555",
                      }}
                    />
                  ) : (
                    // EDITABLE IN ADD MODE
                    <Form.Select
                      value={selectedSubject}
                      onChange={(e) => handleSubjectChange(e.target.value)}
                      style={{
                        backgroundColor: "#fff9d6",
                        borderColor: "#d4b100",
                      }}
                    >
                      <option value="">Select Subject</option>
                      {subjects.map((s) => (
                        <option key={s} value={s}>
                          {s}
                        </option>
                      ))}
                    </Form.Select>
                  )}
                </Form.Group>

                {/* COURSE NUMBER */}
                <Form.Group>
                  <Form.Label>Course Number</Form.Label>

                  {editMode ? (
                    <Form.Control
                      type="text"
                      value={selectedCourse?.course_number || ""}
                      readOnly
                      style={{
                        backgroundColor: "#f2f2f2",
                        borderColor: "#cccccc",
                        color: "#555",
                      }}
                    />
                  ) : (
                    <Form.Select
                      onChange={(e) => handleCourseNumberChange(e.target.value)}
                      style={{
                        backgroundColor: "#fff9d6",
                        borderColor: "#d4b100",
                      }}
                    >
                      <option value="">Select Course</option>
                      {courseNumbers.map((c) => (
                        <option key={c.course_id} value={c.course_id}>
                          {c.course_number}
                        </option>
                      ))}
                    </Form.Select>
                  )}
                </Form.Group>


                {/* TITLE */}
                <Form.Group>
                  <Form.Label>Course Title</Form.Label>
                  <Form.Control
                    type="text"
                    value={selectedCourse?.title || ""}
                    readOnly
                    style={{
                      backgroundColor: "#f2f2f2",
                      borderColor: "#cccccc",
                      color: "#555",
                    }}
                  />
                </Form.Group>

                {/* CREDITS */}
                <Form.Group>
                  <Form.Label>Credits</Form.Label>
                  <Form.Control
                    type="number"
                    value={selectedCredits}
                    readOnly={!selectedCourse?.is_variable_credit}
                    onChange={(e) => setSelectedCredits(e.target.value)}
                    style={{
                      backgroundColor: selectedCourse?.is_variable_credit
                        ? "#fff9d6"
                        : "#f2f2f2",
                      borderColor: selectedCourse?.is_variable_credit
                        ? "#d4b100"
                        : "#cccccc",
                      color: selectedCourse?.is_variable_credit
                        ? "black"
                        : "#555",
                    }}
                  />
                </Form.Group>

                {/* YEAR FIRST */}
                <Form.Group>
                  <Form.Label>Year</Form.Label>
                  <Form.Select
                    value={selectedYear}
                    onChange={(e) => {
                      const y = parseInt(e.target.value);
                      setSelectedYear(y);

                      const validTerms = getValidTermsForYear(y);
                      if (!validTerms.includes(selectedTerm)) {
                        setSelectedTerm(validTerms[validTerms.length - 1]);
                      }
                    }}
                    style={{
                      backgroundColor: "#fff9d6",
                      borderColor: "#d4b100",
                    }}
                  >
                    {yearOptions.map((y) => (
                      <option key={y} value={y}>
                        {y}
                      </option>
                    ))}
                  </Form.Select>
                </Form.Group>

                {/* SEMESTER SECOND */}
                <Form.Group>
                  <Form.Label>Semester</Form.Label>

                  {(() => {
                    // Build valid terms list
                    let validTerms = getValidTermsForYear(selectedYear);

                    // If editing, ensure the record's term is included
                    if (editMode && !validTerms.includes(selectedTerm)) {
                      validTerms = [...validTerms, selectedTerm];
                    }

                    return (
                      <Form.Select
                        value={selectedTerm}
                        onChange={(e) => setSelectedTerm(e.target.value)}
                        style={{
                          backgroundColor: "#fff9d6",
                          borderColor: "#d4b100",
                        }}
                      >
                        {validTerms.map((t) => (
                          <option key={t} value={t}>
                            {t}
                          </option>
                        ))}
                      </Form.Select>
                    );
                  })()}
                </Form.Group>

                {/* GRADE */}
                <Form.Group>
                  <Form.Label>Grade</Form.Label>
                  <Form.Select
                    value={selectedGrade}
                    onChange={(e) => setSelectedGrade(e.target.value)}
                    style={{
                      backgroundColor: "#fff9d6",
                      borderColor: "#d4b100",
                    }}
                  >
                    <option value="">Select Grade</option>
                    {grades.map((g) => (
                      <option key={g} value={g}>
                        {g}
                      </option>
                    ))}
                  </Form.Select>
                </Form.Group>
              </div>
            </Form>
          </Modal.Body>

          <Modal.Footer style={{ backgroundColor: "#f0f4fa" }}>
            <Button variant="secondary" onClick={() => setShowModal(false)}>
              Cancel
            </Button>
            <Button
              variant="primary"
              disabled={isAddDisabled}
              onClick={editMode ? handleEditCourse : handleAddCourse}
              style={{
                opacity: isAddDisabled ? 0.5 : 1,
                cursor: isAddDisabled ? "not-allowed" : "pointer"
              }}
            >
              {editMode ? "Save Changes" : "Add Course"}
            </Button>
          </Modal.Footer>
        </Modal>
      </div>
    </PageContainer>
  );
}