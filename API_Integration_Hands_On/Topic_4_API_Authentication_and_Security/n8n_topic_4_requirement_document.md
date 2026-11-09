# Topic 4: API Authentication and Security (Basic Auth, Bearer Tokens, OAuth 2.0 & JWT)
## Official Technical Requirement Specification & Architecture Blueprint

---

## 1. Document Control
| Field | Specification Value |
| :--- | :--- |
| **Document Title** | Topic 4: API Authentication and Security Specification |
| **Course Module** | API Integration Hands-On for n8n (Level 3 - Enterprise Series) |
| **Version** | 1.0 (Production Master) |
| **Status** | Approved & Verified |
| **Last Updated** | 2026-11-09 |
| **Prepared By** | Lead Solutions Architect & Automation Engineering Team |
| **Target Audience** | Integration Engineers, API Developers, Security Engineers, Automation Trainees |

---

## 2. Learning Concepts & Architectural Principles

### 2.1 The Paradigm of Enterprise API Security
In production enterprise architectures, unauthenticated endpoints do not exist. APIs safeguard proprietary resources and customer PII across multiple authentication topologies:
1. **HTTP Basic Authentication:** Legacy standard encoding credentials as `Authorization: Basic base64(username:password)`. Suitable for simple microservices behind TLS.
2. **Bearer Token Authentication:** Modern token-based authorization passing bearer access tokens in headers (`Authorization: Bearer <token>`).
3. **OAuth 2.0 Delegation Protocol:** Industry standard enabling third-party applications to obtain limited access to an HTTP service on behalf of a resource owner without exposing user credentials.
4. **JSON Web Tokens (JWT):** Stateless, digitally signed claims containers enabling cross-service identity propagation without repeated database lookups.

### 2.2 n8n Decoupled Credential Store
A core principle of security hygiene is separating code/canvas logic from cryptographic credentials:
- **Zero Plain-Text Leakage:** Exporting workflow JSON files completely strips sensitive passwords, API keys, and client secrets.
- **Environment Reusability:** A single Basic Auth or OAuth credential can power dozens of distinct workflows across an enterprise workspace.
- **Automated Lifecycle Management:** n8n automatically tracks OAuth token expiration timestamps and handles refresh-token exchanges without human intervention.

### 2.3 JWT Tripartite Anatomy
A JSON Web Token consists of three distinct URL-safe Base64URL-encoded strings:
- **Header:** `{"alg": "HS256", "typ": "JWT"}` (specifies signature hashing algorithm).
- **Payload:** `{"sub": "1234567890", "name": "John Doe", "admin": true}` (contains identity and authorization claims).
- **Signature:** Cryptographic verification hash preventing payload tampering.

---

## 3. Business Requirements Document (BRD)

| ID | Requirement | Business Rationale | Impact | Priority |
| :--- | :--- | :--- | :--- | :--- |
| **BRD-001** | Secure Credential Isolation | Prevent plain-text secrets and tokens from leaking in exported workflow JSON. | Ensures compliance with SOC2, ISO27001, and GDPR. | Critical |
| **BRD-002** | Multi-Protocol Authentication | Support Basic Auth, Header Auth, and OAuth 2.0 within standardized workflows. | Eliminates custom authentication wrappers. | High |
| **BRD-003** | Stateless Identity Deconstruction | Parse and validate incoming JWT payload claims natively inside automation steps. | Accelerates role-based decision routing. | High |
| **BRD-004** | Echo Header Verification | Validate that external API servers receive expected authorization headers. | Proves zero-loss header propagation. | High |
| **BRD-005** | Complete Canvas Testability | Provide pre-pinned mock data across all nodes for instant 1-click execution. | Guarantees zero-blocker training and CI/CD validation. | Medium |

---

## 4. Product Requirements Document (PRD)

| ID | Capability | User Story & Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **PRD-001** | Basic Auth Execution | As an engineer, I want an HTTP Request node with Basic Auth returning `authenticated: true`. | High |
| **PRD-002** | Header Token Transmission | As a developer, I want to send `Authorization: Bearer my_secret_token_9988` and verify echo receipt. | High |
| **PRD-003** | OAuth 2.0 Handshake Readiness | As an integrator, I want n8n's redirect URI registered in developer consoles for token refreshes. | Critical |
| **PRD-004** | Pure JS JWT Deconstruction | As a security engineer, I want a Code node deconstructing mock JWT headers, claims, and signatures. | High |
| **PRD-005** | Security Audit Summary | As an auditor, I want a terminal Code node synthesizing an end-to-end security compliance score. | High |

---

## 5. Software Requirements Specification (SRS) & Canvas Blueprint

### 5.1 Pipeline Canvas Architecture
```text
[ N04-01: Manual_Trigger ]
            │
            ▼
[ N04-02: HTTP_BasicAuth ] ────────────> GET https://postman-echo.com/basic-auth
            │                            Header: Authorization: Basic cG9zdG1hbjpwYXNzd29yZA==
            │                            Result: { "authenticated": true } (HTTP 200 OK)
            ▼
[ N04-03: HTTP_BearerTokenAuth ] ──────> GET https://postman-echo.com/headers
            │                            Header: Authorization: Bearer my_secret_token_9988
            │                            Result: Echoes header confirmation (HTTP 200 OK)
            ▼
[ N04-04: Code_DeconstructJWT ] ───────> Parses mock JWT string into:
            │                            - Header: alg=HS256, typ=JWT
            │                            - Claims: sub=1234567890, name=John Doe, admin=true
            ▼
[ N04-05: Code_AuthAuditSummary ] ─────> Synthesizes complete 100% PASS security ledger
```

---

## 6. Detailed Node Configuration Blueprint

| Node Name | Node Type | Version | Operational Function & Settings |
| :--- | :--- | :--- | :--- |
| **Manual_Trigger** | `manualTrigger` | 1 | Canvas trigger initiating manual testing execution on button click. |
| **HTTP_BasicAuth** | `httpRequest` | 4.2 | **Method:** GET.<br>**URL:** `https://postman-echo.com/basic-auth`<br>**Auth:** Basic Auth `postman:password`. |
| **HTTP_BearerTokenAuth** | `httpRequest` | 4.2 | **Method:** GET.<br>**URL:** `https://postman-echo.com/headers`<br>**Auth:** Bearer Token `my_secret_token_9988`. |
| **Code_DeconstructJWT** | `code` | 2 | Pure ECMAScript 6 base64 deconstruction parsing JWT Header, Claims, and Signature. |
| **Code_AuthAuditSummary** | `code` | 2 | Consolidates end-to-end security audit receipt verifying all 4 auth mechanisms. |

---

## 7. Testing & Quality Assurance Verification Plan

| Scenario ID | Test Condition | Credential / Payload Profile | Expected Result & Verification |
| :--- | :--- | :--- | :--- |
| **TC-04-01** | Postman Echo Basic Auth | User: `postman`, Pass: `password` | Status 200 OK, response contains `"authenticated": true`. |
| **TC-04-02** | Postman Echo Bearer Auth | `Bearer my_secret_token_9988` | Status 200 OK, echoed headers confirm token receipt. |
| **TC-04-03** | JWT Header Parsing | Encoded HS256 JWT header | Extracted object: `{"alg": "HS256", "typ": "JWT"}`. |
| **TC-04-04** | JWT Claims Extraction | Encoded John Doe JWT payload | Extracted claims: `sub="1234567890"`, `name="John Doe"`, `admin=true`. |
| **TC-04-05** | Complete Canvas Run | Click "Execute workflow" | 100% green checkmarks across entire canvas. |

---

## 8. Operational Security Hardening
- **TLS/HTTPS Invariant:** Never transmit Basic Auth credentials or Bearer tokens over unencrypted HTTP channels.
- **Short-Lived Access Tokens:** In production OAuth 2.0 implementations, configure access token expiration to $le$ 3600 seconds, delegating refresh rotations to n8n's background scheduler.
- **Never Log Sensitive Tokens:** Ensure production logging suppresses raw JWT signature blocks and authorization headers.
