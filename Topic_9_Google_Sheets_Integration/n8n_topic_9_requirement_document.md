# Requirement Document: N8N Hands-On Beginner Course
## Topic 9: Google Sheets Integration

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 9 - Google Sheets Integration |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 24, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to teach trainees and employees how to connect n8n to Google Sheets to read, append, and update rows in a spreadsheet. Trainees will learn how to configure authentication, map workflow fields to spreadsheet columns, specify target spreadsheets and tabs, and use key columns to update existing records.

### 2.2 Learning Scope
* **In Scope:**
  * Connecting the Google Sheets node in n8n with target spreadsheets.
  * Configuring the Append operation to insert new rows of data.
  * Configuring the Read operation to retrieve all rows from a spreadsheet tab.
  * Configuring the Update operation to find an existing row using a lookup key column (e.g., Email) and modify a specific cell value (e.g., Status).
  * Mapping dynamic input variables (e.g., `customerName`, `customerEmail`) to spreadsheet columns (`Name`, `Email`, `Status`).
  * Specifying Spreadsheet IDs and Sheet Name tabs (e.g., `Sheet1`).
* **Out of Scope:**
  * Creating new spreadsheets or deleting existing sheets dynamically via the API.
  * Writing complex cell formulas or modifying cell formatting (font style, cell borders, background colors) via n8n.
  * Managing Google Drive folder permissions or sharing spreadsheets dynamically.

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Completed Topic 1 through Topic 8.
* A Google Account with access to Google Sheets.
* A pre-configured Google Sheets OAuth2 or Service Account credential loaded in their n8n instance.
* A test spreadsheet created with columns: `Name`, `Email`, `Status`.

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | Credentials Config | The workflow shall connect to Google Sheets using valid n8n Google Sheets API credentials (either Service Account or OAuth2). | High |
| **REQ-002** | Target Specification | The Google Sheets nodes shall require specifying a unique Document (Spreadsheet ID) and a Sheet (tab name, e.g. `Sheet1`). | High |
| **REQ-003** | Append Operation | The workflow shall append a new row to the sheet, mapping workflow properties `customerName` to the `Name` column and `customerEmail` to the `Email` column, setting the `Status` column to `Pending`. | High |
| **REQ-004** | Read Operation | The workflow shall read rows from the target spreadsheet tab and return the content as standard JSON objects to the workflow. | High |
| **REQ-005** | Update Operation | The workflow shall update an existing row in the sheet using a lookup:<br>• Lookup Column: `Email`<br>• Lookup Value: `{{ $json.customerEmail }}`<br>• Field to Update: `Status` set to `Verified`. | High |
| **REQ-006** | Data Pipeline Sync | The workflow shall execute sequentially (Trigger -> Mock Data -> Append -> Read -> Update) and return successful indicators for all steps. | High |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | API Endpoint Routing | The system must route requests securely to the Google Sheets API (`sheets.googleapis.com/v4/spreadsheets`). |
| **TR-002** | Column-Header Parsing | The Google Sheets node must retrieve the first row of the sheet to map incoming keys dynamically to spreadsheet column headers. |
| **TR-003** | Row Lookup Resolution | The Update operation must support scanning the specified lookup column for the lookup value and calculating the correct sheet row index to write updates back. |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs to learn how to store, query, and synchronize business data between n8n workflows and spreadsheets, which are standard databases in beginner applications. |
| **Instructor / Reviewer** | Evaluation | Needs to verify that the trainee knows how to configure the Google Sheets node, map fields correctly, and handle Lookups for update actions. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** The trainee has created a Google Spreadsheet and shared access with the n8n Service Account email (if using Service Account auth).
* **Assumption 2 (ASM-002):** The header row in the Google Sheet is row 1 and contains exactly the case-sensitive column titles `Name`, `Email`, and `Status`.
* **Constraint 1 (CON-001):** The Google API limits write frequencies, so bulk operations must respect standard rate limiting constraints.
