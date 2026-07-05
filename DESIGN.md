# DESIGN.md — Billing Project
## Design System & Style Guide
> Inspired by Ixigo Light App Design Language  
> Version 1.0 | One Stop Solutions | July 2026

---

## 1. DESIGN PHILOSOPHY

Extracted directly from Ixigo's observed design behaviour across 23 screens:

| Principle | How Ixigo Does It | Apply to billing project |
|---|---|---|
| **Clarity first** | White dominant surfaces, zero decoration noise | White page bg, content breathes |
| **Orange = action only** | Orange strictly on CTAs and active states | Orange only on primary buttons, active tab, key highlights |
| **Gradient headers** | Purple/blue/sky gradient on app headers | Use orange gradient on detail/flow headers |
| **Cards are the unit** | Everything lives in a white rounded card | Bills, customers, templates — all in cards |
| **Serif for hero moments** | Headlines use serif (looks like Playfair/Georgia) | Use serif for dashboard total amount |
| **Sans for everything else** | Body, labels, prices use clean sans | Inter or DM Sans for all UI text |
| **Colour-coded status** | Green = success/free, Orange = action, Purple = premium | Follow same semantic colour logic |
| **Bottom sticky bar** | Price + CTA always pinned at bottom | Credits + "Send Bill" always pinned |
| **Icon containers** | Rounded square blue/purple bg for feature icons | Same pattern for app feature icons |

---

## 2. COLOUR TOKENS

### 2.1 Primary Palette

```
--color-primary          #E8680A   // Ixigo orange — CTAs, active tab, key accents
--color-primary-dark     #C8560A   // Pressed state / darker orange
--color-primary-light    #FFF3E8   // Orange tint bg for highlights, badges
--color-primary-border   #F0A06A   // Orange border for outlined elements
```

### 2.2 Background & Surface

```
--color-bg-page          #F5F5F5   // Page background — very light gray (not pure white)
--color-bg-card          #FFFFFF   // Card surface — pure white
--color-bg-card-alt      #F8F8F8   // Alternate card / section divider bg
--color-bg-input         #FFFFFF   // Input field background
--color-bg-input-focus   #FAFAFA   // Input focused state bg
--color-bg-tag           #F0F0F0   // Filter chip / tag background (unselected)
--color-bg-tag-selected  #1A1A1A   // Filter chip selected — dark pill (Ixigo pattern)
```

### 2.3 Header Gradients

> Ixigo uses different gradient headers per section. Replicate this pattern.

```
// Home header — purple/violet gradient (Ixigo home pattern)
--gradient-header-home: linear-gradient(180deg, #6B4EFF 0%, #8B6FFF 60%, #F5F5F5 100%)

// Flight/Detail header — orange gradient (Ixigo flight details)
--gradient-header-action: linear-gradient(180deg, #E8680A 0%, #F07820 60%, #FFFFFF 100%)

// Sky/light header — sky blue gradient (Ixigo flights search)
--gradient-header-sky: linear-gradient(180deg, #A8D4F5 0%, #C8E8FF 50%, #F5F5F5 100%)

// Onboarding — white with soft color aura (Ixigo welcome screens)
--gradient-onboarding: radial-gradient(ellipse at 50% 40%, rgba(180,160,255,0.3) 0%, rgba(255,200,180,0.2) 40%, #FFFFFF 70%)
```

### 2.4 Text Colours

```
--color-text-primary     #1A1A1A   // Main headings, card titles, prices
--color-text-secondary   #555555   // Subheadings, labels, descriptions
--color-text-muted       #999999   // Placeholder text, timestamps, helper text
--color-text-disabled    #CCCCCC   // Disabled state text
--color-text-orange      #E8680A   // Orange links, "View All →", active states
--color-text-blue        #2563EB   // Airport codes, links (Ixigo uses blue for codes)
--color-text-green       #16A34A   // Free Cancellation, Free Wifi, success states
--color-text-white       #FFFFFF   // Text on dark/orange backgrounds
```

### 2.5 Semantic / Status Colours

```
--color-success          #16A34A   // Green — success, free features, sent ✓
--color-success-bg       #F0FDF4   // Light green bg for success banners
--color-success-border   #BBF7D0   // Green border

--color-warning          #F59E0B   // Amber — warnings, price lock
--color-warning-bg       #FFFBEB   // Light amber bg
--color-warning-border   #FDE68A   // Amber border

--color-error            #DC2626   // Red — errors, failed states
--color-error-bg         #FEF2F2   // Light red bg
--color-error-border     #FECACA   // Red border

--color-info             #2563EB   // Blue — info, airport codes
--color-info-bg          #EFF6FF   // Light blue bg (Ixigo icon container bg)
--color-info-border      #BFDBFE   // Blue border

--color-purple           #7C3AED   // Purple — premium badges (Ixigo Assured)
--color-purple-bg        #F5F3FF   // Light purple bg
--color-purple-light     #8B6FFF   // Lighter purple for gradients
```

### 2.6 Border & Divider

```
--color-border           #E5E5E5   // Default card border, input border
--color-border-strong    #D0D0D0   // Stronger divider
--color-divider          #F0F0F0   // Section divider — very subtle
```

---

## 3. TYPOGRAPHY

### 3.1 Font Stack

```
// Primary sans-serif — all UI text
font-family: 'Inter', 'DM Sans', -apple-system, sans-serif;

// Serif — hero moments only (dashboard totals, onboarding headlines)
font-family: 'Playfair Display', 'Georgia', serif;

// Monospace — bill numbers, amounts in tables
font-family: 'DM Mono', 'Courier New', monospace;
```

### 3.2 Type Scale

Directly mirrored from Ixigo's observed text sizing:

```
// DISPLAY — Onboarding hero titles (Playfair Display / serif)
--text-display:     32px / font-weight: 700 / line-height: 1.2
// e.g. "Same ixigo, Smarter in every way"

// HEADING 1 — Section hero text (Playfair Display serif)
--text-h1:          26px / font-weight: 700 / line-height: 1.25
// e.g. "Deals & Offers", "Secure your trip", "Top Hotels"

// HEADING 2 — Card titles, screen headings (Inter bold)
--text-h2:          20px / font-weight: 700 / line-height: 1.3
// e.g. "Facilities", "Mumbai → New Delhi", "Best Deals For Hotels"

// HEADING 3 — Sub-section labels (Inter semibold)
--text-h3:          17px / font-weight: 600 / line-height: 1.35
// e.g. "Your selected fare offers", "Free Cancellation"

// BODY LARGE — Primary content (Inter regular)
--text-body-lg:     15px / font-weight: 400 / line-height: 1.5
// e.g. Card descriptions, form values

// BODY — Standard content (Inter regular)
--text-body:        14px / font-weight: 400 / line-height: 1.5
// e.g. Secondary card info, list items

// BODY SMALL — Supporting text (Inter regular)
--text-body-sm:     13px / font-weight: 400 / line-height: 1.4
// e.g. "25kms from BOM", "1 Traveller • Economy"

// LABEL — Uppercase tracking labels (Inter medium)
--text-label:       11px / font-weight: 500 / letter-spacing: 0.8px / text-transform: uppercase
// e.g. "BAGGAGE POLICY", "ARRIVAL AIRPORT", "SAVINGS FOR YOU"

// CAPTION — Timestamps, footnotes (Inter regular)
--text-caption:     11px / font-weight: 400 / line-height: 1.4
// e.g. "+ ₹891 taxes", "T&C Apply"

// PRICE LARGE — Dashboard total amount (Inter or DM Mono bold)
--text-price-lg:    28px / font-weight: 700 / letter-spacing: -0.5px
// e.g. "₹6,828", Dashboard bill total

// PRICE — In-card prices (Inter bold)
--text-price:       18px / font-weight: 700
// e.g. "₹3,892", "₹4,801"

// TIME — Flight times (Inter bold)
--text-time:        22px / font-weight: 700 / letter-spacing: -0.3px
// e.g. "06:25", "08:35" — applies to bill timestamps in our context

// BADGE — Small pill text (Inter medium)
--text-badge:       11px / font-weight: 600 / letter-spacing: 0.3px
```

### 3.3 Typography Rules

```
1. Serif (Playfair Display) ONLY for:
   - Onboarding hero headlines
   - Dashboard greeting + total amount label
   - Section intro text ("Secure your trip", "Deals & Offers")
   - Section titles that need personality

2. Italic serif for emphasis within headings:
   - "Deals & Offers →" — "Offers" in italic serif, "Deals &" in regular sans
   - "Secure your trip" — "your trip" italic serif, "Secure" sans bold

3. Never use serif for:
   - Prices, amounts
   - Form labels or inputs
   - Navigation or tab labels
   - Buttons or CTAs
   - Table data

4. Price amounts: always Inter bold, never serif
5. Strikethrough prices: color #999999, font-size one step smaller
6. "Free" always in --color-green
7. Airport/location codes: Inter bold + --color-blue (#2563EB)
```

---

## 4. SPACING SYSTEM

Ixigo uses an 8px base grid with 16px as the standard page padding.

```
--space-2:    2px    // Micro gaps (icon-label)
--space-4:    4px    // Tight spacing (badge padding, chip gap)
--space-6:    6px    // Small internal gaps
--space-8:    8px    // Base unit — between related elements
--space-12:   12px   // Card internal padding (top/bottom)
--space-16:   16px   // Standard page horizontal margin, card padding
--space-20:   20px   // Section spacing, list item padding
--space-24:   24px   // Between sections on same page
--space-32:   32px   // Major section breaks
--space-48:   48px   // Bottom safe area above sticky bar
```

### Page Layout Rules (from Ixigo screens)

```
Page horizontal padding:    16px both sides
Card internal padding:      16px horizontal / 12px vertical
Section gap:                24px
Between cards in list:      8px gap
Header height (gradient):   ~180-220px visible content area
Bottom sticky bar height:   72px + device safe area
Tab bar height:             60px + device safe area
```

---

## 5. BORDER RADIUS

```
--radius-xs:    4px    // Chips, small tags, table cells
--radius-sm:    8px    // Small buttons, icon containers, input fields
--radius-md:    12px   // Standard cards, most cards in lists
--radius-lg:    16px   // Larger cards, search form card, home category cards
--radius-xl:    20px   // Home category cards (Flight, Train, Hotel, Cab)
--radius-pill:  100px  // Full pill — CTA buttons, filter chips, tab indicators
--radius-full:  9999px // Circular elements — avatar, icon circle
```

### Usage Pattern (from Ixigo)

```
Main CTA button (Search Flights, Continue): border-radius: 100px (pill)
Filter chips (Flights, Hotels, Non-Stop): border-radius: 100px (pill)
Category cards (home grid): border-radius: 16-20px
Flight listing cards: border-radius: 12px
Bottom sheet modal: border-radius-top: 20px, bottom: 0
Input fields: border-radius: 8px
Icon containers (square): border-radius: 12px
Icon containers (circle): border-radius: 100%
Tab bar: border-radius: 0 (flat bar)
Active tab pill: border-radius: 100px
Date selector header pill: border-radius: 100px
```

---

## 6. ELEVATION & SHADOWS

Ixigo uses very subtle shadows — barely visible, mostly white cards on light gray bg.

```
// No shadow — flat card on white section
--shadow-none: none

// Subtle card shadow — most list cards
--shadow-card: 0px 1px 4px rgba(0, 0, 0, 0.06), 0px 0px 0px 1px rgba(0,0,0,0.04)

// Medium shadow — modal bottom sheet, sticky bars
--shadow-modal: 0px -2px 12px rgba(0, 0, 0, 0.10)

// Strong shadow — floating action buttons, AI bubble
--shadow-float: 0px 4px 16px rgba(0, 0, 0, 0.16)

// Bottom bar shadow — pinned footer
--shadow-bottombar: 0px -1px 0px rgba(0,0,0,0.08)
```

---

## 7. COMPONENT PATTERNS

### 7.1 Primary CTA Button

```
// Ixigo orange pill button — "Search Flights →", "Continue", "Select Room"
background:      #E8680A
color:           #FFFFFF
border-radius:   100px
height:          52px
font-size:       16px
font-weight:     600
width:           100%  // always full width
padding:         0 24px
```

### 7.2 Secondary / Ghost Button

```
// Outlined pill — "Change Date", "Dismiss", filter chips unselected
background:      #FFFFFF
color:           #1A1A1A
border:          1.5px solid #E5E5E5
border-radius:   100px
height:          40px
font-size:       14px
font-weight:     500
```

### 7.3 Dark Pill Button

```
// Dark filled pill — "One Way" selected, "Free Modification" active tab
background:      #1A1A1A
color:           #FFFFFF
border-radius:   100px
height:          40px
font-size:       14px
font-weight:     600
```

### 7.4 Small Orange Button

```
// Inline add/action button — "Add", small action within cards
background:      #E8680A
color:           #FFFFFF
border-radius:   8px
height:          36px
padding:         0 16px
font-size:       13px
font-weight:     600
```

### 7.5 Filter / Segment Tabs (horizontal scroll)

```
// Unselected chip
background:      #FFFFFF
color:           #555555
border:          1px solid #E5E5E5
border-radius:   100px
padding:         6px 16px
font-size:       13px
font-weight:     400

// Selected chip
background:      #1A1A1A   // OR #E8680A for primary selected
color:           #FFFFFF
border:          none
border-radius:   100px
padding:         6px 16px
font-size:       13px
font-weight:     500
```

### 7.6 Input Field

```
background:      #FFFFFF
border:          1px solid #E5E5E5
border-radius:   8px
height:          52px
padding:         0 16px
font-size:       15px
color:           #1A1A1A
placeholder:     #CCCCCC

// Focused state
border-color:    #E8680A
outline:         none

// Label style (floating label above)
font-size:       11px
color:           #999999
font-weight:     400
letter-spacing:  0.3px
```

### 7.7 Card — Standard List Card

```
// Flight card, Bill card, Customer card
background:      #FFFFFF
border-radius:   12px
border:          1px solid #F0F0F0
padding:         16px
margin-bottom:   8px
shadow:          --shadow-card
```

### 7.8 Card — Home Category Card (2-column grid)

```
// "Flight", "Hotels", "Train", "Cab" on home screen
background:      #FFFFFF
border-radius:   16px
border:          1px solid #F0F0F0
padding:         16px
// Contains: title bold, discount text in green, 3D illustration right-aligned
title:           font-size 18px, font-weight 700, color #1A1A1A
subtitle:        font-size 13px, color #16A34A (green for discount)
```

### 7.9 Icon Container

```
// Square rounded bg behind feature icons (Ixigo blue icon tiles)
width:           48px
height:          48px
border-radius:   12px
background:      #EFF6FF   // light blue
color:           #2563EB   // blue icon
// OR for orange context:
background:      #FFF3E8
color:           #E8680A
```

### 7.10 Badge / Tag

```
// "CHEAPEST" green badge
background:      #16A34A
color:           #FFFFFF
border-radius:   4px
padding:         2px 8px
font-size:       11px
font-weight:     600
letter-spacing:  0.5px

// "FASTEST" purple badge
background:      #7C3AED
color:           #FFFFFF
(same sizing)

// "New" — blue teal pill
background:      #EFF6FF
color:           #2563EB
border-radius:   100px
padding:         2px 8px
font-size:       11px
font-weight:     500

// Discount % badge
background:      #FFF3E8
color:           #E8680A
border:          1px solid #F0A06A
border-radius:   4px

// "POPULAR" badge
background:      #F5F3FF
color:           #7C3AED
border-radius:   4px

// Promo/offer banner badge (inside orange card)
background:      rgba(255,255,255,0.20)
color:           #FFFFFF
border-radius:   4px
```

### 7.11 Bottom Navigation Tab Bar

```
// Tab bar container
background:      #FFFFFF
border-top:      1px solid #F0F0F0
height:          60px
padding:         0 8px

// Inactive tab
icon-color:      #999999
label-color:     #999999
label-size:      11px

// Active tab
icon-color:      #E8680A
label-color:     #E8680A
label-size:      11px
// Active icon sits in a soft orange pill bg:
pill-bg:         #FFF3E8
pill-radius:     100px
pill-padding:    4px 16px
```

### 7.12 Bottom Sticky Action Bar (pinned CTA)

```
// "₹6,828 ^ | Continue" bar — Ixigo's most used pattern
background:      #FFFFFF
border-top:      1px solid #F0F0F0
shadow:          --shadow-bottombar
height:          72px
padding:         12px 16px
layout:          flex row — price info left, CTA button right

// Price section (left)
amount:          font-size 20px, font-weight 700, color #1A1A1A
sub-info:        font-size 12px, color #999999

// CTA button (right)
(use Primary CTA Button spec above)
width:           auto, min-width 140px
```

### 7.13 Bottom Sheet / Modal

```
// "Different Airport Selected" style modal
background:      #FFFFFF
border-radius:   20px 20px 0 0
shadow:          --shadow-modal
padding:         24px 16px
// Overlay behind: rgba(0,0,0,0.4)
// Title: font-size 18px, font-weight 700, text-align center
// Inner card: bg #F8F8F8, border-radius 12px, padding 16px
```

### 7.14 Horizontal Date Selector

```
// Date strip (Ixigo flight date strip)
background:      #F8F8F8
selected-date:   font-weight 700, color #1A1A1A, underline in #E8680A
other-dates:     font-weight 400, color #999999
price-below:     font-size 12px, color #555555
green-price:     color #16A34A (cheapest)
```

### 7.15 Section Header with Arrow Link

```
// "Deals & Offers →" / "Top Hotels in New Delhi →"
// Pattern: sans bold + italic serif "Offers" + orange arrow
title-sans:      font-size 22px, font-weight 700, font-family Inter
title-serif:     font-size 22px, font-style italic, font-family Playfair Display, color #E8680A
arrow:           "→" color #E8680A
```

### 7.16 Success Toast / Snackbar

```
// "Log in Successful ✓" green pill toast
background:      #16A34A
color:           #FFFFFF
border-radius:   100px
padding:         10px 20px
font-size:       14px
font-weight:     500
icon:            ✓ white checkmark left
position:        bottom center, above sticky bar
```

### 7.17 Loading / Empty State

```
// Ixigo empty state — illustration + muted text
illustration:    flat vector style, light blue/gray tones, orange accent detail
text:            font-size 14px, color #CCCCCC, text-align center
background:      #FFFFFF pure white
// No borders, no cards — just illustration + text on white
```

---

## 8. HEADER PATTERNS

### 8.1 App Home Header (Purple Gradient)

```
// Matches Ixigo home — purple/violet gradient top
background:      linear-gradient(180deg, #6B4EFF 0%, #8B6FFF 80%, transparent 100%)
height:          ~180px
content-bg:      white card floats below gradient
// Contains: hamburger menu left, promo pill center, coins/avatar right
```

### 8.2 Detail / Flow Header (Orange Gradient)

```
// Matches Ixigo flight details — full orange header
background:      linear-gradient(180deg, #E8680A 0%, #F07820 100%)
height:          ~200px
// Contains: back arrow left (white circle), title center (white), share right
// Title: font-size 18px, font-weight 700, color white, font-family Inter
// Sub: font-size 13px, color rgba(255,255,255,0.75)
```

### 8.3 List Screen Header (Light, no gradient)

```
// Flight list, hotel list — clean white/light header
background:      #FFFFFF
// Contains: back arrow, center title, edit/search icon
// Title: font-size 17px, font-weight 700, color #1A1A1A
// Sub: font-size 12px, color #999999
border-bottom:   1px solid #F0F0F0
```

### 8.4 Sky/Cloud Header (Sky Blue Gradient)

```
// Flight search page — sky blue top
background:      linear-gradient(180deg, #87CEEB 0%, #B8DEFF 60%, #F5F5F5 100%)
// Decorative cloud images in bg
// Search form card floats as white card below sky area
```

---

## 9. SEARCH / FORM CARD

```
// The main booking form — "One Way / Round Trip" selector + fields + CTA
background:      #FFFFFF
border-radius:   20px
padding:         20px 16px
shadow:          0px 2px 12px rgba(0,0,0,0.08)
// Floats below the gradient header, margin-top: -20px (overlap)

// Toggle row (One Way / Round Trip)
toggle-bg:       #F0F0F0
selected-bg:     #1A1A1A (dark pill)
unselected:      transparent, color #555555

// Form row — each field
label:           font-size 11px, color #999999
value:           font-size 16px, font-weight 600, color #1A1A1A
divider:         1px solid #F0F0F0 between rows
```

---

## 10. ILLUSTRATION STYLE

Based on Ixigo's home screen category cards:

```
Style:         3D rendered / semi-realistic product illustrations
Objects:       Airplane, train, bus, hotel, car — all 3D, white/cream toned
Background:    Soft light blue-white gradient blob behind each illustration
Position:      Bottom-right corner of card, slightly overflowing card edge
Scale:         ~80px-100px height, proportional width
Shadow:        Very subtle drop shadow on the 3D object
```

For billing project, adapt to:
```
// Shop illustration, WhatsApp icon 3D, bill/receipt 3D, phone 3D
// Same style: 3D rendered, white/cream objects, soft blue glow bg
```

---

## 11. ONBOARDING SCREENS

Based on Ixigo's 4-screen onboarding:

```
// Background
Pure white bottom half, soft gradient aura top half
Aura colours: rgba(180,160,255,0.25) purple + rgba(255,180,120,0.20) orange

// Hero illustration
3D object (Ixigo globe/ball) — large, centred
Size: ~200px diameter
Floating in the gradient aura area

// Headline (serif)
font-family:   Playfair Display
font-size:     28px
font-weight:   700
color:         #1A1A1A
text-align:    center
margin-top:    32px

// Body text
font-family:   Inter
font-size:     15px
font-weight:   400
color:         #666666
text-align:    center
line-height:   1.6

// Navigation
Dots indicator bottom centre
Next arrow: orange circle button, right side
Prev arrow: ghost circle button, left side
X close: light gray circle, top right
```

---

## 12. billing project — SPECIFIC TOKENS

Adapting Ixigo's language to our product:

```
// Our brand color — replacing Ixigo purple header with our identity
// OPTION A: Keep Ixigo's purple header + orange CTA (safest, most familiar)
// OPTION B: Use deep orange header + orange CTA (more bold, orange-first)

// Recommended: Option A — purple header for premium trust,
//              orange only on CTAs (exactly as Ixigo does)
--brand-header:    #6B4EFF   // Purple — header gradient base
--brand-action:    #E8680A   // Orange — all CTAs, active states

// Feature icon containers
Bill:              bg #FFF3E8 / icon #E8680A
Customer:          bg #EFF6FF / icon #2563EB
Bulk Message:      bg #F5F3FF / icon #7C3AED
Credits:           bg #F0FDF4 / icon #16A34A
History:           bg #F8F8F8 / icon #555555

// Credit status colours
Credits healthy (>50%):    #16A34A green
Credits low (20-50%):      #F59E0B amber
Credits critical (<20%):   #DC2626 red
```

---

## 13. FLUTTER IMPLEMENTATION NOTES

```dart
// Colour constants
const kOrange       = Color(0xFFE8680A);
const kOrangeDark   = Color(0xFFC8560A);
const kOrangeLight  = Color(0xFFFFF3E8);
const kPurple       = Color(0xFF6B4EFF);
const kGreen        = Color(0xFF16A34A);
const kGreenLight   = Color(0xFFF0FDF4);
const kBlue         = Color(0xFF2563EB);
const kBlueLight    = Color(0xFFEFF6FF);
const kDark         = Color(0xFF1A1A1A);
const kMuted        = Color(0xFF999999);
const kBorderGray   = Color(0xFFE5E5E5);
const kBgPage       = Color(0xFFF5F5F5);
const kBgCard       = Color(0xFFFFFFFF);

// Border Radius
const kRadiusSm     = BorderRadius.circular(8);
const kRadiusMd     = BorderRadius.circular(12);
const kRadiusLg     = BorderRadius.circular(16);
const kRadiusXl     = BorderRadius.circular(20);
const kRadiusPill   = BorderRadius.circular(100);

// Spacing
const kSpaceSm      = 8.0;
const kSpaceMd      = 16.0;
const kSpaceLg      = 24.0;
const kSpaceXl      = 32.0;

// Shadows
final kShadowCard = BoxShadow(
  color: Colors.black.withOpacity(0.06),
  blurRadius: 4,
  offset: Offset(0, 1),
);
final kShadowModal = BoxShadow(
  color: Colors.black.withOpacity(0.10),
  blurRadius: 12,
  offset: Offset(0, -2),
);
final kShadowFloat = BoxShadow(
  color: Colors.black.withOpacity(0.16),
  blurRadius: 16,
  offset: Offset(0, 4),
);

// Typography
const kFontSans     = 'Inter';
const kFontSerif    = 'PlayfairDisplay';
const kFontMono     = 'DMMono';
```

---

## 14. DO / DON'T REFERENCE

| DO | DON'T |
|---|---|
| Orange on CTAs and active tab only | Orange on backgrounds, cards, headers |
| Purple gradient on home header | Red anywhere in the UI |
| Full-width pill buttons | Square or small rounded buttons |
| White cards on light gray page | Colored card backgrounds |
| Serif for hero headings only | Serif for prices, labels, buttons |
| Green for all free/success states | Orange for success states |
| Horizontal scrollable filter chips | Vertical stacked filters |
| Bottom sticky bar with price + CTA | Floating CTAs mid-page |
| 3D style illustrations | Flat 2D icon illustrations |
| Subtle 1px borders on cards | Heavy shadows or deep borders |
| Uppercase letter-spaced labels | Bold caps labels without tracking |
| Orange underline on active date | Colored date bg (pill style) |
| Blue for codes / links / info | Black for links |
| Dark pill for selected toggle | Colored pill for toggle |

---

## 15. SCREEN-BY-SCREEN MAPPING

| Ixigo Screen | billing project Equivalent |
|---|---|
| Home — category grid (Flight/Hotel/Train/Cab) | Home — action grid (New Bill / Bulk Message / Customers / History) |
| Flight search form | New Bill form (Customer + items + amount) |
| Flight listing cards | Bill history list / Customer list |
| Flight detail — orange header | Bill preview — orange header |
| "Secure your trip" add-ons | "Send Bill" confirmation with credits info |
| Bottom sticky (₹ + Continue) | Bottom sticky (Credits used + Send on WhatsApp) |
| Filter chips (Flights / Hotels / Bank) | Filter chips (All / Today / This Week) |
| Date selector strip | Customer filter strip |
| Hotel card with image + rating | Customer card with stats + last bill |
| Empty state (Fetching...) | Empty state (No bills yet) |
| Onboarding screens | App onboarding / salesperson setup screens |
| Login screen (orange CTA) | Shopkeeper login (same pattern) |
| Bottom sheet modal | Confirmation modals / Cancel request |
| Tab bar (Home/Flights/Hotels/My Trips) | Tab bar (Home/Bill/Customers/Settings) |

---

*DESIGN.md v1.0 — Billing Project — One Stop Solutions*  
*Based on analysis of 23 Ixigo Light App screenshots — July 2026*
