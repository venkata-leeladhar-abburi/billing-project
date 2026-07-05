# PROMPTS.md — Billing Project
# AI Prompt Library — Copy-Paste Ready
# Version 1.0 | One Stop Solutions | July 2026
#
# Every prompt you need to build this app with AI tools (Claude Code, Cursor).
# All prompts reference CLAUDE.md, DESIGN.md, SCREENS.md, COMPONENTS.md, API.md.
#
# HOW TO USE:
#   1. Open Claude Code or Cursor in your Flutter project folder
#   2. Ensure CLAUDE.md is in the project root (AI reads it automatically)
#   3. Copy the prompt below, fill in any [PLACEHOLDERS], paste and run
#   4. Review output before accepting — check against COMPONENTS.md + DESIGN.md
#
# GOLDEN RULE: One file at a time. Never ask AI to build an entire feature at once.

---

## PROMPT INDEX

```
SECTION 1  →  Project Setup Prompts (run once, in order)
SECTION 2  →  Core Architecture Prompts
SECTION 3  →  Shared Widget Prompts (lib/shared/widgets/)
SECTION 4  →  Shopkeeper Feature Prompts
SECTION 5  →  Salesperson Feature Prompts
SECTION 6  →  Super Admin Feature Prompts
SECTION 7  →  Integration Prompts (AiSensy, Razorpay, Supabase)
SECTION 8  →  Bug Fix Prompt Templates
SECTION 9  →  Code Review Prompts
SECTION 10 →  Testing Prompts
```

---

# SECTION 1 — PROJECT SETUP PROMPTS

Run these in order, one at a time, before building any features.

---

## P1-01 — Create Flutter Project

```
Create a new Flutter project for billing project with this exact setup:

Project name: billing_project
Organization: com.onestopsolutions
Description: WhatsApp Billing & Bulk Messaging SaaS for Indian Shopkeepers

After creating, set up pubspec.yaml with these dependencies:
  flutter_riverpod: ^3.3.0
  riverpod_annotation: ^3.3.0
  go_router: ^14.0.0
  dio: ^5.0.0
  supabase_flutter: ^2.0.0
  razorpay_flutter: ^1.3.5
  firebase_messaging: ^15.0.0
  firebase_core: ^3.0.0
  flutter_secure_storage: ^9.0.0
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  image_picker: ^1.1.0
  cached_network_image: ^3.3.0
  pdf: ^3.10.0
  intl: ^0.19.0

dev_dependencies:
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  flutter_lints: ^4.0.0

assets:
  - assets/images/
  - assets/fonts/

fonts:
  - family: Inter
    fonts: [...]
  - family: PlayfairDisplay
    fonts: [...]
  - family: DMMono
    fonts: [...]

Do NOT write any feature code yet. Just set up the project structure.
```

---

## P1-02 — Create Folder Structure

```
This is Billing Project — a Flutter SaaS app. Follow CLAUDE.md exactly.

Create the complete folder structure under lib/ with empty placeholder files:

lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart
│   │   └── app_strings.dart
│   ├── theme/app_theme.dart
│   ├── router/app_router.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   └── api_endpoints.dart
│   ├── storage/secure_storage.dart
│   ├── error/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   └── utils/
│       ├── validators.dart
│       ├── formatters.dart
│       └── extensions.dart
├── shared/
│   ├── widgets/ (25 files — one per widget in COMPONENTS.md)
│   └── providers/auth_provider.dart
└── features/
    ├── auth/
    ├── dashboard/
    ├── billing/
    ├── customers/
    ├── messaging/
    ├── credits/
    ├── settings/
    └── salesperson/

Each feature folder has: data/ domain/ presentation/
Each file should export an empty class or stub function.
The app must compile with no errors after this step.
```

---

## P1-03 — Create AppColors
 
```
This is Billing Project. Follow CLAUDE.md and DESIGN.md exactly.

Create lib/core/constants/app_colors.dart with ALL color tokens from DESIGN.md Section 2.

Required constants:
  kOrange      = Color(0xFFE8680A)   // primary CTA
  kOrangeDark  = Color(0xFFC8560A)   // pressed state
  kOrangeLight = Color(0xFFFFF3E8)   // orange tint bg
  kPurple      = Color(0xFF6B4EFF)   // home header gradient
  kPurpleLight = Color(0xFF8B6FFF)   // header gradient mid
  kGreen       = Color(0xFF16A34A)   // success/sent/free
  kGreenLight  = Color(0xFFF0FDF4)   // green tint bg
  kBlue        = Color(0xFF2563EB)   // info/links/codes
  kBlueLight   = Color(0xFFEFF6FF)   // blue tint bg
  kDark        = Color(0xFF1A1A1A)   // primary text
  kSecondary   = Color(0xFF555555)   // secondary text
  kMuted       = Color(0xFF999999)   // placeholder/timestamp
  kBorderGray  = Color(0xFFE5E5E5)   // card/input borders
  kDivider     = Color(0xFFF0F0F0)   // section dividers
  kBgPage      = Color(0xFFF5F5F5)   // page background (NOT white)
  kBgCard      = Color(0xFFFFFFFF)   // card background
  kError       = Color(0xFFDC2626)   // error states only
  kWarning     = Color(0xFFF59E0B)   // credit low/warning
  kNavy        = Color(0xFF1A1A2E)   // super admin header
  kNavyCard    = Color(0xFF242440)   // navy card surface

Also add gradient constants:
  kGradientPurple — for home header
  kGradientOrange — for detail/flow headers
  kGradientSky    — for search/form headers
  kGradientNavy   — for super admin headers

Also add shadow constants:
  kShadowCard  — BoxShadow(color: 0x0F000000, blur 4, offset 0,1)
  kShadowModal — BoxShadow(color: 0x1A000000, blur 12, offset 0,-2)
  kShadowFloat — BoxShadow(color: 0x29000000, blur 16, offset 0,4)

RULE: Every color in this app comes from AppColors. No inline Color() values in widgets.
```

---

## P1-04 — Create AppTypography

```
This is Billing Project. Follow CLAUDE.md and DESIGN.md Section 3.

Create lib/core/constants/app_typography.dart with ALL text styles.

Font families:
  kFontSans  = 'Inter'           (all UI text)
  kFontSerif = 'PlayfairDisplay' (hero headings only)
  kFontMono  = 'DMMono'          (bill numbers, amounts)

Required TextStyle constants:
  displaySerif  — PlayfairDisplay 32px 700
  h1Serif       — PlayfairDisplay 26px 700
  h2            — Inter 20px 700, color kDark
  h3            — Inter 17px 600, color kDark
  bodyLarge     — Inter 15px 400, color kSecondary
  body          — Inter 14px 400, color kSecondary
  bodySmall     — Inter 13px 400, color kSecondary
  labelSmall    — Inter 11px 500, letterSpacing 0.8, uppercase, color kMuted
  caption       — Inter 11px 400, color kMuted
  priceLarge    — Inter 28px 700, letterSpacing -0.5, color kDark
  price         — Inter 18px 700, color kDark
  timeDisplay   — Inter 22px 700, letterSpacing -0.3, color kDark
  buttonLabel   — Inter 15px 600, color white
  buttonSubLabel — Inter 11px 400, color white 80%
  monoAmount    — DMMono 16px 500, color kDark
  navLabel      — Inter 11px 500, color kMuted (inactive tab)

RULES from DESIGN.md:
  - Serif ONLY for: onboarding hero headlines, dashboard total amount label,
    section intro text. NEVER for prices, buttons, form labels, navigation.
  - Prices always Inter bold, never serif.
  - Strikethrough prices: color kMuted, one size smaller than main price.
```

---

## P1-05 — Create AppSpacing

```
This is billing project. Follow CLAUDE.md and DESIGN.md Section 4.

Create lib/core/constants/app_spacing.dart:

  s2  = 2.0
  s4  = 4.0
  s6  = 6.0
  s8  = 8.0     ← base unit
  s12 = 12.0
  s16 = 16.0    ← standard page horizontal padding
  s20 = 20.0
  s24 = 24.0    ← between sections
  s32 = 32.0
  s48 = 48.0    ← bottom safe area above sticky bar

Also add BorderRadius constants:
  rXs   = BorderRadius.circular(4)
  rSm   = BorderRadius.circular(8)
  rMd   = BorderRadius.circular(12)
  rLg   = BorderRadius.circular(16)
  rXl   = BorderRadius.circular(20)
  rPill = BorderRadius.circular(100)
  rFull = BorderRadius.circular(9999)

Standard page padding:
  kPagePadding = EdgeInsets.symmetric(horizontal: 16)
  kCardPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12)
```

---

## P1-06 — Create AppTheme

```
This is billing project. Follow CLAUDE.md and DESIGN.md.

Create lib/core/theme/app_theme.dart using AppColors and AppTypography.

Requirements:
  - Light mode ONLY (no dark mode — per CLAUDE.md)
  - primaryColor: AppColors.kOrange
  - scaffoldBackgroundColor: AppColors.kBgPage (#F5F5F5)
  - appBarTheme: transparent background, no elevation, dark icons
  - elevatedButtonTheme: orange pill (matches PrimaryButton widget)
  - inputDecorationTheme: matches InputField widget spec from COMPONENTS.md
  - cardTheme: white bg, radius 12, kShadowCard
  - fontFamily: 'Inter' as default
  - textTheme: mapped from AppTypography constants
  - colorScheme: use ColorScheme.light() with kOrange as primary

The theme is applied once in MaterialApp in main.dart.
Individual widgets use AppColors/AppTypography directly — not Theme.of(context).
```

---

## P1-07 — Create go_router Setup

```
This is billing project. Follow CLAUDE.md routes specification.

Create lib/core/router/app_router.dart with go_router.

All routes (from CLAUDE.md Feature Map):

SHOPKEEPER routes:
  /login, /otp, /dashboard, /new-bill, /bill-preview,
  /bill-sent, /bill-history, /bill/:id, /customers,
  /customers/add, /customers/:id, /bulk-message,
  /template-select, /bulk-message-preview, /delivery-report,
  /credits, /credits/topup, /credits/topup-success,
  /notifications, /settings, /settings/cancel-request,
  /settings/cancel-confirm

SALESPERSON routes (prefix /salesperson):
  /salesperson/login, /salesperson/dashboard, /salesperson/shops,
  /salesperson/shops/add/details, /salesperson/shops/add/branding,
  /salesperson/shops/add/plan, /salesperson/shops/add/autopay,
  /salesperson/shops/add/success, /salesperson/shops/:shopId,
  /salesperson/shops/:shopId/edit, /salesperson/cancellations,
  /salesperson/cancellations/:requestId, /salesperson/settings

SUPER ADMIN routes (prefix /admin):
  /admin/login, /admin/dashboard, /admin/salespersons,
  /admin/salespersons/add, /admin/salespersons/:id,
  /admin/shops, /admin/shops/:shopId, /admin/templates,
  /admin/templates/add, /admin/templates/:id, /admin/plans,
  /admin/cancellations, /admin/cancellations/:requestId,
  /admin/revenue, /admin/platform-settings, /admin/settings

Router setup requirements:
  - Use GoRouter with ShellRoute for bottom tab bar
  - Role-based redirect: check user_metadata.role on session start
    shopkeeper → /dashboard
    salesperson → /salesperson/dashboard
    super_admin → /admin/dashboard
    unauthenticated → /login
  - NEVER use Navigator.push() anywhere in the app — only context.go() / context.push()
  - All placeholder screens return Scaffold with centered Text(routeName)
```

---

## P1-08 — Create Dio Client + API Endpoints

```
This is billing project. Follow CLAUDE.md Section "API Integration Rules".

Create lib/core/network/dio_client.dart:
  - Single Dio instance (singleton via Riverpod provider)
  - baseUrl: from --dart-define BACKEND_URL (use Env class)
  - connectTimeout: 10 seconds
  - receiveTimeout: 30 seconds
  - AuthInterceptor: attaches Supabase access_token as Bearer automatically
    Gets token from: Supabase.instance.client.auth.currentSession?.accessToken
    Also attaches X-Shop-Id header from secure storage if shopkeeper role
  - ErrorInterceptor: converts DioException to Failure objects (from failures.dart)
    401 → AuthFailure (trigger logout)
    Network timeout → NetworkFailure
    500 → ServerFailure
    other → UnknownFailure

Create lib/core/network/api_endpoints.dart:
  All API paths as string constants — no inline URL strings in repositories.
  Examples:
    static const shopsMe = '/shops/me';
    static const customers = '/customers';
    static const bills = '/bills';
    static const campaigns = '/campaigns';
    static const creditsTopupInitiate = '/credits/topup/initiate';
    static const creditsTopupVerify = '/credits/topup/verify';
    (add all endpoints from API.md)

Create lib/core/error/failures.dart:
  Sealed class Failure with:
    NetworkFailure, ServerFailure, AuthFailure, NotFoundFailure,
    InsufficientCreditsFailure, ValidationFailure, UnknownFailure
  Each carries: code (String), message (String)

SECURITY RULES:
  - API keys NEVER stored in Flutter — only baseUrl from --dart-define
  - Auth token read from Supabase SDK, never from SharedPreferences
```

---

## P1-09 — Create Validators + Formatters

```
This is billing project.

Create lib/core/utils/validators.dart with these validators:

  String? validatePhone(String? value)
    → null if valid (10 digits, Indian mobile)
    → "Enter a valid 10-digit mobile number" if invalid

  String? validateGst(String? value)
    → null if null/empty (GST is optional)
    → null if matches ^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$
    → "Invalid GST number format" if doesn't match

  String? validateRequired(String? value, String fieldName)
    → null if not empty
    → "{fieldName} is required" if empty

  String? validateAmount(String? value)
    → null if valid positive number
    → "Must be greater than 0" if invalid

  String? validatePassword(String? value)
    → null if meets: min 8 chars, 1 uppercase, 1 number
    → specific message for each failure

  String? validateUpi(String? value)
    → null if matches pattern xxxxx@bankname
    → "Enter a valid UPI ID (e.g. name@upi)" if invalid

Create lib/core/utils/formatters.dart:

  String formatINR(double amount)
    → "₹1,23,456.50" (Indian number format with commas)

  String formatINRCompact(double amount)
    → "₹1.2L", "₹45K", "₹999" based on size

  String formatRelativeTime(DateTime dateTime)
    → "2 min ago", "1 hr ago", "Yesterday", "01 Jul 2026"

  String formatDate(DateTime dateTime)
    → "01 Jul 2026"

  String formatDateTime(DateTime dateTime)
    → "01 Jul 2026 · 10:30 AM"

  String maskPhone(String phone)
    → "+91 XXXXX 43210" (mask first 5 digits)

  String maskUpi(String upiId)
    → "xxxxxxxx@upi" (mask everything before @)
```

---

## P1-10 — Create main.dart + App Entry

```
This is billing project. Follow CLAUDE.md exactly.

Create lib/main.dart:

1. Load environment variables from --dart-define:
   class Env {
     static const backendUrl = String.fromEnvironment('BACKEND_URL', defaultValue: 'http://localhost:3000/v1');
     static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
     static const supabaseAnonKey = String.fromEnvironment('SUPABASE_KEY');
   }

2. Initialize in main():
   - WidgetsFlutterBinding.ensureInitialized()
   - await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey)
   - await Firebase.initializeApp()
   - runApp(const ProviderScope(child: BuildingProjectApp()))

3. BuildingProjectApp widget:
   - ConsumerWidget
   - MaterialApp.router with:
       theme: AppTheme.lightTheme
       routerConfig: appRouter (from app_router.dart)
       debugShowCheckedModeBanner: false
       title: 'billing project'

RULES:
  - ProviderScope wraps the entire app (required for Riverpod)
  - No Navigator key — go_router handles all navigation
  - No setState() in main.dart
```

---

# SECTION 2 — CORE ARCHITECTURE PROMPTS

---

## P2-01 — Auth Notifier (Shopkeeper)

```
This is billing project. Follow CLAUDE.md exactly.

Create lib/features/auth/domain/auth_notifier.dart

Use @riverpod annotation (Riverpod 3.x code generation).
State type: AsyncValue<AuthState>

AuthState model:
  user: User? (Supabase user)
  role: String? ('shopkeeper' | 'salesperson' | 'super_admin')
  shopId: String?
  isAuthenticated: bool

Methods to implement:
  Future<void> requestOtp(String phone)
    → calls supabase.auth.signInWithOtp(phone: '+91{phone}')
    → state = AsyncValue.loading() while waiting
    → state = AsyncValue.error() on failure

  Future<void> verifyOtp(String phone, String token)
    → calls supabase.auth.verifyOTP(phone, token, type: OtpType.sms)
    → on success: reads user_metadata.role, shopId
    → saves shopId to SecureStorage (key: 'shop_id')
    → state = AsyncValue.data(AuthState(user, role, shopId))
    → on failure: state = AsyncValue.error()

  Future<void> logout()
    → supabase.auth.signOut()
    → SecureStorage.delete('shop_id')
    → state = AsyncValue.data(AuthState.empty())

  String? getRoleFromSession()
    → reads from supabase.auth.currentUser?.userMetadata?['role']

Also create lib/features/auth/data/auth_repository.dart:
  Wraps Supabase auth calls
  Returns Either<Failure, AuthResult>

Also create lib/features/auth/data/models/user_model.dart:
  shopId, role, phone, shopName (from user_metadata)
  fromJson, toJson

RULES:
  - Use @riverpod annotation — not StateNotifierProvider
  - Every async method wraps state in AsyncValue.guard()
  - Never store auth tokens manually — supabase_flutter handles this
```

---

## P2-02 — Supabase Realtime Provider (Credits)

```
This is billing project. Follow CLAUDE.md.

Create lib/features/credits/domain/credits_notifier.dart

Use @riverpod annotation.
State type: AsyncValue<CreditState>

CreditState:
  billCredits: int
  billCreditsLimit: int
  msgCredits: int
  msgCreditsLimit: int
  billingCycleEnd: DateTime

The notifier should subscribe to Supabase REAL-TIME on the shop_credits table.
When shop_credits row changes → update state immediately.
This is how the credit badge on the dashboard updates live.

Implementation:
  @override
  AsyncValue<CreditState> build() {
    // Get shopId from SecureStorage
    // Subscribe to Supabase realtime on shop_credits WHERE shop_id = shopId
    // Return initial data from Supabase query
    // Cancel subscription in ref.onDispose()
  }

Also add:
  bool get isBillCreditLow → billCredits / billCreditsLimit < 0.2
  bool get isMsgCreditLow  → msgCredits / msgCreditsLimit < 0.2
  bool get hasBillCredits  → billCredits > 0
  bool get hasMsgCredits   → msgCredits > 0
  Color get billCreditColor → kGreen / kWarning / kError based on level
  Color get msgCreditColor  → same logic

RULES:
  - Cancel Supabase subscription on ref.onDispose()
  - Use select() when watching specific credit fields in widgets (avoid rebuilds)
```

---

# SECTION 3 — SHARED WIDGET PROMPTS

Build these before any feature screens. Build in this order: C-05 AppCard first, then buttons, then others.

---

## P3-01 — AppCard Widget

```
This is billing project. Follow CLAUDE.md and COMPONENTS.md C-05.

Create lib/shared/widgets/app_card.dart

Requirements from COMPONENTS.md C-05:
  Props:
    child: Widget (required)
    padding: EdgeInsets? (default EdgeInsets.all(16))
    backgroundColor: Color? (default AppColors.kBgCard)
    borderRadius: double? (default 12.0)
    borderColor: Color? (default AppColors.kBorderGray)
    borderWidth: double? (default 1.0)
    onTap: VoidCallback? (if set → InkWell wraps)
    shadow: BoxShadow? (default kShadowCard from AppColors)
    leftBorderColor: Color? (for info/warning cards)
    leftBorderWidth: double? (default 4.0 when leftBorderColor set)
    margin: EdgeInsets?

  Visual variants (all from COMPONENTS.md):
    Standard, Tappable (InkWell + orange splash), Info (blue left border),
    Warning (amber left border), Error (red left border), Success (green left border)

  IMPORTANT: When tappable, use Material + InkWell NOT GestureDetector
  IMPORTANT: Use ClipRRect on inner content to respect border radius

DO NOT use:
  - Card widget from Flutter (use Container directly)
  - BoxDecoration without the border defined as Border() not BorderSide
  - Hardcoded colors — always AppColors.kBorderGray etc.

After creating, run: flutter analyze lib/shared/widgets/app_card.dart
Fix any lint errors before proceeding.
```

---

## P3-02 — PrimaryButton Widget

```
This is billing project. Follow CLAUDE.md and COMPONENTS.md C-01.

Create lib/shared/widgets/primary_button.dart

Exact spec from COMPONENTS.md C-01:
  Props: label, onTap, isLoading, isFullWidth, width, leadingIcon, trailingIcon, subLabel
  States: enabled, disabled (null onTap), loading (spinner), pressed (0.98 scale)

Critical implementation details:
  - Use ElevatedButton NOT TextButton or InkWell
  - SizedBox(width: double.infinity, height: 52) wraps button
  - StadiumBorder for pill shape (border-radius 100)
  - elevation: 0 always
  - bg: kOrange when enabled, #CCCCCC when disabled
  - CircularProgressIndicator when isLoading: white, size 20, strokeWidth 2
  - subLabel shown below main label in buttonSubLabel style

Test it renders correctly by using it in a simple test screen.
Run: flutter analyze lib/shared/widgets/primary_button.dart
```

---

## P3-03 — Build Remaining Shared Widgets

```
This is billing project. Follow CLAUDE.md and COMPONENTS.md.

Build these widgets one at a time (run analyze after each):

  1. lib/shared/widgets/secondary_button.dart     → COMPONENTS.md C-02
  2. lib/shared/widgets/dark_pill_button.dart     → COMPONENTS.md C-03
  3. lib/shared/widgets/small_action_button.dart  → COMPONENTS.md C-04
  4. lib/shared/widgets/gradient_header.dart      → COMPONENTS.md C-06
  5. lib/shared/widgets/filter_chip_row.dart      → COMPONENTS.md C-07
  6. lib/shared/widgets/filter_chip.dart          → COMPONENTS.md C-08
  7. lib/shared/widgets/bottom_action_bar.dart    → COMPONENTS.md C-09
  8. lib/shared/widgets/bottom_tab_bar.dart       → COMPONENTS.md C-10
  9. lib/shared/widgets/empty_state.dart          → COMPONENTS.md C-11
  10. lib/shared/widgets/loading_overlay.dart     → COMPONENTS.md C-12
  11. lib/shared/widgets/success_toast.dart       → COMPONENTS.md C-13
  12. lib/shared/widgets/section_header.dart      → COMPONENTS.md C-14
  13. lib/shared/widgets/icon_container.dart      → COMPONENTS.md C-15
  14. lib/shared/widgets/credit_badge.dart        → COMPONENTS.md C-16
  15. lib/shared/widgets/status_badge.dart        → COMPONENTS.md C-17
  16. lib/shared/widgets/plan_badge.dart          → COMPONENTS.md C-18
  17. lib/shared/widgets/bill_card.dart           → COMPONENTS.md C-19
  18. lib/shared/widgets/customer_card.dart       → COMPONENTS.md C-20
  19. lib/shared/widgets/shop_card.dart           → COMPONENTS.md C-21
  20. lib/shared/widgets/input_field.dart         → COMPONENTS.md C-22
  21. lib/shared/widgets/step_progress_bar.dart   → COMPONENTS.md C-23
  22. lib/shared/widgets/confirm_bottom_sheet.dart → COMPONENTS.md C-24
  23. lib/shared/widgets/info_banner.dart         → COMPONENTS.md C-25

For each widget:
  - Read the spec from COMPONENTS.md before writing any code
  - All colors from AppColors, all spacing from AppSpacing, all text from AppTypography
  - Run flutter analyze after each file — fix all warnings
  - No hardcoded values anywhere
```

---

# SECTION 4 — SHOPKEEPER FEATURE PROMPTS

Build features in this order. Each depends on the previous.

---

## P4-01 — Login Screen (S1-01)

```
This is billing project. Follow CLAUDE.md, SCREENS-1.md S1-01, and DESIGN.md.

Create lib/features/auth/presentation/login_screen.dart

Screen spec from SCREENS-1.md S1-01:
  Route: /login
  Header: Sky blue gradient (GradientHeader widget, type: sky)
  Provider: authNotifierProvider

UI sections (top → bottom):
  1. GradientHeader (sky) with app logo centered + tagline
  2. White form AppCard (overlaps header -20px margin-top)
     - Title: "Log in to your shop" (AppTypography.h3)
     - Subtitle: "Enter your WhatsApp number" (AppTypography.bodySmall)
     - Row: "+91 fixed prefix" + InputField (phone, 10 digits)
     - PrimaryButton "Continue" (disabled when < 10 digits)
  3. "Other login options" divider row (Inter 12px, kMuted)
  4. Google login button (white card, border kBorderGray, radius 100px)
  5. Footer: T&C + Privacy Policy links (orange underline)

State handling:
  - authNotifierProvider.when(
      data: (state) → if state.isAuthenticated navigate based on role
      loading: → spinner in Continue button
      error: → inline error below phone field (red, 12px)
    )

On Continue tap:
  ref.read(authNotifierProvider.notifier).requestOtp(phoneController.text)
  On success: context.go('/otp')
  On 'User not found': show "Contact your salesperson to set up your account"
  On rate limit: show countdown timer

RULES:
  - Use ConsumerStatefulWidget (needs TextEditingController)
  - Dispose controller in dispose()
  - Use GradientHeader widget from shared/widgets
  - Use AppCard for form container
  - Use PrimaryButton for CTA
  - NEVER use Navigator.push — use context.go()
```

---

## P4-02 — OTP Screen (S1-02)

```
This is billing project. Follow CLAUDE.md and SCREENS-1.md S1-02.

Create lib/features/auth/presentation/otp_screen.dart

Route: /otp
Provider: authNotifierProvider

UI:
  - Plain white top bar, back arrow (context.pop())
  - Heading: "Enter OTP" (AppTypography.h2, 48px top spacing)
  - Subtext: "Sent to +91 XXXXX {last5}" (masked phone from route params)
  - 6-box OTP input row:
      Each box: 48×56px, bg white, border 1px kBorderGray, radius 10
      Active box: border 2px kOrange
      Filled box: bg kOrangeLight, border kOrange
      Auto-focus first box, auto-advance on digit entry
      Auto-submit when 6th digit entered
  - Resend row: "Didn't receive it?" + "Resend OTP" link
      Countdown timer (45 seconds) — link disabled during countdown
  - PrimaryButton "Verify & Login" (disabled until all 6 digits filled)
    (shown as fallback — auto-submit handles most cases)

On verify:
  ref.read(authNotifierProvider.notifier).verifyOtp(phone, otpCode)
  Success → navigate based on role (router handles redirect)
  Error → clear boxes + shake animation + "Incorrect OTP" message in red

On resend:
  ref.read(authNotifierProvider.notifier).requestOtp(phone)
  Reset timer to 45s

Pass phone number via go_router extra parameter from login screen.
Use ConsumerStatefulWidget for OTP box focus management + countdown timer.
```

---

## P4-03 — Dashboard Screen (S1-03)

```
This is billing project. Follow CLAUDE.md, SCREENS-1.md S1-03, and DESIGN.md.

Create lib/features/dashboard/presentation/dashboard_screen.dart
Create lib/features/dashboard/domain/dashboard_notifier.dart
Create lib/features/dashboard/data/dashboard_repository.dart

NOTIFIER: dashboardNotifierProvider
State: AsyncValue<DashboardState>
DashboardState: { shop: ShopModel, todayRevenue: double, todayBillCount: int }

REPOSITORY: GET /shops/me → returns ShopModel
Also watch: creditsNotifierProvider (real-time Supabase stream)
Also watch: recent bills (last 5): GET /bills?filter=today&limit=5

SCREEN LAYOUT (from SCREENS-1.md S1-03):
  1. GradientHeader (purple, type: GradientHeaderType.purple)
     Left: hamburger icon (placeholder for now)
     Right: CreditBadge widget

  2. HeroCard (white AppCard overlapping header -20px, margin 12px)
     - "TODAY'S REVENUE" LABEL style
     - Total amount in Playfair Display 32px bold (kDark)
     - Divider
     - Stats row: "Bills Today" count | "Bill Credits" remaining
     - Bill credits colored by CreditBadge.creditColor logic

  3. Credit low InfoBanner (amber, conditional — show when isBillCreditLow)
     "Only {n} bill credits left."
     Action: "Buy Credits →" → context.go('/credits/topup')

  4. Quick actions 2×2 grid (12px padding, 8px gap):
       Card 1: "New Bill" — bg kOrange, icon receipt, → /new-bill
       Card 2: "Bulk Message" — bg kNavyCard, icon speakerphone, → /bulk-message
       Card 3: "Customers" — bg kNavyCard, icon people, → /customers
       Card 4: "Bill History" — bg kNavyCard, icon list, → /bill-history

  5. Recent Bills section:
       SectionHeader("Recent Bills", actionLabel: "View All", onAction: → /bill-history)
       5× BillCard widget from shared/widgets
       EmptyState(type: bills) when no bills today

  6. BottomTabBar (4 tabs: Home, New Bill, Customers, Settings)

All colors from AppColors. All text styles from AppTypography.
Use ref.watch() for all providers. Use .when() for AsyncValue states.
Loading: LoadingOverlay widget.
Error: Center text with retry button.
```

---

## P4-04 — New Bill Screen (S1-04)

```
This is billing project. Follow CLAUDE.md, SCREENS-1.md S1-04, FLOWS.md F1-02.

Create lib/features/billing/presentation/new_bill_screen.dart
Create lib/features/billing/domain/new_bill_notifier.dart
Create lib/features/billing/data/models/bill_model.dart
Create lib/features/billing/data/models/bill_item_model.dart

BILL ITEM MODEL:
  id: String (local UUID)
  name: String
  quantity: double
  ratePerUnit: double
  amount: double (computed: qty × rate)

NEW BILL STATE:
  selectedCustomer: CustomerModel?
  items: List<BillItemModel>
  notes: String
  subtotal: double (computed)
  gstRate: double (from shop settings, default 5.0)
  gstAmount: double (computed)
  total: double (computed)
  isSending: bool
  sendError: String?

NOTIFIER METHODS:
  setCustomer(CustomerModel customer)
  addItem() → appends empty BillItemModel
  updateItem(int index, BillItemModel item) → recalculates totals
  removeItem(int index)
  setNotes(String notes)
  void calculateTotals() → updates subtotal, gstAmount, total
  Future<void> sendBill() → POST /bills → returns billId

SCREEN LAYOUT (from SCREENS-1.md S1-04):
  1. Plain white top bar: back arrow + "New Bill" title
  2. Page bg: AppColors.kBgPage (#F5F5F5)
  3. Customer section (AppCard):
     - Search InputField (search icon prefix)
     - Dropdown results (filtered customers)
     - "Add {name} as new customer" last row (orange text)
     - Selected customer chip (orange outlined pill + × to clear)
  4. Bill items section (AppCard):
     - Column headers: Item | Qty | Rate | Amount (proportional widths)
     - Dynamic item rows (TextFormField per cell)
     - Amount column: auto-calculated, read-only, bold
     - "+ Add item" row (orange text + icon)
  5. Totals section (AppCard): Subtotal, GST (5%), divider, Total
  6. Notes section (AppCard, optional): multi-line InputField
  7. Spacer (80px for sticky bar)

BOTTOM STICKY BAR (BottomActionBar):
  Left: "1 credit will be used" (kMuted 12px)
        "{billCredits} remaining" (color by CreditBadge logic)
  Right: PrimaryButton "Preview Bill →"
         Disabled when: !hasCustomer || items.isEmpty || anyItemInvalid

On "Preview Bill →":
  Validate form → if valid: context.push('/bill-preview', extra: billState)

On back (with items entered):
  Show ConfirmBottomSheet "Discard this bill?" before navigating away
```

---

## P4-05 — Bill Preview Screen (S1-05)

```
This is billing project. Follow CLAUDE.md and SCREENS-1.md S1-05.

Create lib/features/billing/presentation/bill_preview_screen.dart

Receives bill state via go_router extra parameter.

SCREEN LAYOUT:
  1. GradientHeader(orange): back arrow + "Bill Preview" + share icon
  2. Mini summary bar (rgba bg in header): shopName · customerName · ₹total
  3. White body (border-radius 20px top, margin-top overlap)
  4. Tab row (3 tabs): "Bill" | "Shop Info" | "Notes"
     DarkPillButton for selected, transparent for unselected

  BILL TAB content:
    Bill header (bg kNavy #1A1A2E, padding 14px 16px):
      - Shop logo circle (40px, initials if no logo)
      - Shop name (Inter 13px bold, white) + GST (10px, rgba(255,255,255,0.4))
    Bill meta row: Bill number + date
    "BILLED TO" label + customer name + phone
    Divider
    Items table: Item | Qty | Rate | Amount columns
    Totals: Subtotal, CGST (2.5%), SGST (2.5%), Grand Total (kOrange)
    Footer (bg #F8F8F8): "Thank you..." + shop phone

  SHOP INFO TAB: shop address, GST, WhatsApp number
  NOTES TAB: notes text or "No notes added" empty state

BOTTOM STICKY BAR:
  Left: "₹{total}" (priceLarge) + customerName (muted)
  Right: PrimaryButton "Send on WhatsApp" (WhatsApp icon leading)
         isLoading: state.isSending

On "Send on WhatsApp":
  ref.read(newBillNotifierProvider.notifier).sendBill()
  On success: context.go('/bill-sent')
  On INSUFFICIENT_CREDITS: SnackBar + show top-up option
  On BILL_SEND_FAILED: SnackBar "WhatsApp send failed. Credit not deducted."
```

---

## P4-06 — Bill Sent Success Screen (S1-06)

```
This is billing project. Follow CLAUDE.md and SCREENS-1.md S1-06.

Create lib/features/billing/presentation/bill_sent_screen.dart

Full white screen, center aligned content:
  1. Animated green checkmark circle (AnimatedScale + FadeIn on mount)
     - Circle: bg kGreenLight, icon kGreen, size 100px
     - "Bill Sent!" (AppTypography.h1Serif — Playfair Display)
     - Sub: "Your customer will receive it on WhatsApp shortly." (bodyLarge, center)

  2. Bill summary AppCard (margin 32px horizontal):
     - Customer name ← → ₹total (kOrange)
     - Bill number ← → "Sent at {time}"
     - "1 bill credit used" (caption, center, kMuted)

  3. Credits remaining pill (centered):
     - "{n} bill credits remaining"
     - bg: kGreenLight, border kGreen, radius 100px, Inter 12px kGreen
     - Changes to amber/red if low

  4. Buttons (padding 16px horizontal, stacked 8px gap):
     - PrimaryButton "Send Another Bill" → NewBillNotifier.reset() → /new-bill
     - SecondaryButton "View Bill History" → /bill-history
     - Text link "Back to Dashboard" (center, kOrange, 13px) → /dashboard

Hardware back → /dashboard (NOT back to preview — bill already sent)
Use PopScope(canPop: false, onPopInvoked: (didPop) => context.go('/dashboard'))
```

---

## P4-07 — Customer List + Add Customer Screens (S1-09, S1-10)

```
This is billing project. Follow CLAUDE.md, SCREENS-1.md S1-09 and S1-10.

Create:
  lib/features/customers/presentation/customer_list_screen.dart
  lib/features/customers/presentation/add_customer_screen.dart
  lib/features/customers/domain/customer_notifier.dart
  lib/features/customers/data/customer_repository.dart
  lib/features/customers/data/models/customer_model.dart

CUSTOMER MODEL: customerId, name, phone, businessType, totalBillsCount,
                totalBilledAmount, lastBillDate, notes, addedAt

CUSTOMER NOTIFIER (customerNotifierProvider):
  State: AsyncValue<CustomerListState>
  CustomerListState: { customers: List<CustomerModel>, filter: String, searchQuery: String, total: int }
  Methods:
    Future<void> loadCustomers()    → GET /customers
    void setFilter(String filter)   → triggers reload
    void setSearch(String query)    → filters locally for fast UX, calls API debounced
    Future<CustomerModel> addCustomer(AddCustomerRequest req) → POST /customers

CUSTOMER LIST SCREEN (S1-09):
  - Plain white top bar: back + "Customers" + search icon + add icon (+)
  - Stats strip (bg kBgPage): "{n} customers"
  - Always-visible search bar (InputField with search prefix icon)
  - FilterChipRow: [All] [Billed Recently] [High Value] [New]
  - ListView.separated with CustomerCard widgets (8px separator)
  - EmptyState(type: customers) when empty
  - FAB (kOrange, + icon) → /customers/add

ADD CUSTOMER SCREEN (S1-10):
  - Top bar: "Cancel" text button + "Add Customer" title
  - Single AppCard with form fields:
      Customer Name* (InputField)
      WhatsApp Number* (InputField, +91 prefix, phone keyboard)
      Business Type (Dropdown — 7 types + Other)
      Notes (optional, multi-line InputField, max 2 lines)
  - PrimaryButton "Save Customer" (full width, disabled when name/phone empty)
  - On save: customerNotifier.addCustomer() → SuccessToast "Customer added" → pop back
  - On PHONE_DUPLICATE: amber warning (not block): "This number already exists: {name}. Add anyway?"
```

---

## P4-08 — Bulk Message Flow (S1-12, S1-13, S1-14, S1-15)

```
This is billing project. Follow CLAUDE.md, SCREENS-1.md S1-12 to S1-15, FLOWS.md F1-05.

Create:
  lib/features/messaging/presentation/bulk_message_screen.dart
  lib/features/messaging/presentation/template_select_screen.dart
  lib/features/messaging/presentation/bulk_message_preview_screen.dart
  lib/features/messaging/presentation/delivery_report_screen.dart
  lib/features/messaging/domain/bulk_message_notifier.dart
  lib/features/messaging/data/messaging_repository.dart
  lib/features/messaging/data/models/template_model.dart
  lib/features/messaging/data/models/campaign_model.dart

BULK MESSAGE NOTIFIER:
  State: { recipientMode, selectedCustomers, selectedTemplate, msgCreditsNeeded, isSending, campaignId }
  Methods: setRecipientMode(), toggleCustomer(), selectTemplate(),
           Future<void> send() → POST /campaigns → sets campaignId on success

BULK MESSAGE SCREEN (S1-12):
  - GradientHeader(purple): "Bulk Message" + credits count in subtitle
  - Recipient section (AppCard): DarkPillButton toggle [All Customers] [Select Manually]
    All mode: "{n} customers will receive this"
    Manual mode: searchable checklist with checkboxes
  - Credit usage preview (AppCard, amber left border if low)
  - Template section (AppCard, tappable → /template-select):
    "Choose Template" label + selected template name OR "Not selected yet"
    Selected preview text (2 lines, truncated)
  - BottomActionBar: "To {n} customers" + "Send Messages" CTA
    Disabled if: no template || no recipients || insufficient credits

TEMPLATE SELECT SCREEN (S1-13):
  - Top bar: "Cancel" + "Choose Template"
  - Business type label: "Templates for: {businessType}"
  - List of TemplateCards (AppCard tappable):
      Business type pill (orange) + template name + preview text (2 lines) + variables caption
      Selected: border 1.5px kOrange + orange checkmark badge top-right
  - PrimaryButton "Confirm Selection" (sticky bottom)
  - Returns selected template via Navigator.pop result (go_router pop with result)

DELIVERY REPORT SCREEN (S1-15):
  - Subscribes to Supabase realtime on campaigns table (campaign.id)
  - Shows live delivery stats: delivered / failed / pending
  - Circle arc indicator showing delivery percentage
  - Failed list with customer names + retry option
```

---

## P4-09 — Credits + Top-Up Screens (S1-16, S1-17, S1-18)

```
This is billing project. Follow CLAUDE.md, SCREENS-1.md S1-16 to S1-18, FLOWS.md F1-06.

Create:
  lib/features/credits/presentation/credits_screen.dart
  lib/features/credits/presentation/topup_screen.dart
  lib/features/credits/presentation/topup_success_screen.dart
  lib/features/credits/domain/topup_notifier.dart
  lib/features/credits/data/credits_repository.dart

CREDITS SCREEN (S1-16):
  - GradientHeader(purple): "Credits & Plan"
  - Plan card (white AppCard overlapping header):
      Plan badge (PlanBadge widget) + "Renews on {date}"
      Bill Credits progress bar (filled kOrange, track kBorderGray)
      "{used}/{limit} used" caption
      Msg Credits progress bar (same)
  - Top-up packs section (SectionHeader "Buy Extra Credits"):
      2 columns: bill credit packs | msg credit packs
      Each pack: AppCard with pack name, credits, price (bold), per-credit cost
      SmallActionButton "Buy" on each card → /credits/topup?pack={packId}

TOP-UP SCREEN (S1-17):
  - Top bar: back + "Buy Credits"
  - Selected pack AppCard (pack name, credits, "Change pack" link in orange)
  - Payment summary AppCard: price + 18% GST + total
  - Payment method section (Razorpay logo)
  - BottomActionBar: "₹{total}" + PrimaryButton "Pay Now"
  - On "Pay Now":
      POST /credits/topup/initiate → get orderId + razorpayKeyId
      Open Razorpay SDK with orderId
      On Razorpay success callback:
        POST /credits/topup/verify with razorpayOrderId, paymentId, signature
        Success → /credits/topup-success
      On Razorpay failure/cancel:
        SnackBar "Payment cancelled/failed"

TOP-UP SUCCESS SCREEN (S1-18):
  - Green checkmark animation + "Credits Added!"
  - Summary AppCard: pack name + credits added + new balance + amount paid
  - PrimaryButton "Back to Dashboard" → /dashboard
  - Hardware back → /dashboard

RAZORPAY INTEGRATION:
  Use razorpay_flutter package
  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handleSuccess)
  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handleError)
  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleWallet)
  Dispose _razorpay in dispose()
```

---

# SECTION 5 — SALESPERSON FEATURE PROMPTS

---

## P5-01 — Salesperson Login Screen (S2-01)

```
This is billing project. Follow CLAUDE.md and SCREENS-2.md S2-01.

Create lib/features/auth/presentation/salesperson_login_screen.dart

Route: /salesperson/login
Different from shopkeeper login — uses email + password, not OTP.

UI:
  - Navy gradient header (GradientHeader type: navy)
  - "Sales Team Portal" badge in header (orange outlined pill)
  - "Restricted Access" badge (red outlined pill, smaller)
  - White form AppCard (overlaps -20px):
      Title: "Sales Team Login"
      Sub: "One Stop Solutions — Internal Only"
      Email InputField (email keyboard)
      Password InputField (obscureText, show/hide toggle)
      "Forgot Password?" link (right-aligned, orange 12px)
      PrimaryButton "Log In" (disabled when fields empty)
  - Security note: "This portal is for authorised administrators only"
  - Footer links: "Are you a shopkeeper? →" and "Sales Team →"

On Log In:
  supabase.auth.signInWithPassword(email, password)
  Check role = 'salesperson' (if not → signOut + show "Wrong login")
  Success → context.go('/salesperson/dashboard')
  Error → "Invalid email or password" below password field
  After 5 failed attempts → "Too many attempts. Try again in 30 minutes."
```

---

## P5-02 — Add Shop 4-Step Flow (S2-04 → S2-08)

```
This is billing project. Follow CLAUDE.md, SCREENS-2.md S2-04 to S2-08, FLOWS.md F2-01.

Create:
  lib/features/salesperson/presentation/add_shop/step1_details_screen.dart
  lib/features/salesperson/presentation/add_shop/step2_branding_screen.dart
  lib/features/salesperson/presentation/add_shop/step3_plan_screen.dart
  lib/features/salesperson/presentation/add_shop/step4_autopay_screen.dart
  lib/features/salesperson/presentation/add_shop/success_screen.dart
  lib/features/salesperson/domain/add_shop_notifier.dart
  lib/features/salesperson/data/shop_repository.dart

ADD SHOP NOTIFIER (addShopNotifierProvider):
  Persists all step data across navigation (do NOT lose data on screen change)
  State: { step1: ShopDetailsForm?, step2: ShopBrandingForm?, plan: String?,
           upiId: String?, mandateStatus: String?, shopId: String?, isLoading: bool }
  Methods:
    saveStep1(ShopDetailsForm), saveStep2(ShopBrandingForm), selectPlan(String),
    setLogo(File), skipLogo(), setUpiId(String),
    Future<void> createShopAndMandate() → POST /subscriptions/autopay/create
    Future<String> checkMandateStatus(String shopId) → polls GET /subscriptions/autopay/status
    reset()

KEY IMPLEMENTATION NOTES:
  - addShopNotifierProvider must be family-scoped or use keepAlive: true
    so data persists across all 4 step screens without losing state on push/pop
  - Step 4 polling: use Timer.periodic every 10 seconds
    cancel timer in notifier dispose and on success/failure
  - Logo upload: image_picker → compress to 500×500px → POST /shops/:id/logo
  - StepProgressBar widget used on all 4 steps
  - Each step's "Next" button calls saveStepN() then context.push(nextRoute)
  - Back arrow on each step calls context.pop() (keeps notifier state)

STEP 4 WAITING STATE (mandate pending):
  Animated orange pulse (AnimatedContainer scale 1.0→1.1→1.0 repeat)
  "Waiting for shopkeeper to approve..."
  Polling status every 10s via checkMandateStatus()
  On 'approved' → cancel timer → context.go('/salesperson/shops/add/success')
  On timeout (10 min) → show [Resend] + [Set Up Later] options
```

---

## P5-03 — Cancellation Request Detail (S2-12)

```
This is billing project. Follow CLAUDE.md and SCREENS-2.md S2-12.

Create lib/features/salesperson/presentation/cancellation_detail_screen.dart

Route: /salesperson/cancellations/:requestId
Provider: cancellationDetailNotifierProvider (takes requestId as param)
Repository: GET /cancellation-requests/:id

SCREEN LAYOUT:
  1. GradientHeader(orange): "Cancellation Request" + requestId subtitle
  2. Shop info AppCard (overlapping header): logo, name, plan, owner, salesperson
  3. Request details AppCard: submitted at, reason, shopkeeper note, salesperson note
  4. Financial impact AppCard (bg #FEF2F2, red left border):
     "Monthly revenue lost: ₹{amount}"
     "Razorpay mandate: {mandateId}"
     "Approving will cancel mandate {mandateId}" (red 13px)
  5. Admin action AppCard (if status = pending):
     Call + WhatsApp links
     Admin notes InputField (multi-line)
     Two action buttons

BOTTOM STICKY BAR (pending only):
  [Reject] SecondaryButton (red outlined, flex 1)
  [Approve] — uses kGreen NOT kOrange (exception to rule — approval action)
  Width: equal flex

On Approve:
  ConfirmBottomSheet.show(context,
    title: "Approve cancellation for {shopName}?",
    body: "AutoPay mandate will be cancelled. Shop access ends {date}.",
    confirmLabel: "Confirm Approve",
    confirmButtonColor: AppColors.kGreen,
  )
  → On confirm: PATCH /cancellation-requests/:id { action: 'approved' }
  → SuccessToast "Request approved" → context.pop()

On Reject:
  Bottom sheet with reason text field
  → PATCH /cancellation-requests/:id { action: 'rejected', reason: ... }
```

---

# SECTION 6 — SUPER ADMIN FEATURE PROMPTS

---

## P6-01 — Super Admin Dashboard (S3-02)

```
This is billing project. Follow CLAUDE.md and SCREENS-3.md S3-02.

Create lib/features/admin/presentation/dashboard_screen.dart
Create lib/features/admin/domain/admin_dashboard_notifier.dart

Provider: GET /admin/dashboard → AdminDashboardState:
  { mrr, mrrChange, totalShops, activeShops, pendingShops,
    salespersonsCount, pendingCancellations, failedPayments,
    newShopsThisMonth, recentActivity: List<ActivityItem> }

SCREEN LAYOUT:
  1. GradientHeader(navy) — UNIQUE to Super Admin
     Greeting: "Good morning, {adminName}"
     Right: Avatar (initials, kOrange bg)

  2. MRR Hero AppCard (overlapping header):
     "MONTHLY RECURRING REVENUE" LABEL style
     "₹{mrr}" in Playfair Display 32px
     "+₹{mrrChange} (+{pct}%)" in kGreen (or kError if negative)
     Stats 2×2 grid: Total Shops | Active | Salespersons | Pending Issues
     "Pending Issues" count in kError if > 0

  3. Alert cards (conditional — show each alert only if relevant):
     InfoBanner(warning): "{n} cancellation requests need action" + "Review →"
     InfoBanner(error): "{n} shops have failed payments" + "View →"
     InfoBanner(warning): "Templates need renewal" + "Manage →"

  4. Quick actions 2×2 grid (kNavyCard bg):
     Salespersons | All Shops | Templates | Revenue

  5. Recent Activity feed (plain list with dividers, no AppCard per row):
     Color-coded dots by event type
     Event text + relative timestamp

  6. BottomTabBar (5 tabs: Dashboard | Shops | Salespersons | Templates | Settings)
```

---

## P6-02 — Template Edit Screen (S3-09)

```
This is billing project. Follow CLAUDE.md and SCREENS-3.md S3-09.

Create lib/features/admin/presentation/template_detail_screen.dart

Route: /admin/templates/:templateId (also /admin/templates/add for new)
Provider: adminTemplateDetailNotifierProvider

KEY FEATURES:
  1. Live preview — as template body is edited, preview updates in real-time
     Show WhatsApp-style bubble (bg #DCF8C6, radius 12px, padding 12px)
     Replace {{1}}, {{2}} etc. with sample values for preview

  2. Variable management — dynamic list:
     Each row: "Variable {{n}}" label + description TextFormField
     "+ Add Variable" (orange text link) appends row
     Variables used in body auto-highlighted in kOrange in preview

  3. Category cost display:
     Marketing → "₹0.86 per message" shown next to category dropdown
     Utility   → "₹0.12 per message"

  4. Meta status display (existing templates):
     Large status badge at top (approved/pending/rejected)
     Rejection reason shown in red AppCard if rejected

BOTTOM STICKY BAR:
  Cost note (left) + [Save Draft] SecondaryButton + [Submit for Approval] PrimaryButton
  Submit shows ConfirmBottomSheet (warns about re-approval on edit)

On Submit:
  PUT /admin/templates/:id { submitToMeta: true }
  Updates template status to 'pending'
  SuccessToast "Template submitted. Awaiting Meta approval (24-48 hours)"
```

---

## P6-03 — Revenue Report Screen (S3-13)

```
This is billing project. Follow CLAUDE.md and SCREENS-3.md S3-13.

Create lib/features/admin/presentation/revenue_screen.dart

Route: /admin/revenue
Provider: adminRevenueNotifierProvider
Default date range: current month
API: GET /admin/revenue?from={date}&to={date}

SCREEN LAYOUT:
  1. GradientHeader(navy): "Revenue Report" + date picker icon right
     Date picker bottom sheet: [This Month] [Last Month] [Last 3 Months] [Custom]

  2. MRR Hero AppCard: total + subscription breakdown + top-up breakdown

  3. Plan distribution AppCard (horizontal progress bars):
     Basic:    [{n} shops · ₹{amount}] [█████░░░░░] (kOrange bar)
     Pro:      [{n} shops · ₹{amount}] [████████░░]
     Business: [{n} shops · ₹{amount}] [███░░░░░░░]

  4. Cost analysis AppCard (INTERNAL — admin-only):
     AiSensy platform fee, Meta message costs, Razorpay fees, total cost
     Net revenue (bold, kGreen), margin %
     Note: "* Message costs are estimates"

  5. Top shops table (AppCard): top 10 shops by value
  6. Salesperson performance table (AppCard): sorted by revenue
  7. Payment health AppCard: successful %, failed count, action needed

All number formatting via formatINR() from formatters.dart.
All tables use simple Column + Row layout (not DataTable widget).
```

---

# SECTION 7 — INTEGRATION PROMPTS

---

## P7-01 — AiSensy Service (Node.js backend)

```
This is billing project Node.js backend. Follow CLAUDE.md and API.md Section 13.

Create src/services/aisensy.service.js

This service is called from Node.js ONLY. Never exposed to Flutter directly.

Methods:

async sendBillMessage({ phone, customerName, shopName, billNumber, totalAmount, pdfUrl })
  POST to AiSensy sendTemplateMessage endpoint
  campaignName: 'building_project_bill_send'
  templateParams: [shopName, billNumber, totalAmount]
  media: { url: pdfUrl, filename: `Bill_${billNumber}.pdf` }
  Returns: { success: boolean, messageId: string | null, error: string | null }
  On rate limit (429): wait 1 second and retry once
  On any error: return { success: false, error: errorMessage }

async sendBulkCampaign({ templateName, broadcastName, receivers })
  POST to AiSensy sendBulkTemplateMessage endpoint
  receivers: array of { whatsappNumber, customParams }
  Returns: { success: boolean, campaignId: string | null, error: string | null }

async submitTemplate({ name, category, language, body, footer, variables })
  POST to AiSensy templates endpoint
  Returns: { success: boolean, submissionId: string | null }

async getTemplateStatus(templateName)
  GET template status from AiSensy
  Returns: { status: 'APPROVED' | 'REJECTED' | 'PENDING', reason: string | null }

Configuration:
  AISENSY_API_KEY from process.env (never hardcoded)
  All requests have: Authorization: Bearer ${AISENSY_API_KEY}
  All requests log: timestamp, method, endpoint, response status (NO payload logging in production)
  Timeout: 10 seconds per request
```

---

## P7-02 — Razorpay Service (Node.js backend)

```
This is billing project Node.js backend. Follow CLAUDE.md and API.md Section 14.

Create src/services/razorpay.service.js

Methods:

async createSubscription({ planId, shopId, shopName, salespersonId })
  POST /v1/subscriptions to Razorpay
  total_count: 120 (10 years — effectively perpetual)
  customer_notify: 1
  notes: { shop_id, shop_name, salesperson_id }
  Returns: { subscriptionId, status }

async createTopupOrder({ amount, shopId, packId, creditType, credits })
  POST /v1/orders to Razorpay
  amount in paise
  notes: { shop_id, pack_id, credit_type, credits }
  Returns: { orderId }

verifyPaymentSignature({ orderId, paymentId, signature })
  HMAC SHA256: `${orderId}|${paymentId}` signed with RAZORPAY_KEY_SECRET
  Returns: boolean (true if valid)

async cancelSubscription(subscriptionId)
  POST /v1/subscriptions/{id}/cancel
  cancel_at_cycle_end: 1
  Returns: { success: boolean }

verifyWebhookSignature(payload, razorpaySignature)
  HMAC SHA256: raw request body signed with RAZORPAY_WEBHOOK_SECRET
  Returns: boolean

Configuration:
  RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET, RAZORPAY_WEBHOOK_SECRET from process.env
  Basic Auth: Buffer.from(`${KEY_ID}:${KEY_SECRET}`).toString('base64')
  All calls logged to webhook_logs table (success or failure)
```

---

## P7-03 — Credit Deduction (Node.js + Supabase)

```
This is billing project Node.js backend. Follow CLAUDE.md, API.md Section 5, DATABASE.md Section 16.1.

Create src/services/credits.service.js

This is the most critical service — handles atomic credit operations.

async deductBillCredit({ shopId, billId })
  Calls Supabase RPC: deduct_bill_credit(shopId, billId)
  (DB function defined in DATABASE.md Section 16.1 — handles atomicity + FOR UPDATE lock)
  Returns: { success: boolean, creditsRemaining: number | null, error: string | null }
  On INSUFFICIENT_BILL_CREDITS: return error WITHOUT throwing exception

async deductMsgCredits({ shopId, campaignId, count })
  Similar atomic operation for msg_credits
  Deducts {count} credits in one DB call
  Returns: { success: boolean, creditsRemaining: number | null, error: string | null }

async addCredits({ shopId, creditType, amount, transactionType, referenceId, performedBy, notes })
  INSERT into shop_credits (via atomic UPDATE) AND credit_transactions
  transactionType: 'topup_addition' | 'manual_addition' | 'plan_allocation' | 'rollback'
  Returns: { success: boolean, newBalance: number }

async rollbackBillCredit({ shopId, billId })
  Called when AiSensy send fails AFTER credit was deducted
  Calls addCredits with transactionType: 'rollback', amount: 1
  Logs rollback reason

CRITICAL RULES:
  NEVER deduct credits outside this service
  NEVER deduct credits without logging to credit_transactions
  ALWAYS use DB function for deductions (FOR UPDATE lock prevents race conditions)
  If credit deduction succeeds but AiSensy fails → MUST call rollbackBillCredit
```

---

# SECTION 8 — BUG FIX PROMPT TEMPLATES

Copy and fill in when you encounter a bug.

---

## P8-01 — State Not Updating

```
Bug in billing project Flutter app. Follow CLAUDE.md exactly.

PROBLEM:
  [Describe what is NOT updating — e.g. "The credit count on the dashboard does not
   decrease after a bill is sent successfully"]

FILE AFFECTED:
  [e.g. lib/features/dashboard/presentation/dashboard_screen.dart]
  [e.g. lib/features/credits/domain/credits_notifier.dart]

CURRENT BEHAVIOR:
  [What the UI shows]

EXPECTED BEHAVIOR:
  [What it should show]

CURRENT STATE MANAGEMENT:
  [e.g. "dashboardNotifierProvider watches creditsNotifierProvider.
   creditsNotifierProvider subscribes to Supabase realtime on shop_credits."]

CONSTRAINT:
  Fix ONLY the state update issue. Do NOT rewrite the widget or change any UI.
  Show me the exact lines to change.
  Use Riverpod 3.x patterns only — no setState(), no GetX.
```

---

## P8-02 — Navigation Error

```
Bug in billing project Flutter app.

PROBLEM:
  [e.g. "Pressing back from /bill-sent goes back to /bill-preview instead of /dashboard"]

CURRENT CODE (relevant snippet):
  [paste the onPressed or navigation code]

EXPECTED:
  [e.g. "Back should always go to /dashboard — bill is already sent"]

FIX USING:
  go_router only — context.go() or PopScope
  Never Navigator.push() or Navigator.pop() for app-level navigation
  Show me the exact fix — do not touch other parts of the file.
```

---

## P8-03 — API Call Error

```
Bug in billing project Flutter app.

PROBLEM:
  [e.g. "POST /bills returns 401 Unauthorized but the user is logged in"]

SCREEN/NOTIFIER:
  [e.g. lib/features/billing/domain/new_bill_notifier.dart]

ERROR MESSAGE:
  [paste the exact error or stack trace]

RELEVANT API SPEC:
  From API.md Section 5.1: POST /bills requires:
  Authorization: Bearer {supabase_token} and X-Shop-Id header

CURRENT INTERCEPTOR CODE:
  [paste AuthInterceptor code from dio_client.dart]

DIAGNOSE AND FIX:
  Check: is the token being attached? is X-Shop-Id being attached?
  Show me the fix in dio_client.dart AuthInterceptor only.
  Do NOT change the billing notifier or screen.
```

---

## P8-04 — Widget Render Issue

```
Bug in billing project Flutter app.

PROBLEM:
  [e.g. "AppCard with leftBorderColor shows the border only on the left but clips the content
   on the right side"]

WIDGET FILE:
  lib/shared/widgets/app_card.dart

CURRENT CODE:
  [paste the relevant BoxDecoration or Border code]

EXPECTED VISUAL:
  From COMPONENTS.md C-05: "Standard + 4px left border in color, other 3 sides 1px #E5E5E5"

FIX:
  Fix the Border definition only. Do not change any other prop or logic.
  Ensure ClipRRect matches the borderRadius to avoid content overflow.
```

---

## P8-05 — Credit Deduction Not Atomic

```
Bug in billing project Node.js backend.

PROBLEM:
  [e.g. "Two simultaneous bill sends from the same shop both succeed even when only 1
   credit remains — race condition"]

AFFECTED FILE:
  src/services/credits.service.js

CURRENT IMPLEMENTATION:
  [paste current deductBillCredit implementation]

REQUIRED FIX:
  Must use PostgreSQL FOR UPDATE lock via Supabase RPC call.
  The DB function deduct_bill_credit() in DATABASE.md Section 16.1 handles this.
  Fix the service to call the RPC function instead of direct UPDATE.
  Show exact code change only.
```

---

# SECTION 9 — CODE REVIEW PROMPTS

---

## P9-01 — Review a New Screen

```
Review this Flutter screen for billing project. Apply CLAUDE.md rules strictly.

FILE: [paste file path]

CODE:
[paste the screen code]

CHECK FOR:
  1. Hardcoded colors (any Color(0xFF...) not from AppColors) → flag all
  2. Hardcoded spacing (any double literal for padding/margin not from AppSpacing) → flag all
  3. Hardcoded strings not from AppStrings → flag all
  4. Business logic in build() method → should be in notifier → flag all
  5. setState() for non-local state → should use Riverpod → flag
  6. Navigator.push() or pop() → should be context.go() / context.push() → flag
  7. ref.read() inside build() → should be ref.watch() → flag
  8. Missing AsyncValue error/loading state handling → flag if .value accessed without .when()
  9. Missing const constructor on static widgets → flag for performance
  10. Duplicate widget that exists in lib/shared/widgets/ → flag and suggest using shared one

For each issue: quote the line, explain why it violates CLAUDE.md, show the fix.
```

---

## P9-02 — Review a Notifier

```
Review this Riverpod notifier for billing project. Apply CLAUDE.md rules.

FILE: [paste file path]

CODE:
[paste the notifier code]

CHECK FOR:
  1. Uses @riverpod annotation (not StateNotifierProvider) → correct
  2. All async methods use AsyncValue.guard() → correct
  3. All three states returned: loading, data, error → correct
  4. No business logic in screens calling this notifier → verify
  5. Repository calls use Either<Failure, T> return type → correct
  6. No direct Supabase/Dio calls in notifier → should be in repository → flag
  7. Proper dispose handling (StreamSubscriptions cancelled in ref.onDispose) → flag if missing
  8. State mutations are immutable (copyWith, not direct mutation) → correct
  9. ref.invalidateSelf() used correctly for refresh → correct if present

For each issue found: explain violation + show exact fix.
```

---

# SECTION 10 — TESTING PROMPTS

---

## P10-01 — Unit Test for Notifier

```
Write unit tests for billing project.

FILE TO TEST: lib/features/billing/domain/new_bill_notifier.dart

Read the notifier code and write tests for these scenarios:
  1. addItem() adds a BillItemModel to the items list
  2. removeItem(0) removes item at index 0
  3. updateItem() recalculates subtotal, gstAmount, total correctly
     Test case: 2 items × ₹100 each = ₹200 subtotal, ₹10 GST (5%), ₹210 total
  4. sendBill() — success path: calls billingRepository.sendBill() with correct params
  5. sendBill() — on API error: state becomes AsyncError with correct failure type
  6. sendBill() — INSUFFICIENT_BILL_CREDITS: state becomes AsyncError with InsufficientCreditsFailure
  7. After successful sendBill(): state.isLoading resolves to data state

Setup:
  Use ProviderContainer for testing (not WidgetTester)
  Mock BillingRepository using Mocktail or Mockito
  Mock creditsNotifierProvider to return 50 credits

Test file location: test/features/billing/new_bill_notifier_test.dart
Use flutter_test and riverpod testing utilities.
```

---

## P10-02 — Widget Test for Shared Component

```
Write widget tests for billing project.

WIDGET TO TEST: lib/shared/widgets/primary_button.dart

Tests:
  1. Renders label text correctly
  2. Shows CircularProgressIndicator when isLoading: true, hides label
  3. onTap is called when button is tapped (enabled state)
  4. onTap is NOT called when button is disabled (onTap: null)
  5. Background color is kOrange when enabled
  6. Background color is #CCCCCC when disabled (onTap null)
  7. Button is full width when isFullWidth: true (default)
  8. Button renders leadingIcon when provided
  9. Button renders subLabel when provided

Test file: test/shared/widgets/primary_button_test.dart
Use flutter_test WidgetTester.
Pump the widget inside a MaterialApp with AppTheme.lightTheme.
```

---

## P10-03 — Integration Test for Core Flow

```
Write an integration test for billing project.

FLOW TO TEST: F1-02 — Send a Bill (from FLOWS.md)

Test: Happy path — shopkeeper creates and sends a bill

Setup:
  Mock Supabase auth (logged in as shopkeeper)
  Mock GET /customers → returns 1 customer: { id: 'c1', name: 'Suresh', phone: '9876543210' }
  Mock POST /bills → returns { billId: 'b1', billNumber: 'BILL-2026-0001', status: 'sent' }
  Mock shop_credits Supabase stream → billCredits: 50

Steps:
  1. Start at /dashboard → verify "New Bill" action card is visible
  2. Tap "New Bill" → verify /new-bill screen loads
  3. Type "Suresh" in customer search → verify Suresh Kumar appears
  4. Tap Suresh Kumar → verify customer chip appears
  5. Enter item: name "Cotton", qty "2", rate "500"
  6. Verify amount shows "₹1000" (auto-calculated)
  7. Verify total shows "₹1050" (1000 + 5% GST)
  8. Tap "Preview Bill →" → verify /bill-preview loads
  9. Verify bill shows correct totals
  10. Tap "Send on WhatsApp" → verify loading state
  11. Verify POST /bills was called with correct body
  12. Verify navigation to /bill-sent
  13. Verify "Bill Sent!" headline appears

Test file: integration_test/send_bill_flow_test.dart
Use flutter_test + integration_test package.
Mock all HTTP calls via Dio Interceptor mock.
```

---

## PROMPT QUICK REFERENCE

```
SETUP (run in order):
  P1-01 Create project → P1-02 Folder structure → P1-03 AppColors →
  P1-04 AppTypography → P1-05 AppSpacing → P1-06 AppTheme →
  P1-07 go_router → P1-08 Dio + Endpoints → P1-09 Validators →
  P1-10 main.dart

CORE ARCHITECTURE:
  P2-01 Auth notifier → P2-02 Credits realtime

SHARED WIDGETS:
  P3-01 AppCard → P3-02 PrimaryButton → P3-03 All remaining 23 widgets

SHOPKEEPER SCREENS (in order):
  P4-01 Login → P4-02 OTP → P4-03 Dashboard →
  P4-04 New Bill → P4-05 Bill Preview → P4-06 Bill Sent →
  P4-07 Customer List + Add → P4-08 Bulk Message flow →
  P4-09 Credits + Top-Up

SALESPERSON SCREENS:
  P5-01 Login → P5-02 Add Shop 4-step → P5-03 Cancellation detail

SUPER ADMIN SCREENS:
  P6-01 Dashboard → P6-02 Template edit → P6-03 Revenue report

INTEGRATIONS:
  P7-01 AiSensy (Node.js) → P7-02 Razorpay (Node.js) → P7-03 Credits service

BUG FIXES:
  P8-01 State not updating → P8-02 Navigation error →
  P8-03 API call error → P8-04 Widget render issue →
  P8-05 Race condition

CODE REVIEW:
  P9-01 Review screen → P9-02 Review notifier

TESTING:
  P10-01 Unit test notifier → P10-02 Widget test component →
  P10-03 Integration test flow
```

---

*PROMPTS.md v1.0 — Billing Project — One Stop Solutions*
*Complete AI prompt library · 10 sections · July 2026*
