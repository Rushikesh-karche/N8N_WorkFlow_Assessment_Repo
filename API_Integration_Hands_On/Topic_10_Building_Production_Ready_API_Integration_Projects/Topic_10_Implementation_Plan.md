# Implementation Plan: N8N Hands-On API Integration Course
## Topic 10: Building Production-Ready API Integration Projects (Step-by-Step Guide)

---

### Overview
This step-by-step guide walks you through establishing Development vs. Production environment separation using n8n environment variables, upgrading outdated node versions on the canvas, implementing production webhook signature filtering, and building an automated, cron-scheduled Uptime Health Check workflow.

---

### Step 1: Establish Dev-vs-Prod Environment Separation
In a production deployment, hardcoding endpoint URLs or secrets is a critical security risk. Instead, configure n8n to read environment variables:
1. On your local machine, open your terminal (PowerShell or Bash).
2. Set environment variables before launching n8n:
   - **PowerShell:**
     ```powershell
     $env:API_BASE_URL="https://reqres.in/api"
     $env:NODE_ENV="production"
     n8n start
     ```
   - **Bash:**
     ```bash
     export API_BASE_URL="https://reqres.in/api"
     export NODE_ENV="production"
     n8n start
     ```
3. Open your n8n canvas and create a new workflow.
4. Add an **Edit Fields (Set)** node named `Load Config`.
5. Configure the parameters:
   - **String:** `endpoint` | **Value (Expression):** `{{ $env.API_BASE_URL || 'https://reqres.in/api' }}`
   - **String:** `env` | **Value (Expression):** `{{ $env.NODE_ENV || 'production' }}`
6. Click **Test step** and verify that n8n reads `"production"` and `"https://reqres.in/api"` dynamically from the system environment.

---

### Step 2: Manage Node Version Upgrades
n8n routinely updates node capabilities (e.g., HTTP Request v1 to v4.2). Outdated nodes display warning markers:
1. Inspect your canvas. If any node has a yellow warning circle or icon next to its name, it indicates a newer version of the node is available.
2. Double-click the node to open its settings.
3. Look for a banner or update alert, and click the **Update node** button.
4. n8n will update the node to the latest version on the canvas.
5. **Important:** Check the node inputs and outputs. Major version updates can change the JSON return structure. Review the output schema and update downstream variables if necessary (e.g. if the new version groups metadata keys under a different parent selector).

---

### Step 3: Implement Webhook Security Filters
In production, verify request authenticity to prevent endpoint spamming:
1. In your Webhook trigger node configuration panel, navigate to the Settings or Authentication section.
2. Rather than hardcoding key secrets, configure Header/API authentication linking to a saved Secret credential.
3. Configure signature verification logic to intercept incoming header signatures (such as Stripe or GitHub signatures) and block unauthorized payloads prior to node execution.

---

### Step 4: Build a Cron-Scheduled Uptime Health Check
We will build a workflow that polls our target API's availability every 5 minutes and sends alerts on failure:
1. In n8n, create a new workflow canvas.
2. Add a **Schedule Trigger** node as the start step (and add a **Manual Trigger** node for instant 1-click canvas testing).
3. Configure the trigger parameters:
   - **Trigger Interval:** Select `Minutes`.
   - **Minutes:** Set to `5` *(executes every 5 minutes)*.
4. Connect the trigger to an HTTP Request node named `Ping API Endpoint`.
5. Configure the ping parameters:
   - **Method:** `GET`
   - **URL:** `{{ $json.endpoint || $env.API_BASE_URL }}/users/2`
   - **Settings Tab:** Under **On Fail**, toggle setting to **Continue (using error output)** *(this ensures the workflow continues running when the ping fails, allowing us to route the alert)*.
6. Connect `Ping API Endpoint` to an **If** node named `If_Healthy`.
7. Configure the If conditions:
   - Check if Number: `{{ $json.statusCode || ($json.data && $json.data.id ? 200 : 500) }}` is equal to `200`.
8. Connect the **True** branch of the If node to a **No Operation (No-Op)** node (`No_Op_Healthy`).
9. Connect the **False** branch of the If node to an HTTP Request node named `Send Downtime Alert`.
10. Configure `Send Downtime Alert`:
    - **Method:** `POST`
    - **URL:** `https://postman-echo.com/post`
    - **Send Body:** Toggle to `Yes`.
    - **JSON:** Paste the alert body payload:
      ```json
      {
        "alert": "CRITICAL DOWNTIME DETECTED",
        "endpoint": "ReqRes API",
        "statusCode": "{{ $json.statusCode || 500 }}",
        "errorMessage": "{{ $json.message || 'Service Unavailable' }}",
        "timestamp": "{{ $now.toISOString() }}"
      }
      ```
11. **Testing:** Change the ping URL to an invalid address (forcing a 404). Click **Test workflow** and verify that `Send Downtime Alert` triggers and formats the payload successfully.

---

### Step 5: Version Control and Project Packaging
1. Connect terminal branches to a **Code** node named `Code_AuditSummary` to synthesize production readiness compliance.
2. Rename the workflow (top-left) to: `Topic 10 - N8N Production Uptime Monitor`.
3. Click **Save** in the top-right.
4. Click the menu dropdown icon next to the workflow title:
   - Select **Export** to download the workflow configuration as a `.json` file.
5. Save this `.json` file to your project's Git repository for version control tracking.
6. Toggle the workflow status switch in the top-right corner to **Active** to start the cron health check schedules.
