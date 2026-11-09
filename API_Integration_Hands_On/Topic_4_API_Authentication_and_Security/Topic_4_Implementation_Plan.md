# Implementation Plan: N8N Hands-On API Integration Course
## Topic 4: API Authentication and Security (Step-by-Step Guide)

---

### Overview
This step-by-step guide walks you through creating reusable credentials, configuring Basic Auth (base64 username/password), setting up API Key/Header Auth, connecting to OAuth 2.0 endpoints using client credentials and redirect callbacks, and analyzing JSON Web Token (JWT) structures.

---

### Step 1: Manage Reusable Credentials in the n8n Console
n8n stores credentials securely separate from workflows. This prevents keys from being exposed in plain text when sharing workflows:
1. Open your n8n Dashboard.
2. In the left navigation menu, click on **Credentials**.
3. Click the **Add Credential** button in the top-right corner.
4. Search for **Basic Auth** and click **Create**.
5. Configure the credentials parameters:
   - **User Name:** `postman`
   - **Password:** `password`
6. Click **Save** to encrypt and save your credentials.

---

### Step 2: Implement Basic Authentication in HTTP Request Node
We will test our Basic Auth credentials against a secure mock endpoint provided by Postman Echo:
1. In n8n, create a new workflow canvas.
2. Add a **Manual Trigger** node.
3. Connect a new **HTTP Request** node named `HTTP_BasicAuth` to the trigger.
4. In the HTTP Request configuration panel:
   - **Method:** `GET`
   - **URL:** `https://postman-echo.com/basic-auth`
   - **Authentication:** Select **Generic Credential Type**.
   - **Generic Credential Type:** Select **Basic Auth**.
   - **Credential for Basic Auth:** Select the credentials created in Step 1.
5. Click **Test step** and verify:
   - The status code returns `200 OK`.
   - The JSON response output contains `"authenticated": true`.

---

### Step 3: Implement Header-Based Token Authentication (Bearer Token)
Many APIs use Bearer tokens passed inside the HTTP Authorization header:
1. Add a new **HTTP Request** node named `HTTP_BearerTokenAuth` to your workflow.
2. In the configurations:
   - **Method:** `GET`
   - **URL:** `https://postman-echo.com/headers`
   - **Authentication:** Select **Generic Credential Type**.
   - **Generic Credential Type:** Select **Header Auth**.
   - **Create New Credential:** Set:
     - **Name:** `Authorization`
     - **Value:** `Bearer my_secret_token_9988`
3. Click **Test step**.
4. Review the response. The postman-echo server echoes back all request headers it received. Verify the JSON contains: `"authorization": "Bearer my_secret_token_9988"`.

---

### Step 4: Configure OAuth 2.0 Consent Handshake
OAuth 2.0 uses a secure redirection handshake to authorize access without sharing passwords:
1. Add a new HTTP Request node.
2. Select **Authentication** $ightarrow$ **Predefined Credential Type**.
3. Select a predefined OAuth 2.0 provider (e.g. GitHub OAuth2 or Spotify Account).
4. n8n displays your unique callback Redirect URL:
   `https://yourdomain.n8n.cloud/rest/oauth2-credential/callback`
5. Go to the provider's developer console (e.g., GitHub Developer Settings $ightarrow$ OAuth Apps), register a new application, and paste n8n's Redirect URL into the Authorization Callback URL field.
6. Copy the generated **Client ID** and **Client Secret** from the provider.
7. Return to the n8n credential popup and paste:
   - **Client ID:** `<copied_client_id>`
   - **Client Secret:** `<copied_client_secret>`
8. Click **Sign in with GitHub** or **Connect**.
9. A popup window prompts you to log in and click **Authorize**.
10. The credential status in n8n changes to **"Connected"** or **"Active"**. n8n automatically manages token expirations and refreshes in the background.

---

### Step 5: Deconstruct JSON Web Tokens (JWT)
JSON Web Tokens are compact URL-safe credentials composed of three parts separated by dots (`.`): `Header.Payload.Signature`.
1. Copy this mock JWT string:
   ```text
   eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMzE5
   ```
2. Open a new browser tab and navigate to `https://jwt.io/`.
3. Paste the string into the Encoded box.
4. Review the decoded panels:
   - **Header (Red):** Displays metadata including algorithm type (`HS256`) and token type (`JWT`).
   - **Payload (Blue):** Displays claims data: `sub` (Subject ID: `1234567890`), `name` (`John Doe`), and `admin` status (`true`).
   - **Signature (Green):** Displays validation check computed using a secret key to verify token authenticity.

---

### Step 6: Save and Execute the Full Workflow
1. Rename the workflow (top-left) to: `N8N API Authentication Workflow`.
2. Click **Save** in the top-right.
3. Click **Test workflow** to run all nodes. Verify they execute successfully, displaying green checkmarks.
