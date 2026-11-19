# Topic 6: Handling API Responses, Errors, and Rate Limits
## API Integration Hands-On Course for n8n

[![n8n Version](https://img.shields.io/badge/n8n-v1.x-orange.svg)](https://n8n.io)
[![Postman Echo](https://img.shields.io/badge/Postman-Echo-FF6C37.svg)](https://postman-echo.com)
[![ReqRes API](https://img.shields.io/badge/Mock_API-ReqRes.in-green.svg)](https://reqres.in)
[![Status](https://img.shields.io/badge/Status-Completed--Verified-brightgreen.svg)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]()

---

## 📌 Executive Overview
Welcome to **Topic 6: Handling API Responses, Errors, and Rate Limits** in the **API Integration Hands-On Course for n8n**.

In production environments, APIs fail, network connections drop, collections span multiple pages, and rate limits throttle un-paced requests. This module delivers enterprise resilience strategies:
1. **Configuring Request Retries:** Automatically re-attempt flaky requests with 3 retries and 2000ms backoff delay.
2. **Implementing "Continue on Fail" Bypasses:** Prevent pipeline crashes by routing non-critical errors into structured data objects.
3. **Designing Page-Offset Pagination Loops:** Traverse multi-page REST endpoints with safety bounds to prevent infinite loops.
4. **Pacing Requests with Wait Nodes:** Introduce 1-second delays inside loops to strictly respect remote API rate limits.
5. **Architecting Global Error Workflows:** Centralize incident alerts with an `Error Trigger` node capturing workflow IDs, failed nodes, and root error messages.

---

## 🚀 Key Repository Artifacts
| File | Description |
| :--- | :--- |
| **`Topic 6 - N8N API Error Handling & Rate Limiting.json`** | Complete 12-node workflow with retry policies, continue-on-fail bypass, pagination pacing, global error trigger, and embedded `pinData`. |
| **`n8n_topic_6_requirement_document.md`** | Enterprise architectural specification covering BRD, PRD, SRS, node blueprints, and QA plans. |
| **`n8n_topic_6_requirement_document.pdf`** | Formatted executive PDF requirement document compiled via Microsoft Edge headless mode. |
| **`Topic_6_Implementation_Plan.md`** | Step-by-step practical guide detailing exact retry settings, pagination formulas, and error trigger configurations. |
| **`Topic_6_Implementation_Plan.pdf`** | Official formatted PDF implementation guide compiled via Microsoft Edge headless mode. |

---

## 🛠️ Canvas Architecture & Flow
```text
[ Manual Trigger ] ──> [ Initialize Page ] ──> [ Fetch User Page ] ──> [ If_HasMorePages ]
                                                     ▲                       │ (True: More Pages)
                                                     │                       ▼
                                            [ Wait (1s Pacing) ] <── [ Increment Page ]
                                                     │
                                                     ▼ (False: Done / Limit)
[ Code_AuditSummary ] <── [ Continue on Fail (404) ] <── [ Retry Policy (500) ]

[ Error Trigger ] ──> [ Format Error Alert ] ──> [ Log Global Error Summary ]
```

---

## 🧪 Testing & Verification Guide
1. **1-Click Instant Canvas Verification:**
   - Import `Topic 6 - N8N API Error Handling & Rate Limiting.json` into your n8n canvas.
   - Click **Execute workflow**.
   - Observe all nodes execute sequentially with bright green checkmarks and verify the `Code_AuditSummary` node outputs a 100% PASS audit receipt!
2. **Resilience Checkpoints:**
   - **Retries:** `Call Flaky API - Retries` attempts up to 3 times with 2000ms backoff on HTTP 500.
   - **Error Output:** `Call Flaky API - Continue on Fail` turns a 404 error into a clean JSON error object without halting execution.
   - **Pagination Loop:** `Fetch User Page` retrieves ReqRes users, increments page number, and pauses 1 second via `Wait_PacingDelay`.
   - **Global Error Alert:** `Error_Trigger` captures `workflow.id`, `workflow.name`, and `execution.error.nodeName` for instant Slack/Email dispatch.

---

## 🎥 YouTube Video Recording Guide (60 Seconds Left-to-Right)
- **0:00 - 0:15 (Why & What):** Introduce Topic 6. Explain that production workflows must handle flaky servers, avoid crashing on non-fatal errors, paginate through large datasets, and pace requests to avoid rate-limit bans.
- **0:15 - 0:30 (Pagination Loop & Wait Pacing):** Show `Initialize Page`, `Fetch User Page`, and `If_HasMorePages`. Highlight how `Increment Page` and `Wait_PacingDelay` pause execution for 1 second to stay within API rate limits while safety bounds prevent infinite loops.
- **0:30 - 0:45 (Retries & Continue-on-Fail):** Zoom into `Call Flaky API - Retries` showing 3 retries with 2-second delays on 500 errors. Then show `Call Flaky API - Continue on Fail`, demonstrating how a 404 turns into a structured JSON error object instead of crashing the pipeline.
- **0:45 - 1:00 (Global Error Trigger & 1-Click Run):** Highlight the `Error Trigger` branch capturing `failedNode` and `errorMessage`. Click "Execute workflow" showing 100% green checkmarks across the canvas!
