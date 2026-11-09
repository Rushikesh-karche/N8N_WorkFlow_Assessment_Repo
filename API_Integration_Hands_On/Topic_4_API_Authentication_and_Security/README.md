# Topic 4: API Authentication and Security (Basic Auth, Bearer Tokens, OAuth 2.0 & JWT)
## API Integration Hands-On Course for n8n

[![n8n Version](https://img.shields.io/badge/n8n-v1.x-orange.svg)](https://n8n.io)
[![Postman Echo](https://img.shields.io/badge/Postman-Echo-FF6C37.svg)](https://postman-echo.com)
[![Status](https://img.shields.io/badge/Status-Completed--Verified-brightgreen.svg)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]()

---

## 📌 Executive Overview
Welcome to **Topic 4: API Authentication and Security** in the **API Integration Hands-On Course for n8n**.

This module establishes enterprise-grade authentication standards across modern RESTful web services:
1. Managing encrypted, decoupled credentials in the **n8n Credential Store** to eliminate plain-text key leakage.
2. Authenticating via **HTTP Basic Auth** (`postman:password`) against Postman Echo with status `200 OK`.
3. Dispatching **Header-Based Bearer Tokens** (`Authorization: Bearer my_secret_token_9988`) and validating server echo receipts.
4. Architectural walkthrough of **OAuth 2.0 Handshakes** (Client ID, Client Secret, Redirect Callbacks, and token refresh rotations).
5. Deconstructing and validating **JSON Web Tokens (JWT)** into Header, Payload claims, and Signature hashes.

---

## 🚀 Key Repository Artifacts
| File | Description |
| :--- | :--- |
| **`Topic 4 - N8N API Authentication Workflow.json`** | Complete importable n8n workflow with embedded `pinData` for instant 1-click execution. |
| **`n8n_topic_4_requirement_document.md`** | Comprehensive technical requirement specification covering BRD, PRD, SRS, and test specifications. |
| **`n8n_topic_4_requirement_document.pdf`** | Professional executive PDF requirement document rendered via Microsoft Edge headless mode. |
| **`Topic_4_Implementation_Plan.md`** | Step-by-step practical implementation plan with exact authentication configurations and JWT deconstruction steps. |
| **`Topic_4_Implementation_Plan.pdf`** | Official formatted PDF implementation guide rendered via Microsoft Edge headless mode. |

---

## 🛠️ Canvas Architecture & Flow
```text
[ Manual Trigger ] ──> [ HTTP Basic Auth ] ──> [ HTTP Bearer Token ] ──> [ Deconstruct JWT ] ──> [ Security Audit Summary ]
```

---

## 🧪 Testing & Verification Guide
1. **n8n Canvas Verification:**
   - Import `Topic 4 - N8N API Authentication Workflow.json` into n8n.
   - Click **Execute workflow**.
   - Observe all 5 nodes execute sequentially with green checkmarks immediately!
2. **Security Verification Checkpoints:**
   - `HTTP_BasicAuth` $ightarrow$ Status `200 OK`, `authenticated: true`.
   - `HTTP_BearerTokenAuth` $ightarrow$ Echoes `"authorization": "Bearer my_secret_token_9988"`.
   - `Code_DeconstructJWT` $ightarrow$ Decodes `alg: "HS256"`, `name: "John Doe"`, `admin: true`.
   - `Code_AuthAuditSummary` $ightarrow$ Confirms `securityComplianceScore: "100% PASS"`.

---

## 🎥 YouTube Video Recording Guide (60 Seconds Left-to-Right)
- **0:00 - 0:15 (Why & What):** Introduce Topic 4 and explain why decoupling credentials from workflows and mastering Basic Auth, Bearer Tokens, OAuth 2.0, and JWTs is mandatory for enterprise security.
- **0:15 - 0:30 (Basic Auth & Bearer Tokens):** Show `HTTP_BasicAuth` returning `authenticated: true` from Postman Echo, followed by `HTTP_BearerTokenAuth` verifying our Bearer token in the echoed header.
- **0:30 - 0:45 (OAuth 2.0 & JWT Deconstruction):** Explain the OAuth 2.0 callback architecture in n8n, then walk through `Code_DeconstructJWT` showing how our mock JWT breaks down into Header, John Doe's admin claims, and the cryptographic signature.
- **0:45 - 1:00 (Security Audit Ledger & Execution):** Highlight `Code_AuthAuditSummary` compiling our 100% compliance receipt. Click "Execute workflow" showing all green checkmarks across the canvas!
