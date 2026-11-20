# Implementation Plan: N8N Hands-On API Integration Course
## Topic 9: Testing, Debugging, and Optimizing API Integrations (Step-by-Step Guide)

---

### Overview
This step-by-step guide walks you through establishing Postman environment variables, writing JavaScript test assertions to validate API responses, auditing n8n execution history logs to troubleshoot errors, and optimizing workflow latencies by configuring parallel execution branches with a Merge node.

---

### Step 1: Manage Postman Environment Variables
To keep your URLs and test parameters dynamic across testing environments:
1. Open the Postman application.
2. In the left navigation sidebar, click on **Environments**.
3. Click the **+** (Create Environment) button and name it: `ReqRes_Sandbox_Env`.
4. In the variable table, enter the following configurations:
   - **Variable 1:** Name: `base_url` | Type: `default` | Current Value: `https://reqres.in/api`
   - **Variable 2:** Name: `user_id` | Type: `default` | Current Value: `2`
5. Click **Save** in the top-right corner.
6. Open a new request tab, set the method to **GET**.
7. Select `ReqRes_Sandbox_Env` from the environment dropdown list located in the top-right corner of the Postman interface.
8. In the URL bar, reference your variables using double curly braces:
   ```text
   {{base_url}}/users/{{user_id}}
   ```
9. Click **Send** to verify the variables resolve dynamically to `https://reqres.in/api/users/2`.

---

### Step 2: Write JavaScript Test Assertions in Postman
To automate response testing and regression validation, write assertions inside Postman's JavaScript test sandbox:
1. Inside the request tab from Step 1, click the **Tests** tab located directly below the URL address bar.
2. Paste the following JavaScript test scripts:
   ```javascript
   // Assert that the HTTP response status code is 200 OK
   pm.test("Status code is 200 OK", function () {
       pm.response.to.have.status(200);
   });

   // Assert that the server response delay is under 500 milliseconds
   pm.test("Response latency is under 500ms", function () {
       pm.expect(pm.response.responseTime).to.be.below(500);
   });

   // Assert that the returned JSON payload contains the correct user ID data
   pm.test("JSON payload contains correct user ID", function () {
       var jsonData = pm.response.json();
       pm.expect(jsonData.data.id).to.eql(2);
       pm.expect(jsonData.data.first_name).to.be.a('string');
   });
   ```
3. Click **Send**.
4. In the response dashboard at the bottom, select the **Test Results** tab.
5. Confirm that all three test scripts display a green **PASS** badge.

---

### Step 3: Audit n8n Execution History
To troubleshoot workflow execution issues and analyze node execution bottlenecks:
1. In your n8n Dashboard, click on **Executions** in the left navigation sidebar.
2. You will see a list of previous execution runs. Select a completed execution to open it.
3. Review the logs:
   - Hover over any node and click on it to inspect the **Input** tab (data received) and **Output** tab (data returned).
   - **Troubleshoot a failure:** Find a node showing a red execution mark, open its settings, and click the **Error** tab to view the stack trace logs.
   - **Performance inspection:** Verify each node's individual execution duration (rendered next to the node name, e.g., `45ms`).

---

### Step 4: Implement Parallel Node Execution (Fork/Join)
If you need to query multiple independent APIs, running them sequentially adds up the latency. Running them in parallel reduces end-to-end execution times significantly:
1. In your n8n workspace, create a new workflow canvas.
2. Add a **Manual Trigger** node.
3. Connect the Manual Trigger's output connector to two separate, parallel HTTP Request nodes:
   - **HTTP Request Node A:**
     - **Name:** `Fetch User 1`
     - **Method:** `GET`
     - **URL:** `https://jsonplaceholder.typicode.com/users/1`
   - **HTTP Request Node B:**
     - **Name:** `Fetch User 2`
     - **Method:** `GET`
     - **URL:** `https://jsonplaceholder.typicode.com/users/2`
4. Add a **Merge** node to the canvas:
   - Rename to: `Merge_ParallelResults`.
5. Connect the outputs of **BOTH** `Fetch User 1` and `Fetch User 2` to the input ports of the Merge node:
   - Node A connects to **Input 1**.
   - Node B connects to **Input 2**.
6. Double-click the Merge node to configure:
   - **Mode:** `Append` (or Combine).
7. Click **Test step** in the Merge node to verify it waits for both parallel paths to resolve before outputting the unified dataset.

---

### Step 5: Save and Verify Performance Benefits
1. Connect the output of `Merge_ParallelResults` to a **Code** node named `Code_AuditSummary` to calculate latency improvements and verify combined records.
2. Rename the workflow (top-left) to: `Topic 9 - N8N Performance Tuning Workflow`.
3. Click **Save** in the top-right corner.
4. Click **Execute workflow** at the bottom-center.
5. Verify that both HTTP requests fire and resolve concurrently. Compare the total workflow execution duration against a sequential equivalent to observe the 40%+ latency reduction!
