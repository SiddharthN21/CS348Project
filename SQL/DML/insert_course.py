import json

# ---------------------------------------------------------
# DATASET: CS courses (real data you already provided earlier)
# ---------------------------------------------------------
cs_courses = [
    # Example structure — the full list will be inserted here
    # {
    #     "subject": "CS",
    #     "number": "18000",
    #     "title": "Problem Solving and Object-Oriented Programming",
    #     "min_credit": 4,
    #     "max_credit": 4,
    #     "description": "Introduction to programming using objects...",
    #     "level": 10000
    # },
]

# ---------------------------------------------------------
# DATASET: Non-CS required courses (placeholder entries)
# ---------------------------------------------------------
all_required_courses = [

    # ============================
    # CS COURSES (real values)
    # ============================

    {"subject": "CS", "number": "18000", "title": "Problem Solving and Object-Oriented Programming",
     "min_credit": 4, "max_credit": 4, "is_variable_credit": 0,
     "description_summary": "Intro to programming using objects and problem solving.",
     "department": "CS", "level": 10000},

    {"subject": "CS", "number": "18200", "title": "Foundations of Computer Science",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Discrete math foundations for CS.",
     "department": "CS", "level": 10000},

    {"subject": "CS", "number": "24000", "title": "Programming in C",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "C programming, pointers, memory, and systems concepts.",
     "department": "CS", "level": 20000},

    {"subject": "CS", "number": "25000", "title": "Computer Architecture",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Machine organization, CPU design, memory hierarchy.",
     "department": "CS", "level": 20000},

    {"subject": "CS", "number": "25100", "title": "Data Structures and Algorithms",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Data structures, algorithm analysis, recursion.",
     "department": "CS", "level": 20000},

    {"subject": "CS", "number": "25200", "title": "Systems Programming",
     "min_credit": 4, "max_credit": 4, "is_variable_credit": 0,
     "description_summary": "Systems programming, processes, memory, concurrency.",
     "department": "CS", "level": 20000},

    # 30000-level
    {"subject": "CS", "number": "30700", "title": "Software Engineering I",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Software engineering principles and design.",
     "department": "CS", "level": 30000},

    {"subject": "CS", "number": "31400", "title": "Numerical Methods",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Numerical computation and approximation techniques.",
     "department": "CS", "level": 30000},

    {"subject": "CS", "number": "33400", "title": "Fundamentals of Computer Graphics",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Rendering, transformations, graphics pipeline.",
     "department": "CS", "level": 30000},

    {"subject": "CS", "number": "34800", "title": "Information Systems",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Enterprise information systems and data management.",
     "department": "CS", "level": 30000},

    {"subject": "CS", "number": "35200", "title": "Compilers: Principles and Practice",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Compiler design, parsing, code generation.",
     "department": "CS", "level": 30000},

    {"subject": "CS", "number": "35300", "title": "Principles of Concurrency and Parallelism",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Parallel programming and concurrency models.",
     "department": "CS", "level": 30000},

    {"subject": "CS", "number": "35400", "title": "Operating Systems",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "OS design, scheduling, memory, file systems.",
     "department": "CS", "level": 30000},

    {"subject": "CS", "number": "35500", "title": "Introduction to Cryptography",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Cryptographic primitives and security models.",
     "department": "CS", "level": 30000},

    {"subject": "CS", "number": "37300", "title": "Data Mining and Machine Learning",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "ML algorithms, classification, clustering.",
     "department": "CS", "level": 30000},

    {"subject": "CS", "number": "38100", "title": "Introduction to the Analysis of Algorithms",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Algorithm complexity and design techniques.",
     "department": "CS", "level": 30000},

    # 40000-level
    {"subject": "CS", "number": "40800", "title": "Software Engineering II",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Advanced software engineering and project work.",
     "department": "CS", "level": 40000},

    {"subject": "CS", "number": "42200", "title": "Computer Networks",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Networking protocols, routing, transport.",
     "department": "CS", "level": 40000},

    {"subject": "CS", "number": "42600", "title": "Computer Security",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Security principles, vulnerabilities, defenses.",
     "department": "CS", "level": 40000},

    {"subject": "CS", "number": "44000", "title": "Introduction to Artificial Intelligence",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "AI fundamentals, search, reasoning, learning.",
     "department": "CS", "level": 40000},

    {"subject": "CS", "number": "44800", "title": "Introduction to Relational Database Systems",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Database design, SQL, relational theory.",
     "department": "CS", "level": 40000},

    {"subject": "CS", "number": "45600", "title": "Programming Languages",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "PL paradigms, semantics, interpreters.",
     "department": "CS", "level": 40000},

    {"subject": "CS", "number": "47100", "title": "Introduction to Digital Design",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Digital logic and hardware design.",
     "department": "CS", "level": 40000},

    {"subject": "CS", "number": "47300", "title": "Web Information Systems",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Web architectures, backend systems.",
     "department": "CS", "level": 40000},

    {"subject": "CS", "number": "47500", "title": "Human-Computer Interaction",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "HCI principles, usability, interaction design.",
     "department": "CS", "level": 40000},

    {"subject": "CS", "number": "47800", "title": "Introduction to Bioinformatics",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Bioinformatics algorithms and applications.",
     "department": "CS", "level": 40000},

    {"subject": "CS", "number": "48300", "title": "Theory of Computation",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Automata, languages, Turing machines, complexity.",
     "department": "CS", "level": 40000},

    {"subject": "CS", "number": "48900", "title": "Embedded Systems",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "Embedded programming, hardware interfaces.",
     "department": "CS", "level": 40000},

    {"subject": "CS", "number": "49000", "title": "Special Topics in Computer Science",
     "min_credit": 1, "max_credit": 3, "is_variable_credit": 1,
     "description_summary": "Variable topics in CS.",
     "department": "CS", "level": 40000},

    # ============================
    # NON-CS COURSES (placeholders)
    # ============================

    {"subject": "MA", "number": "16100", "title": "Plane Analytic Geometry And Calculus I",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "MA", "level": 10000},

    {"subject": "MA", "number": "16200", "title": "Plane Analytic Geometry And Calculus II",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "MA", "level": 10000},

    {"subject": "MA", "number": "26100", "title": "Multivariate Calculus",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "MA", "level": 20000},

    {"subject": "MA", "number": "26500", "title": "Linear Algebra",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "MA", "level": 20000},

    {"subject": "MA", "number": "35100", "title": "Elementary Linear Algebra",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "MA", "level": 30000},

    {"subject": "MA", "number": "35300", "title": "Linear Algebra II",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "MA", "level": 30000},

    {"subject": "STAT", "number": "35000", "title": "Introduction To Statistics",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "STAT", "level": 30000},

    {"subject": "STAT", "number": "35500", "title": "Statistics For Data Science",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "STAT", "level": 30000},

    {"subject": "PHYS", "number": "17200", "title": "Modern Mechanics",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "PHYS", "level": 10000},

    {"subject": "PHYS", "number": "27200", "title": "Electricity And Optics",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "PHYS", "level": 20000},

    {"subject": "ENGL", "number": "10600", "title": "First-Year Composition",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "ENGL", "level": 10000},

    {"subject": "COM", "number": "11400", "title": "Fundamentals Of Speech Communication",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "COM", "level": 10000},

    {"subject": "BIOL", "number": "11000", "title": "Fundamentals Of Biology I",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "BIOL", "level": 10000},

    {"subject": "CHM", "number": "11500", "title": "General Chemistry I",
     "min_credit": 3, "max_credit": 3, "is_variable_credit": 0,
     "description_summary": "To be extracted", "department": "CHM", "level": 10000},
]

# ---------------------------------------------------------
# Helper: Determine level from course number
# ---------------------------------------------------------
def determine_level(course_number):
    try:
        n = int(course_number)
        return (n // 10000) * 10000
    except:
        return 0

# ---------------------------------------------------------
# Helper: Determine credits (placeholder for non-CS)
# ---------------------------------------------------------
def placeholder_credit():
    return 3, 3, False  # min_credit, max_credit, is_variable_credit

# ---------------------------------------------------------
# SQL GENERATION
# ---------------------------------------------------------
def generate_sql():
    lines = []

    # -----------------------------
    # CS COURSES (real data)
    # -----------------------------
    for c in cs_courses:
        subject = c["subject"]
        number = c["number"]
        title = c["title"]
        min_credit = c["min_credit"]
        max_credit = c["max_credit"]
        is_var = 1 if min_credit != max_credit else 0
        description = c["description"].replace("'", "\\'")
        department = subject
        level = c["level"]

        sql = f"""
INSERT INTO course (
    subject_code,
    course_number,
    title,
    min_credit,
    max_credit,
    is_variable_credit,
    description_summary,
    department,
    level
)
VALUES (
    '{subject}',
    '{number}',
    '{title.replace("'", "\\'")}',
    {min_credit},
    {max_credit},
    {is_var},
    '{description}',
    '{department}',
    {level}
);
"""
        lines.append(sql)

    # -----------------------------
    # NON-CS COURSES (placeholder)
    # -----------------------------
    for c in all_required_courses:
        subject = c["subject"]
        number = c["number"]
        title = c["title"]
        min_credit, max_credit, is_var = placeholder_credit()
        description = "To be extracted"
        department = subject
        level = determine_level(number)

        sql = f"""
INSERT INTO course (
    subject_code,
    course_number,
    title,
    min_credit,
    max_credit,
    is_variable_credit,
    description_summary,
    department,
    level
)
VALUES (
    '{subject}',
    '{number}',
    '{title.replace("'", "\\'")}',
    {min_credit},
    {max_credit},
    {1 if is_var else 0},
    '{description}',
    '{department}',
    {level}
);
"""
        lines.append(sql)

    return "".join(lines)

# ---------------------------------------------------------
# WRITE OUTPUT FILE
# ---------------------------------------------------------
output = generate_sql()

with open("course.sql", "w") as f:
    f.write(output)

print("Generated course.sql successfully.")