# Topic 2: Making Your First API Calls (CRUD Operations)
## API Integration Hands-On Course for n8n

[![n8n Version](https://img.shields.io/badge/n8n-v1.x-orange.svg)](https://n8n.io)
[![Postman](https://img.shields.io/badge/Postman-v10.x-FF6C37.svg)](https://www.postman.com)
[![Status](https://img.shields.io/badge/Status-Completed--Verified-brightgreen.svg)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]()

---

## 📌 Executive Overview
Welcome to **Topic 2: Making Your First API Calls** in the **API Integration Hands-On Course for n8n**.

This module teaches developers how to execute, inspect, and automate the four core CRUD HTTP operations using the **ReqRes mock API sandbox** (`https://reqres.in`):
1. **GET Request with Query Parameters:** Fetching paginated user lists (`?page=2`) with status `200 OK`.
2. **POST Request with JSON Body:** Creating new user records (`Alice Smith`) and verifying status `201 Created` with server-generated IDs.
3. **PUT Request for Resource Replacement:** Overwriting existing records (`Alice Jones - Lead Engineer`) with status `200 OK`.
4. **DELETE Request for Resource Removal:** Purging targeted records and handling status `204 No Content`.
5. **Sequential CRUD Workflow:** Chaining all four operations into an automated n8n pipeline terminating with an audit verification summary.

---

## 🚀 Key Repository Artifacts
| File | Description |
| :--- | :--- |
| **`Topic 2 - N8N CRUD Verification Workflow.json`** | Complete importable n8n workflow with embedded `pinData` for instant 1-click execution. |
| **`n8n_topic_2_requirement_document.md`** | Comprehensive technical requirement specification covering BRD, PRD, SRS, and test specifications. |
| **`n8n_topic_2_requirement_document.pdf`** | Professional executive PDF requirement document rendered via Microsoft Edge headless mode. |
| **`Topic_2_Implementation_Plan.md`** | Step-by-step practical implementation plan with exact Postman and n8n instructions. |
| **`Topic_2_Implementation_Plan.pdf`** | Official formatted PDF implementation guide. |

---

## 🛠️ Canvas Architecture & Flow
```text
[ Manual Trigger ] ──> [ GET /api/users?page=2 ] ──> [ POST /api/users ] ──> [ PUT /api/users/2 ] ──> [ DELETE /api/users/2 ] ──> [ Audit Summary ]
```

---

## 🧪 Testing & Verification Guide
1. **Postman Verification:**
   - Execute `GET https://reqres.in/api/users?page=2` $ightarrow$ Verify `200 OK`.
   - Execute `POST https://reqres.in/api/users` with Alice Smith JSON $ightarrow$ Verify `201 Created`.
   - Execute `PUT https://reqres.in/api/users/2` with Alice Jones JSON $ightarrow$ Verify `200 OK`.
   - Execute `DELETE https://reqres.in/api/users/2` $ightarrow$ Verify `204 No Content`.
2. **n8n Canvas Verification:**
   - Import `Topic 2 - N8N CRUD Verification Workflow.json` into n8n.
   - Click **Execute workflow**.
   - Observe all 6 nodes execute sequentially with green checkmarks immediately!

---

## 🎥 YouTube Video Recording Guide (60 Seconds Left-to-Right)
- **0:00 - 0:15 (Why & What):** Introduce Topic 2 and explain why mastering the four primary HTTP verbs (GET, POST, PUT, DELETE) and status codes (200, 201, 204) is essential for any API integration.
- **0:15 - 0:30 (GET & POST Nodes):** Walk through `HTTP_GetUsersPage2` showing query parameterization (`page=2`), followed by `HTTP_CreateUser` dispatching our JSON body and receiving ID 721.
- **0:30 - 0:45 (PUT & DELETE Nodes):** Highlight `HTTP_UpdateUser` updating the role to Lead Engineer with status 200, and `HTTP_DeleteUser` executing the purge returning status 204 No Content.
- **0:45 - 1:00 (Execution & Audit Ledger):** Click "Execute workflow", show all green checkmarks lighting up across the canvas, and inspect `Code_AuditSummary` confirming 100% CRUD integrity.
