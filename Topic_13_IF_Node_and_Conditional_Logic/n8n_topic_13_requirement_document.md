# Requirement Document: N8N Hands-On Beginner Course
## Topic 13: IF Node & Conditional Logic

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 13 - IF Node & Conditional Logic |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 25, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to teach trainees and employees how to use the IF node to filter and route items based on conditions for decision making. Trainees will learn the comparison operators (e.g., equals, greater than, contains) available in the IF node, how to select the correct operator based on field types (String, Number, Boolean), and how to connect downstream nodes to the True and False output branches.

### 2.2 Learning Scope
* **In Scope:**
  * Adding and configuring the IF node in the n8n canvas.
  * Configuring comparison conditions using dynamic expressions (e.g., checking if `{{ $json.orderValue }}` is greater than or equal to 100).
  * Selecting correct comparison types (String vs. Number vs. Boolean).
  * Routing items to either the True or False output paths based on condition evaluation.
  * Connecting different downstream nodes (e.g., Edit Fields node) to the True and False outputs to verify branch routing.
* **Out of Scope:**
  * Configuring multi-conditional routes with complex logical AND/OR groups or nesting multiple IF nodes recursively (focus is on basic single-condition comparison).
  * Using the Switch node (which handles multi-value routing).
  * Writing custom JavaScript functions inside a Code node to evaluate conditions.

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Completed Topic 1 through Topic 12.
* A basic understanding of comparison logic (greater than, equals, contains) and true/false branching.

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | IF Node Integration | The workflow shall include an IF node to split data routing. | High |
| **REQ-002** | Operator Configuration | The IF node shall support configuring basic comparison operators (e.g., Number: Greater Than or Equal To) for a specified input field. | High |
| **REQ-003** | Expression Comparison | The condition input shall support dynamic expressions (e.g., `{{ $json.orderValue }}`) referencing preceding node properties. | High |
| **REQ-004** | True Branch Routing | Items matching the condition (e.g., orderValue &gt;= 100) shall be output through the true branch. | High |
| **REQ-005** | False Branch Routing | Items not matching the condition (e.g., orderValue &lt; 100) shall be output through the false branch. | High |
| **REQ-006** | Complete Branch Mapping | The workflow shall route outputs to two distinct downstream Edit Fields nodes:<br>• Set VIP Status connected to the True branch<br>• Set Regular Status connected to the False branch. | High |
| **REQ-007** | Sequential Execution | The workflow shall run successfully for different input test data, routing items to the correct branch without errors. | High |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | Dynamic Data Type Coercion | The IF node must coerce string values representing numbers into actual numeric types when using numeric operators (like Greater Than) to prevent alphabetical sort comparison errors. |
| **TR-002** | Item-by-Item Evaluation | The n8n router must evaluate the condition independently for each item in the input JSON array, splitting the items into two separate output arrays (true and false arrays). |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs to understand how to add logic gates to workflows to filter noise, handle exceptions, or perform different actions based on incoming data attributes. |
| **Instructor / Reviewer** | Evaluation | Needs to verify that the trainee configured comparison operators, mapped the parameters dynamically, and connected/designed the true/false paths. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** The trainee's input mock data contains a field (e.g., orderValue or amount) that can be evaluated.
* **Constraint 1 (CON-001):** The IF node has two hard-coded branches (True and False); complex multi-routing requires either multiple IF nodes in sequence or a Switch node.
