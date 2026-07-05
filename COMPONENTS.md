# COMPONENTS.md — Billing Project
# Shared Widget Specifications
# Version 1.0 | One Stop Solutions | July 2026
#
# This file documents every reusable widget in lib/shared/widgets/
# For each widget:
#   - Exact file path
#   - Props (parameters) with types and defaults
#   - All visual states
#   - Design tokens used (from DESIGN.md)
#   - Exact Flutter code structure
#   - Usage examples from screens
#   - What NOT to do
#
# Read alongside: DESIGN.md · CLAUDE.md · SCREENS-1/2/3.md

---

## CRITICAL RULE

Before building any widget in a feature folder, check this file first.
If the widget already exists in lib/shared/widgets/ → USE IT. Do NOT rebuild it.
If it does not exist → build it here in shared/widgets/ first, then use it.
NEVER duplicate a shared widget inside a feature folder.

---

## WIDGET INDEX

```
C-01   PrimaryButton           ← Orange pill CTA button
C-02   SecondaryButton         ← Outlined ghost pill button
C-03   DarkPillButton          ← Dark filled pill (#1A1A1A)
C-04   SmallActionButton       ← Small inline orange button (e.g. "Add", "Buy")
C-05   AppCard                 ← Standard white card container
C-06   GradientHeader          ← Top gradient header (purple / orange / sky / navy)
C-07   FilterChipRow           ← Horizontal scrollable filter chips
C-08   FilterChip              ← Individual filter chip
C-09   BottomActionBar         ← Sticky bottom bar (info left + CTA right)
C-10   BottomTabBar            ← Main navigation tab bar
C-11   EmptyState              ← Illustration + message + optional CTA
C-12   LoadingOverlay          ← Full-screen loading state
C-13   SuccessToast            ← Green pill toast notification
C-14   SectionHeader           ← "Title →" section label with optional arrow
C-15   IconContainer           ← Rounded square bg + icon
C-16   CreditBadge             ← Credit count display (color by status)
C-17   StatusBadge             ← Colored pill for status display
C-18   PlanBadge               ← Plan name pill (Basic/Pro/Business)
C-19   BillCard                ← Bill list row card
C-20   CustomerCard            ← Customer list row card
C-21   ShopCard                ← Shop list row card (salesperson/admin)
C-22   InputField              ← Styled text form field
C-23   StepProgressBar         ← Multi-step flow progress indicator
C-24   ConfirmBottomSheet      ← Reusable confirmation bottom sheet
C-25   InfoBanner              ← Colored left-border info/warning/error banner
```

Total: 25 shared widgets.

---

## DESIGN TOKENS (used across all components)

```dart
// lib/core/constants/app_colors.dart
class AppColors {
  static const kOrange      = Color(0xFFE8680A);  // CTAs, active states
  static const kOrangeDark  = Color(0xFFC8560A);  // pressed state
  static const kOrangeLight = Color(0xFFFFF3E8);  // orange tint bg
  static const kPurple      = Color(0xFF6B4EFF);  // home header, premium
  static const kGreen       = Color(0xFF16A34A);  // success, sent, free
  static const kGreenLight  = Color(0xFFF0FDF4);  // green tint bg
  static const kBlue        = Color(0xFF2563EB);  // info, links, codes
  static const kBlueLight   = Color(0xFFEFF6FF);  // blue tint bg
  static const kDark        = Color(0xFF1A1A1A);  // primary text
  static const kSecondary   = Color(0xFF555555);  // secondary text
  static const kMuted       = Color(0xFF999999);  // muted/placeholder
  static const kBorderGray  = Color(0xFFE5E5E5);  // borders
  static const kBgPage      = Color(0xFFF5F5F5);  // page background
  static const kBgCard      = Color(0xFFFFFFFF);  // card background
  static const kError       = Color(0xFFDC2626);  // error states
  static const kWarning     = Color(0xFFF59E0B);  // warning states
}

// lib/core/constants/app_spacing.dart
class AppSpacing {
  static const s4 = 4.0;   static const s8 = 8.0;
  static const s12 = 12.0; static const s16 = 16.0;
  static const s20 = 20.0; static const s24 = 24.0;
  static const s32 = 32.0; static const s48 = 48.0;
}

// lib/core/constants/app_typography.dart
class AppTypography {
  static const displaySerif = TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 32, fontWeight: FontWeight.w700);
  static const h1Serif      = TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 26, fontWeight: FontWeight.w700);
  static const h2           = TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A));
  static const h3           = TextStyle(fontFamily: 'Inter', fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A));
  static const bodyLarge    = TextStyle(fontFamily: 'Inter', fontSize: 15, color: Color(0xFF555555));
  static const body         = TextStyle(fontFamily: 'Inter', fontSize: 14, color: Color(0xFF555555));
  static const bodySmall    = TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFF555555));
  static const labelSmall   = TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.8, color: Color(0xFF999999));
  static const caption      = TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xFF999999));
  static const priceLarge   = TextStyle(fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5, color: Color(0xFF1A1A1A));
  static const price        = TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A));
  static const buttonLabel  = TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white);
  static const buttonSubLabel = TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xCCFFFFFF));
  static const monoAmount   = TextStyle(fontFamily: 'DMMono', fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A));
}
```

---

## C-01 — PrimaryButton

```
File:    lib/shared/widgets/primary_button.dart
Purpose: The main orange pill CTA. Used for ALL primary actions.
         "Send Bill", "Continue", "Save", "Pay Now", "Search →"
```

### Props

```dart
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;       // null = disabled state
  final bool isLoading;            // shows spinner, default: false
  final bool isFullWidth;          // default: true
  final double? width;             // custom width if isFullWidth false
  final IconData? leadingIcon;     // optional icon before label
  final IconData? trailingIcon;    // optional icon after label
  final String? subLabel;          // small text below main label
}
```

### Visual States

```
ENABLED:
  bg: AppColors.kOrange | text: white, Inter 15px 600
  border-radius: 100px | height: 52px | width: 100%

DISABLED (onTap == null):
  bg: #CCCCCC | text: white (same)

LOADING (isLoading true):
  bg: AppColors.kOrange | shows: CircularProgressIndicator (white, 20px, strokeWidth 2)

PRESSED:
  bg: AppColors.kOrangeDark | scale: 0.98
```

### Code Structure

```dart
@override
Widget build(BuildContext context) {
  return SizedBox(
    width: isFullWidth ? double.infinity : width,
    height: 52,
    child: ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: onTap == null ? const Color(0xFFCCCCCC) : AppColors.kOrange,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        elevation: 0,
      ),
      child: isLoading
        ? const SizedBox(width: 20, height: 20,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(label, style: AppTypography.buttonLabel),
                if (subLabel != null)
                  Text(subLabel!, style: AppTypography.buttonSubLabel),
              ]),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, size: 18, color: Colors.white),
              ],
            ],
          ),
    ),
  );
}
```

### Usage Examples

```dart
PrimaryButton(label: 'Send on WhatsApp', onTap: handleSend, leadingIcon: Icons.whatsapp)
PrimaryButton(label: 'Sending...', isLoading: state.isLoading, onTap: null)
PrimaryButton(label: 'Preview Bill →', onTap: canPreview ? handlePreview : null)
PrimaryButton(label: 'Send on WhatsApp', subLabel: '1 bill credit will be used', onTap: handleSend)
```

### DON'T

```
❌ Never use for destructive actions — use red text button instead
❌ Never change the orange color — always AppColors.kOrange
❌ Never hardcode height — always 52px via SizedBox
```

---

## C-02 — SecondaryButton

```
File:    lib/shared/widgets/secondary_button.dart
Purpose: Ghost outlined pill for secondary actions.
         "View History", "Change Date", "Dismiss", "Cancel"
```

### Props

```dart
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;          // default: false
  final bool isFullWidth;        // default: true
  final Color? borderColor;      // default: AppColors.kBorderGray
  final Color? textColor;        // default: AppColors.kDark
  final IconData? leadingIcon;
}
```

### Visual States

```
ENABLED:
  bg: #FFFFFF | border: 1.5px solid #E5E5E5 | text: #1A1A1A, Inter 14px 500
  border-radius: 100px | height: 48px

DISABLED: bg: #FFFFFF | border: 1.5px solid #EEEEEE | text: #CCCCCC

RED VARIANT (reject/cancel): borderColor: kError + textColor: kError
```

### Usage

```dart
SecondaryButton(label: 'View Bill History', onTap: () => context.go('/bill-history'))
SecondaryButton(label: 'Reject Request', onTap: handleReject,
  borderColor: AppColors.kError, textColor: AppColors.kError)
```

---

## C-03 — DarkPillButton

```
File:    lib/shared/widgets/dark_pill_button.dart
Purpose: Dark filled pill for selected toggle state.
         "One Way" selected, "Free Modification" active tab.
```

### Props

```dart
class DarkPillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;    // true = dark bg; false = transparent + gray text
  final IconData? icon;
}
```

### Visual

```
SELECTED: bg #1A1A1A | text white, Inter 14px 600 | radius 100px | height 40px
UNSELECTED: transparent | text #555555, Inter 14px 400
```

### Usage

```dart
Row(children: [
  DarkPillButton(label: 'All Customers', isSelected: mode == 'all', onTap: () => setMode('all')),
  DarkPillButton(label: 'Select Manually', isSelected: mode == 'manual', onTap: () => setMode('manual')),
])
```

---

## C-04 — SmallActionButton

```
File:    lib/shared/widgets/small_action_button.dart
Purpose: Small inline button for card actions. "Add", "Buy", "Retry"
```

### Props

```dart
class SmallActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? backgroundColor;   // default: AppColors.kOrange
}
```

### Visual

```
bg: AppColors.kOrange | text: white, Inter 13px 600
border-radius: 8px (NOT pill) | height: 36px | padding: 0 16px
```

---

## C-05 — AppCard

```
File:    lib/shared/widgets/app_card.dart
Purpose: Universal white card container. Wraps any content.
         Used for form sections, list items, summary panels, info cards.
```

### Props

```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;         // default: EdgeInsets.all(16)
  final Color? backgroundColor;     // default: AppColors.kBgCard
  final double? borderRadius;       // default: 12.0
  final Color? borderColor;         // default: AppColors.kBorderGray
  final double? borderWidth;        // default: 1.0
  final VoidCallback? onTap;        // if set → InkWell tappable
  final BoxShadow? shadow;          // default: kShadowCard
  final Color? leftBorderColor;     // colored left accent (info/warning/error)
  final double? leftBorderWidth;    // default: 4.0 if leftBorderColor set
  final EdgeInsets? margin;
}
```

### Shadow Token

```dart
const kShadowCard = BoxShadow(
  color: Color(0x0F000000),   // black 6%
  blurRadius: 4,
  offset: Offset(0, 1),
);
```

### Visual Variants

```
STANDARD:     bg #FFFFFF | border 1px #E5E5E5 | radius 12 | kShadowCard
TAPPABLE:     standard + InkWell (splashColor: kOrangeLight 30%)
INFO:         leftBorderColor: kBlue | bg: kBlueLight
WARNING:      leftBorderColor: kWarning | bg: #FFFBEB
ERROR:        leftBorderColor: kError | bg: #FEF2F2
SUCCESS:      leftBorderColor: kGreen | bg: kGreenLight
```

### Code Structure

```dart
@override
Widget build(BuildContext context) {
  final card = Container(
    margin: margin,
    decoration: BoxDecoration(
      color: backgroundColor ?? AppColors.kBgCard,
      borderRadius: BorderRadius.circular(borderRadius ?? 12),
      border: Border(
        left: leftBorderColor != null
            ? BorderSide(color: leftBorderColor!, width: leftBorderWidth ?? 4)
            : BorderSide(color: borderColor ?? AppColors.kBorderGray, width: borderWidth ?? 1),
        top:    BorderSide(color: borderColor ?? AppColors.kBorderGray, width: borderWidth ?? 1),
        right:  BorderSide(color: borderColor ?? AppColors.kBorderGray, width: borderWidth ?? 1),
        bottom: BorderSide(color: borderColor ?? AppColors.kBorderGray, width: borderWidth ?? 1),
      ),
      boxShadow: [shadow ?? kShadowCard],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular((borderRadius ?? 12) - 1),
      child: Padding(padding: padding ?? const EdgeInsets.all(16), child: child),
    ),
  );
  if (onTap != null) {
    return Material(color: Colors.transparent,
      child: InkWell(onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        splashColor: AppColors.kOrangeLight.withOpacity(0.3),
        child: card));
  }
  return card;
}
```

### Usage Examples

```dart
// Standard form section
AppCard(child: Column(children: [
  Text('CUSTOMER', style: AppTypography.labelSmall), const SizedBox(height: 12),
  // form fields...
]))

// Tappable bill row
AppCard(onTap: () => context.go('/bill/${bill.id}'),
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  child: BillRowContent(bill: bill))

// Warning banner
AppCard(leftBorderColor: AppColors.kWarning, backgroundColor: const Color(0xFFFFFBEB),
  child: Row(children: [
    const Icon(Icons.warning_amber, color: AppColors.kWarning),
    const SizedBox(width: 12),
    Expanded(child: Text('Only 18 credits left')),
  ]))
```

---

## C-06 — GradientHeader

```
File:    lib/shared/widgets/gradient_header.dart
Purpose: Top gradient header — replaces AppBar on key screens.
```

### Props

```dart
class GradientHeader extends StatelessWidget {
  final GradientHeaderType type;     // required
  final String? title;
  final String? subtitle;
  final bool showBackButton;         // default: false
  final VoidCallback? onBack;        // default: context.pop()
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final double height;               // default: 180.0
  final Widget? bottomOverlap;       // widget overlapping header bottom
  final double overlapAmount;        // default: 20.0
}

enum GradientHeaderType { purple, orange, sky, navy }
```

### Gradient + Title Color Map

```dart
purple: [Color(0xFF6B4EFF), Color(0xFF8B6FFF), Colors.transparent] | title: white
orange: [Color(0xFFE8680A), Color(0xFFF07820), Colors.white]        | title: white
sky:    [Color(0xFFA8D4F5), Color(0xFFC8E8FF), Colors.transparent]  | title: #1A1A2E
navy:   [Color(0xFF1A1A2E), Color(0xFF2D2D4E), Colors.transparent]  | title: white
```

### Usage

```dart
GradientHeader(type: GradientHeaderType.orange, showBackButton: true,
  title: 'Bill Preview', trailingWidget: ShareButton())

GradientHeader(type: GradientHeaderType.purple,
  leadingWidget: MenuButton(), trailingWidget: CreditBadge(),
  bottomOverlap: HeroCard(), overlapAmount: 20)
```

---

## C-07 — FilterChipRow

```
File:    lib/shared/widgets/filter_chip_row.dart
Purpose: Horizontal scrollable row of filter chips.
```

### Props

```dart
class FilterChipRow extends StatelessWidget {
  final List<FilterChipData> chips;
  final String selectedValue;
  final ValueChanged<String> onSelect;
  final EdgeInsets? padding;          // default: horizontal 16px
  final bool allowMultiSelect;        // default: false
}

class FilterChipData {
  final String value;
  final String label;
  final int? count;
}
```

### Chip Visual

```
UNSELECTED: bg #FFFFFF | border 1px #E5E5E5 | text #555555 | radius 100px | h 34px | px 16px
SELECTED:   bg #1A1A1A | text white, Inter 13px 500 | radius 100px
```

### Usage

```dart
FilterChipRow(
  chips: [
    FilterChipData(value: 'all', label: 'All'),
    FilterChipData(value: 'today', label: 'Today'),
    FilterChipData(value: 'this_week', label: 'This Week'),
  ],
  selectedValue: state.filter,
  onSelect: (v) => ref.read(notifier.notifier).setFilter(v),
)
```

---

## C-08 — FilterChip (individual)

```
File:    lib/shared/widgets/filter_chip.dart
```

### Props

```dart
class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;
  final Color? selectedColor;   // default: #1A1A1A
}
```

---

## C-09 — BottomActionBar

```
File:    lib/shared/widgets/bottom_action_bar.dart
Purpose: Sticky bottom bar. Info on left, CTA on right.
         The most-used bottom pattern in the app (Ixigo "₹6828 | Continue").
```

### Props

```dart
class BottomActionBar extends StatelessWidget {
  final String? primaryLabel;      // left bold text ("₹2,992")
  final String? secondaryLabel;    // left muted text ("Suresh Kumar")
  final String ctaLabel;           // button label
  final VoidCallback? onCtaTap;    // null = disabled
  final bool isCtaLoading;         // default: false
  final Widget? ctaLeadingIcon;
  final String? creditInfo;        // "1 credit will be used"
  final Color? creditInfoColor;
  final bool showTopBorder;        // default: true
}
```

### Visual

```
Container: bg #FFFFFF | border-top 1px #F0F0F0 | height 72px | padding 12px 16px
Left:  primaryLabel (Inter 18px bold, #1A1A1A)
       secondaryLabel (Inter 12px, #999999)
       creditInfo (Inter 11px, creditInfoColor)
Right: PrimaryButton (auto-sized, min-width 140px)
```

### Usage

```dart
BottomActionBar(
  primaryLabel: '₹${bill.total}',
  secondaryLabel: bill.customerName,
  ctaLabel: 'Send on WhatsApp',
  onCtaTap: state.isLoading ? null : handleSend,
  isCtaLoading: state.isLoading,
  ctaLeadingIcon: const Icon(Icons.whatsapp, size: 18, color: Colors.white),
  creditInfo: '1 bill credit will be used',
  creditInfoColor: AppColors.kGreen,
)
```

---

## C-10 — BottomTabBar

```
File:    lib/shared/widgets/bottom_tab_bar.dart
Purpose: Main navigation tab bar. Different per role.
```

### Props

```dart
class AppBottomTabBar extends StatelessWidget {
  final List<TabBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
}

class TabBarItem {
  final IconData icon;
  final String label;
  final int? badgeCount;
}
```

### Visual

```
Container: bg #FFFFFF | border-top 1px #F0F0F0 | height 60px

ACTIVE:   icon+label kOrange | pill bg kOrangeLight | radius 100px | padding 4px 16px
INACTIVE: icon+label #999999 | no pill
```

### Tabs per Role

```
Shopkeeper (4): Home | New Bill | Customers | Settings
Salesperson (4): Dashboard | Shops | Cancellations | Settings
Super Admin (5): Dashboard | Shops | Salespersons | Templates | Settings
```

---

## C-11 — EmptyState

```
File:    lib/shared/widgets/empty_state.dart
Purpose: No-data screen — illustration + title + subtitle + optional CTA.
```

### Props

```dart
class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? ctaLabel;
  final VoidCallback? onCtaTap;
  final EmptyStateType type;
}

enum EmptyStateType { bills, customers, campaigns, notifications, shops, generic }
```

### Visual

```
Centered column | padding 48px horizontal
Illustration: 160px wide, gray (#E0E0E0) + orange accent, flat Ixigo style
Title: Inter 16px 600, #555555, center
Subtitle: Inter 14px, #CCCCCC, center
CTA: PrimaryButton, margin-top 24px
```

### Usage

```dart
EmptyState(
  type: EmptyStateType.bills,
  title: 'No bills yet',
  subtitle: 'Tap New Bill to send your first bill.',
  ctaLabel: 'Send a Bill',
  onCtaTap: () => context.go('/new-bill'),
)
```

---

## C-12 — LoadingOverlay

```
File:    lib/shared/widgets/loading_overlay.dart
Purpose: Full-screen or inline loading state for AsyncValue.loading().
```

### Props

```dart
class LoadingOverlay extends StatelessWidget {
  final bool isFullScreen;   // default: true
  final String? message;
  final Color? color;        // default: AppColors.kOrange
}
```

### Visual

```
FULL: bg #FFFFFF | center: CircularProgressIndicator (kOrange, strokeWidth 3)
      optional message below (Inter 14px, #999999)
INLINE: sized to parent | spinner centered
```

### Usage

```dart
state.when(
  loading: () => const LoadingOverlay(),
  data: (data) => ContentWidget(data: data),
  error: (e, _) => ErrorState(message: e.toString()),
)
```

---

## C-13 — SuccessToast

```
File:    lib/shared/widgets/success_toast.dart
Purpose: Temporary green pill toast for successful actions.
         Shown as overlay — not a widget in the tree.
```

### Props

```dart
class SuccessToast {
  static void show(BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    IconData icon = Icons.check_circle_outline,
    Color backgroundColor = AppColors.kGreen,
  });
}
```

### Visual

```
Pill: bg kGreen | radius 100px | padding 10px 20px | kShadowFloat
Content: white checkmark icon (18px) + message (Inter 14px white 500)
Position: bottom center, above tab bar (16px margin)
Animate: slide up + fade in | auto-dismiss after duration
```

### Usage

```dart
SuccessToast.show(context, message: 'Bill sent on WhatsApp ✓');
SuccessToast.show(context, message: 'Customer added');
SuccessToast.show(context, message: '300 credits added!', icon: Icons.add_circle_outline);
```

---

## C-14 — SectionHeader

```
File:    lib/shared/widgets/section_header.dart
Purpose: Section title with optional serif italic word + "View All →" link.
         Matches Ixigo's "Deals & Offers →" style.
```

### Props

```dart
class SectionHeader extends StatelessWidget {
  final String title;
  final String? serifWord;       // rendered in Playfair italic + kOrange
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showArrow;          // default: true
  final String? subtitle;
}
```

### Visual

```
Title: Inter 20px 700, #1A1A1A
serifWord: Playfair Display 20px italic, kOrange (appended after title)
Arrow "→": kOrange
Action link: Inter 13px, kOrange, right-aligned
Subtitle: Inter 12px, #999999
```

### Usage

```dart
SectionHeader(title: 'Recent Bills')
SectionHeader(title: 'Recent Bills', actionLabel: 'View All', onAction: () => context.go('/bill-history'))
SectionHeader(title: 'Deals & ', serifWord: 'Offers', actionLabel: 'View All', onAction: () {})
```

---

## C-15 — IconContainer

```
File:    lib/shared/widgets/icon_container.dart
Purpose: Rounded square with colored bg + icon. Feature tiles, notification icons.
```

### Props

```dart
class IconContainer extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double size;           // default: 48
  final double iconSize;       // default: 24
  final double borderRadius;   // default: 12
}
```

### Preset Colors (DESIGN.md §12)

```dart
// Bill:     bg kOrangeLight  | icon kOrange
// Customer: bg kBlueLight    | icon kBlue
// Message:  bg #F5F3FF       | icon #7C3AED (purple)
// Credits:  bg kGreenLight   | icon kGreen
// History:  bg #F8F8F8       | icon #555555
```

### Usage

```dart
IconContainer(
  icon: Icons.receipt_long_outlined,
  iconColor: AppColors.kOrange,
  backgroundColor: AppColors.kOrangeLight,
)
```

---

## C-16 — CreditBadge

```
File:    lib/shared/widgets/credit_badge.dart
Purpose: Credit count with dynamic color by level. Dashboard top bar + credits screen.
```

### Props

```dart
class CreditBadge extends StatelessWidget {
  final int currentCredits;
  final int maxCredits;
  final CreditType type;       // CreditType.bill | CreditType.msg
  final bool showLabel;        // default: true
  final double fontSize;       // default: 16
}
```

### Color Logic

```dart
// > 50% of max → kGreen | 20-50% → kWarning | < 20% → kError
Color get statusColor {
  final pct = currentCredits / maxCredits;
  if (pct > 0.5) return AppColors.kGreen;
  if (pct > 0.2) return AppColors.kWarning;
  return AppColors.kError;
}
```

---

## C-17 — StatusBadge

```
File:    lib/shared/widgets/status_badge.dart
Purpose: Colored pill showing status. "● Active", "⏳ Pending", "✓ Approved"
```

### Props

```dart
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;
  final bool showDot;     // default: true
  final double fontSize;  // default: 11
}

enum StatusBadgeType { active, pending, approved, rejected, failed, suspended, info }
```

### Color Map

```
active/approved: bg kGreenLight | text kGreen
pending:         bg #FFFBEB     | text kWarning
rejected:        bg #F5F5F5     | text #999999
failed/suspended: bg #FEF2F2   | text kError
info:            bg kBlueLight  | text kBlue
```

### Usage

```dart
StatusBadge(label: '● Active', type: StatusBadgeType.active)
StatusBadge(label: '⏳ Pending', type: StatusBadgeType.pending)
StatusBadge(label: '✓ Approved', type: StatusBadgeType.approved)
```

---

## C-18 — PlanBadge

```
File:    lib/shared/widgets/plan_badge.dart
Purpose: Subscription plan pill. "BASIC" / "PRO" / "BUSINESS"
```

### Props

```dart
class PlanBadge extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isLarge;    // default: false
}
```

### Per Plan Visual

```
BASIC:    bg #F5F5F5 | text #555555
PRO:      bg #F5F3FF | text #7C3AED (purple)
BUSINESS: bg kOrangeLight | text kOrange
```

---

## C-19 — BillCard

```
File:    lib/shared/widgets/bill_card.dart
Purpose: Bill row in history and customer detail lists.
```

### Props

```dart
class BillCard extends StatelessWidget {
  final BillModel bill;
  final VoidCallback onTap;
  final bool showCustomerName;   // default: true
}
```

### Layout

```
AppCard (tappable, padding: 12px 16px):
Row:
  Left: Column [ customerName (14px bold) · billNumber (11px muted) · timestamp (11px muted) ]
  Right: Column(end) [ "₹{total}" (14px bold) · StatusBadge (sent/failed) ]
```

---

## C-20 — CustomerCard

```
File:    lib/shared/widgets/customer_card.dart
Purpose: Customer row in customer list.
```

### Props

```dart
class CustomerCard extends StatelessWidget {
  final CustomerModel customer;
  final VoidCallback onTap;
}
```

### Layout

```
AppCard (tappable, padding: 12px 16px):
Row:
  Avatar circle (40px, initials, bg: kOrangeLight, text: kOrange)
  SizedBox(12)
  Expanded Column [ name (14px bold) · phone (12px muted) ]
  Column(end) [ "₹{totalBilled}" (13px bold) · "{n} bills" (11px muted) ]
```

---

## C-21 — ShopCard

```
File:    lib/shared/widgets/shop_card.dart
Purpose: Shop row in salesperson + admin shop lists.
```

### Props

```dart
class ShopCard extends StatelessWidget {
  final ShopModel shop;
  final VoidCallback onTap;
  final bool showSalesperson;   // default: false
}
```

### Layout

```
AppCard (tappable, padding: 12px 16px):
Row:
  Logo circle (40px initials, kOrangeLight bg)
  SizedBox(12)
  Expanded Column [
    shopName (14px bold)
    ownerName OR salespersonName (12px muted)
    businessType (11px muted)
  ]
  Column(end, gap 4) [ PlanBadge · StatusDot (6px circle by status) ]
```

---

## C-22 — InputField

```
File:    lib/shared/widgets/input_field.dart
Purpose: Styled TextFormField for all forms in the app.
```

### Props

```dart
class InputField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? placeholder;
  final TextInputType keyboardType;  // default: TextInputType.text
  final bool obscureText;            // default: false
  final bool readOnly;               // default: false
  final String? errorText;
  final String? prefixText;          // "+91"
  final Widget? suffixWidget;        // eye toggle, scan icon
  final int? maxLines;               // default: 1
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool isRequired;             // default: false — shows * in orange
}
```

### Visual States

```
NORMAL:   bg #FFFFFF | border 1px #E5E5E5 | radius 8 | height 52px | padding 0 16px
FOCUSED:  border 1.5px kOrange
ERROR:    border 1.5px kError | errorText below in red (11px)
READONLY: bg #FAFAFA | text #555555
Label:    Inter 11px, #999999, uppercase 0.3px tracking
          Required " *" in kOrange
```

### Usage

```dart
InputField(
  label: 'Customer Name', placeholder: 'e.g. Suresh Kumar',
  isRequired: true, controller: nameController,
  onChanged: (v) => ref.read(notifier.notifier).setName(v),
)
InputField(
  label: 'WhatsApp Number', prefixText: '+91',
  keyboardType: TextInputType.phone, errorText: state.phoneError,
)
InputField(
  label: 'Password', obscureText: !showPass,
  suffixWidget: IconButton(
    icon: Icon(showPass ? Icons.visibility_off : Icons.visibility),
    onPressed: () => setState(() => showPass = !showPass),
  ),
)
```

---

## C-23 — StepProgressBar

```
File:    lib/shared/widgets/step_progress_bar.dart
Purpose: Multi-step progress indicator for Add Shop 4-step flow.
```

### Props

```dart
class StepProgressBar extends StatelessWidget {
  final List<String> stepLabels;
  final int currentStep;      // 0-indexed
  final int completedSteps;
}
```

### Visual

```
Horizontal row of circles connected by lines:
COMPLETED: bg kGreen | white checkmark | label Inter 10px #999999
ACTIVE:    bg kOrange | white step number | label Inter 10px bold kOrange
UPCOMING:  bg #E5E5E5 | gray step number | label Inter 10px #CCCCCC
Lines: completed→active: kOrange | active→upcoming: #E5E5E5 | height 2px
```

### Usage

```dart
StepProgressBar(
  stepLabels: ['Details', 'Branding', 'Plan', 'AutoPay'],
  currentStep: 1,       // on step 2 (0-indexed)
  completedSteps: 1,    // step 1 complete
)
```

---

## C-24 — ConfirmBottomSheet

```
File:    lib/shared/widgets/confirm_bottom_sheet.dart
Purpose: Reusable bottom sheet confirmation dialog.
```

### Props

```dart
class ConfirmBottomSheet extends StatelessWidget {
  final String title;
  final String? body;
  final String confirmLabel;
  final String cancelLabel;        // default: 'Cancel'
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color confirmButtonColor;  // default: kOrange
  final bool isDestructive;        // true → red confirm button
  final Widget? customContent;
}

static Future<bool?> show(BuildContext context, {...}) async { ... }
```

### Visual

```
bg: #FFFFFF | radius top 20px | padding 24px 16px + safe area
Handle: 4×40px gray bar, centered top
Title: Inter 18px bold, #1A1A1A, center
Body: Inter 14px, #555555, center, 1.6 line-height
Confirm: PrimaryButton (kOrange or kError if destructive)
Cancel: SecondaryButton | 8px gap below confirm
```

### Usage

```dart
final confirmed = await ConfirmBottomSheet.show(context,
  title: 'Send to 128 customers?',
  body: 'This will use 128 message credits.',
  confirmLabel: 'Send Now',
);
if (confirmed == true) handleSend();

// Destructive
ConfirmBottomSheet.show(context,
  title: 'Delete this shop?',
  body: 'This cannot be undone.',
  confirmLabel: 'Delete', isDestructive: true,
);
```

---

## C-25 — InfoBanner

```
File:    lib/shared/widgets/info_banner.dart
Purpose: Persistent colored left-border inline banner.
         Not temporary (unlike SuccessToast). Stays in layout.
```

### Props

```dart
class InfoBanner extends StatelessWidget {
  final String message;
  final InfoBannerType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isDismissible;    // default: false
  final IconData? customIcon;
}

enum InfoBannerType { info, warning, error, success }
```

### Color Map

```
info:    border kBlue    | bg kBlueLight  | icon kBlue    | text #1E40AF
warning: border kWarning | bg #FFFBEB     | icon kWarning | text #92400E
error:   border kError   | bg #FEF2F2     | icon kError   | text #991B1B
success: border kGreen   | bg kGreenLight | icon kGreen   | text #14532D
```

### Visual

```
AppCard (leftBorderColor, backgroundColor from color map, padding 12px 14px):
Row: icon (20px) + SizedBox(12) + Expanded Column:
  message (Inter 13px, color map text, line-height 1.5)
  actionLabel (Inter 13px, kOrange, 500) — if provided
```

### Usage

```dart
InfoBanner(type: InfoBannerType.warning,
  message: 'AutoPay cannot be cancelled directly. Submit a request and we will process it.')

InfoBanner(type: InfoBannerType.error,
  message: 'Only 8 bill credits left.',
  actionLabel: 'Buy Credits →', onAction: () => context.go('/credits/topup'))

InfoBanner(type: InfoBannerType.info,
  message: "Based on 'Clothing' type, the 'Festival Offer' template will be assigned.")
```

---

## WIDGET QUICK REFERENCE BY SCREEN

```
S1-03 Dashboard:     GradientHeader(purple), AppCard, IconContainer, BillCard,
                     EmptyState, BottomTabBar, CreditBadge, InfoBanner(warning)

S1-04 New Bill:      AppCard, InputField, BottomActionBar, PrimaryButton

S1-05 Bill Preview:  GradientHeader(orange), AppCard, BottomActionBar, PrimaryButton, SuccessToast

S1-06 Bill Sent:     AppCard, PrimaryButton, SecondaryButton, StatusBadge, CreditBadge

S1-07 Bill History:  FilterChipRow, BillCard, EmptyState

S1-09 Customers:     FilterChipRow, CustomerCard, EmptyState, PrimaryButton

S1-12 Bulk Message:  GradientHeader(purple), AppCard, DarkPillButton, FilterChipRow,
                     InfoBanner, BottomActionBar, ConfirmBottomSheet

S1-13 Template:      AppCard, PrimaryButton

S1-15 Delivery:      AppCard, StatusBadge, SmallActionButton

S1-16 Credits:       GradientHeader(purple), AppCard, CreditBadge, PlanBadge, SmallActionButton

S1-17 Top-Up:        AppCard, BottomActionBar, PrimaryButton

S2-02 SP Dashboard:  GradientHeader(purple), AppCard, IconContainer, ShopCard,
                     EmptyState, BottomTabBar, InfoBanner(warning)

S2-04 Step 1:        StepProgressBar, AppCard, InputField, BottomActionBar, PrimaryButton

S2-05 Step 2:        StepProgressBar, AppCard, BottomActionBar, PrimaryButton

S2-06 Step 3:        StepProgressBar, AppCard, PlanBadge, InfoBanner(info), BottomActionBar

S2-07 Step 4:        StepProgressBar, AppCard, InputField, InfoBanner(info+warning),
                     BottomActionBar, PrimaryButton

S2-12 Cancel Detail: GradientHeader(orange), AppCard, InfoBanner(error), StatusBadge,
                     PrimaryButton, SecondaryButton, BottomActionBar, ConfirmBottomSheet

S3-02 Admin Dash:    GradientHeader(navy), AppCard, IconContainer, InfoBanner, StatusBadge, BottomTabBar

S3-06 All Shops:     FilterChipRow, ShopCard, PlanBadge, StatusBadge, EmptyState

S3-09 Template Edit: GradientHeader(orange), AppCard, InputField, BottomActionBar,
                     PrimaryButton, SecondaryButton, InfoBanner

S3-13 Revenue:       GradientHeader(navy), AppCard, PlanBadge, FilterChipRow
```

---

*COMPONENTS.md v1.0 — Billing Project — One Stop Solutions*
*25 shared widgets · Props, states, code, usage examples · July 2026*
*Next document: PROMPTS.md*
