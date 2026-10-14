# Requirement Document: N8N Hands-On Beginner Course
## Topic 15: Split in Batches & Basic Error Handling

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 15 - Split in Batches & Basic Error Handling |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 25, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to teach trainees and employees how to process multiple records using looping and batches, and handle failures with basic Continue on Fail settings. Trainees will learn how looping operates across multiple items, how the Split in Batches node controls execution flow by dividing arrays into sub-arrays, and how the "Continue on Fail" node setting prevents workflow interruption during network or data validation failures.

### 2.2 Learning Scope
* **In Scope:**
  * Adding and configuring the Split in Batches node to process array data.
  * Setting the Batch Size parameter (e.g. processing 2 items at a time from a list of 5).
  * Implementing a functional n8n loop by routing the processed output of the loop back to the Split in Batches input connector.
  * Enabling the Continue on Fail (or Continue on Fail / OnError: Continue) setting on a downstream node.
  * Simulating a failure on one item (e.g., using a mock URL that fails or invalid data) to verify that the loop continues to process subsequent batches without termination.
* **Out of Scope:**
  * Configuring workflow-wide Error Trigger nodes (which capture overall workflow failures).
  * Configuring complex auto-retry parameters (e.g., Retry on Fail settings with exponential backoffs).
  * Writing custom JavaScript-based loop recursion inside a Code node.

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Completed Topic 1 through Topic 14.
* A firm understanding of JSON arrays, objects, and basic programming loops (e.g., for/while).

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | Split in Batches Node | The workflow shall include a Split in Batches node to split an incoming array of records into defined batch groups. | High |
| **REQ-002** | Batch Size Config | The Split in Batches node shall support configuring a static Batch Size parameter (e.g., 2). | High |
| **REQ-003** | Feedback Loop Hook | The workflow design shall implement a loop routing the output of the batch-processing nodes back to the input port of the Split in Batches node to pull the next batch. | High |
| **REQ-004** | Completion Branch | The Split in Batches node shall route execution to a separate "Done" output path when all batches are processed. | High |
| **REQ-005** | Continue on Fail Setup | The workflow shall configure the Continue on Fail setting on a node inside the loop (e.g., an HTTP Request node calling a mock URL). | High |
| **REQ-006** | Error Tolerance | If the configured node inside the loop fails for a specific batch item, the workflow shall not stop, but rather execute the next node in the loop sequence, returning the error details in the node payload. | High |
| **REQ-007** | Complete Loop Execution | The workflow shall process all mock items in batches, survive any individual node failure, and complete with a success output status. | High |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | Batch Pointer State | The n8n execution context must track the current batch offset/index internally and return only the subset of items for the active iteration. |
| **TR-002** | Exception Catching | When Continue on Fail is enabled, the runtime must catch execution exceptions, wrap them inside a JSON error property structure, and return success indicators to downstream nodes. |
| **TR-003** | Loop Recursion Safety | The system must prevent memory overflows and run with standard loop termination checks to prevent infinite loops. |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs to learn how to batch large datasets (e.g. avoiding API rate limits) and build resilient workflows that do not crash on single-item failures. |
| **Instructor / Reviewer** | Evaluation | Needs to verify that the student knows how to connect a feedback loop, configure batch size, and enable error resilience options. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** The input mock data list is long enough to span multiple batches (at least 4 items for a batch size of 2).
* **Assumption 2 (ASM-002):** At least one item in the list will cause an error on the downstream processing node to test the Continue on Fail logic.
* **Constraint 1 (CON-001):** Infinite loops will occur if the feedback connection goes back to the manual trigger or a node preceding the Split in Batches node; it must loop back to the Split in Batches node itself.
