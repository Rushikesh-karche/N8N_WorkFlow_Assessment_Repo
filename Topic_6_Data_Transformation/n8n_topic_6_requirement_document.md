# Requirement Document: N8N Hands-On Beginner Course
## Topic 6: Data Transformation

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 6 - Data Transformation |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 23, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to teach trainees and employees how to reformat, clean, and map raw data into a structured output schema using core n8n nodes. By the end of this topic, the learner will be able to perform data cleanup tasks such as renaming keys, trimming whitespaces, converting text casing, and normalizing inputs into standardized properties.

### 2.2 Learning Scope
* **In Scope:**
  * Renaming raw incoming data keys to match a standard destination schema.
  * Removing leading and trailing whitespaces from string values using JavaScript's `.trim()` method.
  * Normalizing text casing by converting text to uppercase (using `.toUpperCase()`) and lowercase (using `.toLowerCase()`).
  * Combining field mapping and text manipulation in n8n expressions.
  * Filtering out unnecessary fields by not passing them through the final node.
* **Out of Scope:**
  * Complex data validation rules (e.g., regex-based email syntax checks, phone number format normalization).
  * Working with nested arrays or object flattening techniques.
  * Utilizing third-party scripting libraries for string manipulations.

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Completed Topic 1 through Topic 5.
* Familiarity with basic JavaScript string manipulation functions.
* An active n8n instance.

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | Dirty Mock Data | The workflow shall start with a node configured to output three mock fields representing dirty, unformatted customer data: `Raw_Name` (with leading/trailing spaces and irregular casing), `contact_email` (with spaces and uppercase characters), and `phone_number` (with spaces). | High |
| **REQ-002** | Schema Mapping | The workflow shall map the raw incoming keys to standard keys in the output:<br>• `Raw_Name` shall map to `cleanName`<br>• `contact_email` shall map to `cleanEmail`<br>• `phone_number` shall map to `cleanPhone`. | High |
| **REQ-003** | Whitespace Trimming | The workflow shall strip any leading and trailing whitespaces from all three text strings. | High |
| **REQ-004** | Case Standardization | The workflow shall convert the output name to uppercase and the output email to lowercase. | High |
| **REQ-005** | Final Payload | The final output shall be a single flat JSON object containing only the mapped keys (`cleanName`, `cleanEmail`, and `cleanPhone`), with all unmapped original fields excluded. | High |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | Chained Javascript Methods | The n8n expression parser must support chaining JavaScript string methods (e.g., `.trim().toUpperCase()`) on data fields. |
| **TR-002** | Output Selectivity | The workflow must use an Edit Fields (Set) node configured to not pass all raw inputs through, ensuring only the newly defined clean keys are emitted. |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs to learn data hygiene and payload mapping, which are critical skills when preparing payloads for database updates or API requests. |
| **Instructor / Reviewer** | Evaluation | Needs to verify that the student renamed fields, removed formatting issues, and correctly applied text casing changes dynamically. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** The raw input values are guaranteed to be populated (non-null) strings, avoiding null-pointer expression failures.
* **Constraint 1 (CON-001):** The cleanup rules are statically defined inside the expression panel and do not dynamically inspect field types.
