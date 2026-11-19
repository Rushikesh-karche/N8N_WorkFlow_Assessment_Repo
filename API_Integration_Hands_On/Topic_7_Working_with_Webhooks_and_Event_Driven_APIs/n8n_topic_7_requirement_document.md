# Topic 7: Working with Webhooks and Event-Driven APIs
## Official Technical Requirement Specification & Architecture Blueprint

---

## 1. Document Control
| Field | Specification Value |
| :--- | :--- |
| **Document Title** | Topic 7: Working with Webhooks and Event-Driven APIs Specification |
| **Course Module** | API Integration Hands-On for n8n (Level 3 - Enterprise Series) |
| **Version** | 1.0 (Production Master) |
| **Status** | Approved & Verified |
| **Last Updated** | 2026-11-19 |
| **Prepared By** | Lead Solutions Architect & Automation Engineering Team |
| **Target Audience** | Integration Engineers, API Developers, DevOps Engineers, Automation Trainees |

---

## 2. Learning Concepts & Architectural Principles

### 2.1 Event-Driven Architecture (EDA) vs Scheduled Polling
Traditional polling repeatedly queries endpoints at fixed cron intervals (e.g., every 5 minutes):
1. **Inefficiencies of Polling:** Wastes computational cycles, consumes API quota, and incurs up to a 5-minute latency window before detecting new data.
2. **The Webhook Solution:** External systems (Stripe, GitHub, Shopify, Salesforce) push HTTP POST event notifications instantaneously when state changes occur, reducing latency from minutes to milliseconds.

### 2.2 Local Tunneling via ngrok & Base URL Registration
Because local developer environments run behind NAT routers and corporate firewalls on non-routable localhost addresses:
- **ngrok Tunneling:** Exposes local port 5678 to the public internet via a secure HTTPS subdomain.
- **Base Webhook URL Registration:** Setting `WEBHOOK_URL=https://<subdomain>.ngrok-free.app` ensures n8n generates externally reachable callback URLs in its webhook trigger interface.

### 2.3 Test vs Production Webhook Endpoints
n8n provides two distinct lifecycle endpoints for every webhook trigger:
- **Test Webhook (`/webhook-test/...`):** Active only while the user clicks "Listen for test event". Returns live execution traces directly into the editor for interactive debugging.
- **Production Webhook (`/webhook/...`):** Active 24/7 once the workflow switch is toggled to "Active". Ingests live traffic asynchronously in the background and writes audit logs to the Executions history.

### 2.4 Cryptographic Request Signing & Spoofing Defense (HMAC-SHA256)
Public webhook endpoints are exposed to the open web and must verify sender authenticity:
- **Shared Secret Pattern:** Senders pass an agreed secret token in custom headers (`X-Webhook-Signature`).
- **Cryptographic HMAC-SHA256:** Senders hash the outbound request body with a private shared secret. n8n computes the identical HMAC on the inbound raw body using Node.js `crypto` to mathematically guarantee payload integrity and reject spoofing attacks.

---

## 3. Business Requirements Document (BRD)

| ID | Requirement | Business Rationale | Impact | Priority |
| :--- | :--- | :--- | :--- | :--- |
| **BRD-001** | Sub-Second Lead Ingestion | Ingest customer leads immediately upon submission via HTTP Webhooks. | Eliminates polling delay; accelerates sales qualification response time. | Critical |
| **BRD-002** | Secure Ingress Verification | Enforce cryptographic signature checks on inbound webhooks. | Blocks malicious payload injection and unauthorized endpoint tampering. | Critical |
| **BRD-003** | Dual Ingress Environments | Maintain dedicated test listening routes and permanent production routes. | Prevents staging tests from corrupting production databases. | High |
| **BRD-004** | Immediate Ingress Acknowledgement | Return HTTP 200 immediately upon payload receipt to prevent remote timeouts. | Prevents upstream webhook senders from triggering false retry floods. | High |
| **BRD-005** | Offline PinData Resilience | Provide embedded test mock data on all canvas nodes. | Enables 100% green 1-click execution during student training and CI validation. | Medium |

---

## 4. Product Requirements Document (PRD)

| ID | Capability | User Story & Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **PRD-001** | Webhook Trigger Endpoint | Node listens on `POST /receive-leads` with `onReceived` response mode. | Critical |
| **PRD-002** | Signature Verification | Evaluates `x-webhook-signature` using HMAC-SHA256 and header authentication. | Critical |
| **PRD-003** | Conditional Routing | If node branches valid signatures to lead processing and invalid to 401 Unauthorized. | High |
| **PRD-004** | Lead State Transformation | Set node formats `leadId`, `name`, `email`, `leadStatus`, and UTC timestamp. | High |
| **PRD-005** | Production Tunnel Support | Architecture accommodates ngrok base URLs for external callback routing. | High |
| **PRD-006** | End-to-End Audit Verification | Code node verifies HMAC validation, routing, and generates 100% PASS audit receipt. | High |

---

## 5. Software Requirements Specification (SRS) & Canvas Blueprint

### 5.1 Pipeline Canvas Architecture
```text
[ N07-01: Webhook_ReceiveLeads ] ────┐
(POST /receive-leads)                 │
                                      ▼
[ N07-02: Manual_Trigger ] ──────> [ N07-04: Verify_HMACSignature ] 
            │                      (Validates SHA256 HMAC & Header Secret)
            ▼                                 │
[ N07-03: Mock_InboundLeadPayload ] ──────────┘
                                      │
                                      ▼
                           [ N07-05: If_SignatureValid ]
                                 ├── True (Signature Verified)
                                 │         │
                                 │         ▼
                                 │   [ N07-06: Process_LeadData ]
                                 │   (Enriches & maps lead metadata)
                                 │         │
                                 │         ▼
                                 │   [ N07-08: Code_AuditSummary ]
                                 │   (100% PASS Compliance Receipt)
                                 │
                                 └── False (Invalid / Missing Signature)
                                           │
                                           ▼
                                     [ N07-07: Reject_UnauthorizedRequest ]
                                     (Emits HTTP 401 Unauthorized Object)
```

---

## 6. Detailed Node Configuration Blueprint

| Node Name | Node Type | Version | Operational Function & Settings |
| :--- | :--- | :--- | :--- |
| **Webhook_ReceiveLeads** | `webhook` | 2 | Method: POST, Path: `receive-leads`, Response Mode: `onReceived`. Ingests live payloads. |
| **Manual_Trigger** | `manualTrigger` | 1 | Initiates manual execution on canvas button click for testing. |
| **Mock_InboundLeadPayload** | `set` | 3.4 | Emulates Postman inbound payload with lead metadata and test signature header. |
| **Verify_HMACSignature** | `code` | 2 | Computes SHA256 HMAC of body using secret key and verifies header authenticity. |
| **If_SignatureValid** | `if` | 2 | Evaluates `isSignatureValid === true` to branch legitimate traffic from spoofed calls. |
| **Process_LeadData** | `set` | 3.4 | Enriches lead record with status, CRM stage, and current ISO timestamp. |
| **Reject_UnauthorizedRequest** | `set` | 3.4 | Formats 401 Unauthorized rejection payload for security violation auditing. |
| **Code_AuditSummary** | `code` | 2 | Synthesizes comprehensive webhook security and ingestion audit receipt. |

---

## 7. Testing & Quality Assurance Verification Plan

| Scenario ID | Test Condition | Evaluation Target | Expected Result & Verification |
| :--- | :--- | :--- | :--- |
| **TC-07-01** | Inbound Payload Ingestion | `POST /receive-leads` | Webhook node captures `leadId`, `name`, and `email` from Postman POST. |
| **TC-07-02** | Immediate Acknowledgment | Response Mode `onReceived` | Sender receives HTTP 200 OK instantaneously. |
| **TC-07-03** | Valid Signature Match | `my_shared_signing_secret_9988` | Signature passes verification; routes to `Process_LeadData`. |
| **TC-07-04** | Spoofed / Corrupt Signature | Incorrect Header Value | Signature fails verification; routes to `Reject_UnauthorizedRequest` (401). |
| **TC-07-05** | Production Workflow Activation | Inactive → Active Switch | Background execution recorded in n8n Executions log on production URL call. |
| **TC-07-06** | 1-Click Instant Canvas Run | Click "Execute workflow" | 100% green checkmarks across all canvas nodes via embedded pinData. |

---

## 8. Operational Guidelines & Best Practices
- **Always Keep Secrets in Environment Variables:** In production, reference shared signing secrets using `$env.WEBHOOK_SIGNING_SECRET` rather than hardcoding in nodes.
- **Fast ACK Pattern:** Always use `responseMode: "onReceived"` for heavy downstream processing to prevent remote webhook senders (e.g. Shopify 5s limit) from timing out and re-sending duplicates.
- **Use ngrok Reserved Domains for Dev:** For persistent local development, use an ngrok paid or static reserved domain so webhook URLs do not change on tunnel restart.
