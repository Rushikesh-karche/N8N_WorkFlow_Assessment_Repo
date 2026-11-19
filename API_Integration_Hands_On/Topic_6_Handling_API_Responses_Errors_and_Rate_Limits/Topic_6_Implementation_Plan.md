# Implementation Plan: N8N Hands-On API Integration Course
## Topic 6: Handling API Responses, Errors, and Rate Limits (Step-by-Step Guide)

---

### Overview
This step-by-step guide walks you through configuring request retry options and "Continue on Fail" settings in the HTTP Request node, designing a page-offset pagination loop with safety bounds, introducing Wait nodes to pace requests, and configuring a global Error Trigger workflow to send alerts.

---

### Step 1: Configure HTTP Request Retries
To handle transient network drops or temporary server timeouts without crashing your workflow, configure retries:
1. In your n8n workspace, create a new workflow canvas.
2. Add a **Manual Trigger** node.
3. Connect a new **HTTP Request** node to the trigger. Rename the node to: `Call Flaky API - Retries`.
4. In the node configuration panel:
   - **Method:** `GET`
   - **URL:** `https://postman-echo.com/status/500` *(This endpoint deliberately returns an HTTP 500 error for testing).*
5. Click the **Settings** tab in the node sidebar:
   - **On Fail / Error Handling:** Change the default selection to **Retry**.
   - **Max Retries:** Set to `3` *(attempt the request 3 times before failing).*
   - **Retry Delay (ms):** Set to `2000` *(wait 2 seconds between attempts).*
6. Click **Test step** and monitor execution logs; n8n will retry the request 3 times with 2-second delays.

---

### Step 2: Implement "Continue on Fail" Error Bypasses
If a node's data is non-critical, you can prevent the entire workflow from stopping by allowing execution to continue:
1. Connect a new HTTP Request node or configure: `Call Flaky API - Continue on Fail`.
2. Set the URL to a non-existent path to trigger a 404:
   - **URL:** `https://jsonplaceholder.typicode.com/invalid-route-9988`
   - **Method:** `GET`
3. Open the **Settings** tab in the node sidebar:
   - Toggle the **Continue on Fail** (or **On Error**) setting to **Continue (using error output)**.
4. Click **Test step**.
5. Observe the result: instead of showing a red execution failure, the node shows a yellow warning icon and passes a JSON object containing error parameters (`message`, `statusCode`, `description`) to the next node in the path without halting downstream execution.

---

### Step 3: Build an Automated Pagination Loop (Page Offset)
To fetch large lists of users across multiple pages from a mock API, we will build a page-offset loop:
1. Add an **Edit Fields (Set)** node named `Initialize Page`. Connect it to the **Manual Trigger**.
   - **Fields to Add:** Number: `currentPage` → Value: `1`.
2. Add a new **HTTP Request** node connected to `Initialize Page`. Rename this node to `Fetch User Page`.
   - **Method:** `GET`
   - **URL:** `https://reqres.in/api/users`
   - **Send Query Parameters:** Toggle to **Yes**.
   - **Parameters:** Name: `page` | Value: `{{ $json.currentPage }}`
3. Connect an **If** node to the output of `Fetch User Page`. Rename to `If_HasMorePages`.
   - **Conditions:** Check if Number: `{{ $json.data.length }}` is greater than `0`.
   - **Safety Guardrail:** Add condition: Number `{{ $json.page }}` is less than `3` (or max safety limit of 5) to prevent infinite loops.
4. From the **True** branch of the If node, connect an **Edit Fields (Set)** node named `Increment Page`.
   - **Fields to Add:** Number: `currentPage` | Value (Expression): `{{ $('Fetch User Page').item.json.page + 1 }}`
5. Connect the output of `Increment Page` through a pacing node back to the input of `Fetch User Page` to complete the loop.
6. Connect the **False** branch of the If node to continue to downstream error-handling verification nodes.

---

### Step 4: Pace Requests to Prevent Rate-Limiting Blocks
To respect API rate limits (e.g. 1 call per second), introduce a pacing delay inside the loop:
1. Drag a new **Wait** node onto your canvas.
2. Insert it in the loop line between the `Increment Page` node and the `Fetch User Page` node (or downstream continuation).
3. Configure the Wait settings:
   - **Wait Amount:** `1`
   - **Wait Unit:** `Seconds`
4. Now, every iteration of the pagination loop pauses for 1 second before requesting the next page, guaranteeing compliance with rate-limiting quotas.

---

### Step 5: Implement a Global Error Trigger Workflow
When an unhandled error occurs, n8n can trigger a dedicated alerting workflow:
1. On your canvas (or as a separate workflow), add an **Error Trigger** node as the start node.
2. Connect it to an **Edit Fields (Set)** node named `Format Error Alert`.
3. Configure the variables:
   - **String:** `failedWorkflowId` | Expression: `{{ $json.workflow.id }}`
   - **String:** `failedWorkflowName` | Expression: `{{ $json.workflow.name }}`
   - **String:** `failedNode` | Expression: `{{ $json.execution.error.nodeName }}`
   - **String:** `errorMessage` | Expression: `{{ $json.execution.error.message }}`
   - **String:** `alertSeverity` | Value: `CRITICAL`
4. Connect to `Log_GlobalErrorSummary` to format a Slack/Email notification payload.
5. In your main workflow canvas, click the gear icon in the top-right corner to open **Workflow Settings**:
   - Under **Error Workflow**, select `Global Error Handler` (or the current workflow) from the dropdown list.
6. Save the main workflow. If any unhandled node fails, n8n triggers the error alert pipeline automatically.

---

### Step 6: Save and Execute the Full Workflow
1. Rename the workflow (top-left) to: `Topic 6 - N8N API Error Handling & Rate Limiting`.
2. Click **Save** in the top-right corner.
3. Click **Execute workflow** at the bottom-center of the screen.
4. Confirm that all nodes in the pipeline execute with green checkmarks and verify the `Code_AuditSummary` node outputs a 100% PASS compliance receipt.
