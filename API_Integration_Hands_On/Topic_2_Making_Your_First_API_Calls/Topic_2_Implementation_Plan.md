# Implementation Plan: N8N Hands-On API Integration Course
## Topic 2: Making Your First API Calls (Step-by-Step Guide)

---

### Overview
This step-by-step guide walks you through executing GET, POST, PUT, PATCH, and DELETE requests using the ReqRes public mock API sandbox (`https://reqres.in`). You will configure query parameters, customize request headers, format JSON request bodies, and parse successful status codes (200, 201, 204) in both Postman and n8n.

---

### Step 1: Understand the ReqRes Sandbox Endpoints
For this topic, we will use ReqRes (`https://reqres.in`), which is a hosted mock server that supports all standard CRUD API requests:
- **Base URL:** `https://reqres.in`
- **Inbound Methods Supported:** `GET`, `POST`, `PUT`, `PATCH`, `DELETE`
- **Response Format:** `application/json`

---

### Step 2: Configure Query Parameters (GET Request)
Query strings append search variables to your URL. We will fetch page 2 of the mock users list:
- **Target Endpoint:** `GET https://reqres.in/api/users?page=2`

#### In Postman:
1. Open a new tab, select `GET` method, and enter the URL: `https://reqres.in/api/users`.
2. Select the **Params** tab below the URL bar.
3. In the key-value table, enter:
   - **Key:** `page`
   - **Value:** `2`
4. Notice the URL automatically changes to `https://reqres.in/api/users?page=2`.
5. Click **Send** and check that the status code is `200 OK`.

#### In n8n:
1. Open your n8n canvas. Add a **Manual Trigger** node.
2. Connect it to a new **HTTP Request** node named `HTTP_GetUsersPage2`.
3. Set the parameters:
   - **Method:** `GET`
   - **URL:** `https://reqres.in/api/users`
   - **Send Query Parameters:** Toggle to **Yes**.
   - **Parameters:**
     - **Name:** `page` | **Value:** `2`
4. Click **Test step** and verify the JSON list of page 2 users returns in the right panel.

---

### Step 3: Create a Record (POST Request with JSON Body)
POST requests send data bodies to the server to create a new resource:
- **Target Endpoint:** `POST https://reqres.in/api/users`
- **JSON Payload:**
```json
{
  "name": "Alice Smith",
  "job": "Software Engineer"
}
```

#### In Postman:
1. Open a new tab, select `POST`, and enter `https://reqres.in/api/users`.
2. Under the URL bar, select the **Body** tab.
3. Select the **raw** radio button, and select **JSON** from the dropdown menu on the right.
4. Paste the JSON payload into the editor.
5. Click **Send**.
6. Verify the status code is `201 Created` and the response body contains your text fields plus an `id` and a `createdAt` timestamp.

#### In n8n:
1. Connect a new **HTTP Request** node named `HTTP_CreateUser` to your workflow.
2. Set the parameters:
   - **Method:** `POST`
   - **URL:** `https://reqres.in/api/users`
   - **Send Body:** Toggle to **Yes**.
   - **Body Content Type:** `JSON`
   - **Specify Body:** `Using JSON`
   - **JSON:** Paste:
     ```json
     {
       "name": "Alice Smith",
       "job": "Software Engineer"
     }
     ```
3. Click **Test step** and verify status code `201` and output keys (`id`, `createdAt`).

---

### Step 4: Update a Record (PUT Request)
PUT is used to replace an entire existing resource, whereas PATCH is used for partial updates:
- **Target Endpoint:** `PUT https://reqres.in/api/users/2`
- **JSON Payload:**
```json
{
  "name": "Alice Jones",
  "job": "Lead Engineer"
}
```

#### In n8n:
1. Add a new **HTTP Request** node named `HTTP_UpdateUser` to the workflow.
2. Set the parameters:
   - **Method:** `PUT`
   - **URL:** `https://reqres.in/api/users/2`
   - **Send Body:** Toggle to **Yes**.
   - **Specify Body:** `Using JSON`
   - **JSON:** Paste the payload above.
3. Click **Test step**. Verify that the status code is `200 OK` and an `updatedAt` timestamp is returned.

---

### Step 5: Delete a Record (DELETE Request)
DELETE removes a resource from the server:
- **Target Endpoint:** `DELETE https://reqres.in/api/users/2`

#### In n8n:
1. Add a new **HTTP Request** node named `HTTP_DeleteUser` to the workflow.
2. Set the parameters:
   - **Method:** `DELETE`
   - **URL:** `https://reqres.in/api/users/2`
3. Click **Test step**.
4. Observe the response: the status code should return `204 No Content` (meaning the request succeeded and the server returned an empty body) or `200 OK`.

---

### Step 6: Build and Execute the Combined CRUD Workflow
To confirm that you can execute multiple HTTP methods sequentially:
1. Arrange your n8n nodes in a single line on the canvas:
   `Manual_Trigger` $ightarrow$ `HTTP_GetUsersPage2` (GET) $ightarrow$ `HTTP_CreateUser` (POST) $ightarrow$ `HTTP_UpdateUser` (PUT) $ightarrow$ `HTTP_DeleteUser` (DELETE) $ightarrow$ `Code_AuditSummary`
2. Click on the workflow name in the top-left corner and rename it to: `N8N CRUD Verification Workflow`.
3. Click **Save** in the top-right corner.
4. Click **Test workflow** at the bottom.
5. Confirm that all nodes execute successfully, displaying green checkmarks.
