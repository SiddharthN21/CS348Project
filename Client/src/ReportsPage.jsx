// -------------------------------------------------------------
// ReportsPage.jsx
// Loads dynamic data (GPA range + course list)
// Handles "Generate Report" backend call
// Displays results in popup window with sorting + badges + sticky header
// -------------------------------------------------------------

import React, { useEffect, useState } from "react";
import ReportFilters from "./ReportFilters";

const ReportsPage = () => {
  const [minGPA, setMinGPA] = useState(null);
  const [maxGPA, setMaxGPA] = useState(null);
  const [courseList, setCourseList] = useState([]);

  useEffect(() => {
    fetch("http://localhost:5000/api/reports/gpa-range")
      .then((res) => res.json())
      .then((data) => {
        setMinGPA(data.min_gpa);
        setMaxGPA(data.max_gpa);
      });

    fetch("http://localhost:5000/api/reports/courses")
      .then((res) => res.json())
      .then((data) => {
        setCourseList(data.courses);
      });
  }, []);

  // -------------------------------------------------------------
  // Called when user clicks "Generate Report"
  // -------------------------------------------------------------
  const handleGenerateReport = (filters) => {
    const reportWindow = window.open("", "_blank", "width=1100,height=800");

    reportWindow.document.body.innerHTML = `
      <h2 style="font-family: Arial; margin-top: 20px;">Generating Report...</h2>
      <p>Please wait while we fetch your results.</p>
    `;

    fetch("http://localhost:5000/api/reports/filter", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(filters)
    })
      .then((res) => res.json())
      .then((data) => {
        const results = data.results || [];

        // ---------------------------------------------------------
        // Build table rows with grade badges
        // ---------------------------------------------------------
        const rows = results
          .map((r) => {
            const grade = r.grade ?? "";
            const badgeClass =
              grade === "A" ? "bg-success text-white px-2 py-1 rounded"
              : grade === "B" ? "bg-primary text-white px-2 py-1 rounded"
              : grade === "C" ? "bg-warning text-dark px-2 py-1 rounded"
              : grade === "D" ? "bg-orange text-dark px-2 py-1 rounded"
              : grade === "F" ? "bg-danger text-white px-2 py-1 rounded"
              : "bg-secondary text-white px-2 py-1 rounded";

            return `
              <tr>
                <td>${r.student_id}</td>
                <td>${r.full_name ?? ""}</td>
                <td>${r.avg_gpa ?? ""}</td>
                <td>${r.year ?? ""}</td>
                <td>${r.term_code ?? ""}</td>
                <td>${r.course_code ?? ""}</td>
                <td>${r.course_title ?? ""}</td>
                <td><span class="${badgeClass}">${grade}</span></td>
              </tr>
            `;
          })
          .join("");

        const emptyMessage = `
          <p style="font-size: 16px; margin-top: 20px;">
            <strong>No results found.</strong><br>
            Try adjusting your filter.
          </p>
        `;

        // ---------------------------------------------------------
        // Full popup HTML with sorting + sticky header
        // ---------------------------------------------------------
        reportWindow.document.body.innerHTML = `
          <html>
            <head>
              <title>Student Report</title>
              <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />

              <style>
                thead th {
                  position: sticky;
                  top: 0;
                  background: #212529;
                  color: white;
                  cursor: pointer;
                  z-index: 2;
                }
                tbody tr:hover {
                  background-color: #f1f1f1;
                }
              </style>

              <script>
                // Sorting function
                function sortTable(colIndex) {
                  const table = document.getElementById("reportTable");
                  let switching = true;
                  let dir = "asc";

                  while (switching) {
                    switching = false;
                    const rows = table.rows;

                    for (let i = 1; i < rows.length - 1; i++) {
                      let shouldSwitch = false;
                      const x = rows[i].getElementsByTagName("TD")[colIndex];
                      const y = rows[i + 1].getElementsByTagName("TD")[colIndex];

                      let xVal = x.innerText.toLowerCase();
                      let yVal = y.innerText.toLowerCase();

                      // Numeric sort if both values are numbers
                      if (!isNaN(parseFloat(xVal)) && !isNaN(parseFloat(yVal))) {
                        xVal = parseFloat(xVal);
                        yVal = parseFloat(yVal);
                      }

                      if (dir === "asc" && xVal > yVal) {
                        shouldSwitch = true;
                        break;
                      }
                      if (dir === "desc" && xVal < yVal) {
                        shouldSwitch = true;
                        break;
                      }
                    }

                    if (shouldSwitch) {
                      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                      switching = true;
                    } else {
                      if (dir === "asc") {
                        dir = "desc";
                        switching = true;
                      }
                    }
                  }
                }
              </script>
            </head>

            <body style="padding: 20px; font-family: Arial;">
              <h2>Student Report</h2>

              ${
                results.length === 0
                  ? emptyMessage
                  : `
                <div style="max-height: 600px; overflow-y: auto;">
                  <table id="reportTable" class="table table-striped table-bordered mt-3">
                    <thead class="table-dark">
                      <tr>
                        <th onclick="sortTable(0)">ID</th>
                        <th onclick="sortTable(1)">Name</th>
                        <th onclick="sortTable(2)">GPA</th>
                        <th onclick="sortTable(3)">Year</th>
                        <th onclick="sortTable(4)">Term</th>
                        <th onclick="sortTable(5)">Course Code</th>
                        <th onclick="sortTable(6)">Course Title</th>
                        <th onclick="sortTable(7)">Grade</th>
                      </tr>
                    </thead>
                    <tbody>
                      ${rows}
                    </tbody>
                  </table>
                </div>
              `
              }
            </body>
          </html>
        `;
      })
      .catch((err) => {
        reportWindow.document.body.innerHTML = `
          <h2>Error</h2>
          <p>Could not load report.</p>
          <pre>${err}</pre>
        `;
      });
  };

  return (
    <div className="container mt-4">
      <h2 className="mb-4">Student Reports & Filtering</h2>

      <ReportFilters
        minGPA={minGPA}
        maxGPA={maxGPA}
        courseList={courseList}
        onGenerate={handleGenerateReport}
      />
    </div>
  );
};

export default ReportsPage;