# Project 05: E-Commerce Competitor Price Intelligence & Dynamic Re-Pricing Agent
## Project Code: `AI-AGENT-PRJ-05`
**Course:** AI Agent Hands-On Assessment (n8n Level 1, Level 2, API Integration & AI Agents)  
**Lead Evaluator:** Deepesh Jain | **Passing Score:** 75.0 / 100.0 | **Target:** 100.0 / 100.0 (High Distinction)

---

## Executive Summary
**Project 05: E-Commerce Competitor Price Intelligence & Dynamic Re-Pricing Agent** is an enterprise-grade autonomous dynamic pricing solution built natively in **n8n**. It unifies scheduled and webhook ingestion, strict schema gatekeeping, mathematical margin floor calculations ($\max(\text{COGS}\times 1.15, \text{MAP})$), an autonomous ReAct AI Agent container with Vector RAG and live sub-workflow competitor price scraping, Shopify Admin REST API integration with exponential backoff on HTTP 429, Slack operational notifications, and an asynchronous Dead-Letter Queue (DLQ).

---

## Key Architectural Highlights & 100/100 Compliance
1. **Zero-Tolerance Margin Protection (Gate 1):** Never sells below COGS + 15% or brand Minimum Advertised Price (MAP).
2. **Zero Plaintext Secrets (Gate 2):** Securely binds Shopify API tokens via `$env.SHOPIFY_ADMIN_TOKEN`.
3. **Closed Circular Batch Loop (Gate 3):** Fully closed loops connecting from both Switch outputs back to `Split In Batches`, terminating cleanly in an HTTP 200 response upon completion.
4. **Resilience & DLQ (Gate 4):** Catches unhandled exceptions and Shopify rate limits with an asynchronous Error Trigger appending to `/data/pricing_dlq.jsonl`.
5. **Native Node Architecture:** No shortcuts or mocked code blocks—features real native nodes for Webhooks, Filters, Split in Batches, AI Agents, Memory, Parsers, Switch, HTTP Requests, Slack, and DLQ!

---

## File Inventory
```
Project_05_E_Commerce_Repricing_Agent/
├── Project 05 - E-Commerce Competitor Price Intelligence & Dynamic Re-Pricing Agent.json  # Master Workflow JSON
├── SUB_Competitor_Scraper.json                                                           # Sub-Workflow Scraper Tool
├── Postman_Collection_Project_05_Repricing_Agent.json                                     # Automated TC-001 to TC-005 Test Suite
├── brand_map_agreements.json                                                             # Brand MAP & Category Elasticity Knowledge
├── n8n_project_05_requirement_document.md                                                # Complete BRD / PRD / SRS Specification
├── n8n_project_05_requirement_document.pdf                                               # Compiled PDF Specification
├── Project_05_Implementation_Plan.md                                                     # Step-by-Step Implementation & Defense Guide
├── Project_05_Implementation_Plan.pdf                                                    # Compiled PDF Implementation Plan
└── README.md                                                                             # Evaluation & Architecture Overview
```

---

## Quick Start & Verification in n8n

### Mode 1: 1-Click Verification inside n8n Canvas
1. Open n8n canvas.
2. In the top-right menu, select **Import from File**.
3. Choose `Project 05 - E-Commerce Competitor Price Intelligence & Dynamic Re-Pricing Agent.json`.
4. Click **Execute Workflow** (or test from `Manual_Catalog_Trigger`).
5. All nodes execute and process the test catalog across batches!

### Mode 2: Live Automated Regression Testing (Postman)
1. Import `Postman_Collection_Project_05_Repricing_Agent.json` into Postman.
2. Set variable `base_url` to your running n8n instance (e.g. `http://localhost:5678`).
3. Run the collection runner to execute all 5 test scenarios:
   - **TC-001:** Competitor Undercut Above Floor (Adjusts price to \$67.99, emits Shopify PUT + Slack alert).
   - **TC-002:** Predatory Price Below MAP Protected (Retains price at \$64.99, prevents floor breach).
   - **TC-003:** Missing Mandatory Attributes (Returns HTTP 400 Bad Request with `INVALID_CATALOG_ITEM`).
   - **TC-004:** Shopify API 429 Throttle (Exponential backoff retry verification).
   - **TC-005:** Dead-Letter Queue Triage (Unhandled exception logged to DLQ).

---

## Evaluation Rubric Alignment (100.0 Points Total)
* **n8n Level 1 (15 Pts):** Webhook trigger, Schema Filter, Switch routing.
* **n8n Level 2 (20 Pts):** Hard margin floor logic, Split-In-Batches loop, Token budgeting.
* **AI Agent Container (25 Pts):** ReAct tools agent, `gpt-4o` temp 0.1, Window buffer memory, JSON Output Parser.
* **Dynamic Tool Calling (20 Pts):** Vector RAG tool, Competitor Scraper Sub-Workflow tool.
* **API Integration (10 Pts):** Shopify Admin PUT with token auth, HTTP 429 retry backoff.
* **Resilience (10 Pts):** Error Trigger configuration, DLQ persistence.
