# SCREENS-1.md — Shopkeeper Role
# Billing Project — Screen Specifications
# Version 1.0 | One Stop Solutions | July 2026
#
# This file covers ROLE 1: SHOPKEEPER (primary end user)
# Read alongside: DESIGN.md (visual specs) · CLAUDE.md (architecture rules)
#
# FILE SERIES:
# SCREENS-1.md → Shopkeeper (this file)
# SCREENS-2.md → Salesperson / Admin
# SCREENS-3.md → Super Admin

---

## HOW TO READ THIS FILE

Each screen entry contains:
- **Route** → go_router path
- **File** → exact Flutter file location
- **Header type** → which gradient from DESIGN.md §8
- **Role** → who can access this screen
- **Purpose** → what the screen does in one sentence
- **Data / Provider** → which Riverpod notifier drives this screen
- **UI Sections** → every visible section top to bottom
- **Actions** → what the user can tap/submit
- **Navigation** → where each action goes
- **Empty state** → what shows when there is no data
- **Error state** → what shows on API failure
- **Bottom bar** → sticky bottom bar content (if any)
- **Shared widgets** → which widgets from lib/shared/widgets/ to use

---

## SCREEN INDEX — SHOPKEEPER ROLE

```
S1-01   Login Screen
S1-02   OTP Verification Screen
S1-03   Dashboard (Home) Screen
S1-04   New Bill Screen
S1-05   Bill Preview Screen
S1-06   Bill Sent Success Screen
S1-07   Bill History Screen
S1-08   Bill Detail Screen
S1-09   Customer List Screen
S1-10   Add Customer Screen
S1-11   Customer Detail Screen
S1-12   Bulk Message Screen
S1-13   Template Select Screen
S1-14   Bulk Message Preview Screen
S1-15   Delivery Report Screen
S1-16   Credits Screen
S1-17   Credit Top-Up Screen
S1-18   Top-Up Success Screen
S1-19   Notifications Screen
S1-20   Settings Screen
S1-21   Cancel Request Screen
S1-22   Cancel Request Confirmation Screen
```

Total: 22 screens for Shopkeeper role.

---

## S1-01 — LOGIN SCREEN

```
Route:       /login
File:        lib/features/auth/presentation/login_screen.dart
Header:      Sky blue gradient (DESIGN.md §8.4)
             linear-gradient(180deg, #A8D4F5 0%, #C8E8FF 50%, #F5F5F5 100%)
Role:        Shopkeeper (unauthenticated)
Purpose:     Entry point — shopkeeper enters mobile number to receive OTP
Provider:    authNotifierProvider (AuthNotifier)
```

### UI Sections (top → bottom)

```
1. SKY HEADER AREA (~200px)
   - Sky blue gradient background
   - App logo centered (shop illustration + "billing project" wordmark)
   - Tagline below logo: "Send bills. Grow your business." (Inter 14px, #FFFFFF 70%)

2. WHITE FORM CARD (floats below header, margin-top: -20px overlap)
   - border-radius: 20px, bg: #FFFFFF, shadow: kShadowCard
   - padding: 20px 16px
   - Title: "Log in to your shop" (Inter 18px bold, #1A1A1A)
   - Subtitle: "Enter your WhatsApp number" (Inter 14px, #999999)
   - Country code + phone field:
       Row: [+91 dropdown (non-editable)] [10-digit number field]
       Field: bg #FFFFFF, border 1px #E5E5E5, radius 8, height 52px
       Keyboard: number pad
   - Continue button (PrimaryButton widget)
       Full-width orange pill, label: "Continue"
       Disabled state: when phone field is empty or < 10 digits

3. DIVIDER AREA
   - "Other login options" centered text (Inter 12px, #999999)

4. SOCIAL LOGIN ROW (Google only for now)
   - Google button: white card, Google logo + "Continue with Google"
   - border: 1px #E5E5E5, radius 100px, height 48px

5. FOOTER
   - "By proceeding, you agree to our Terms & Privacy Policy"
   - Inter 11px, #CCCCCC, center aligned
   - "Terms" and "Privacy Policy" in #E8680A (orange underline)
```

### Actions

```
[Continue button tap]     → validate 10-digit number → call AuthNotifier.requestOtp()
                           → on success: navigate to /otp
                           → on error: show inline error below field (red #DC2626)
[Google login tap]        → trigger Google OAuth via Supabase → navigate to /dashboard
[Terms tap]               → open URL: terms page (WebView or browser)
[Privacy Policy tap]      → open URL: privacy page
```

### States

```
Loading:  Continue button shows CircularProgressIndicator (white, inside button)
Error:    Inline text below phone field: "Invalid number" or server error message
          Text: Inter 12px, #DC2626
```

### Shared Widgets

```
PrimaryButton, AppCard (form card)
```

---

## S1-02 — OTP VERIFICATION SCREEN

```
Route:       /otp
File:        lib/features/auth/presentation/otp_screen.dart
Header:      Light — plain white, no gradient
Role:        Shopkeeper (unauthenticated, post phone entry)
Purpose:     Shopkeeper enters 6-digit OTP received on WhatsApp/SMS
Provider:    authNotifierProvider (AuthNotifier)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Back arrow (left) → goes back to /login
   - No title (clean top bar)

2. CONTENT (padding 16px horizontal)
   - Top spacing: 48px
   - Heading: "Enter OTP" (Inter 24px bold, #1A1A1A)
   - Subtext: "Sent to +91 XXXXX XXXXX" (Inter 14px, #555555)
     (show masked number — last 5 digits visible)

3. OTP INPUT ROW
   - 6 individual digit boxes in a row
   - Each box: 48px × 56px, bg #FFFFFF, border 1px #E5E5E5, radius 10
   - Active box: border 2px #E8680A (orange)
   - Filled box: bg #FFF3E8 (orange light), border #E8680A
   - Auto-focus first box on screen load
   - Auto-advance to next box on digit entry
   - Number keyboard

4. RESEND ROW
   - "Didn't receive it?" (Inter 13px, #999999)
   - "Resend OTP" link (Inter 13px, #E8680A, orange)
   - Countdown timer: "Resend in 0:45" — counts down 45 seconds
   - Resend link disabled (grey) during countdown, enabled after

5. VERIFY BUTTON
   - PrimaryButton: "Verify & Login"
   - Disabled until all 6 digits entered
   - Auto-submits when 6th digit is entered (no need to tap button)
```

### Actions

```
[Auto-submit / Verify tap]  → AuthNotifier.verifyOtp() 
                             → on success: navigate to /dashboard
                             → on error: clear boxes + show error message
[Resend OTP tap]            → AuthNotifier.requestOtp() again
                             → reset countdown to 45s
[Back tap]                  → go back to /login, clear state
```

### States

```
Loading:   Verify button shows spinner
Error:     "Incorrect OTP. Please try again." below OTP boxes (red #DC2626)
           Boxes shake animation (brief)
Success:   Brief green flash on boxes → navigate to /dashboard
```

### Shared Widgets

```
PrimaryButton
```

---

## S1-03 — DASHBOARD (HOME) SCREEN

```
Route:       /dashboard
File:        lib/features/dashboard/presentation/dashboard_screen.dart
Header:      Purple gradient (DESIGN.md §8.1)
             linear-gradient(180deg, #6B4EFF 0%, #8B6FFF 60%, transparent 100%)
Role:        Shopkeeper (authenticated)
Purpose:     Home screen — today's summary, quick actions, recent bills
Provider:    dashboardNotifierProvider (DashboardNotifier)
             creditsNotifierProvider (CreditsNotifier)
```

### UI Sections (top → bottom)

```
1. PURPLE GRADIENT HEADER
   - Left: Hamburger menu icon (→ opens side drawer — future feature)
   - Center: Promo pill (optional — "Get 3 months free →" if new user)
   - Right: Credit badge (golden coin icon + shop avatar)
     - Credit badge shows total credits remaining (bill + msg combined)
     - Tap → navigate to /credits

2. HERO CARD (white card, overlaps header by -20px, margin 12px horizontal)
   - bg: #FFFFFF, border-radius: 16px, shadow: kShadowCard
   - Label: "Today's Revenue" (LABEL style — 11px uppercase, #999999)
   - Amount: "₹12,400" (Playfair Display 32px bold, #1A1A1A)
     (sum of all bills sent today — fetched from Supabase)
   - Divider: 1px #F0F0F0
   - Stats row (2 columns):
       Left:  Bills Today → count of bills sent today
       Right: Bill Credits → remaining billCredits count
     - Each stat: number (Inter 18px bold, #1A1A1A) + label (11px, #999999)
   - Credit status color on billCredits number:
       > 50%: #16A34A (green)
       20-50%: #F59E0B (amber)
       < 20%: #DC2626 (red)

3. QUICK ACTIONS GRID (2×2 grid, padding 12px horizontal)
   - 4 action cards in 2 columns, 8px gap
   - Card 1: NEW BILL (PRIMARY)
       bg: #E8680A (orange), radius 12
       Icon: receipt/invoice icon (white, 20px)
       Label: "New Bill" (Inter 13px bold, white)
       Sub: "Send PDF via WhatsApp" (10px, rgba(255,255,255,0.55))
       Tap → /new-bill
   - Card 2: BULK MESSAGE
       bg: #242440 (navy card), radius 12
       Icon: speakerphone icon (white)
       Label: "Bulk Message" (white)
       Sub: "{msgCredits} credits" (10px, rgba(255,255,255,0.4))
       Tap → /bulk-message
   - Card 3: CUSTOMERS
       bg: #242440 (navy card), radius 12
       Icon: users icon (white)
       Label: "Customers" (white)
       Sub: "{count} contacts" (10px, rgba(255,255,255,0.4))
       Tap → /customers
   - Card 4: BILL HISTORY
       bg: #242440 (navy card), radius 12
       Icon: receipt list icon (white)
       Label: "Bill History" (white)
       Sub: "View all bills" (10px, rgba(255,255,255,0.4))
       Tap → /bill-history

4. CREDIT LOW BANNER (conditional — show only when < 20% credits)
   - bg: #FFFBEB (amber light), border: 1px #FDE68A, radius 10
   - Left: warning icon (#F59E0B)
   - Text: "Only {n} bill credits left. Top up to keep sending."
   - Right: "Buy Credits" link in orange
   - Tap → /credits/topup

5. RECENT BILLS SECTION
   - Section header: "Recent Bills" (Inter 13px, #999999, LABEL style)
   - List of last 5 bills — each bill row:
       Left side:
         - Customer name (Inter 14px, #1A1A1A)
         - Timestamp (Inter 11px, #999999) e.g. "2 min ago"
         - Green dot + "Sent ✓" if delivered
       Right side:
         - Bill amount (Inter 14px bold, #1A1A1A)
       Separator: 0.5px #F0F0F0 between rows
   - "View All →" link in orange below list → /bill-history

6. BOTTOM TAB BAR
   - 4 tabs: Home | New Bill | Customers | Settings
   - Active: orange icon + label + soft orange pill bg (#FFF3E8)
   - Inactive: grey icon + grey label
```

### Empty State (no bills today)

```
- Hero card: "₹0" amount, "0 bills" stat
- Recent bills section: Empty state widget
  Illustration: receipt with question mark (light gray, Ixigo style)
  Text: "No bills sent today" (14px, #CCCCCC)
  Sub: "Tap New Bill to get started" (12px, #CCCCCC)
```

### Actions

```
[New Bill card]         → /new-bill
[Bulk Message card]     → /bulk-message
[Customers card]        → /customers
[Bill History card]     → /bill-history
[Buy Credits (banner)]  → /credits/topup
[Bill row tap]          → /bill/:id (BillDetail)
[View All]              → /bill-history
[Credits badge (top)]   → /credits
[Tab: New Bill]         → /new-bill
[Tab: Customers]        → /customers
[Tab: Settings]         → /settings
```

### Shared Widgets

```
AppCard, IconContainer, FilterChipRow, BottomActionBar (tab bar), CreditBadge
```

---

## S1-04 — NEW BILL SCREEN

```
Route:       /new-bill
File:        lib/features/billing/presentation/new_bill_screen.dart
Header:      Light — plain white top bar (no gradient)
Role:        Shopkeeper
Purpose:     Shopkeeper creates a bill — select customer, add items, review total
Provider:    newBillNotifierProvider (NewBillNotifier)
             customerNotifierProvider (read for customer search)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Left: Back arrow (→ /dashboard)
   - Center: "New Bill" (Inter 17px bold, #1A1A1A)
   - Right: empty

2. PAGE BG: #F5F5F5

3. CUSTOMER SECTION (AppCard, margin 16px)
   - Section label: "CUSTOMER" (LABEL style — 11px uppercase, #999999)
   - Search field:
       Placeholder: "Search by name or number"
       Left icon: search icon (#999999)
       On tap: expands dropdown showing customer list filtered by input
   - Customer dropdown results (when typing):
       Each row: name (bold) + phone number (muted)
       "Add new customer" row at bottom with + icon in orange
   - Selected customer chip (after selection):
       Shows: customer name + phone
       Orange outlined pill with × to deselect
   - "Add New Customer" shortcut (if no results found):
       Orange text link: "Add {typed name} as new customer →"
       Tap → opens AddCustomer bottom sheet (inline, not a new screen)

4. BILL ITEMS SECTION (AppCard, margin 16px)
   - Section label: "BILL ITEMS" (LABEL style)
   - Column headers row:
       "Item" | "Qty" | "Rate" | "Amount"
       (Inter 10px, #CCCCCC, proportional widths: 2:1:1:1.2)
   - Item rows (dynamic, starts with 1 empty row):
       TextFormField for each cell
       Item name: flex 2 (text input)
       Qty: flex 1 (number, min 1)
       Rate: flex 1 (number with ₹)
       Amount: flex 1.2 (auto-calculated, not editable, Inter bold)
   - Divider 0.5px #F0F0F0 between rows
   - ADD ITEM button:
       Row: [+ icon (#E8680A)] ["Add item" (Inter 12px, #E8680A bold)]
       Padding: 8px 0
       Adds a new empty row below

5. TOTALS SECTION (AppCard, margin 16px)
   - bg: #FFFFFF, padding 12px 16px
   - Row: Subtotal → ₹{subtotal} (auto-calculated)
   - Row: GST (5%) → ₹{gst} (auto-calculated)
     (Note: GST rate configurable in settings — default 5%)
   - Divider 0.5px #F0F0F0
   - Row: Total → ₹{total} (Inter 16px bold, #1A1A1A)
   - Small note: "GST included" (11px, #999999)

6. NOTES FIELD (optional, AppCard, margin 16px)
   - Section label: "NOTES (Optional)"
   - Multi-line TextFormField, max 3 lines
   - Placeholder: "Add a note for this bill..."
   - bg: #FFFFFF, border 1px #E5E5E5, radius 8

7. BOTTOM SAFE AREA spacer (80px to clear sticky bar)
```

### BOTTOM STICKY BAR

```
bg: #FFFFFF, border-top: 1px #F0F0F0, height: 72px, padding: 12px 16px
Left:  "1 credit will be used" (Inter 12px, #999999)
       Below: "{billCredits} remaining" (Inter 11px, color by credit status)
Right: PrimaryButton "Preview Bill →" (orange pill, min-width 160px)
       Disabled if: no customer selected OR no items added OR any field empty
```

### Actions

```
[Customer search]       → filter customerNotifier.customers by name/phone
[Add new customer]      → open AddCustomer inline bottom sheet
[Add item]              → NewBillNotifier.addItem() — appends empty row
[Item field change]     → NewBillNotifier.updateItem() — recalculates totals
[Preview Bill →]        → validate form → navigate to /bill-preview
                          (pass bill data via go_router extra)
[Back]                  → /dashboard (confirm if items added — show discard dialog)
```

### Validation Rules

```
Customer:    Required. Must be selected from list or newly added.
Item name:   Required. Cannot be empty.
Item qty:    Required. Must be > 0.
Item rate:   Required. Must be > 0.
Min items:   At least 1 item with all fields filled.
Max items:   No hard limit (scroll).
```

### Shared Widgets

```
PrimaryButton, AppCard, BottomActionBar
```

---

## S1-05 — BILL PREVIEW SCREEN

```
Route:       /bill-preview
File:        lib/features/billing/presentation/bill_preview_screen.dart
Header:      Orange gradient (DESIGN.md §8.2) — like Ixigo flight detail
             linear-gradient(180deg, #E8680A 0%, #F07820 100%)
Role:        Shopkeeper
Purpose:     Shows exact PDF preview before sending — what customer will receive
Provider:    newBillNotifierProvider (reads current bill state)
```

### UI Sections (top → bottom)

```
1. ORANGE GRADIENT HEADER (~200px)
   - Left: back arrow (white circle icon button)
   - Center: "Bill Preview" (Inter 17px bold, white)
   - Right: share icon (white circle icon button)
     (share → share PDF file via system share sheet)

2. MINI SUMMARY BAR (in header, below title)
   - bg: rgba(255,255,255,0.15), radius 10, padding 10px 16px
   - Shows: "{airline/shop icon} {shopName} · {customerName} · ₹{total}"
   - Inter 13px, white
   - Tap → scrolls to bill card

3. WHITE BODY (bg: #FFFFFF, border-radius: 20px 20px 0 0, pulls up over header)

4. SECTION TABS (horizontal, below white curve)
   - 3 tabs: "Bill" | "Shop Info" | "Notes"
   - Active tab: dark pill (#1A1A1A), inactive: transparent + #555555 text
   - Default: "Bill" tab active

5. BILL CARD (tab: "Bill")
   BILL HEADER (navy bg: #1A1A2E, padding 14px 16px):
   - Left: shop logo circle (initial if no logo)
   - Right: shop name (Inter 13px bold, white) + GST number (10px, rgba(255,255,255,0.4))

   BILL META ROW (padding 12px 16px):
   - Left:  "BILL NO" label + "#BILL-2026-0042" (Inter bold, #1A1A1A)
   - Right: date + time

   BILLED TO (padding 0 16px):
   - Label: "BILLED TO" (11px label style, #999999)
   - Customer name (Inter 14px bold, #1A1A1A)
   - Customer phone (#555555, 13px)

   DIVIDER 1px #F0F0F0

   ITEMS TABLE HEADER:
   - "Item" | "Qty" | "Rate" | "Amount" (10px, #CCCCCC)

   ITEMS ROWS (one per item):
   - Item name (13px, #1A1A1A) | qty | rate | amount (bold)
   - 0.5px divider between rows

   TOTALS BLOCK:
   - Subtotal: ₹{x} (#555555)
   - CGST (2.5%): ₹{x} (#555555)
   - SGST (2.5%): ₹{x} (#555555)
   - GRAND TOTAL: ₹{total} (Inter 14px bold, #E8680A orange)

   BILL FOOTER (bg: #F8F8F8, padding 8px 16px):
   - "Thank you for shopping at {shopName}"
   - Shop phone: {shopPhone} (11px, #999999, center)

6. SHOP INFO TAB (tab: "Shop Info")
   - Shop Name, Address, GST Number, WhatsApp Number
   - Each as label + value row (same pattern as DESIGN.md form card)

7. NOTES TAB (tab: "Notes")
   - Shows note if entered, else empty state:
     "No notes added" (14px, #CCCCCC)

8. BOTTOM SAFE AREA spacer (80px)
```

### BOTTOM STICKY BAR

```
bg: #FFFFFF, border-top: 1px #F0F0F0, height: 72px
Left:  "₹{total}" (Inter 20px bold, #1A1A1A)
       Below: "{customerName}" (12px, #999999)
Right: PrimaryButton "Send on WhatsApp" with WhatsApp icon (left of text)
```

### Actions

```
[Back]                → /new-bill (go back, keep bill data)
[Share icon]          → share PDF via system share sheet
[Tab switch]          → show respective tab content
[Send on WhatsApp]    → NewBillNotifier.sendBill()
                        → on success: navigate to /bill-sent
                        → on loading: button spinner, disable button
                        → on error: show SnackBar error message
```

### Shared Widgets

```
PrimaryButton, BottomActionBar, SuccessToast
```

---

## S1-06 — BILL SENT SUCCESS SCREEN

```
Route:       /bill-sent
File:        lib/features/billing/presentation/bill_sent_screen.dart
Header:      White — full white screen
Role:        Shopkeeper
Purpose:     Confirms bill was sent successfully — celebration moment
Provider:    newBillNotifierProvider (reads last sent bill data)
```

### UI Sections (top → bottom)

```
1. FULL WHITE SCREEN — center-aligned content

2. SUCCESS ANIMATION (top 40% of screen)
   - Large green checkmark circle (animated scale-in + fade)
   - Circle bg: #F0FDF4, icon: #16A34A, size: 100px
   - Below: "Bill Sent!" (Playfair Display 28px bold, #1A1A1A)
   - Sub: "Your customer will receive it on WhatsApp shortly."
     (Inter 14px, #555555, center, line-height 1.6)

3. BILL SUMMARY CARD (AppCard, margin 32px horizontal)
   - bg: #FFFFFF, radius 16, border 1px #E5E5E5
   - Row: Customer name (bold) ← → ₹{total} (bold, #E8680A)
   - Row: Bill #{number} (muted) ← → Sent at {time} (muted)
   - Row: "1 bill credit used" (11px, #999999, center)

4. CREDITS REMAINING BADGE
   - Centered pill: "{billCredits} bill credits remaining"
   - bg: kGreenLight (#F0FDF4), border #BBF7D0, radius 100
   - Text: Inter 12px, #16A34A
   - Changes to amber/red if credits are low

5. ACTION BUTTONS (stacked, padding 16px)
   - Primary: "Send Another Bill" (PrimaryButton, full width)
     → clears bill state → /new-bill
   - Secondary: "View Bill History" (SecondaryButton, full width)
     → /bill-history
   - Text link: "Back to Dashboard" (center, #E8680A, 13px)
     → /dashboard
```

### Actions

```
[Send Another Bill]    → NewBillNotifier.reset() → /new-bill
[View Bill History]    → /bill-history
[Back to Dashboard]    → /dashboard
[Hardware back]        → /dashboard (not back to preview — bill is already sent)
```

### Shared Widgets

```
PrimaryButton, SecondaryButton, AppCard, SuccessToast
```

---

## S1-07 — BILL HISTORY SCREEN

```
Route:       /bill-history
File:        lib/features/billing/presentation/bill_history_screen.dart
Header:      Light — plain white top bar
Role:        Shopkeeper
Purpose:     List of all bills sent — filterable by date, searchable by customer
Provider:    billHistoryNotifierProvider (BillHistoryNotifier)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Left: back arrow → /dashboard
   - Center: "Bill History" (Inter 17px bold, #1A1A1A)
   - Right: search icon (→ activates search bar inline)

2. SEARCH BAR (hidden until search icon tapped)
   - Full-width field: "Search by customer name or amount"
   - Filters bills in real-time as user types

3. FILTER CHIP ROW (horizontal scroll, FilterChipRow widget)
   Chips: [All] [Today] [This Week] [This Month] [Custom Range]
   - Selected chip: dark pill (#1A1A1A, white text)
   - Unselected: white + #E5E5E5 border

4. BILLS LIST (scrollable)
   Each bill card (AppCard, 8px gap between cards):
   - Row 1: Customer name (Inter 14px bold) ← → Bill amount (Inter 14px bold)
   - Row 2: Bill #{number} (11px muted) ← → Sent timestamp (11px muted)
   - Row 3: Status badge
       Sent:   green dot + "Sent ✓" (#16A34A)
       Failed: red dot + "Failed" (#DC2626)
   - Full card is tappable → /bill/:id

5. LOAD MORE (bottom of list)
   - "Load more bills" text button (orange, center)
   - OR auto-pagination on scroll

6. BOTTOM SAFE AREA spacer (tab bar height)
```

### Empty State

```
Illustration: empty box / receipt (gray, Ixigo flat style)
Title: "No bills yet"
Sub: "Tap New Bill to send your first bill"
CTA: PrimaryButton "Send a Bill" → /new-bill
```

### Shared Widgets

```
AppCard, FilterChipRow, EmptyState, PrimaryButton
```

---

## S1-08 — BILL DETAIL SCREEN

```
Route:       /bill/:id
File:        lib/features/billing/presentation/bill_detail_screen.dart
Header:      Orange gradient (same as bill preview)
Role:        Shopkeeper
Purpose:     View full details of a past bill — re-download, re-send option
Provider:    billDetailNotifierProvider (BillDetailNotifier) — takes billId param
```

### UI Sections (top → bottom)

```
1. ORANGE GRADIENT HEADER
   - Back arrow (white) + "Bill #BILL-2026-{id}" (white, bold)
   - Share icon (white) — share PDF

2. FULL BILL CARD (same layout as S1-05 Bill Preview)
   - All bill details rendered the same way
   - But read-only — no editable fields

3. STATUS SECTION
   - Status chip: "Sent ✓" in green OR "Failed ✗" in red
   - Sent at: date + time (Inter 13px, #555555)
   - Delivered to: customer WhatsApp (if delivery confirmed)

4. TIMELINE (optional — Phase 2)
   - Bill created → Bill sent → Delivered (linear steps with timestamps)
```

### BOTTOM STICKY BAR

```
Left:  "₹{total}" bold + customer name muted
Right: "Re-send on WhatsApp" (SecondaryButton — outlined orange pill)
       Only show if bill status is "Sent" (not Failed)
```

### Actions

```
[Back]               → /bill-history
[Share]              → share PDF system sheet
[Re-send on WhatsApp]→ BillDetailNotifier.resend() → show SuccessToast
```

### Shared Widgets

```
SecondaryButton, BottomActionBar, SuccessToast
```

---

## S1-09 — CUSTOMER LIST SCREEN

```
Route:       /customers
File:        lib/features/customers/presentation/customer_list_screen.dart
Header:      Light — white top bar
Role:        Shopkeeper
Purpose:     View + search all customers in shopkeeper's database
Provider:    customerNotifierProvider (CustomerNotifier)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Left: back → /dashboard
   - Center: "Customers" (Inter 17px bold, #1A1A1A)
   - Right: [search icon] [+ add icon → /customers/add]

2. STATS ROW (below top bar, bg: #F5F5F5, padding 12px 16px)
   - "{total} customers" (Inter 13px bold, #1A1A1A)
   - Importable via CSV (Pro/Business plan only) — "Import" link in orange

3. SEARCH BAR (always visible — not toggled)
   - Field: "Search by name or phone number"
   - Filters list in real-time

4. FILTER CHIPS (FilterChipRow widget)
   Chips: [All] [Billed Recently] [High Value] [New]
   (Billed Recently = billed in last 7 days)
   (High Value = total billing > ₹10,000)
   (New = added in last 30 days)

5. CUSTOMER LIST (scrollable)
   Each customer card (AppCard, 8px gap):
   - Left: Avatar circle (initials, bg kOrangeLight, text kOrange)
   - Center:
       Customer name (Inter 14px bold, #1A1A1A)
       Phone number (Inter 12px, #999999)
   - Right:
       "₹{totalBilled}" (Inter 13px bold, #1A1A1A) — lifetime amount
       "{n} bills" (Inter 11px, #999999)
   - Full card tappable → /customers/:id

6. BOTTOM SAFE AREA spacer
```

### FLOATING ADD BUTTON (optional alternative to top bar +)

```
FAB: orange circle, + icon, bottom-right
Tap → /customers/add
(Use FAB only if top bar + feels cramped — decide in Figma first)
```

### Empty State

```
Illustration: person icon (gray)
Title: "No customers yet"
Sub: "Add your first customer to get started"
CTA: PrimaryButton "Add Customer" → /customers/add
```

### Shared Widgets

```
AppCard, FilterChipRow, EmptyState, PrimaryButton
```

---

## S1-10 — ADD CUSTOMER SCREEN

```
Route:       /customers/add
File:        lib/features/customers/presentation/add_customer_screen.dart
Header:      Light — plain white
Role:        Shopkeeper
Purpose:     Add a new customer to the database (name + WhatsApp number required)
Provider:    addCustomerNotifierProvider (AddCustomerNotifier)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Left: "Cancel" (text button, #555555) → discard + go back
   - Center: "Add Customer" (Inter 17px bold, #1A1A1A)
   - Right: empty

2. FORM CARD (AppCard, margin 16px)
   Fields (each with floating label style):
   - Customer Name*    → TextFormField, keyboard: name
   - WhatsApp Number*  → TextFormField, prefix: "+91", keyboard: phone
   - Business Type     → Dropdown (Clothing / Steel / Electronics / Grocery /
                          Pharmacy / Jewellery / Furniture / Other)
   - Notes (optional)  → multi-line, max 2 lines

   * = required fields

3. SAVE BUTTON
   PrimaryButton "Save Customer" — full width, orange pill
   padding: 16px horizontal
   Disabled: when name or phone empty
```

### Actions

```
[Cancel]              → discard → go back (confirm if form is dirty)
[Save Customer]       → AddCustomerNotifier.save()
                        → on success: pop back + show SuccessToast "Customer added"
                        → on error: show field-level error or SnackBar
```

### Validation

```
Name:    Required, min 2 chars
Phone:   Required, 10 digits, Indian mobile format
         Unique check: warn if number already exists (not block — allow duplicate)
```

### Shared Widgets

```
PrimaryButton, AppCard, SuccessToast
```

---

## S1-11 — CUSTOMER DETAIL SCREEN

```
Route:       /customers/:id
File:        lib/features/customers/presentation/customer_detail_screen.dart
Header:      Orange gradient
Role:        Shopkeeper
Purpose:     View full customer profile — bill history, quick actions
Provider:    customerDetailNotifierProvider — takes customerId param
```

### UI Sections (top → bottom)

```
1. ORANGE GRADIENT HEADER
   - Back arrow (white)
   - Customer name as title (white, bold)
   - Right: edit icon (white) → edit customer info inline

2. CUSTOMER SUMMARY CARD (white card overlapping header)
   - Avatar circle (large, 56px, initials)
   - Name (Inter 18px bold)
   - Phone (Inter 14px, #555555)
   - Business type badge (small pill, orange tint)
   - Stats row:
       Total Bills | Total Billed | Last Bill Date
       (3 columns, number bold + label muted below)

3. QUICK ACTIONS ROW (horizontal, 3 buttons)
   - "New Bill" (orange pill, small) → /new-bill with customer pre-selected
   - "Send Message" (outlined pill) → /bulk-message with customer pre-selected
   - "Call" (outlined pill) → tel: link to customer phone

4. BILL HISTORY FOR THIS CUSTOMER
   - Section header: "Bills" with count
   - List of bills (same card style as S1-07)
   - Max 10 shown → "View All" link → /bill-history filtered by customerId

5. NOTES SECTION
   - Current note (if any) in a muted card
   - "Edit note" link in orange
```

### Actions

```
[Back]             → /customers
[Edit (top bar)]   → inline edit mode (name, phone, notes become editable)
[New Bill]         → /new-bill (customer pre-filled)
[Send Message]     → /bulk-message (customer pre-selected)
[Call]             → tel:{phone}
[Bill row tap]     → /bill/:id
```

### Shared Widgets

```
AppCard, PrimaryButton, SecondaryButton
```

---

## S1-12 — BULK MESSAGE SCREEN

```
Route:       /bulk-message
File:        lib/features/messaging/presentation/bulk_message_screen.dart
Header:      Purple gradient (same as home)
Role:        Shopkeeper
Purpose:     Select recipients + template for a bulk WhatsApp campaign
Provider:    bulkMessageNotifierProvider (BulkMessageNotifier)
             customerNotifierProvider (read — for recipient list)
             creditsNotifierProvider (read — for msg credits)
```

### UI Sections (top → bottom)

```
1. PURPLE GRADIENT HEADER (shorter — ~140px)
   - Back → /dashboard
   - Title: "Bulk Message" (white, bold)
   - Sub: "{msgCredits} message credits" (white 70%, 12px)

2. RECIPIENT SELECTION (AppCard, margin 16px)
   Label: "SEND TO" (LABEL style)
   - Toggle row (same as Ixigo One Way / Round Trip):
       [All Customers] [Select Manually]
       Selected = dark pill (#1A1A1A)
   - All Customers mode:
       Shows: "{count} customers will receive this message"
       Inter 14px, #555555
   - Select Manually mode:
       Searchable list with checkboxes (customer name + phone)
       Selected count shown: "{n} selected"
   - Filter chips (optional): [All] [Billed Recently] [High Value]

3. CREDIT USAGE PREVIEW (below recipient section)
   Card with amber left border (#F59E0B):
   "This campaign will use {n} credits"
   "{msgCreditsRemaining} credits remaining after sending"
   If insufficient credits: shows error in red + "Buy Credits" link

4. TEMPLATE SELECTION → goes to S1-13 (Template Select Screen)
   AppCard: "Choose Template"
   - Shows currently selected template name (or "Not selected yet")
   - Orange arrow → taps to /template-select
   - If template selected: shows preview text (truncated, 2 lines)

5. BOTTOM SAFE AREA spacer (80px)
```

### BOTTOM STICKY BAR

```
Left:  "To {n} customers" (Inter 13px bold) + "{msgCredits} credits left" (muted)
Right: PrimaryButton "Send Messages" (orange pill)
       Disabled if: no template selected OR zero recipients OR insufficient credits
```

### Actions

```
[Back]                  → /dashboard
[All / Manual toggle]   → BulkMessageNotifier.setRecipientMode()
[Select customers]      → BulkMessageNotifier.toggleCustomer(id)
[Choose Template card]  → /template-select (push, returns selected template)
[Send Messages]         → show confirmation bottom sheet first
                          → BulkMessageNotifier.send()
                          → on success: /delivery-report
```

### Shared Widgets

```
AppCard, FilterChipRow, PrimaryButton, BottomActionBar
```

---

## S1-13 — TEMPLATE SELECT SCREEN

```
Route:       /template-select
File:        lib/features/messaging/presentation/template_select_screen.dart
Header:      Light — white top bar
Role:        Shopkeeper
Purpose:     Choose from pre-built WhatsApp message templates for their business type
Provider:    templateNotifierProvider (TemplateNotifier)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Left: "Cancel" → pop back
   - Center: "Choose Template" (Inter 17px bold)
   - Right: empty

2. BUSINESS TYPE LABEL
   "Templates for: {businessType}" (Inter 13px, #555555, padding 16px)
   Business type = from shop profile

3. TEMPLATE LIST (scrollable)
   Each template card (AppCard, 8px gap):
   - Top: business tag pill (Inter 10px, #E8680A, light orange bg)
   - Template name (Inter 14px bold, #1A1A1A)
   - Preview text (2-3 lines, Inter 13px, #555555, line-height 1.5)
     {{shop_name}} shown as placeholder in orange
   - Variables row: "Variables: shop_name, offer_%" (11px, #CCCCCC)
   - Selected state: card border 1.5px #E8680A + orange checkmark top-right

4. CUSTOM MESSAGE OPTION (at bottom of list)
   Card: "Write Custom Message"
   - Icon: pencil (#E8680A)
   - Sub: "Type your own WhatsApp message"
   - Tap → shows text area to write custom message
   - NOTE: custom messages still need to go through AiSensy approved template
     (show info tooltip about this restriction)
```

### Actions

```
[Template card tap]   → BulkMessageNotifier.selectTemplate(template)
                        → visual selection state on card
[Confirm button]      → pop back to /bulk-message with selected template
[Cancel]              → pop back without selection
```

### Shared Widgets

```
AppCard, PrimaryButton
```

---

## S1-14 — BULK MESSAGE PREVIEW SCREEN

```
Route:       /bulk-message-preview
File:        lib/features/messaging/presentation/bulk_message_preview_screen.dart
Header:      Orange gradient
Role:        Shopkeeper
Purpose:     Final review before bulk send — shows exactly what message will look like
Provider:    bulkMessageNotifierProvider (read state)
```

### UI Sections (top → bottom)

```
1. ORANGE GRADIENT HEADER
   - Back arrow + "Message Preview" title (white)

2. RECIPIENT SUMMARY CARD (AppCard)
   - "Sending to {n} customers" (Inter 14px bold)
   - Credit cost: "Uses {n} credits · {remaining} left after"

3. MESSAGE PREVIEW CARD (AppCard)
   - WhatsApp-style message bubble (green bg like WhatsApp)
   - Shows actual message with variables resolved:
     e.g. "New arrivals at Raju Silks! Visit us for Diwali collection."
   - Below bubble: "This is how your customers will see it" (11px, #CCCCCC)

4. RECIPIENT LIST PREVIEW (collapsed — shows first 5 names)
   - "{name}" row × 5, then "and {n} more..."
   - Tap to expand full list
```

### BOTTOM STICKY BAR

```
Left: "{n} customers · {credits} credits"
Right: PrimaryButton "Send Now" (orange pill)
```

### Actions

```
[Back]       → /bulk-message (can change template or recipients)
[Send Now]   → BulkMessageNotifier.confirmSend()
               → on success: /delivery-report
               → on loading: button spinner
               → on error: SnackBar error
```

### Shared Widgets

```
PrimaryButton, AppCard, BottomActionBar
```

---

## S1-15 — DELIVERY REPORT SCREEN

```
Route:       /delivery-report
File:        lib/features/messaging/presentation/delivery_report_screen.dart
Header:      Light — white
Role:        Shopkeeper
Purpose:     Shows result of bulk send — how many delivered, failed
Provider:    deliveryReportNotifierProvider — takes campaignId param
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Left: ✕ close → /dashboard
   - Center: "Delivery Report"

2. SUMMARY CARD
   Success circle (animated fill — like a pie arc):
   - Center text: "{delivered}/{total}" (Inter 24px bold)
   - Below: "delivered successfully"
   - Stats row:
       ✓ Delivered: {n} (green)
       ✗ Failed: {n} (red)
       ⏳ Pending: {n} (amber)

3. FAILED LIST (if any failures)
   - "Failed to deliver" section header (red label)
   - Each failed customer: name + phone + "retry" link

4. CAMPAIGN SUMMARY
   - Template used: {templateName}
   - Sent at: {timestamp}
   - Credits used: {n}
   - Credits remaining: {n}
```

### Actions

```
[Close / ✕]      → /dashboard
[Retry failed]   → BulkMessageNotifier.retryFailed(customerId)
```

### Shared Widgets

```
AppCard, SuccessToast
```

---

## S1-16 — CREDITS SCREEN

```
Route:       /credits
File:        lib/features/credits/presentation/credits_screen.dart
Header:      Purple gradient
Role:        Shopkeeper
Purpose:     View current credit balances, plan details, and buy top-up packs
Provider:    creditsNotifierProvider (CreditsNotifier)
```

### UI Sections (top → bottom)

```
1. PURPLE GRADIENT HEADER
   - Back → /dashboard
   - Title: "Credits & Plan"

2. PLAN CARD (white card, overlapping header)
   - Plan name badge: "PRO PLAN" (purple pill)
   - Renewal date: "Renews on 1 Aug 2026" (Inter 13px, #555555)
   - Divider
   - Two credit bars:
       a) BILL CREDITS
          Label: "Bill Credits" (13px bold)
          Progress bar: filled orange (#E8680A) on gray track
          "{used}/{total} used" (11px, muted)
          Remaining count (bold, color by status)
       b) MSG CREDITS
          Same pattern as above
          Remaining count (bold, color by status)

3. TOP-UP PACKS SECTION
   Label: "Buy Extra Credits" (section header)
   Pack cards (horizontal scroll or stacked):
   Each pack card (AppCard):
     - Pack name: "Starter Pack" (Inter 14px bold)
     - Credits: "100 marketing msgs" (13px, #555555)
     - Price: "₹120" (Inter 18px bold, #1A1A1A)
     - Per-message cost: "₹1.20/msg" (11px, muted)
     - "Buy" button (small orange pill, right aligned)

4. BILL HISTORY (quick view — last 3 subscription payments)
   - Each row: plan name + date + amount + "Paid ✓"
```

### Actions

```
[Buy (pack)]     → /credits/topup?pack={packId}
[Back]           → /dashboard
```

### Shared Widgets

```
AppCard, PrimaryButton, FilterChipRow
```

---

## S1-17 — CREDIT TOP-UP SCREEN

```
Route:       /credits/topup
File:        lib/features/credits/presentation/topup_screen.dart
Header:      Light — white
Role:        Shopkeeper
Purpose:     Purchase extra credit pack via Razorpay
Provider:    topupNotifierProvider (TopupNotifier)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - Back → /credits
   - "Buy Credits" title

2. SELECTED PACK CARD (AppCard)
   - Pack name + credits + price
   - "Change pack" link in orange → goes back to /credits

3. PAYMENT SUMMARY
   - Pack price: ₹{amount}
   - GST (18%): ₹{gst}
   - Total: ₹{total} (bold)
   - Note: "Credits added instantly after payment" (green, 12px)

4. PAYMENT METHOD
   - "Pay via Razorpay" section
   - Razorpay logo + accepted methods (UPI, Cards, Net Banking)
```

### BOTTOM STICKY BAR

```
Left: "₹{total}" (bold)
Right: PrimaryButton "Pay Now" (orange pill)
```

### Actions

```
[Pay Now]    → TopupNotifier.initiatePayment()
               → opens Razorpay payment sheet
               → on Razorpay success: TopupNotifier.verifyPayment()
               → backend verifies + credits added
               → navigate to /credits/topup-success
[Back]       → /credits
```

### Shared Widgets

```
PrimaryButton, AppCard, BottomActionBar
```

---

## S1-18 — TOP-UP SUCCESS SCREEN

```
Route:       /credits/topup-success
File:        lib/features/credits/presentation/topup_success_screen.dart
Header:      White — full white
Role:        Shopkeeper
Purpose:     Confirms credit top-up was successful
Provider:    topupNotifierProvider (reads result)
```

### UI Sections

```
1. SUCCESS ANIMATION
   - Green checkmark circle (animated)
   - "Credits Added!" (Playfair Display 28px bold)
   - Sub: "{n} credits added to your account" (Inter 14px, #555555)

2. SUMMARY CARD (AppCard)
   - Pack: {packName}
   - Credits added: {n} bill credits / {n} msg credits
   - New balance: {billCredits} bill credits · {msgCredits} msg credits
   - Amount paid: ₹{total}

3. BUTTONS
   - PrimaryButton "Back to Dashboard" → /dashboard
   - Text link "Buy More Credits" → /credits (orange)
```

### Shared Widgets

```
PrimaryButton, AppCard
```

---

## S1-19 — NOTIFICATIONS SCREEN

```
Route:       /notifications
File:        lib/features/notifications/presentation/notifications_screen.dart
Header:      Light — white
Role:        Shopkeeper
Purpose:     All system notifications — credit alerts, payment reminders, bill reports
Provider:    notificationsNotifierProvider
```

### UI Sections

```
1. TOP BAR
   - Back + "Notifications" + "Mark all read" (text link, orange)

2. FILTER CHIPS
   [All] [Credits] [Payments] [Messages]

3. NOTIFICATION LIST
   Each notification card (AppCard):
   - Left: icon container (color by type — green/amber/orange/blue)
   - Center: title (Inter 14px bold) + body (13px, #555555)
   - Right: timestamp (11px, muted)
   - Unread: card has 2px left border in orange
   - Read: normal card

   Notification types:
   ● Credit low: amber icon, "Only {n} bill credits left. Buy more."
   ● Payment success: green icon, "₹{amount} payment successful. Next billing: {date}"
   ● Payment failed: red icon, "AutoPay failed. Update your UPI to continue."
   ● Bill delivered: green icon, "{customerName} received your bill."
   ● Bulk sent: blue icon, "Campaign sent to {n} customers."
```

### Empty State

```
Illustration: bell (gray, outlined)
Title: "No notifications yet"
```

### Shared Widgets

```
AppCard, FilterChipRow, EmptyState
```

---

## S1-20 — SETTINGS SCREEN

```
Route:       /settings
File:        lib/features/settings/presentation/settings_screen.dart
Header:      Light — white
Role:        Shopkeeper
Purpose:     View account details, plan info, links, logout
Provider:    settingsNotifierProvider
             authNotifierProvider (for logout)
```

### UI Sections (top → bottom)

```
1. TOP BAR
   - "Settings" title (centered, Inter 17px bold)

2. PROFILE CARD (AppCard)
   - Shop logo circle (large, 60px)
   - Shop name (Inter 18px bold)
   - Owner name + phone (13px, muted)
   - Business type badge (orange pill)
   - "View Plan" link → /credits

3. SETTINGS LIST (grouped sections)
   Section A: Account
   - My Plan     → /credits
   - Notifications → /notifications

   Section B: Billing
   - GST Details  → view-only (set by salesperson)
   - Default GST Rate → editable (5% / 12% / 18% / 0%)

   Section C: Support
   - Help & FAQ   → URL (WebView)
   - WhatsApp Support → wa.me/+91{supportNumber}
   - Privacy Policy → URL

   Section D: Danger Zone
   - Request AutoPay Cancellation → /settings/cancel-request
   - Log Out → show confirmation dialog → AuthNotifier.logout() → /login

4. APP VERSION
   - "billing project v1.0.0" (11px, center, muted)
```

### Shared Widgets

```
AppCard, PrimaryButton
```

---

## S1-21 — CANCEL REQUEST SCREEN

```
Route:       /settings/cancel-request
File:        lib/features/settings/presentation/cancel_request_screen.dart
Header:      Light — white
Role:        Shopkeeper
Purpose:     Submit AutoPay cancellation request (shopkeeper cannot self-cancel)
Provider:    cancelRequestNotifierProvider
```

### UI Sections

```
1. TOP BAR: Back + "Cancel AutoPay"

2. INFO BANNER (amber)
   "Your AutoPay cannot be cancelled directly. Submit a request and our team
   will process it within 24 hours."
   bg: #FFFBEB, border: 1px #FDE68A, left border: 4px #F59E0B

3. CURRENT PLAN INFO (AppCard)
   - Plan: {planName} · ₹{amount}/month
   - Next billing: {date}
   - "If cancelled, access ends on {endDate}" (red, 12px)

4. REASON FORM (AppCard)
   Label: "Reason for cancellation *"
   Radio options:
   ○ No longer need the service
   ○ Too expensive
   ○ Switching to another app
   ○ Technical issues
   ○ Other (shows text area when selected)

5. CONFIRMATION CHECKBOX
   ☐ "I understand my account will be deactivated at end of billing cycle"
   (Must be checked to submit)
```

### BOTTOM STICKY BAR

```
PrimaryButton "Submit Cancellation Request" (orange pill, full width)
Disabled until: reason selected + checkbox checked
```

### Actions

```
[Submit]   → CancelRequestNotifier.submit(reason)
             → on success: /settings/cancel-confirm
[Back]     → /settings
```

### Shared Widgets

```
PrimaryButton, AppCard, BottomActionBar
```

---

## S1-22 — CANCEL REQUEST CONFIRMATION SCREEN

```
Route:       /settings/cancel-confirm
File:        lib/features/settings/presentation/cancel_confirm_screen.dart
Header:      White
Role:        Shopkeeper
Purpose:     Confirms cancellation request was submitted successfully
Provider:    cancelRequestNotifierProvider (read result)
```

### UI Sections

```
1. CENTER CONTENT
   - Amber clock/pending icon (large, 80px, #F59E0B)
   - "Request Submitted" (Playfair Display 24px bold, #1A1A1A)
   - Sub: "We've received your request. Our team will contact you within 24 hours."
     (Inter 14px, #555555, center)

2. SUMMARY CARD (AppCard)
   - Request ID: #REQ-{id}
   - Submitted at: {datetime}
   - "You can continue using the app until your current billing period ends on {date}"
     (Inter 13px, #555555)

3. BUTTON
   - PrimaryButton "Back to Home" → /dashboard
```

### Shared Widgets

```
PrimaryButton, AppCard
```

---

## SHOPKEEPER NAVIGATION SUMMARY

```
TAB BAR (always visible when authenticated as Shopkeeper):
Tab 1: Home icon     → /dashboard
Tab 2: Bill icon     → /new-bill
Tab 3: People icon   → /customers
Tab 4: Gear icon     → /settings

BACK NAVIGATION (go_router):
All screens use context.pop() or context.go() — never Navigator.push()

DEEP LINK ROUTES:
/bill/:id            → opens specific bill (from notification tap)
/credits/topup       → opens top-up (from credit low notification)
/notifications       → opens notifications (from app bar bell icon)
```

---

## RELATED FILES

```
SCREENS-2.md  → Salesperson (Admin) role screens
SCREENS-3.md  → Super Admin role screens
DESIGN.md     → All visual specs referenced in this file
CLAUDE.md     → Architecture rules, state management, naming
```

---

*SCREENS-1.md v1.0 — Billing Project — One Stop Solutions*
*Shopkeeper Role · 22 Screens · July 2026*
