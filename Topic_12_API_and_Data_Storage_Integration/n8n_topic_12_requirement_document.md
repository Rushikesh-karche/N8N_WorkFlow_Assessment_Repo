# Requirement Document: N8N Hands-On Beginner Course
## Topic 12: API & Data Storage Integration

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 12 - API & Data Storage Integration |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 25, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to teach trainees and employees how to combine the HTTP Request node with Google Sheets to fetch external data and store it for later use. Trainees will learn the design pattern of fetching array-based JSON responses from a public API, resolving nested JSON structures, mapping those fields to a Google Sheet's columns, and understanding how n8n automatically handles multi-item loops.

### 2.2 Learning Scope
* **In Scope:**
  * Configuring an HTTP Request node to execute a GET request fetching a list of users (e.g., `https://jsonplaceholder.typicode.com/users`).
  * Configuring a Google Sheets node (Append operation) to insert the fetched data.
  * Resolving nested JSON elements (such as `company.name` inside a user profile) using expressions.
  * Mapping dynamic data points (`id`, `name`, `email`, and `company.name`) to Google Sheet headers.
  * Leveraging n8n's native looping mechanism to append all records in the fetched array to the spreadsheet.
* **Out of Scope:**
  * Handling complex deduplication logic or looking up existing spreadsheet rows before appending (focus is strictly on bulk data retrieval and appending).
  * Dynamically formatting sheet cells or creating tables or columns via Google Sheets API.
  * Connecting to third-party SQL databases (focus is strictly on Google Sheets as storage).

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Completed Topic 1 through Topic 11.
* Verified Google Sheets OAuth2 / Service Account credentials configured in n8n.
* A target Google Sheet created with columns: `ID`, `Name`, `Email`, `Company`.
* Internet access to fetch mock data from public REST APIs.

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | API Fetch | The workflow shall include an HTTP Request node configured to perform a GET request fetching a list of records from `https://jsonplaceholder.typicode.com/users`. | High |
| **REQ-002** | Google Sheets Append | The workflow shall include a Google Sheets node configured with the Append Row operation to save the fetched records. | High |
| **REQ-003** | Nested Field Mapping | The Google Sheets node shall support extracting and mapping both flat and nested properties from the API response:<br>• `id` to `ID` column<br>• `name` to `Name` column<br>• `email` to `Email` column<br>• `company.name` (nested property) to `Company` column. | High |
| **REQ-004** | Multi-Item Looping | The workflow shall process all items returned in the API response array and append each as a separate row in the Google Sheet. | High |
| **REQ-005** | Sheet Target Config | The Google Sheets node shall require specifying the target Spreadsheet ID and sheet name tab (`Sheet1`). | High |
| **REQ-006** | Complete Integration Flow | The workflow shall execute sequentially (Trigger -> HTTP Request -> Google Sheets) and write all retrieved items successfully. | High |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | Automatic Iterative Execution | The n8n runtime must automatically loop downstream nodes when an upstream node outputs an array of multiple items. |
| **TR-002** | Nested Path Resolution | The expression engine must parse nested properties (dot notation: `{{ $json.company.name }}`) without throwing execution errors. |
| **TR-003** | Batch Write / Write Throttling | The Google Sheets node must successfully process multiple incoming rows (typically 10 rows from the API) in a batch or quick succession without hitting connection rate limits. |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs to learn the core data storage pattern of fetching data from external endpoints and writing it to a spreadsheet database for storage and reporting. |
| **Instructor / Reviewer** | Evaluation | Needs to verify that the student can combine HTTP and Google Sheets nodes, map nested properties, and successfully write multiple rows. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** The public mock API returns an array of structured JSON profiles.
* **Assumption 2 (ASM-002):** The header row in the Google Sheet is row 1 and contains the exact column titles: `ID`, `Name`, `Email`, and `Company`.
* **Constraint 1 (CON-001):** Google Sheets API limits may restrict writing thousands of rows in simple loops, so this exercise is constrained to 10 mock records.
