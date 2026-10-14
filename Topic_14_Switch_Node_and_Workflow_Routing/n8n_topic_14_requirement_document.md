# Requirement Document: N8N Hands-On Beginner Course
## Topic 14: Switch Node & Workflow Routing

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 14 - Switch Node & Workflow Routing |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 25, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to teach trainees and employees how to use the Switch node to route items down different paths based on multiple conditions. Trainees will learn how to configure multiple output branches, understand how rules are checked in sequential order, and configure a default branch for items that do not match any rule.

### 2.2 Learning Scope
* **In Scope:**
  * Adding and configuring the Switch node in the n8n canvas.
  * Configuring the node to read a dynamic value via expression (e.g., `{{ $json.role }}`).
  * Setting up multiple rule branches (e.g., admin, editor, viewer) using string or numeric comparison operators.
  * Setting up a Default fallback branch for non-matching inputs.
  * Connecting different downstream nodes (e.g., Edit Fields nodes) to each output branch to handle items differently.
  * Testing the workflow with multiple items to verify multi-way branching.
* **Out of Scope:**
  * Writing custom JavaScript switch-statement routines inside a Code node (we will focus on the UI configuration of the Switch node).
  * Dynamic generation of output branches based on API response payloads at runtime.

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Completed Topic 1 through Topic 13.
* A solid understanding of basic comparison logic (such as string equals) and true/false branching (IF node).

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | Switch Node Integration | The workflow shall include a Switch node to route records along multiple distinct branches based on property matching. | High |
| **REQ-002** | Multi-Branch Rule Config | The Switch node shall support defining multiple specific comparison rules (e.g., Rule 0: admin, Rule 1: editor, Rule 2: viewer). | High |
| **REQ-003** | Default Fallback Rule | The Switch node shall support a default/fallback condition routing items to a designated output if no other rules match. | High |
| **REQ-004** | Sequential Ordering | The Switch node shall evaluate rules in sequential order (top to bottom). | High |
| **REQ-005** | Dynamic Expression Input | The Switch node value parameter shall dynamically retrieve an input item's property using expressions (e.g., `{{ $json.role }}`). | High |
| **REQ-006** | Complete Routing Map | The workflow shall route outputs to four distinct downstream Edit Fields nodes matching the roles:<br>• Set Admin Status (Branch 0)<br>• Set Editor Status (Branch 1)<br>• Set Viewer Status (Branch 2)<br>• Set Guest Status (Default Fallback Branch 3). | High |
| **REQ-007** | Multi-Item Processing | The workflow shall process multiple items simultaneously and route each profile to its correct role branch. | High |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | Index-Based Branch Routing | The n8n compiler must translate each rule into an index-based output connector port, routing the item exactly through the port index that matched the rule condition. |
| **TR-002** | Dynamic Array Partitioning | The Switch node must process an input array of multiple JSON items and partition them into distinct output arrays corresponding to the matched rules. |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs to learn how to implement clean multi-path workflows without nesting multiple IF nodes, which is complex and difficult to maintain. |
| **Instructor / Reviewer** | Evaluation | Needs to verify that the student correctly configures the Switch node rules, sets the default branch, and links the downstream actions. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** The input mock data contains a field (e.g., role) that maps to one of the defined rules or acts as a fallback.
* **Constraint 1 (CON-001):** Once the Switch node output count is set, it is static; adding rules requires updating the node settings and re-connecting the paths.
