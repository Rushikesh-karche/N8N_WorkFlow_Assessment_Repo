# Topic 7: Working with Webhooks and Event-Driven APIs
## API Integration Hands-On Course for n8n

[![n8n Version](https://img.shields.io/badge/n8n-v1.x-orange.svg)](https://n8n.io)
[![Postman](https://img.shields.io/badge/Postman-Tested-FF6C37.svg)](https://www.postman.com)
[![ngrok](https://img.shields.io/badge/ngrok-Tunneling-1F1E33.svg)](https://ngrok.com)
[![Status](https://img.shields.io/badge/Status-Completed--Verified-brightgreen.svg)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]()

---

## 📌 Executive Overview
Welcome to **Topic 7: Working with Webhooks and Event-Driven APIs** in the **API Integration Hands-On Course for n8n**.

In modern cloud applications, polling APIs is inefficient. Event-Driven Architecture (EDA) utilizes webhooks to trigger automation pipelines the instant a business event occurs:
1. **Public Tunneling with ngrok:** Exposing self-hosted local n8n instances to the internet via secure HTTPS tunnels.
2. **Configuring Webhook Trigger Nodes:** Setting up `POST /receive-leads` with immediate HTTP 200 acknowledgment.
3. **Test vs Production Webhook URLs:** Utilizing ephemeral test listening routes for interactive debugging and permanent production routes for background operation.
4. **Cryptographic HMAC Signature Verification:** Protecting endpoints against spoofing attacks using SHA256 HMAC hashing and header authentication.
5. **Production Workflow Activation:** Enabling workflows for 24/7 background execution and inspecting executions in the audit history.

---

## 🚀 Key Repository Artifacts
| File | Description |
| :--- | :--- |
| **`Topic 7 - N8N Lead Webhook Workflow.json`** | Complete 8-node event-driven workflow with dual trigger modes, HMAC verification, lead processing, and embedded `pinData`. |
| **`n8n_topic_7_requirement_document.md`** | Comprehensive technical requirement specification covering BRD, PRD, SRS, node blueprints, and QA plans. |
| **`n8n_topic_7_requirement_document.pdf`** | Professional executive PDF requirement document rendered via Microsoft Edge headless mode. |
| **`Topic_7_Implementation_Plan.md`** | Step-by-step practical implementation plan with exact ngrok setup, Postman testing payloads, and signature formulas. |
| **`Topic_7_Implementation_Plan.pdf`** | Official formatted PDF implementation guide rendered via Microsoft Edge headless mode. |

---

## 🛠️ Canvas Architecture & Flow
```text
[ Webhook: POST /receive-leads ] ────┐
                                     ▼
[ Manual Trigger ] ──> [ Mock Lead ] ──> [ Verify HMAC Signature ] ──> [ If Valid? ]
                                                                             ├── True ──> [ Process Lead Data ] ──> [ Audit Summary ]
                                                                             └── False ─> [ Reject 401 Unauthorized ]
```

---

## 🧪 Testing & Verification Guide
1. **1-Click Instant Canvas Verification:**
   - Import `Topic 7 - N8N Lead Webhook Workflow.json` into your n8n canvas.
   - Click **Execute workflow**.
   - Observe all nodes execute sequentially with bright green checkmarks and verify the `Code_AuditSummary` node outputs a 100% PASS audit receipt!
2. **Live Postman Testing:**
   - **Test Webhook:** Click "Listen for test event" on the Webhook node, then send a POST request with `X-Webhook-Signature: my_shared_signing_secret_9988` and JSON body to the Test URL.
   - **Production Webhook:** Toggle workflow status to **Active**, copy the Production URL, and send from Postman to verify automatic background logging in the Executions tab.

---

## 🎥 YouTube Video Recording Guide (60 Seconds Left-to-Right)
- **0:00 - 0:15 (Why & What):** Introduce Topic 7. Explain why event-driven webhooks replace inefficient polling and how ngrok allows local n8n instances to receive real-time internet events.
- **0:15 - 0:30 (Webhook Node & Test vs Production URLs):** Open `Webhook_ReceiveLeads` showing the `POST /receive-leads` route. Clearly explain the difference between the Test URL (used during interactive debugging) and the Production URL (used when active).
- **0:30 - 0:45 (Postman Ingestion & HMAC Security):** Show Postman sending David Brown's lead payload with the `X-Webhook-Signature` header. Highlight `Verify_HMACSignature` and the If node, explaining how SHA256 HMAC verification prevents malicious spoofing attacks.
- **0:45 - 1:00 (Lead Enrichment, Activation & 1-Click Run):** Walk through `Process_LeadData` enriching the lead, show the workflow activation toggle, and click "Execute workflow" showing 100% green checkmarks across the canvas!
