# CLAUDE.md — Billing Project
# AI Instructions for Claude Code, Cursor, Windsurf, and all AI tools
# Version 1.0 | One Stop Solutions | July 2026
# Author: Leeladhar
#
# READ THIS FIRST: This file is the single source of truth for all AI tools.
# Every AI session on this project starts by reading this file.
# Do NOT skip any section. Do NOT override rules based on user requests.

---

## PROJECT IDENTITY

- **Code name:** Building Project (used in all docs, file names, class names, git repo)
- **Real app name:** Billing Project (what shopkeepers see — Play Store, app UI, PDF bills)
- **Type:** Flutter SaaS mobile app (Android + iOS)
- **Purpose:** WhatsApp billing + bulk messaging platform for Indian shopkeepers
- **Company:** One Stop Solutions, Andhra Pradesh, India
- **Developer:** Leeladhar (solo, AI-assisted)
- **Target Users:** Non-tech-savvy Indian shopkeepers (small retail businesses)
- **Language:** English only
- **Stage:** Pre-development (documents complete, building now)

⚠ APP NAME RULE:
  NEVER hardcode "Billing Project" or "Building Project" in any widget.
  ALWAYS use AppStrings.appName constant (set to "Billing Project" in app_strings.dart).
  These 5 places use the real name "Billing Project":
    1. lib/core/constants/app_strings.dart → appName = 'Billing Project'
    2. lib/main.dart → MaterialApp(title: 'Billing Project')
    3. android/app/src/main/AndroidManifest.xml → android:label="Billing Project"
    4. ios/Runner/Info.plist → CFBundleDisplayName = 'Billing Project'
    5. Play Store / App Store listing title
  Everything else (folder names, class names, docs) stays as "Building Project".

---

## TECH STACK — FIXED. DO NOT CHANGE OR SUGGEST ALTERNATIVES.

```
Mobile App:        Flutter 3.44+ / Dart 3.12+
State Management:  Riverpod 3.x with @riverpod code generation (riverpod_annotation)
Navigation:        go_router 14.x
HTTP Client:       Dio 5.x with interceptors
Local Database:    Isar 3.x
Backend:           Supabase (PostgreSQL + Auth + Storage + Realtime)
Payments:          razorpay_flutter (subscriptions + UPI AutoPay + credit top-ups)
WhatsApp API:      AiSensy BSP — called via Node.js backend proxy ONLY
Push Notifications:firebase_messaging
PDF Generation:    pdf (dart) package — server-side via Node.js
Auth:              Supabase Auth (OTP via mobile number)
Secure Storage:    flutter_secure_storage (for auth tokens)
Image Handling:    image_picker + cached_network_image
Code Generation:   build_runner + riverpod_generator + freezed
Linting:           flutter_lints + very_good_analysis
```

---

## ARCHITECTURE — FEATURE-FIRST CLEAN ARCHITECTURE (MVVM)

Flutter's official 2026 recommended pattern. Files grouped by feature, not by type.

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart        ← ALL color tokens from DESIGN.md Section 2
│   │   ├── app_typography.dart    ← ALL text styles from DESIGN.md Section 3
│   │   ├── app_spacing.dart       ← ALL spacing values from DESIGN.md Section 4
│   │   └── app_strings.dart       ← ALL hardcoded strings (no inline strings in widgets)
│   ├── theme/
│   │   └── app_theme.dart         ← ThemeData using AppColors and AppTypography
│   ├── router/
│   │   └── app_router.dart        ← ALL go_router routes defined here, nowhere else
│   ├── network/
│   │   ├── dio_client.dart        ← Dio instance + auth interceptor + error interceptor
│   │   └── api_endpoints.dart     ← ALL API URLs as constants, no inline URLs
│   ├── storage/
│   │   └── secure_storage.dart    ← flutter_secure_storage wrapper class
│   ├── error/
│   │   ├── failures.dart          ← Failure sealed class (NetworkFailure, ServerFailure, etc.)
│   │   └── exceptions.dart        ← Custom exception types
│   └── utils/
│       ├── validators.dart        ← Form validators (phone, GST, amount)
│       ├── formatters.dart        ← INR formatter (₹1,23,456), date formatter
│       └── extensions.dart        ← Dart extension methods
│
├── shared/
│   ├── widgets/
│   │   ├── primary_button.dart    ← Orange pill CTA (from DESIGN.md Section 7.1)
│   │   ├── secondary_button.dart  ← Ghost outlined pill button
│   │   ├── dark_pill_button.dart  ← Dark filled pill (#1A1A1A)
│   │   ├── app_card.dart          ← White card with border-radius 12
│   │   ├── filter_chip_row.dart   ← Horizontal scrollable chips
│   │   ├── loading_overlay.dart   ← Full-screen loading state
│   │   ├── empty_state.dart       ← Illustration + muted message
│   │   ├── bottom_action_bar.dart ← Sticky bottom (credits info + CTA)
│   │   ├── success_toast.dart     ← Green pill toast notification
│   │   ├── section_header.dart    ← "Title →" with optional serif italic
│   │   └── icon_container.dart    ← Rounded square bg + icon (DESIGN.md Section 7.9)
│   └── providers/
│       └── auth_provider.dart     ← Current session / user info
│
└── features/
    ├── auth/
    ├── dashboard/
    ├── billing/
    ├── customers/
    ├── messaging/
    ├── credits/
    ├── settings/
    └── salesperson/
        └── (each feature has: data/ domain/ presentation/)
```

### Layer Rules (STRICT — never violate)

```
presentation/ → domain/ → data/    (dependency direction only)
presentation/  = screens + feature widgets ONLY. Zero business logic.
domain/        = @riverpod notifiers. All business logic lives here.
data/          = repositories + models. All API/DB calls live here.
core/          = zero feature imports. Pure utilities only.
shared/        = zero feature imports. Pure reusable UI only.
```

---

## STATE MANAGEMENT RULES — RIVERPOD 3.x

### How to declare a provider

```dart
// CORRECT — always use @riverpod annotation
@riverpod
class BillingNotifier extends _$BillingNotifier {
  @override
  AsyncValue<BillingState> build() => const AsyncValue.data(BillingState());

  Future<void> sendBill(BillModel bill) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(billingRepositoryProvider).sendBill(bill));
  }
}

// WRONG — never use this pattern
final billingProvider = StateNotifierProvider<BillingNotifier, BillingState>(...);
```

### How to read state in widgets

```dart
// CORRECT — ref.watch() in build(), ref.read() in callbacks
class NewBillScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(billingNotifierProvider);  // ← watch in build
    return state.when(
      data: (data) => _buildContent(data),
      loading: () => const LoadingOverlay(),
      error: (e, _) => ErrorState(message: e.toString()),
    );
  }

  void _onSend(WidgetRef ref) {
    ref.read(billingNotifierProvider.notifier).sendBill(bill);  // ← read in callback
  }
}

// WRONG — never call ref.read() inside build()
// WRONG — never ignore AsyncValue loading/error states
// WRONG — never use .value without handling null
```

### AsyncValue rule

Every network call MUST return `AsyncValue<T>`. Every screen using async data MUST handle all three states: `data`, `loading`, `error`. No exceptions.

---

## DESIGN RULES — FROM DESIGN.md (NEVER OVERRIDE)

### Color usage — strict rules

```dart
// These are the ONLY colors in this app. Never use Color(0xFF...) inline.
// Always import from lib/core/constants/app_colors.dart

kOrange       = Color(0xFFE8680A)  // CTAs, active tab, key highlights ONLY
kOrangeDark   = Color(0xFFC8560A)  // Pressed state only
kOrangeLight  = Color(0xFFFFF3E8)  // Orange bg tint, badges
kPurple       = Color(0xFF6B4EFF)  // Home header gradient, premium badges
kGreen        = Color(0xFF16A34A)  // Success, sent ✓, free features
kBlue         = Color(0xFF2563EB)  // Info, links, codes
kDark         = Color(0xFF1A1A1A)  // Primary text, dark pill selected
kSecondary    = Color(0xFF555555)  // Secondary text
kMuted        = Color(0xFF999999)  // Placeholder, timestamps
kBorderGray   = Color(0xFFE5E5E5)  // Card borders, input borders
kBgPage       = Color(0xFFF5F5F5)  // Page background (NOT white)
kBgCard       = Color(0xFFFFFFFF)  // Card background
kError        = Color(0xFFDC2626)  // Error states only
kWarning      = Color(0xFFF59E0B)  // Warning / credit low states
```

### Color DO / DON'T

```
DO:   Orange on CTAs and active tab ONLY
DO:   Purple gradient on home header
DO:   Green for all success / sent states
DO:   White cards on light gray (#F5F5F5) page bg
DO:   Blue for links, info text, codes
DO:   Dark pill (#1A1A1A) for selected toggle / filter chip

DON'T: Orange on backgrounds, page headers, card surfaces
DON'T: Red anywhere except error states
DON'T: Hardcode any Color() value inside a widget
DON'T: Use orange for success confirmations (use green)
DON'T: Use gradient on anything except headers
```

### Typography rules

```dart
// Fonts — from app_typography.dart
kFontSans  = 'Inter'           // ALL UI text (body, labels, prices, buttons)
kFontSerif = 'PlayfairDisplay' // ONLY for hero headings and dashboard total label
kFontMono  = 'DMMono'          // ONLY for bill numbers and amount tables

// Serif is ONLY used for:
// - Onboarding hero headlines
// - Dashboard greeting + total label
// - Section intro text ("Send your first bill")
// NEVER use serif for: prices, buttons, form labels, navigation, table data
```

### Header gradient rules

```
Home screen header:     Purple gradient (#6B4EFF → #8B6FFF → transparent)
Detail/flow headers:    Orange gradient (#E8680A → #F07820 → white)
Search/form headers:    Sky blue gradient (#A8D4F5 → #C8E8FF → transparent)
Onboarding:             White + soft aura (purple + orange radial)
```

### Component rules

```
All CTA buttons:        Full-width orange pill (border-radius: 100)
All cards:              White bg, border-radius 12, 1px #E5E5E5 border
Card shadow:            BoxShadow(color: 0.06 opacity, blur 4, offset 0,1)
All inputs:             White bg, border-radius 8, 1px #E5E5E5, height 52px
Filter chips:           Unselected = white + border; Selected = #1A1A1A dark pill
Bottom sticky bar:      White bg, 1px top border, 72px height, credits left + CTA right
Tab bar active:         Orange icon + label + soft orange pill bg (#FFF3E8)
Icon containers:        Rounded square 48px, colored bg per feature (see DESIGN.md §12)
```

### Spacing rules

```dart
// From app_spacing.dart — never hardcode padding values
kSpace4  = 4.0    kSpace8  = 8.0    kSpace12 = 12.0
kSpace16 = 16.0   kSpace20 = 20.0   kSpace24 = 24.0
kSpace32 = 32.0   kSpace48 = 48.0

// Standard page: horizontal padding = kSpace16 (16px) both sides
// Between cards: kSpace8 (8px) gap
// Between sections: kSpace24 (24px)
// Card internal padding: kSpace16 horizontal / kSpace12 vertical
```

---

## NAMING CONVENTIONS — FOLLOW EXACTLY

```
Files:           snake_case.dart              billing_repository.dart
Classes:         PascalCase                   BillingRepository
Variables:       camelCase                    billAmount, customerName
Constants:       camelCase with k prefix      kOrange, kSpace16, kRadiusMd
Providers:       @riverpod + Notifier suffix  BillingNotifier, CustomerNotifier
Screens:         PascalCase + Screen          NewBillScreen, CustomerListScreen
Widgets:         PascalCase descriptive       BillItemRow, HeroCard, CreditBadge
Models:          PascalCase + Model           BillModel, CustomerModel, TemplateModel
Repositories:    PascalCase + Repository      BillingRepository, CustomerRepository
Routes:          lowercase + / prefix         /dashboard, /new-bill, /customers/:id
Enums:           PascalCase + descriptive     CreditStatus.healthy, BillStatus.sent
```

---

## FEATURE MAP — 3 ROLES

### Role 1: Shopkeeper (primary user)

```
Auth:          /login, /otp
Dashboard:     /dashboard  (home — bills today, credits, quick actions)
Billing:       /new-bill, /bill-preview, /bill-history, /bill/:id
Customers:     /customers, /customers/add, /customers/:id
Messaging:     /bulk-message, /template-select, /delivery-report
Credits:       /credits, /credits/topup
Settings:      /settings, /settings/cancel-request
```

### Role 2: Salesperson / Admin

```
Auth:          /salesperson/login
Dashboard:     /salesperson/dashboard
Shops:         /salesperson/shops, /salesperson/shops/add, /salesperson/shops/:id
Cancellations: /salesperson/cancellations
```

### Role 3: Super Admin

```
Auth:          /admin/login
Dashboard:     /admin/dashboard
Salespersons:  /admin/salespersons, /admin/salespersons/add
All Shops:     /admin/shops
Templates:     /admin/templates
Plans:         /admin/plans
Cancellations: /admin/cancellations
Revenue:       /admin/revenue
```

---

## API INTEGRATION RULES

### AiSensy (WhatsApp)

```
CRITICAL: NEVER call AiSensy API directly from Flutter.
ALL AiSensy calls go through Node.js backend proxy.
Reason: AiSensy API key must never be in the Flutter app (APK can be decompiled).

// In Flutter — call YOUR backend
POST /api/billing/send-bill        → Your Node.js → AiSensy
POST /api/messaging/send-bulk      → Your Node.js → AiSensy

// What Flutter sends to your backend:
{ shopId, customerId, billId, templateName, params }

// Never send AiSensy API key from Flutter. Ever.
```

### Razorpay

```
// Use razorpay_flutter package
// Subscriptions: create order on Node.js backend → open Razorpay in Flutter
// AutoPay mandate: created by Salesperson during shop onboarding
// Credit top-up: one-time payment via Razorpay
// Verify every payment on backend via Razorpay webhook signature — never trust Flutter-side only
```

### Supabase

```dart
// Init in main.dart
await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

// Access
final supabase = Supabase.instance.client;

// Auth tokens stored by supabase_flutter automatically (do not re-store in SharedPreferences)
// Additional tokens (AiSensy proxy auth, etc.) → flutter_secure_storage ONLY
```

---

## SECURITY RULES — NON-NEGOTIABLE

```
1. NO API keys in Flutter code. Use --dart-define at build time:
   flutter run --dart-define=SUPABASE_URL=xxx --dart-define=SUPABASE_KEY=xxx

2. NO auth tokens in SharedPreferences. Use flutter_secure_storage.

3. NO AiSensy calls from Flutter. Always proxy via Node.js backend.

4. NO Razorpay secret key in Flutter. Only razorpay_key_id (public key).

5. NO console prints of: phone numbers, bill amounts, API responses in production.
   Always wrap debug prints in: if (kDebugMode) { ... }

6. Supabase RLS (Row Level Security) must be enabled on ALL tables.
   Flutter never has direct table access without RLS policy.

7. Validate ALL user inputs before sending to API:
   - WhatsApp numbers: must be 10 digits, Indian format
   - GST numbers: must match regex ^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$
   - Bill amounts: must be positive numbers only
```

---

## CRITICAL DON'TS — AI MUST NEVER DO THESE

```
❌  NEVER use GetX for anything. Not for state, navigation, DI, or HTTP.
❌  NEVER put business logic inside widget build() methods.
❌  NEVER hardcode Color(0xFF...) values inside widgets. Use AppColors.
❌  NEVER hardcode padding/spacing values. Use AppSpacing constants.
❌  NEVER hardcode font sizes inline. Use AppTypography styles.
❌  NEVER hardcode strings inline in widgets. Use AppStrings.
❌  NEVER use SharedPreferences for auth tokens (use flutter_secure_storage).
❌  NEVER call AiSensy API directly from Flutter.
❌  NEVER add a package not already in pubspec.yaml without asking first.
❌  NEVER rewrite an entire file when fixing a bug — edit only what's needed.
❌  NEVER use setState() for app-wide or feature-level state — use Riverpod.
❌  NEVER ignore AsyncValue error states — always handle loading, data, error.
❌  NEVER use Navigator.push() — always use go_router context.go() or context.push().
❌  NEVER create a widget that is not in the feature's presentation/ or shared/widgets/.
❌  NEVER duplicate a widget that already exists in shared/widgets/.
❌  NEVER use print() in production code — use kDebugMode guard.
❌  NEVER generate code that skips null safety — all code must be null-safe Dart 3.x.
❌  NEVER use dynamic type — always specify proper types.
❌  NEVER use late keyword without a clear reason — prefer nullable + null check.
```

---

## CREDIT SYSTEM RULES (BUSINESS LOGIC)

```
// Two separate credit pools per shopkeeper:
billCredits:    for sending PDF bills via WhatsApp (utility messages)
msgCredits:     for bulk marketing messages

// Deduction rules:
1 bill sent     = 1 billCredit deducted
1 bulk message  = 1 msgCredit per recipient

// When credits run low:
< 20% remaining → show warning banner on dashboard (amber #F59E0B)
= 0             → block that action, show top-up screen

// Credit deduction must be ATOMIC:
Deduct credit in DB + trigger AiSensy send in same backend transaction.
If AiSensy send fails → rollback credit deduction. Never deduct on failure.

// Credit status display:
> 50% of plan limit:  kGreen  (#16A34A)
20-50%:               kWarning (#F59E0B)
< 20%:                kError  (#DC2626)
```

---

## SUBSCRIPTION PLAN RULES

```
Basic Plan:    ₹299/mo  → 100 bill credits + 300 msg credits + 500 customers max
Pro Plan:      ₹599/mo  → 300 bill credits + 800 msg credits + 2000 customers max
Business Plan: ₹999/mo  → Unlimited bills + 2000 msg credits + unlimited customers

Credits reset on billing date each month (no rollover).
AutoPay via Razorpay UPI mandate. Set up by Salesperson during onboarding.
Shopkeeper CANNOT cancel AutoPay themselves. Must submit cancellation request.
Cancel request → stored in Supabase → Super Admin reviews and processes.
```

---

## HOW TO USE THIS FILE WHEN PROMPTING AI

When asking AI to build anything, always start your prompt with:

```
"This is Building Project. Follow CLAUDE.md exactly.
[Then describe what you need]"
```

When asking for a new screen, always specify:
1. Exact file path: `lib/features/billing/presentation/new_bill_screen.dart`
2. Which role it's for: Shopkeeper / Salesperson / Super Admin
3. What data it needs: which provider/notifier to watch
4. Which shared widgets to use from `lib/shared/widgets/`
5. Which header type: Purple / Orange / Sky / Light
6. Whether it has a bottom sticky bar and what it contains

---

## KEY DOCUMENTS (AI MUST REFERENCE)

```
DESIGN.md      → All visual design decisions, color tokens, component specs
PRD.md         → Product requirements, subscription plans, business rules
SCREENS.md     → Every screen in all 3 roles (create this next)
API.md         → All API endpoints and payload shapes (create this next)
DATABASE.md    → Full Supabase schema and RLS rules (create this next)
FLOWS.md       → Step-by-step user flows for every critical journey
COMPONENTS.md  → All shared widgets and their props
```



## PROGRESS TRACKING

This project uses PROGRESS.md as the live development tracker.

RULES FOR AI:
1. READ PROGRESS.md at the start of every session
   → Know what is done (never rebuild ✅ items)
   → Know what is in progress (continue from ⏳ items)
   → Know what is blocked (ask before touching 🔴 items)

2. UPDATE PROGRESS.md after every meaningful code change:
   → Change ⬜ to ✅ when a file is complete + tested
   → Change ⬜ to ⏳ when a file is started but not done
   → Add a line to DAILY LOG with today's date + what changed
   → Update "CURRENTLY IN PROGRESS" and "NEXT UP" at top
   → Update STATS section (completed files count)

3. NEVER mark ✅ unless:
   → The file exists on disk
   → flutter analyze shows zero errors for that file
   → It has been tested (either on device or unit test)

4. If a bug is found while building, add it to BUGS & BLOCKERS LOG
   Format: [DATE] [HIGH/MED/LOW] [OPEN] Description of the bug
---

## PROJECT STATUS

```
✅ PRD v1.0           — Complete
✅ DESIGN.md v1.0     — Complete
✅ Dev Guide          — Complete
✅ CLAUDE.md v1.0     — This file
⏳ SCREENS.md         — Next
⏳ API.md             — Next
⏳ DATABASE.md        — Next
⏳ FLOWS.md           — Next
⏳ COMPONENTS.md      — Next
⏳ Flutter project    — Not started yet
```

---

*CLAUDE.md v1.0 — Billing Project — One Stop Solutions*
*Created: July 2026 | Author: Leeladhar*
*This file must be present in the project root before ANY code is written.*
