# Project 10: Aviation MRO Airworthiness, Flight Telemetry & AOG Dispatch Mesh (`Aero-MRO-Sync`)
## Project Code: `N8N-API-AERO-PRJ-10`
**Evaluator:** Deepesh Jain | **Passing Score:** 75.0 / 100.0 | **Target:** 100.0 / 100.0 (High Distinction)

---

## Executive Summary
**Aero-MRO-Sync** is an enterprise-grade autonomous flight telemetry and MRO dispatch mesh built natively inside **n8n**. It ingests real-time ACARS datalinks, cryptographically verifies payloads using HMAC-SHA256, computes dual-constraint Life-Limited Part (LLP) wear, executes Haversine nearest-hub routing for certified inventory, enforces FAA Form 8130-3 anti-counterfeit validation, pauses for Chief Inspector Human-in-the-Loop (HITL) authorization, and orchestrates a 4-tier RESTful maintenance dispatch mesh.

---

## Key Features & Regulatory Adherence
1. **Zero-Trust Datalink Ingestion:** Constant-time HMAC-SHA256 (`crypto.timingSafeEqual`), ±300s window drift validation, and replay deduplication cache.
2. **Dual-Constraint RUL Engine:** Evaluates flight hours ($4.0\%$) vs. flight cycles ($3.0\%$), asserting $\min(RUL_h, RUL_c) = 3.0\% \le 5.0\%$ to trigger mandatory AOG grounding.
3. **Haversine Geolocation Engine:** Filters $certifiedStock > 0$ and calculates great-circle distance to select Detroit Metro (DTW, 376.5 km) over ATL (975.5 km) and LAX (2,801.9 km).
4. **Anti-SUP Compliance Gate:** Parses FAA Form 8130-3 release certificate and verifies remaining cycles match the ledger checksum ($10000 === 10000$).
5. **Human-in-the-Loop (HITL) Gate:** Licensed Chief Inspector airworthiness sign-off per FAA 14 CFR § 43.7.
6. **4 REST CRUD Dispatch Mesh:**
   - `POST /v1/aog/work-orders` (Hot-shot courier dispatch from DTW)
   - `PUT /v1/fleet/N842UA/airworthiness` (`AOG_GROUNDED`)
   - `PATCH /v1/parts/SN-SPARE-DTW04/status` (`RESERVED_AOG`)
   - `DELETE /v1/gates/GATE-ORD-B14` (Release departure gate)

---

## File Inventory
```
Project_10_Aero_MRO_Sync/
├── Project 10 - Aero-MRO-Sync Workflow.json  # Complete n8n workflow with embedded pinData (1-Click Run)
├── Postman_Collection_Aero_MRO_Sync.json    # Automated 7-scenario regression test collection
├── schema.sql                               # PostgreSQL DDL for audit tables & DLQ
├── faa_8130_3_release_cert.txt              # Synthetic FAA Form 8130-3 digital release tag
├── n8n_project_10_requirement_document.md   # Comprehensive BRD, PRD, SRS specification
├── n8n_project_10_requirement_document.pdf  # Compiled PDF specification
├── Project_10_Implementation_Plan.md        # Step-by-step implementation & defense guide
├── Project_10_Implementation_Plan.pdf       # Compiled PDF implementation plan
└── README.md                                # Repository guide & evaluation overview
```

---

## 1-Click Verification in n8n
1. Open n8n canvas.
2. Click **Workflow Settings -> Import from File**.
3. Select `Project 10 - Aero-MRO-Sync Workflow.json`.
4. Click **Test Step** or **Execute Workflow**.
5. All 13 core nodes execute instantly and light up green using embedded `pinData`!

---

## Automated Testing Suite (Postman)
Import `Postman_Collection_Aero_MRO_Sync.json` into Postman and execute the collection runner:
- **TC-01:** Complete End-to-End AOG Workflow Execution (Asserts RUL=3.0%, DTW selected, all 4 CRUD ops succeed).
- **TC-02:** Invalid HMAC Signature Rejection (`401 Unauthorized`).
- **TC-03:** Expired Timestamp Replay Attack (`400 Bad Request`).
- **TC-04:** Normal Flight Telemetry Routing to DLQ (RUL=15.0%, no AOG).
- **TC-05:** Zero Certified Stock Hub Rejection (`422 Unprocessable`).
- **TC-06:** Suspected Unapproved Part (SUP) Checksum Mismatch (`422 Unprocessable`).
- **TC-07:** Chief Inspector HITL Disapproval Gate (`403 Forbidden`).
