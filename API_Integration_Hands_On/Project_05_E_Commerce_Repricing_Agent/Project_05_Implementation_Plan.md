# Implementation Plan: E-Commerce Competitor Price Intelligence & Dynamic Re-Pricing Agent
## Project Code: `AI-AGENT-PRJ-05` | Target Evaluator: Deepesh Jain

---

## 1. Overview & Architectural Blueprint
This document provides the exhaustive, production-grade implementation guide for building and defending **Project 05: E-Commerce Competitor Price Intelligence & Dynamic Re-Pricing Agent** in **n8n**. 

The architecture ingests catalog updates via Webhook or Schedule Trigger, enforces a strict Schema Gatekeeper (HTTP 400 rejection on invalid items), batches records in chunks of 5, applies hard margin floors ($\max(\text{COGS}\times 1.15, \text{MAP})$), runs an autonomous ReAct AI Agent container equipped with Vector RAG and a live Sub-Workflow Scraper tool, synchronizes adjustments to Shopify via REST with exponential backoff on HTTP 429, emits alerts to Slack `#pricing-intel`, and logs failures to an asynchronous Dead-Letter Queue (DLQ).

---

## 2. Complete Node-by-Node Implementation Guide

### Node 1: Webhook_SKU_Repricing_Trigger
- **Node Type:** `n8n-nodes-base.webhook` (v2.0)
- **Role & Evaluation Marking:** Serves as the primary real-time catalog intake endpoint.
- **Parameters:**
  - `path`: `sku-repricing-trigger`
  - `httpMethod`: `POST`
  - `responseMode`: `responseNode` (Allows downstream `Respond to Webhook` nodes to emit custom HTTP 200 and HTTP 400 responses).

---

### Node 2: Manual_Catalog_Trigger & Mock_Inbound_Catalog_Payload
- **Node Type:** `n8n-nodes-base.manualTrigger` (v1) & `n8n-nodes-base.set` (v3.4)
- **Role & Evaluation Marking:** Enables 1-click execution inside n8n canvas for manual testing and grading verification without requiring external curl/Postman commands.
- **Inbound Test Payload (Section 5.1):**
```json
{
  "catalog": [
    {
      "sku": "TECH-CAM-4K-01",
      "title": "UltraHD 4K Streaming Webcam with Ring Light",
      "variant_id": "449102910291",
      "cogs": 42.50,
      "current_price": 79.99,
      "map_price": 64.99,
      "inventory_quantity": 420,
      "target_margin_percent": 30
    },
    {
      "sku": "TECH-MIC-USB-02",
      "title": "Cardioid USB Condenser Microphone",
      "variant_id": "449102910292",
      "cogs": 30.00,
      "current_price": 59.99,
      "map_price": 49.99,
      "inventory_quantity": 150,
      "target_margin_percent": 35
    },
    {
      "sku": "TECH-CAM-PREDATORY",
      "title": "UltraHD 4K Streaming Webcam with Ring Light",
      "variant_id": "449102910291",
      "cogs": 42.50,
      "current_price": 79.99,
      "map_price": 64.99,
      "inventory_quantity": 420,
      "target_margin_percent": 30
    }
  ]
}
```

---

### Node 3: Filter_Schema_Gatekeeper & IF_Catalog_Schema_Valid
- **Node Type:** `n8n-nodes-base.code` (v2.0) & `n8n-nodes-base.if` (v2.2)
- **Role & Evaluation Marking:** Enforces Level 1 Schema Validation. Checks for the mandatory presence of `sku`, `title`, `cogs`, `current_price`, `variant_id`, and `inventory_quantity`.
- **Failure Branch:** Routes invalid payloads to **`Respond_400_Bad_Request`** returning:
```json
{
  "error": "INVALID_CATALOG_ITEM",
  "missing_fields": ["sku", "cogs"],
  "timestamp": "2026-11-25T15:00:00.000Z"
}
```

---

### Node 4: Split_In_Batches_Loop
- **Node Type:** `n8n-nodes-base.splitInBatches` (v3.0)
- **Role & Evaluation Marking:** Implements Level 2 chunked processing with `batchSize: 5` to prevent rate-limit exhaustion against competitor sites and downstream APIs.
- **Done Branch:** When all batches complete, routes to **`Respond_200_Batch_Completed`** to cleanly close the webhook lifecycle.

---

### Node 5: Margin_Guardrail_Engine
- **Node Type:** `n8n-nodes-base.code` (v2.0)
- **Role & Evaluation Marking:** Pre-computes mathematical guardrails strictly per Section 5.2.
- **Code:**
```javascript
const inputData = $input.first().json.body || $input.first().json;

// 1. Compute Cost & Floor Constraints
const cogs = Number(inputData.cogs) || 0;
const currentPrice = Number(inputData.current_price) || 0;
const mapPrice = Number(inputData.map_price) || 0;

// Hard Floor: COGS + 15% minimum margin
const rawCostFloor = Number((cogs * 1.15).toFixed(2));
const hardMarginFloor = Math.max(rawCostFloor, mapPrice);

// 2. Current Margin Percentage
const currentMarginPercent = Number((((currentPrice - cogs) / currentPrice) * 100).toFixed(1));

// 3. Token Estimation
const totalChars = JSON.stringify(inputData).length;
const estimatedTokens = Math.ceil(totalChars / 4);

return [{
  json: {
    sku: inputData.sku,
    title: inputData.title,
    variant_id: inputData.variant_id,
    cogs: cogs,
    current_price: currentPrice,
    map_price: mapPrice,
    hard_margin_floor: hardMarginFloor,
    raw_cost_floor: rawCostFloor,
    current_margin_percent: currentMarginPercent,
    inventory_quantity: inputData.inventory_quantity || 0,
    estimated_tokens: estimatedTokens,
    evaluated_at: new Date().toISOString()
  }
}];
```

---

### Node 6: AI_Agent_Container (ReAct Tools Agent)
- **Node Type:** `@n8n/n8n-nodes-langchain.agent` (v1.7)
- **Role & Evaluation Marking:** Autonomous reasoning engine orchestrating tool execution and pricing elasticity evaluations.
- **System Message Prompt:**
  > *"You are an autonomous E-Commerce Strategic Repricing Agent. Your objective is to maximize revenue without ever violating the Hard Margin Floor or Brand MAP agreements. Query your Competitor Scraper tool to inspect live competitor pricing. Consult your Margin Vector tool to evaluate elasticity rules. Output strictly valid JSON conforming to the Output Parser."*
- **Sub-Nodes Connected:**
  1. **OpenAI_Chat_Model (`gpt-4o`):** Temperature locked to `0.1` (deterministic, zero hallucination), Max Tokens: `850`.
  2. **Window_Buffer_Memory:** Session Key `{{ $json.sku }}`, Context Window Depth: `6`.
  3. **Structured_Output_Parser:** JSON Schema enforcing `sku`, `price_action`, `current_price`, `competitor_price`, `recommended_price`, `projected_margin_percent`, `floor_breach_prevented`, `price_change_rationale`.
  4. **Brand_Margin_Vector_RAG_Tool:** Vector store embedding category vendor rules (Electronics: Strict MAP adherence, max $2 discount vs competitor; Apparel: clearance discounting down to COGS + 10%).
  5. **Competitor_Price_Scraper_SubWorkflow_Tool (`query_competitor_marketplace_price`):** Invokes sub-workflow `SUB_Competitor_Scraper` to retrieve real-time competitor prices.

---

### Node 7: Parse_Agent_Decision_And_Guardrails
- **Node Type:** `n8n-nodes-base.code` (v2.0)
- **Role & Evaluation Marking:** Secondary defense layer validating that the agent's output never violates Gate 1. If competitor price is below the hard floor (e.g., predatory \$55.00 dump), it forces `recommended_price = hard_margin_floor`, `floor_breach_prevented = true`, and `price_action = 'PRICE_RETAINED'`.

---

### Node 8: Switch_Price_Action_Routing
- **Node Type:** `n8n-nodes-base.switch` (v3.2)
- **Role & Evaluation Marking:** Evaluates `$json.price_action`:
  - Output 0 (`PRICE_ADJUSTED`): Routes to Shopify PUT and Slack Alert.
  - Output 1 (`PRICE_RETAINED`): Routes directly back to `Split_In_Batches_Loop` to advance to the next SKU.

---

### Node 9: Shopify_Admin_PUT_Variant
- **Node Type:** `n8n-nodes-base.httpRequest` (v4.2)
- **Role & Evaluation Marking:** RESTful variant price synchronization.
- **Parameters:**
  - Method: `PUT`
  - URL: `https://enterprise-store.myshopify.com/admin/api/2026-01/variants/{{ $json.variant_id }}.json`
  - Authentication: Header parameter `X-Shopify-Access-Token: {{ $env.SHOPIFY_ADMIN_TOKEN }}` (Zero plaintext storage).
  - Body:
    ```json
    {
      "variant": {
        "id": "{{ $json.variant_id }}",
        "price": "{{ Number($json.recommended_price).toFixed(2) }}",
        "compare_at_price": "{{ Number($json.current_price).toFixed(2) }}"
      }
    }
    ```
  - Resilience: `Retry on Fail: true`, `Max Tries: 3`, `Wait: 1000ms`, `Exponential Backoff: true`.

---

### Node 10: Slack_Repricing_Notification & Circular Loop Closure
- **Node Type:** `n8n-nodes-base.httpRequest` / Slack (v4.2)
- **Role & Evaluation Marking:** Posts formatted alert to `#pricing-intel` detailing SKU, old price, new price, margin impact, and rationale.
- **Loop Connection:** Output connects directly back to `Split_In_Batches_Loop` to process remaining catalog items, guaranteeing zero infinite loops.

---

### Node 11: Error_Trigger_Global & Append_Pricing_DLQ
- **Node Type:** `n8n-nodes-base.errorTrigger` (v1) & `n8n-nodes-base.code` (v2.0)
- **Role & Evaluation Marking:** Traps fatal network timeouts or unhandled exceptions, appending records to `/data/pricing_dlq.jsonl` with execution ID, timestamp, and failed node metadata.

---

## 3. Deepesh Jain Defense Grilling Preparation: Questions & Winning Answers

### 🥊 Grilling Question 1:
> *"Why did you use `Math.max(rawCostFloor, mapPrice)` instead of prioritizing whichever was negotiated first with the vendor?"*

**Winning Defense Answer:**
> "In enterprise e-commerce margin governance, vendor contracts (MAP agreements) and financial solvency (COGS + 15% net margin) are dual non-negotiable boundaries. If a supplier sets an aggressive MAP of \$40 on an item with a COGS of \$42.50, selling at \$40 would violate our corporate gross margin policy and result in selling at an operational loss. Conversely, if our COGS floor is \$48.88 but the brand's legal MAP is \$64.99, selling below \$64.99 would trigger brand contract termination and distributor de-listing. By taking `Math.max(rawCostFloor, mapPrice)`, we mathematically guarantee that neither profitability nor vendor compliance can ever be breached."

---

### 🥊 Grilling Question 2:
> *"Why did you separate the competitor scraping logic into an autonomous Sub-Workflow Tool (`query_competitor_marketplace_price`) instead of writing an inline HTTP request in the main loop?"*

**Winning Defense Answer:**
> "Decoupling scraper logic into a dedicated sub-workflow achieves three enterprise architectural goals:
> 1. **ReAct Tool Encapsulation:** It exposes a standardized LangChain tool interface to the AI Agent container, enabling the agent to reason dynamically about whether and when competitor data is required.
> 2. **Anti-Scraping Resilience:** Competitor marketplace APIs and scrapers frequently change selectors, proxy rotation pools, or rate limit tiers. Isolating scraping into `SUB_Competitor_Scraper` allows maintenance teams to update proxy configurations without disturbing the master catalog re-pricing pipeline.
> 3. **Concurrency & Rate Limit Protection:** The sub-workflow can independently implement queueing, caching, and exponential backoff."

---

### 🥊 Grilling Question 3:
> *"How do you guarantee that an infinite loop cannot occur inside the `Split In Batches` cycle?"*

**Winning Defense Answer:**
> "In n8n, an infinite batch loop occurs when an iteration does not route back to the batch node input or when the done condition is misconfigured. Our workflow enforces strict determinism:
> 1. When `price_action === 'PRICE_ADJUSTED'`, execution flows through Shopify PUT, then through Slack notification, and then loops back to the input of `Split_In_Batches_Loop`.
> 2. When `price_action === 'PRICE_RETAINED'`, execution bypasses the Shopify PUT and routes immediately back to the input of `Split_In_Batches_Loop`.
> 3. Once all items in the catalog batch are consumed, the `done` output fires, terminating execution cleanly into `Respond_200_Batch_Completed`. Every branch is fully closed and acyclic."

---

## 4. Postman Automated Test Execution Guide

1. Open Postman and import `Postman_Collection_Project_05_Repricing_Agent.json`.
2. Configure environment variable `base_url` to your active n8n instance (e.g. `http://localhost:5678`).
3. Run the collection runner across all 5 test scenarios:
   - **TC-001 (Competitor Undercut Above Floor):** Asserts HTTP 200, price adjusted to \$67.99, Shopify PUT executed.
   - **TC-002 (Predatory Price Below MAP Protected):** Asserts HTTP 200, price retained at \$64.99, `floor_breach_prevented === true`.
   - **TC-003 (Missing Data 400 Error):** Asserts HTTP 400 Bad Request, returns `INVALID_CATALOG_ITEM`.
   - **TC-004 (Shopify API 429 Retry):** Asserts rate-limit retry succeeds via exponential backoff.
   - **TC-005 (Dead-Letter Queue Triage):** Asserts fatal exception logs cleanly to DLQ.
