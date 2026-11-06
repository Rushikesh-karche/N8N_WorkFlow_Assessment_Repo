# Implementation Plan: N8N Hands-On API Integration Course
## Topic 1: Setting Up Your API Development Environment (Step-by-Step Guide)

---

### Overview
This step-by-step guide walks you through downloading and configuring Postman, deploying your n8n visual workflow editor environment (cloud or local npm sandbox), identifying public REST API sandboxes, executing a test GET query in Postman, building an n8n GET request workflow, and validating JSON output logs.

---

### Step 1: Install and Configure Postman
Postman is an industry-standard API client used for building, testing, and debugging API calls:
1. Open your web browser and navigate to `https://www.postman.com/downloads/`.
2. Download and run the installer for your operating system.
3. Open the Postman application and sign up for a free personal account.
4. Once logged in, click on the **Workspaces** dropdown menu in the top navigation bar and select **Create Workspace**.
5. Configure the workspace settings:
   - **Name:** `n8n_API_Trainee_Workspace`
   - **Visibility:** Select **Personal** (private to you).
6. Click **Create Workspace** to initialize your development canvas.

---

### Step 2: Set Up Your n8n Environment (Local or Cloud)
You can choose to run n8n either in the cloud or self-hosted locally on your machine. Choose one of the options below:

#### Option A: n8n Cloud (Recommended for quick start)
1. Go to `https://n8n.io/cloud/` and sign up for a free developer trial account.
2. Complete the initial registration email verification.
3. Launch your editor workspace from the cloud portal (e.g., `https://your-subdomain.n8n.cloud`).

#### Option B: Local npm Setup (Alternative)
1. Ensure you have Node.js (v18.x or newer) installed on your machine.
2. Open your terminal or PowerShell and run the command to install n8n globally:
   ```bash
   npm install n8n -g
   ```
3. Launch n8n locally by running:
   ```bash
   n8n start
   ```
4. Once initialized, open your browser and go to `http://localhost:5678`. Set up your admin login details.

---

### Step 3: Identify the Public Mock API Sandbox
To test requests safely without API keys or registrations, we will use JSONPlaceholder, a free online REST API sandbox representing mock server records:
- **Base URL Endpoint:** `https://jsonplaceholder.typicode.com`
- **Resource Route:** `/users` (returns a list of 10 mock user profiles)
- **Target Method:** `GET`
- **Resulting URI:** `GET https://jsonplaceholder.typicode.com/users`

---

### Step 4: Execute Your First GET Request in Postman
1. In Postman, click the **+** tab in the center panel to open a new request canvas.
2. Set the HTTP request method dropdown (located left of the URL bar) to **GET** (default setting).
3. Paste the sandbox URL in the address bar:
   `https://jsonplaceholder.typicode.com/users`
4. Click the blue **Send** button on the right.
5. Review the results in the response dashboard at the bottom:
   - **Status Code:** Confirm it shows `200 OK` (successful request).
   - **Time & Size:** Observe the response transit time (ms) and data size.
   - **Body Tab:** Set the output filter to JSON (or Pretty) to view the list of mock user profiles (including parameters like `id`, `name`, `email`, `address`).

---

### Step 5: Build and Run Your GET Workflow in n8n
1. Open your n8n visual editor page in the browser.
2. Click **+ Add First Step** or **+** in the center of the blank canvas.
3. Select **Manual Trigger** node from the triggers category.
4. Hover over the right output port of the Manual Trigger node, click the **+** connector, and search for the **HTTP Request** node.
5. Click **HTTP Request** to add and connect the node.
6. Double-click the HTTP Request node to open its configuration panel:
   - **Method:** Select `GET` from the dropdown list.
   - **URL:** Paste: `https://jsonplaceholder.typicode.com/users`
   - **Authentication:** Set to `None`.
   - **Response Format:** Set to `JSON` (default setting).
7. Inside the HTTP Request node panel, click the **Test step** or **Listen for test** button.
8. Inspect the response panel on the right. Confirm the JSON data returns successfully with the array of mock user records.

---

### Step 6: Naming, Saving, and Executing the Workflow
1. Click on the default workflow name (top-left corner, e.g., `"My workflow 1"`) and rename it to: `My First API GET Workflow`.
2. Click the **Save** button in the top-right corner of the canvas.
3. Click the **Test workflow** button located at the bottom-center of the screen.
4. Observe the execution details: a green checkmark will appear next to both the Manual Trigger and HTTP Request nodes, indicating that data traversed the canvas successfully.
