# Topic 2: Making Your First API Calls (CRUD Operations)
## Official Technical Requirement Specification & Architecture Blueprint

---

## 1. Document Control
| Field | Specification Value |
| :--- | :--- |
| **Document Title** | Topic 2: Making Your First API Calls (CRUD Operations) Specification |
| **Course Module** | API Integration Hands-On for n8n (Level 3 - Enterprise Series) |
| **Version** | 1.0 (Production Master) |
| **Status** | Approved & Verified |
| **Last Updated** | 2026-11-06 |
| **Prepared By** | Lead Solutions Architect & Automation Engineering Team |
| **Target Audience** | Integration Engineers, API Developers, Automation Trainees |

---

## 2. Learning Concepts & Architectural Principles

### 2.1 The REST Architectural Style & HTTP Verbs
Representational State Transfer (REST) relies on standardized HTTP methods to perform operations on server resources:
1. **GET (Read):** Retrieves resource state without side effects (Idempotent & Safe). Supports pagination, filtering, and sorting via URL Query Parameters (`?page=2`).
2. **POST (Create):** Submits data in the request body to create a subordinate resource. Returns `201 Created` along with a server-generated identifier and timestamp.
3. **PUT (Full Replace):** Overwrites an entire resource representation at a specific URI (Idempotent). Returns `200 OK` with update confirmation.
4. **DELETE (Remove):** Purges the targeted resource from the server. Returns `204 No Content` or `200 OK`.

### 2.2 HTTP Status Code Classification
Understanding server response codes is critical for building resilient automation error handling:
- **`200 OK`**: Standard success for GET and PUT queries.
- **`201 Created`**: Successful resource instantiation via POST.
- **`204 No Content`**: Action succeeded without payload return (standard for DELETE).
- **`4xx Client Errors`**: Request contains invalid syntax, missing parameters, or nonexistent resource identifiers.

### 2.3 Sequential CRUD Orchestration in n8n
Unlike isolated client tools, n8n executes CRUD requests as an integrated pipeline:
- Downstream nodes can dynamically inherit identifiers produced by upstream actions (e.g., passing `id` from POST into PUT and DELETE).
- Built-in node pinning enables developers to test individual verbs without repeatedly modifying production state.

---

## 3. Business Requirements Document (BRD)

| ID | Requirement | Business Rationale | Impact | Priority |
| :--- | :--- | :--- | :--- | :--- |
| **BRD-001** | Full CRUD Lifecycle Validation | Master all 4 primary HTTP verbs within a single unified workflow. | Eliminates manual CRUD scripts; standardizes integration patterns. | High |
| **BRD-002** | Structured Query Parameterization | Support URL query string variables for pagination and resource filtering. | Prevents URL concatenation errors and injection vulnerabilities. | High |
| **BRD-003** | JSON Body Serialization | Accurately construct and transmit JSON payloads in POST and PUT operations. | Ensures schema compliance with external REST microservices. | Critical |
| **BRD-004** | Status Code Dissection & Handling | Correctly interpret `200`, `201`, and `204` response semantics across tools. | Prevents false-negative error triggers on empty 204 responses. | High |
| **BRD-005** | Zero-Blocker PinData Coverage | Provide pre-pinned mock data across all nodes for offline execution. | Guarantees instant 1-click execution for trainees and CI/CD pipelines. | Medium |

---

## 4. Product Requirements Document (PRD)

| ID | Capability | User Story & Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **PRD-001** | Paginated GET Request | As an engineer, I want to fetch page 2 of users using query params (`page: 2`) and receive HTTP 200. | High |
| **PRD-002** | POST Resource Creation | As a developer, I want to post Alice Smith's profile and receive HTTP 201 with generated `id` and `createdAt`. | Critical |
| **PRD-003** | PUT Resource Replacement | As an admin, I want to update Alice's title to Lead Engineer via PUT and verify `updatedAt`. | High |
| **PRD-004** | DELETE Resource Removal | As an operator, I want to issue a DELETE to `/users/2` and verify an HTTP 204 No Content response. | High |
| **PRD-005** | Lifecycle Audit Ledger | As an auditor, I want a final Code node summarizing all 4 operations with execution timestamps. | High |

---

## 5. Software Requirements Specification (SRS) & Canvas Blueprint

### 5.1 Pipeline Canvas Architecture
```text
[ N02-01: Manual_Trigger ]
            │
            ▼
[ N02-02: HTTP_GetUsersPage2 ] ────> GET https://reqres.in/api/users?page=2 (HTTP 200 OK)
            │
            ▼
[ N02-03: HTTP_CreateUser ] ───────> POST https://reqres.in/api/users (HTTP 201 Created)
            │                        Body: { "name": "Alice Smith", "job": "Software Engineer" }
            ▼
[ N02-04: HTTP_UpdateUser ] ───────> PUT https://reqres.in/api/users/2 (HTTP 200 OK)
            │                        Body: { "name": "Alice Jones", "job": "Lead Engineer" }
            ▼
[ N02-05: HTTP_DeleteUser ] ───────> DELETE https://reqres.in/api/users/2 (HTTP 204 No Content)
            │
            ▼
[ N02-06: Code_AuditSummary ] ─────> Emits complete CRUD verification receipt
```

---

## 6. Detailed Node Configuration Blueprint

| Node Name | Node Type | Version | Operational Function & Settings |
| :--- | :--- | :--- | :--- |
| **Manual_Trigger** | `manualTrigger` | 1 | Canvas trigger initiating manual testing execution on button click. |
| **HTTP_GetUsersPage2** | `httpRequest` | 4.2 | **Method:** `GET`<br>**URL:** `https://reqres.in/api/users`<br>**Query:** `page=2` |
| **HTTP_CreateUser** | `httpRequest` | 4.2 | **Method:** `POST`<br>**URL:** `https://reqres.in/api/users`<br>**Body:** JSON Alice Smith profile |
| **HTTP_UpdateUser** | `httpRequest` | 4.2 | **Method:** `PUT`<br>**URL:** `https://reqres.in/api/users/2`<br>**Body:** JSON Alice Jones update |
| **HTTP_DeleteUser** | `httpRequest` | 4.2 | **Method:** `DELETE`<br>**URL:** `https://reqres.in/api/users/2`<br>**Options:** Expects HTTP 204/200 |
| **Code_AuditSummary** | `code` | 2 | Consolidates end-to-end execution receipt verifying all 4 HTTP methods. |

---

## 7. Testing & Quality Assurance Verification Plan

| Scenario ID | Test Condition | Input Data Profile | Expected Execution Route | Verification Checkpoint |
| :--- | :--- | :--- | :--- | :--- |
| **TC-02-01** | Query Parameter GET | `page=2` | `GET https://reqres.in/api/users?page=2` | Status 200 OK, returns 6 records starting with ID 7 (Michael Lawson). |
| **TC-02-02** | Payload POST Creation | Alice Smith JSON body | `POST https://reqres.in/api/users` | Status 201 Created, returns generated ID `721` and `createdAt`. |
| **TC-02-03** | Resource PUT Update | Alice Jones JSON body | `PUT https://reqres.in/api/users/2` | Status 200 OK, returns updated title and `updatedAt` timestamp. |
| **TC-02-04** | Resource DELETE Removal | Target resource ID 2 | `DELETE https://reqres.in/api/users/2` | Status 204 No Content (or 200 OK), resource removed. |
| **TC-02-05** | Complete Canvas Pipeline Run | 1-Click "Execute workflow" | All 5 nodes execute sequentially. | 100% green checkmarks across all canvas nodes. |

---

## 8. Operational Guidelines & Best Practices
- **Handle Empty 204 Responses:** In n8n HTTP Request node, configure response handling so that empty bodies from `204 No Content` do not trigger false failure exceptions.
- **Idempotency Awareness:** Remember that GET, PUT, and DELETE should be idempotent; repeating them yields identical server state, whereas POST creates duplicate records if replayed.
- **Use Dynamic Parameter References:** In production, wire the generated `id` from the POST response into downstream PUT and DELETE nodes via `{{ $node["HTTP_CreateUser"].json["id"] }}`.
