# Topic 8: Integrating Multiple APIs Together
## API Integration Hands-On Course for n8n

[![n8n Version](https://img.shields.io/badge/n8n-v1.x-orange.svg)](https://n8n.io)
[![JSONPlaceholder](https://img.shields.io/badge/API-JSONPlaceholder-blue.svg)](https://jsonplaceholder.typicode.com)
[![Postman Echo](https://img.shields.io/badge/Postman-Echo-FF6C37.svg)](https://postman-echo.com)
[![Status](https://img.shields.io/badge/Status-Completed--Verified-brightgreen.svg)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]()

---

## 📌 Executive Overview
Welcome to **Topic 8: Integrating Multiple APIs Together** in the **API Integration Hands-On Course for n8n**.

Real-world business automations must connect multiple external platforms into a cohesive, traceable pipeline. In this module, you will build an end-to-end multi-API orchestration workflow:
1. **Support Ticket Intake:** Ingesting structured customer support tickets with issue descriptions and contact metadata.
2. **Correlation ID Generation:** Generating custom transaction identifiers (`TX-YYYYMMDDHHmmss-XXX`) using Luxon date formatting and math expressions for distributed tracing.
3. **Dynamic Customer Lookup:** Resolving customer email addresses to database IDs using inline ternary expressions while preserving upstream state.
4. **Mock Database Logging:** Transmitting ticket details to a database POST API with `X-Correlation-ID` tracking headers.
5. **Multi-Hop Notification Alerting:** Dispatching confirmation emails via Postman Echo by pulling customer emails and ticket IDs directly from upstream ancestor nodes.

---

## 🚀 Key Repository Artifacts
| File | Description |
| :--- | :--- |
| **`Topic 8 - N8N API Orchestration Workflow.json`** | Complete 7-node multi-API orchestration pipeline with correlation tracing, ancestor referencing, and embedded `pinData`. |
| **`n8n_topic_8_requirement_document.md`** | Enterprise architectural specification covering BRD, PRD, SRS, node blueprints, and QA plans. |
| **`n8n_topic_8_requirement_document.pdf`** | Formatted executive PDF requirement document compiled via Microsoft Edge headless mode. |
| **`Topic_8_Implementation_Plan.md`** | Step-by-step practical implementation plan with exact transaction expressions, lookup logic, and notification templates. |
| **`Topic_8_Implementation_Plan.pdf`** | Official formatted PDF implementation guide compiled via Microsoft Edge headless mode. |

---

## 🛠️ Canvas Architecture & Flow
```text
[ Manual Trigger ] ──> [ Support Ticket Intake ] ──> [ Initialize Transaction (Correlation ID) ]
                                                                   │
                                                                   ▼
[ Code_AuditSummary ] <── [ Send Notification Alert ] <── [ Log to Database ] <── [ Customer Lookup ]
                                (Postman Echo)             (JSONPlaceholder)
```

---

## 🧪 Testing & Verification Guide
1. **1-Click Instant Canvas Verification:**
   - Import `Topic 8 - N8N API Orchestration Workflow.json` into your n8n canvas.
   - Click **Execute workflow**.
   - Observe all 7 nodes execute sequentially with bright green checkmarks and verify the `Code_AuditSummary` node outputs a 100% PASS compliance receipt!
2. **Orchestration Verification Checkpoints:**
   - **Transaction ID:** Generated as `TX-YYYYMMDDHHmmss-XXX` and forwarded in the database request header `X-Correlation-ID`.
   - **Customer Lookup:** Resolves Alice's email to `CUST-7744` without losing parent ticket fields.
   - **Database Log:** Returns HTTP 201 Created from JSONPlaceholder.
   - **Notification Alert:** Postman Echo receives confirmation email payload with Alice's email and ticket ID extracted from the `Initialize Transaction` ancestor node.

---

## 🎥 YouTube Video Recording Guide (60 Seconds Left-to-Right)
- **0:00 - 0:15 (Why & What):** Introduce Topic 8. Explain how production workflows orchestrate multiple disparate APIs while retaining end-to-end traceability using correlation IDs and ancestor references.
- **0:15 - 0:30 (Ticket Intake & Correlation Tracking):** Show `Incoming Support Ticket` and `Initialize Transaction`. Highlight the Luxon expression generating `TX-YYYYMMDDHHmmss-XXX` and demonstrate how `Customer Database Lookup` resolves Alice's customer ID while keeping upstream fields intact.
- **0:30 - 0:45 (Database Logging & Correlation Header):** Open `Log to Database`, showing the `X-Correlation-ID` header and JSON body sent to JSONPlaceholder, returning a 201 Created response.
- **0:45 - 1:00 (Ancestor Notification & 1-Click Run):** Highlight `Send Notification Alert` pulling Alice's email from `$('Initialize Transaction')`. Click "Execute workflow" showing 100% green checkmarks across all canvas nodes!
