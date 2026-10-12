# Requirement Document: N8N Hands-On Beginner Course
## Topic 3: Working with Core Nodes & Data Mapping

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 3 - Working with Core Nodes & Data Mapping |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 20, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to teach trainees/employees how to use the Edit Fields (Set) node to define new fields, modify existing values, assign specific data types (string, number, boolean), and map values dynamically from preceding nodes using expressions.

### 2.2 Learning Scope
* **In Scope:**
  * Adding fields of various types (String, Number, Boolean) to a workflow payload.
  * Editing/overwriting values of pre-existing fields within the data stream.
  * Using the n8n expression editor (`{{ ... }}`) to reference parent node output variables.
  * Mapping a value from an input field to create a new output field.
* **Out of Scope:**
  * Complex JavaScript operations or loops within the expression block.
  * Manipulating nested JSON arrays or objects.
  * Data formatting functions (dates, timezone conversion, string splits).

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Completed Topic 1 and Topic 2.
* Understanding of basic JSON structure (keys and values).
* Understanding of standard data types (String, Number, Boolean).

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | Create Initial Data | The workflow shall start with a node configured to output three distinct data fields representing a product: a string, a number, and a boolean. | High |
| **REQ-002** | Data Types | The initial fields shall be strictly typed inside the first node:<br>• `productName` (String)<br>• `basePrice` (Number)<br>• `isAvailable` (Boolean). | High |
| **REQ-003** | Modify Data | A second connected node shall modify the value of the incoming `isAvailable` boolean field from `true` to `false`. | High |
| **REQ-004** | Variable Mapping | The second node shall create a new field named `inventoryLabel` and populate it by dynamically mapping the value of the incoming `productName` field. | High |
| **REQ-005** | Calculated Field | The second node shall create a new field named `priceWithTax` that calculates 10% tax on top of the incoming `basePrice` (using an expression: `basePrice * 1.1`). | High |
| **REQ-006** | Schema Verification | The final workflow execution shall output a single JSON object containing: `productName`, `basePrice`, `isAvailable`, `inventoryLabel`, and `priceWithTax`. | High |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | Expression Engine | The n8n expression parser must resolve variables in real time using the format: `{{ $json.fieldName }}`. |
| **TR-002** | Node Selection | The workflow shall use the Edit Fields (Set) node or the Set node depending on the n8n version, but using the same basic parameter schema. |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs to learn how data typing and dynamic referencing works so they can construct functional business workflows. |
| **Instructor / Reviewer** | Evaluation | Needs to confirm the trainee hasn't hardcoded mapped values and has instead used dynamic expressions correctly. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** Trainees understand that expression calculations (e.g. math operations) must be wrapped in `{{ }}` curly braces to evaluate in n8n.
* **Constraint 1 (CON-001):** The calculations in this beginner exercise are basic mathematics and do not account for floating-point rounding corrections.
