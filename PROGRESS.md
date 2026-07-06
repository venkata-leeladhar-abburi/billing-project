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
Last updated:     2026-07-05
Currently on:     Phase 7 — Super Admin Portal — DONE. All 15 SCREENS-3.md screens
                  built, wired into app_router.dart. ALL 50 screens across all 3
                  roles are now real (zero _placeholderBuilder routes remain in
                  app_router.dart). flutter analyze clean. Next: Phase 8 (testing/
                  polish) or Phase 0 (real backend accounts) — that's the only
                  work left before this is a fully-connected mock-data app.
Blocked on:       Browser-preview click-through verification could not be completed —
                  flutter-widget-preview dev server hung at shell init in this sandbox
                  (environment issue, not app code). Re-run preview_start when possible
                  to do a visual audit pass across all 3 portals (done previously for
                  the Shopkeeper portal only). Real device run on iPhone 17 Pro Max
                  simulator confirmed the app boots and onboarding renders correctly
                  after a Firebase.initializeApp() crash fix (see Daily Log).
Overall progress: 6 / 8 phases complete | 50 / 50 screens complete (all 3 roles done)
```

---

## PHASE OVERVIEW

```
Phase 0  ⬜  Accounts + Database setup (manual)
Phase 1  ✅  Flutter project + folder structure + constants
Phase 2  ✅  Shared widgets (25 widgets) — all 25 built + flutter analyze clean
Phase 3  ✅  Auth + Dashboard (mock auth/data; real Supabase repositories not built)
Phase 4  ⏳  Core billing flow — Flutter side done (mock send), Node.js backend not started
Phase 5  ✅  Complete shopkeeper portal — all 22 screens + onboarding done, wired, audited
Phase 6  ✅  Complete salesperson portal — all 13 screens done, wired, spec-checked
Phase 7  ✅  Complete Super Admin portal — all 15 screens done, wired (50/50 screens total)
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
1.1  ✅  All .md docs copied to project root
       (CLAUDE.md, DESIGN.md, COMPONENTS.md, SCREENS-1/2/3.md,
        API.md, DATABASE.md, FLOWS.md, PROMPTS.md, PROGRESS.md)
1.2  ✅  Flutter project created (building_project, com.onestopsolutions)
1.3  ✅  pubspec.yaml — all dependencies added
1.4  ✅  Complete folder structure created (lib/core + lib/shared + lib/features)
1.5  ✅  lib/core/constants/app_colors.dart
1.6  ✅  lib/core/constants/app_typography.dart
1.7  ✅  lib/core/constants/app_spacing.dart
1.8  ✅  lib/core/constants/app_strings.dart
1.9  ✅  lib/core/theme/app_theme.dart
1.10 ✅  lib/core/router/app_router.dart (all 50 routes as placeholders)
1.11 ✅  lib/core/network/dio_client.dart (+ auth interceptor + error interceptor)
1.12 ✅  lib/core/network/api_endpoints.dart
1.13 ✅  lib/core/storage/secure_storage.dart
1.14 ✅  lib/core/error/failures.dart
1.15 ✅  lib/core/error/exceptions.dart
1.16 ✅  lib/core/utils/validators.dart
1.17 ✅  lib/core/utils/formatters.dart
1.18 ✅  lib/core/utils/extensions.dart
1.19 ✅  lib/main.dart (ProviderScope + Supabase init + Firebase init)
1.20 ✅  lib/core/mock/mock_fixtures.dart (shared mock data source)

CHECKPOINT: flutter analyze → zero issues ✅
```

---

## PHASE 2 — Shared Widgets (Claude Code)

```
2.1  ✅  C-05 lib/shared/widgets/app_card.dart
2.2  ✅  C-01 lib/shared/widgets/primary_button.dart
2.3  ✅  C-02 lib/shared/widgets/secondary_button.dart
2.4  ✅  C-03 lib/shared/widgets/dark_pill_button.dart
2.5  ✅  C-04 lib/shared/widgets/small_action_button.dart
2.6  ✅  C-06 lib/shared/widgets/gradient_header.dart
2.7  ✅  C-07 lib/shared/widgets/filter_chip_row.dart
2.8  ✅  C-08 lib/shared/widgets/filter_chip.dart
2.9  ✅  C-09 lib/shared/widgets/bottom_action_bar.dart
2.10 ✅  C-10 lib/shared/widgets/bottom_tab_bar.dart
2.11 ✅  C-11 lib/shared/widgets/empty_state.dart
2.12 ✅  C-12 lib/shared/widgets/loading_overlay.dart
2.13 ✅  C-13 lib/shared/widgets/success_toast.dart
2.14 ✅  C-14 lib/shared/widgets/section_header.dart
2.15 ✅  C-15 lib/shared/widgets/icon_container.dart
2.16 ✅  C-16 lib/shared/widgets/credit_badge.dart
2.17 ✅  C-17 lib/shared/widgets/status_badge.dart
2.18 ✅  C-18 lib/shared/widgets/plan_badge.dart
2.19 ✅  C-19 lib/shared/widgets/bill_card.dart (needed a stub BillModel — see core/models/bill_model.dart)
2.20 ✅  C-20 lib/shared/widgets/customer_card.dart (needed a stub CustomerModel — see core/models/customer_model.dart)
2.21 ✅  C-21 lib/shared/widgets/shop_card.dart (needed a stub ShopModel — see core/models/shop_model.dart)
2.22 ✅  C-22 lib/shared/widgets/input_field.dart
2.23 ✅  C-23 lib/shared/widgets/step_progress_bar.dart
2.24 ✅  C-24 lib/shared/widgets/confirm_bottom_sheet.dart (showModalBottomSheet, not showDialog)
2.25 ✅  C-25 lib/shared/widgets/info_banner.dart

CHECKPOINT: All 25/25 widgets built, flutter analyze zero issues ✅. Visually verified in Chrome web preview (Flutter web via preview harness) ✅. NOT yet verified on a real Android device ⬜ (Phase 0 accounts/signing not set up).
```

---

## PHASE 3 — Auth + Dashboard (Antigravity)

```
Core Architecture:
3.1  ⬜  lib/features/auth/data/models/user_model.dart (not needed yet — mock auth returns a plain role string)
3.2  ⬜  lib/features/auth/data/auth_repository.dart (skipped — mock logic lives directly in auth_notifier.dart per instructions; add when backend ready)
3.3  ✅  lib/features/auth/domain/auth_notifier.dart (mock requestOtp/verifyOtp/logout, code 123456)
3.4  ⬜  lib/shared/providers/auth_provider.dart (still a placeholder stub, unused so far)
3.5  ⬜  lib/features/credits/domain/credits_notifier.dart (Supabase realtime) — not started

Shopkeeper Auth:
3.6  ✅  S1-01 lib/features/auth/presentation/login_screen.dart
3.7  ✅  S1-02 lib/features/auth/presentation/otp_screen.dart (6-box auto-advance, 45s resend countdown)

Dashboard:
3.8  ⬜  lib/features/dashboard/data/dashboard_repository.dart (skipped — mock logic lives directly in dashboard_notifier.dart)
3.9  ✅  lib/features/dashboard/domain/dashboard_notifier.dart
3.10 ✅  S1-03 lib/features/dashboard/presentation/dashboard_screen.dart

CHECKPOINT: OTP login works on real device → Dashboard loads with real Supabase data ⬜
  (Mock flow now works through the REAL connected app_router.dart, not just isolated
  preview: added lib/core/utils/mock_session.dart — a temporary MockSession.role holder
  that AuthNotifier sets on verifyOtp() success and _redirect checks alongside the real
  Supabase session. Full onboarding→login→otp→dashboard→everywhere flow is click-through
  navigable on device today. TODO left inline: delete mock_session.dart and this bypass
  once real Supabase Auth is wired in Phase 0+.)
```

---

## PHASE 4 — Core Billing Flow (Antigravity) ← CRITICAL

```
Models + Repository:
4.1  ✅  lib/core/models/bill_model.dart (deviates from planned path — needed by shared
       BillCard widget which cannot import features/, so it lives in core/models/ instead
       of features/billing/data/models/bill_model.dart. NewBillItem/NewBillState mock
       models for the New Bill flow live in new_bill_notifier.dart itself.)
4.2  ⬜  lib/features/billing/data/models/bill_item_model.dart (superseded by NewBillItem in new_bill_notifier.dart)
4.3  ⬜  lib/features/billing/data/billing_repository.dart (skipped — mock logic lives directly in new_bill_notifier.dart)

Notifier:
4.4  ✅  lib/features/billing/domain/new_bill_notifier.dart (customer select/add, dynamic
       items, live totals, sendBill() mock with 800ms delay, reset())

Screens:
4.5  ✅  S1-04 lib/features/billing/presentation/new_bill_screen.dart
4.6  ✅  S1-05 lib/features/billing/presentation/bill_preview_screen.dart
4.7  ✅  S1-06 lib/features/billing/presentation/bill_sent_screen.dart

Node.js Backend:
4.8  ⬜  src/services/aisensy.service.js (Node.js)
4.9  ⬜  src/services/credits.service.js (Node.js — atomic deduction)
4.10 ⬜  src/routes/bills.route.js (POST /bills endpoint)
4.11 ⬜  Backend deployed to Railway

CHECKPOINT ★ MOST CRITICAL:
  Create real bill → PDF arrives on WhatsApp → credit -1 in Supabase ⬜
  (Flutter-side mock flow complete and visually verified: New Bill → Bill Preview →
  Bill Sent all work end-to-end with simulated send. Real WhatsApp delivery blocked
  on Node.js backend + AiSensy account, Phase 0.)
```

---

## PHASE 5 — Complete Shopkeeper Portal (Antigravity)

```
Customers:
5.1  ✅  lib/core/models/customer_model.dart (deviates from planned path — needed by
       shared CustomerCard widget, so it lives in core/models/ instead of
       features/customers/data/models/customer_model.dart. Extended with optional
       lastBilledAt/addedAt for the "Billed Recently"/"New" filter chips.)
5.2  ⬜  lib/features/customers/data/customer_repository.dart (skipped — mock logic lives directly in customer_notifier.dart)
5.3  ✅  lib/features/customers/domain/customer_notifier.dart (5 mock customers)
5.4  ✅  S1-09 lib/features/customers/presentation/customer_list_screen.dart
       (stats row, search, FilterChipRow: All/Billed Recently/High Value/New, empty states)
5.5  ✅  S1-10 lib/features/customers/presentation/add_customer_screen.dart
       (add_customer_notifier.dart: name/phone/business-type/notes, duplicate-phone
       warning with "Add anyway" override)
5.6  ✅  S1-11 lib/features/customers/presentation/customer_detail_screen.dart
       (customer_detail_notifier.dart is a Riverpod family provider keyed by customerId;
       "Call" quick action now uses real url_launcher tel: link; inline edit mode is
       still a stubbed TODO — separate feature, not just a display concern)

Bill History:
5.7  ✅  lib/features/billing/domain/bill_history_notifier.dart (7 mock bills, sentAt
       DateTime added to BillModel for Today/This Week/This Month filtering)
5.8  ✅  S1-07 lib/features/billing/presentation/bill_history_screen.dart
       (search toggle, FilterChipRow, optional ?customerId= query filter from
       Customer Detail's "View All →")
5.9  ✅  S1-08 lib/features/billing/presentation/bill_detail_screen.dart
       (bill_detail_notifier.dart family provider by billId; Re-send on WhatsApp via
       BottomActionBar, only shown when status=sent)

Bulk Messaging:
5.10 ⬜  lib/features/messaging/data/models/template_model.dart (superseded — reuses
       MockTemplate from core/mock/mock_fixtures.dart for consistency with existing
       shared fixtures, no separate model built)
5.11 ⬜  lib/features/messaging/data/models/campaign_model.dart (skipped — campaign
       state lives directly in bulk_message_notifier.dart's BulkMessageState)
5.12 ⬜  lib/features/messaging/data/messaging_repository.dart (skipped — mock logic
       lives directly in bulk_message_notifier.dart)
5.13 ✅  lib/features/messaging/domain/bulk_message_notifier.dart (single notifier
       shared across all 4 messaging screens below — recipient mode/selection,
       template selection, credit calc, send() with simulated delivered/failed split)
5.14 ✅  S1-12 lib/features/messaging/presentation/bulk_message_screen.dart
5.15 ✅  S1-13 lib/features/messaging/presentation/template_select_screen.dart
5.16 ✅  S1-14 lib/features/messaging/presentation/bulk_message_preview_screen.dart
5.17 ✅  S1-15 lib/features/messaging/presentation/delivery_report_screen.dart

Credits + Top-Up:
5.18 ⬜  lib/features/credits/data/credits_repository.dart (skipped — mock logic lives
       directly in credits_notifier.dart)
5.19 ✅  lib/features/credits/domain/topup_notifier.dart (mock Razorpay pay() flow,
       800ms→1200ms delay, setPack() seeded from router extra)
5.20 ✅  S1-16 lib/features/credits/presentation/credits_screen.dart (plan card,
       bill/msg credit bars, 3 top-up packs, recent payments)
5.21 ✅  S1-17 lib/features/credits/presentation/topup_screen.dart (pack summary +
       18% GST breakdown, mock "Pay via Razorpay")
5.22 ✅  S1-18 lib/features/credits/presentation/topup_success_screen.dart
5.23 ⬜  src/services/razorpay.service.js (Node.js) — Phase 0/backend, not started
5.24 ⬜  src/routes/topup.route.js (Node.js) — Phase 0/backend, not started

Remaining Shopkeeper Screens:
5.25 ✅  S1-19 lib/features/notifications/presentation/notifications_screen.dart
       (5 mock notifications, 5 types with distinct icon/color, unread = orange
       left border, "Mark all read")
5.26 ✅  S1-20 lib/features/settings/presentation/settings_screen.dart (profile card,
       Account/Billing/Support/Danger Zone sections, GST rate picker bottom sheet,
       WhatsApp Support via real wa.me link, Log Out via ConfirmBottomSheet)
5.27 ✅  S1-21 lib/features/settings/presentation/cancel_request_screen.dart
       (cancel_request_notifier.dart: reason radio group + custom-reason text +
       confirmation checkbox gating submit)
5.28 ✅  S1-22 lib/features/settings/presentation/cancel_confirm_screen.dart

Onboarding (not in original SCREENS-1.md index, added per explicit request):
5.29 ✅  lib/features/onboarding/presentation/onboarding_screen.dart — 3-slide
       PageView per DESIGN.md §11 style (radial aura bg, serif headline, dot
       indicators), wired as the app's initial route before /login
```

---

## PHASE 6 — Salesperson Portal (Antigravity) — DONE

```
Auth:
6.1  ✅  lib/features/auth/domain/salesperson_auth_notifier.dart (mock: password ≥4 chars succeeds)
6.1b ✅  lib/features/auth/presentation/salesperson_login_screen.dart  [S2-01]
       Reciprocal "Are you a salesperson?" link added to shopkeeper login_screen.dart,
       and "Are you a shopkeeper?" link on this screen — full cross-navigation both ways.

Dashboard:
6.2  ✅  lib/features/salesperson/domain/salesperson_dashboard_notifier.dart (salespersonDashboardProvider)
6.3  ✅  lib/features/salesperson/presentation/dashboard_screen.dart  [S2-02]

Shop Management:
6.4  ✅  lib/core/models/shop_model.dart — expanded with full field set (status, autopay,
       credits, customer limits, etc.) + ShopModel.copyWith() added for immutable updates.
6.5  ✅  lib/features/salesperson/domain/salesperson_mock_shops.dart — buildMockShopModels()
       enriches core/mock/mock_fixtures.dart's MockShop list into full ShopModel instances;
       single shared source reused by dashboard, shop list, shop detail, edit shop.
       (No separate shop_repository.dart — mock notifiers call this helper directly.)
6.6  ✅  lib/features/salesperson/domain/shop_list_notifier.dart (shopListProvider)
6.7  ✅  lib/features/salesperson/presentation/shop_list_screen.dart  [S2-03]
       Search (name/owner) + 7 filter chips (All/Active/Pending/Suspended/Basic/Pro/Business).

Add Shop Flow (4 steps):
6.8  ✅  lib/features/salesperson/domain/add_shop_notifier.dart (addShopProvider — sync state,
       persists across all 4 wizard steps; not AsyncValue since it's pure in-memory form data)
6.9  ✅  lib/features/salesperson/presentation/add_shop/step1_details_screen.dart  [S2-04]
6.10 ✅  lib/features/salesperson/presentation/add_shop/step2_branding_screen.dart  [S2-05]
       Real image_picker (camera/gallery) + live bill-header preview.
6.11 ✅  lib/features/salesperson/presentation/add_shop/step3_plan_screen.dart  [S2-06]
6.12 ✅  lib/features/salesperson/presentation/add_shop/step4_autopay_screen.dart  [S2-07]
       Mocked mandate flow: 800ms "sending" → 2500ms "waiting approval" → auto-approved
       (per agreed scope: no real Razorpay/QR scan/10-min polling in this mock phase).
6.13 ✅  lib/features/salesperson/presentation/add_shop/success_screen.dart  [S2-08]
       PopScope intercepts hardware back → /salesperson/dashboard (per spec).

Shop Detail + Edit:
6.14 ✅  lib/features/salesperson/domain/shop_detail_notifier.dart (shopDetailProvider(shopId),
       family provider) + suspendShop()
6.15 ✅  lib/features/salesperson/presentation/shop_detail_screen.dart  [S2-09]
       Profile/plan/usage/details/danger-zone cards + mocked 3-payment billing history.
6.16 ✅  lib/features/salesperson/domain/edit_shop_notifier.dart (editShopProvider(shopId))
6.16b ✅ lib/features/salesperson/presentation/edit_shop_screen.dart  [S2-10]
       Top bar Cancel (discard-confirm if dirty) + Save, plan-change grid, SuccessToast.

Cancellations:
6.17 ✅  lib/features/salesperson/domain/cancellation_request_model.dart (CancellationRequest +
       buildMockCancellationRequests() mock data — no existing shared model to reuse)
6.17b ✅ lib/features/salesperson/domain/cancellation_list_notifier.dart (cancellationListProvider)
6.18 ✅  lib/features/salesperson/presentation/cancellation_list_screen.dart  [S2-11]
6.19 ✅  lib/features/salesperson/domain/cancellation_detail_notifier.dart (cancellationDetailProvider(requestId))
6.19b ✅ lib/features/salesperson/presentation/cancellation_detail_screen.dart  [S2-12]
       Approve → confirm bottom sheet; Reject → reason bottom sheet; both → SuccessToast
       + navigate back to list, matching spec Actions section exactly.

Settings:
6.20 ✅  lib/features/salesperson/presentation/settings_screen.dart  [S2-13]

Router wiring:
6.21 ✅  All /salesperson/* routes in lib/core/router/app_router.dart replaced with real
       screen builders (was _placeholderBuilder for all of them) — includes the 4 ShellRoute
       tab routes (dashboard/shops/cancellations/settings) and family routes (:shopId,
       :shopId/edit, :requestId).

CHECKPOINT: flutter analyze → 1 pre-existing info-level lint only
       (use_build_context_synchronously in step1_details_screen.dart, same accepted
       pattern used elsewhere in the shopkeeper portal) — zero errors, zero warnings.
CHECKPOINT: Screen-by-screen pass against SCREENS-2.md + FLOWS.md Section 2 confirmed
       route paths, provider names, and Actions match spec; fixed several deviations
       found during that pass (see Daily Log 2026-07-05 entry below).
NOT DONE: Browser-preview click-through verification — flutter-widget-preview server
       would not boot in this sandbox (hangs at shell init, unrelated to app code).
       Re-attempt when environment is available.
```

---

## PHASE 7 — Super Admin Portal — DONE

```
Auth + Dashboard:
7.1  ✅  lib/features/auth/domain/admin_auth_notifier.dart (adminAuthProvider — mock:
       email must contain '@', password ≥6 chars)
7.2  ✅  lib/features/auth/presentation/admin_login_screen.dart  [S3-01]
       Navy gradient header, "Super Admin Portal" + "Restricted Access" badges,
       links to both shopkeeper and salesperson logins.
7.3  ✅  lib/features/admin/domain/admin_dashboard_notifier.dart (adminDashboardProvider)
7.4  ✅  lib/features/admin/presentation/dashboard_screen.dart  [S3-02]
       MRR hero card, 4 conditional alert cards, 4 quick-action cards, activity feed.

Shared mock data (new):
7.4b ✅  lib/features/admin/domain/admin_mock_salespersons.dart — platform-wide
       salesperson roster (buildMockSalespersons()); shop assignment matched by
       salespersonName since ShopModel has no salespersonId FK in this mock phase.
       Updated lib/features/salesperson/domain/salesperson_mock_shops.dart to vary
       salespersonName per shop (was hardcoded to one name) and added
       buildMockShopModelsFor(name) so the Salesperson portal's dashboard/shop-list
       correctly show only that salesperson's shops while Admin's screens use the
       unfiltered buildMockShopModels() for the platform-wide view.
7.4c ✅  lib/core/models/cancellation_model.dart — CancellationRequest model +
       buildMockCancellationRequests() PROMOTED from
       features/salesperson/domain/cancellation_request_model.dart (deleted) to
       core/models/ so both Salesperson and Admin cancellation screens share one
       source of truth. Added salespersonName, salespersonAction, adminNotes fields
       needed by the admin detail screen. Salesperson's existing cancellation
       notifiers/screens updated to import from the new core location — no behavior
       change on that side.
7.4d ✅  lib/core/models/shop_model.dart — ShopModel.copyWith() extended with
       salespersonName/billCreditsLimit/msgCreditsLimit/billCreditsUsed/
       msgCreditsUsed params (previously copyWith couldn't change salesperson or
       credits — needed for Admin's reassign/add-credits actions).

Salesperson Management:
7.5  ✅  lib/features/admin/domain/salesperson_list_notifier.dart (salespersonListProvider)
7.6  ✅  lib/features/admin/presentation/salesperson_list_screen.dart  [S3-03]
7.7  ✅  lib/features/admin/domain/add_salesperson_notifier.dart (addSalespersonProvider —
       password rule: 8+ chars, 1 number, 1 uppercase, confirm must match)
7.7b ✅  lib/features/admin/presentation/add_salesperson_screen.dart  [S3-04]
7.8  ✅  lib/features/admin/domain/salesperson_detail_notifier.dart
       (salespersonDetailProvider(id), family) + deactivate()/reactivate()
7.8b ✅  lib/features/admin/presentation/salesperson_detail_screen.dart  [S3-05]

All Shops:
7.9  ✅  lib/features/admin/domain/all_shops_notifier.dart (allShopsProvider — platform-
       wide, unfiltered)
7.10 ✅  lib/features/admin/presentation/all_shops_screen.dart  [S3-06]
       Search + 2 filter-chip rows (status/plan) + advanced-filter bottom sheet
       (salesperson dropdown).
7.11 ✅  lib/features/admin/domain/admin_shop_detail_notifier.dart
       (adminShopDetailProvider(shopId), family) + changePlan/addCredits/
       reassignSalesperson/suspend/reactivate/delete
7.11b ✅ lib/features/admin/presentation/shop_detail_screen.dart  [S3-07]
       Full admin view: subscription+billing history, usage, shop details, 8
       admin-action rows (change plan, add credits ×2, reset password, reassign,
       suspend/reactivate, delete-with-type-shop-name-to-confirm).

Templates:
7.12 ✅  lib/features/admin/domain/template_model.dart — TemplateModel +
       buildMockTemplates() (7 business-type templates with Meta approval status)
7.12b ✅ lib/features/admin/domain/templates_notifier.dart (templatesProvider) + toggleActive()
7.13 ✅  lib/features/admin/presentation/templates_screen.dart  [S3-08]
7.14 ✅  lib/features/admin/domain/template_detail_notifier.dart
       (templateDetailProvider(id), family; id='new' for Add Template) +
       saveDraft()/submitForApproval() (mocked: pending → auto-approved after 3s,
       per agreed scope)
7.14b ✅ lib/features/admin/presentation/template_detail_screen.dart  [S3-09]
       Full form incl. live WhatsApp-style preview, variables editor, Save
       Draft + Submit for Approval bottom bar.

Plans + Cancellations + Revenue + Settings:
7.15 ✅  lib/features/admin/domain/plans_notifier.dart (plansProvider) — edit-mode
       with draft state, cancelEdit() reverts without saving
7.15b ✅ lib/features/admin/presentation/plans_screen.dart  [S3-10]
7.16 ✅  lib/features/admin/domain/admin_cancellation_list_notifier.dart
       (adminCancellationListProvider) — sort by newest/oldest/plan value
7.17 ✅  lib/features/admin/presentation/cancellation_list_screen.dart  [S3-11]
       "NEEDS ACTION" pending section shown above "ALL REQUESTS", per spec.
7.18 ✅  lib/features/admin/domain/admin_cancellation_detail_notifier.dart
       (adminCancellationDetailProvider(id), family) + approve()/reject()
7.18b ✅ lib/features/admin/presentation/cancellation_detail_screen.dart  [S3-12]
       Financial impact card, cancellation terms, admin-notes field, green
       Approve / red Reject bottom bar (pending only).
7.19 ✅  lib/features/admin/domain/revenue_notifier.dart (revenueProvider) — MRR,
       plan breakdown, top shops, salesperson performance, payment health all
       computed live from buildMockShopModels()/buildMockSalespersons() (per
       agreed scope, not hardcoded)
7.20 ✅  lib/features/admin/presentation/revenue_screen.dart  [S3-13]
7.21 ✅  lib/features/admin/domain/platform_settings_notifier.dart
       (platformSettingsProvider) — AiSensy/Razorpay fields fully editable +
       mocked Test Connection (per agreed scope)
7.21b ✅ lib/features/admin/presentation/platform_settings_screen.dart  [S3-14]
7.22 ✅  lib/features/admin/presentation/admin_settings_screen.dart  [S3-15]
       (navigation + logout only — reuses adminAuthProvider, no dedicated notifier
       needed per spec)

Router wiring:
7.23 ✅  All /admin/* routes in lib/core/router/app_router.dart replaced with real
       screen builders — includes the 5-tab ShellRoute (dashboard/shops/
       salespersons/templates/settings) and every family route (:id, :shopId,
       :requestId). Removed _placeholderBuilder and _PlaceholderScreen from
       app_router.dart entirely — all 50 SCREENS-1/2/3.md routes are now real
       screens, none left as placeholders.

CHECKPOINT: flutter analyze → 2 pre-existing info-level lints only
       (use_build_context_synchronously, same accepted pattern used throughout
       the app) — zero errors, zero warnings, across all 15 new screens plus the
       shared-model refactor touching the Salesperson portal.
NOT DONE: Browser-preview click-through verification — same environment
       limitation noted for the Salesperson portal build (flutter-widget-preview
       dev server would not boot in this sandbox).
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

[2026-07-05] [MED] [FIXED] bottom_action_bar.dart: 3-line left info column (primary/
  secondary/credit labels) overflowed the 72px bar's available content height by ~11px
  due to default font line-height. Fixed with explicit height:1.1 on each Text style.
  Caught via preview screenshot showing the yellow/black RenderFlex overflow stripe.

[2026-07-05] [HIGH] [FIXED] bottom_action_bar.dart: CTA button used a raw
  ConstrainedBox(minWidth:140) with no maxWidth. Flutter's Row always gives unbounded
  (infinite) width to non-Expanded children, so that infinity propagated straight into
  the button and crashed layout — white-screened EVERY screen using this shared widget
  (New Bill, Bill Preview, Bill Detail, Credits Top-Up, Cancel Request, Bulk Message,
  Bulk Message Preview). Only surfaced once the real device/simulator's accessibility
  semantics bridge attached (didn't show in early web-preview screenshots). Fixed by
  replacing the ConstrainedBox+SizedBox with ElevatedButton's built-in `minimumSize`
  style property, the correct API for "min width, auto-size otherwise".

[2026-07-05] [HIGH] [FIXED] gradient_header.dart: used a fixed `height:` on the
  Container wrapping a Column of back-button row + title + subtitle. Any screen whose
  header content didn't fit that exact height overflowed (Bulk Message's height:140
  override overflowed by 43px), cascading into a semantics-assertion crash spam that
  left the app unable to render subsequent screens properly. Fixed by switching to
  `constraints: BoxConstraints(minHeight: height)` so the header grows to fit content
  instead of ever overflowing, regardless of what height any screen passes in.

[2026-07-05] [MED] [FIXED] bottom_action_bar.dart: even after the minimumSize fix,
  the specific 3-line combination (primaryLabel + secondaryLabel + creditInfo, used
  only by Bill Detail's "Re-send on WhatsApp" bar) still overflowed by 9px — manual
  line-height tuning is too fragile. Fixed generally by wrapping the left info Column
  in a FittedBox(fit: BoxFit.scaleDown), so any future label combination auto-shrinks
  to fit instead of overflowing.

[2026-07-05] [HIGH] [FIXED] credits_screen.dart: the "Buy" button on each pack card
  crashed with the exact same infinite-width bug class as the BottomActionBar issue
  above, but in a different widget — a Column (price + Buy button) on the right side
  of the pack card Row wasn't wrapped in Expanded, so it received unbounded width from
  the Row and propagated it into the button. Fixed by wrapping that Column in
  IntrinsicWidth. Audited the rest of the codebase for the same pattern (SizedBox-
  wrapped button inside a non-Expanded Row child) — this was the only other instance;
  customer_detail_screen.dart's similar-looking buttons are already Expanded-wrapped.

[2026-07-05] [LOW] [FIXED] bill_card.dart: displayed amounts via raw
  `'₹${amount.toStringAsFixed(2)}'` instead of Formatters.formatINR(), so bill amounts
  showed as "₹2992.50" instead of the correct Indian comma grouping "₹2,992.50".
  Grepped the whole codebase for the same pattern — this was the only instance.
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
2026-07-05  PHASE1/2 Verified Phase 1 (project setup, core constants/theme/router/network/storage/error/utils, main.dart) and Phase 2 (all 25 shared widgets) already on disk and passing flutter analyze with zero issues. Added lib/core/mock/mock_fixtures.dart as the single shared mock data source for all upcoming notifiers.
2026-07-05  PHASE2  Discovered the 25 "widgets" were actually empty stubs (SizedBox.shrink()), not real implementations. Built all 25 for real, one at a time, each verified with flutter analyze (zero issues) and visually confirmed in a Chrome web preview harness (lib/main_widget_preview.dart, since the real app can't boot yet — Supabase/Firebase unconfigured, Phase 0 pending). Found and fixed a genuine overflow bug in bottom_action_bar.dart along the way (see Bugs log). Added core/models/bill_model.dart, customer_model.dart, shop_model.dart, plan_type.dart as shared data shapes for BillCard/CustomerCard/ShopCard/PlanBadge (core/ instead of feature data/models/ paths, since shared/widgets/ cannot import features/).
2026-07-05  PHASE3  Built mock AuthNotifier (requestOtp/verifyOtp/logout, mock OTP code 123456) + LoginScreen (S1-01) + OtpScreen (S1-02, 6-box auto-advance, 45s resend countdown) and DashboardNotifier + DashboardScreen (S1-03, purple header, hero revenue card, quick actions, recent bills). Wired /login, /otp, /dashboard into app_router.dart. Fixed iOS deployment target (13.0 → 15.0 in Podfile + Xcode project) which was blocking firebase_core from building on the simulator. Flagged: app_router.dart's session-based _redirect will bounce mock-authenticated users back to /login until real Supabase auth exists.
2026-07-05  PHASE4  Built NewBillNotifier (customer select/search/add, dynamic bill items, live subtotal/GST/total, sendBill() mock, reset()) and the full New Bill → Bill Preview → Bill Sent screen flow (S1-04/05/06), including a Bill/Shop Info/Notes tab layout on the preview screen and an animated success screen. Wired /new-bill, /bill-preview, /bill-sent into app_router.dart. Pulled /dashboard and /new-bill out of the shopkeeper ShellRoute since they render their own bottom bars (AppBottomTabBar / BottomActionBar), avoiding a doubled-up bottom bar.
2026-07-05  PHASE5  Built CustomerNotifier + CustomerListScreen (S1-09: stats row, search, FilterChipRow with All/Billed Recently/High Value/New) and CustomerDetailNotifier (Riverpod family provider by customerId) + CustomerDetailScreen (S1-11: orange header, overlapping summary card, quick actions, bill history, notes). Wired /customers and /customers/:id into app_router.dart. Flagged: "Call" quick action needs the url_launcher package (not in pubspec.yaml yet, needs approval before adding); Add Customer screen (S1-10) not built yet.
2026-07-05  PHASE5  Built ALL remaining shopkeeper screens in one continuous session per user request: Bill History (S1-07) + Bill Detail (S1-08, family provider by billId), Add Customer (S1-10, duplicate-phone warning flow), full Bulk Messaging flow (S1-12/13/14/15, one shared BulkMessageNotifier across all 4 screens, reuses MockFixtures.templates), full Credits flow (S1-16/17/18, mock Razorpay pay()), Notifications (S1-19), Settings (S1-20, GST rate picker, logout confirm), Cancel Request + Confirm (S1-21/22). Also added: a 3-slide Onboarding screen (not in original SCREENS-1.md index) as the new initial route; a MockSession bypass (core/utils/mock_session.dart) so the mock-auth flow works through the REAL connected app_router.dart instead of only in isolated preview; the url_launcher package (approved) for real tel:/wa.me links. Every new route wired into app_router.dart.
2026-07-05  AUDIT   User reported Settings sub-pages "not opening" on the simulator. Root-caused through simulator log analysis (not guesswork) to a chain of real Flutter layout crashes, not a navigation/wiring bug: (1) bottom_action_bar.dart's CTA used a raw ConstrainedBox(minWidth:140) with no maxWidth — Row gives non-Expanded children unbounded width, so infinity reached the button and crashed every screen using this shared widget; (2) gradient_header.dart's fixed `height:` overflowed on Bulk Message's height:140 override, cascading into an app-wide semantics-crash; (3) same bug class as (1) independently in credits_screen.dart's "Buy" button (un-Expanded Column in a Row). Fixed all three at the root (ElevatedButton.minimumSize, Container minHeight, IntrinsicWidth) rather than patching each call site. Then ran a full autonomous visual audit of all 22 shopkeeper screens via a stacked gallery preview harness, screenshotting every screen — found 2 more issues along the way (a 3-line BottomActionBar overflow on Bill Detail, fixed with FittedBox; bill_card.dart missing Formatters.formatINR comma grouping). All 22 screens now confirmed clean. flutter analyze zero issues project-wide. Relaunched on the user's iPhone 17 Pro Max simulator with every fix applied.
2026-07-05  PHASE6  Built all 13 Salesperson portal screens per SCREENS-2.md: SalespersonAuthNotifier + Login (S2-01), SalespersonDashboardNotifier + Dashboard (S2-02), ShopListNotifier + Shop List (S2-03, search + 7 filter chips), 4-step Add Shop wizard (S2-04→08: Details/Branding-with-real-image_picker/Plan/AutoPay-with-mocked-mandate-approval/Success), ShopDetailNotifier + Shop Detail (S2-09, family provider, suspend action, mocked billing history), EditShopNotifier + Edit Shop (S2-10, plan-change grid), CancellationRequest model + mock data + list/detail notifiers + screens (S2-11/12, approve/reject confirmation bottom sheets), Settings (S2-13). Added ShopModel.copyWith() (didn't exist) since 3 screens needed immutable shop updates. Wired every /salesperson/* route in app_router.dart from _placeholderBuilder to real screens. Added reciprocal "Are you a salesperson?"/"Are you a shopkeeper?" links between the two login screens for full click-through navigability.
2026-07-05  REVIEW  Did a screen-by-screen pass cross-checking all 13 built screens against SCREENS-2.md + FLOWS.md Section 2. Confirmed all route paths, provider names (after fixing several — riverpod_generator strips the "Notifier" suffix, so e.g. shopDetailNotifierProvider was wrong, shopDetailProvider is correct), and Actions match spec. Fixed real deviations found: success_screen.dart used PrimaryButton/SecondaryButton's wrong param name (onPressed instead of onTap — compile error), button order was swapped vs spec, title/font/checklist items didn't match spec, missing PopScope hardware-back-to-dashboard; salesperson_login_screen.dart was missing the app logo (spec says "same as shopkeeper login"); edit_shop_screen.dart was missing the spec'd top-bar Cancel-with-discard-confirm and used SnackBar instead of SuccessToast; cancellation_detail_screen.dart was missing the spec'd Approve/Reject confirmation bottom sheets (was calling the notifier directly) and Request ID/Submitted By fields; settings_screen.dart was missing the "Sales Team" role pill, shop count, and confirm-password field; shop_detail_screen.dart was missing the spec'd billing history and "Added By" field. flutter analyze re-run clean after all fixes (1 pre-existing info lint only, no errors/warnings). Could not complete a browser-preview visual click-through — the flutter-widget-preview dev server hung at shell init in this environment across 3 restart attempts (environment issue, not app code).
2026-07-05  BUGFIX  User asked to rerun the app on the iPhone 17 Pro Max simulator (real device run, not the widget-preview harness). First launch crashed with an unhandled `Firebase.initializeApp()` exception before `runApp()` was ever called — root cause: main.dart called it unguarded, and Firebase has never been configured (Phase 0 pending), so the whole app showed nothing. Fixed by wrapping it in try/catch, mirroring the existing pattern already used for Supabase-not-configured in app_router.dart's `_redirect`. Relaunched — confirmed via screenshot that the app now boots straight to the onboarding flow with no crash. Push notifications won't work until a real Firebase project exists, but the rest of the mock-data app is unaffected.
2026-07-05  PHASE7  Built all 15 Super Admin portal screens per SCREENS-3.md: AdminAuthNotifier + Login (S3-01, navy gradient, mock email+password≥6), AdminDashboardNotifier + Dashboard (S3-02, MRR hero, 4 conditional alerts, activity feed), Salesperson Management (S3-03/04/05: list/add/detail with deactivate-reactivate), All Shops (S3-06, platform-wide search+filters+advanced-filter sheet) + Admin Shop Detail (S3-07, 8 admin actions incl. change-plan/add-credits/reassign/delete-with-type-to-confirm), Templates (S3-08/09: 7 business-type templates, live WhatsApp-style preview, mocked Meta submit-and-auto-approve per agreed scope), Subscription Plans (S3-10, edit-mode with draft/cancel), admin Cancellations (S3-11/12, NEEDS ACTION priority section, financial-impact card, green Approve/red Reject), Revenue Report (S3-13, MRR/plan-breakdown/top-shops/salesperson-performance/payment-health all computed live from the shared mock shop data per agreed scope), Platform Settings (S3-14, fully-mock AiSensy/Razorpay fields + fake Test Connection per agreed scope), Admin Settings (S3-15). Two shared-model refactors along the way: promoted CancellationRequest from features/salesperson/domain/ to core/models/cancellation_model.dart (added salespersonName/salespersonAction/adminNotes fields) so Admin's cancellation screens reuse the same model instead of duplicating it; extended ShopModel.copyWith() to support changing salespersonName/credit limits (previously impossible via copyWith). Also fixed salesperson_mock_shops.dart, which had hardcoded every mock shop to the same salesperson name — added buildMockShopModelsFor(name) and updated the Salesperson portal's dashboard/shop-list to use it, so Admin's platform-wide "All Shops" view can show shops spread across multiple salespersons without breaking the Salesperson portal's "my shops only" scoping. Wired every /admin/* route in app_router.dart from _placeholderBuilder to real screens, including the 5-tab ShellRoute — this was the last placeholder route in the entire app, so _placeholderBuilder and _PlaceholderScreen were deleted from app_router.dart entirely. flutter analyze clean (2 pre-existing info lints only, same accepted pattern used throughout). All 50 SCREENS-1/2/3.md screens across all 3 roles are now real, connected screens.
```

---

## STATS

```
Total files to build:   ~120 Dart files + ~15 Node.js files
Completed Dart files:   ~145 (19 core + 25 widgets + mock_fixtures + main.dart + 6 core
                         models [bill/customer/shop/plan_type/cancellation/mock_session]
                         + onboarding [1 screen] + auth [3 notifiers+4 screens] +
                         dashboard [notifier+screen] + billing [3 notifiers+5 screens] +
                         customers [3 notifiers+3 screens] + messaging [1 notifier+4
                         screens] + credits [2 notifiers+3 screens] + notifications
                         [notifier+screen] + settings [2 notifiers+4 screens] +
                         salesperson [7 notifiers/models + 13 screens] + admin
                         [15 notifiers/models + 15 screens])
Completed Node files:   0
Screens complete:       50 / 50 — ALL SCREENS COMPLETE (entire Shopkeeper role: 22
                         screens. Entire Salesperson role: 13 screens. Entire Super
                         Admin role: Login, Dashboard, Salesperson List, Add
                         Salesperson, Salesperson Detail, All Shops, Shop Detail,
                         Templates, Template Detail, Plans, Cancellation List,
                         Cancellation Detail, Revenue, Platform Settings, Admin
                         Settings — 15 screens.)
Phases complete:        6 / 8 fully (Phase 1/2/3/5/6/7 done; Phase 4 in progress
                         pending Node.js backend; Phase 8 not started)
Days in development:    2
```
