# Requirement Document: N8N Hands-On Beginner Course
## Topic 1: Create Your First Workflow

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 1 - Create Your First Workflow |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 20, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to guide trainees and employees through their first hands-on experience in n8n. By the end of this topic, the learner will understand the fundamental mechanics of n8n: starting a workflow, using trigger nodes, connecting actions, viewing data, and saving work.

### 2.2 Learning Scope
* **In Scope:**
  * Accessing the n8n editor interface.
  * Adding and configuring the Manual Trigger node.
  * Adding a basic action node (e.g., Edit Fields / Set node) to produce an output payload.
  * Connecting nodes together.
  * Executing the workflow manually.
  * Viewing input and output data in the schema panel.
  * Naming, saving, and organizing the workflow.
* **Out of Scope:**
  * Complex event triggers (Webhooks, Schedules, Web Scrapers).
  * JavaScript code execution within nodes.
  * Credential management and external service integrations (Slack, Google Sheets, databases).

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Access to an active n8n instance (n8n Cloud, self-hosted, or local Desktop app).
* A compatible web browser (Chrome, Firefox, Edge, Safari) with access to the n8n Editor UI.
* Basic computer literacy (mouse dragging, keyboard inputs).

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | Editor Access | The environment shall allow the trainee to open a blank workflow canvas in n8n. | High |
| **REQ-002** | Trigger Node | The workflow shall start with a Manual Trigger node to allow manual testing. | High |
| **REQ-003** | Action Node | The workflow shall contain a data-producing node (specifically the Edit Fields / Set node) to output a static text message. | High |
| **REQ-004** | Node Connection | The Manual Trigger node shall be connected to the Edit Fields (Set) node, indicating data flows from left to right. | High |
| **REQ-005** | Configuration | The Edit Fields (Set) node shall be configured with a parameter named `greeting` containing the value `"Hello, n8n!"`. | High |
| **REQ-006** | Execution | The system shall successfully execute the workflow when the trainee clicks the "Test workflow" button. | High |
| **REQ-007** | Output View | The trainee shall be able to inspect the execution results and see the JSON output structure containing the `greeting` parameter. | High |
| **REQ-008** | Naming & Save | The trainee shall name the workflow "My First N8N Workflow" and save it in the database. | Medium |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | n8n Version | The system should run n8n version 1.0.0 or higher to ensure compatibility with the updated Edit Fields node interface. |
| **TR-002** | Network Access | No external API access is required for this beginner exercise. The workflow must execute locally inside the n8n sandbox. |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs a clear, frictionless layout to learn node mechanics and visual debugging. |
| **Instructor / Reviewer** | Evaluation | Needs to easily check if the trainee named, saved, and executed the workflow correctly. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** Trainees have read-only or creator permissions on the n8n instance to save and edit workflows.
* **Constraint 1 (CON-001):** The user's screen resolution should be at least 1280×720 to comfortably use the node editor sidebar.