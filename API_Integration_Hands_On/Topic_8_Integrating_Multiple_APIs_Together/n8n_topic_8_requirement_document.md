# Topic 8: Integrating Multiple APIs Together
## Official Technical Requirement Specification & Architecture Blueprint

---

## 1. Document Control
| Field | Specification Value |
| :--- | :--- |
| **Document Title** | Topic 8: Integrating Multiple APIs Together Specification |
| **Course Module** | API Integration Hands-On for n8n (Level 3 - Enterprise Series) |
| **Version** | 1.0 (Production Master) |
| **Status** | Approved & Verified |
| **Last Updated** | 2026-11-20 |
| **Prepared By** | Lead Solutions Architect & Automation Engineering Team |
| **Target Audience** | Integration Engineers, API Developers, DevOps Engineers, Automation Trainees |

---

## 2. Learning Concepts & Architectural Principles

### 2.1 Multi-API Orchestration & Enterprise Integration Patterns (EIP)
Production workflows bridge distinct systems—support desks, CRM databases, payment gateways, and messaging platforms:
1. **The Distributed Transaction Problem:** Actions across multiple REST services require unified tracking. If an error occurs in step 4, engineers need an audit key to identify associated operations in step 1.
2. **Correlation ID Propagation:** Generating a standardized correlation identifier (`TX-YYYYMMDDHHmmss-XXX`) and forwarding it via `X-Correlation-ID` headers guarantees end-to-end distributed tracing.

### 2.2 Data Enrichment & In-Flight Customer Lookup
Incoming event payloads often contain only basic identifiers (e.g., an email address):
- **Dynamic Lookup Logic:** Utilizing ternary expressions `{{ $json.customerEmail === 'alice@example.com' ? 'CUST-7744' : 'CUST-9999' }}` resolves relational database IDs on the fly.
- **Pass-Through Preservation:** Enabling `keepOnlySet: false` guarantees that preceding ticket attributes flow seamlessly downstream alongside enriched fields.

### 2.3 State Preservation across Multi-Hop API Calls
Linear workflows replace the active item payload at each HTTP Request node:
- **Downstream Context Loss:** After calling `Log to Database`, the output contains database response metadata rather than original customer details.
- **Ancestor Node Referencing:** Using `$('Initialize Transaction').item.json.customerEmail` allows terminal notification nodes to extract root customer metadata without complex merging or intermediate staging variables.

---

## 3. Business Requirements Document (BRD)

| ID | Requirement | Business Rationale | Impact | Priority |
| :--- | :--- | :--- | :--- | :--- |
| **BRD-001** | Unified Ticket Orchestration | Seamlessly orchestrate customer ticket intake, database logging, and email notification. | Replaces manual triage; cuts ticket acknowledgment time to < 2 seconds. | Critical |
| **BRD-002** | Distributed Transaction Tracing | Generate and propagate unique correlation IDs across all service calls. | Enables instant cross-system log correlation during incident triage. | Critical |
| **BRD-003** | Automated Customer ID Resolution | Map customer email addresses to enterprise customer IDs dynamically. | Eliminates human data entry errors in CRM records. | High |
| **BRD-004** | Context-Rich Notifications | Dispatch confirmation messages combining original ticket data and generated transaction IDs. | Delivers transparent, professional customer support communication. | High |
| **BRD-005** | Offline PinData Resilience | Embed pre-validated test data on all nodes. | Guarantees instant 1-click execution for training and automated testing. | Medium |

---

## 4. Product Requirements Document (PRD)

| ID | Capability | User Story & Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **PRD-001** | Inbound Ticket Staging | Set node captures `ticketId`, `customerEmail`, and `issueDescription`. | High |
| **PRD-002** | Correlation ID Generation | Set node generates `TX-YYYYMMDDHHmmss-XXX` using Luxon and math expressions. | Critical |
| **PRD-003** | Relational ID Lookup | Set node maps `alice@example.com` to `CUST-7744` with `keepOnlySet: false`. | High |
| **PRD-004** | Database Record Logging | HTTP POST to JSONPlaceholder with `X-Correlation-ID` header and JSON payload. | Critical |
| **PRD-005** | Ancestor-Linked Notification | HTTP POST to Postman Echo pulling recipient from `Initialize Transaction`. | Critical |
| **PRD-006** | Orchestration Audit Verification | Code node verifies all 3 service outputs and generates 100% PASS receipt. | High |

---

## 5. Software Requirements Specification (SRS) & Canvas Blueprint

### 5.1 Pipeline Canvas Architecture
```text
[ N08-01: Manual_Trigger ]
            │
            ▼
[ N08-02: Incoming Support Ticket ] ───> ticketId: "TCK-8855", customerEmail: "alice@example.com"
            │
            ▼
[ N08-03: Initialize Transaction ] ────> Generates transactionId: "TX-20261120145000-456"
            │
            ▼
[ N08-04: Customer Database Lookup ] ──> Maps email to customerId: "CUST-7744" (keepOnlySet: false)
            │
            ▼
[ N08-05: Log to Database ] ───────────> POST https://jsonplaceholder.typicode.com/posts
            │                            Headers: X-Correlation-ID: {{ $json.transactionId }}
            ▼
[ N08-06: Send Notification Alert ] ───> POST https://postman-echo.com/post
            │                            Recipient: {{ $('Initialize Transaction').item.json.customerEmail }}
            ▼                            Body: references $json.transactionId
[ N08-07: Code_AuditSummary ] ─────────> Synthesizes 100% PASS Multi-API Orchestration Receipt
```

---

## 6. Detailed Node Configuration Blueprint

| Node Name | Node Type | Version | Operational Function & Settings |
| :--- | :--- | :--- | :--- |
| **Manual_Trigger** | `manualTrigger` | 1 | Initiates manual execution on canvas button click. |
| **Incoming Support Ticket** | `set` | 3.4 | Ingests mock support ticket payload: `ticketId`, `customerEmail`, `issueDescription`. |
| **Initialize Transaction** | `set` | 3.4 | Generates unique correlation ID `TX-{{ $now.toFormat('yyyyMMddHHmmss') }}-{{ Math.floor(Math.random()*1000) }}`. |
| **Customer Database Lookup** | `set` | 3.4 | Evaluates ternary lookup: `alice@example.com` → `CUST-7744`; passes all upstream fields. |
| **Log to Database** | `httpRequest` | 4.2 | Method: POST, URL: `https://jsonplaceholder.typicode.com/posts`. Sends `X-Correlation-ID` header. |
| **Send Notification Alert** | `httpRequest` | 4.2 | Method: POST, URL: `https://postman-echo.com/post`. Pulls recipient from ancestor node. |
| **Code_AuditSummary** | `code` | 2 | Evaluates end-to-end multi-API audit trail and outputs 100% PASS compliance receipt. |

---

## 7. Testing & Quality Assurance Verification Plan

| Scenario ID | Test Condition | Evaluation Target | Expected Result & Verification |
| :--- | :--- | :--- | :--- |
| **TC-08-01** | Support Ticket Staging | Incoming Payload | Ingests ticket `TCK-8855` and Alice's email cleanly. |
| **TC-08-02** | Correlation ID Generation | `transactionId` Expression | Outputs valid `TX-YYYYMMDDHHmmss-XXX` timestamp-prefixed ID. |
| **TC-08-03** | Customer ID Lookup | Email Match Condition | Evaluates Alice to `CUST-7744` while preserving parent fields. |
| **TC-08-04** | Mock Database Logging | POST JSONPlaceholder | Returns HTTP 201 Created with echoed transaction attributes. |
| **TC-08-05** | Ancestor State Retrieval | Postman Echo Notification | Successfully injects Alice's email and ticket ID from ancestor node. |
| **TC-08-06** | 1-Click Instant Canvas Run | Click "Execute workflow" | 100% green checkmarks across all canvas nodes via embedded pinData. |

---

## 8. Operational Guidelines & Best Practices
- **Standardize Correlation Header Names:** Use `X-Correlation-ID` or `X-Request-ID` consistently across all outbound API calls to simplify distributed tracing.
- **Toggle Keep Only Set Fields Mindfully:** In lookup nodes, ensure `keepOnlySet: false` is selected so upstream context is not unintentionally dropped.
- **Leverage Ancestor Nodes Over State Staging:** When sending confirmation notifications, pull directly from the original intake node using `$('Node Name').item.json` to ensure immutable data integrity.
