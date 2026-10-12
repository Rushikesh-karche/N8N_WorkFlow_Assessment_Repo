# Requirement Document: N8N Hands-On Beginner Course
## Topic 2: Understanding Workflow Execution & Debugging Basics

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 2 - Understanding Workflow Execution |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 20, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to teach trainees/employees how data moves through a workflow, how to inspect what enters and leaves any given node, and how to identify and debug errors using visual cues, execution history logs, and step-by-step executions.

### 2.2 Learning Scope
* **In Scope:**
  * Inspecting the input data and output data panels of active nodes.
  * Simulating a node-level failure using a basic node (e.g., an HTTP Request node configured with an invalid URL).
  * Identifying visual indicators for succeeded vs failed nodes (green vs red icons/outlines).
  * Performing step-by-step testing on individual nodes ("Test step").
  * Navigating and reading the n8n Executions history dashboard.
* **Out of Scope:**
  * Advanced error recovery methods (e.g., Error Trigger nodes, "Continue on Fail" routing, Try/Catch blocks).
  * Writing code to handle error exceptions.
  * Debugging external server/infrastructure crashes.

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Completed Topic 1: Create Your First Workflow.
* An active n8n editor session.
* Access to the left-hand sidebar navigation (specifically the Executions tab).

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | Input/Output Inspection | The trainee shall be able to open any node's configuration panel and toggle between the Input and Output tabs to inspect data schemas. | High |
| **REQ-002** | Error Simulation | The workflow shall include a node configured to fail intentionally (e.g., an HTTP Request node pointed to a non-existent URL: `https://this-domain-does-not-exist-12345.com`). | High |
| **REQ-003** | Visual Diagnostics | The system UI shall highlight the failed node in red with a status label stating "Error" or "Failed" after workflow execution. | High |
| **REQ-004** | Error Data Review | The trainee shall be able to click on the failed node and view the JSON format of the error message under the Output panel. | High |
| **REQ-005** | Single Step Execution | The editor shall allow executing a single node individually (clicking "Test step") without executing the entire workflow from the trigger. | High |
| **REQ-006** | Historical Logs | The system shall register every test execution in the Executions sidebar page, listing the execution status, date/time, and duration. | High |
| **REQ-007** | Log Inspection | The trainee shall be able to click on a past execution from the history log to inspect the inputs, outputs, and status of that specific run. | Medium |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | Network Connection | The n8n instance must have network access (or simulated DNS failure) to verify connection timeout/invalid DNS errors on the HTTP request node. |
| **TR-002** | Execution Save Settings | Ensure "Save execution progress" settings are enabled in n8n configuration so test runs are stored in the execution logs. |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs to learn how to identify where a workflow breaks so they can fix bugs independently. |
| **Instructor / Reviewer** | Evaluation | Needs to verify that the student knows how to navigate historical execution logs and inspect nested JSON data payloads. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** The n8n instance configuration defaults to saving test runs in the local execution database.
* **Constraint 1 (CON-001):** Historical execution logs might be automatically pruned after 24-48 hours depending on database storage.
