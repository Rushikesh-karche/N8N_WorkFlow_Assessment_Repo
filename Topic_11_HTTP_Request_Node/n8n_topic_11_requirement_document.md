# Requirement Document: N8N Hands-On Beginner Course
## Topic 11: HTTP Request Node

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 11 - HTTP Request Node |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 25, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to teach trainees and employees how to use the HTTP Request node to call a public API and retrieve data using GET and POST requests. Trainees will learn the basic structure of an API request (including URL, Method, headers, query parameters, and body) and how to read the JSON response returned by a public API for downstream processing in n8n.

### 2.2 Learning Scope
* **In Scope:**
  * Adding and configuring the HTTP Request node in the n8n canvas.
  * Configuring a GET request to retrieve mock data from a public REST API (e.g., `https://jsonplaceholder.typicode.com/users/1`).
  * Configuring a POST request to send a JSON payload to a public REST API endpoint (e.g., `https://jsonplaceholder.typicode.com/posts`).
  * Defining the Request Method, URL, Query Parameters, and Request Body.
  * Reading and inspecting the structured JSON response in the n8n UI.
* **Out of Scope:**
  * Configuring complex authentication methods (like OAuth2 token refreshing or client certificate credentials) on the HTTP Request node; the exercises will use public unauthenticated APIs.
  * Parsing HTML or non-structured plain text formats using custom regex (we will focus on JSON parsing).
  * Configuring advanced HTTP options such as custom timeouts, proxy servers, or custom SSL certificate validation.

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Completed Topic 1 through Topic 10.
* A basic conceptual understanding of APIs, specifically the difference between HTTP GET and POST methods, and JSON payloads.
* Outbound internet access from the n8n instance to query public endpoints.

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | HTTP GET Config | The workflow shall include an HTTP Request node configured with method GET to call a public API endpoint (e.g., `https://jsonplaceholder.typicode.com/users/1`). | High |
| **REQ-002** | HTTP POST Config | The workflow shall include an HTTP Request node configured with method POST to call a public API endpoint (e.g., `https://jsonplaceholder.typicode.com/posts`). | High |
| **REQ-003** | JSON Body Mapping | The HTTP Request POST node shall send a JSON-formatted body containing properties from the preceding nodes (e.g., name and email). | High |
| **REQ-004** | Response Parsing | The HTTP Request node shall automatically parse the API's JSON response, outputting a structured JSON object to the canvas. | High |
| **REQ-005** | Response Evaluation | The trainee shall identify specific fields in the API output (e.g., checking the id from the GET response or the created status from the POST response). | High |
| **REQ-006** | Sequential Execution | The workflow shall run sequentially (Trigger -> HTTP Request GET -> Edit Fields/Mock -> HTTP Request POST) and complete with no errors. | High |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | Outbound Network Calls | The n8n server hosting the environment must be capable of executing outbound HTTPS connections to public endpoints over port 443. |
| **TR-002** | Content-Type Header Parsing | The HTTP Request node must inspect the response's Content-Type header and parse the payload as JSON when set to `application/json`. |
| **TR-003** | Response Schema Preservation | The system must output the response object exactly as received from the API, mapping nesting structure correctly into n8n's internal JSON representation. |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs to learn how to fetch live external data and send updates to third-party endpoints that lack native n8n nodes. |
| **Instructor / Reviewer** | Evaluation | Needs to verify that the student knows how to specify URLs, select correct methods, build query parameters or body payloads, and inspect outputs. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** The public mock API (e.g., JSONPlaceholder) is active, fully functional, and accessible by the trainee's n8n server.
* **Assumption 2 (ASM-002):** The API response is returned in standard JSON format.
* **Constraint 1 (CON-001):** The public API endpoint may have strict rate limits, so testing workflows frequently could result in temporary 429 Too Many Requests status codes.
