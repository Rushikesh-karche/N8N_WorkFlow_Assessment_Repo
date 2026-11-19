# Topic 5: Building API Workflows in n8n (Chaining, Ancestor Lookups & Date Transforms)
## Official Technical Requirement Specification & Architecture Blueprint

---

## 1. Document Control
| Field | Specification Value |
| :--- | :--- |
| **Document Title** | Topic 5: Building API Workflows in n8n Specification |
| **Course Module** | API Integration Hands-On for n8n (Level 3 - Enterprise Series) |
| **Version** | 1.0 (Production Master) |
| **Status** | Approved & Verified |
| **Last Updated** | 2026-11-19 |
| **Prepared By** | Lead Solutions Architect & Automation Engineering Team |
| **Target Audience** | Integration Engineers, API Developers, DevOps Engineers, Automation Trainees |

---

## 2. Learning Concepts & Architectural Principles

### 2.1 Sequential API Chaining & Pipeline Composition
Real-world business processes require orchestrating multiple distributed services sequentially where downstream actions depend on context generated several steps upstream:
1. **The Context Loss Challenge:** In linear data pipelines, each node replaces the active `$json` payload with its own output. Without referencing prior state, variables from earlier nodes become unreachable.
2. **The Ancestor Lookup Solution:** n8n's `$('Node Name').item.json` syntax allows developers to cross-reference any preceding node across the canvas regardless of topological distance.
3. **Data Merging Without Bloat:** Eliminates unnecessary temporary merger nodes by selectively pulling exact ancestor fields into downstream payloads.

### 2.2 Built-In Luxon Date & Time Transformations
Modern APIs mandate strict timestamp formatting (ISO-8601, RFC-2822, or custom SQL datetime strings):
- **`$now` Object:** Native Luxon DateTime object representing instantaneous execution time.
- **ISO-8601 Strings:** `$now.toISOString()` emits standardized UTC timestamps (e.g. `2026-11-19T14:15:00.000Z`).
- **Relative Date Math:** `$now.minus({ hours: 1 })` or `$now.plus({ days: 7 })` enables rolling window queries and SLA deadlines.
- **Custom Format Masks:** `toFormat('yyyy-MM-dd HH:mm:ss')` transforms dates without requiring external third-party formatting libraries.

### 2.3 System Context Metadata & Observability
Enterprise automations must preserve audit trails for tracing and debugging:
- **`$executionId`:** Unique identifier assigned to every workflow execution run.
- **`$workflowId`:** Static identifier of the executing workflow definition.
- **Observability Best Practice:** Propagating execution telemetry into external log entries guarantees end-to-end traceability across microservices.

---

## 3. Business Requirements Document (BRD)

| ID | Requirement | Business Rationale | Impact | Priority |
| :--- | :--- | :--- | :--- | :--- |
| **BRD-001** | Multi-Hop Context Preservation | Seamlessly access ancestor variables without canvas clutter or manual pass-through staging. | Reduces workflow node count by 40%. | High |
| **BRD-002** | Dynamic Header Generation | Inject dynamic transaction timestamps and department context into HTTP request headers. | Guarantees audit compliance across microservice gateways. | High |
| **BRD-003** | Precision Date Formatting | Format UTC timestamps into custom database formats using native Luxon operations. | Eliminates date parsing errors and time zone drift. | High |
| **BRD-004** | Execution Telemetry Capture | Automatically bind system execution and workflow identifiers to outbound log payloads. | Accelerates incident triage from hours to seconds. | Critical |
| **BRD-005** | Offline PinData Resilience | Provide embedded mock data on every node for instant 1-click execution. | Facilitates zero-blocker training and CI/CD validation. | Medium |

---

## 4. Product Requirements Document (PRD)

| ID | Capability | User Story & Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **PRD-001** | Base User State Staging | Set node establishing `username: "Alice"` and `department: "Engineering"`. | High |
| **PRD-002** | Dynamic Header Injection | HTTP GET to Postman Echo sending `X-Transaction-Time` and `X-User-Dept`. | High |
| **PRD-003** | Ancestor Lookup Outbound POST | HTTP POST to JSONPlaceholder referencing `$('Set Base User').item.json.username`. | Critical |
| **PRD-004** | Luxon Time Calculation | Post body contains timestamp formatted 1 hour in the past via `$now.minus({ hours: 1 })`. | High |
| **PRD-005** | Metadata Aggregation | Set node capturing `executionId`, `workflowId`, and `finalLogTitle`. | High |
| **PRD-006** | End-to-End Audit Verification | Terminal Code node verifying that all ancestor keys and system variables resolved correctly. | High |

---

## 5. Software Requirements Specification (SRS) & Canvas Blueprint

### 5.1 Pipeline Canvas Architecture
```text
[ N05-01: Manual_Trigger ]
            │
            ▼
[ N05-02: Set Base User ] ─────────────> Defines base context:
            │                            - username: "Alice"
            │                            - department: "Engineering"
            ▼
[ N05-03: Postman Echo Headers ] ──────> GET https://postman-echo.com/headers
            │                            Headers:
            │                            - X-Transaction-Time: {{ $now.toISOString() }}
            │                            - X-User-Dept: {{ $json.department }}
            ▼
[ N05-04: Create Log Entry ] ──────────> POST https://jsonplaceholder.typicode.com/posts
            │                            Body:
            │                            - title: "Log entry for {{ $('Set Base User').item.json.username }}"
            │                            - body: "User-Agent utilized was {{ $json.headers['user-agent'] }}"
            │                            - timestamp: "{{ $now.minus({ hours: 1 }).toFormat(...) }}"
            ▼
[ N05-05: Output Metadata ] ───────────> Captures execution telemetry:
            │                            - executionId: {{ $executionId }}
            │                            - workflowId: {{ $workflowId }}
            │                            - finalLogTitle: {{ $json.title }}
            ▼
[ N05-06: Code_AuditSummary ] ─────────> Synthesizes complete 100% PASS chaining receipt
```

---

## 6. Detailed Node Configuration Blueprint

| Node Name | Node Type | Version | Operational Function & Settings |
| :--- | :--- | :--- | :--- |
| **Manual_Trigger** | `manualTrigger` | 1 | Canvas trigger initiating manual testing execution on button click. |
| **Set Base User** | `set` | 3.4 | Stores static user metadata: `username: "Alice"`, `department: "Engineering"`. |
| **Postman Echo Headers** | `httpRequest` | 4.2 | Method: GET, URL: `https://postman-echo.com/headers`. Transmits dynamic ISO timestamp and user department headers. |
| **Create Log Entry** | `httpRequest` | 4.2 | Method: POST, URL: `https://jsonplaceholder.typicode.com/posts`. Cross-references ancestor username and parent user-agent. |
| **Output Metadata** | `set` | 3.4 | Maps system variables: `$executionId`, `$workflowId`, and upstream `$json.title`. |
| **Code_AuditSummary** | `code` | 2 | Consolidates end-to-end chaining audit receipt verifying ancestor resolution and execution metrics. |

---

## 7. Testing & Quality Assurance Verification Plan

| Scenario ID | Test Condition | Expression Evaluated | Expected Result & Verification |
| :--- | :--- | :--- | :--- |
| **TC-05-01** | Dynamic ISO Header | `{{ $now.toISOString() }}` | Valid ISO-8601 UTC timestamp (e.g. `2026-11-19T14:15:00.000Z`). |
| **TC-05-02** | Parent Department Header | `{{ $json.department }}` | Echoed header contains `"x-user-dept": "Engineering"`. |
| **TC-05-03** | 2-Hop Ancestor Lookup | `{{ $('Set Base User').item.json.username }}` | Outbound title resolves to `"Log entry for Alice"`. |
| **TC-05-04** | Immediate Parent Header | `{{ $json.headers['user-agent'] }}` | Outbound body resolves to `"User-Agent utilized was axios/1.7.4"`. |
| **TC-05-05** | Luxon Relative Date Math | `{{ $now.minus({ hours: 1 }).toFormat('yyyy-MM-dd HH:mm:ss') }}` | Formats timestamp exactly 1 hour prior in standard SQL format. |
| **TC-05-06** | System Telemetry Extraction | `{{ $executionId }}`, `{{ $workflowId }}` | Outputs internal non-empty execution and workflow IDs. |
| **TC-05-07** | 1-Click Instant Canvas Run | Click "Execute workflow" | 100% green checkmarks across all canvas nodes. |

---

## 8. Operational Guidelines & Best Practices
- **Robust Node Renaming:** Always use descriptive, unique node names because ancestor lookups bind directly to the string literal `$('Node Name')`. Renaming an upstream node automatically prompts n8n to update downstream references.
- **UTC Time Invariance:** Always store and transmit dates in standard UTC ISO-8601 formatting, converting to localized formatting only at terminal notification layers.
- **Safe Bracket Notation:** When accessing HTTP headers that contain hyphens (e.g., `user-agent`, `content-type`), always use bracket notation (`$json.headers['user-agent']`) rather than dot notation.
