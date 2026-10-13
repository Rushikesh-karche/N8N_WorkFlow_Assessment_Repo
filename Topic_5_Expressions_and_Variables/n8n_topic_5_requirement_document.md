# Requirement Document: N8N Hands-On Beginner Course
## Topic 5: Expressions & Variables

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 5 - Expressions & Variables |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 23, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to teach trainees and employees how to use n8n expressions to reference data dynamically, combine strings, change text casing, and format dates using the built-in Luxon date functions.

### 2.2 Learning Scope
* **In Scope:**
  * Referencing variables dynamically from parent nodes using n8n's `{{ ... }}` expression syntax.
  * Combining multiple string fields together (concatenation) with custom separators.
  * Performing basic text casing operations such as converting text to uppercase (using `.toUpperCase()`).
  * Working with dates by parsing ISO-formatted date strings using n8n's built-in `$dateTime` helper.
  * Formatting dates into human-readable representations using the `.toFormat()` syntax.
  * Accessing the current date/time dynamically using the global `$now` variable.
* **Out of Scope:**
  * Advanced JavaScript string regex matching or complex string splitting/slicing logic.
  * Complex date calculations like business days difference or calendar conversions.
  * Installing external NPM modules or configuring custom scripting runtimes.

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Completed Topic 1 through Topic 4.
* Familiarity with basic JavaScript syntax (variables, operations, method calls).
* Access to an active n8n editor session with expressions capabilities.

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | Input Setup | The workflow shall start with a node configured to output three mock data fields: `firstName` (all lowercase), `lastName` (all lowercase), and `birthDate` (an ISO date-time string). | High |
| **REQ-002** | Concatenation & Case | The workflow shall combine the `firstName` and `lastName` fields separated by a space and convert the result entirely to uppercase, mapped to `fullNameUpperCase`. | High |
| **REQ-003** | Date Formatting | The workflow shall parse the input `birthDate` ISO string and format it into `MMMM dd, yyyy` (e.g. "April 12, 1998"), mapped to `formattedBirthDate`. | High |
| **REQ-004** | Current Date | The workflow shall dynamically retrieve the current date/time using n8n's date variables and format it as `yyyy-MM-dd`, mapped to `processedDate`. | High |
| **REQ-005** | Output Structure | The final workflow execution shall output a single JSON object containing exactly these fields: `fullNameUpperCase`, `formattedBirthDate`, and `processedDate`. | High |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | Date Library (Luxon) | The system must support the Luxon-based datetime helper objects (`$dateTime` and `$now`) within expressions to format date strings. |
| **TR-002** | Expression Evaluation | The expressions engine must evaluate JavaScript string operations like `.toUpperCase()` and standard string concatenation (using `+` operator or template literals) in real time. |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs to learn how to clean, format, and prepare text and date fields dynamically when passing payloads between systems. |
| **Instructor / Reviewer** | Evaluation | Needs to confirm the student can write functional expressions and format values dynamically without hardcoding static values. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** The trainee's n8n environment has standard configuration options enabled to resolve timezone expressions relative to UTC or the system locale.
* **Constraint 1 (CON-001):** Date formatting options are constrained to the supported tokens in Luxon's `toFormat` syntax.
