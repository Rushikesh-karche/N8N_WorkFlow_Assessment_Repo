# Topic 1: Setting Up Your API Development Environment
## API Integration Hands-On Course for n8n

[![n8n Version](https://img.shields.io/badge/n8n-v1.x-orange.svg)](https://n8n.io)
[![Postman](https://img.shields.io/badge/Postman-v10.x-FF6C37.svg)](https://www.postman.com)
[![Status](https://img.shields.io/badge/Status-Completed--Verified-brightgreen.svg)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]()

---

## 📌 Executive Overview
Welcome to **Topic 1: Setting Up Your API Development Environment** in the **API Integration Hands-On Course for n8n**.

This introductory module establishes the foundational development setup required for all enterprise API automations:
1. Installing and configuring **Postman** with a dedicated development workspace (`n8n_API_Trainee_Workspace`).
2. Deploying the **n8n visual workflow editor** (Cloud or self-hosted npm runtime).
3. Utilizing the free public mock API sandbox **JSONPlaceholder** (`https://jsonplaceholder.typicode.com/users`).
4. Probing and analyzing REST API responses in Postman (Status `200 OK`, headers, JSON bodies).
5. Assembling an automated n8n pipeline executing the HTTP GET query, transforming user schema, and compiling audit logs.

---

## 🚀 Key Repository Artifacts
| File | Description |
| :--- | :--- |
| **`Topic 1 - My First API GET Workflow.json`** | Complete importable n8n workflow with embedded `pinData` for instant 1-click execution. |
| **`n8n_topic_1_requirement_document.md`** | Comprehensive requirement document covering BRD, PRD, SRS, and test specifications. |
| **`n8n_topic_1_requirement_document.pdf`** | Professional executive PDF requirement document rendered via Microsoft Edge headless mode. |
| **`Topic_1_Implementation_Plan.md`** | Step-by-step practical implementation plan with exact Postman and n8n instructions. |
| **`Topic_1_Implementation_Plan.pdf`** | Official formatted PDF implementation guide. |

---

## 🛠️ Canvas Architecture & Flow
```text
[ Manual Trigger ] ──> [ HTTP Request (GET /users) ] ──> [ Validate & Format ] ──> [ Execution Summary ]
```

---

## 🧪 Testing & Verification Guide
1. **Postman Verification:**
   - Open Postman, navigate to `n8n_API_Trainee_Workspace`.
   - Send `GET https://jsonplaceholder.typicode.com/users`.
   - Confirm `Status: 200 OK` and 10 mock user profiles returned.
2. **n8n Canvas Verification:**
   - Import `Topic 1 - My First API GET Workflow.json` into n8n.
   - Click **Execute workflow**.
   - Observe all 4 nodes light up with green checkmarks immediately!

---

## 🎥 YouTube Video Recording Guide (60 Seconds Left-to-Right)
- **0:00 - 0:15 (Why & What):** Introduce the API Integration Hands-On course and explain why testing endpoints in Postman before automating in n8n prevents production bugs.
- **0:15 - 0:30 (Postman Probing):** Show Postman sending a GET request to JSONPlaceholder `/users`, highlighting the `200 OK` status and JSON body.
- **0:30 - 0:45 (n8n Pipeline Setup):** Show the n8n canvas: Manual Trigger connected to the HTTP Request node querying the same endpoint.
- **0:45 - 1:00 (Execution & Verification):** Click "Execute workflow", show the clean data flow through the Validation and Summary nodes, and display the final verified output.
