# Topic 1: Setting Up Your API Development Environment
## Official Technical Requirement Specification & Architecture Blueprint

---

## 1. Document Control
| Field | Specification Value |
| :--- | :--- |
| **Document Title** | Topic 1: Setting Up Your API Development Environment Specification |
| **Course Module** | API Integration Hands-On for n8n (Level 3 - Enterprise Series) |
| **Version** | 1.0 (Production Master) |
| **Status** | Approved & Verified |
| **Last Updated** | 2026-11-06 |
| **Prepared By** | Lead Solutions Architect & Automation Engineering Team |
| **Target Audience** | Integration Engineers, API Developers, Automation Trainees |

---

## 2. Learning Concepts & Architectural Principles

### 2.1 The Role of API Clients in Automation Workflows
Before building production automations in n8n, developers must independently explore, test, and validate API endpoints using an isolated HTTP client. **Postman** serves as the gold-standard environment for:
1. **Isolated Contract Verification:** Testing authentication headers, parameters, and payloads without workflow side effects.
2. **Response Inspection:** Analyzing HTTP status codes (`200 OK`, `401 Unauthorized`, `404 Not Found`), payload data structures, and round-trip latency.
3. **Reproducible Debugging:** Establishing mock collections and baseline requests that inform workflow design.

### 2.2 n8n as an Event-Driven API Orchestrator
While Postman is built for manual API probing, **n8n** turns API requests into resilient, production-grade automated pipelines:
- **Declarative Nodes:** Visual nodes abstract low-level HTTP boilerplate (TCP sockets, SSL handshakes, connection pooling).
- **JSON Item Streaming:** n8n treats every JSON object as an independent data item, enabling native batching and filtering.
- **Node Pinning:** Embedded mock test fixtures allow developers to verify canvas transformation logic instantly without saturating external rate limits.

### 2.3 The Mock API Sandbox Paradigm
Using production APIs for learning introduces security hazards, credential rotation overhead, and accidental data corruption. Sandbox mock servers like **JSONPlaceholder** provide:
- Realistic RESTful resources (`/users`, `/posts`, `/todos`).
- Idempotent and safe operations (`GET`).
- Predictable schema structures with zero API key dependencies.

---

## 3. Business Requirements Document (BRD)

| ID | Requirement | Business Rationale | Impact | Priority |
| :--- | :--- | :--- | :--- | :--- |
| **BRD-001** | Standardized Developer Workspace Setup | Ensure consistent developer environments across Windows, macOS, and Linux. | Reduces onboarding setup time from days to under 15 minutes. | High |
| **BRD-002** | Zero-Cost API Sandbox Exploration | Provide safe, rate-limit-tolerant REST sandbox environments for testing. | Eliminates billing overhead and credential compromise risk. | Critical |
| **BRD-003** | Dual Tool Verification Methodology | Validate API contracts in Postman before assembling n8n automation graphs. | Reduces workflow authoring errors by 80%. | High |
| **BRD-004** | Deterministic JSON Output Logging | Ensure clean normalization of API arrays into discrete, typed workflow items. | Guarantees downstream reliability and schema compliance. | High |
| **BRD-005** | Offline Development Readiness | Embed pre-pinned test data in n8n nodes for 100% offline verification. | Allows canvas demonstrations without network bottlenecks. | Medium |

---

## 4. Product Requirements Document (PRD)

| ID | Capability | User Story & Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **PRD-001** | Postman Workspace Initialization | As a developer, I want a private workspace `n8n_API_Trainee_Workspace` so my requests are organized. | High |
| **PRD-002** | Postman GET Execution | As an engineer, I want to execute `GET https://jsonplaceholder.typicode.com/users` and inspect the 200 OK status. | High |
| **PRD-003** | n8n Manual Trigger | As a workflow builder, I want a manual start node so I can execute my workflow on demand. | Critical |
| **PRD-004** | n8n HTTP Request Configuration | As an integrator, I want an HTTP Request node configured with method GET and JSON parsing enabled. | Critical |
| **PRD-005** | Record Normalization Engine | As a data engineer, I want a Code node to filter and reformat raw user fields into verified profile schema. | High |
| **PRD-006** | Execution Telemetry Summary | As an auditor, I want a terminal node that outputs execution metrics (record count, status code, timestamp). | High |

---

## 5. Software Requirements Specification (SRS) & Canvas Blueprint

### 5.1 Pipeline Canvas Architecture
```text
[ N01-01: Manual_Trigger ]
            │
            ▼
[ N01-02: HTTP_GetUsers ] ─────────> GET https://jsonplaceholder.typicode.com/users
            │                        (Returns 10 mock user profiles)
            ▼
[ N01-03: Code_ValidateAndFormatUsers ] ──> Normalizes user fields:
            │                               id, fullName, username, email, city, company
            ▼
[ N01-04: Code_ExecutionSummary ] ─────────> Emits terminal execution telemetry:
                                             status: API_GET_QUERY_SUCCESSFUL, count: 10
```

---

## 6. Detailed Node Configuration Blueprint

| Node Name | Node Type | Version | Operational Function & Settings |
| :--- | :--- | :--- | :--- |
| **Manual_Trigger** | `manualTrigger` | 1 | Canvas trigger initiating manual testing execution on button click. |
| **HTTP_GetUsers** | `httpRequest` | 4.2 | **Method:** `GET`<br>**URL:** `https://jsonplaceholder.typicode.com/users`<br>**Auth:** None<br>**Format:** JSON |
| **Code_ValidateAndFormatUsers** | `code` | 2 | Pure ECMAScript 6 loop unrolling 10 user profiles into standardized schema with `status: VERIFIED_ACTIVE`. |
| **Code_ExecutionSummary** | `code` | 2 | Aggregates pipeline metrics, calculates record counts, and emits audit timestamp. |

---

## 7. Testing & Quality Assurance Verification Plan

| Scenario ID | Test Condition | Input Data Profile | Expected Execution Route | Verification Checkpoint |
| :--- | :--- | :--- | :--- | :--- |
| **TC-01-01** | Postman GET Execution | `GET https://jsonplaceholder.typicode.com/users` | Direct HTTP request via Postman client. | Status `200 OK`, 10 JSON records visible in Pretty Body tab. |
| **TC-01-02** | n8n Canvas 1-Click Execution | Click "Execute workflow" / "Test step". | Manual Trigger $ightarrow$ HTTP_GetUsers $ightarrow$ Validate $ightarrow$ Summary. | 100% green checkmarks across all canvas nodes. |
| **TC-01-03** | Data Schema Verification | JSONPlaceholder user payload. | Verified fields: `userId`, `fullName`, `email`, `city`, `companyName`. | Field values match mock schema exactly. |
| **TC-01-04** | Offline PinData Resilience | Canvas execution in disconnected environment. | Pinned data fixtures on all nodes. | Instantaneous execution with zero timeout errors. |

---

## 8. Operational Guidelines & Best Practices
- **Never hardcode production credentials:** For authenticated APIs, always use n8n Credentials store instead of raw header parameters.
- **Inspect headers and rate limits:** Always examine `X-RateLimit-Limit` and `Retry-After` headers on external SaaS gateways.
- **Keep Code nodes pure:** Avoid non-standard Node.js built-ins to maintain zero-blocker compatibility in cloud n8n environments.
