# API.md — billing project
# Complete API Specification
# Version 1.0 | One Stop Solutions | July 2026
#
# This file documents every API call in the system:
# 1. Flutter app → Your Node.js backend
# 2. Node.js backend → AiSensy (WhatsApp)
# 3. Node.js backend → Razorpay (Payments)
# 4. Flutter app → Supabase (Database + Auth)
#
# Read alongside: CLAUDE.md · DATABASE.md · SCREENS-1/2/3.md
#
# CRITICAL RULE FROM CLAUDE.md:
# Flutter NEVER calls AiSensy or Razorpay Secret APIs directly.
# ALL third-party calls go through your Node.js backend.
# Flutter only calls: (a) your Node.js backend, (b) Supabase client SDK

---

## HOW TO READ THIS FILE

Each API entry contains:
- **Method + Path** → HTTP method and endpoint
- **Called by** → Flutter app or Node.js backend
- **Auth** → what auth header is required
- **Request** → body/query params with types
- **Response (success)** → exact JSON shape returned
- **Response (error)** → error codes and messages
- **Flutter usage** → which screen/notifier calls this
- **Notes** → business rules, edge cases, rate limits

---

## SECTION INDEX

```
SECTION 1  →  Base URLs & Auth
SECTION 2  →  Auth APIs (Supabase + OTP)
SECTION 3  →  Shop APIs (create, read, update)
SECTION 4  →  Customer APIs
SECTION 5  →  Billing APIs (create bill, send via WhatsApp)
SECTION 6  →  Messaging APIs (bulk WhatsApp campaigns)
SECTION 7  →  Credits APIs (balance, top-up)
SECTION 8  →  Subscription & AutoPay APIs (Razorpay)
SECTION 9  →  Template APIs (WhatsApp templates)
SECTION 10 →  Notification APIs
SECTION 11 →  Admin APIs (Super Admin only)
SECTION 12 →  Webhook Handlers (inbound — from Razorpay + AiSensy)
SECTION 13 →  AiSensy API Reference (Node.js → AiSensy)
SECTION 14 →  Razorpay API Reference (Node.js → Razorpay)
SECTION 15 →  Error Code Reference
```

---

## SECTION 1 — BASE URLS & AUTH

### 1.1 Base URLs

```
// Your Node.js backend (Railway hosted)
BACKEND_BASE_URL = https://api.buildingproject.in/v1
// Use --dart-define=BACKEND_URL=xxx in Flutter builds

// Supabase (Flutter SDK calls this directly)
SUPABASE_URL     = https://{projectId}.supabase.co
SUPABASE_ANON_KEY = {anonKey}  // public key only — safe in Flutter
// Use --dart-define=SUPABASE_URL=xxx --dart-define=SUPABASE_KEY=xxx

// AiSensy (called from Node.js ONLY — never Flutter)
AISENSY_BASE_URL = https://backend.aisensy.com/campaign/t1/api

// Razorpay (Node.js for secret operations, Flutter for payment UI only)
RAZORPAY_BASE_URL = https://api.razorpay.com/v1
```

### 1.2 Auth Strategy

```
Flutter → Supabase:
  Authorization: Bearer {supabase_access_token}
  (supabase_flutter SDK handles this automatically)

Flutter → Your Node.js Backend:
  Authorization: Bearer {supabase_access_token}
  (same token — your Node.js verifies it with Supabase)
  X-Shop-Id: {shopId}  (for shopkeeper requests)

Node.js → AiSensy:
  Authorization: Bearer {AISENSY_API_KEY}
  (stored in Node.js .env — NEVER sent to Flutter)

Node.js → Razorpay:
  Basic Auth: {RAZORPAY_KEY_ID}:{RAZORPAY_KEY_SECRET}
  (stored in Node.js .env — NEVER sent to Flutter)

Super Admin requests to Node.js Backend:
  Authorization: Bearer {supabase_access_token}
  X-Admin-Role: super_admin
  (Node.js verifies role from Supabase user metadata)
```

### 1.3 Standard Response Envelope

All Node.js backend responses follow this shape:

```json
// Success
{
  "success": true,
  "data": { ... },
  "message": "Optional success message"
}

// Error
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message",
    "details": { ... }   // optional extra info
  }
}
```

### 1.4 Dio Client Setup (Flutter)

```dart
// lib/core/network/dio_client.dart
// This is the ONLY Dio instance in the app

final dio = Dio(BaseOptions(
  baseUrl: Env.backendUrl,
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 30),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
));

// Auth interceptor — attaches Supabase token automatically
dio.interceptors.add(AuthInterceptor());

// Error interceptor — converts HTTP errors to Failure objects
dio.interceptors.add(ErrorInterceptor());
```

---

## SECTION 2 — AUTH APIs

### 2.1 Request OTP (Shopkeeper Login)

```
Method:     POST (Supabase Auth SDK — not your backend)
Called by:  Flutter (authNotifierProvider)
Screen:     S1-01 Login Screen
```

```dart
// Flutter code — using Supabase SDK directly
await supabase.auth.signInWithOtp(
  phone: '+91${phoneNumber}',
  shouldCreateUser: false,  // shopkeeper must exist (created by salesperson)
);
```

```
Response (success):  OTP sent to phone via SMS/WhatsApp
Response (error):
  - "User not found" → phone not registered (salesperson hasn't added them)
  - "Rate limit" → too many OTP requests
```

```
Flutter handling:
  success → navigate to /otp screen
  "User not found" → show "Contact your salesperson to set up your account"
  rate limit → show countdown timer + "Try again in {n} minutes"
```

### 2.2 Verify OTP (Shopkeeper)

```
Method:     POST (Supabase Auth SDK)
Called by:  Flutter
Screen:     S1-02 OTP Screen
```

```dart
final response = await supabase.auth.verifyOTP(
  phone: '+91${phoneNumber}',
  token: otpCode,
  type: OtpType.sms,
);
// response.session contains access_token + refresh_token
// Supabase SDK stores these automatically
```

```
Response (success):
{
  "access_token": "eyJ...",
  "refresh_token": "...",
  "user": {
    "id": "uuid",
    "phone": "+919876543210",
    "user_metadata": {
      "role": "shopkeeper",
      "shop_id": "uuid",
      "shop_name": "Raju Silks",
      "plan": "pro"
    }
  }
}

Response (error):
  - "Invalid OTP" → wrong code entered
  - "OTP expired" → 10-minute window passed
```

### 2.3 Salesperson Login

```
Method:     POST (Supabase Auth SDK — email+password)
Called by:  Flutter
Screen:     S2-01 Salesperson Login
```

```dart
final response = await supabase.auth.signInWithPassword(
  email: email,
  password: password,
);
```

```
Response (success): same session shape as 2.2, role = "salesperson"
Response (error):
  - "Invalid login credentials" → wrong email/password
  - "Email not confirmed" → account not active
```

### 2.4 Super Admin Login

```
Method:     POST (Supabase Auth SDK — email+password)
Called by:  Flutter
Screen:     S3-01 Admin Login
```

```dart
final response = await supabase.auth.signInWithPassword(
  email: adminEmail,
  password: adminPassword,
);
// Check user_metadata.role === 'super_admin' after login
// If role is not super_admin → sign out + show "Unauthorised"
```

### 2.5 Logout (All Roles)

```dart
await supabase.auth.signOut();
// Clear all local state in Riverpod providers
// Clear flutter_secure_storage
// Navigate to appropriate login screen based on last role
```

### 2.6 Refresh Session

```
Handled automatically by supabase_flutter SDK.
No manual refresh needed.
If refresh fails → catch AuthException → navigate to login.
```

---

## SECTION 3 — SHOP APIs

### 3.1 Get Shop Profile (Shopkeeper)

```
Method:      GET
Path:        /shops/me
Called by:   Flutter (dashboardNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id header
Screen:      S1-03 Dashboard, S1-20 Settings
```

```
Request:     No body (shopId from auth token)

Response (success):
{
  "success": true,
  "data": {
    "shopId": "uuid",
    "shopName": "Raju Silks",
    "ownerName": "Rajesh Kumar",
    "ownerPhone": "+919876543210",
    "whatsappNumber": "+919876543210",
    "address": "123 Main Street, Vijayawada",
    "city": "Vijayawada",
    "state": "Andhra Pradesh",
    "pinCode": "520001",
    "gstNumber": "37AABCS1234A1Z5",
    "businessType": "clothing",
    "logoUrl": "https://supabase.../shop-logos/uuid.jpg",
    "plan": "pro",
    "planStartDate": "2026-06-01",
    "billCredits": 182,
    "msgCredits": 640,
    "status": "active",
    "createdAt": "2026-06-01T10:00:00Z"
  }
}
```

### 3.2 Create Shop (Salesperson)

```
Method:      POST
Path:        /shops
Called by:   Flutter (addShopNotifierProvider)
Auth:        Bearer {salesperson_token}
Screen:      S2-04 → S2-07 Add Shop flow
```

```json
Request body:
{
  "shopName": "Raju Silks",
  "ownerName": "Rajesh Kumar",
  "ownerPhone": "9876543210",
  "whatsappNumber": "9876543210",
  "address": "123 Main Street",
  "city": "Vijayawada",
  "state": "Andhra Pradesh",
  "pinCode": "520001",
  "gstNumber": "37AABCS1234A1Z5",
  "businessType": "clothing",
  "plan": "pro",
  "salespersonId": "uuid"
}
```

```json
Response (success):
{
  "success": true,
  "data": {
    "shopId": "uuid",
    "shopName": "Raju Silks",
    "loginPhone": "+919876543210",
    "temporaryPassword": null,
    "credentialsSentViaWhatsApp": true,
    "assignedTemplateId": "uuid",
    "assignedTemplateName": "clothing_festival_offer"
  },
  "message": "Shop created. Credentials sent to +919876543210"
}

Response (error):
  PHONE_ALREADY_EXISTS  → "A shopkeeper with this phone already exists"
  GST_INVALID           → "Invalid GST number format"
  PLAN_NOT_FOUND        → "Selected plan does not exist"
```

```
Backend actions on shop creation:
1. Create user in Supabase Auth (phone)
2. Create shop record in shops table
3. Assign business type template
4. Set user role = 'shopkeeper' in metadata
5. Set bill/msg credit limits based on plan
6. Send login credentials via AiSensy WhatsApp message
```

### 3.3 Upload Shop Logo

```
Method:      POST
Path:        /shops/:shopId/logo
Called by:   Flutter (addShopNotifierProvider — Step 2)
Auth:        Bearer {salesperson_token}
Content-Type: multipart/form-data
Screen:      S2-05 Add Shop Branding
```

```
Request:
  file: [image file, max 2MB, jpg/png]

Response (success):
{
  "success": true,
  "data": {
    "logoUrl": "https://supabase.../shop-logos/{shopId}.jpg"
  }
}

Response (error):
  FILE_TOO_LARGE  → "Logo must be under 2MB"
  INVALID_FORMAT  → "Only JPG and PNG are supported"
```

```
Backend actions:
1. Compress image to max 500x500px
2. Upload to Supabase Storage (shop-logos bucket)
3. Update shop record with logoUrl
4. Return public URL
```

### 3.4 Update Shop Details

```
Method:      PUT
Path:        /shops/:shopId
Called by:   Flutter (editShopNotifierProvider)
Auth:        Bearer {salesperson_token} OR {admin_token}
Screen:      S2-10 Edit Shop, S3-07 Admin Shop Detail
```

```json
Request body (all fields optional — send only what changed):
{
  "shopName": "Raju Silks Pvt Ltd",
  "address": "456 New Street",
  "city": "Vijayawada",
  "state": "Andhra Pradesh",
  "pinCode": "520001",
  "gstNumber": "37AABCS1234A1Z5",
  "businessType": "clothing",
  "whatsappNumber": "9876543210"
}
```

```json
Response (success):
{
  "success": true,
  "data": { ...updatedShop },
  "message": "Shop updated successfully"
}
```

### 3.5 Get All Shops (Salesperson — their shops only)

```
Method:      GET
Path:        /shops?status=active&plan=pro&search=raju&page=1&limit=20
Called by:   Flutter (shopListNotifierProvider)
Auth:        Bearer {salesperson_token}
Screen:      S2-03 Shop List
```

```json
Response (success):
{
  "success": true,
  "data": {
    "shops": [
      {
        "shopId": "uuid",
        "shopName": "Raju Silks",
        "ownerName": "Rajesh Kumar",
        "ownerPhone": "+919876543210",
        "businessType": "clothing",
        "city": "Vijayawada",
        "plan": "pro",
        "status": "active",
        "billCredits": 182,
        "msgCredits": 640,
        "logoUrl": "https://...",
        "lastActive": "2026-07-01T08:00:00Z",
        "addedAt": "2026-06-01T10:00:00Z"
      }
    ],
    "total": 47,
    "page": 1,
    "limit": 20
  }
}
```

### 3.6 Get All Shops (Super Admin — all shops on platform)

```
Method:      GET
Path:        /admin/shops?status=&plan=&salespersonId=&businessType=&search=&page=1&limit=20
Called by:   Flutter (adminShopListNotifierProvider)
Auth:        Bearer {admin_token} + X-Admin-Role: super_admin
Screen:      S3-06 All Shops
```

```json
Response: same shape as 3.5 but includes:
{
  "data": {
    "shops": [
      {
        ...shopFields,
        "salespersonId": "uuid",
        "salespersonName": "Vijay Kumar",
        "planAmount": 599,
        "aiSensyCostThisMonth": 142.50  // internal field
      }
    ],
    "total": 234,
    "summary": {
      "totalMRR": 98400,
      "activeShops": 198,
      "pendingShops": 12,
      "suspendedShops": 4
    }
  }
}
```

---

## SECTION 4 — CUSTOMER APIs

### 4.1 Get Customers (Shopkeeper)

```
Method:      GET
Path:        /customers?search=suresh&filter=billed_recently&page=1&limit=50
Called by:   Flutter (customerNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-09 Customer List
```

```
Query params:
  search:  string (name or phone)
  filter:  "all" | "billed_recently" | "high_value" | "new"
  page:    number (default 1)
  limit:   number (default 50, max 100)
```

```json
Response (success):
{
  "success": true,
  "data": {
    "customers": [
      {
        "customerId": "uuid",
        "name": "Suresh Kumar",
        "phone": "+919876543210",
        "businessType": "clothing",
        "totalBillsCount": 8,
        "totalBilledAmount": 24800,
        "lastBillDate": "2026-07-01T10:00:00Z",
        "addedAt": "2026-05-15T09:00:00Z",
        "notes": "Regular customer"
      }
    ],
    "total": 128,
    "page": 1,
    "limit": 50
  }
}
```

### 4.2 Add Customer

```
Method:      POST
Path:        /customers
Called by:   Flutter (addCustomerNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-10 Add Customer, S1-04 New Bill (inline add)
```

```json
Request body:
{
  "name": "Suresh Kumar",
  "phone": "9876543210",
  "businessType": "clothing",
  "notes": "Regular customer"
}
```

```json
Response (success):
{
  "success": true,
  "data": {
    "customerId": "uuid",
    "name": "Suresh Kumar",
    "phone": "+919876543210",
    "isNew": true
  },
  "message": "Customer added"
}

Response (error):
  PHONE_DUPLICATE  → warn only (not block) — returns existing customer with warning flag
  NAME_TOO_SHORT   → "Name must be at least 2 characters"
  PHONE_INVALID    → "Enter a valid 10-digit Indian mobile number"
  CUSTOMER_LIMIT   → "You've reached your plan's customer limit. Upgrade to add more."
```

### 4.3 Get Customer Detail

```
Method:      GET
Path:        /customers/:customerId
Called by:   Flutter (customerDetailNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-11 Customer Detail
```

```json
Response (success):
{
  "success": true,
  "data": {
    "customerId": "uuid",
    "name": "Suresh Kumar",
    "phone": "+919876543210",
    "businessType": "clothing",
    "totalBillsCount": 8,
    "totalBilledAmount": 24800,
    "lastBillDate": "2026-07-01T10:00:00Z",
    "notes": "Regular customer",
    "addedAt": "2026-05-15T09:00:00Z",
    "recentBills": [
      {
        "billId": "uuid",
        "billNumber": "BILL-2026-0042",
        "amount": 2400,
        "status": "sent",
        "sentAt": "2026-07-01T10:00:00Z"
      }
    ]
  }
}
```

### 4.4 Update Customer

```
Method:      PUT
Path:        /customers/:customerId
Called by:   Flutter (customerDetailNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-11 Customer Detail (edit mode)
```

```json
Request body (all optional):
{
  "name": "Suresh K.",
  "phone": "9876543210",
  "notes": "Updated note"
}
```

---

## SECTION 5 — BILLING APIs

### 5.1 Create Bill

```
Method:      POST
Path:        /bills
Called by:   Flutter (newBillNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-04 New Bill → S1-05 Preview → triggers on "Send on WhatsApp"
```

```json
Request body:
{
  "customerId": "uuid",
  "items": [
    {
      "name": "Cotton Saree",
      "quantity": 2,
      "ratePerUnit": 1200,
      "amount": 2400
    },
    {
      "name": "Dupatta",
      "quantity": 1,
      "ratePerUnit": 450,
      "amount": 450
    }
  ],
  "subtotal": 2850,
  "gstRate": 5,
  "gstAmount": 142.50,
  "total": 2992.50,
  "notes": "Regular customer discount applied"
}
```

```json
Response (success):
{
  "success": true,
  "data": {
    "billId": "uuid",
    "billNumber": "BILL-2026-0042",
    "status": "created",
    "pdfUrl": "https://supabase.../bills/uuid.pdf",
    "billCreditsRemaining": 81
  },
  "message": "Bill created"
}

Response (error):
  INSUFFICIENT_CREDITS  → "Not enough bill credits. Buy more to continue."
  CUSTOMER_NOT_FOUND    → "Customer not found"
  ITEMS_EMPTY           → "Add at least one item to the bill"
  AMOUNT_INVALID        → "All item amounts must be greater than 0"
```

```
Backend actions on bill creation:
1. Validate request
2. Check billCredits > 0 (atomic check)
3. Generate bill number (BILL-{YEAR}-{incrementing 4-digit})
4. Generate PDF using PDFKit (Node.js)
5. Upload PDF to Supabase Storage (bills bucket)
6. Deduct 1 billCredit from shop (atomic — same DB transaction as step 5)
7. Create bill record in bills table
8. Trigger WhatsApp send (Section 5.2)
9. Return response with billId + pdfUrl + updated credit count
```

### 5.2 Send Bill via WhatsApp

```
Method:      POST (internal — called from Node.js after bill creation)
Path:        Node.js → AiSensy API (never called from Flutter directly)
Called by:   Node.js backend (after /bills creation succeeds)
```

```
Node.js sends to AiSensy:
POST https://backend.aisensy.com/campaign/t1/api/v2/whatsapp/sendTemplateMessage

{
  "apiKey": "${AISENSY_API_KEY}",
  "campaignName": "building_project_bill_send",
  "destination": "${customerPhone}",
  "userName": "${customerName}",
  "templateParams": [
    "${shopName}",
    "${billNumber}",
    "${totalAmount}"
  ],
  "media": {
    "url": "${pdfPublicUrl}",
    "filename": "Bill_${billNumber}.pdf"
  }
}

AiSensy response (success):
{
  "status": 200,
  "message": "Message Queued Successfully",
  "messageId": "wamid.xxx"
}

AiSensy response (error):
  400 → template not found / invalid params
  401 → invalid API key
  429 → rate limit exceeded
```

```
On AiSensy success:
  → update bills table: status = 'sent', aiSensyMessageId = wamid
  → return success to Flutter

On AiSensy failure:
  → ROLLBACK credit deduction (restore 1 billCredit)
  → update bills table: status = 'failed'
  → return error to Flutter with message "WhatsApp send failed. Credit not deducted."
```

### 5.3 Get Bill History

```
Method:      GET
Path:        /bills?filter=today&search=suresh&customerId=uuid&page=1&limit=20
Called by:   Flutter (billHistoryNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-07 Bill History
```

```
Query params:
  filter:     "today" | "this_week" | "this_month" | "all"
  search:     string (customer name or bill number)
  customerId: uuid (filter by specific customer)
  page:       number
  limit:      number (default 20)
```

```json
Response (success):
{
  "success": true,
  "data": {
    "bills": [
      {
        "billId": "uuid",
        "billNumber": "BILL-2026-0042",
        "customerId": "uuid",
        "customerName": "Suresh Kumar",
        "customerPhone": "+919876543210",
        "total": 2992.50,
        "status": "sent",
        "sentAt": "2026-07-01T10:00:00Z",
        "pdfUrl": "https://supabase.../bills/uuid.pdf"
      }
    ],
    "total": 142,
    "todayTotal": 12400,
    "todayCount": 8,
    "page": 1,
    "limit": 20
  }
}
```

### 5.4 Get Bill Detail

```
Method:      GET
Path:        /bills/:billId
Called by:   Flutter (billDetailNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-08 Bill Detail
```

```json
Response (success):
{
  "success": true,
  "data": {
    "billId": "uuid",
    "billNumber": "BILL-2026-0042",
    "customer": {
      "customerId": "uuid",
      "name": "Suresh Kumar",
      "phone": "+919876543210"
    },
    "shop": {
      "shopName": "Raju Silks",
      "gstNumber": "37AABCS1234A1Z5",
      "whatsappNumber": "+919876543210",
      "logoUrl": "https://..."
    },
    "items": [
      { "name": "Cotton Saree", "quantity": 2, "ratePerUnit": 1200, "amount": 2400 },
      { "name": "Dupatta", "quantity": 1, "ratePerUnit": 450, "amount": 450 }
    ],
    "subtotal": 2850,
    "gstRate": 5,
    "cgst": 71.25,
    "sgst": 71.25,
    "total": 2992.50,
    "notes": "Regular customer",
    "status": "sent",
    "aiSensyMessageId": "wamid.xxx",
    "createdAt": "2026-07-01T10:00:00Z",
    "sentAt": "2026-07-01T10:00:05Z",
    "pdfUrl": "https://supabase.../bills/uuid.pdf"
  }
}
```

### 5.5 Re-send Bill

```
Method:      POST
Path:        /bills/:billId/resend
Called by:   Flutter (billDetailNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-08 Bill Detail
```

```json
Response (success):
{
  "success": true,
  "data": {
    "billId": "uuid",
    "status": "sent",
    "resentAt": "2026-07-01T11:00:00Z"
  },
  "message": "Bill re-sent on WhatsApp"
}
```

```
Notes:
- Re-send does NOT deduct credits (already deducted on original send)
- Re-send only available for bills with status = "sent" (not "failed" or "created")
- Re-sends are logged in bill_resends table (for audit)
```

---

## SECTION 6 — MESSAGING APIs (BULK WHATSAPP)

### 6.1 Get Templates for Shop

```
Method:      GET
Path:        /templates?businessType=clothing
Called by:   Flutter (templateNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-13 Template Select
```

```json
Response (success):
{
  "success": true,
  "data": {
    "templates": [
      {
        "templateId": "uuid",
        "name": "clothing_festival_offer",
        "displayName": "Festival Offer",
        "businessType": "clothing",
        "category": "marketing",
        "body": "New arrivals at {{shop_name}}! Visit us for {{offer}} this {{season}}.",
        "variables": [
          { "index": 1, "key": "shop_name", "description": "Your shop name" },
          { "index": 2, "key": "offer", "description": "Discount e.g. 30% Off" },
          { "index": 3, "key": "season", "description": "e.g. Diwali, Eid" }
        ],
        "metaStatus": "approved",
        "aiSensyTemplateId": "clothing_festival_offer_en",
        "isActive": true,
        "costPerMessage": 0.86
      }
    ]
  }
}
```

### 6.2 Send Bulk Campaign

```
Method:      POST
Path:        /campaigns
Called by:   Flutter (bulkMessageNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-14 Bulk Message Preview → "Send Now"
```

```json
Request body:
{
  "templateId": "uuid",
  "recipientMode": "all",
  "customerIds": [],
  "templateVariables": {
    "shop_name": "Raju Silks",
    "offer": "30% Off",
    "season": "Diwali"
  }
}
```

```
recipientMode:
  "all"    → send to all customers (customerIds ignored)
  "manual" → send only to customers in customerIds array
```

```json
Response (success):
{
  "success": true,
  "data": {
    "campaignId": "uuid",
    "status": "queued",
    "totalRecipients": 128,
    "msgCreditsUsed": 128,
    "msgCreditsRemaining": 112,
    "estimatedCompletionTime": "2026-07-01T10:05:00Z"
  },
  "message": "Campaign queued. Messages will be sent shortly."
}

Response (error):
  INSUFFICIENT_MSG_CREDITS → "Not enough message credits. {n} needed, {m} available."
  TEMPLATE_NOT_APPROVED    → "This template is pending Meta approval. Try another."
  NO_RECIPIENTS            → "No customers found to send to"
  TEMPLATE_NOT_FOUND       → "Template not found"
```

```
Backend actions on campaign creation:
1. Validate credits (atomic check: msgCredits >= totalRecipients)
2. Deduct msgCredits (atomic — before sending)
3. Create campaign record (status: queued)
4. Queue individual messages (Node.js job queue)
5. For each recipient → call AiSensy sendTemplateMessage
6. Update delivery status per message
7. On completion → update campaign record with final stats
8. Send push notification to shopkeeper with delivery summary
```

### 6.3 Get Campaign Delivery Report

```
Method:      GET
Path:        /campaigns/:campaignId/report
Called by:   Flutter (deliveryReportNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-15 Delivery Report
```

```json
Response (success):
{
  "success": true,
  "data": {
    "campaignId": "uuid",
    "templateName": "clothing_festival_offer",
    "status": "completed",
    "totalRecipients": 128,
    "delivered": 121,
    "failed": 7,
    "pending": 0,
    "msgCreditsUsed": 128,
    "sentAt": "2026-07-01T10:00:00Z",
    "completedAt": "2026-07-01T10:03:45Z",
    "failedRecipients": [
      {
        "customerId": "uuid",
        "customerName": "Venkat Rao",
        "phone": "+919876543210",
        "failureReason": "Invalid WhatsApp number"
      }
    ]
  }
}
```

### 6.4 Retry Failed Campaign Recipients

```
Method:      POST
Path:        /campaigns/:campaignId/retry
Called by:   Flutter (deliveryReportNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-15 Delivery Report → "retry" link
```

```json
Request body:
{
  "customerIds": ["uuid1", "uuid2"]
}

Response (success):
{
  "success": true,
  "data": {
    "retriedCount": 2,
    "msgCreditsUsed": 2,
    "msgCreditsRemaining": 110
  }
}
```

---

## SECTION 7 — CREDITS APIs

### 7.1 Get Credit Balance

```
Method:      GET (Supabase direct — real-time subscription)
Called by:   Flutter (creditsNotifierProvider)
Auth:        Supabase SDK (automatic)
Screen:      S1-03 Dashboard, S1-16 Credits Screen
```

```dart
// Flutter uses Supabase real-time for live credit updates
final stream = supabase
  .from('shop_credits')
  .stream(primaryKey: ['shop_id'])
  .eq('shop_id', shopId)
  .map((rows) => CreditModel.fromJson(rows.first));
```

```json
Supabase row shape (shop_credits table):
{
  "shop_id": "uuid",
  "bill_credits": 82,
  "bill_credits_limit": 300,
  "msg_credits": 640,
  "msg_credits_limit": 800,
  "billing_cycle_start": "2026-07-01",
  "billing_cycle_end": "2026-07-31",
  "updated_at": "2026-07-01T10:00:00Z"
}
```

### 7.2 Get Top-Up Packs

```
Method:      GET
Path:        /credits/packs
Called by:   Flutter (creditsNotifierProvider)
Auth:        Bearer {token}
Screen:      S1-16 Credits Screen
```

```json
Response (success):
{
  "success": true,
  "data": {
    "billCreditPacks": [
      {
        "packId": "bill_small",
        "name": "Bill Credits — Small",
        "credits": 50,
        "price": 40,
        "pricePerCredit": 0.80,
        "type": "bill_credits"
      },
      {
        "packId": "bill_large",
        "name": "Bill Credits — Large",
        "credits": 200,
        "price": 140,
        "pricePerCredit": 0.70,
        "type": "bill_credits"
      }
    ],
    "msgCreditPacks": [
      {
        "packId": "msg_starter",
        "name": "Starter Pack",
        "credits": 100,
        "price": 120,
        "pricePerCredit": 1.20,
        "type": "msg_credits"
      },
      {
        "packId": "msg_standard",
        "name": "Standard Pack",
        "credits": 300,
        "price": 320,
        "pricePerCredit": 1.07,
        "type": "msg_credits"
      },
      {
        "packId": "msg_value",
        "name": "Value Pack",
        "credits": 600,
        "price": 580,
        "pricePerCredit": 0.97,
        "type": "msg_credits"
      }
    ]
  }
}
```

### 7.3 Initiate Top-Up Payment

```
Method:      POST
Path:        /credits/topup/initiate
Called by:   Flutter (topupNotifierProvider)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-17 Top-Up Screen → "Pay Now"
```

```json
Request body:
{
  "packId": "msg_standard"
}
```

```json
Response (success):
{
  "success": true,
  "data": {
    "orderId": "order_xxx",
    "razorpayKeyId": "rzp_live_xxx",
    "amount": 32000,
    "currency": "INR",
    "receipt": "topup_uuid",
    "packId": "msg_standard",
    "packName": "Standard Pack",
    "credits": 300,
    "creditType": "msg_credits"
  }
}
```

```
Flutter then opens Razorpay payment sheet with orderId + razorpayKeyId.
On Razorpay success → call Section 7.4 to verify.
```

### 7.4 Verify Top-Up Payment

```
Method:      POST
Path:        /credits/topup/verify
Called by:   Flutter (topupNotifierProvider — after Razorpay success callback)
Auth:        Bearer {token} + X-Shop-Id
Screen:      S1-17 Top-Up (after Razorpay callback)
```

```json
Request body:
{
  "razorpayOrderId": "order_xxx",
  "razorpayPaymentId": "pay_xxx",
  "razorpaySignature": "signature_xxx",
  "packId": "msg_standard"
}
```

```json
Response (success):
{
  "success": true,
  "data": {
    "transactionId": "uuid",
    "packName": "Standard Pack",
    "creditsAdded": 300,
    "creditType": "msg_credits",
    "newBalance": {
      "billCredits": 82,
      "msgCredits": 940
    },
    "amountPaid": 320,
    "paidAt": "2026-07-01T11:00:00Z"
  },
  "message": "300 message credits added to your account"
}

Response (error):
  SIGNATURE_INVALID    → "Payment verification failed. Contact support."
  ORDER_NOT_FOUND      → "Order not found"
  ALREADY_PROCESSED    → "This payment was already processed"
```

```
Backend actions:
1. Verify Razorpay signature (HMAC SHA256)
2. If invalid → return error (do NOT add credits)
3. If valid → add credits to shop_credits table (atomic)
4. Create transaction record
5. Send WhatsApp confirmation to shopkeeper
6. Return updated credit balance
```

### 7.5 Add Credits Manually (Super Admin Only)

```
Method:      POST
Path:        /admin/shops/:shopId/credits/add
Called by:   Flutter (adminShopDetailNotifierProvider)
Auth:        Bearer {admin_token} + X-Admin-Role: super_admin
Screen:      S3-07 Admin Shop Detail → "Add Credits Manually"
```

```json
Request body:
{
  "creditType": "bill_credits",
  "amount": 50,
  "reason": "Compensation for technical issue on 2026-07-01"
}
```

```json
Response (success):
{
  "success": true,
  "data": {
    "creditsAdded": 50,
    "creditType": "bill_credits",
    "newBalance": 132,
    "addedBy": "admin_uuid",
    "reason": "Compensation for technical issue on 2026-07-01"
  }
}
```

---

## SECTION 8 — SUBSCRIPTION & AUTOPAY APIs

### 8.1 Create AutoPay Mandate

```
Method:      POST
Path:        /subscriptions/autopay/create
Called by:   Flutter (addShopNotifierProvider — Step 4)
Auth:        Bearer {salesperson_token}
Screen:      S2-07 Add Shop AutoPay Setup
```

```json
Request body:
{
  "shopId": "uuid",
  "upiId": "shopkeeper@upi",
  "plan": "pro",
  "planAmount": 599
}
```

```json
Response (success):
{
  "success": true,
  "data": {
    "mandateId": "mandate_xxx",
    "status": "pending",
    "upiId": "shopkeeper@upi",
    "amount": 599,
    "frequency": "monthly",
    "approvalMessage": "Mandate request sent to shopkeeper's UPI app",
    "expiresAt": "2026-07-01T10:10:00Z"
  }
}
```

```
Backend actions:
1. Create Razorpay subscription (POST /v1/subscriptions)
2. Create Razorpay UPI mandate for the subscription
3. Store mandate details in subscriptions table (status: pending)
4. Return mandate details to Flutter (show waiting screen)
Flutter polls Section 8.2 every 10 seconds to check approval status.
```

### 8.2 Check Mandate Status

```
Method:      GET
Path:        /subscriptions/autopay/status?shopId=uuid
Called by:   Flutter (polling every 10s while on waiting screen)
Auth:        Bearer {salesperson_token}
Screen:      S2-07 Add Shop AutoPay → waiting state
```

```json
Response (success):
{
  "success": true,
  "data": {
    "mandateId": "mandate_xxx",
    "status": "approved",
    "approvedAt": "2026-07-01T10:05:30Z",
    "nextBillingDate": "2026-08-01",
    "subscriptionId": "sub_xxx"
  }
}
```

```
status values:
  "pending"  → shopkeeper hasn't approved yet → keep polling
  "approved" → navigate to success screen
  "failed"   → show error + retry option
  "expired"  → mandate window passed → show "Request timed out"
```

### 8.3 Cancel AutoPay Mandate (Super Admin Only)

```
Method:      POST
Path:        /admin/subscriptions/:subscriptionId/cancel
Called by:   Flutter (adminCancellationDetailNotifierProvider)
Auth:        Bearer {admin_token} + X-Admin-Role: super_admin
Screen:      S3-12 Cancellation Request Detail → "Approve"
```

```json
Request body:
{
  "cancellationRequestId": "uuid",
  "reason": "Shopkeeper requested cancellation",
  "adminNotes": "Verified with salesperson. Processing approved."
}
```

```json
Response (success):
{
  "success": true,
  "data": {
    "subscriptionId": "sub_xxx",
    "mandateCancelledAt": "2026-07-01T12:00:00Z",
    "shopAccessEndsAt": "2026-07-31T23:59:59Z",
    "razorpayCancellationId": "xxx"
  },
  "message": "AutoPay cancelled. Shop access ends 31 Jul 2026."
}
```

```
Backend actions:
1. Call Razorpay: POST /v1/subscriptions/{id}/cancel
2. Update subscription status in DB (cancelled)
3. Update shop status: active until billing period end
4. Update cancellation request: status = approved
5. Send WhatsApp notification to shopkeeper
6. Send WhatsApp notification to salesperson
```

---

## SECTION 9 — TEMPLATE APIs

### 9.1 Get All Templates (Super Admin)

```
Method:      GET
Path:        /admin/templates?status=approved&businessType=clothing
Called by:   Flutter (adminTemplatesNotifierProvider)
Auth:        Bearer {admin_token}
Screen:      S3-08 Business Templates
```

```json
Response (success):
{
  "success": true,
  "data": {
    "templates": [
      {
        "templateId": "uuid",
        "name": "clothing_festival_offer",
        "displayName": "Festival Offer",
        "businessType": "clothing",
        "category": "marketing",
        "body": "New arrivals at {{shop_name}}! ...",
        "variables": [...],
        "metaStatus": "approved",
        "aiSensyTemplateId": "clothing_festival_offer_en",
        "isActive": true,
        "shopsUsing": 42,
        "costPerMessage": 0.86,
        "lastUpdated": "2026-06-15T10:00:00Z"
      }
    ]
  }
}
```

### 9.2 Create / Update Template

```
Method:      POST (create) / PUT (update)
Path:        /admin/templates / /admin/templates/:templateId
Called by:   Flutter (adminTemplateDetailNotifierProvider)
Auth:        Bearer {admin_token}
Screen:      S3-09 Template Edit
```

```json
Request body:
{
  "name": "clothing_festival_offer_v2",
  "displayName": "Festival Offer",
  "businessType": "clothing",
  "category": "marketing",
  "body": "New arrivals at {{1}}! Visit us for {{2}} this {{3}}.",
  "variables": [
    { "index": 1, "key": "shop_name", "description": "Shop name" },
    { "index": 2, "key": "offer", "description": "Discount" },
    { "index": 3, "key": "season", "description": "Season name" }
  ],
  "submitToMeta": true
}
```

```json
Response (success):
{
  "success": true,
  "data": {
    "templateId": "uuid",
    "metaStatus": "pending",
    "aiSensySubmissionId": "xxx",
    "message": "Template submitted for Meta approval. Usually 24-48 hours."
  }
}
```

```
Backend actions (when submitToMeta = true):
1. Save template to DB (status: pending)
2. POST to AiSensy template creation endpoint
3. AiSensy forwards to Meta for approval
4. AiSensy webhook notifies you when approved/rejected (Section 12.2)
```

### 9.3 Toggle Template Active Status

```
Method:      PATCH
Path:        /admin/templates/:templateId/toggle
Called by:   Flutter (adminTemplatesNotifierProvider)
Auth:        Bearer {admin_token}
Screen:      S3-08 Templates → active toggle
```

```json
Request body:
{ "isActive": false }

Response:
{
  "success": true,
  "data": { "templateId": "uuid", "isActive": false }
}
```

---

## SECTION 10 — NOTIFICATION APIs

### 10.1 Register FCM Token

```
Method:      POST
Path:        /notifications/register
Called by:   Flutter (on app start / token refresh)
Auth:        Bearer {token}
```

```json
Request body:
{
  "fcmToken": "firebase_token_xxx",
  "platform": "android",
  "appVersion": "1.0.0"
}

Response:
{ "success": true, "message": "Token registered" }
```

### 10.2 Get Notifications

```
Method:      GET
Path:        /notifications?filter=all&page=1&limit=20
Called by:   Flutter (notificationsNotifierProvider)
Auth:        Bearer {token}
Screen:      S1-19 Notifications
```

```json
Response (success):
{
  "success": true,
  "data": {
    "notifications": [
      {
        "notificationId": "uuid",
        "type": "credit_low",
        "title": "Credits Running Low",
        "body": "Only 18 bill credits left. Buy more to keep sending bills.",
        "isRead": false,
        "data": { "creditType": "bill_credits", "remaining": 18 },
        "createdAt": "2026-07-01T09:00:00Z"
      }
    ],
    "unreadCount": 3,
    "total": 24
  }
}
```

### 10.3 Mark Notifications Read

```
Method:      PATCH
Path:        /notifications/mark-read
Called by:   Flutter
Auth:        Bearer {token}
```

```json
Request body:
{
  "notificationIds": ["uuid1", "uuid2"],
  "markAllRead": false
}
```

---

## SECTION 11 — ADMIN APIs

### 11.1 Get Platform Dashboard Stats

```
Method:      GET
Path:        /admin/dashboard
Called by:   Flutter (adminDashboardNotifierProvider)
Auth:        Bearer {admin_token} + X-Admin-Role: super_admin
Screen:      S3-02 Super Admin Dashboard
```

```json
Response (success):
{
  "success": true,
  "data": {
    "mrr": 98400,
    "mrrChange": 4200,
    "mrrChangePercent": 4.5,
    "totalShops": 234,
    "activeShops": 198,
    "pendingShops": 12,
    "suspendedShops": 4,
    "salespersonsCount": 8,
    "pendingCancellations": 3,
    "failedPayments": 2,
    "newShopsThisMonth": 18,
    "recentActivity": [
      {
        "type": "shop_subscribed",
        "message": "Raju Silks subscribed to Pro Plan",
        "timestamp": "2026-07-01T09:00:00Z"
      }
    ]
  }
}
```

### 11.2 Get Revenue Report

```
Method:      GET
Path:        /admin/revenue?from=2026-07-01&to=2026-07-31
Called by:   Flutter (adminRevenueNotifierProvider)
Auth:        Bearer {admin_token}
Screen:      S3-13 Revenue Report
```

```json
Response (success):
{
  "success": true,
  "data": {
    "period": { "from": "2026-07-01", "to": "2026-07-31" },
    "subscriptionRevenue": 93600,
    "topupRevenue": 4800,
    "totalRevenue": 98400,
    "planBreakdown": {
      "basic": { "shops": 89, "revenue": 26611 },
      "pro": { "shops": 98, "revenue": 58702 },
      "business": { "shops": 11, "revenue": 10989 }
    },
    "topupBreakdown": {
      "msgStarter": { "sold": 12, "revenue": 1440 },
      "msgStandard": { "sold": 8, "revenue": 2560 },
      "msgValue": { "sold": 1, "revenue": 580 },
      "billSmall": { "sold": 3, "revenue": 120 },
      "billLarge": { "sold": 0, "revenue": 0 }
    },
    "estimatedCosts": {
      "aiSensyPlatformFee": 1500,
      "metaMessageCosts": 8420,
      "razorpayFees": 1968,
      "totalCosts": 11888
    },
    "estimatedNetRevenue": 86512,
    "estimatedMarginPercent": 87.9,
    "paymentHealth": {
      "successful": 198,
      "failed": 6,
      "retrySuccessful": 4
    },
    "topShops": [
      {
        "shopId": "uuid",
        "shopName": "Krishna Electronics",
        "plan": "business",
        "monthlyValue": 999,
        "billsSent": 342
      }
    ],
    "salespersonPerformance": [
      {
        "salespersonId": "uuid",
        "name": "Vijay Kumar",
        "totalShops": 42,
        "revenueGenerated": 24600,
        "newThisMonth": 5
      }
    ]
  }
}
```

### 11.3 Get All Salespersons (Super Admin)

```
Method:      GET
Path:        /admin/salespersons?status=active&search=vijay&page=1&limit=20
Called by:   Flutter (salespersonListNotifierProvider for admin)
Auth:        Bearer {admin_token}
Screen:      S3-03 Salesperson Management
```

```json
Response (success):
{
  "success": true,
  "data": {
    "salespersons": [
      {
        "salespersonId": "uuid",
        "name": "Vijay Kumar",
        "phone": "+919876543210",
        "email": "vijay@onestopsolutions.in",
        "city": "Vijayawada",
        "status": "active",
        "totalShops": 42,
        "activeShops": 38,
        "revenueGenerated": 24600,
        "addedAt": "2026-01-15T10:00:00Z"
      }
    ],
    "total": 8
  }
}
```

### 11.4 Create Salesperson

```
Method:      POST
Path:        /admin/salespersons
Called by:   Flutter (addSalespersonNotifierProvider)
Auth:        Bearer {admin_token}
Screen:      S3-04 Add Salesperson
```

```json
Request body:
{
  "name": "Vijay Kumar",
  "phone": "9876543210",
  "email": "vijay@onestopsolutions.in",
  "city": "Vijayawada",
  "password": "TempPass123",
  "notes": "Handles Vijayawada and Guntur region"
}
```

```json
Response (success):
{
  "success": true,
  "data": {
    "salespersonId": "uuid",
    "name": "Vijay Kumar",
    "credentialsSentViaWhatsApp": true
  },
  "message": "Account created. Login details sent to +919876543210"
}
```

---

## SECTION 12 — WEBHOOK HANDLERS

### 12.1 Razorpay Payment Webhook

```
Method:      POST
Path:        /webhooks/razorpay
Called by:   Razorpay servers (inbound — not Flutter)
Auth:        Razorpay-Signature header (HMAC SHA256 — verify before processing)
```

```
Events handled:
  payment.captured         → subscription payment success → extend shop access
  payment.failed           → payment failure → notify shop + salesperson
  subscription.activated   → new AutoPay mandate approved by shopkeeper
  subscription.charged     → monthly deduction success
  subscription.halted      → payment failed 3 times → suspend shop access
  subscription.cancelled   → AutoPay cancelled → update shop status
```

```json
Example payload (payment.captured):
{
  "entity": "event",
  "event": "payment.captured",
  "payload": {
    "payment": {
      "entity": {
        "id": "pay_xxx",
        "order_id": "order_xxx",
        "subscription_id": "sub_xxx",
        "amount": 59900,
        "currency": "INR",
        "status": "captured"
      }
    }
  }
}
```

```
Backend response: HTTP 200 (always return 200 to Razorpay even on processing error)
Log all webhooks to webhook_logs table for debugging.
```

### 12.2 AiSensy Template Status Webhook

```
Method:      POST
Path:        /webhooks/aisensy/template-status
Called by:   AiSensy servers (when Meta approves/rejects a template)
Auth:        X-AiSensy-Secret header
```

```json
Payload:
{
  "templateName": "clothing_festival_offer",
  "status": "APPROVED",
  "reason": null
}
```

```
On APPROVED:
  → update template.metaStatus = 'approved' in DB
  → send push notification to Super Admin

On REJECTED:
  → update template.metaStatus = 'rejected', rejectionReason = reason
  → send push notification to Super Admin
```

### 12.3 AiSensy Message Delivery Webhook

```
Method:      POST
Path:        /webhooks/aisensy/delivery
Called by:   AiSensy servers (delivery status updates)
Auth:        X-AiSensy-Secret header
```

```json
Payload:
{
  "messageId": "wamid.xxx",
  "status": "delivered",
  "timestamp": "2026-07-01T10:00:05Z",
  "destination": "+919876543210"
}
```

```
status values: "sent" | "delivered" | "read" | "failed"

On received:
  → look up message by aiSensyMessageId (bills or campaigns table)
  → update delivery status
  → if campaign message: update campaign delivery stats
  → if bill: update bill delivery status
```

---

## SECTION 13 — AISENSY API REFERENCE (NODE.JS → AISENSY)

All calls from Node.js to AiSensy. Never called from Flutter.

### 13.1 Send Template Message (Bill or Single)

```
POST https://backend.aisensy.com/campaign/t1/api/v2/whatsapp/sendTemplateMessage

Headers:
  Authorization: Bearer {AISENSY_API_KEY}
  Content-Type: application/json

Body:
{
  "apiKey": "{AISENSY_API_KEY}",
  "campaignName": "building_project_bill_send",
  "destination": "+919876543210",
  "userName": "Suresh Kumar",
  "templateParams": ["Raju Silks", "BILL-2026-0042", "₹2,992.50"],
  "media": {
    "url": "https://supabase.../bills/uuid.pdf",
    "filename": "Bill_BILL-2026-0042.pdf"
  }
}

Success response:
{ "status": 200, "message": "Message Queued Successfully", "messageId": "wamid.xxx" }

Error responses:
  400 → { "status": 400, "message": "Template not found" }
  401 → { "status": 401, "message": "Unauthorized" }
  429 → { "status": 429, "message": "Rate limit exceeded" }
```

### 13.2 Send Bulk Campaign

```
POST https://backend.aisensy.com/campaign/t1/api/v2/whatsapp/sendBulkTemplateMessage

Body:
{
  "apiKey": "{AISENSY_API_KEY}",
  "campaignName": "building_project_bulk",
  "templateName": "clothing_festival_offer_en",
  "broadcastName": "campaign_uuid",
  "receivers": [
    {
      "whatsappNumber": "+919876543210",
      "customParams": ["Raju Silks", "30% Off", "Diwali"]
    },
    {
      "whatsappNumber": "+919876543211",
      "customParams": ["Raju Silks", "30% Off", "Diwali"]
    }
  ]
}
```

### 13.3 Create / Submit Template

```
POST https://backend.aisensy.com/campaign/t1/api/v2/templates

Body:
{
  "apiKey": "{AISENSY_API_KEY}",
  "templateName": "clothing_festival_offer_v2",
  "category": "MARKETING",
  "language": "en",
  "headerType": "NONE",
  "body": "New arrivals at {{1}}! Visit us for {{2}} this {{3}}.",
  "footer": "billing project · Reply STOP to opt out",
  "buttons": []
}
```

---

## SECTION 14 — RAZORPAY API REFERENCE (NODE.JS → RAZORPAY)

All calls from Node.js to Razorpay using Basic Auth (keyId:keySecret).

### 14.1 Create Subscription

```
POST https://api.razorpay.com/v1/subscriptions

Body:
{
  "plan_id": "plan_{pro/basic/business}",
  "total_count": 120,
  "quantity": 1,
  "customer_notify": 1,
  "notes": {
    "shop_id": "uuid",
    "shop_name": "Raju Silks",
    "salesperson_id": "uuid"
  }
}
```

### 14.2 Create Order (for top-up)

```
POST https://api.razorpay.com/v1/orders

Body:
{
  "amount": 32000,
  "currency": "INR",
  "receipt": "topup_uuid",
  "notes": {
    "shop_id": "uuid",
    "pack_id": "msg_standard",
    "credit_type": "msg_credits",
    "credits": 300
  }
}
```

### 14.3 Cancel Subscription

```
POST https://api.razorpay.com/v1/subscriptions/{id}/cancel

Body:
{
  "cancel_at_cycle_end": 1
}
```

### 14.4 Verify Payment Signature (Node.js utility)

```javascript
const crypto = require('crypto');

function verifyRazorpaySignature(orderId, paymentId, signature, keySecret) {
  const expectedSignature = crypto
    .createHmac('sha256', keySecret)
    .update(`${orderId}|${paymentId}`)
    .digest('hex');
  return expectedSignature === signature;
}
```

---

## SECTION 15 — ERROR CODE REFERENCE

### 15.1 Backend Error Codes

```
AUTH errors:
  AUTH_TOKEN_INVALID       → Token expired or malformed
  AUTH_ROLE_FORBIDDEN      → User role not allowed for this endpoint
  AUTH_SHOP_MISMATCH       → X-Shop-Id doesn't match token's shop

SHOP errors:
  SHOP_NOT_FOUND           → Shop ID doesn't exist
  SHOP_SUSPENDED           → Shop account is suspended
  SHOP_PHONE_EXISTS        → Phone number already registered

CREDIT errors:
  INSUFFICIENT_BILL_CREDITS → Not enough bill credits
  INSUFFICIENT_MSG_CREDITS  → Not enough message credits
  CREDIT_DEDUCTION_FAILED   → DB transaction failed (retry)

BILLING errors:
  BILL_NOT_FOUND           → Bill ID doesn't exist
  BILL_ITEMS_EMPTY         → No items in bill
  BILL_SEND_FAILED         → AiSensy send failed (credit not deducted)
  PDF_GENERATION_FAILED    → PDF could not be created

MESSAGING errors:
  TEMPLATE_NOT_FOUND       → Template ID doesn't exist
  TEMPLATE_NOT_APPROVED    → Template pending Meta approval
  CAMPAIGN_NO_RECIPIENTS   → No customers to send to
  AISENSY_RATE_LIMITED     → Too many requests to AiSensy

PAYMENT errors:
  PAYMENT_SIGNATURE_INVALID → Razorpay signature mismatch
  PAYMENT_ALREADY_PROCESSED → Duplicate payment attempt
  ORDER_NOT_FOUND           → Razorpay order ID not found
  MANDATE_APPROVAL_TIMEOUT  → AutoPay mandate not approved in time

CUSTOMER errors:
  CUSTOMER_NOT_FOUND        → Customer ID doesn't exist
  CUSTOMER_LIMIT_REACHED    → Plan's customer limit exceeded
  CUSTOMER_PHONE_DUPLICATE  → Phone already exists (warning only — not block)

VALIDATION errors:
  PHONE_INVALID             → Not a valid 10-digit Indian number
  GST_INVALID               → GST number doesn't match format
  AMOUNT_INVALID            → Amount must be positive
  REQUIRED_FIELD_MISSING    → A required field was not provided

SERVER errors:
  INTERNAL_SERVER_ERROR     → Unexpected server error (log and alert)
  SERVICE_UNAVAILABLE       → AiSensy or Razorpay is down
  DATABASE_ERROR            → Supabase query failed
```

### 15.2 Flutter Error Handling Pattern

```dart
// In every repository method:
Future<Either<Failure, T>> apiCall() async {
  try {
    final response = await dio.post('/endpoint', data: body);
    if (response.data['success'] == true) {
      return Right(T.fromJson(response.data['data']));
    } else {
      return Left(ServerFailure(
        code: response.data['error']['code'],
        message: response.data['error']['message'],
      ));
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return Left(NetworkFailure('Connection timeout. Check your internet.'));
    }
    return Left(NetworkFailure('Network error. Please try again.'));
  } catch (e) {
    return Left(UnknownFailure(e.toString()));
  }
}
```

### 15.3 User-Facing Error Messages (show these in Flutter, not raw error codes)

```
INSUFFICIENT_BILL_CREDITS  → "Not enough bill credits. Tap to buy more."
INSUFFICIENT_MSG_CREDITS   → "Not enough message credits. Tap to buy more."
BILL_SEND_FAILED           → "Could not send on WhatsApp. Your credit was not deducted. Try again."
TEMPLATE_NOT_APPROVED      → "This template is awaiting approval. Try another."
PAYMENT_SIGNATURE_INVALID  → "Payment could not be verified. Contact support."
AUTH_TOKEN_INVALID         → "Session expired. Please log in again."
INTERNAL_SERVER_ERROR      → "Something went wrong on our end. Please try again."
CUSTOMER_LIMIT_REACHED     → "You've reached your customer limit. Upgrade your plan."
SERVICE_UNAVAILABLE        → "Service is temporarily unavailable. Try again in a few minutes."
```

---

*API.md v1.0 — billing project — One Stop Solutions*
*Complete API specification across all services · July 2026*
*Next document: DATABASE.md*
