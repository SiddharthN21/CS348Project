import json

# ---------------------------------------------------------
# CONFIG: All prerequisite data goes here
# ---------------------------------------------------------

prereqs = {
    "CS 18200": [
        {"expr": {"AND": ["CS 18000", "MA 16100"]}, "external": False, "concurrent": False, "notes": "", "grade": "C"}
    ],
    "CS 24000": [
        {"expr": {"course": "CS 18000"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}
    ],
    "CS 25000": [
        {"expr": {"AND": ["CS 18200", "CS 24000"]}, "external": False, "concurrent": False, "notes": "", "grade": "C"}
    ],
    "CS 25100": [
        {"expr": {"AND": ["CS 18200", "CS 24000"]}, "external": False, "concurrent": False, "notes": "", "grade": "C"}
    ],
    "CS 25200": [
        {"expr": {"AND": ["CS 25000", "CS 25100"]}, "external": False, "concurrent": False, "notes": "", "grade": "C"}
    ],

    # ---------------------------------------------------------
    # Upper-level CS courses (internal prereqs only)
    # ---------------------------------------------------------
    "CS 30700": [{"expr": {"course": "CS 25200"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 34800": [{"expr": {"course": "CS 25200"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 35100": [{"expr": {"course": "CS 25100"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 35200": [{"expr": {"course": "CS 25100"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 35300": [{"expr": {"course": "CS 35100"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 35400": [{"expr": {"course": "CS 25100"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 37300": [{"expr": {"course": "CS 25200"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 40800": [{"expr": {"course": "CS 25200"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 43900": [{"expr": {"course": "CS 25200"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 44800": [{"expr": {"course": "CS 25200"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 45600": [{"expr": {"course": "CS 35100"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 45800": [{"expr": {"course": "CS 25200"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 47100": [{"expr": {"course": "CS 25200"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 47300": [{"expr": {"course": "CS 25200"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 47500": [{"expr": {"course": "CS 25200"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 48300": [{"expr": {"course": "CS 38100"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 48900": [{"expr": {"course": "CS 25100"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],
    "CS 43400": [{"expr": {"course": "CS 33400"}, "external": False, "concurrent": False, "notes": "", "grade": "C"}],

    # ---------------------------------------------------------
    # Starred courses with placeholder external prereqs
    # ---------------------------------------------------------
    "CS 31400": [
        {"expr": {"course": "MA 26500"}, "external": True, "concurrent": False, "notes": "External prereq (Math)", "grade": "C"},
        {"expr": {"course": "To Be Identified"}, "external": True, "concurrent": False, "notes": "External prereq placeholder", "grade": "C"}
    ],
    "CS 35500": [
        {"expr": {"course": "CS 25100"}, "external": False, "concurrent": False, "notes": "", "grade": "C"},
        {"expr": {"course": "To Be Identified"}, "external": True, "concurrent": False, "notes": "External prereq placeholder", "grade": "C"}
    ],
    "CS 38100": [
        {"expr": {"course": "CS 25100"}, "external": False, "concurrent": False, "notes": "", "grade": "C"},
        {"expr": {"course": "To Be Identified"}, "external": True, "concurrent": False, "notes": "External prereq placeholder", "grade": "C"}
    ],
    "CS 44000": [
        {"expr": {"course": "CS 37300"}, "external": False, "concurrent": False, "notes": "", "grade": "C"},
        {"expr": {"course": "To Be Identified"}, "external": True, "concurrent": False, "notes": "External prereq placeholder", "grade": "C"}
    ],
    "CS 47800": [
        {"expr": {"course": "CS 25200"}, "external": False, "concurrent": False, "notes": "", "grade": "C"},
        {"expr": {"course": "To Be Identified"}, "external": True, "concurrent": False, "notes": "External prereq placeholder", "grade": "C"}
    ]
}

# ---------------------------------------------------------
# SQL GENERATION
# ---------------------------------------------------------

def sql_escape_json(obj):
    return json.dumps(obj).replace("'", "\\'")


def generate_sql():
    lines = []

    for course, prereq_list in prereqs.items():
        subject, number = course.split()

        for p in prereq_list:
            expr = sql_escape_json(p["expr"])
            grade = p["grade"]
            concurrent = "TRUE" if p["concurrent"] else "FALSE"
            external = "TRUE" if p["external"] else "FALSE"
            notes = p["notes"].replace("'", "\\'")

            sql = f"""
INSERT INTO course_prerequisite (
    course_id,
    expression_json,
    min_grade,
    is_concurrent_allowed,
    is_external_prereq,
    notes
)
VALUES (
    (SELECT course_id FROM course WHERE subject_code='{subject}' AND course_number='{number}'),
    '{expr}',
    '{grade}',
    {concurrent},
    {external},
    '{notes}'
);
"""
            lines.append(sql)

    return "".join(lines)


# ---------------------------------------------------------
# WRITE OUTPUT FILE
# ---------------------------------------------------------

output = generate_sql()

with open("course_prerequisites.sql", "w") as f:
    f.write(output)

print("Generated course_prerequisites.sql successfully.")