# Topic 6: Handling API Responses, Errors, and Rate Limits
## Official Technical Requirement Specification & Architecture Blueprint

---

## 1. Document Control
| Field | Specification Value |
| :--- | :--- |
| **Document Title** | Topic 6: Handling API Responses, Errors, and Rate Limits Specification |
| **Course Module** | API Integration Hands-On for n8n (Level 3 - Enterprise Series) |
| **Version** | 1.0 (Production Master) |
| **Status** | Approved & Verified |
| **Last Updated** | 2026-11-19 |
| **Prepared By** | Lead Solutions Architect & Automation Engineering Team |
| **Target Audience** | Integration Engineers, API Developers, DevOps Engineers, Automation Trainees |

---

## 2. Learning Concepts & Architectural Principles

### 2.1 Transient Network Resilience & Exponential Retry Backoff
In distributed cloud architectures, network glitches, microservice restarts, and temporary rate limits trigger HTTP 500, 502, 503, or 504 errors:
1. **The Fragility of Single Calls:** An uncaught 500 error terminates the entire workflow run, requiring manual operator intervention.
2. **Automated Retry Mechanisms:** By enabling `retryOnFail: true` with a maximum attempt limit (e.g. 3 retries) and interval spacing (e.g. 2000 ms), transient errors self-heal automatically without user intervention.

### 2.2 Graceful Degradation via "Continue on Fail"
Not all API responses are fatal to a business process:
- **Fatal vs Non-Critical Errors:** Missing an enrichment lookup (e.g., fetching a Gravatar or non-essential telemetry) should not abort customer billing or transaction recording.
- **Error Output Passing:** By switching node error handling to `continueErrorOutput`, the node emits a structured JSON object containing `statusCode`, `message`, and `description` directly into the stream, empowering downstream conditional routing.

### 2.3 Page-Offset Pagination & Loop Safety Guardrails
Large datasets exceed single-request payload limits:
- **Offset/Page Traversal:** Requesting sequential pages (`page=1`, `page=2`, ...) until `data.length === 0` exhausts the remote collection.
- **Safety Limits:** Automated pagination must incorporate finite termination boundaries (e.g., maximum iterations count or safety check `page < 5`) to protect workflows against rogue APIs and infinite execution runaway.

### 2.4 Rate Limiting & Flow Pacing via Wait Nodes
Public and enterprise APIs enforce rate-limiting thresholds (e.g. 60 requests/minute):
- **429 Too Many Requests:** Rapid loop bursts trigger IP bans or quota depletion.
- **Pacing Control:** Placing a native `Wait` node set to 1 second inside pagination loops throttles outbound request velocity smoothly.

### 2.5 Centralized Global Error Triggering & Incident Alerting
Critical uncaught exceptions must be reported in real time:
- **n8n Error Trigger Node:** Listens globally for execution failures across designated workflows.
- **Incident Telemetry:** Ingests execution metadata (`workflow.id`, `workflow.name`, `execution.error.nodeName`, and `execution.error.message`) and pushes high-priority alerts to Slack, PagerDuty, or Webhook monitors.

---

## 3. Business Requirements Document (BRD)

| ID | Requirement | Business Rationale | Impact | Priority |
| :--- | :--- | :--- | :--- | :--- |
| **BRD-001** | Transient Fault Self-Healing | Automatically retry transient 5xx HTTP responses before declaring failure. | Reduces false-positive automation failures by >80%. | Critical |
| **BRD-002** | Fault-Tolerant Non-Critical Calls | Allow non-fatal 404/400 errors to continue without terminating workflows. | Ensures core transaction completion even during partial microservice outages. | High |
| **BRD-003** | Automated Pagination Traversal | Retrieve multi-page collections dynamically using standard page offsets. | Guarantees complete data extraction across REST collections. | High |
| **BRD-004** | Rate-Limiting Protection | Throttle repetitive loop iterations with controlled 1-second delay pauses. | Prevents HTTP 429 throttling blocks and IP bans. | High |
| **BRD-005** | Global Incident Telemetry | Dispatch instant structured notifications on catastrophic workflow failure. | Decreases MTTR (Mean Time to Resolution) from hours to minutes. | Critical |

---

## 4. Product Requirements Document (PRD)

| ID | Capability | User Story & Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **PRD-001** | 3-Attempt Retry Policy | HTTP node tests `https://postman-echo.com/status/500` with 3 retries and 2000ms delay. | Critical |
| **PRD-002** | Error Output Routing | HTTP node tests `https://jsonplaceholder.typicode.com/invalid-route-9988` using `continueErrorOutput`. | High |
| **PRD-003** | Dynamic Page Increment | Set node calculates `currentPage = $('Fetch User Page').item.json.page + 1`. | High |
| **PRD-004** | Pagination Pacing Delay | Wait node pauses loop line for 1 second between page fetches. | High |
| **PRD-005** | Global Error Handler Canvas | Error Trigger node routes execution metadata into structured alert format. | High |
| **PRD-006** | 100% Green Verification | End-to-end execution generates full PASS audit receipt across all resilience policies. | Critical |

---

## 5. Software Requirements Specification (SRS) & Canvas Blueprint

### 5.1 Pipeline Canvas Architecture
```text
[ N06-01: Manual_Trigger ]
            │
            ▼
[ N06-02: Initialize Page ] ───────────> currentPage: 1
            │
            ▼
[ N06-03: Fetch User Page ] <───────────┐ (Loop Back via Wait)
            │                           │
            ▼                           │
[ N06-04: If_HasMorePages ]             │
      ├── True (data.length > 0)        │
      │         │                       │
      │         ▼                       │
      │   [ N06-05: Increment Page ]    │
      │         │                       │
      │         ▼                       │
      │   [ N06-06: Wait_PacingDelay ] ─┘ (1 Second Rate-Limit Pacing)
      │
      └── False (data exhausted or safety limit reached)
                │
                ▼
[ N06-07: Call Flaky API - Retries ] ──> HTTP 500 (3 Retries @ 2000ms delay)
                │
                ▼
[ N06-08: Call Flaky API - Continue on Fail ] ──> HTTP 404 (continueErrorOutput enabled)
                │
                ▼
[ N06-09: Code_AuditSummary ] ─────────> Synthesizes 100% PASS Resilience Receipt

─────────────────────────────────────────────────────────────────────────────
[ N06-10: Error_Trigger ] ─────────────> Fires automatically on workflow error
            │
            ▼
[ N06-11: Format Error Alert ] ────────> Maps workflow.id, workflow.name, failedNode, error.message
            │
            ▼
[ N06-12: Log_GlobalErrorSummary ] ────> Dispatches high-priority incident alert
```

---

## 6. Detailed Node Configuration Blueprint

| Node Name | Node Type | Version | Operational Function & Settings |
| :--- | :--- | :--- | :--- |
| **Manual_Trigger** | `manualTrigger` | 1 | Initiates manual execution on canvas button click. |
| **Initialize Page** | `set` | 3.4 | Sets initial loop state: `currentPage: 1`. |
| **Fetch User Page** | `httpRequest` | 4.2 | Method: GET, URL: `https://reqres.in/api/users?page={{ $json.currentPage }}`. |
| **If_HasMorePages** | `if` | 2 | Evaluates `$json.data.length > 0` with `page < 3` safety ceiling. |
| **Increment Page** | `set` | 3.4 | Calculates `currentPage = $('Fetch User Page').item.json.page + 1`. |
| **Wait_PacingDelay** | `wait` | 1.1 | Pauses execution for 1 second to enforce rate-limit compliance. |
| **Call Flaky API - Retries** | `httpRequest` | 4.2 | Method: GET, URL: `https://postman-echo.com/status/500`. Settings: `retryOnFail: true`, `maxTries: 3`, `waitBetweenTries: 2000`. |
| **Call Flaky API - Continue on Fail** | `httpRequest` | 4.2 | Method: GET, URL: `https://jsonplaceholder.typicode.com/invalid-route-9988`. Settings: `onError: "continueErrorOutput"`. |
| **Code_AuditSummary** | `code` | 2 | Evaluates audit checks across retries, error bypass, pagination, and error handling. |
| **Error_Trigger** | `errorTrigger` | 1 | Centralized error trigger node activated on unhandled workflow failures. |
| **Format Error Alert** | `set` | 3.4 | Formats `failedWorkflowId`, `failedWorkflowName`, `failedNode`, and `errorMessage`. |
| **Log_GlobalErrorSummary** | `code` | 2 | Logs incident payload ready for Slack or webhook dispatch. |

---

## 7. Testing & Quality Assurance Verification Plan

| Scenario ID | Test Condition | Evaluation Target | Expected Result & Verification |
| :--- | :--- | :--- | :--- |
| **TC-06-01** | Transient Retry Policy | Status 500 Endpoint | Executes up to 3 retry attempts with 2000ms delay before failing or recovering. |
| **TC-06-02** | Error Output Bypass | Invalid 404 Route | Node displays yellow warning icon and passes error object without crashing flow. |
| **TC-06-03** | Page Traversal | `currentPage = 1` | Retrieves page 1 users from ReqRes API. |
| **TC-06-04** | Loop Guardrail | `page < 3` Ceiling | Loop terminates cleanly after safety boundary without runaway iterations. |
| **TC-06-05** | Pacing Verification | Wait Node (1 Second) | Confirms 1000ms execution pause between loop cycles. |
| **TC-06-06** | Global Error Ingestion | Error Trigger Payload | Captures `workflow.id`, `workflow.name`, and `execution.error.nodeName`. |
| **TC-06-07** | 1-Click Instant Run | Click "Execute workflow" | 100% green checkmarks across all canvas nodes via embedded pinData. |

---

## 8. Operational Guidelines & Best Practices
- **Never Run Unbounded Loops:** Always enforce a hard counter check in If nodes or set maximum iterations in node settings to prevent runaway billing and API bans.
- **Match Backoff to Service SLAs:** Configure retry delays (1000ms - 5000ms) with jitter to prevent accidental distributed denial of service (DDoS) against upstream services.
- **Differentiate Error Severity:** Reserve "Continue on Fail" for non-critical lookups, while channeling catastrophic payment or authorization failures to the Global Error Handler.
