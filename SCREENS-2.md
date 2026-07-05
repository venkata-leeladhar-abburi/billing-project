# SCREENS-2.md — Salesperson (Admin) Role
# Billing Project — Screen Specifications
# Version 1.0 | One Stop Solutions | July 2026
#
# This file covers ROLE 2: SALESPERSON / ADMIN
# Salesperson = the field sales team member who onboards shopkeepers
# Read alongside: DESIGN.md · CLAUDE.md · SCREENS-1.md
#
# FILE SERIES:
# SCREENS-1.md → Shopkeeper (primary user)
# SCREENS-2.md → Salesperson / Admin (this file)
# SCREENS-3.md → Super Admin

---

## SALESPERSON ROLE — CONTEXT

```
Who:        One Stop Solutions sales team members
What:       They visit shops, set up accounts, configure everything
            Shopkeeper never sets up their own account — salesperson does it all
Access:     Separate login from shopkeeper — same Flutter app, different role routing
Can do:     Add shops, configure shop details, set up Razorpay AutoPay,
            assign business type + template, view their assigned shops,
            review and action cancellation requests
Cannot do:  Access shopkeeper billing data, send bills on behalf of shopkeeper,
            manage other salesperson's shops, access Super Admin functions
```

---

## SCREEN INDEX — SALESPERSON ROLE

```
S2-01   Salesperson Login Screen
S2-02   Salesperson Dashboard Screen
S2-03   Shop List Screen
S2-04   Add Shop — Step 1 (Shop Details)
S2-05   Add Shop — Step 2 (Logo & Branding)
S2-06   Add Shop — Step 3 (Plan Selection)
S2-07   Add Shop — Step 4 (AutoPay Setup)
S2-08   Add Shop — Success Screen
S2-09   Shop Detail Screen
S2-10   Edit Shop Screen
S2-11   Cancellation Requests Screen
S2-12   Cancellation Request Detail Screen
S2-13   Salesperson Settings Screen
```

Total: 13 screens for Salesperson role.

---

## S2-01 — SALESPERSON LOGIN SCREEN

```
Route:       /salesperson/login
File:        lib/features/auth/presentation/salesperson_login_screen.dart
Header:      Sky blue gradient (DESIGN.md §8.4)
Role:        Salesperson (unauthenticated)
Purpose:     Entry point for salesperson — separate from shopkeeper login
Provider:    salespersonAuthNotifierProvider (SalespersonAuthNotifier)
```

### UI Sections (top → bottom)

```
1. SKY GRADIENT HEADER (~200px)
   - bg: linear-gradient(180deg, #A8D4F5 0%, #C8E8FF 50%, #F5F5F5 100%)
   - App logo centered (same as shopkeeper login)
   - Role badge below logo: "Sales Team Portal" 
     (pill, bg: rgba(255,255,255,0.25), text: white, Inter 12px bold)

2. WHITE FORM CARD (floats -20px overlap on header)
   - border-radius: 20px, bg: #FFFFFF, shadow: kShadowCard
   - padding: 20px 16px
   - Title: "Sales Team Login" (Inter 18px bold, #1A1A1A)
   - Sub: "Enter your registered mobile number" (Inter 14px, #999999)
   
   - Mobile field:
       Row: [+91 (fixed)] [10-digit number]
       Style: same as S1-01
   
   - Password field (salesperson login uses password, not OTP):
       Label: "Password"
       Type: password with show/hide toggle
       bg: #FFFFFF, border 1px #E5E5E5, radius 8, height 52px
   
   - "Forgot Password?" link (right aligned, orange, 12px)
   
   - PrimaryButton "Log In" (full width orange pill)
     Disabled: when either field empty

3. FOOTER
   - "Access restricted to authorised sales team only"
   - Inter 11px, #CCCCCC, center
   
   - "Are you a shopkeeper?" text link → /login
     (so salesperson doesn't end up on wrong screen)
```

### Actions

```
[Log In]                  → validate → SalespersonAuthNotifier.login(phone, password)
                            → on success: navigate to /salesperson/dashboard
                            → on error: show inline error "Invalid credentials"
[Forgot Password]         → show bottom sheet: "Contact your admin to reset password"
                            (no self-service reset — Super Admin handles it)
[Are you a shopkeeper?]   → /login
```

### States

```
Loading:  Button shows spinner
Error:    "Invalid mobile number or password" below password field (red, 12px)
```

### Shared Widgets

```
PrimaryButton, AppCard
```

---

## S2-02 — SALESPERSON DASHBOARD SCREEN

```
Route:       /salesperson/dashboard
File:        lib/features/salesperson/presentation/dashboard_screen.dart
Header:      Purple gradient (DESIGN.md §8.1) — same as shopkeeper home
Role:        Salesperson (authenticated)
Purpose:     Overview of all shops managed by this salesperson — stats + quick actions
Provider:    salespersonDashboardNotifierProvider (SalespersonDashboardNotifier)
```

### UI Sections (top → bottom)

```
1. PURPLE GRADIENT HEADER (~180px)
   - Left: Hamburger menu (→ side drawer — future)
   - Center: "Good morning, {salespersonName}" (white, Inter 15px)
   - Right: Avatar circle (initials, #E8680A bg)

2. STATS HERO CARD (white, overlapping header -20px)
   - border-radius: 16px, bg: #FFFFFF, shadow: kShadowCard
   - padding: 20px 16px
   
   Label: "YOUR SHOPS" (LABEL style, 11px uppercase, #999999)
   
   Stats grid (2×2):
   ┌─────────────────┬─────────────────┐
   │  {n}            │  {n}            │
   │  Total Shops    │  Active Today   │
   ├─────────────────┼─────────────────┤
   │  {n}            │  {n}            │
   │  New This Month │  Pending Setup  │
   └─────────────────┴─────────────────┘
   Each stat: number (Inter 22px bold, #1A1A1A) + label (11px, #999999)
   
   "Pending Setup" count in amber (#F59E0B) if > 0

3. QUICK ACTIONS ROW (horizontal, 2 cards side by side, margin 12px)
   Card A: ADD NEW SHOP
     bg: #E8680A (orange), radius 12
     Icon: store/shop icon (white, 20px)
     Label: "Add New Shop" (white, 13px bold)
     Sub: "Onboard a shopkeeper" (white 55%, 10px)
     Tap → /salesperson/shops/add (goes to S2-04 Step 1)

   Card B: VIEW ALL SHOPS
     bg: #242440 (navy), radius 12
     Icon: grid icon (white)
     Label: "All Shops" (white)
     Sub: "{n} shops" (white 40%, 10px)
     Tap → /salesperson/shops

4. PENDING CANCELLATIONS BANNER (conditional — show only if pending > 0)
   - bg: #FEF2F2 (red light), border: 1px #FECACA, radius 10
   - Left: warning icon (#DC2626)
   - Text: "{n} cancellation request(s) need your attention"
   - Right: "Review →" link (orange)
   - Tap → /salesperson/cancellations

5. RECENT SHOPS SECTION
   - Section header: "Recent Shops" (LABEL style) + "View All →" (orange right)
   - Last 5 shops added by this salesperson
   Each shop card (AppCard, 8px gap):
     - Left: Shop logo circle (initials fallback, 40px)
     - Center:
         Shop name (Inter 14px bold, #1A1A1A)
         Business type badge (orange pill, 10px)
         Owner phone (11px, #999999)
     - Right:
         Plan badge: "PRO" / "BASIC" / "BIZ" (small pill, purple bg)
         Status dot: green (active) / amber (pending setup) / red (suspended)
     Tap → /salesperson/shops/:id

6. BOTTOM TAB BAR
   4 tabs: Dashboard | Shops | Cancellations | Settings
   Active: orange icon + label + orange pill bg
   Inactive: grey
```

### Empty State (no shops yet)

```
Hero card: all zeros
Recent shops: EmptyState widget
  Illustration: empty store (gray flat)
  Title: "No shops yet"
  Sub: "Tap Add New Shop to onboard your first shopkeeper"
  CTA: PrimaryButton "Add New Shop" → /salesperson/shops/add
```

### Actions

```
[Add New Shop card]        → /salesperson/shops/add
[All Shops card]           → /salesperson/shops
[Cancellations banner]     → /salesperson/cancellations
[Shop row tap]             → /salesperson/shops/:id
[View All →]               → /salesperson/shops
[Tab: Shops]               → /salesperson/shops
[Tab: Cancellations]       → /salesperson/cancellations
[Tab: Settings]            → /salesperson/settings
```

### Shared Widgets

```
AppCard, IconContainer, EmptyState, PrimaryButton
```

---

## S2-03 — SHOP LIST SCREEN

```
Route:       /salesperson/shops
File:        lib/features/salesperson/presentation/shop_list_screen.dart
Header:      Light — white top bar
Role:        Salesperson
Purpose:     Full list of all shops this salesperson has added — searchable + filterable
Provider:    shopListNotifierProvider (ShopListNotifier)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Left: back → /salesperson/dashboard
   - Center: "My Shops" (Inter 17px bold)
   - Right: [search icon] [+ add icon → /salesperson/shops/add]

2. STATS STRIP (bg: #F5F5F5, padding 12px 16px)
   Inline row: "{total} shops · {active} active · {pending} pending setup"
   Inter 12px, #555555

3. SEARCH BAR (always visible)
   - "Search shop name or owner name"
   - Filters list in real time

4. FILTER CHIPS (FilterChipRow)
   [All] [Active] [Pending Setup] [Suspended] [Basic] [Pro] [Business]
   - Multi-filter: chips can combine (e.g. Active + Pro)

5. SHOP LIST (scrollable, 8px gap between cards)
   Each shop card (AppCard):
   - Left: Shop logo circle (40px, initials fallback)
   - Center:
       Shop name (Inter 14px bold, #1A1A1A)
       Owner: {ownerName} (Inter 12px, #555555)
       Added: {date} (Inter 11px, #999999)
   - Right:
       Plan pill: "BASIC" / "PRO" / "BIZ"
         Basic: bg #F5F5F5, text #555555
         Pro: bg #F5F3FF, text #7C3AED (purple)
         Business: bg #FFF3E8, text #E8680A (orange)
       Status indicator:
         ● Active (green #16A34A)
         ● Pending Setup (amber #F59E0B)
         ● Suspended (red #DC2626)
   - Full card tap → /salesperson/shops/:id

6. FLOATING ADD BUTTON
   FAB: orange circle, + icon, bottom right
   Tap → /salesperson/shops/add
```

### Empty State

```
Illustration: empty store
Title: "No shops found"
Sub (with filter): "Try a different filter"
Sub (no shops): "Add your first shop to get started"
CTA: PrimaryButton "Add New Shop"
```

### Shared Widgets

```
AppCard, FilterChipRow, EmptyState, PrimaryButton
```

---

## S2-04 — ADD SHOP — STEP 1: SHOP DETAILS

```
Route:       /salesperson/shops/add/details
File:        lib/features/salesperson/presentation/add_shop/step1_details_screen.dart
Header:      Light — white with step progress indicator
Role:        Salesperson
Purpose:     First step of shop onboarding — enter all shop + owner details
Provider:    addShopNotifierProvider (AddShopNotifier) — persists across all 4 steps
```

### STEP PROGRESS INDICATOR (below top bar)

```
4-step progress bar (horizontal):
[1 Details] ──── [2 Branding] ──── [3 Plan] ──── [4 AutoPay]
Active step: orange filled circle + label
Completed step: green filled circle + checkmark
Upcoming: gray circle + label
Line between: filled orange for completed, gray for upcoming
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Left: "Cancel" (text, #555555) → confirm discard dialog → /salesperson/dashboard
   - Center: "New Shop · Step 1 of 4"
   - Right: empty

2. STEP PROGRESS BAR (see above, below top bar)

3. FORM CARD — SHOP INFORMATION (AppCard, margin 16px)
   Section label: "SHOP INFORMATION"
   
   Fields:
   - Shop Name *            → TextFormField (text, keyboard: text)
   - Owner Full Name *      → TextFormField
   - Owner Mobile Number *  → TextFormField (prefix: +91, keyboard: phone)
     (this becomes the shopkeeper's login number)
   - WhatsApp Number *      → TextFormField (prefix: +91, keyboard: phone)
     (can be same as mobile — checkbox: "Same as mobile number")
   - Shop Address *         → multi-line TextFormField (max 3 lines)
   - City *                 → TextFormField
   - State *                → Dropdown (Indian states list)
   - PIN Code *             → TextFormField (keyboard: number, 6 digits)

4. FORM CARD — BUSINESS INFORMATION (AppCard, margin 16px)
   Section label: "BUSINESS INFORMATION"
   
   Fields:
   - GST Number (optional)  → TextFormField (uppercase auto-format)
     Validation: regex ^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$
     Note below: "Skip if GST not applicable" (11px, #999999)
   - Business Type *        → Dropdown:
       [Clothing] [Steel] [Electronics] [Grocery]
       [Pharmacy] [Jewellery] [Furniture] [Other]
   - Shop Category          → auto-filled from Business Type (can override)

5. BOTTOM SAFE AREA spacer (80px)
```

### BOTTOM STICKY BAR

```
Left: "Step 1 of 4" (Inter 12px, #999999)
Right: PrimaryButton "Next: Branding →" (orange pill)
       Disabled until all required fields valid
```

### Actions

```
[Next: Branding →]   → validate all required fields
                       → AddShopNotifier.saveStep1(details)
                       → navigate to /salesperson/shops/add/branding
[Cancel]             → show dialog: "Discard this shop?"
                       [Discard] → /salesperson/dashboard
                       [Continue] → stay
```

### Validation

```
Shop Name:     Required, min 2 chars
Owner Name:    Required, min 2 chars
Mobile:        Required, 10 digits Indian
WhatsApp:      Required, 10 digits Indian
Address:       Required, min 10 chars
City:          Required
State:         Required (select from list)
PIN Code:      Required, 6 digits
GST:           Optional, if entered must match regex
Business Type: Required
```

### Shared Widgets

```
PrimaryButton, AppCard, BottomActionBar
```

---

## S2-05 — ADD SHOP — STEP 2: LOGO & BRANDING

```
Route:       /salesperson/shops/add/branding
File:        lib/features/salesperson/presentation/add_shop/step2_branding_screen.dart
Header:      Light — white
Role:        Salesperson
Purpose:     Upload shop logo, preview how bills will look with this branding
Provider:    addShopNotifierProvider (persists step data)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Left: back arrow → /salesperson/shops/add/details
   - Center: "New Shop · Step 2 of 4"

2. STEP PROGRESS BAR (step 2 active, step 1 completed green)

3. LOGO UPLOAD SECTION (AppCard, margin 16px)
   Section label: "SHOP LOGO"
   
   Upload zone (center):
   - Dashed border circle (120px diameter), bg: #F5F5F5
   - If no logo: camera icon (#CCCCCC) + "Tap to upload logo" (12px, #999999)
   - If logo uploaded: shows logo image in circle (cropped)
   - Tap → image_picker (gallery or camera options in bottom sheet)
   
   Below upload zone:
   - "Recommended: 200×200px, PNG or JPG, max 2MB" (11px, #CCCCCC, center)
   - "Skip for now" link (orange, 12px, center)
     → uses initials avatar as fallback on bills

4. LOGO PREVIEW CARD (shows after logo uploaded or skipped)
   Section label: "BILL HEADER PREVIEW"
   Shows a mini preview of the bill header:
   ┌─────────────────────────────────────────┐
   │ [LOGO]  Shop Name                       │  ← navy bg #1A1A2E
   │         GST: {gstNumber}                │
   └─────────────────────────────────────────┘
   Note: "This is how your shop will appear on every PDF bill" (11px, #999999)

5. BILL COLOR THEME (optional — Phase 2, skip for now)
   Placeholder card: "Custom bill colors coming soon" (gray, muted)

6. BOTTOM SAFE AREA spacer
```

### BOTTOM STICKY BAR

```
Left: "Step 2 of 4"
Right: PrimaryButton "Next: Select Plan →"
       Always enabled (logo is optional)
```

### Actions

```
[Logo tap]           → show bottom sheet: [Take Photo] [Choose from Gallery] [Cancel]
                       → image_picker → crop to square
                       → AddShopNotifier.setLogo(imageFile)
[Skip for now]       → AddShopNotifier.skipLogo()
[Next: Select Plan]  → /salesperson/shops/add/plan
[Back]               → /salesperson/shops/add/details
```

### Shared Widgets

```
PrimaryButton, AppCard, BottomActionBar
```

---

## S2-06 — ADD SHOP — STEP 3: PLAN SELECTION

```
Route:       /salesperson/shops/add/plan
File:        lib/features/salesperson/presentation/add_shop/step3_plan_screen.dart
Header:      Light — white
Role:        Salesperson
Purpose:     Choose the subscription plan for this shopkeeper
Provider:    addShopNotifierProvider
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Back → Step 2 + "New Shop · Step 3 of 4"

2. STEP PROGRESS BAR (step 3 active)

3. INTRO TEXT (padding 16px)
   "Choose the right plan for this shop."
   Inter 14px, #555555

4. PLAN CARDS (stacked, 12px gap, margin 16px)
   3 plan cards — only one selectable at a time

   BASIC PLAN CARD (AppCard):
   - Plan name: "BASIC" (Inter 14px bold, #1A1A1A)
   - Price: "₹299/month" (Inter 22px bold, #1A1A1A)
   - Feature list:
       ✓ 100 bill credits/month (green checkmark)
       ✓ 300 bulk msg credits/month
       ✓ Up to 500 customers
       ✓ 3 months bill history
       ✓ In-app chat support
   - Best for: "Small kirana, grocery shops" (11px, #999999 italic)
   - Selected state: border 2px #E8680A + orange radio filled top-right

   PRO PLAN CARD (AppCard):
   - "MOST POPULAR" badge (top center, purple pill #7C3AED)
   - Plan name: "PRO" (purple text #7C3AED)
   - Price: "₹599/month"
   - Feature list:
       ✓ 300 bill credits/month
       ✓ 800 bulk msg credits/month
       ✓ Up to 2,000 customers
       ✓ 12 months bill history
       ✓ Priority support
       ✓ All business templates
   - Best for: "Clothing, electronics shops"
   - Selected state: border 2px #7C3AED

   BUSINESS PLAN CARD (AppCard):
   - Plan name: "BUSINESS" (orange text #E8680A)
   - Price: "₹999/month"
   - Feature list:
       ✓ Unlimited bill credits
       ✓ 2,000 bulk msg credits/month
       ✓ Unlimited customers
       ✓ Unlimited bill history
       ✓ Dedicated support
       ✓ All templates + custom
   - Best for: "Steel, jewellery, large shops"
   - Selected state: border 2px #E8680A

5. TEMPLATE AUTO-ASSIGN INFO (AppCard, margin 16px, bg: #EFF6FF)
   Left: info icon (#2563EB)
   Text: "Based on this shop's business type ({businessType}), the
          '{templateName}' WhatsApp template will be auto-assigned."
   (Inter 13px, #2563EB)

6. BOTTOM SAFE AREA spacer
```

### BOTTOM STICKY BAR

```
Left: Plan selected indicator: "PRO · ₹599/mo" OR "Select a plan"
Right: PrimaryButton "Next: AutoPay →"
       Disabled until a plan is selected
```

### Actions

```
[Plan card tap]     → AddShopNotifier.selectPlan(plan)
                      → visual selection state updates
[Next: AutoPay →]   → AddShopNotifier.saveStep3(plan)
                      → /salesperson/shops/add/autopay
[Back]              → /salesperson/shops/add/branding
```

### Shared Widgets

```
PrimaryButton, AppCard, BottomActionBar
```

---

## S2-07 — ADD SHOP — STEP 4: AUTOPAY SETUP

```
Route:       /salesperson/shops/add/autopay
File:        lib/features/salesperson/presentation/add_shop/step4_autopay_screen.dart
Header:      Light — white
Role:        Salesperson
Purpose:     Set up Razorpay UPI AutoPay mandate for shopkeeper subscription
Provider:    addShopNotifierProvider
             razorpayNotifierProvider (for payment flow)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Back → Step 3 + "New Shop · Step 4 of 4"

2. STEP PROGRESS BAR (step 4 active)

3. EXPLANATION CARD (AppCard, bg: #F0FDF4 green tint)
   Left: info icon (green #16A34A)
   Title: "AutoPay Setup" (Inter 14px bold, #1A1A1A)
   Body: "The shopkeeper's subscription fee (₹{planAmount}/month) will be 
          automatically deducted on the {billingDay} of every month via UPI.
          The shopkeeper must approve this mandate on their phone."
   (Inter 13px, #555555, line-height 1.6)

4. PLAN SUMMARY CARD (AppCard, margin 16px)
   - Plan: {planName} (bold)
   - Monthly amount: ₹{amount} (Inter 20px bold, #1A1A1A)
   - First billing: {firstBillingDate} (13px, #555555)
   - "AutoPay will continue until cancelled" (11px, #999999)

5. UPI SETUP SECTION (AppCard, margin 16px)
   Section label: "SHOPKEEPER'S UPI DETAILS"
   
   Option A — UPI ID entry:
   - Label: "UPI ID" (floating label)
   - Field: e.g. shopkeeper@upi
   - Validate UPI format: xxxxxx@bankname
   
   OR divider: "OR"
   
   Option B — QR code scan:
   - "Scan shopkeeper's UPI QR code" button (SecondaryButton)
   - Opens camera for QR scan → auto-fills UPI ID field
   
   Note: "Hand the phone to the shopkeeper to approve the mandate"
   (11px, #999999, italic)

6. MANDATE APPROVAL FLOW (shows after UPI entry)
   Step display (3 mini steps inline):
   1. Enter UPI → 2. Send to Razorpay → 3. Shopkeeper approves on their UPI app
   
   Info banner: "After tapping Create AutoPay, Razorpay will send a
                 mandate approval request to the shopkeeper's UPI app.
                 The shopkeeper must approve it within 10 minutes."
   bg: #FFFBEB (amber light), border amber

7. BOTTOM SAFE AREA spacer
```

### BOTTOM STICKY BAR

```
Left: "₹{amount}/month" (bold) + "via UPI AutoPay" (muted)
Right: PrimaryButton "Create AutoPay Mandate" (orange pill)
       Disabled until UPI ID entered and valid
```

### Actions

```
[Scan QR]                → open camera → parse UPI QR → fill UPI field
[Create AutoPay Mandate] → AddShopNotifier.createAutoPayMandate(upiId)
                           → Razorpay mandate creation API
                           → on success: show "Mandate sent" confirmation
                           → shopkeeper sees approval in their UPI app
                           → poll for mandate status (approved/pending/failed)
                           → on approved: navigate to /salesperson/shops/add/success
                           → on failed/timeout: show error + retry option
[Back]                   → /salesperson/shops/add/plan
```

### States

```
Sending mandate:  Button spinner + "Sending mandate request..."
Waiting approval: Full-screen waiting state:
                  - Animated pulse circle (orange)
                  - "Waiting for shopkeeper to approve..."
                  - "This can take up to 10 minutes"
                  - Countdown timer (optional)
                  - "Resend Request" link (after 2 min)
Approved:         Green success animation → navigate to success screen
Failed:           Error card + "Retry" button + "Set up later" option
```

### Shared Widgets

```
PrimaryButton, SecondaryButton, AppCard, BottomActionBar
```

---

## S2-08 — ADD SHOP — SUCCESS SCREEN

```
Route:       /salesperson/shops/add/success
File:        lib/features/salesperson/presentation/add_shop/success_screen.dart
Header:      White — full white
Role:        Salesperson
Purpose:     Shop successfully onboarded — celebrate + next steps
Provider:    addShopNotifierProvider (read final shop data)
```

### UI Sections (top → bottom)

```
1. FULL WHITE SCREEN, center aligned

2. SUCCESS ANIMATION
   - Large green checkmark circle (animated scale-in)
   - Circle: bg #F0FDF4, icon #16A34A, 100px
   - "Shop Added!" (Playfair Display 28px bold, #1A1A1A)
   - Sub: "{shopName} is now live on billing project."
     (Inter 14px, #555555, center)

3. SHOP SUMMARY CARD (AppCard, margin 32px horizontal)
   - Shop name + logo (or initials)
   - Owner: {ownerName}
   - Plan: {planName} · ₹{amount}/month
   - Business type: {type}
   - AutoPay: "Active ✓" (green)

4. CREDENTIALS INFO CARD (AppCard, bg: #EFF6FF blue tint)
   Left: info icon (blue)
   Title: "Login credentials sent"
   Body: "The shopkeeper will receive their login details via WhatsApp on
          {ownerWhatsApp}. They can log in immediately."
   (Inter 13px, #2563EB)

5. NEXT STEPS (stacked chips, left-aligned)
   ✓ Shop created
   ✓ AutoPay set up
   ✓ Template assigned
   ✓ Credentials sent
   All in green (#16A34A) with checkmark

6. ACTION BUTTONS
   - PrimaryButton "Add Another Shop" → clears state → /salesperson/shops/add/details
   - SecondaryButton "View This Shop" → /salesperson/shops/:newShopId
   - Text link "Back to Dashboard" (orange, center) → /salesperson/dashboard
```

### Actions

```
[Add Another Shop]  → AddShopNotifier.reset() → /salesperson/shops/add/details
[View This Shop]    → /salesperson/shops/{newShopId}
[Back to Dashboard] → /salesperson/dashboard
[Hardware back]     → /salesperson/dashboard (not back to autopay — shop already created)
```

### Shared Widgets

```
PrimaryButton, SecondaryButton, AppCard
```

---

## S2-09 — SHOP DETAIL SCREEN

```
Route:       /salesperson/shops/:shopId
File:        lib/features/salesperson/presentation/shop_detail_screen.dart
Header:      Orange gradient (DESIGN.md §8.2)
Role:        Salesperson
Purpose:     Full details of one shop — usage stats, plan, status, actions
Provider:    shopDetailNotifierProvider — takes shopId param
```

### UI Sections (top → bottom)

```
1. ORANGE GRADIENT HEADER (~200px)
   - Back arrow (white) → /salesperson/shops
   - Shop name as title (white, Inter 17px bold)
   - Edit icon (white, pencil) → /salesperson/shops/:id/edit

2. SHOP PROFILE CARD (white, overlapping header -20px)
   - Logo circle (56px) + shop name (18px bold) + business type badge
   - Owner name + phone (13px, #555555)
   - Status badge:
       Active: green pill "● Active"
       Pending: amber pill "⏳ Pending Setup"
       Suspended: red pill "● Suspended"

3. PLAN & BILLING CARD (AppCard, margin 16px)
   Section label: "SUBSCRIPTION"
   - Plan name (bold) + price (bold, orange)
   - AutoPay status: "Active via UPI" (green) / "Pending" (amber) / "Failed" (red)
   - Next billing date: {date}
   - Billing history (last 3 payments):
       Each row: {date} · ₹{amount} · Paid ✓ (or Failed ✗)

4. USAGE STATS CARD (AppCard, margin 16px)
   Section label: "THIS MONTH'S USAGE"
   - Bill Credits: progress bar + "{used}/{total} used"
   - Msg Credits: progress bar + "{used}/{total} used"
   - Customers: "{count}/{limit}" (or "Unlimited")
   - Bills sent this month: {n}
   - Last active: {timestamp} (when shopkeeper last opened app)

5. SHOP DETAILS CARD (AppCard, margin 16px)
   Section label: "SHOP DETAILS"
   - Address, City, State, PIN
   - GST Number (or "Not provided")
   - WhatsApp number
   - Business type
   - Template assigned: {templateName}
   - Added by: {salespersonName} on {date}

6. DANGER ZONE (AppCard, margin 16px, border: 1px #FECACA)
   Section label: "ACCOUNT" (red label)
   - "Suspend Shop" (text button, red #DC2626)
     → shows confirmation bottom sheet → SuperAdmin approval required note
   - "View Cancellation Requests" (text link, orange)
     → /salesperson/cancellations?shopId={id}

7. BOTTOM SAFE AREA spacer
```

### Actions

```
[Edit (top bar)]             → /salesperson/shops/:id/edit
[Back]                       → /salesperson/shops
[Suspend Shop]               → bottom sheet confirmation → salespersonNotifier.requestSuspend()
[View Cancellation Requests] → /salesperson/cancellations filtered by shopId
```

### Shared Widgets

```
AppCard, PrimaryButton
```

---

## S2-10 — EDIT SHOP SCREEN

```
Route:       /salesperson/shops/:shopId/edit
File:        lib/features/salesperson/presentation/edit_shop_screen.dart
Header:      Light — white
Role:        Salesperson
Purpose:     Edit any shop details — name, address, GST, plan upgrade
Provider:    editShopNotifierProvider — takes shopId param
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Left: "Cancel" (text) → confirm discard → /salesperson/shops/:id
   - Center: "Edit Shop" (Inter 17px bold)
   - Right: "Save" (text button, orange) → same as Save button

2. FORM — same fields as Step 1 (S2-04) but pre-filled with existing data
   All fields editable:
   - Shop Name, Owner Name, WhatsApp, Address, City, State, PIN
   - GST Number
   - Business Type (changing this offers to re-assign template)

3. PLAN SECTION (AppCard)
   Current plan shown with "Upgrade Plan" link (orange)
   Tap → shows plan selection inline (same cards as Step 3)
   Note: "Plan downgrades contact Super Admin" (11px, muted)

4. TEMPLATE SECTION (AppCard)
   Currently assigned template shown
   "Change Template" link → same template select flow

5. LOGO SECTION
   Current logo shown + "Change Logo" link

6. SAVE BUTTON (bottom, padding 16px)
   PrimaryButton "Save Changes" (orange pill, full width)
```

### Actions

```
[Cancel]            → confirm discard if dirty → /salesperson/shops/:id
[Save / Save Changes] → EditShopNotifier.save()
                       → on success: SuccessToast "Shop updated" → /salesperson/shops/:id
                       → on error: SnackBar error
[Upgrade Plan]      → inline plan cards appear below
[Change Template]   → /template-select (push, returns selection)
[Change Logo]       → image_picker bottom sheet
```

### Shared Widgets

```
PrimaryButton, AppCard, SuccessToast
```

---

## S2-11 — CANCELLATION REQUESTS SCREEN

```
Route:       /salesperson/cancellations
File:        lib/features/salesperson/presentation/cancellation_list_screen.dart
Header:      Light — white top bar
Role:        Salesperson
Purpose:     View all AutoPay cancellation requests from shops this salesperson manages
Provider:    cancellationListNotifierProvider
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Back → /salesperson/dashboard
   - "Cancellation Requests" (Inter 17px bold)
   - Right: filter icon

2. STATS STRIP
   "{pending} pending · {resolved} resolved"
   Pending count in red (#DC2626) if > 0

3. FILTER CHIPS
   [All] [Pending] [Approved] [Rejected]
   (same chip style as DESIGN.md)

4. REQUEST LIST (scrollable, 8px gap)
   Each request card (AppCard):
   - Left: shop logo circle (36px)
   - Center:
       Shop name (Inter 14px bold)
       Reason: {reason} (Inter 12px, #555555, 1 line truncated)
       Submitted: {relativeTime} e.g. "2 hours ago" (11px, muted)
   - Right:
       Status badge:
         Pending:  amber pill "⏳ Pending"
         Approved: green pill "✓ Approved"
         Rejected: gray pill "✗ Rejected"
   - Full card tap → /salesperson/cancellations/:requestId

5. EMPTY STATE
   Illustration: checkmark (green, all good)
   Title: "No cancellation requests"
   Sub: "All your shops are active"
```

### Shared Widgets

```
AppCard, FilterChipRow, EmptyState
```

---

## S2-12 — CANCELLATION REQUEST DETAIL SCREEN

```
Route:       /salesperson/cancellations/:requestId
File:        lib/features/salesperson/presentation/cancellation_detail_screen.dart
Header:      Orange gradient
Role:        Salesperson
Purpose:     View a single cancellation request — review details + take action
Provider:    cancellationDetailNotifierProvider — takes requestId param
```

### UI Sections (top → bottom)

```
1. ORANGE GRADIENT HEADER
   - Back → /salesperson/cancellations
   - "Cancellation Request" (white, bold)

2. SHOP INFO CARD (white, overlapping header)
   - Shop logo + name + owner
   - Plan: {planName} · ₹{amount}/month
   - AutoPay started: {date}
   - Current billing period ends: {date}

3. REQUEST DETAILS CARD (AppCard)
   Section label: "REQUEST DETAILS"
   - Submitted by: Shopkeeper (always)
   - Submitted at: {datetime}
   - Request ID: #REQ-{id}
   - Reason: {fullReasonText}
   - Shopkeeper note (if any): "{customNote}"

4. IMPACT SUMMARY (AppCard, bg: #FEF2F2 red tint)
   Left: warning icon (red)
   - "If approved, shop access ends on {billingEndDate}"
   - "AutoPay mandate will be cancelled via Razorpay"
   - "Shopkeeper data retained for 90 days post-cancellation"

5. ACTION SECTION (AppCard, margin 16px)
   Section label: "YOUR ACTION"
   
   If status = Pending:
   - "Contact Shopkeeper First" suggestion (Inter 13px, muted italic)
   - "Call {ownerPhone}" link → tel:
   - "WhatsApp {ownerWhatsApp}" link → wa.me/
   - Divider
   - Two buttons:
       [Approve Request] (green outlined pill, full width)
       [Reject Request]  (red outlined pill, full width)
   
   If status = Approved:
   - "You approved this request on {date}" (green, checkmark icon)
   - "AutoPay cancellation processed by Super Admin" (muted)
   
   If status = Rejected:
   - "You rejected this request on {date}" (muted, ✗ icon)

6. NOTES TO SUPER ADMIN (AppCard — only for Pending status)
   Section label: "NOTES FOR SUPER ADMIN (Optional)"
   - Multi-line TextFormField
   - Placeholder: "Add any notes about this shop before escalating..."
```

### BOTTOM STICKY BAR (only when status = Pending)

```
Left: empty
Right: Two buttons inline (side by side):
  [Reject] SecondaryButton (outlined red pill, flex 1)
  [Approve] PrimaryButton (green pill, flex 1)
  Note: green CTA replaces standard orange — exception for approve action
        Use Color(0xFF16A34A) for approve button background
```

### Actions

```
[Call link]       → tel:{ownerPhone}
[WhatsApp link]   → wa.me/{ownerWhatsApp}
[Approve]         → show confirmation bottom sheet:
                    "Approve this cancellation request?"
                    "The shopkeeper's account will be deactivated on {endDate}"
                    [Confirm Approve] → CancellationDetailNotifier.approve()
                                       → SuccessToast "Request approved"
                                       → back to /salesperson/cancellations
[Reject]          → show bottom sheet with reason input:
                    "Reason for rejection" (text field)
                    [Confirm Reject] → CancellationDetailNotifier.reject(reason)
                                      → SuccessToast "Request rejected"
[Back]            → /salesperson/cancellations
```

### Shared Widgets

```
AppCard, PrimaryButton, SecondaryButton, BottomActionBar, SuccessToast
```

---

## S2-13 — SALESPERSON SETTINGS SCREEN

```
Route:       /salesperson/settings
File:        lib/features/salesperson/presentation/settings_screen.dart
Header:      Light — white
Role:        Salesperson
Purpose:     Salesperson profile, account info, logout
Provider:    salespersonSettingsNotifierProvider
             salespersonAuthNotifierProvider (for logout)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - "Settings" (centered, Inter 17px bold)

2. PROFILE CARD (AppCard)
   - Avatar circle (initials, orange bg, 56px)
   - Salesperson name (Inter 18px bold)
   - Mobile number (13px, #555555)
   - Role badge: "Sales Team" (orange pill)
   - Managed shops: "{n} active shops" (11px, muted)

3. SETTINGS LIST

   Section A: My Work
   - My Shops        → /salesperson/shops
   - Cancellations   → /salesperson/cancellations
   - My Performance  → placeholder (Phase 2 — show shops added, revenue generated)

   Section B: Account
   - Change Password → bottom sheet: current + new + confirm password
   - Contact Super Admin → wa.me/{adminNumber}

   Section C: App Info
   - Help & FAQ      → URL
   - Privacy Policy  → URL
   - App Version: "billing project v1.0.0" (center, 11px, muted)

   Section D: Session
   - Log Out → confirmation dialog → SalespersonAuthNotifier.logout() → /salesperson/login

4. VERSION FOOTER
   "billing project v1.0.0 · Sales Portal" (11px, center, #CCCCCC)
```

### Actions

```
[My Shops]          → /salesperson/shops
[Cancellations]     → /salesperson/cancellations
[Change Password]   → bottom sheet form
[Log Out]           → confirmation → logout → /salesperson/login
```

### Shared Widgets

```
AppCard, PrimaryButton
```

---

## SALESPERSON NAVIGATION SUMMARY

```
TAB BAR (4 tabs, always visible when authenticated as Salesperson):
Tab 1: Dashboard icon  → /salesperson/dashboard
Tab 2: Shops icon      → /salesperson/shops
Tab 3: Alert icon      → /salesperson/cancellations
Tab 4: Gear icon       → /salesperson/settings

ADD SHOP FLOW (multi-step, linear):
/salesperson/shops/add/details
  → /salesperson/shops/add/branding
  → /salesperson/shops/add/plan
  → /salesperson/shops/add/autopay
  → /salesperson/shops/add/success

BACK NAVIGATION:
All screens use context.pop() or context.go() via go_router.
Multi-step add flow: back arrow goes to previous step (not dashboard).
Success screen: back hardware button goes to dashboard.

ROLE GUARD:
All /salesperson/* routes require role = 'salesperson' in Supabase user metadata.
If shopkeeper tries to access /salesperson/* → redirect to /dashboard.
```

---

## RELATED FILES

```
SCREENS-1.md  → Shopkeeper role (22 screens)
SCREENS-3.md  → Super Admin role (next)
DESIGN.md     → All visual specs referenced in this file
CLAUDE.md     → Architecture rules, state management, naming
```

---

*SCREENS-2.md v1.0 — Billing Project — One Stop Solutions*
*Salesperson Role · 13 Screens · July 2026*
