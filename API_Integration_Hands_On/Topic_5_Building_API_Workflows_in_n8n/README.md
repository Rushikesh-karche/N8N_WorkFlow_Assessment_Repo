# Topic 5: Building API Workflows in n8n (Chaining, Ancestor Lookups & Date Transforms)
## API Integration Hands-On Course for n8n

[![n8n Version](https://img.shields.io/badge/n8n-v1.x-orange.svg)](https://n8n.io)
[![Postman Echo](https://img.shields.io/badge/Postman-Echo-FF6C37.svg)](https://postman-echo.com)
[![JSON Placeholder](https://img.shields.io/badge/API-JSONPlaceholder-blue.svg)](https://jsonplaceholder.typicode.com)
[![Status](https://img.shields.io/badge/Status-Completed--Verified-brightgreen.svg)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]()

---

## 📌 Executive Overview
Welcome to **Topic 5: Building API Workflows in n8n** in the **API Integration Hands-On Course for n8n**.

In real-world integrations, automations rarely exist as standalone single-step calls. Complex business pipelines require chaining multiple disparate APIs while retaining and merging data from preceding steps. This module equips developers with essential workflow orchestration techniques:
1. Sequential API chaining across **Postman Echo** and **JSONPlaceholder**.
2. Dynamically generating **ISO-8601 request headers** using `$now.toISOString()`.
3. Traversing non-adjacent parent nodes using n8n's **ancestor lookup syntax** (`$('Set Base User').item.json.username`).
4. Applying **Luxon relative date arithmetic** (`$now.minus({ hours: 1 }).toFormat('yyyy-MM-dd HH:mm:ss')`).
5. Mapping system execution context variables (`$executionId`, `$workflowId`) for enterprise observability.

---

## 🚀 Key Repository Artifacts
| File | Description |
| :--- | :--- |
| **`Topic 5 - N8N API Chaining Workflow.json`** | Complete importable n8n workflow with embedded `pinData` for instant 1-click execution. |
| **`n8n_topic_5_requirement_document.md`** | Comprehensive technical requirement specification covering BRD, PRD, SRS, and test specifications. |
| **`n8n_topic_5_requirement_document.pdf`** | Professional executive PDF requirement document rendered via Microsoft Edge headless mode. |
| **`Topic_5_Implementation_Plan.md`** | Step-by-step practical implementation plan with exact ancestor expressions, headers, and Luxon syntax. |
| **`Topic_5_Implementation_Plan.pdf`** | Official formatted PDF implementation guide rendered via Microsoft Edge headless mode. |

---

## 🛠️ Canvas Architecture & Flow
```text
[ Manual Trigger ] ──> [ Set Base User ] ──> [ Postman Echo Headers ] ──> [ Create Log Entry ] ──> [ Output Metadata ] ──> [ Audit Summary ]
```

---

## 🧪 Testing & Verification Guide
1. **n8n Canvas Verification:**
   - Import `Topic 5 - N8N API Chaining Workflow.json` into n8n.
   - Click **Execute workflow**.
   - Observe all 6 nodes execute sequentially with green checkmarks immediately!
2. **Expression Verification Checkpoints:**
   - `X-Transaction-Time` $ightarrow$ Resolves to live ISO-8601 timestamp (e.g. `2026-11-19T14:15:00.000Z`).
   - `X-User-Dept` $ightarrow$ Resolves to `"Engineering"`.
   - `title` in Create Log Entry $ightarrow$ Successfully pulls Alice from 2 nodes upstream via `$('Set Base User').item.json.username`.
   - `timestamp` $ightarrow$ Formats time 1 hour ago in `yyyy-MM-dd HH:mm:ss`.
   - `Output Metadata` $ightarrow$ Captures internal `executionId` and `workflowId`.

---

## 🎥 YouTube Video Recording Guide (60 Seconds Left-to-Right)
- **0:00 - 0:15 (Why & What):** Introduce Topic 5 and explain why multi-node chaining and referencing distant ancestor nodes without context loss is crucial for production pipelines.
- **0:15 - 0:30 (Base User & Dynamic Headers):** Show `Set Base User` establishing Alice in Engineering, followed by `Postman Echo Headers` generating dynamic ISO timestamps and department headers.
- **0:30 - 0:45 (Ancestor Lookups & Luxon Math):** Highlight `Create Log Entry` reaching 2 steps back using `$('Set Base User').item.json.username` to get Alice's name, pulling the parent's user-agent, and formatting a timestamp 1 hour ago with Luxon.
- **0:45 - 1:00 (Metadata, Audit & Execution):** Show `Output Metadata` capturing execution and workflow IDs, and `Code_AuditSummary` confirming 100% PASS. Click "Execute workflow" showing all green checkmarks across the canvas!
