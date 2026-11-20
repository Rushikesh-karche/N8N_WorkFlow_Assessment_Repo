# Implementation Plan: N8N Hands-On API Integration Course
## Topic 8: Integrating Multiple APIs Together (Step-by-Step Guide)

---

### Overview
This step-by-step guide walks you through building a multi-step API orchestration workflow that initiates a support ticket payload, creates a unique transaction correlation ID, maps customer email addresses to database IDs, logs data records to a mock database endpoint, and sends customized confirmation messages using ancestor node variables.

---

### Step 1: Initialize Support Ticket Metadata
We will configure the entry point node of our workflow to store a mock customer support ticket:
1. In your n8n workspace, create a new workflow canvas.
2. Add a **Manual Trigger** node.
3. Click the Trigger's output connector and add an **Edit Fields (Set)** node.
4. Rename this node to: `Incoming Support Ticket`.
5. Configure the parameters:
   - **Specify Fields:** Select **Using JSON** from the dropdown menu (or add individual fields).
   - **JSON:** Paste the following support ticket data:
     ```json
     {
       "ticketId": "TCK-8855",
       "customerEmail": "alice@example.com",
       "issueDescription": "My account password reset button is not working."
     }
     ```
6. Click **Test step** to run and populate this JSON in the execution thread.

---

### Step 2: Generate Unique Transaction ID
For auditing purposes, we will generate a unique Transaction ID to track this ticket across all downstream APIs:
1. Add an **Edit Fields (Set)** node connected to the output of `Incoming Support Ticket`.
2. Rename this node to: `Initialize Transaction`.
3. In the node configurations:
   - Under **Fields to Add**, click **Add Field** → **String**:
     - **Name:** `transactionId`
     - **Value (Expression):** `{{ 'TX-' + $now.toFormat('yyyyMMddHHmmss') + '-' + Math.floor(Math.random()*1000) }}` *(Observe the preview generates a custom ID, e.g. "TX-20261120145000-456")*
   - Ensure the other variables from the parent node flow through. Click **Add Field** → **String** for each, mapping:
     - **Name:** `ticketId` → Value: `{{ $json.ticketId }}`
     - **Name:** `customerEmail` → Value: `{{ $json.customerEmail }}`
     - **Name:** `issueDescription` → Value: `{{ $json.issueDescription }}`
4. Click **Test step** to verify all fields are populated in output.

---

### Step 3: Resolve Customer ID via Lookup Logic
To map our customer's email address to a database Customer ID (caching/lookup pattern):
1. Connect a new **Edit Fields (Set)** node to the output of `Initialize Transaction`.
2. Rename this node to: `Customer Database Lookup`.
3. Configure the parameters:
   - **Keep Only Set Fields:** Toggle to **No** *(this ensures all upstream variables like `transactionId` and `issueDescription` continue to flow downstream)*.
   - Under **Fields to Add**, click **Add Field** → **String**:
     - **Name:** `customerId`
     - **Value (Expression):** `{{ $json.customerEmail === 'alice@example.com' ? 'CUST-7744' : 'CUST-9999' }}`
4. Click **Test step**. Notice the output schema now includes the new `customerId` mapped dynamically alongside all parent properties.

---

### Step 4: Log Ticket details to a Mock Database API
We will call a mock database POST endpoint, passing our transaction variables and appending a tracking correlation header:
1. Connect a new **HTTP Request** node to the output of `Customer Database Lookup`.
2. Rename this node to: `Log to Database`.
3. Configure the parameters:
   - **Method:** `POST`
   - **URL:** `https://jsonplaceholder.typicode.com/posts`
   - **Send Headers:** Toggle to **Yes**.
   - **Headers:**
     - **Name:** `X-Correlation-ID` | **Value (Expression):** `{{ $json.transactionId }}`
   - **Send Body:** Toggle to **Yes**.
   - **Body Content Type:** `JSON`.
   - **Specify Body:** `Using JSON`.
   - **JSON:** Paste the following database schema model:
     ```json
     {
       "transactionId": "{{ $json.transactionId }}",
       "customerId": "{{ $json.customerId }}",
       "ticketId": "{{ $json.ticketId }}",
       "details": "{{ $json.issueDescription }}",
       "status": "LOGGED"
     }
     ```
4. Click **Test step**. Verify that the mock server responds with status code `201 Created` and echoes the logged properties.

---

### Step 5: Send Confirmation Alert using Ancestor Variables
Once logged, we will trigger a mock email confirmation mapping properties from the database response and ancestor nodes:
1. Connect a new **HTTP Request** node to the output of `Log to Database`.
2. Rename this node to: `Send Notification Alert`.
3. Configure the parameters:
   - **Method:** `POST`
   - **URL:** `https://postman-echo.com/post`
   - **Send Body:** Toggle to **Yes**.
   - **Body Content Type:** `JSON`.
   - **Specify Body:** `Using JSON`.
   - **JSON:** Paste the notification model:
     ```json
     {
       "alertType": "EMAIL",
       "recipient": "{{ $('Initialize Transaction').item.json.customerEmail }}",
       "subject": "Support Ticket {{ $('Initialize Transaction').item.json.ticketId }} Logged",
       "body": "Hi, your ticket has been successfully registered under Transaction ID {{ $json.transactionId }}. We will investigate shortly."
     }
     ```
   - *Notice that `customerEmail` and `ticketId` are retrieved directly from the `Initialize Transaction` ancestor node, maintaining consistent state across multiple API boundaries.*
4. Click **Test step** and verify the Postman Echo response.

---

### Step 6: Save and Execute the Orchestration Workflow
1. Connect the output of `Send Notification Alert` to a **Code** node named `Code_AuditSummary` to synthesize execution metrics.
2. Rename the workflow (top-left) to: `Topic 8 - N8N API Orchestration Workflow`.
3. Click **Save** in the top-right corner.
4. Click **Execute workflow** at the bottom-center.
5. Confirm that all nodes in the orchestration execute successfully with green checkmarks and verify the complete audit receipt.
