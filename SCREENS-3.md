# SCREENS-3.md — Super Admin Role
# Billing Project — Screen Specifications
# Version 1.0 | One Stop Solutions | July 2026
#
# This file covers ROLE 3: SUPER ADMIN
# Super Admin = One Stop Solutions internal team (Leeladhar + core team)
# Read alongside: DESIGN.md · CLAUDE.md · SCREENS-1.md · SCREENS-2.md
#
# FILE SERIES:
# SCREENS-1.md → Shopkeeper (primary user)
# SCREENS-2.md → Salesperson / Admin
# SCREENS-3.md → Super Admin (this file)

---

## SUPER ADMIN ROLE — CONTEXT

```
Who:        One Stop Solutions internal team only (Leeladhar + designated admins)
What:       Full platform control — manage salespersons, all shops, pricing,
            templates, cancellations, revenue, system config
Access:     Separate login — same Flutter app, separate role routing
Can do:     Everything. Add/remove salespersons, view ALL shops across ALL
            salespersons, manage 7 business type WhatsApp templates,
            set subscription plan limits, approve AutoPay cancellations,
            view platform-wide revenue reports, configure AiSensy + Razorpay
Cannot do:  Nothing is restricted. Super Admin has full platform access.
Risk note:  This role must be protected with strong password + 2FA in Phase 2.
            In Phase 1: password auth with very strong password requirement.
```

---

## SCREEN INDEX — SUPER ADMIN ROLE

```
S3-01   Super Admin Login Screen
S3-02   Super Admin Dashboard Screen
S3-03   Salesperson Management Screen
S3-04   Add Salesperson Screen
S3-05   Salesperson Detail Screen
S3-06   All Shops Screen
S3-07   Shop Detail (Admin View) Screen
S3-08   Business Templates Screen
S3-09   Template Detail / Edit Screen
S3-10   Subscription Plans Screen
S3-11   All Cancellation Requests Screen
S3-12   Cancellation Request Detail (Admin) Screen
S3-13   Revenue Report Screen
S3-14   Platform Settings Screen
S3-15   Super Admin Settings Screen
```

Total: 15 screens for Super Admin role.

---

## S3-01 — SUPER ADMIN LOGIN SCREEN

```
Route:       /admin/login
File:        lib/features/auth/presentation/admin_login_screen.dart
Header:      Navy gradient (unique to Super Admin — not used elsewhere)
             linear-gradient(180deg, #1A1A2E 0%, #2D2D4E 60%, #F5F5F5 100%)
Role:        Super Admin (unauthenticated)
Purpose:     Secure entry point for Super Admin — password auth, no OTP
Provider:    adminAuthNotifierProvider (AdminAuthNotifier)
```

### UI Sections (top → bottom)

```
1. NAVY GRADIENT HEADER (~200px)
   - bg: linear-gradient(180deg, #1A1A2E 0%, #2D2D4E 60%, transparent 100%)
   - App logo centered
   - Role badge: "Super Admin Portal"
     (pill, bg: rgba(232,104,10,0.25), border: 1px rgba(232,104,10,0.5),
      text: #E8680A orange, Inter 12px bold)
   - Warning badge below: "Restricted Access"
     (pill, bg: rgba(220,38,38,0.15), text: #DC2626, 11px)

2. WHITE FORM CARD (floats -20px overlap)
   - border-radius: 20px, bg: #FFFFFF, shadow: kShadowCard
   - padding: 20px 16px
   - Title: "Admin Login" (Inter 18px bold, #1A1A1A)
   - Sub: "One Stop Solutions — Internal Only" (Inter 13px, #999999 italic)

   Fields:
   - Email / Phone (admin uses email — not phone)
     Label: "Admin Email"
     Field: email keyboard
   - Password
     Label: "Password"
     Type: password with show/hide toggle
   
   - PrimaryButton "Log In" (full width orange pill)
     Disabled: when either field empty

3. SECURITY NOTE (below form card)
   - Lock icon + "This portal is for authorised administrators only.
     Unauthorised access is a violation of platform policy."
   - Inter 11px, #CCCCCC, center

4. FOOTER LINK
   - "Log in as Shopkeeper →" → /login (orange text link)
   - "Log in as Sales Team →" → /salesperson/login (orange text link)
```

### Actions

```
[Log In]                  → validate → AdminAuthNotifier.login(email, password)
                            → on success: navigate to /admin/dashboard
                            → on error: "Invalid credentials" below password field
[Shopkeeper link]         → /login
[Sales Team link]         → /salesperson/login
```

### States

```
Loading:  Button spinner
Error:    "Invalid email or password" (red, 12px, below password)
          After 5 failed attempts: "Too many attempts. Try again in 30 minutes."
          (security lockout — tracked in Supabase)
```

### Shared Widgets

```
PrimaryButton, AppCard
```

---

## S3-02 — SUPER ADMIN DASHBOARD SCREEN

```
Route:       /admin/dashboard
File:        lib/features/admin/presentation/dashboard_screen.dart
Header:      Navy gradient (same as login — unique to Super Admin)
             linear-gradient(180deg, #1A1A2E 0%, #2D2D4E 60%, transparent 100%)
Role:        Super Admin
Purpose:     Platform-wide health at a glance — MRR, shops, alerts, quick actions
Provider:    adminDashboardNotifierProvider (AdminDashboardNotifier)
```

### UI Sections (top → bottom)

```
1. NAVY GRADIENT HEADER (~180px)
   - Left: hamburger menu
   - Center: "billing project Admin" (white, Inter 14px, 70% opacity)
   - Right: avatar (initials, orange bg)
   - Below center: greeting "Good morning, {adminName}" (white, 16px bold)

2. MRR HERO CARD (white, overlapping header -20px)
   - border-radius: 16px, bg: #FFFFFF, shadow: kShadowCard
   - padding: 20px 16px
   
   Label: "MONTHLY RECURRING REVENUE" (LABEL style)
   Amount: "₹{mrr}" (Playfair Display 32px bold, #1A1A1A)
   Sub: "+{n} new shops this month" (Inter 13px, green #16A34A if positive)
   
   Divider
   
   Stats grid (2×2):
   ┌──────────────────┬──────────────────┐
   │ {n}              │ {n}              │
   │ Total Shops      │ Active Shops     │
   ├──────────────────┼──────────────────┤
   │ {n}              │ {n}              │
   │ Salespersons     │ Pending Issues   │
   └──────────────────┴──────────────────┘
   "Pending Issues" in red (#DC2626) if > 0

3. ALERTS SECTION (shows only if alerts exist)
   Each alert card (AppCard, left colored border):
   
   Alert types:
   ● Cancellation pending: amber border
     "{n} cancellation request(s) awaiting approval"
     → "Review" link → /admin/cancellations
   
   ● Payment failures: red border
     "{n} shop(s) have failed AutoPay payments"
     → "View" link → /admin/shops?filter=payment_failed
   
   ● Template expired: orange border
     "{n} WhatsApp template(s) need renewal"
     → "Manage" link → /admin/templates
   
   ● New shops pending: blue border
     "{n} shops added today across all salespersons"
     (informational only)

4. QUICK ACTIONS GRID (2×2, margin 12px)
   Card 1: SALESPERSONS (navy)
     Icon: team icon (white)
     Label: "Salespersons" + "{n} active"
     Tap → /admin/salespersons
   
   Card 2: ALL SHOPS (navy)
     Icon: store icon (white)
     Label: "All Shops" + "{n} total"
     Tap → /admin/shops
   
   Card 3: TEMPLATES (orange — frequently updated)
     Icon: message template icon (white)
     Label: "Templates" + "{n} active"
     Tap → /admin/templates
   
   Card 4: REVENUE (navy)
     Icon: chart/graph icon (white)
     Label: "Revenue" + "₹{mrr}/mo"
     Tap → /admin/revenue

5. RECENT ACTIVITY FEED
   Section header: "Recent Activity" (LABEL style)
   Last 10 platform events:
   Each row (no card — plain list with dividers):
   - Icon (color by type) + event text + timestamp
   
   Event types:
   🟢 "{shopName} subscribed to Pro Plan" (green dot)
   🟡 "{shopName} requested cancellation" (amber dot)
   🔴 "{shopName} AutoPay failed" (red dot)
   🔵 "{salespersonName} added {shopName}" (blue dot)
   🟠 "{n} messages sent by {shopName}" (orange dot)
   
   "View all activity" link (orange) → Phase 2 feature

6. BOTTOM TAB BAR (5 tabs — Super Admin has more)
   Dashboard | Shops | Salespersons | Templates | Settings
   Active: orange icon + label + pill bg
```

### Shared Widgets

```
AppCard, IconContainer, EmptyState
```

---

## S3-03 — SALESPERSON MANAGEMENT SCREEN

```
Route:       /admin/salespersons
File:        lib/features/admin/presentation/salesperson_list_screen.dart
Header:      Light — white top bar
Role:        Super Admin
Purpose:     View + manage all salesperson accounts on the platform
Provider:    salespersonListNotifierProvider (AdminSalespersonListNotifier)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Back → /admin/dashboard
   - "Salespersons" (Inter 17px bold)
   - Right: [search icon] [+ add icon → /admin/salespersons/add]

2. STATS STRIP
   "{total} salespersons · {active} active · {n} shops managed total"
   Inter 12px, #555555, padding 12px 16px, bg: #F5F5F5

3. SEARCH BAR
   "Search by name or phone"

4. FILTER CHIPS
   [All] [Active] [Inactive]

5. SALESPERSON LIST (scrollable, 8px gap)
   Each salesperson card (AppCard):
   - Left: avatar circle (initials, orange bg, 40px)
   - Center:
       Name (Inter 14px bold, #1A1A1A)
       Phone (Inter 12px, #555555)
       Added on: {date} (11px, muted)
   - Right:
       "{n} shops" (Inter 13px bold, #1A1A1A)
       Status dot: green (active) / red (inactive)
   - Tap → /admin/salespersons/:id

6. FAB
   Orange + circle, bottom right → /admin/salespersons/add
```

### Empty State

```
Illustration: team icon (gray)
Title: "No salespersons yet"
Sub: "Add your first sales team member"
CTA: PrimaryButton "Add Salesperson" → /admin/salespersons/add
```

### Shared Widgets

```
AppCard, FilterChipRow, EmptyState, PrimaryButton
```

---

## S3-04 — ADD SALESPERSON SCREEN

```
Route:       /admin/salespersons/add
File:        lib/features/admin/presentation/add_salesperson_screen.dart
Header:      Light — white
Role:        Super Admin
Purpose:     Create a new salesperson account — credentials sent via WhatsApp
Provider:    addSalespersonNotifierProvider
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - "Cancel" (text) + "Add Salesperson" title + empty right

2. FORM CARD (AppCard, margin 16px)
   Section label: "SALESPERSON DETAILS"
   
   Fields:
   - Full Name *           → TextFormField
   - Mobile Number *       → TextFormField (prefix: +91, phone keyboard)
     (this becomes their login number)
   - Email Address         → TextFormField (email keyboard, optional)
   - City / Region *       → TextFormField (where they operate)
   - Notes (internal)      → multi-line, optional
     "e.g. Handles Vijayawada and Guntur region"

3. PASSWORD SECTION (AppCard, margin 16px)
   Section label: "LOGIN CREDENTIALS"
   
   - "Temporary Password *"
     Field: TextFormField (password type, show/hide toggle)
     Note: "Salesperson must change this on first login" (11px, muted)
   - "Confirm Password *" → TextFormField
   
   Password rules shown below:
   ● Minimum 8 characters
   ● At least 1 number
   ● At least 1 uppercase letter

4. CREDENTIAL DELIVERY INFO (AppCard, bg: #EFF6FF)
   Left: info icon (blue)
   "Login credentials will be sent to {mobileNumber} via WhatsApp after creation."
   Inter 13px, #2563EB

5. SAVE BUTTON
   PrimaryButton "Create Salesperson Account" (orange pill, full width)
   padding: 16px
   Disabled: when required fields empty or passwords don't match
```

### Actions

```
[Cancel]                      → confirm discard → /admin/salespersons
[Create Salesperson Account]  → AddSalespersonNotifier.create()
                                → on success: SuccessToast "Account created"
                                             → /admin/salespersons
                                → on error: SnackBar error message
```

### Validation

```
Name:         Required, min 2 chars
Mobile:       Required, 10 digits, unique (check against existing salespersons)
City/Region:  Required
Password:     Required, min 8 chars, 1 number, 1 uppercase
Confirm:      Must match password
```

### Shared Widgets

```
PrimaryButton, AppCard, SuccessToast
```

---

## S3-05 — SALESPERSON DETAIL SCREEN

```
Route:       /admin/salespersons/:salespersonId
File:        lib/features/admin/presentation/salesperson_detail_screen.dart
Header:      Orange gradient
Role:        Super Admin
Purpose:     Full view of one salesperson — their shops, performance, account actions
Provider:    adminSalespersonDetailNotifierProvider — takes salespersonId param
```

### UI Sections (top → bottom)

```
1. ORANGE GRADIENT HEADER
   - Back → /admin/salespersons
   - Salesperson name as title (white, bold)
   - Edit icon (white)

2. PROFILE CARD (white, overlapping header)
   - Avatar (56px, initials)
   - Name (18px bold) + phone (13px, muted)
   - City/Region badge (orange pill)
   - Status: Active / Inactive (green / red pill)
   - Member since: {date} (11px, muted)

3. PERFORMANCE STATS CARD (AppCard)
   Section label: "PERFORMANCE"
   Stats grid (2×2):
   ┌────────────────┬────────────────┐
   │ {n}            │ ₹{amount}      │
   │ Total Shops    │ Revenue Gen.   │
   ├────────────────┼────────────────┤
   │ {n}            │ {n}            │
   │ Active Shops   │ This Month     │
   └────────────────┴────────────────┘
   "Revenue Generated" = sum of all subscription fees from this salesperson's shops

4. THEIR SHOPS (AppCard)
   Section label: "SHOPS ({count})"
   - List of last 5 shops + "View All {n} Shops →" link
   Each row:
   - Shop name (bold) + business type badge
   - Plan + status dot
   Tap row → /admin/shops/:shopId

5. ACCOUNT ACTIONS (AppCard, margin 16px)
   Section label: "ACCOUNT MANAGEMENT"
   - Reset Password → bottom sheet: Super Admin sets new temp password
   - Deactivate Account → red text button → confirmation bottom sheet
     Note: "Deactivating will not affect their shops — Super Admin takes over"
   - Reactivate Account → (shows only if inactive)

6. TIMELINE (AppCard — Phase 2)
   Placeholder: "Activity timeline coming soon"
```

### Actions

```
[Back]                → /admin/salespersons
[Edit]                → inline edit (name, phone, region)
[View All Shops]      → /admin/shops?salespersonId={id}
[Shop row tap]        → /admin/shops/:shopId
[Reset Password]      → bottom sheet password form
[Deactivate]          → confirmation bottom sheet → AdminSalespersonNotifier.deactivate()
```

### Shared Widgets

```
AppCard, PrimaryButton, SecondaryButton
```

---

## S3-06 — ALL SHOPS SCREEN

```
Route:       /admin/shops
File:        lib/features/admin/presentation/all_shops_screen.dart
Header:      Light — white top bar
Role:        Super Admin
Purpose:     Complete platform-wide list of all shops — all salespersons, all plans
Provider:    adminShopListNotifierProvider
             Query params: ?salespersonId= ?filter= ?plan=
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Back → /admin/dashboard
   - "All Shops" (Inter 17px bold)
   - Right: [search] [filter icon (opens advanced filter bottom sheet)]

2. STATS STRIP
   "{total} shops · {active} active · ₹{mrr} MRR"
   Inter 12px, #555555, bg: #F5F5F5

3. SEARCH BAR
   "Search shop name, owner, phone, city"

4. FILTER CHIPS ROW 1 — By Status
   [All] [Active] [Pending] [Suspended] [Payment Failed]

5. FILTER CHIPS ROW 2 — By Plan
   [All Plans] [Basic] [Pro] [Business]

6. ADVANCED FILTER BOTTOM SHEET (on filter icon tap)
   - Salesperson: Dropdown (All / {salespersonName} list)
   - Business Type: Multi-select chips (7 types)
   - State: Dropdown (Indian states)
   - Date Added: Date range picker
   - [Apply Filters] PrimaryButton + [Reset] SecondaryButton

7. SHOP LIST (scrollable, 8px gap)
   Each shop card (AppCard):
   - Left: Shop logo circle (36px, initials fallback)
   - Center:
       Shop name (Inter 14px bold)
       Salesperson: {salespersonName} (Inter 11px, #999999)
       City + Business type (Inter 12px, #555555)
   - Right:
       Plan pill (Basic/Pro/Business with color coding)
       Status dot (green/amber/red)
       Monthly value: "₹{planAmount}" (Inter 12px bold, #E8680A)
   - Tap → /admin/shops/:shopId

8. LOAD MORE / PAGINATION
   Auto-paginate on scroll
   Show loading indicator at bottom while fetching
```

### Empty State

```
Title: "No shops found"
Sub: "Try adjusting your filters"
CTA: SecondaryButton "Clear Filters"
```

### Shared Widgets

```
AppCard, FilterChipRow, EmptyState, SecondaryButton
```

---

## S3-07 — SHOP DETAIL (ADMIN VIEW) SCREEN

```
Route:       /admin/shops/:shopId
File:        lib/features/admin/presentation/shop_detail_screen.dart
Header:      Orange gradient
Role:        Super Admin
Purpose:     Full admin view of any shop — everything visible, all actions available
Provider:    adminShopDetailNotifierProvider — takes shopId param
```

### UI Sections (top → bottom)

```
1. ORANGE GRADIENT HEADER
   - Back → /admin/shops
   - Shop name (white, bold)
   - Right: edit icon + kebab menu (⋮) for more actions

2. SHOP PROFILE CARD (white, overlapping)
   - Logo (56px) + name (18px bold) + business type badge
   - Owner: {name} · {phone}
   - Managed by: {salespersonName} (link → /admin/salespersons/:id)
   - Status badge: Active / Pending / Suspended

3. SUBSCRIPTION CARD (AppCard)
   Section label: "SUBSCRIPTION & BILLING"
   - Plan: {planName} badge (colored by plan)
   - Monthly: ₹{amount}
   - AutoPay: {status} (green/amber/red)
   - UPI ID: {upiId} (partially masked: xxxx@{bank})
   - Next billing: {date}
   - Started: {startDate}
   - Billing history (last 5 payments):
       Each: {date} · ₹{amount} · Paid ✓ / Failed ✗
   - "Download Invoice" link (orange, per payment row) — Phase 2

4. USAGE STATS CARD (AppCard)
   Section label: "PLATFORM USAGE"
   - Bill Credits: {used}/{total} (progress bar)
   - Msg Credits: {used}/{total} (progress bar)
   - Customers: {count}/{limit}
   - Total Bills Sent (all time): {n}
   - Total Bulk Campaigns: {n}
   - Last Active: {timestamp}
   - WhatsApp Messages Sent (all time): {n}
   - AiSensy cost this month: "~₹{cost}" (internal — only visible to Super Admin)

5. SHOP DETAILS CARD (AppCard)
   - Full address, city, state, PIN
   - GST number
   - WhatsApp number
   - Business type + assigned template
   - App login number
   - Date onboarded

6. ADMIN ACTIONS CARD (AppCard, margin 16px)
   Section label: "ADMIN ACTIONS"
   
   Action rows (each as tappable row with chevron):
   - Change Plan                → inline plan selector bottom sheet
   - Change Assigned Template   → /admin/templates (push, returns selection)
   - Add Bill Credits Manually  → bottom sheet: add {n} credits (for support use)
   - Add Msg Credits Manually   → bottom sheet: add {n} credits
   - Reset Shopkeeper Password  → bottom sheet: set temp password
   - Reassign Salesperson       → bottom sheet: pick from salesperson list
   - Suspend Shop               → red text → confirmation → suspend
   - Reactivate Shop            → (shows only if suspended)
   - Delete Shop                → red text → double confirmation (type shop name)
                                   "This cannot be undone"

7. CANCELLATION REQUESTS (AppCard)
   Section label: "CANCELLATION HISTORY"
   - List of any cancellation requests from this shop
   - Each: date + reason + status + who actioned it
   - "No requests" if none
```

### Actions

```
[Back]                  → /admin/shops
[Edit]                  → same as S2-10 (edit shop screen) but with admin access
[Change Plan]           → bottom sheet plan selector
[Add Credits]           → bottom sheet: number input + confirm
[Suspend]               → confirmation → AdminShopNotifier.suspend()
[Delete]                → double-confirm dialog (type shop name) → AdminShopNotifier.delete()
[Reassign Salesperson]  → bottom sheet: searchable salesperson list
```

### Shared Widgets

```
AppCard, PrimaryButton, SecondaryButton
```

---

## S3-08 — BUSINESS TEMPLATES SCREEN

```
Route:       /admin/templates
File:        lib/features/admin/presentation/templates_screen.dart
Header:      Light — white top bar
Role:        Super Admin
Purpose:     Manage all 7 WhatsApp business type templates — view, edit, activate
Provider:    adminTemplatesNotifierProvider
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Back → /admin/dashboard
   - "WhatsApp Templates" (Inter 17px bold)
   - Right: + add icon → /admin/templates/add (for adding new business type)

2. PLATFORM STATUS BANNER
   AiSensy connection status:
   ● Connected: green banner "AiSensy API connected · Templates synced {time}"
   ● Error: red banner "AiSensy connection failed. Check API settings."
   bg: #F0FDF4 (connected) / #FEF2F2 (error)
   Border: green/red left 4px

3. TEMPLATE FILTER CHIPS
   [All] [Active] [Pending Approval] [Rejected] [Inactive]
   (Meta approval status from AiSensy)

4. TEMPLATE LIST (7 cards, one per business type)
   Each template card (AppCard, 8px gap):
   
   TOP ROW:
   - Business type icon (IconContainer, 40px, colored bg)
   - Business type name (Inter 14px bold, #1A1A1A)
   - Meta approval status badge (right):
       Approved: green pill "✓ Approved"
       Pending:  amber pill "⏳ Pending"
       Rejected: red pill "✗ Rejected"
   
   MIDDLE ROW:
   - Template name: "{templateName}" (Inter 13px, #555555 italic)
   - Category: "Marketing" / "Utility" (Inter 11px, muted)
   
   PREVIEW ROW (truncated to 2 lines):
   - Template text with {{variables}} highlighted in orange
   - e.g. "New arrivals at {{shop_name}}! Visit us for {{offer}}..."
   
   BOTTOM ROW:
   - Active toggle (right): iOS-style switch
     On = template is assigned to shops of this type
     Off = template disabled (shops fallback to generic)
   - "Edit" link (orange text, left) → /admin/templates/:id

5. SUBMISSION GUIDE CARD (AppCard, bg: #EFF6FF, bottom of list)
   Left: info icon (blue)
   Title: "Template Approval Process"
   Body: "New or edited templates must be submitted to Meta for approval.
          This typically takes 24-48 hours. Avoid editing approved templates
          without good reason — re-approval is required."
   Inter 13px, #2563EB
```

### Actions

```
[Add template +]       → /admin/templates/add
[Edit link]            → /admin/templates/:id
[Active toggle]        → AdminTemplatesNotifier.toggleActive(templateId)
                         → updates AiSensy assignment
[Card tap]             → /admin/templates/:id
```

### Shared Widgets

```
AppCard, FilterChipRow, IconContainer
```

---

## S3-09 — TEMPLATE DETAIL / EDIT SCREEN

```
Route:       /admin/templates/:templateId
             /admin/templates/add (new template)
File:        lib/features/admin/presentation/template_detail_screen.dart
Header:      Orange gradient
Role:        Super Admin
Purpose:     View + edit a WhatsApp template — submit to Meta for approval via AiSensy
Provider:    adminTemplateDetailNotifierProvider — takes templateId param
```

### UI Sections (top → bottom)

```
1. ORANGE GRADIENT HEADER
   - Back → /admin/templates
   - "{BusinessType} Template" as title (white, bold)
   - Right: "Save" (white text button) — same as save button

2. STATUS CARD (white, overlapping header)
   For existing templates:
   - Meta Approval Status: large badge
       Approved: green bg pill "✓ Approved by Meta"
       Pending:  amber bg "⏳ Pending Meta Approval"
       Rejected: red bg "✗ Rejected — See reason below"
   - Template ID on AiSensy: {templateId} (monospace, 12px, muted)
   - Last updated: {date}
   - Rejection reason (if rejected): red card with Meta's reason text

3. TEMPLATE FORM (AppCard, margin 16px)
   Section label: "TEMPLATE DETAILS"
   
   Fields:
   - Template Name (for AiSensy)
     Field: TextFormField
     Note: "Must be lowercase, underscores only. e.g. clothing_festival_offer"
   
   - Business Type (read-only for existing, dropdown for new)
     Dropdown: 7 types + "Other"
   
   - Category
     Dropdown: [Marketing] [Utility]
     Note: Marketing = ₹0.86/msg · Utility = ₹0.12/msg (cost shown below)
   
   - Template Language: "en" (English — fixed for now)
   
   - Template Header (optional)
     Dropdown: [None] [Text] [Image] [Document]
     If Text: TextFormField for header text
   
   - Template Body * (main message)
     Multi-line TextFormField (min 3 lines, max 10 lines)
     Character count: {n}/1024 (AiSensy limit)
     Variable guide below:
       "Use {{1}}, {{2}} for dynamic variables"
       "e.g. New arrivals at {{1}}! Visit us for {{2}} off."
   
   - Template Footer (optional)
     TextFormField (short text, no variables)
     e.g. "billing project · Reply STOP to opt out"
   
   - Variables List
     Dynamic add rows:
     [ Variable {{1}} ] [ Description: "Shop name"   ]
     [ Variable {{2}} ] [ Description: "Offer %"     ]
     + Add Variable (orange text link)
     Note: "Variables must match what your backend sends to AiSensy"

4. PREVIEW CARD (AppCard, bg: #F0F0F0 — simulates WhatsApp)
   Section label: "LIVE PREVIEW"
   WhatsApp-style message bubble:
   - bg: #DCF8C6 (WhatsApp green), border-radius: 12px, padding 12px
   - Shows template with sample values filled in:
     {{1}} → "Raju Silks"
     {{2}} → "30%"
   - Preview updates live as template body is edited
   - Note: "This is how recipients will see the message" (11px, muted)

5. SHOPS USING THIS TEMPLATE (read-only, AppCard)
   Section label: "ASSIGNED TO"
   - "{n} shops of type {businessType} are using this template"
   - List of first 5 shop names (truncated)
   - "View all shops" link → /admin/shops?businessType={type}
```

### BOTTOM STICKY BAR

```
Left: Category cost note: "Marketing: ₹0.86/msg" (muted)
Right: Two buttons side by side:
  [Save Draft] (SecondaryButton, outlined) — saves without submitting
  [Submit for Approval] (PrimaryButton orange) — saves + submits to Meta via AiSensy
```

### Actions

```
[Save Draft]              → AdminTemplateNotifier.saveDraft()
                            → SuccessToast "Draft saved"
[Submit for Approval]     → AdminTemplateNotifier.submit()
                            → confirmation bottom sheet:
                              "This will submit the template to Meta for approval.
                               If already approved, editing requires re-approval."
                            → on confirm: submit → status changes to "Pending"
                            → SuccessToast "Template submitted for approval"
[Add Variable]            → appends new variable row
[Back]                    → /admin/templates (confirm if unsaved changes)
```

### Shared Widgets

```
PrimaryButton, SecondaryButton, AppCard, BottomActionBar, SuccessToast
```

---

## S3-10 — SUBSCRIPTION PLANS SCREEN

```
Route:       /admin/plans
File:        lib/features/admin/presentation/plans_screen.dart
Header:      Light — white
Role:        Super Admin
Purpose:     View + edit subscription plan pricing and credit limits
Provider:    adminPlansNotifierProvider
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Back → /admin/dashboard
   - "Subscription Plans" (Inter 17px bold)
   - Right: edit mode toggle (pencil icon)

2. WARNING BANNER (always visible)
   Amber left-border card:
   "Changes to plan pricing and limits affect ALL new subscriptions immediately.
    Existing subscriptions renew at the price they signed up for."
   Inter 13px, amber (#F59E0B)

3. PLAN CARDS (3 stacked cards, same visual style as S2-06 but editable)

   Each plan card (AppCard):
   
   PLAN HEADER:
   - Plan name badge (colored)
   - Current price (Inter 24px bold)
   - Edit mode: price becomes TextFormField
   
   LIMITS SECTION:
   In view mode: plain text rows
   In edit mode: each limit becomes a TextFormField (number)
   
   - Bill Credits/month: {n} (∞ for Business)
   - Msg Credits/month: {n}
   - Customer Limit: {n} (∞ for Business)
   - Bill History: "{n} months" / "Unlimited"
   
   SHOPS ON THIS PLAN:
   - "{n} active shops on this plan" (Inter 12px, muted)
   - "₹{planPrice × shopCount}/month total" (Inter 12px, bold)

4. TOP-UP PACK PRICING (AppCard)
   Section label: "CREDIT TOP-UP PACKS"
   
   Editable table:
   Pack Name | Credits | Price | Cost/Credit
   - 5 rows (one per pack)
   - In edit mode: Price column becomes editable
   - Cost/Credit auto-calculated (read-only)
   
   Below table:
   "Your AiSensy cost: ₹0.86/marketing msg · ₹0.12/utility msg"
   (Inter 11px, muted — reference for pricing decisions)

5. SAVE SECTION (edit mode only)
   - PrimaryButton "Save Plan Changes" (orange pill)
   - SecondaryButton "Cancel" (outlined)
```

### Actions

```
[Edit toggle (top bar)]   → AdminPlansNotifier.enterEditMode()
                            → all fields become editable
[Save Plan Changes]       → double confirmation bottom sheet:
                            "Are you sure? New subscriptions will use these prices."
                            [Confirm] → AdminPlansNotifier.savePlans()
                            → SuccessToast "Plans updated"
[Cancel (edit mode)]      → AdminPlansNotifier.cancelEdit() → revert changes
```

### Shared Widgets

```
AppCard, PrimaryButton, SecondaryButton, SuccessToast
```

---

## S3-11 — ALL CANCELLATION REQUESTS SCREEN

```
Route:       /admin/cancellations
File:        lib/features/admin/presentation/cancellation_list_screen.dart
Header:      Light — white
Role:        Super Admin
Purpose:     Platform-wide view of all cancellation requests — from ALL shops
Provider:    adminCancellationListNotifierProvider
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Back → /admin/dashboard
   - "Cancellation Requests" (Inter 17px bold)
   - Right: filter icon

2. STATS STRIP
   "{pending} pending · {approved} approved · {rejected} rejected"
   Pending in red if > 0

3. FILTER CHIPS
   [All] [Pending] [Approved] [Rejected]

4. SORT OPTIONS (inline, right-aligned text)
   "Sort: Newest" → tap to toggle Newest / Oldest / Plan Value

5. REQUEST LIST (scrollable, 8px gap)
   Each request card (AppCard):
   - Top row:
       Shop name (14px bold) + Salesperson name (11px, muted)
   - Middle row:
       Reason (13px, #555555, 1 line truncated)
       Plan: {planName} · ₹{amount}/mo (12px, muted)
   - Bottom row:
       Submitted: {relativeTime} (11px, muted)
       Status badge (right): Pending amber / Approved green / Rejected gray
       "Actioned by {name}" (11px, muted — for non-pending)
   - Tap → /admin/cancellations/:requestId

6. PENDING PRIORITY SECTION (only if pending > 0)
   Shows pending requests at the TOP in a separate "Needs Action" section
   before "All Requests" section
   - Section divider: "NEEDS ACTION ({n})" in red label style
   - Then: "ALL REQUESTS" section below
```

### Empty State

```
Illustration: checkmark (green)
Title: "No cancellation requests"
Sub: "All shops are active and in good standing"
```

### Shared Widgets

```
AppCard, FilterChipRow, EmptyState
```

---

## S3-12 — CANCELLATION REQUEST DETAIL (ADMIN) SCREEN

```
Route:       /admin/cancellations/:requestId
File:        lib/features/admin/presentation/cancellation_detail_screen.dart
Header:      Orange gradient
Role:        Super Admin
Purpose:     Full view + final action on a cancellation request
Provider:    adminCancellationDetailNotifierProvider — takes requestId param
```

### UI Sections (top → bottom)

```
1. ORANGE GRADIENT HEADER
   - Back → /admin/cancellations
   - "Cancellation Request" (white, bold)
   - Request ID: "#REQ-{id}" (white, 12px, 70% opacity below title)

2. SHOP & SALESPERSON CARD (white, overlapping)
   - Shop logo + name + business type badge
   - Owner: {name} · {phone}
   - Managed by: {salespersonName} (link)
   - Plan: {planName} · ₹{amount}/mo (bold)
   - Customer since: {startDate}
   - AutoPay UPI: {maskedUpi}

3. REQUEST DETAILS CARD (AppCard)
   - Submitted by: Shopkeeper
   - Submitted at: {fullDateTime}
   - Reason: {fullReason}
   - Shopkeeper note: "{note}" (if provided)
   - Salesperson note: "{note}" (if salesperson added notes)
   - Salesperson action: Approved / Rejected / Pending review

4. FINANCIAL IMPACT CARD (AppCard, bg: #FEF2F2)
   Left: money icon (red)
   - Monthly revenue lost: ₹{planAmount}
   - Remaining billing period: {days} days (until {endDate})
   - AutoPay mandate ID: {mandateId} (Razorpay reference)
   - "Approving will cancel Razorpay mandate ID {mandateId}" (13px, red)

5. CANCELLATION TERMS (AppCard)
   - Shop access ends: {billingEndDate}
   - Data retention: 90 days post-cancellation
   - AutoPay cancellation: processed immediately upon approval
   - "Shop can re-subscribe anytime" (green, 12px)

6. ADMIN ACTION SECTION (AppCard)
   If status = Pending:
   - Internal admin notes field:
     "Admin Notes (Internal)" — TextFormField multi-line
     "These notes are not visible to the shopkeeper"
   
   Two action buttons:
   [Reject Request] (SecondaryButton — red outlined)
   [Approve & Cancel AutoPay] (PrimaryButton — green)
   
   If status = Approved:
   - "Approved by {adminName} on {date}" (green chip)
   - "Razorpay AutoPay mandate cancelled" (green, 13px)
   - "Shop access ends {date}" (muted, 12px)
   
   If status = Rejected:
   - "Rejected by {adminName} on {date}" (gray chip)
   - Rejection reason shown
```

### BOTTOM STICKY BAR (Pending status only)

```
Left:  "₹{amount}/mo will be lost" (red, bold)
Right: Two buttons:
  [Reject] (SecondaryButton, red outlined, flex 1)
  [Approve] (green primary button — Color(0xFF16A34A), flex 1)
```

### Actions

```
[Approve & Cancel AutoPay] → confirmation bottom sheet:
                             "Confirm cancellation for {shopName}?
                              This will cancel their Razorpay AutoPay mandate
                              and deactivate the shop on {endDate}."
                             [Confirm] → AdminCancellationNotifier.approve()
                                         → calls Razorpay API to cancel mandate
                                         → updates shop status in Supabase
                                         → sends WhatsApp notification to shopkeeper
                                         → SuccessToast "Cancellation approved"
                                         → navigate back to /admin/cancellations

[Reject Request]          → bottom sheet:
                             "Reason for rejection" (required TextFormField)
                             [Confirm Rejection] → AdminCancellationNotifier.reject(reason)
                                                   → sends WhatsApp notification to shopkeeper
                                                   → SuccessToast "Request rejected"
[Back]                    → /admin/cancellations
```

### Shared Widgets

```
AppCard, PrimaryButton, SecondaryButton, BottomActionBar, SuccessToast
```

---

## S3-13 — REVENUE REPORT SCREEN

```
Route:       /admin/revenue
File:        lib/features/admin/presentation/revenue_screen.dart
Header:      Navy gradient (Super Admin brand)
Role:        Super Admin
Purpose:     Financial overview — MRR, plan distribution, top-up revenue, trends
Provider:    adminRevenueNotifierProvider
```

### UI Sections (top → bottom)

```
1. NAVY GRADIENT HEADER (~180px)
   - Back → /admin/dashboard
   - "Revenue Report" (white, bold)
   - Right: date range picker (shows current month by default)
     Tap → bottom sheet: [This Month] [Last Month] [Last 3 Months] [Custom Range]

2. MRR HERO CARD (white, overlapping header)
   - "MONTHLY RECURRING REVENUE" (LABEL)
   - ₹{mrr} (Playfair Display 32px bold)
   - vs last month: "+₹{diff} (+{%})" (green) / "-₹{diff} (-{%})" (red)
   
   Stats row:
   - Subscription Revenue: ₹{amount}
   - Top-Up Revenue: ₹{amount}
   - Total Revenue: ₹{total} (bold orange)

3. PLAN DISTRIBUTION CARD (AppCard)
   Section label: "PLAN BREAKDOWN"
   
   Visual bar chart (horizontal bars, 3 rows):
   Basic:    {n} shops · ₹{amount} · ▓▓▓░░░ (bar, orange)
   Pro:      {n} shops · ₹{amount} · ▓▓▓▓▓░ (bar, purple)
   Business: {n} shops · ₹{amount} · ▓░░░░░ (bar, orange)
   
   Total: {totalShops} shops · ₹{totalRevenue}/month

4. TOP-UP REVENUE CARD (AppCard)
   Section label: "CREDIT TOP-UPS"
   
   - Total top-up revenue this month: ₹{amount} (bold)
   - Number of top-up transactions: {n}
   - Most purchased pack: {packName} ({n} times)
   
   Pack breakdown table:
   Pack Name | Sold | Revenue
   (5 rows, one per pack)

5. COST ANALYSIS CARD (AppCard)
   Section label: "PLATFORM COSTS (INTERNAL)"
   Note: "Visible to Super Admin only"
   
   - AiSensy platform fee: ₹1,500/month (fixed)
   - Meta message costs this month: ₹{estimated}
     (estimated based on bills sent + bulk messages × per-message rates)
   - Razorpay fees (2% of transactions): ₹{estimated}
   - Estimated total cost: ₹{total}
   - Estimated net revenue: ₹{netRevenue} (bold green)
   - Estimated margin: {%}% (bold)
   Note: "* Message costs are estimates. Verify with AiSensy dashboard."

6. TOP SHOPS TABLE (AppCard)
   Section label: "TOP SHOPS BY VALUE"
   Table (top 10 shops):
   Rank | Shop Name | Plan | Monthly Value | Bills Sent
   (5 visible + "Show all" toggle)

7. SALESPERSON PERFORMANCE TABLE (AppCard)
   Section label: "SALESPERSON PERFORMANCE"
   Table:
   Name | Shops | Revenue Generated | New This Month
   Sorted by revenue descending

8. PAYMENT HEALTH CARD (AppCard)
   Section label: "PAYMENT HEALTH"
   - Successful AutoPay: {n} ({%}%)  (green)
   - Failed AutoPay: {n} ({%}%)      (red)
   - Retry successful: {n}            (amber)
   - Action needed: {n}               (red, bold if > 0)
```

### Actions

```
[Date range picker]   → bottom sheet → AdminRevenueNotifier.setDateRange()
[Show all (shops)]    → expand full top shops table
[Back]                → /admin/dashboard
```

### Shared Widgets

```
AppCard, FilterChipRow
```

---

## S3-14 — PLATFORM SETTINGS SCREEN

```
Route:       /admin/platform-settings
File:        lib/features/admin/presentation/platform_settings_screen.dart
Header:      Light — white
Role:        Super Admin
Purpose:     Configure platform-wide API keys, integration settings, notifications
Provider:    adminPlatformSettingsNotifierProvider
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Back → /admin/dashboard
   - "Platform Settings" (Inter 17px bold)
   - Right: "Save All" (text button, orange — saves all sections at once)

2. AISENSY SETTINGS (AppCard)
   Section label: "AISENSY — WHATSAPP API"
   
   - Connection status badge: "✓ Connected" (green) / "✗ Disconnected" (red)
   - API Key: masked field (****{last4}) with eye toggle
     "Stored securely — not visible after save"
   - Campaign Name prefix: TextFormField
     "e.g. building_project_" (prepended to all template names)
   - WhatsApp Platform Number: {number} (read-only, set by AiSensy account)
   - [Test Connection] button (SecondaryButton, small)
     → AdminPlatformSettingsNotifier.testAiSensy()
     → SuccessToast "Connection successful" / error SnackBar

3. RAZORPAY SETTINGS (AppCard)
   Section label: "RAZORPAY — PAYMENTS"
   
   - Connection status badge
   - Key ID (public): TextFormField (visible — it's public)
   - Key Secret: masked field with eye toggle
   - Webhook Secret: masked field
   - Test/Live mode toggle:
       [Test Mode] [Live Mode] — dark pill for active
       WARNING: "Switching to Test Mode will stop real payments"
   - [Test Connection] button

4. SUPABASE SETTINGS (AppCard — read-only display)
   Section label: "SUPABASE — DATABASE"
   
   - Project URL: {maskedUrl}
   - Connection: "✓ Connected" (green)
   - DB Storage used: {n} MB / {limit} MB (progress bar)
   - Auth provider: Supabase Auth (OTP)
   
   Note: "To change Supabase settings, update environment variables on Railway."
   (11px, muted — these are ENV vars, not editable in app)

5. NOTIFICATION SETTINGS (AppCard)
   Section label: "PLATFORM NOTIFICATIONS"
   
   Toggle rows (iOS-style switches):
   - Notify Super Admin on new cancellation request → toggle
   - Notify Super Admin on AutoPay failure         → toggle
   - Notify Salesperson on their shop cancellation → toggle
   - Notify Shopkeeper 3 days before AutoPay       → toggle
   - Notify Shopkeeper on credit low (< 20%)       → toggle
   
   WhatsApp notification number (Super Admin):
   - "Send critical alerts to:" TextFormField (+91 prefix)

6. APP VERSION INFO (AppCard)
   - Flutter app version: v{appVersion}
   - API server version: v{apiVersion}
   - Last template sync with AiSensy: {timestamp}
   - [Force Sync Templates] (SecondaryButton)

7. DANGER ZONE (AppCard, border: 1px #FECACA)
   Section label: "DANGER ZONE" (red label)
   - [Clear All Caches] → confirmation → clears Isar local caches
   - [Force Re-send Credentials] → for a specific shop (phone number input)
```

### Actions

```
[Save All]               → AdminPlatformSettingsNotifier.saveAll()
                           → validates all fields → saves to Supabase settings table
                           → SuccessToast "Settings saved"
[Test Connection]        → per-section test calls
[Force Sync Templates]   → AdminPlatformSettingsNotifier.syncTemplates()
                           → fetches latest template statuses from AiSensy
[Clear All Caches]       → confirmation → AdminPlatformSettingsNotifier.clearCaches()
[Live/Test mode toggle]  → shows big warning bottom sheet before switching
```

### Shared Widgets

```
AppCard, PrimaryButton, SecondaryButton, SuccessToast
```

---

## S3-15 — SUPER ADMIN SETTINGS SCREEN

```
Route:       /admin/settings
File:        lib/features/admin/presentation/admin_settings_screen.dart
Header:      Light — white
Role:        Super Admin
Purpose:     Admin personal account settings + logout
Provider:    adminSettingsNotifierProvider
             adminAuthNotifierProvider (logout)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - "Settings" (centered, Inter 17px bold)

2. PROFILE CARD (AppCard)
   - Avatar circle (initials, navy bg #1A1A2E, 56px)
   - Admin name (Inter 18px bold)
   - Email (Inter 13px, #555555)
   - Role badge: "Super Admin" (navy pill, white text)
   - "One Stop Solutions" (11px, muted)

3. SETTINGS LIST

   Section A: Platform Management
   - Platform Settings    → /admin/platform-settings
   - Subscription Plans   → /admin/plans
   - WhatsApp Templates   → /admin/templates
   - Revenue Report       → /admin/revenue

   Section B: Team
   - Salespersons         → /admin/salespersons
   - All Shops            → /admin/shops
   - Cancellations        → /admin/cancellations

   Section C: Account
   - Change Password      → bottom sheet (current + new + confirm)
   - Change Email         → bottom sheet (new email + password confirm)
   - Two-Factor Auth      → "Coming in Phase 2" (grayed out, Phase 2)

   Section D: App
   - App Version          → "billing project v1.0.0" (non-tappable)
   - Privacy Policy       → URL
   - Help / Docs          → URL (internal admin docs)

   Section E: Session
   - Log Out → confirmation dialog
     "Log out of Super Admin portal?"
     [Cancel] [Log Out] → AdminAuthNotifier.logout() → /admin/login

4. VERSION FOOTER
   "billing project v1.0.0 · Admin Portal · One Stop Solutions"
   (11px, center, #CCCCCC)
```

### Actions

```
[Platform Settings]  → /admin/platform-settings
[Plans]              → /admin/plans
[Templates]          → /admin/templates
[Revenue]            → /admin/revenue
[Salespersons]       → /admin/salespersons
[All Shops]          → /admin/shops
[Cancellations]      → /admin/cancellations
[Change Password]    → bottom sheet form
[Log Out]            → confirmation → logout → /admin/login
```

### Shared Widgets

```
AppCard, PrimaryButton
```

---

## SUPER ADMIN NAVIGATION SUMMARY

```
TAB BAR (5 tabs — unique to Super Admin role):
Tab 1: Dashboard icon    → /admin/dashboard
Tab 2: Store icon        → /admin/shops
Tab 3: Team icon         → /admin/salespersons
Tab 4: Template icon     → /admin/templates
Tab 5: Gear icon         → /admin/settings

ROLE GUARD:
All /admin/* routes require role = 'super_admin' in Supabase user metadata.
If shopkeeper or salesperson tries to access /admin/* → redirect to their home.

BACK NAVIGATION:
All screens use context.pop() or context.go() — never Navigator.push()

DEEP LINK ROUTES:
/admin/cancellations/:requestId  → from push notification
/admin/shops/:shopId             → from revenue report tap
/admin/salespersons/:id          → from shop detail salesperson link
```

---

## COMPLETE SCREEN COUNT SUMMARY

```
SCREENS-1.md   Shopkeeper Role       22 screens
SCREENS-2.md   Salesperson Role      13 screens
SCREENS-3.md   Super Admin Role      15 screens
               ─────────────────────────────────
               TOTAL                 50 screens
```

---

## RELATED FILES

```
SCREENS-1.md  → Shopkeeper role (22 screens)
SCREENS-2.md  → Salesperson role (13 screens)
DESIGN.md     → All visual specs referenced across all 3 files
CLAUDE.md     → Architecture rules, state management, naming
```

---

*SCREENS-3.md v1.0 — Billing Project — One Stop Solutions*
*Super Admin Role · 15 Screens · July 2026*
