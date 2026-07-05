# FLOWS.md — Billing Project
# Critical User Flow Specifications
# Version 1.0 | One Stop Solutions | July 2026
#
# This file documents every critical user journey in the app:
# - Step-by-step numbered flows
# - Success paths + failure paths
# - Edge cases
# - What the backend does at each step
# - What the Flutter UI shows at each step
#
# Read alongside: SCREENS-1/2/3.md · API.md · DATABASE.md · CLAUDE.md

---

## SECTION INDEX

```
SECTION 1  →  Shopkeeper Flows
  F1-01    Shopkeeper First Login
  F1-02    Send a Bill (Core Flow)
  F1-03    Add a New Customer (inline during billing)
  F1-04    View and Re-send a Past Bill
  F1-05    Send a Bulk Campaign
  F1-06    Buy Credit Top-Up
  F1-07    Request AutoPay Cancellation

SECTION 2  →  Salesperson Flows
  F2-01    Onboard a New Shopkeeper (Full 4-Step Flow)
  F2-02    Review and Action a Cancellation Request
  F2-03    Edit an Existing Shop

SECTION 3  →  Super Admin Flows
  F3-01    Create a Salesperson Account
  F3-02    Approve AutoPay Cancellation
  F3-03    Submit a WhatsApp Template for Meta Approval
  F3-04    Handle a Failed AutoPay Payment
  F3-05    Add Manual Credits to a Shop

SECTION 4  →  System Flows (automated — no user action)
  F4-01    Monthly Credit Reset
  F4-02    Razorpay AutoPay Deduction
  F4-03    AiSensy Delivery Status Update
  F4-04    Credit Low Warning Trigger
```

---

## HOW TO READ THIS FILE

```
Each flow has:
  TRIGGER       → what starts this flow
  PRECONDITIONS → what must be true before flow can start
  ACTORS        → who is involved (user + system)
  HAPPY PATH    → numbered steps when everything works
  FAILURE PATHS → what happens when each step fails
  EDGE CASES    → unusual but valid scenarios
  POSTCONDITIONS → state of the system after flow completes
```

---

# SECTION 1 — SHOPKEEPER FLOWS

---

## F1-01 — SHOPKEEPER FIRST LOGIN

```
TRIGGER:       Shopkeeper receives WhatsApp message with credentials from salesperson
PRECONDITIONS: Salesperson has completed Add Shop flow (F2-01) successfully
ACTORS:        Shopkeeper, Flutter app, Supabase Auth, Node.js backend
```

### Happy Path

```
Step 1  — Shopkeeper opens app for the first time
          Flutter shows: /login screen (S1-01)
          Sky blue gradient header, "billing project" logo, phone + continue field

Step 2  — Shopkeeper enters 10-digit mobile number
          Flutter: validates 10 digits as they type
          Continue button enables when 10 digits entered

Step 3  — Shopkeeper taps "Continue"
          Flutter calls: supabase.auth.signInWithOtp(phone: '+91{number}')
          Flutter shows: loading spinner on Continue button

Step 4  — OTP sent successfully
          Supabase sends OTP to phone via SMS
          Flutter navigates to: /otp screen (S1-02)
          Displays: "Sent to +91 XXXXX X{last5}" (masked)
          45-second countdown begins

Step 5  — Shopkeeper enters 6-digit OTP
          Flutter: each digit auto-advances to next box
          6th digit entered → auto-submits (no button tap needed)

Step 6  — OTP verified successfully
          Flutter calls: supabase.auth.verifyOTP(phone, token)
          Supabase returns: session with access_token + user metadata
          user_metadata.role = 'shopkeeper'
          user_metadata.shop_id = '{uuid}'

Step 7  — Flutter reads role from user_metadata
          Checks: role === 'shopkeeper' → navigate to /dashboard
          Flutter stores: session automatically via supabase_flutter SDK

Step 8  — Dashboard loads
          dashboardNotifierProvider fetches: GET /shops/me + shop_credits stream
          Flutter shows: S1-03 Dashboard with shop name, today's stats
          First time: "₹0" revenue, 0 bills, credits at full plan limit

Step 9  — First login complete
          Node.js logs: last_login_at updated in profiles table
          Shopkeeper is now active on the platform
```

### Failure Paths

```
FAIL at Step 3 — Phone not found in Supabase Auth:
  Supabase returns: error "User not found"
  Flutter shows: inline error below phone field
  Message: "Your account is not set up yet. Contact your salesperson."
  Reason: Salesperson hasn't created this shop account yet

FAIL at Step 3 — Rate limit hit (too many OTP requests):
  Supabase returns: rate limit error
  Flutter shows: "Too many attempts. Try again in {n} minutes."
  Countdown timer shown

FAIL at Step 5 — Wrong OTP entered:
  Supabase returns: "Invalid OTP"
  Flutter shows: boxes shake animation + "Incorrect OTP. Try again."
  OTP boxes cleared, cursor back to first box
  Shopkeeper can try again (up to 3 attempts before new OTP needed)

FAIL at Step 5 — OTP expired (10 minutes passed):
  Supabase returns: "OTP expired"
  Flutter shows: "OTP has expired. Request a new one."
  "Resend OTP" link activates immediately

FAIL at Step 6 — Role is not 'shopkeeper':
  e.g. someone uses salesperson credentials on shopkeeper login screen
  Flutter detects: role !== 'shopkeeper'
  Action: supabase.auth.signOut() immediately
  Flutter shows: "Wrong login. Use the Sales Team login instead."
  Shows link: "Go to Sales Team login →"

FAIL at Step 8 — Dashboard API fails:
  GET /shops/me returns error
  Flutter shows: ErrorState with "Could not load your shop. Pull to refresh."
  Retry button available
```

### Edge Cases

```
EDGE 1 — Shopkeeper already logged in (opens app again):
  supabase_flutter SDK restores session automatically
  Flutter checks session on app start → valid session found
  Skip login → go directly to /dashboard
  No OTP needed

EDGE 2 — Session expires while using app:
  Supabase SDK tries to refresh token → fails
  AuthInterceptor catches 401 on any API call
  Flutter: sign out silently → navigate to /login
  Show: "Your session expired. Please log in again."

EDGE 3 — Shopkeeper's account suspended:
  OTP works, session created, but shop status = 'suspended'
  GET /shops/me returns: status: 'suspended'
  Flutter shows: full-screen suspension notice
  "Your account has been suspended. Contact your salesperson: {phone}"
  No access to any features until unsuspended
```

### Postconditions

```
✓ Shopkeeper has valid Supabase session
✓ profiles.last_login_at updated
✓ dashboardNotifierProvider has shop data loaded
✓ creditsNotifierProvider has live credit balance
✓ FCM token registered (if notification permission granted)
```

---

## F1-02 — SEND A BILL (CORE FLOW)

```
TRIGGER:       Shopkeeper taps "New Bill" on dashboard or tab bar
PRECONDITIONS: Shopkeeper is logged in, bill_credits > 0
ACTORS:        Shopkeeper, Flutter app, Node.js backend, AiSensy, Supabase
```

### Happy Path

```
Step 1  — Shopkeeper taps "New Bill"
          Flutter navigates to: /new-bill (S1-04)
          NewBillNotifier initialized with empty state
          Page bg: #F5F5F5, plain white top bar

Step 2  — Select or add customer
          Shopkeeper taps customer search field
          Types customer name or phone
          Flutter calls: customerNotifierProvider.search(query) — local filter

Step 2a — Existing customer found:
          Shopkeeper taps customer row in dropdown
          Customer chip appears: "{name} · +91{phone}" with × to deselect
          NewBillNotifier.setCustomer(customer)

Step 2b — Customer not found:
          Shopkeeper sees: "Add '{typed name}' as new customer →" row
          Taps it → inline bottom sheet opens (S1-10 AddCustomer)
          Enters name + phone → taps "Save Customer"
          POST /customers → customer created
          Bottom sheet closes, new customer auto-selected in bill form

Step 3  — Add bill items
          Default: 1 empty item row (name | qty | rate | amount)
          Shopkeeper types: item name, qty, rate
          Flutter: NewBillNotifier.updateItem() called on each change
          Amount column: auto-calculated (qty × rate), not editable
          Total section: subtotal + 5% GST + grand total all auto-update

Step 4  — Add more items (optional)
          Shopkeeper taps "+ Add item"
          NewBillNotifier.addItem() → new empty row appended
          Up to unlimited rows (scroll)

Step 5  — Add notes (optional)
          Shopkeeper types in notes field
          Saved to bill on creation

Step 6  — Tap "Preview Bill →" (bottom sticky bar)
          Flutter validates: customer selected? items filled? amounts > 0?
          If valid: navigate to /bill-preview (S1-05)
          pass bill data via go_router extra parameter

Step 7  — Review PDF preview
          Bill preview rendered with:
            ● Shop logo + name + GST (navy header)
            ● Bill number: BILL-2026-XXXX (generated server-side after creation)
            ● Customer name + phone
            ● All items in table format
            ● Subtotal + CGST (2.5%) + SGST (2.5%) + Grand Total
            ● "Thank you" footer
          Shopkeeper reviews all details

Step 8  — Tap "Send on WhatsApp"
          Flutter calls: POST /bills
          Button shows: spinner + disabled
          Bottom bar shows: "Sending..."

Step 9  — Backend creates bill + sends WhatsApp
          Node.js:
            a. Validates request
            b. Checks bill_credits > 0 (atomic SELECT FOR UPDATE)
            c. Calls generate_bill_number() DB function
            d. Generates PDF (PDFKit)
            e. Uploads PDF to Supabase Storage (bills bucket)
            f. Deducts 1 bill_credit (deduct_bill_credit() DB function)
            g. Creates bills record (status: created)
            h. Creates bill_items records
            i. Calls AiSensy sendTemplateMessage API with PDF URL
            j. Updates bill: status = 'sent', aisensy_message_id = wamid

Step 10 — Success response returned to Flutter
          Response: { billId, billNumber, status: 'sent', billCreditsRemaining: 81 }
          Flutter navigates to: /bill-sent (S1-06)

Step 11 — Bill sent success screen
          Large green checkmark animation
          "Bill Sent!" headline
          Summary card: customer name + amount + bill number
          Credits remaining badge (green / amber / red by level)

Step 12 — Shopkeeper chooses next action
          [Send Another Bill] → NewBillNotifier.reset() → /new-bill
          [View Bill History] → /bill-history
          [Back to Dashboard] → /dashboard
```

### Failure Paths

```
FAIL at Step 6 — Validation fails:
  Flutter shows: inline field errors
  Customer: "Please select a customer"
  Item name: "Item name cannot be empty"
  Qty/Rate: "Must be greater than 0"
  Preview button stays disabled until all errors fixed

FAIL at Step 8 — Insufficient credits (race condition):
  Bill credits read as > 0 by Flutter but depleted between check + send
  Backend deduct_bill_credit() function detects 0 credits
  Returns: INSUFFICIENT_BILL_CREDITS error
  Flutter shows: SnackBar "Not enough bill credits."
  Bill NOT created, NO credit deducted
  BottomSheet appears: "Buy more credits?" with [Buy Credits] CTA

FAIL at Step 9c — PDF generation fails:
  Backend returns: PDF_GENERATION_FAILED error
  Flutter shows: SnackBar "Could not generate bill PDF. Try again."
  Bill NOT saved, credit NOT deducted
  User stays on preview screen

FAIL at Step 9i — AiSensy send fails:
  AiSensy returns error (wrong number, rate limit, API down)
  Backend: ROLLBACK credit deduction (restore 1 bill_credit)
  Backend: sets bill status = 'failed'
  Backend returns: BILL_SEND_FAILED error to Flutter
  Flutter shows: SnackBar "Could not send on WhatsApp. Your credit was not deducted."
  User stays on preview screen with "Try Again" option

FAIL at Step 9i — Customer's WhatsApp number invalid:
  AiSensy returns: "Invalid WhatsApp number"
  Same as above — credit rolled back, bill marked failed
  Flutter shows: "The customer's WhatsApp number may be incorrect. Verify and try again."
```

### Edge Cases

```
EDGE 1 — Shopkeeper tries to send with 0 credits:
  Flutter: "Preview Bill" button disabled
  Shows credit low banner: "0 bill credits left. Buy credits to send bills."
  [Buy Credits] CTA shown prominently

EDGE 2 — Shopkeeper navigates back from preview to edit:
  Goes back to /new-bill
  NewBillNotifier retains all entered data (customer, items, notes)
  No data lost

EDGE 3 — Shopkeeper kills app mid-flow:
  NewBillNotifier state is NOT persisted to disk
  On re-open: starts fresh from empty bill form
  (Draft bills are a Phase 2 feature)

EDGE 4 — Same bill re-submitted (accidental double tap):
  "Send on WhatsApp" button disabled immediately after first tap
  Second tap is impossible
  If network issue causes Flutter to show error and user retries:
    Backend generates new bill with new bill number (not idempotent in Phase 1)
    Phase 2: add idempotency key

EDGE 5 — Very large bill (100+ items):
  All items accepted, no hard limit
  PDF generation may take longer (3-8 seconds)
  Flutter: shows "Generating bill..." with animated progress on button
  Timeout set to 30 seconds (DioException receiveTimeout)
```

### Postconditions

```
✓ bills record created with status = 'sent'
✓ bill_items records created
✓ 1 bill_credit deducted from shop_credits
✓ credit_transactions log entry created (bill_deduction)
✓ customer.total_bills_count + total_billed_amount updated (trigger)
✓ PDF stored in Supabase Storage
✓ Customer received WhatsApp message with PDF
✓ shopkeeper sees success screen
```

---

## F1-03 — ADD A NEW CUSTOMER (INLINE DURING BILLING)

```
TRIGGER:       During F1-02, shopkeeper types name not found in customer list
PRECONDITIONS: On /new-bill screen, customer search active
ACTORS:        Shopkeeper, Flutter, Node.js backend
```

### Happy Path

```
Step 1  — Shopkeeper types in customer search field
          No matching customer found
          Flutter shows: "Add '{typed name}' as new customer →" as last row

Step 2  — Shopkeeper taps "Add" row
          Bottom sheet slides up (not new screen)
          Shows: Add Customer mini-form
            ● Name field (pre-filled with typed text)
            ● WhatsApp number field (empty)
            ● Business type (optional dropdown)
            ● Save Customer button (disabled until phone filled)

Step 3  — Shopkeeper enters phone number
          Flutter validates: 10 digits, Indian format
          Save button enables

Step 4  — Shopkeeper taps "Save Customer"
          Flutter calls: POST /customers
          Button shows spinner

Step 5  — Customer created in backend
          Node.js: checks customer limit for plan
          Inserts into customers table
          Returns: { customerId, name, phone, isNew: true }

Step 6  — Bottom sheet closes
          Flutter: SuccessToast "Customer added" (green pill, 2 seconds)
          New customer auto-selected in bill form (customer chip appears)
          Shopkeeper continues building the bill
```

### Failure Paths

```
FAIL at Step 4 — Phone already exists for this shop:
  Backend returns: PHONE_DUPLICATE (warning, not error)
  Flutter: bottom sheet stays open
  Shows amber warning: "A customer with this number already exists: {existing name}"
  Two options shown:
    [Use existing customer] → selects the existing one, closes sheet
    [Add anyway]            → proceeds with duplicate (allowed)

FAIL at Step 4 — Customer limit reached:
  Backend returns: CUSTOMER_LIMIT_REACHED
  Flutter shows: error in bottom sheet
  "You've reached your {plan} plan limit of {n} customers."
  [Upgrade Plan] CTA shown → /credits
  Cannot add new customer until upgraded

FAIL at Step 3 — Invalid phone format:
  Flutter inline validation: "Enter a valid 10-digit mobile number"
  Save button stays disabled
```

### Postconditions

```
✓ customers record created in DB
✓ New customer selected in bill form
✓ Billing flow continues seamlessly
```

---

## F1-04 — VIEW AND RE-SEND A PAST BILL

```
TRIGGER:       Shopkeeper taps a bill in history or customer detail
PRECONDITIONS: Bill exists with status = 'sent', shopkeeper is logged in
ACTORS:        Shopkeeper, Flutter, Node.js, AiSensy
```

### Happy Path

```
Step 1  — Shopkeeper navigates to /bill-history (S1-07)
          Or: /customers/:id → bill row

Step 2  — Taps a bill card
          Flutter navigates to: /bill/:id (S1-08)
          billDetailNotifierProvider loads: GET /bills/:billId

Step 3  — Bill detail screen loads
          Orange gradient header with bill number
          Full bill rendered (same visual as S1-05 preview)
          Status chip: "Sent ✓" in green
          Sent timestamp shown

Step 4  — Shopkeeper taps "Re-send on WhatsApp"
          (button only visible if status = 'sent')
          Flutter calls: POST /bills/:billId/resend
          Button shows spinner

Step 5  — Backend re-sends
          Node.js: calls AiSensy with same PDF URL (no new PDF generated)
          Logs to bill_resends table
          Returns: { status: 'sent', resentAt: timestamp }

Step 6  — Success
          Flutter shows: SuccessToast "Bill re-sent on WhatsApp" (green pill)
          No credit deducted (re-sends are free)
```

### Failure Paths

```
FAIL at Step 4 — Bill status is 'failed' (original send failed):
  Re-send button NOT shown (only shown for status = 'sent')
  Instead: "Send Again" button shown (triggers fresh send with credit deduction)

FAIL at Step 5 — AiSensy fails on re-send:
  Flutter shows: SnackBar "Re-send failed. Try again."
  No credit deducted (never deducted on re-sends)
```

---

## F1-05 — SEND A BULK CAMPAIGN

```
TRIGGER:       Shopkeeper taps "Bulk Message" on dashboard
PRECONDITIONS: msg_credits > 0, at least 1 approved template for their business type,
               at least 1 customer in database
ACTORS:        Shopkeeper, Flutter, Node.js, AiSensy
```

### Happy Path

```
Step 1  — Shopkeeper taps "Bulk Message" on dashboard
          Flutter navigates to: /bulk-message (S1-12)
          bulkMessageNotifierProvider loads:
            ● Customer list from customerNotifierProvider
            ● msg_credits from creditsNotifierProvider

Step 2  — Select recipients
          Default: "All Customers" mode selected
          Shows: "{n} customers will receive this message"
          Toggle to "Select Manually" → shows searchable customer checklist

Step 3  — Tap "Choose Template" card
          Flutter navigates (push) to: /template-select (S1-13)
          templateNotifierProvider loads: GET /templates?businessType={type}
          Shows templates for their business type

Step 4  — Select a template
          Shopkeeper taps template card
          Card shows selected state (orange border + checkmark)
          Taps "Confirm" → returns to /bulk-message
          Selected template name shown in "Choose Template" card

Step 5  — Review credit usage
          Flutter shows: "This campaign will use {n} credits · {remaining} left after"
          Color: green if plenty, amber if low, red if insufficient

Step 6  — Tap "Send Messages" (bottom sticky bar)
          If insufficient credits: button disabled + "Insufficient credits" shown
          If sufficient: shows confirmation bottom sheet:
            "Send {templateName} to {n} customers?"
            "This will use {n} message credits."
            [Cancel] [Send Now]

Step 7  — Shopkeeper taps "Send Now"
          Flutter calls: POST /campaigns
          Body: { templateId, recipientMode, customerIds: [], templateVariables: {...} }
          Button shows: spinner

Step 8  — Backend creates campaign + queues messages
          Node.js:
            a. Validates: template approved? credits sufficient? recipients exist?
            b. Atomic credit deduction: deduct {n} msg_credits
            c. Creates campaigns record (status: queued)
            d. Creates campaign_recipients rows (one per customer)
            e. Starts sending via AiSensy bulk API
            f. Returns: { campaignId, status: 'queued', totalRecipients: n }

Step 9  — Flutter navigates to: /delivery-report (S1-15)
          deliveryReportNotifierProvider opens Supabase realtime on campaigns table
          Live delivery stats update as messages send:
            ● Total: 128 | Sent: 45 | Delivered: 40 | Failed: 0 | Pending: 83

Step 10 — Campaign completes
          All messages processed by AiSensy
          campaigns.status = 'completed'
          Flutter shows final delivery report:
            ● Big "121/128 delivered" stat with green arc
            ● Failed list (if any) with customer names + retry option
```

### Failure Paths

```
FAIL at Step 3 — No approved templates for their business type:
  templateNotifierProvider returns empty list
  Flutter shows: empty state on template select screen
  "No templates available. Contact support to set up templates for your business."

FAIL at Step 6 — Insufficient msg_credits:
  Credits badge shows red
  "Send Messages" button disabled
  Banner: "Need {n} credits. You have {m}. Buy more to send."
  [Buy Credits] CTA in banner → /credits/topup

FAIL at Step 8 — Atomic credit check fails (race condition):
  Another process depleted credits between Flutter check + API call
  Backend returns: INSUFFICIENT_MSG_CREDITS
  Flutter shows: SnackBar "Not enough message credits."
  No campaign created, no credits deducted

FAIL at Step 8 — Template not approved:
  Backend returns: TEMPLATE_NOT_APPROVED
  Flutter shows: "This template is pending Meta approval. Choose another."
  Returns to /template-select

FAIL at Step 9 — Some messages fail (partial failure):
  AiSensy delivers some, fails some (invalid numbers, etc.)
  campaign_recipients rows updated per message
  Delivery report shows: failed list
  Each failed row has [Retry] option → POST /campaigns/:id/retry
```

### Edge Cases

```
EDGE 1 — Shopkeeper navigates away during sending:
  Campaign continues running on backend
  Shopkeeper can return to /bill-history (not campaigns) — Phase 1
  Phase 2: "Active Campaigns" section on dashboard

EDGE 2 — 0 customers in database:
  "All Customers" mode shows: "0 customers · Add customers first"
  Send button disabled
  Shows: "Add customers to start sending bulk messages" with [Add Customer] CTA
```

### Postconditions

```
✓ campaigns record created with status = 'completed'
✓ campaign_recipients rows updated with delivery status
✓ msg_credits deducted from shop_credits
✓ credit_transactions log entry created (msg_deduction)
✓ customers receive WhatsApp messages
✓ Delivery report shown to shopkeeper
```

---

## F1-06 — BUY CREDIT TOP-UP

```
TRIGGER:       Shopkeeper taps "Buy Credits" from dashboard banner, credits screen, or
               any credit-insufficient error state
PRECONDITIONS: Shopkeeper is logged in, Razorpay is in live mode
ACTORS:        Shopkeeper, Flutter, Node.js, Razorpay
```

### Happy Path

```
Step 1  — Shopkeeper arrives at /credits (S1-16)
          creditsNotifierProvider shows: current bill + msg credit balances
          Top-up pack cards shown (bill credit packs + msg credit packs)

Step 2  — Shopkeeper taps "Buy" on a pack
          Flutter navigates to: /credits/topup?pack={packId} (S1-17)
          Shows pack summary + payment breakdown (price + 18% GST + total)

Step 3  — Shopkeeper reviews and taps "Pay Now"
          Flutter calls: POST /credits/topup/initiate
          Body: { packId: 'msg_standard' }
          Button shows spinner

Step 4  — Backend creates Razorpay order
          Node.js: POST /v1/orders to Razorpay
          Returns: { orderId, razorpayKeyId, amount, packId, credits }

Step 5  — Flutter opens Razorpay payment sheet
          Uses: razorpay_flutter package
          Opens native Razorpay UI with: orderId + amount + shopkeeper's phone
          Shopkeeper selects payment method: UPI / Card / Net Banking

Step 6  — Shopkeeper completes payment
          Razorpay returns: payment success callback
          Callback contains: razorpayOrderId, razorpayPaymentId, razorpaySignature

Step 7  — Flutter verifies payment with backend
          Flutter calls: POST /credits/topup/verify
          Body: { razorpayOrderId, razorpayPaymentId, razorpaySignature, packId }

Step 8  — Backend verifies + adds credits
          Node.js:
            a. Verify HMAC SHA256 signature (orderId|paymentId with key secret)
            b. If invalid: return PAYMENT_SIGNATURE_INVALID (do NOT add credits)
            c. Check topup_orders table: payment not already processed
            d. Add credits atomically to shop_credits
            e. Log to credit_transactions (topup_addition)
            f. Update topup_orders: status = 'paid', credits_added_at = now()
            g. Send WhatsApp confirmation to shopkeeper
            h. Return: { creditsAdded, creditType, newBalance }

Step 9  — Flutter navigates to: /credits/topup-success (S1-18)
          Shows: green checkmark + "300 credits added!" + new balance
          Supabase realtime updates dashboard credit badge automatically
```

### Failure Paths

```
FAIL at Step 5 — Shopkeeper cancels Razorpay payment:
  Razorpay returns: payment cancelled callback
  Flutter: closes Razorpay sheet, stays on /credits/topup
  Shows: SnackBar "Payment cancelled"
  No credits added (order not completed)

FAIL at Step 5 — Payment fails (insufficient UPI balance, etc.):
  Razorpay returns: payment failed callback with error code
  Flutter: shows SnackBar "Payment failed. Please try again."
  Shows retry option on /credits/topup

FAIL at Step 7 — Signature verification fails:
  Backend returns: PAYMENT_SIGNATURE_INVALID
  Flutter shows: "Payment verification failed. Contact support with reference: {paymentId}"
  Credits NOT added
  topup_orders record kept with status = 'failed' for investigation

FAIL at Step 8 — Duplicate payment (user tapped pay twice somehow):
  Backend detects: razorpay_payment_id already exists in topup_orders
  Returns: ALREADY_PROCESSED
  Flutter shows: "This payment was already applied to your account."
  User is NOT double-charged (idempotency protection)
```

### Postconditions

```
✓ topup_orders record with status = 'paid'
✓ shop_credits updated with new balance
✓ credit_transactions log entry (topup_addition)
✓ Shopkeeper receives WhatsApp confirmation
✓ Dashboard credit badge updates in real-time
```

---

## F1-07 — REQUEST AUTOPAY CANCELLATION

```
TRIGGER:       Shopkeeper taps "Request AutoPay Cancellation" in Settings
PRECONDITIONS: Shopkeeper has active subscription, no pending cancellation request
ACTORS:        Shopkeeper, Flutter, Node.js backend
```

### Happy Path

```
Step 1  — Shopkeeper navigates to: /settings → /settings/cancel-request (S1-21)
          Shows: amber info banner explaining the process
          Current plan info (name, amount, next billing date, access-ends-if-cancelled)

Step 2  — Shopkeeper selects cancellation reason
          Radio options: No longer needed / Too expensive / Switching app /
                         Technical issues / Other
          If "Other": text area appears

Step 3  — Shopkeeper checks confirmation checkbox
          "I understand my account will be deactivated at end of billing cycle"
          Submit button enables only after: reason selected + checkbox checked

Step 4  — Shopkeeper taps "Submit Cancellation Request"
          Flutter calls: POST /cancellation-requests (via backend)
          Body: { reason: 'too_expensive', customReason: null }
          Button shows spinner

Step 5  — Backend creates request
          Node.js:
            a. Checks: no existing pending request for this shop
            b. Gets subscription details (Razorpay subscription ID)
            c. Creates cancellation_requests record (status: pending)
            d. Creates notification for salesperson
            e. Creates notification for super_admin
            f. Returns: { requestId, status: 'pending', submittedAt }

Step 6  — Flutter navigates to: /settings/cancel-confirm (S1-22)
          Shows: amber clock icon + "Request Submitted"
          Request ID shown
          "Our team will contact you within 24 hours"
          "You can continue using the app until {billingEndDate}"

Step 7  — Notifications sent
          Salesperson: push notification "Shop {name} requested cancellation"
          Super Admin: push notification "New cancellation request: {shopName}"
```

### Failure Paths

```
FAIL at Step 4 — Already has pending request:
  Backend returns: error
  Flutter shows: "You already have a pending cancellation request (submitted {date}).
                  Our team will contact you soon."

FAIL at Step 4 — Network error:
  Flutter shows: SnackBar "Failed to submit. Check your connection and try again."
  User can retry
```

### Postconditions

```
✓ cancellation_requests record created (status: pending)
✓ Salesperson notified
✓ Super Admin notified
✓ Shopkeeper can continue using app until billing cycle ends
✓ AutoPay NOT cancelled yet (requires admin approval)
```

---

# SECTION 2 — SALESPERSON FLOWS

---

## F2-01 — ONBOARD A NEW SHOPKEEPER (FULL 4-STEP FLOW)

```
TRIGGER:       Salesperson taps "Add New Shop" on their dashboard
PRECONDITIONS: Salesperson is logged in, Super Admin has set up plan configs
ACTORS:        Salesperson, Flutter, Node.js, Razorpay, AiSensy, Supabase Auth
```

### Happy Path

```
Step 1  — Salesperson taps "Add New Shop" on dashboard
          Flutter navigates to: /salesperson/shops/add/details (S2-04)
          addShopNotifierProvider initialized with empty state
          4-step progress bar shown: [1 Details] ─ [2 Branding] ─ [3 Plan] ─ [4 AutoPay]

── STEP 1: DETAILS ────────────────────────────────────────────────────────────

Step 2  — Salesperson fills shop information form
          Fields: Shop Name, Owner Name, Mobile, WhatsApp, Address, City, State, PIN
          Fields: GST Number (optional), Business Type (dropdown)
          Flutter validates each field on blur (leave field)

Step 3  — Taps "Next: Branding →"
          Flutter: validates all required fields
          addShopNotifierProvider.saveStep1(details) — saves to local state
          Navigates to: /salesperson/shops/add/branding (S2-05)
          Step 1 circle turns green ✓

── STEP 2: BRANDING ────────────────────────────────────────────────────────────

Step 4  — Logo upload (optional)
          Salesperson taps logo upload zone
          Bottom sheet: [Take Photo] [Choose from Gallery] [Cancel]
          image_picker returns image file
          Image cropped to square (1:1 ratio)
          Preview shown in circle + bill header preview card below

Step 5  — Taps "Next: Select Plan →"
          addShopNotifierProvider.setLogo(imageFile) — stores locally
          Navigates to: /salesperson/shops/add/plan (S2-06)
          Step 2 circle turns green ✓

── STEP 3: PLAN SELECTION ──────────────────────────────────────────────────────

Step 6  — Salesperson selects a plan
          3 plan cards shown: Basic ₹299 / Pro ₹599 / Business ₹999
          Taps Pro → card gets orange border + checkmark
          Template auto-assign info shown:
            "Based on 'Clothing' type, 'clothing_festival_offer' will be assigned"

Step 7  — Taps "Next: AutoPay →"
          addShopNotifierProvider.selectPlan('pro')
          Navigates to: /salesperson/shops/add/autopay (S2-07)
          Step 3 circle turns green ✓

── STEP 4: AUTOPAY SETUP ───────────────────────────────────────────────────────

Step 8  — Salesperson enters shopkeeper's UPI ID
          OR: taps "Scan UPI QR Code" → opens camera → scans → auto-fills
          UPI ID validated: must match pattern xxx@bankname

Step 9  — Taps "Create AutoPay Mandate"
          Flutter calls: POST /subscriptions/autopay/create
          Body: { shopId: (temp), upiId, plan: 'pro', planAmount: 599 }
          Wait — backend creates all records first

Step 10 — Backend creates shop + mandate (atomic)
          Node.js:
            a. Creates Supabase Auth user (phone-based)
            b. Creates profiles record (role: 'shopkeeper')
            c. Creates shops record (status: 'pending_setup')
            d. Creates shop_credits record (pro plan limits)
            e. Creates shop_settings record (defaults)
            f. Uploads logo to Supabase Storage (if provided)
            g. Assigns template based on business type
            h. Creates Razorpay subscription
            i. Sends AutoPay mandate request to shopkeeper's UPI
            j. Creates subscriptions record (status: 'pending')
            k. Returns: { shopId, mandateId, status: 'pending' }

Step 11 — Flutter shows waiting screen
          Animated orange pulse circle
          "Waiting for shopkeeper to approve AutoPay..."
          "The shopkeeper will see a notification in their UPI app"
          Salesperson hands phone to shopkeeper to approve
          Flutter polls: GET /subscriptions/autopay/status?shopId={id} every 10 seconds

Step 12 — Shopkeeper approves mandate in their UPI app (e.g. GPay, PhonePe)
          Razorpay receives approval → fires webhook to backend
          Backend: updates subscriptions.status = 'active'
          Next poll by Flutter returns: status = 'approved'

Step 13 — Flutter stops polling, navigates to: /salesperson/shops/add/success (S2-08)
          Large green checkmark
          "Shop Added!" headline
          Shop summary card (name, plan, AutoPay status: Active ✓)
          Credentials info: "Login details sent to shopkeeper's WhatsApp"

Step 14 — Backend sends credentials (async — happens in Step 10j)
          Node.js sends WhatsApp via AiSensy:
          "Welcome to billing project! Your login number: {phone}.
           Download the app and log in with OTP."
          shops.status updated to 'active'
```

### Failure Paths

```
FAIL at Step 3 — Phone number already registered:
  Backend returns: SHOP_PHONE_EXISTS
  Flutter shows: error on /details form
  "A shop is already registered with this phone number."

FAIL at Step 9 — Razorpay mandate creation fails:
  Backend returns error
  Flutter shows: "Could not create AutoPay mandate. Check UPI ID and try again."
  Retry option shown
  Note: if shop was already created (step 10a-k partial), backend rolls back
  or marks shop as 'pending_setup' for completion later

FAIL at Step 11 — Mandate approval timeout (10 minutes):
  Flutter shows: "Mandate approval timed out."
  Two options:
    [Resend Request] → resend mandate notification to shopkeeper's UPI
    [Set Up Later]   → shop created without AutoPay (status: pending_setup)
                       Salesperson can come back later to complete

FAIL at Step 11 — Shopkeeper rejects mandate in UPI app:
  Razorpay webhook: mandate status = 'rejected'
  Flutter shows: "The shopkeeper declined the AutoPay request."
  Options:
    [Try Again with Different UPI] → re-enter UPI and retry
    [Set Up Later]                 → leave as pending_setup
```

### Postconditions

```
✓ profiles record created (role: shopkeeper)
✓ shops record created (status: active)
✓ shop_credits initialized at plan limits
✓ shop_settings created with defaults
✓ subscriptions record created (status: active)
✓ template assigned to shop
✓ Logo uploaded to Supabase Storage (if provided)
✓ Shopkeeper received WhatsApp with login credentials
✓ Salesperson sees shop in their shop list
```

---

## F2-02 — REVIEW AND ACTION A CANCELLATION REQUEST

```
TRIGGER:       Salesperson receives push notification of new cancellation request
               OR navigates to /salesperson/cancellations
PRECONDITIONS: A shopkeeper has submitted a cancellation request (F1-07)
ACTORS:        Salesperson, Flutter, Node.js backend
```

### Happy Path

```
Step 1  — Salesperson opens app, sees alert badge on Cancellations tab
          OR receives push notification "Shop {name} requested cancellation"

Step 2  — Navigates to: /salesperson/cancellations (S2-11)
          Pending requests shown first (red label "NEEDS ACTION")
          Request card: shop name + reason + submitted time + "⏳ Pending"

Step 3  — Taps request card
          Navigates to: /salesperson/cancellations/:requestId (S2-12)
          Shows: shop info, plan details, reason, financial impact (revenue lost)

Step 4  — Salesperson contacts shopkeeper first (recommended)
          Taps "Call {ownerPhone}" → tel: link
          OR taps "WhatsApp {ownerWhatsApp}" → wa.me/ link
          Attempts to understand reason and retain the shop

Step 5a — Salesperson decides to APPROVE:
          Taps [Approve Request] in bottom sticky bar
          Confirmation bottom sheet:
            "Approve cancellation for {shopName}?
             AutoPay will be cancelled by Super Admin.
             Shop access ends on {billingEndDate}."
          [Cancel] [Confirm Approve]
          Taps "Confirm Approve"
          Flutter calls: PATCH /cancellation-requests/:id
          Body: { action: 'approved', salespersonNote: '...' }
          Status updates to: Super Admin review pending

Step 5b — Salesperson decides to REJECT:
          Taps [Reject Request]
          Bottom sheet: "Reason for rejection" text field
          Taps "Confirm Rejection"
          Flutter calls: PATCH /cancellation-requests/:id
          Body: { action: 'rejected', salespersonNote: '...', rejectionReason: '...' }

Step 6  — SuccessToast shown + navigate back to list
          "Request approved / rejected"
          Super Admin notified (if approved) for final processing
```

### Postconditions

```
✓ cancellation_request updated with salesperson action
✓ Super Admin notified if approved (for AutoPay cancellation)
✓ Shopkeeper notified of decision via push notification
```

---

## F2-03 — EDIT AN EXISTING SHOP

```
TRIGGER:       Salesperson taps edit icon on shop detail screen
PRECONDITIONS: Salesperson is the assigned salesperson for this shop
ACTORS:        Salesperson, Flutter, Node.js
```

### Happy Path

```
Step 1  — Salesperson navigates to: /salesperson/shops/:id (S2-09)
Step 2  — Taps edit icon (top bar, pencil)
          Flutter navigates to: /salesperson/shops/:id/edit (S2-10)
          All fields pre-filled with current shop data

Step 3  — Salesperson edits one or more fields
          Flutter: form is dirty (changes detected)

Step 4  — Taps "Save Changes"
          Flutter calls: PUT /shops/:shopId
          Body: { only changed fields }
          Button shows spinner

Step 5  — Backend updates shop
          Node.js: validates changed fields
          Updates shops record
          If business_type changed: re-assigns template
          If plan changed: updates shop_credits limits

Step 6  — Success
          SuccessToast "Shop updated"
          Navigate back to: /salesperson/shops/:id
          Updated data reflected immediately
```

---

# SECTION 3 — SUPER ADMIN FLOWS

---

## F3-01 — CREATE A SALESPERSON ACCOUNT

```
TRIGGER:       Super Admin taps "+" on Salesperson Management screen
PRECONDITIONS: Super Admin is logged in
ACTORS:        Super Admin, Flutter, Node.js, Supabase Auth, AiSensy
```

### Happy Path

```
Step 1  — Super Admin navigates to: /admin/salespersons/add (S3-04)

Step 2  — Fills form:
          Full Name, Mobile Number, Email (optional), City/Region, Notes
          Sets temporary password (min 8 chars, 1 number, 1 uppercase)
          Confirms password

Step 3  — Taps "Create Salesperson Account"
          Flutter calls: POST /admin/salespersons
          Button shows spinner

Step 4  — Backend creates account
          Node.js:
            a. Creates Supabase Auth user (phone + email/password)
            b. Creates profiles record (role: 'salesperson')
            c. Creates salespersons record
            d. Sends WhatsApp via AiSensy:
               "Welcome to billing project Sales Team!
                Your login: {phone} / Password: {tempPassword}
                Download the app and log in via Sales Team login."

Step 5  — Success
          SuccessToast "Account created. Credentials sent to {phone}"
          Navigate back to: /admin/salespersons
          New salesperson appears in list (status: Active)
```

---

## F3-02 — APPROVE AUTOPAY CANCELLATION

```
TRIGGER:       Super Admin receives notification of salesperson-approved cancellation
               OR reviews pending cancellations on dashboard
PRECONDITIONS: Cancellation request exists with salesperson_action = 'approved'
               OR status = 'pending' (Super Admin can action directly)
ACTORS:        Super Admin, Flutter, Node.js, Razorpay
```

### Happy Path

```
Step 1  — Super Admin navigates to: /admin/cancellations/:requestId (S3-12)

Step 2  — Reviews: shop info, plan, reason, financial impact, mandate ID

Step 3  — Adds internal admin notes (optional)

Step 4  — Taps [Approve & Cancel AutoPay] (green button)
          Confirmation bottom sheet:
            "Confirm cancellation for {shopName}?
             This will cancel Razorpay mandate {mandateId}.
             Shop access ends on {billingEndDate}."
          [Cancel] [Confirm]

Step 5  — Taps "Confirm"
          Flutter calls: POST /admin/subscriptions/:subId/cancel
          Body: { cancellationRequestId, reason, adminNotes }
          Button shows spinner

Step 6  — Backend processes cancellation
          Node.js:
            a. POST /v1/subscriptions/{razorpaySubId}/cancel to Razorpay
               (cancel_at_cycle_end: 1 — cancels at billing period end)
            b. Updates subscriptions: status = 'cancelled', cancel_at_period_end = true
            c. Sets access_ends_at = end of current billing cycle
            d. Updates shops: status = 'active' (until billing ends) → triggers to cancel on date
            e. Updates cancellation_requests: status = 'approved', actioned_by = admin_id
            f. Sends WhatsApp to shopkeeper:
               "Your cancellation has been approved. You can use the app until {date}.
                We're sorry to see you go. Contact us if you change your mind."
            g. Sends WhatsApp to salesperson:
               "{shopName}'s cancellation has been processed. Access ends {date}."
            h. Logs to admin_actions table

Step 7  — Flutter shows: SuccessToast "Cancellation approved"
          Navigate back to: /admin/cancellations
          Request now shows: "✓ Approved by {adminName} on {date}"
```

### Postconditions

```
✓ Razorpay AutoPay mandate cancelled
✓ subscriptions.status = 'cancelled'
✓ Shop continues to work until billing cycle ends
✓ On billing end date: Edge Function changes shop.status = 'inactive'
✓ Shopkeeper + Salesperson notified
✓ admin_actions log entry created
```

---

## F3-03 — SUBMIT A WHATSAPP TEMPLATE FOR META APPROVAL

```
TRIGGER:       Super Admin creates/edits a template and taps "Submit for Approval"
PRECONDITIONS: Super Admin logged in, AiSensy connected
ACTORS:        Super Admin, Flutter, Node.js, AiSensy, Meta
```

### Happy Path

```
Step 1  — Super Admin navigates to: /admin/templates/:id (S3-09)
          Fills template form: name, category, body, variables
          Live preview shows resolved template text

Step 2  — Taps "Submit for Approval"
          Confirmation bottom sheet shown (warns about re-approval if editing)
          Taps "Confirm"
          Flutter calls: PUT /admin/templates/:id { submitToMeta: true }

Step 3  — Backend submits to AiSensy
          Node.js: POST to AiSensy template creation endpoint
          Template body + variables sent
          AiSensy returns: submissionId
          Node.js: updates template (meta_status: 'pending', submitted_at: now())

Step 4  — AiSensy submits to Meta (async — takes 24-48 hours)
          Meta reviews template
          AiSensy receives approval/rejection from Meta

Step 5 (24-48 hours later) — AiSensy fires webhook to backend
          POST /webhooks/aisensy/template-status
          Payload: { templateName, status: 'APPROVED' }

Step 6  — Backend processes webhook
          Node.js: updates template (meta_status: 'approved', approved_at: now())
          If approved: sets is_active = true (available to shops now)
          Sends push notification to Super Admin:
            "Template '{templateName}' approved by Meta. Now active."

Step 7  — Super Admin sees updated status on /admin/templates
          Green "✓ Approved" badge on template card
          Template now appears for shopkeepers of that business type
```

### Failure Paths

```
FAIL — Meta rejects template:
  AiSensy webhook: status = 'REJECTED', reason = "policy violation"
  Backend: meta_status = 'rejected', meta_rejection_reason = reason
  Push notification to Super Admin: "Template rejected. Reason: {reason}"
  Super Admin must edit template and resubmit
```

---

## F3-04 — HANDLE A FAILED AUTOPAY PAYMENT

```
TRIGGER:       Razorpay webhook: payment.failed on a subscription charge
PRECONDITIONS: System event — no user action triggers this
ACTORS:        Razorpay, Node.js webhook handler, Flutter (notifications)
```

### Flow

```
Step 1  — Razorpay attempts monthly AutoPay charge
          Fails: insufficient balance, UPI expired, bank declined

Step 2  — Razorpay fires webhook: payment.failed
          POST /webhooks/razorpay
          Payload: { event: 'payment.failed', subscriptionId, shopId }

Step 3  — Backend processes failure
          Node.js:
            a. Logs to webhook_logs
            b. Increments failure count on subscription
            c. If failure_count < 3: schedule retry (Razorpay does this automatically)
            d. Creates notification for shopkeeper:
               "⚠ AutoPay Failed. Update your UPI to continue."
            e. Creates notification for salesperson
            f. Sends WhatsApp to shopkeeper:
               "Payment of ₹{amount} failed. Please ensure your UPI account has
                sufficient balance. Razorpay will retry in 24 hours."

Step 4  — If failure_count reaches 3 (halted):
          Razorpay webhook: subscription.halted
          Node.js:
            a. Updates subscription: status = 'halted'
            b. Sends WhatsApp to shopkeeper:
               "Your subscription has been paused after 3 failed payments.
                Contact your salesperson to resolve."
            c. Notifies Super Admin + salesperson
            d. shops.status NOT changed yet (grace period: 7 days)

Step 5  — Grace period (7 days)
          After 7 days with no payment resolution:
          Scheduled Edge Function: sets shops.status = 'suspended'
          Shopkeeper cannot use app until payment resolved + salesperson reactivates

Step 6  — Shopkeeper resolves payment
          Salesperson contacts shopkeeper
          Shopkeeper updates UPI in their bank app
          Salesperson uses admin panel to reactivate mandate (Phase 2)
          OR: Super Admin creates new AutoPay mandate for shop
```

---

## F3-05 — ADD MANUAL CREDITS TO A SHOP

```
TRIGGER:       Super Admin taps "Add Bill Credits Manually" or "Add Msg Credits Manually"
               on shop detail screen — usually for support/compensation
PRECONDITIONS: Super Admin logged in
ACTORS:        Super Admin, Flutter, Node.js
```

### Happy Path

```
Step 1  — Super Admin navigates to: /admin/shops/:id (S3-07)
          Taps "Add Bill Credits Manually" → bottom sheet slides up

Step 2  — Bottom sheet form:
          - Credit type: Bill Credits (pre-selected based on which button tapped)
          - Amount field: numeric input (e.g. 50)
          - Reason field: text (required) "e.g. Compensation for outage on 2026-07-01"
          [Cancel] [Add Credits]

Step 3  — Taps "Add Credits"
          Flutter calls: POST /admin/shops/:id/credits/add
          Body: { creditType: 'bill_credits', amount: 50, reason: '...' }

Step 4  — Backend adds credits
          Node.js:
            a. Updates shop_credits: bill_credits += 50
            b. Logs to credit_transactions (manual_addition, performed_by = admin)
            c. Logs to admin_actions (action: 'credits_added')
            d. Sends WhatsApp to shopkeeper:
               "Good news! 50 bill credits have been added to your account by
                our support team."

Step 5  — SuccessToast "50 bill credits added"
          Bottom sheet closes
          Shop detail refreshes: updated credit count shown
```

---

# SECTION 4 — SYSTEM FLOWS (AUTOMATED)

---

## F4-01 — MONTHLY CREDIT RESET

```
TRIGGER:       Scheduled Supabase Edge Function (runs 00:01 IST on 1st of each month)
ACTORS:        Supabase Edge Function, database
```

### Flow

```
Step 1  — Edge function triggers (00:01 IST on 1st)

Step 2  — Query all active shops + their plans
          SELECT id, plan FROM shops WHERE status = 'active'

Step 3  — For each shop:
          a. Reset bill_credits to plan limit (Basic:100, Pro:300, Business:99999)
          b. Reset msg_credits to plan limit (Basic:300, Pro:800, Business:2000)
          c. Reset bill_credits_used = 0, msg_credits_used = 0
          d. Update billing_cycle_start, billing_cycle_end
          e. Log to credit_transactions (monthly_reset for each credit type)

Step 4  — All shops' credits reset for new month
          No notifications sent for credit reset (it's expected behavior)
          Realtime updates push new balances to open Flutter apps
```

---

## F4-02 — RAZORPAY AUTOPAY DEDUCTION

```
TRIGGER:       Razorpay fires subscription.charged webhook on billing date
ACTORS:        Razorpay, Node.js webhook handler
```

### Flow

```
Step 1  — Razorpay deducts ₹{plan_amount} from shopkeeper's UPI on billing date

Step 2  — Razorpay fires webhook: subscription.charged / payment.captured
          POST /webhooks/razorpay

Step 3  — Backend processes success
          Node.js:
            a. Verifies Razorpay webhook signature
            b. Logs to webhook_logs
            c. Updates subscription: last_billed_at = now()
            d. Calculates next billing date
            e. Creates notification for shopkeeper:
               "₹{amount} AutoPay deducted for {plan} plan. Next billing: {date}"
            f. Sends WhatsApp confirmation

Step 4  — Credits will be reset by monthly Edge Function (F4-01)
          (AutoPay deduction and credit reset are separate processes)
```

---

## F4-03 — AISENSY DELIVERY STATUS UPDATE

```
TRIGGER:       AiSensy fires delivery webhook when message status changes
ACTORS:        AiSensy, Node.js webhook handler, Supabase Realtime
```

### Flow

```
Step 1  — Customer's phone receives WhatsApp message
          WhatsApp sends delivery receipt to AiSensy

Step 2  — AiSensy fires delivery webhook
          POST /webhooks/aisensy/delivery
          Payload: { messageId: 'wamid.xxx', status: 'delivered', destination: '+91...' }

Step 3  — Backend updates delivery status
          Node.js:
            a. Verify X-AiSensy-Secret header
            b. Look up message:
               Bills: SELECT * FROM bills WHERE aisensy_message_id = messageId
               Campaigns: SELECT * FROM campaign_recipients WHERE aisensy_message_id = messageId

Step 4a — If bill message:
          Update bills: delivered_at = timestamp
          Create notification: "Bill #{number} delivered to {customerName} ✓"

Step 4b — If campaign message:
          Update campaign_recipients: status = 'delivered'
          Update campaigns: delivered_count += 1
          If all messages processed: status = 'completed'
          Supabase Realtime: Flutter delivery report screen updates live

Step 5  — If status = 'read' (customer opened message):
          Update delivered_at stays, status updated to 'read'
          No user-facing notification for read (too noisy)
```

---

## F4-04 — CREDIT LOW WARNING TRIGGER

```
TRIGGER:       Credit count drops below 20% of plan limit after any deduction
ACTORS:        Node.js (after bill send or campaign send), Flutter (push notification)
```

### Flow

```
Step 1  — Bill or campaign send completes (F1-02 Step 9 or F1-05 Step 8)
          Backend has new credit balance

Step 2  — Node.js checks: is new balance < 20% of plan limit?
          Bill credits: Basic < 20, Pro < 60, Business < unlimited (never triggers)
          Msg credits: Basic < 60, Pro < 160, Business < 400

Step 3  — If below threshold:
          Check: was a credit_low notification already sent in last 24 hours?
          (avoid notification spam)

Step 4  — If not recently notified:
          Create notification record (type: 'credit_low')
          Send FCM push notification to shopkeeper's device
          Message: "Only {n} {type} credits left. Buy more to keep sending."

Step 5  — Flutter receives push notification
          If app is open: in-app banner appears at top of screen
          If app is closed: push notification shown in device notification tray
          Tapping notification: opens /credits screen

Step 6  — If credits reach 0:
          Type changes to 'credit_exhausted' notification
          Dashboard shows: red banner "0 bill credits. You cannot send bills."
          New Bill button: still visible but tapping shows credit exhaustion modal
          [Buy Credits] CTA prominent
```

---

## FLOW DEPENDENCY MAP

```
F1-02 (Send Bill) requires:
  ✓ F1-01 (Login) completed
  ✓ At least 1 customer (via F1-03 or existing)
  ✓ bill_credits > 0 (topped up via F1-06 if needed)
  ✓ F2-01 (Shopkeeper onboarded) previously completed
  ✓ AiSensy template approved (F3-03 completed)

F1-05 (Bulk Campaign) requires:
  ✓ F1-01 (Login) completed
  ✓ msg_credits > 0
  ✓ At least 1 approved template (F3-03 completed)
  ✓ At least 1 customer in database

F2-01 (Onboard Shopkeeper) requires:
  ✓ Salesperson logged in (F2 login flow)
  ✓ Razorpay in live mode (platform settings)
  ✓ AiSensy connected (platform settings)
  ✓ At least 1 template per business type (F3-03 done for that type)

F3-02 (Approve Cancellation) requires:
  ✓ F1-07 (Cancel Request submitted) completed
  ✓ Super Admin logged in
  ✓ Razorpay subscription ID exists in subscriptions table
```

---

## ERROR ESCALATION PATH

```
Level 1 — App handles automatically:
  Network timeout → retry with exponential backoff (up to 3 retries)
  Session expired → silent re-login → retry original request

Level 2 — User handles:
  Insufficient credits → show top-up flow
  Invalid form fields → inline validation errors
  AiSensy send failed → "Try again" option (no credit deducted)

Level 3 — Salesperson handles:
  AutoPay mandate rejected → salesperson contacts shopkeeper
  Shop pending setup → salesperson completes setup
  Cancellation request → salesperson reviews

Level 4 — Super Admin handles:
  AutoPay payment failed 3× → Super Admin + salesperson coordinate
  Template rejected by Meta → Super Admin edits and resubmits
  Cancellation approval → Super Admin processes Razorpay cancellation
  Manual credit addition → Super Admin for support cases

Level 5 — Technical (One Stop Solutions dev team):
  AiSensy API down → monitor, no code fix, wait for AiSensy resolution
  Razorpay API down → monitor webhook_logs, process backlog when restored
  Supabase outage → app shows maintenance screen (maintenance_mode flag)
```

---

*FLOWS.md v1.0 — Billing Project — One Stop Solutions*
*14 critical flows across 3 roles + 4 system flows · July 2026*
*Next document: COMPONENTS.md*
