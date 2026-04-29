import React, { useEffect, useState } from "react";
import { Form, Button, Row, Col, Alert } from "react-bootstrap";

const DegreePlanCriteria = () => {
  const studentId = localStorage.getItem("student_id");

  // Dropdown data
  const [majors, setMajors] = useState(null);
  const [tracks, setTracks] = useState(null);
  const [minors, setMinors] = useState(null);
  const [certs, setCerts] = useState(null);

  // Selected values
  const [selectedMajor, setSelectedMajor] = useState("");
  const [selectedTracks, setSelectedTracks] = useState([]);
  const [selectedMinor, setSelectedMinor] = useState(null); // RADIO
  const [selectedCerts, setSelectedCerts] = useState([]);

  // Credit preferences
  const [preferredCredits, setPreferredCredits] = useState("");
  const [minCredits, setMinCredits] = useState("");
  const [maxCredits, setMaxCredits] = useState("");

  const [message, setMessage] = useState(null);

  // ---------------------------------------------------------
  // Load dropdown options + existing criteria
  // ---------------------------------------------------------
  useEffect(() => {
    fetch("http://localhost:5000/api/degree-plan/options")
      .then((res) => res.json())
      .then((data) => {
        setMajors(data.majors);
        setTracks(data.tracks);
        setMinors(data.minors);
        setCerts(data.certifications);
      });

    fetch(`http://localhost:5000/api/degree-plan/criteria/${studentId}`)
      .then((res) => res.json())
      .then((data) => {
        if (!data || !data.criteria) return;

        const c = data.criteria;

        setSelectedMajor(c.selected_major || "");

        setSelectedTracks(JSON.parse(c.selected_tracks || "[]"));
        setSelectedMinor(JSON.parse(c.selected_minors || "[]")[0] || null);
        setSelectedCerts(JSON.parse(c.selected_certifications || "[]"));

        setPreferredCredits(c.preferred_credits || "");
        setMinCredits(c.min_credits || "");
        setMaxCredits(c.max_credits || "");
      });
  }, [studentId]);

  // ---------------------------------------------------------
  // Filter tracks by selected major
  // ---------------------------------------------------------
  const filteredTracks = tracks?.filter(
    (t) => t.major_id === Number(selectedMajor)
  ) || [];

  // ---------------------------------------------------------
  // Track selection (max 2)
  // ---------------------------------------------------------
  const toggleTrack = (trackId) => {
    if (selectedTracks.includes(trackId)) {
      setSelectedTracks(selectedTracks.filter((id) => id !== trackId));
    } else {
      if (selectedTracks.length >= 2) {
        setMessage({
          type: "danger",
          text: "You can select a maximum of 2 tracks."
        });
        return;
      }
      setSelectedTracks([...selectedTracks, trackId]);
    }
  };

  // ---------------------------------------------------------
  // Certification selection (max 2)
  // ---------------------------------------------------------
  const toggleCert = (certId) => {
    if (selectedCerts.includes(certId)) {
      setSelectedCerts(selectedCerts.filter((id) => id !== certId));
    } else {
      if (selectedCerts.length >= 2) {
        setMessage({
          type: "danger",
          text: "You can select a maximum of 2 certifications."
        });
        return;
      }
      setSelectedCerts([...selectedCerts, certId]);
    }
  };

  // ---------------------------------------------------------
  // Save criteria
  // ---------------------------------------------------------
  const handleSave = () => {
    const payload = {
      student_id: studentId,
      selected_major: selectedMajor,
      selected_tracks: selectedTracks,
      selected_minors: selectedMinor ? [selectedMinor] : [],
      selected_certifications: selectedCerts,
      preferred_credits: preferredCredits,
      min_credits: minCredits,
      max_credits: maxCredits
    };

    fetch("http://localhost:5000/api/degree-plan/criteria", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    })
      .then((res) => res.json())
      .then((data) => {
        setMessage({ type: "success", text: "Criteria saved successfully: " + data.message });
      })
      .catch(() => {
        setMessage({ type: "danger", text: "Error saving criteria" });
      });
  };

  // ---------------------------------------------------------
  // Reset criteria
  // ---------------------------------------------------------
  const handleReset = () => {
    setSelectedMajor("");
    setSelectedTracks([]);
    setSelectedMinor(null);
    setSelectedCerts([]);
    setPreferredCredits("");
    setMinCredits("");
    setMaxCredits("");
    setMessage({ type: "info", text: "Criteria reset." });
  };

  // ---------------------------------------------------------
  // Validation rules
  // ---------------------------------------------------------
  const isValid =
    selectedMajor &&
    minCredits >= 6 &&
    minCredits <= 9 &&
    maxCredits >= 15 &&
    maxCredits <= 18 &&
    preferredCredits >= minCredits &&
    preferredCredits <= maxCredits;

  if (!majors || !tracks || !minors || !certs) {
    return <div>Loading Degree Plan Criteria...</div>;
  }

  return (
    <div className="container mt-0">
      <h2 className="mt-1 mb-2">Degree Plan Criteria(Sample Only)</h2>
      <p className="text-muted">Select your preferences for generating a degree plan.</p>

      {message && (
        <Alert className="py-2 my-2" variant={message.type} onClose={() => setMessage(null)} dismissible>
          {message.text}
        </Alert>
      )}

      <Form>
        {/* Major */}
        <Form.Group className="mb-3">
          <Form.Label><strong>Major</strong></Form.Label>
          <Form.Select
            value={selectedMajor}
            onChange={(e) => {
              setSelectedMajor(e.target.value);
              setSelectedTracks([]); // reset tracks
            }}
          >
            <option value="">-- Select Major --</option>
            {majors.map((m) => (
              <option key={m.major_id} value={m.major_id}>
                {m.major_name}
              </option>
            ))}
          </Form.Select>
        </Form.Group>

        {/* Tracks (max 2) */}
        <Form.Group className="mb-3">
          <Form.Label><strong>Tracks (Max 2)</strong></Form.Label>
          {filteredTracks.length === 0 && (
            <div className="text-muted">Select a major to see available tracks.</div>
          )}
          <Row>
            {filteredTracks.map((t) => (
              <Col md={6} key={t.track_id}>   {/* 2-column layout */}
                <Form.Check
                  key={t.track_id}
                  type="checkbox"
                  label={t.track_name}
                  checked={selectedTracks.includes(t.track_id)}
                  onChange={() => toggleTrack(t.track_id)}
                />
              </Col>
            ))}
          </Row>
        </Form.Group>

        {/* Minors (radio, 2-column) */}
        <Form.Group className="mb-3">
          <Form.Label><strong>Minor (Max 1)</strong></Form.Label>
          <Row>
            {minors.map((m) => (
              <Col md={4} key={m.minor_id}>   {/* 3-column layout */}
                <Form.Check
                  type="radio"
                  label={m.minor_name}
                  name="minorRadio"
                  checked={selectedMinor === m.minor_id}
                  onChange={() => setSelectedMinor(m.minor_id)}
                />
              </Col>
            ))}
          </Row>
        </Form.Group>

        {/* Certifications (max 2, 3-column) */}
        <Form.Group className="mb-3">
          <Form.Label><strong>Certifications (Max 2)</strong></Form.Label>
          <Row>
            {certs.map((c) => (
              <Col md={4} key={c.certification_id}> {/* 3-column layout */}
                <Form.Check
                  type="checkbox"
                  label={c.certification_name}
                  checked={selectedCerts.includes(c.certification_id)}
                  onChange={() => toggleCert(c.certification_id)}
                />
              </Col>
            ))}
          </Row>
        </Form.Group>

        {/* Credit Preferences */}
        <Row>
          <Col>
            <Form.Group className="mb-3">
              <Form.Label>
                Preferred Credits 
                <span className="text-muted ms-1"> </span>
              </Form.Label>
              <Form.Control
                type="number"
                min={minCredits || 6}
                max={maxCredits || 18}
                value={preferredCredits}
                onChange={(e) => {
                  const val = Number(e.target.value);
                  if (val >= (minCredits || 6) && val <= (maxCredits || 18)) {
                    setPreferredCredits(val);
                  }
                }}
              />
            </Form.Group>
          </Col>

          <Col>
            <Form.Group className="mb-3">
              <Form.Label>
                Min Credits <span className="text-muted">(Allowed: 6–9)</span>
              </Form.Label>
              <Form.Control
                type="number"
                min={6}
                max={9}
                value={minCredits}
                onChange={(e) => {
                  const val = Number(e.target.value);
                  if (val >= 6 && val <= 9) {
                    setMinCredits(val);

                    // Auto-adjust preferred if out of range
                    if (preferredCredits < val) setPreferredCredits(val);
                  }
                }}
              />
            </Form.Group>
          </Col>

          <Col>
            <Form.Group className="mb-3">
              <Form.Label>
                Max Credits <span className="text-muted">(Allowed: 15–18)</span>
              </Form.Label>
              <Form.Control
                type="number"
                min={15}
                max={18}
                value={maxCredits}
                onChange={(e) => {
                  const val = Number(e.target.value);
                  if (val >= 15 && val <= 18) {
                    setMaxCredits(val);

                    // Auto-adjust preferred if out of range
                    if (preferredCredits > val) setPreferredCredits(val);
                  }
                }}
              />
            </Form.Group>
          </Col>
        </Row>

        {/* Note */}
        <div className="text-muted mb-3" style={{ fontSize: "0.9rem" }}>
          <strong>Note:</strong>  
           Min Credits must be between <strong>6–9</strong>  
           , Max Credits must be between <strong>15–18</strong>  
           , Preferred Credits should fall between Min and Max  
        </div>

        <Button variant="primary" disabled={!isValid} onClick={handleSave}>
          Save Criteria
        </Button>

        <Button variant="secondary" className="ms-2" onClick={handleReset}>
          Reset
        </Button>
      </Form>
    </div>
  );
};

export default DegreePlanCriteria;
