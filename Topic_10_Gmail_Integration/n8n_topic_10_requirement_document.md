# Requirement Document: N8N Hands-On Beginner Course
## Topic 10: Gmail Integration

---

## 1. Document Control

| Field | Value |
| :--- | :--- |
| **Document Title** | Requirement Document: Topic 10 - Gmail Integration |
| **Course** | N8N - Hands On Beginner Course |
| **Target Audience** | Trainee / Employee |
| **Version** | 1.0 |
| **Status** | Approved |
| **Last Updated** | June 25, 2026 |

---

## 2. Objectives & Scope

### 2.1 Course Objective
The main objective of this learning module is to teach trainees and employees how to connect n8n to Gmail to send personalized emails automatically using dynamic content. Trainees will learn how to configure Gmail OAuth2 authentication, set up the send email operation, and use expressions inside the Gmail node to reference data from previous nodes (such as recipient's name and email) to personalize both the subject and the body of the email.

### 2.2 Learning Scope
* **In Scope:**
  * Connecting the Gmail node in n8n with valid API credentials.
  * Configuring the node to perform the Send Email operation (Message: Send).
  * Using n8n expressions (`{{ ... }}`) to dynamically populate the "To" (recipient) field, the "Subject" field, and the "Body" (content) field of the email.
  * Personalizing the email content dynamically with input variables (e.g., `customerName`, `customerEmail`) passed from a mock data node.
  * Sending emails using plain text format.
* **Out of Scope:**
  * Configuring complex Gmail routing rules, filters, or labels.
  * Retrieving, reading, or processing incoming emails from the Gmail inbox.
  * Managing Gmail draft folders, threads, or delete operations.
  * Sending emails with multiple complex attachments or dynamic inline HTML styling.
  * Setting up Google Cloud Console credentials from scratch (assumed pre-configured in the environment).

---

## 3. Target Audience Requirements (Pre-requisites)

To successfully complete this hands-on exercise, trainees/employees must have:
* Completed Topic 1 through Topic 9.
* A Google Account with active Gmail access.
* A pre-configured Gmail OAuth2 credential loaded in their n8n instance.
* A mock data node set up outputting: `customerName` and `customerEmail`.

---

## 4. Functional Requirements

| Requirement ID | Section | Requirement Description | Priority |
| :--- | :--- | :--- | :--- |
| **REQ-001** | Credentials Config | The workflow shall connect to Gmail using valid n8n Gmail API credentials (OAuth2). | High |
| **REQ-002** | Operation Selection | The Gmail node shall be configured to send an email message (Resource: Message, Operation: Send). | High |
| **REQ-003** | Recipient Expression | The "To Email" field shall dynamically resolve to the recipient's email address using the expression `{{ $json.customerEmail }}` from the previous node. | High |
| **REQ-004** | Subject Personalization | The "Subject" field shall be dynamically personalized, incorporating the recipient's name (e.g., `Welcome to N8N Course, {{ $json.customerName }}!`). | High |
| **REQ-005** | Body Personalization | The "Email Body" field shall utilize expressions to insert dynamic text variables, including the recipient's name (e.g., `Hello {{ $json.customerName }}, ...`). | High |
| **REQ-006** | Sequential Execution | The workflow shall execute sequentially (Trigger -> Mock Customer Data -> Gmail) and output a successful status response including Gmail message ID upon completion. | High |

---

## 5. Technical Requirements

| ID | Technical Requirement | Details |
| :--- | :--- | :--- |
| **TR-001** | API Endpoint Routing | The system must route requests securely to the Google Gmail API endpoints (`www.googleapis.com/gmail/v1/users/me/messages/send`). |
| **TR-002** | Expression Parsing | The n8n execution engine must evaluate the double curly-bracket expressions `{{ ... }}` and insert the corresponding data strings before executing the API request. |
| **TR-003** | JSON Input Schema | The Gmail node must consume a JSON structure from the predecessor node containing root properties `customerName` (string) and `customerEmail` (string). |

---

## 6. Stakeholders and Personas

| Persona | Role | Need |
| :--- | :--- | :--- |
| **Trainee / Employee** | Student | Needs to learn how to personalize customer communication dynamically based on database/form data to automate outreach. |
| **Instructor / Reviewer** | Evaluation | Needs to verify that the trainee knows how to configure the Gmail node, construct valid n8n expressions, and send personalized messages. |

---

## 7. Assumptions & Constraints

* **Assumption 1 (ASM-001):** The trainee has active Gmail OAuth2 credentials that are authorized to send emails.
* **Assumption 2 (ASM-002):** The email address provided in the mock data is valid and accessible for checking the test delivery.
* **Constraint 1 (CON-001):** The Google API limits send frequencies and sizes (e.g., Gmail API daily sending limits).
