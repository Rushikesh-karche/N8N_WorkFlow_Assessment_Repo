# Topic 3: Working with JSON Data (Hierarchy, Dot-Notation & Array Indexing)
## Official Technical Requirement Specification & Architecture Blueprint

---

## 1. Document Control
| Field | Specification Value |
| :--- | :--- |
| **Document Title** | Topic 3: Working with JSON Data Specification |
| **Course Module** | API Integration Hands-On for n8n (Level 3 - Enterprise Series) |
| **Version** | 1.0 (Production Master) |
| **Status** | Approved & Verified |
| **Last Updated** | 2026-11-09 |
| **Prepared By** | Lead Solutions Architect & Automation Engineering Team |
| **Target Audience** | Integration Engineers, API Developers, Automation Trainees |

---

## 2. Learning Concepts & Architectural Principles

### 2.1 The Omnipresence of Hierarchical JSON in APIs
Modern RESTful web services rarely emit flat key-value pairs. Real-world payloads—such as invoices, order requisitions, and customer profiles—are structured hierarchically with:
1. **Nested Objects:** Grouping related attributes (e.g., `customer.contact.email`).
2. **Homogeneous Collections (Arrays):** Containing multiple line items (e.g., `purchasedItems[0]`).
3. **Nullables and Optionals:** Representing conditional fields (`discountCode: null`).

### 2.2 Dot-Notation vs Bracket Indexing in n8n Expressions
n8n leverages JavaScript expression syntax wrapped in double curly braces `{{ ... }}`:
- **Dot-Notation (`.`):** Used to traverse deep object properties:
  ```javascript
  {{ $json.customer.contact.email }} // Resolves to "johndoe@example.com"
  ```
- **0-Based Bracket Indexing (`[0]`):** Used to access specific elements in arrays:
  ```javascript
  {{ $json.purchasedItems[0].name }}  // Resolves to "Wireless Mouse"
  {{ $json.purchasedItems[0].price }} // Resolves to 25.99
  ```
- **String Interpolation:** Concatenating variables seamlessly:
  ```javascript
  {{ $json.customer.firstName }} {{ $json.customer.lastName }} // Resolves to "John Doe"
  ```

### 2.3 Cross-Node Expression Mapping & Payload Construction
Extracted variables can immediately be injected into downstream HTTP payloads without temporary database staging, enabling ultra-fast, memory-efficient data enrichment.

---

## 3. Business Requirements Document (BRD)

| ID | Requirement | Business Rationale | Impact | Priority |
| :--- | :--- | :--- | :--- | :--- |
| **BRD-001** | Complex Schema Ingestion | Accept multi-level nested receipt schemas without parsing errors. | Eliminates manual pre-flattening scripts. | High |
| **BRD-002** | Precise Hierarchy Traversal | Extract deeply nested contact details via dot notation. | Prevents silent null pointer exceptions. | Critical |
| **BRD-003** | Array Element Isolation | Access specific line items via zero-based array index notation. | Guarantees exact item-level transaction accounting. | High |
| **BRD-004** | Dynamic Outbound Serialization | Inject dynamic variables into outbound REST notification payloads. | Accelerates customer communication automation. | High |
| **BRD-005** | Complete Canvas Testability | Provide pre-pinned test data on every node for 1-click execution. | Facilitates zero-blocker training and CI/CD validation. | Medium |

---

## 4. Product Requirements Document (PRD)

| ID | Capability | User Story & Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **PRD-001** | Nested Mock Data Staging | As a developer, I want a Set node loading an invoice receipt with customer and item arrays. | High |
| **PRD-002** | Dot-Notation Email & Name Extraction | As an integrator, I want to extract `customerEmail` and composite `fullName` via expressions. | Critical |
| **PRD-003** | Array Index Item Access | As a billing specialist, I want to fetch the first purchased item's name and price via `[0]`. | High |
| **PRD-004** | Dynamic HTTP POST Dispatch | As a notification service, I want to POST to JSONPlaceholder with title and body referencing extracted keys. | High |
| **PRD-005** | Audit Verification Ledger | As an auditor, I want a final Code node confirming all traversed keys and the outbound 201 response. | High |

---

## 5. Software Requirements Specification (SRS) & Canvas Blueprint

### 5.1 Pipeline Canvas Architecture
```text
[ N03-01: Manual_Trigger ]
            │
            ▼
[ N03-02: Mock Invoice Data ] ─────────> Defines receipt REC-9988 with nested customer & purchasedItems
            │
            ▼
[ N03-03: Extract Customer Data ] ─────> Evaluates dot-notation & array indexing:
            │                            - customerEmail: {{ $json.customer.contact.email }}
            │                            - fullName: {{ $json.customer.firstName }} {{ $json.customer.lastName }}
            │                            - firstItemName: {{ $json.purchasedItems[0].name }}
            │                            - firstItemPrice: {{ $json.purchasedItems[0].price }}
            ▼
[ N03-04: HTTP_SendNotification ] ─────> POST https://jsonplaceholder.typicode.com/posts
            │                            Body: { "title": "New Purchase for John Doe", ... }
            ▼
[ N03-05: Code_AuditSummary ] ─────────> Emits terminal validation receipt confirming 100% PASS
```

---

## 6. Detailed Node Configuration Blueprint

| Node Name | Node Type | Version | Operational Function & Key Configuration |
| :--- | :--- | :--- | :--- |
| **Manual_Trigger** | `manualTrigger` | 1 | Canvas testing trigger for immediate execution. |
| **Mock Invoice Data** | `set` | 3.4 | **Mode:** Raw JSON.<br>Loads invoice schema (`receiptId`, `customer`, `purchasedItems`). |
| **Extract Customer Data** | `set` | 3.4 | **Mode:** Fields.<br>Extracts `customerEmail`, `fullName`, `firstItemName`, `firstItemPrice`. |
| **HTTP_SendNotification** | `httpRequest` | 4.2 | **Method:** POST.<br>**URL:** `https://jsonplaceholder.typicode.com/posts`<br>**Body:** Dynamic JSON. |
| **Code_AuditSummary** | `code` | 2 | Consolidates end-to-end traversal receipt verifying all expressions and outbound API returns. |

---

## 7. Testing & Quality Assurance Verification Plan

| Scenario ID | Test Condition | Expression Evaluated | Expected Resolved Value | Verification Checkpoint |
| :--- | :--- | :--- | :--- | :--- |
| **TC-03-01** | Deep Dot-Notation Email | `{{ $json.customer.contact.email }}` | `"johndoe@example.com"` | Field matches nested contact object value exactly. |
| **TC-03-02** | Composite Name String | `{{ $json.customer.firstName }} {{ $json.customer.lastName }}` | `"John Doe"` | Both first and last names concatenated with single space. |
| **TC-03-03** | First Array Element Name | `{{ $json.purchasedItems[0].name }}` | `"Wireless Mouse"` | Zero-based index correctly extracts item 0 name. |
| **TC-03-04** | First Array Element Price | `{{ $json.purchasedItems[0].price }}` | `25.99` | Zero-based index correctly extracts numeric float. |
| **TC-03-05** | Dynamic Outbound HTTP POST | Title & Body referencing extracted variables | Status `201 Created` with ID 101 | Transmitted payload matches resolved expression strings. |
| **TC-03-06** | 1-Click Instant Canvas Run | Click "Execute workflow" | All 5 nodes execute | 100% green checkmarks across entire canvas. |

---

## 8. Operational Guidelines & Best Practices
- **Null-Safety Guardrails:** In production, use optional chaining or fallback operators (`{{ $json.customer?.contact?.email || 'N/A' }}`) to prevent workflow termination if an upstream object key is missing.
- **Array Boundary Checks:** Always ensure array length is verified before referencing higher indices (e.g., `[1]` or `[2]`).
- **Data Type Preservation:** Notice that `firstItemPrice` is defined as a `number` type in the Set node to maintain financial numeric precision.
