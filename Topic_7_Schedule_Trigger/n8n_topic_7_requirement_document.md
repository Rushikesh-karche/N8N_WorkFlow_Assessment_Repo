# Requirement Document: N8N Hands-On Beginner Course
## Topic 7: Schedule Trigger

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 7 - Schedule Trigger |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 24, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to teach trainees and employees how to use the Schedule Trigger node to run workflows automatically using time-based intervals and custom cron expressions. Trainees will learn the basics of cron syntax and configure multiple schedule rules within a single trigger node.

### 2.2 Learning Scope
* **In Scope:**
  * Adding and configuring the Schedule Trigger node within a workflow.
  * Setting up simple daily intervals at a specific time (e.g., 09:00 AM).
  * Writing and explaining custom cron expressions (e.g., triggering weekdays at 8:30 AM).
  * Understanding the standard 5-field cron syntax format (minute hour day-of-month month day-of-week).
  * Connecting the trigger to a downstream action node (Edit Fields) to capture and log execution timestamps.
* **Out of Scope:**
  * Configuring timezone adjustments dynamically per-execution (using external timezone APIs).
  * Triggering external events via Webhooks or Polling nodes (covered in separate modules).
  * Configuring complex error-handling or retry policies on schedule failures.

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Completed Topic 1 through Topic 6.
* A basic understanding of time representation (hours, minutes, days of the week).
* An active n8n instance with workspace edit and testing permissions.

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | Simple Daily Interval | The workflow shall trigger automatically on a daily basis at a specific hour and minute (e.g., daily at 09:00 AM). | High |
| **REQ-002** | Custom Cron Schedule | The workflow shall trigger automatically on a custom schedule representing weekdays (Monday through Friday) at a specific time (e.g., 08:30 AM). | High |
| **REQ-003** | Cron Syntax Mapping | The custom schedule must use a standard 5-field cron expression equivalent to `30 8 * * 1-5` (representing minute 30, hour 8, every day of month, every month, days 1 to 5 / Mon-Fri). | High |
| **REQ-004** | Downstream Logger | The Schedule Trigger node shall connect to an Edit Fields (Set) node named Log Execution to record each automatic execution. | High |
| **REQ-005** | Execution Timestamp | The Log Execution node shall output a single dynamic string property `executionTime` containing the timestamp of when the trigger fired using n8n expression syntax referencing the current date and time. | High |
| **REQ-006** | Workflow Activation | The finished workflow must be capable of being toggled to Active to run automatically in the background according to the defined schedules. | Medium |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | Cron Execution Engine | The underlying n8n instance scheduler must parse the standard 5-field cron expression syntax in real-time. |
| **TR-002** | Multiple Schedule Rules | The Schedule Trigger node must support configuring multiple schedule rules (e.g., a simple daily rule and a custom cron rule) within the same node's configuration parameters. |
| **TR-003** | Dynamic Variable Reference | The workflow expressions engine must resolve the dynamic `$now` or `$dateTime` helper variables to format the output execution timestamp. |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs to understand how to schedule workflows automatically to replace manual routines, a critical skill for business process automation. |
| **Instructor / Reviewer** | Evaluation | Needs to verify that the student understands basic cron fields and has configured both simple and custom cron triggers in the Schedule Trigger node. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** The n8n instance's system timezone is configured correctly, ensuring the time-based triggers fire at the trainee's expected local time.
* **Assumption 2 (ASM-002):** The workflow is saved and active to ensure background schedule triggers are evaluated by n8n.
* **Constraint 1 (CON-001):** The execution resolution is subject to the cron engine's precision, which operates on a minimum granularity of minutes.
