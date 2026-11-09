# Topic 3: Working with JSON Data (Hierarchy, Dot-Notation & Array Indexing)
## API Integration Hands-On Course for n8n

[![n8n Version](https://img.shields.io/badge/n8n-v1.x-orange.svg)](https://n8n.io)
[![JSON Placeholder](https://img.shields.io/badge/API-JSONPlaceholder-blue.svg)](https://jsonplaceholder.typicode.com)
[![Status](https://img.shields.io/badge/Status-Completed--Verified-brightgreen.svg)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]()

---

## 📌 Executive Overview
Welcome to **Topic 3: Working with JSON Data** in the **API Integration Hands-On Course for n8n**.

In enterprise integrations, web APIs exchange complex nested JSON payloads rather than flat tabular data. This module equips developers with the core data manipulation competencies in n8n:
1. Ingesting multi-level nested receipt JSON containing child objects and item arrays.
2. Writing **dot-notation expressions** to traverse object hierarchies (`{{ $json.customer.contact.email }}`).
3. Querying list collections via **zero-based array indexing** (`{{ $json.purchasedItems[0].name }}`).
4. Constructing string concatenations (`{{ $json.customer.firstName }} {{ $json.customer.lastName }}`).
5. Dynamically populating outbound **HTTP POST payloads** to external notification endpoints.

---

## 🚀 Key Repository Artifacts
| File | Description |
| :--- | :--- |
| **`Topic 3 - N8N JSON Traversal Workflow.json`** | Complete importable n8n workflow with embedded `pinData` for instant 1-click execution. |
| **`n8n_topic_3_requirement_document.md`** | Comprehensive technical requirement specification covering BRD, PRD, SRS, and test specifications. |
| **`n8n_topic_3_requirement_document.pdf`** | Professional executive PDF requirement document rendered via Microsoft Edge headless mode. |
| **`Topic_3_Implementation_Plan.md`** | Step-by-step practical implementation plan with exact n8n expressions and verification checkpoints. |
| **`Topic_3_Implementation_Plan.pdf`** | Official formatted PDF implementation guide rendered via Microsoft Edge headless mode. |

---

## 🛠️ Canvas Architecture & Flow
```text
[ Manual Trigger ] ──> [ Mock Invoice Data ] ──> [ Extract Customer Data ] ──> [ HTTP POST Notification ] ──> [ Audit Summary ]
```

---

## 🧪 Testing & Verification Guide
1. **n8n Canvas Verification:**
   - Import `Topic 3 - N8N JSON Traversal Workflow.json` into n8n.
   - Click **Execute workflow**.
   - Observe all 5 nodes execute sequentially with green checkmarks immediately!
2. **Expression Verification Checkpoints:**
   - `customerEmail` $ightarrow$ `"johndoe@example.com"`
   - `fullName` $ightarrow$ `"John Doe"`
   - `firstItemName` $ightarrow$ `"Wireless Mouse"`
   - `firstItemPrice` $ightarrow$ `25.99`
   - Outbound HTTP POST $ightarrow$ Returns HTTP `201 Created` with ID `101`.

---

## 🎥 YouTube Video Recording Guide (60 Seconds Left-to-Right)
- **0:00 - 0:15 (Why & What):** Introduce Topic 3 and explain why mastering nested JSON traversal (dot notation and array indexing) is the foundation of data transformation in n8n.
- **0:15 - 0:30 (Mock Data & Hierarchy):** Show `Mock Invoice Data` containing nested customer contacts and the `purchasedItems` array.
- **0:30 - 0:45 (Dot Notation & Array Indexing):** Walk through `Extract Customer Data`, showing how `$json.customer.contact.email` resolves to John's email and `$json.purchasedItems[0].name` extracts the Wireless Mouse.
- **0:45 - 1:00 (Outbound Mapping & Audit Summary):** Highlight `HTTP_SendNotification` injecting these variables into an outbound POST request, and inspect `Code_AuditSummary` confirming all expressions resolved with 100% accuracy.
