# Implementation Plan: N8N Hands-On API Integration Course
## Topic 5: Building API Workflows in n8n (Step-by-Step Guide)

---

### Overview
This step-by-step guide walks you through building a sequential multi-node API integration chain, generating dynamic ISO-8601 request headers, utilizing ancestor lookup syntax `->('Node Name').item.json` to pull data from non-adjacent parent nodes, formatting date/time parameters using Luxon, and mapping system context variables.

---

### Step 1: Create Your Base User Node
We will set up the first node in our chain to store some static user metadata:
1. In your n8n workspace, create a new workflow canvas.
2. Add a **Manual Trigger** node.
3. Click the output connector on the Manual Trigger and add an **Edit Fields (Set)** node.
4. Rename this node to: `Set Base User`.
5. Configure the parameters:
   - Under **Fields to Add**, click **Add Field** → **String**:
     - **Name:** `username`
     - **Value:** `Alice`
   - Click **Add Field** → **String**:
     - **Name:** `department`
     - **Value:** `Engineering`
6. Click **Test step** to load these values into n8n's execution history.

---

### Step 2: Call the First API (GET Echo Headers with Dynamic Context)
We will call a header echo API, injecting the department string from our parent node and generating a dynamic transaction timestamp:
1. Connect a new **HTTP Request** node to the output of `Set Base User`.
2. Rename this node to: `Postman Echo Headers`.
3. Configure the parameters:
   - **Method:** `GET`
   - **URL:** `https://postman-echo.com/headers`
   - **Send Headers:** Toggle to **Yes** (or Add Option → Headers).
   - **Headers:**
     - **Header 1:**
       - **Name:** `X-Transaction-Time`
       - **Value (Expression):** `{{ ->now.toISOString() }}` *(resolves to current ISO timestamp, e.g., "2026-11-19T14:15:00.000Z")*
     - **Header 2:**
       - **Name:** `X-User-Dept`
       - **Value (Expression):** `{{ ->json.department }}` *(resolves to "Engineering")*
4. Click **Test step**. The response panel will display the headers received by the echo server.

---

### Step 3: Call the Second API referencing the Ancestor Node
We will connect a second HTTP request node that routes data. This node builds a request body combining the username from the `Set Base User` node (2 steps upstream) and the user-agent header from `Postman Echo Headers` (1 step upstream):
1. Connect a new **HTTP Request** node to the output of `Postman Echo Headers`.
2. Rename this node to: `Create Log Entry`.
3. Configure the parameters:
   - **Method:** `POST`
   - **URL:** `https://jsonplaceholder.typicode.com/posts`
   - **Send Body:** Toggle to **Yes**.
   - **Body Content Type:** `JSON`.
   - **Specify Body:** `Using JSON`.
   - **JSON:** Paste the following template:
     ```json
     {
       "title": "Log entry for {{ ->('Set Base User').item.json.username }}",
       "body": "User-Agent utilized was {{ ->json.headers['user-agent'] }}",
       "timestamp": "{{ ->now.minus({ hours: 1 }).toFormat('yyyy-MM-dd HH:mm:ss') }}"
     }
     ```
     - `{{ ->('Set Base User').item.json.username }}` is the ancestor lookup syntax referencing the distant node.
     - `{{ ->json.headers['user-agent'] }}` references the immediate parent's output.
     - `{{ ->now.minus({ hours: 1 }).toFormat('yyyy-MM-dd HH:mm:ss') }}` demonstrates Luxon date formatting options.
4. Click **Test step** and verify the compiled request body resolves:
   ```json
   {
     "title": "Log entry for Alice",
     "body": "User-Agent utilized was axios/1.7.4",
     "timestamp": "2026-11-19 13:15:00",
     "id": 101
   }
   ```

---

### Step 4: Map System Context Variables
To trace and audit our execution, we will map system environment variables:
1. Connect an **Edit Fields (Set)** node to the output of `Create Log Entry`.
2. Rename this node to: `Output Metadata`.
3. Add the following parameters:
   - **String:** `executionId` → Value (Expression): `{{ ->executionId }}`
   - **String:** `workflowId` → Value (Expression): `{{ ->workflowId }}`
   - **String:** `finalLogTitle` → Value (Expression): `{{ ->json.title }}`
   - **String:** `logTimestamp` → Value (Expression): `{{ ->json.timestamp }}`
4. Click **Test step** and verify that n8n resolves the internal execution and workflow IDs.

---

### Step 5: Save and Execute the Full Workflow
1. Rename the workflow (top-left) to: `N8N API Chaining Workflow`.
2. Click **Save** in the top-right corner.
3. Click **Test workflow** at the bottom-center.
4. Confirm that all nodes in the chain execute successfully, displaying green checkmarks.
5. Click on each node in the execution trace list to inspect the data inputs and outputs.
