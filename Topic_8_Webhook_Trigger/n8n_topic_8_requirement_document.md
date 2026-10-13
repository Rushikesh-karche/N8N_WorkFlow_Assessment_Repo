# Requirement Document: N8N Hands-On Beginner Course
## Topic 8: Webhook Trigger

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 8 - Webhook Trigger |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 24, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to teach trainees and employees how to configure the Webhook Trigger node to receive external data and capture incoming HTTP requests. Trainees will learn the difference between Test and Production Webhook URLs, how to activate the listening state in n8n, and how to inspect and process the JSON body payload of incoming requests.

### 2.2 Learning Scope
* **In Scope:**
  * Adding and configuring the Webhook trigger node in the canvas.
  * Setting the HTTP Method parameter to `POST` and the Path parameter to `contact-form`.
  * Locating, copying, and understanding the differences between the Test URL and the Production URL.
  * Activating the node's listening mode in the n8n UI to capture a test payload.
  * Sending a mock JSON payload (containing `name`, `email`, and `message`) and inspecting the received request body.
  * Connecting the Webhook Trigger to a downstream Edit Fields (Set) node named `Process Webhook Data` to map incoming attributes.
* **Out of Scope:**
  * Configuring custom webhook responses (e.g., customized headers, custom response status code, or custom JSON responses).
  * Configuring security authentication methods like Basic Auth, Header Auth, or JWT validation on the Webhook node.
  * Processing raw binary/file uploads (multi-part form data).

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Completed Topic 1 through Topic 7.
* A basic understanding of HTTP methods (specifically GET and POST) and JSON format.
* An external client tool (like curl via command prompt, Postman, or a web-based client) capable of sending HTTP POST requests with a JSON body.

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | Webhook Node Setup | The workflow shall start with a Webhook node configured to receive HTTP POST requests on the path `contact-form`. | High |
| **REQ-002** | URL Differentiator | The workflow configuration shall require the trainee to use the Test URL for development testing and understand that the Production URL requires workflow activation. | High |
| **REQ-003** | Webhook Payload Capture | The Webhook node must successfully capture and display incoming JSON request body variables: `name`, `email`, and `message`. | High |
| **REQ-004** | Data Mapping | A connected downstream Edit Fields (Set) node named `Process Webhook Data` shall map incoming body variables to:<br>• `customerName` (from `body.name`)<br>• `customerEmail` (from `body.email`)<br>• `customerMessage` (from `body.message`). | High |
| **REQ-005** | Payload Cleanup | The Edit Fields node shall exclude all metadata (headers, query, context) and output only the flat mapped JSON keys: `customerName`, `customerEmail`, and `customerMessage`. | High |
| **REQ-006** | Complete Testing | The workflow shall resolve without errors when a test HTTP POST request with valid JSON is sent to the Test URL while n8n is listening. | High |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | Webhook Server Listener | The n8n instance must expose a public or network-accessible endpoint that routes HTTP requests to the appropriate workflow trigger engine. |
| **TR-002** | JSON Parser | The system must automatically parse incoming `application/json` payload bodies, placing them in the `$json.body` namespace. |
| **TR-003** | Editor UI Listener State | The editor UI must support an active listening state (e.g. 120 seconds countdown) that captures and updates the editor's node parameters panel with the structure of the incoming request. |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs to learn how to integrate n8n workflows with external systems (such as third-party form builders, CRM alerts, or custom applications) using standard webhook endpoints. |
| **Instructor / Reviewer** | Evaluation | Needs to verify that the student knows how to set up the correct HTTP method/path, listen for test requests, and reference JSON body variables dynamically. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** The trainee's local n8n instance can receive requests from their command prompt (local environment) or the internet if hosted externally.
* **Assumption 2 (ASM-002):** The test request sent contains a valid JSON payload in the request body with correct keys.
* **Constraint 1 (CON-001):** The Test Webhook URL is only active when the trainee clicks "Listen for test event" and will timeout after 120 seconds if no request is received.
