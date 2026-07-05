# PROGRESS.md — Billing Project
# Development Progress Tracker
# Version 1.0 | One Stop Solutions | July 2026
# Author: Leeladhar
#
# ─────────────────────────────────────────────────────────────────
# HOW AI READS THIS FILE:
#   At the start of every session, AI reads this file to know:
#   - What is already done (never rebuild these)
#   - What is currently in progress (continue from here)
#   - What is blocked (ask Leeladhar before proceeding)
#   - What is next (build this next)
#
# HOW AI UPDATES THIS FILE:
#   After every meaningful code change, AI must:
#   1. Change the status of the completed item from ⏳ to ✅
#   2. Add a line to the Daily Log with date + what was done
#   3. Update "CURRENTLY IN PROGRESS" section
#   4. Update "NEXT UP" section
#   Never delete old log entries. Only append.
#
# STATUS LEGEND:
#   ✅  Done — file exists, compiles, tested on device
#   ⏳  In progress — started but not complete
#   🔴  Blocked — needs decision or external dependency
#   ⬜  Not started — not touched yet
#   🔁  Needs rework — done but has issues flagged
# ─────────────────────────────────────────────────────────────────

---

## CURRENT STATUS SNAPSHOT

```
Last updated:     [AI fills this on every update]
Currently on:     Phase 1 — Project Setup
Currently building: Nothing yet — not started
Blocked on:       Nothing
Overall progress: 0 / 8 phases complete | 0 / 50 screens complete
```

---

## PHASE OVERVIEW

```
Phase 0  ⬜  Accounts + Database setup (manual)
Phase 1  ⬜  Flutter project + folder structure + constants
Phase 2  ⬜  Shared widgets (25 widgets)
Phase 3  ⬜  Auth + Dashboard
Phase 4  ⬜  Core billing flow (CRITICAL)
Phase 5  ⬜  Complete shopkeeper portal
Phase 6  ⬜  Salesperson portal
Phase 7  ⬜  Super Admin portal
Phase 8  ⬜  Testing + bugs + Play Store
```

---

## PHASE 0 — Accounts + Database (Manual Setup)

```
0.1  ⬜  Supabase project created + URL/key saved
0.2  ⬜  AiSensy account + WhatsApp number registered
0.3  ⬜  Razorpay account created (TEST mode)
0.4  ⬜  Firebase project + google-services.json downloaded
0.5  ⬜  Railway account created (for Node.js backend)
0.6  ⬜  GitHub private repo created
0.7  ⬜  DATABASE.md tables created in Supabase SQL Editor
       (Sections 3→4→5→6→7→8→9→10→11→12→13→16→17 in order)
0.8  ⬜  Supabase Realtime enabled on: shop_credits, notifications, campaigns, subscriptions
0.9  ⬜  Supabase Storage buckets created: shop-logos, bills, app-assets
0.10 ⬜  7 WhatsApp templates submitted to Meta via AiSensy (takes 24-48h)
```

---

## PHASE 1 — Project Setup (Claude Code)

```
1.1  ⬜  All .md docs copied to project root
       (CLAUDE.md, DESIGN.md, COMPONENTS.md, SCREENS-1/2/3.md,
        API.md, DATABASE.md, FLOWS.md, PROMPTS.md, PROGRESS.md)
1.2  ⬜  Flutter project created (building_project, com.onestopsolutions)
1.3  ⬜  pubspec.yaml — all dependencies added
1.4  ⬜  Complete folder structure created (lib/core + lib/shared + lib/features)
1.5  ⬜  lib/core/constants/app_colors.dart
1.6  ⬜  lib/core/constants/app_typography.dart
1.7  ⬜  lib/core/constants/app_spacing.dart
1.8  ⬜  lib/core/constants/app_strings.dart
1.9  ⬜  lib/core/theme/app_theme.dart
1.10 ⬜  lib/core/router/app_router.dart (all 50 routes as placeholders)
1.11 ⬜  lib/core/network/dio_client.dart (+ auth interceptor + error interceptor)
1.12 ⬜  lib/core/network/api_endpoints.dart
1.13 ⬜  lib/core/storage/secure_storage.dart
1.14 ⬜  lib/core/error/failures.dart
1.15 ⬜  lib/core/error/exceptions.dart
1.16 ⬜  lib/core/utils/validators.dart
1.17 ⬜  lib/core/utils/formatters.dart
1.18 ⬜  lib/core/utils/extensions.dart
1.19 ⬜  lib/main.dart (ProviderScope + Supabase init + Firebase init)

CHECKPOINT: flutter run → white screen, zero errors ⬜
```

---

## PHASE 2 — Shared Widgets (Claude Code)

```
2.1  ⬜  C-05 lib/shared/widgets/app_card.dart
2.2  ⬜  C-01 lib/shared/widgets/primary_button.dart
2.3  ⬜  C-02 lib/shared/widgets/secondary_button.dart
2.4  ⬜  C-03 lib/shared/widgets/dark_pill_button.dart
2.5  ⬜  C-04 lib/shared/widgets/small_action_button.dart
2.6  ⬜  C-06 lib/shared/widgets/gradient_header.dart
2.7  ⬜  C-07 lib/shared/widgets/filter_chip_row.dart
2.8  ⬜  C-08 lib/shared/widgets/filter_chip.dart
2.9  ⬜  C-09 lib/shared/widgets/bottom_action_bar.dart
2.10 ⬜  C-10 lib/shared/widgets/bottom_tab_bar.dart
2.11 ⬜  C-11 lib/shared/widgets/empty_state.dart
2.12 ⬜  C-12 lib/shared/widgets/loading_overlay.dart
2.13 ⬜  C-13 lib/shared/widgets/success_toast.dart
2.14 ⬜  C-14 lib/shared/widgets/section_header.dart
2.15 ⬜  C-15 lib/shared/widgets/icon_container.dart
2.16 ⬜  C-16 lib/shared/widgets/credit_badge.dart
2.17 ⬜  C-17 lib/shared/widgets/status_badge.dart
2.18 ⬜  C-18 lib/shared/widgets/plan_badge.dart
2.19 ⬜  C-19 lib/shared/widgets/bill_card.dart
2.20 ⬜  C-20 lib/shared/widgets/customer_card.dart
2.21 ⬜  C-21 lib/shared/widgets/shop_card.dart
2.22 ⬜  C-22 lib/shared/widgets/input_field.dart
2.23 ⬜  C-23 lib/shared/widgets/step_progress_bar.dart
2.24 ⬜  C-24 lib/shared/widgets/confirm_bottom_sheet.dart
2.25 ⬜  C-25 lib/shared/widgets/info_banner.dart

CHECKPOINT: All 25 widgets render on real Android device, zero analyzer warnings ⬜
```

---

## PHASE 3 — Auth + Dashboard (Antigravity)

```
Core Architecture:
3.1  ⬜  lib/features/auth/data/models/user_model.dart
3.2  ⬜  lib/features/auth/data/auth_repository.dart
3.3  ⬜  lib/features/auth/domain/auth_notifier.dart
3.4  ⬜  lib/shared/providers/auth_provider.dart
3.5  ⬜  lib/features/credits/domain/credits_notifier.dart (Supabase realtime)

Shopkeeper Auth:
3.6  ⬜  S1-01 lib/features/auth/presentation/login_screen.dart
3.7  ⬜  S1-02 lib/features/auth/presentation/otp_screen.dart

Dashboard:
3.8  ⬜  lib/features/dashboard/data/dashboard_repository.dart
3.9  ⬜  lib/features/dashboard/domain/dashboard_notifier.dart
3.10 ⬜  S1-03 lib/features/dashboard/presentation/dashboard_screen.dart

CHECKPOINT: OTP login works on real device → Dashboard loads with real Supabase data ⬜
```

---

## PHASE 4 — Core Billing Flow (Antigravity) ← CRITICAL

```
Models + Repository:
4.1  ⬜  lib/features/billing/data/models/bill_model.dart
4.2  ⬜  lib/features/billing/data/models/bill_item_model.dart
4.3  ⬜  lib/features/billing/data/billing_repository.dart

Notifier:
4.4  ⬜  lib/features/billing/domain/new_bill_notifier.dart

Screens:
4.5  ⬜  S1-04 lib/features/billing/presentation/new_bill_screen.dart
4.6  ⬜  S1-05 lib/features/billing/presentation/bill_preview_screen.dart
4.7  ⬜  S1-06 lib/features/billing/presentation/bill_sent_screen.dart

Node.js Backend:
4.8  ⬜  src/services/aisensy.service.js (Node.js)
4.9  ⬜  src/services/credits.service.js (Node.js — atomic deduction)
4.10 ⬜  src/routes/bills.route.js (POST /bills endpoint)
4.11 ⬜  Backend deployed to Railway

CHECKPOINT ★ MOST CRITICAL:
  Create real bill → PDF arrives on WhatsApp → credit -1 in Supabase ⬜
```

---

## PHASE 5 — Complete Shopkeeper Portal (Antigravity)

```
Customers:
5.1  ⬜  lib/features/customers/data/models/customer_model.dart
5.2  ⬜  lib/features/customers/data/customer_repository.dart
5.3  ⬜  lib/features/customers/domain/customer_notifier.dart
5.4  ⬜  S1-09 lib/features/customers/presentation/customer_list_screen.dart
5.5  ⬜  S1-10 lib/features/customers/presentation/add_customer_screen.dart
5.6  ⬜  S1-11 lib/features/customers/presentation/customer_detail_screen.dart

Bill History:
5.7  ⬜  lib/features/billing/domain/bill_history_notifier.dart
5.8  ⬜  S1-07 lib/features/billing/presentation/bill_history_screen.dart
5.9  ⬜  S1-08 lib/features/billing/presentation/bill_detail_screen.dart

Bulk Messaging:
5.10 ⬜  lib/features/messaging/data/models/template_model.dart
5.11 ⬜  lib/features/messaging/data/models/campaign_model.dart
5.12 ⬜  lib/features/messaging/data/messaging_repository.dart
5.13 ⬜  lib/features/messaging/domain/bulk_message_notifier.dart
5.14 ⬜  S1-12 lib/features/messaging/presentation/bulk_message_screen.dart
5.15 ⬜  S1-13 lib/features/messaging/presentation/template_select_screen.dart
5.16 ⬜  S1-14 lib/features/messaging/presentation/bulk_message_preview_screen.dart
5.17 ⬜  S1-15 lib/features/messaging/presentation/delivery_report_screen.dart

Credits + Top-Up:
5.18 ⬜  lib/features/credits/data/credits_repository.dart
5.19 ⬜  lib/features/credits/domain/topup_notifier.dart
5.20 ⬜  S1-16 lib/features/credits/presentation/credits_screen.dart
5.21 ⬜  S1-17 lib/features/credits/presentation/topup_screen.dart
5.22 ⬜  S1-18 lib/features/credits/presentation/topup_success_screen.dart
5.23 ⬜  src/services/razorpay.service.js (Node.js)
5.24 ⬜  src/routes/topup.route.js (Node.js)

Remaining Shopkeeper Screens:
5.25 ⬜  S1-19 lib/features/notifications/presentation/notifications_screen.dart
5.26 ⬜  S1-20 lib/features/settings/presentation/settings_screen.dart
5.27 ⬜  S1-21 lib/features/settings/presentation/cancel_request_screen.dart
5.28 ⬜  S1-22 lib/features/settings/presentation/cancel_confirm_screen.dart
```

---

## PHASE 6 — Salesperson Portal (Antigravity)

```
Auth:
6.1  ⬜  lib/features/auth/presentation/salesperson_login_screen.dart  [S2-01]

Dashboard:
6.2  ⬜  lib/features/salesperson/domain/salesperson_dashboard_notifier.dart
6.3  ⬜  lib/features/salesperson/presentation/dashboard_screen.dart  [S2-02]

Shop Management:
6.4  ⬜  lib/features/salesperson/data/models/shop_model.dart
6.5  ⬜  lib/features/salesperson/data/shop_repository.dart
6.6  ⬜  lib/features/salesperson/domain/shop_list_notifier.dart
6.7  ⬜  lib/features/salesperson/presentation/shop_list_screen.dart  [S2-03]

Add Shop Flow (4 steps):
6.8  ⬜  lib/features/salesperson/domain/add_shop_notifier.dart (persists across steps)
6.9  ⬜  lib/features/salesperson/presentation/add_shop/step1_details_screen.dart  [S2-04]
6.10 ⬜  lib/features/salesperson/presentation/add_shop/step2_branding_screen.dart  [S2-05]
6.11 ⬜  lib/features/salesperson/presentation/add_shop/step3_plan_screen.dart  [S2-06]
6.12 ⬜  lib/features/salesperson/presentation/add_shop/step4_autopay_screen.dart  [S2-07]
6.13 ⬜  lib/features/salesperson/presentation/add_shop/success_screen.dart  [S2-08]

Shop Detail + Edit:
6.14 ⬜  lib/features/salesperson/domain/shop_detail_notifier.dart
6.15 ⬜  lib/features/salesperson/presentation/shop_detail_screen.dart  [S2-09]
6.16 ⬜  lib/features/salesperson/presentation/edit_shop_screen.dart  [S2-10]

Cancellations:
6.17 ⬜  lib/features/salesperson/domain/cancellation_list_notifier.dart
6.18 ⬜  lib/features/salesperson/presentation/cancellation_list_screen.dart  [S2-11]
6.19 ⬜  lib/features/salesperson/presentation/cancellation_detail_screen.dart  [S2-12]

Settings:
6.20 ⬜  lib/features/salesperson/presentation/settings_screen.dart  [S2-13]
```

---

## PHASE 7 — Super Admin Portal (Antigravity)

```
Auth + Dashboard:
7.1  ⬜  lib/features/admin/domain/admin_auth_notifier.dart
7.2  ⬜  lib/features/auth/presentation/admin_login_screen.dart  [S3-01]
7.3  ⬜  lib/features/admin/domain/admin_dashboard_notifier.dart
7.4  ⬜  lib/features/admin/presentation/dashboard_screen.dart  [S3-02]

Salesperson Management:
7.5  ⬜  lib/features/admin/domain/admin_salesperson_notifier.dart
7.6  ⬜  lib/features/admin/presentation/salesperson_list_screen.dart  [S3-03]
7.7  ⬜  lib/features/admin/presentation/add_salesperson_screen.dart  [S3-04]
7.8  ⬜  lib/features/admin/presentation/salesperson_detail_screen.dart  [S3-05]

All Shops:
7.9  ⬜  lib/features/admin/domain/admin_shop_list_notifier.dart
7.10 ⬜  lib/features/admin/presentation/all_shops_screen.dart  [S3-06]
7.11 ⬜  lib/features/admin/presentation/shop_detail_screen.dart  [S3-07]

Templates:
7.12 ⬜  lib/features/admin/domain/admin_templates_notifier.dart
7.13 ⬜  lib/features/admin/presentation/templates_screen.dart  [S3-08]
7.14 ⬜  lib/features/admin/presentation/template_detail_screen.dart  [S3-09]

Plans + Revenue + Settings:
7.15 ⬜  lib/features/admin/presentation/plans_screen.dart  [S3-10]
7.16 ⬜  lib/features/admin/domain/admin_cancellation_notifier.dart
7.17 ⬜  lib/features/admin/presentation/cancellation_list_screen.dart  [S3-11]
7.18 ⬜  lib/features/admin/presentation/cancellation_detail_screen.dart  [S3-12]
7.19 ⬜  lib/features/admin/domain/admin_revenue_notifier.dart
7.20 ⬜  lib/features/admin/presentation/revenue_screen.dart  [S3-13]
7.21 ⬜  lib/features/admin/presentation/platform_settings_screen.dart  [S3-14]
7.22 ⬜  lib/features/admin/presentation/admin_settings_screen.dart  [S3-15]
```

---

## PHASE 8 — Testing + Polish + Launch

```
Code Review:
8.1  ⬜  P9-01 review run on all shopkeeper screens
8.2  ⬜  P9-02 review run on all notifiers
8.3  ⬜  All hardcoded colors replaced with AppColors
8.4  ⬜  All hardcoded spacing replaced with AppSpacing

Tests:
8.5  ⬜  Unit tests — NewBillNotifier (P10-01)
8.6  ⬜  Unit tests — CreditsNotifier
8.7  ⬜  Widget tests — PrimaryButton, AppCard (P10-02)
8.8  ⬜  Integration test — Send Bill flow (P10-03)

Production Readiness:
8.9  ⬜  Razorpay switched to LIVE mode
8.10 ⬜  AiSensy all 7 templates Meta-approved
8.11 ⬜  Supabase RLS verified (shopkeeper A cannot see shopkeeper B's data)
8.12 ⬜  Full end-to-end test on real Redmi/Realme device
8.13 ⬜  Release keystore created + stored safely
8.14 ⬜  flutter build appbundle --release successful
8.15 ⬜  Play Store internal testing track uploaded
```

---

## BUGS & BLOCKERS LOG

```
Format: [DATE] [SEVERITY: HIGH/MED/LOW] [STATUS: OPEN/FIXED] Description

No bugs logged yet.
```

---

## DECISIONS LOG

```
Format: [DATE] Decision made + reason

2026-07-04  Tech stack finalised: Flutter + Riverpod 3.x + Supabase + AiSensy + Razorpay
2026-07-04  Billing format: PDF only (all business types, same structure, different header color)
2026-07-04  WhatsApp BSP: AiSensy (₹1,500/mo platform fee)
2026-07-04  Payment gateway: Razorpay (UPI AutoPay mandates)
2026-07-04  Subscription pricing: Basic ₹299 · Pro ₹599 · Business ₹999
2026-07-04  AutoPay cancel: request-only (shopkeeper cannot self-cancel)
2026-07-04  App language: English only
2026-07-04  Phase 1 WhatsApp: single platform number (per-shop numbers in Phase 2)
2026-07-04  Design style: Ixigo light app inspired (orange #E8680A + purple gradient headers)
```

---

## DAILY LOG

```
Format: [DATE] [PHASE] What was built/changed

2026-07-04  SETUP   All planning documents created (PRD, DESIGN, CLAUDE, SCREENS, API, DATABASE, FLOWS, COMPONENTS, PROMPTS, PROGRESS)
```

---

## STATS

```
Total files to build:   ~120 Dart files + ~15 Node.js files
Completed Dart files:   0
Completed Node files:   0
Screens complete:       0 / 50
Phases complete:        0 / 8
Days in development:    0
```
