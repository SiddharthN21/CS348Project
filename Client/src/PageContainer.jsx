/**
 * PageContainer.jsx
 *
 * A reusable wrapper component that ensures:
 *  - Consistent padding across all pages
 *  - Full-width and full-height layout inside the dashboard
 *  - Prevents content from shrinking based on text size
 *
 * All pages (Home, Courses, Criteria, Snapshot) should wrap
 * their content inside <PageContainer> for consistent UI.
 */

export default function PageContainer({ children }) {
  return (
    <div
      style={{
        flex: 1,                // <-- CRITICAL: fills available space
        width: "100%",          // full width of right panel
        height: "100%",         // fill parent container
        minHeight: "100vh",     // ensures full vertical coverage
        display: "flex",        // allow children to stretch
        flexDirection: "column",
        padding: "10px",
        boxSizing: "border-box"
      }}
    >
      {children}
    </div>
  );
}
