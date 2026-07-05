# DATABASE.md — Billing Project
# Complete Supabase Database Schema
# Version 1.0 | One Stop Solutions | July 2026
#
# Database: Supabase (PostgreSQL)
# All tables use UUID primary keys
# All tables have created_at + updated_at timestamps
# Row Level Security (RLS) enabled on ALL tables — no exceptions
# Soft deletes only — never hard delete (use is_deleted or status columns)
#
# Read alongside: CLAUDE.md · API.md · SCREENS-1/2/3.md

---

## SECTION INDEX

```
SECTION 1  →  Database Design Principles
SECTION 2  →  Schema Overview (all tables at a glance)
SECTION 3  →  Auth & Users Tables
SECTION 4  →  Shop Tables
SECTION 5  →  Customer Tables
SECTION 6  →  Billing Tables
SECTION 7  →  Messaging Tables
SECTION 8  →  Credits & Subscriptions Tables
SECTION 9  →  Templates Tables
SECTION 10 →  Notifications Tables
SECTION 11 →  Admin & Audit Tables
SECTION 12 →  Row Level Security (RLS) Policies
SECTION 13 →  Indexes
SECTION 14 →  Supabase Storage Buckets
SECTION 15 →  Supabase Realtime Subscriptions
SECTION 16 →  Database Functions & Triggers
```

---

## SECTION 1 — DATABASE DESIGN PRINCIPLES

```
1. UUID everywhere
   All primary keys are UUID (gen_random_uuid()).
   Never use auto-increment integers as primary keys.
   Reason: distributed-safe, no enumeration attacks, Supabase default.

2. Soft deletes only
   NEVER use DELETE on any table.
   Use: is_deleted BOOLEAN DEFAULT false
   OR:  status column with 'deleted' as a possible value.
   Reason: bill history must be immutable, audit trail required.

3. Timestamps on everything
   Every table has:
   created_at  TIMESTAMPTZ DEFAULT now()
   updated_at  TIMESTAMPTZ DEFAULT now()
   Auto-updated via trigger (see Section 16).

4. Row Level Security (RLS) on ALL tables
   Every table has RLS enabled.
   Shopkeeper sees only their own shop's data.
   Salesperson sees only their assigned shops' data.
   Super Admin sees everything.
   See Section 12 for full policies.

5. Atomic operations for credits
   Credit deduction + bill creation happen in a single DB transaction.
   Use Supabase DB functions (plpgsql) for atomic credit ops.
   Never update credits from two separate API calls.

6. No sensitive data in Flutter-accessible tables
   AiSensy API key → Node.js .env only
   Razorpay secret → Node.js .env only
   UPI IDs → stored in DB but never returned to Flutter directly
   (returned masked: xxxx@bank)

7. Enums as PostgreSQL types
   Use CREATE TYPE for fixed value sets.
   Easier to query, indexed efficiently.

8. All monetary amounts in paise (integer)
   Store prices as integers in paise (₹599 = 59900 paise).
   Avoids floating point errors.
   Display layer converts to rupees (÷ 100).
   Exception: GST amounts use NUMERIC(10,2) for precision.
```

---

## SECTION 2 — SCHEMA OVERVIEW

```
AUTH & USERS
  profiles              ← extends Supabase auth.users (one profile per user)

SHOPS
  shops                 ← core shop record
  shop_credits          ← real-time credit balances (1 row per shop)
  shop_settings         ← per-shop config (GST rate, default notes, etc.)

CUSTOMERS
  customers             ← shopkeeper's customer database

BILLING
  bills                 ← every bill created
  bill_items            ← line items for each bill
  bill_resends          ← audit log of re-sends

MESSAGING
  campaigns             ← bulk message campaigns
  campaign_recipients   ← one row per recipient per campaign

CREDITS & SUBSCRIPTIONS
  subscriptions         ← Razorpay subscription details per shop
  credit_transactions   ← audit log of every credit change
  topup_orders          ← Razorpay top-up orders

TEMPLATES
  templates             ← WhatsApp message templates

NOTIFICATIONS
  notifications         ← in-app notifications per user

ADMIN & AUDIT
  salespersons          ← salesperson profiles + performance
  cancellation_requests ← AutoPay cancellation requests
  webhook_logs          ← all inbound webhooks logged
  admin_actions         ← audit log of Super Admin actions
  platform_settings     ← global platform config (AiSensy key, etc.)
```

---

## SECTION 3 — AUTH & USERS TABLES

### 3.1 profiles

Extends Supabase `auth.users`. One row per user (shopkeeper, salesperson, admin).

```sql
CREATE TABLE profiles (
  id              UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role            TEXT NOT NULL CHECK (role IN ('shopkeeper', 'salesperson', 'super_admin')),
  full_name       TEXT NOT NULL,
  phone           TEXT UNIQUE NOT NULL,
  email           TEXT,
  avatar_url      TEXT,
  is_active       BOOLEAN DEFAULT true,
  last_login_at   TIMESTAMPTZ,
  created_at      TIMESTAMPTZ DEFAULT now(),
  updated_at      TIMESTAMPTZ DEFAULT now()
);
```

```
role values:
  'shopkeeper'   → end user (shop owner)
  'salesperson'  → sales team member (creates shops)
  'super_admin'  → One Stop Solutions internal team

Indexes: phone, role, is_active
RLS: user can read/update their own row only
     super_admin can read all rows
```

---

## SECTION 4 — SHOP TABLES

### 4.1 shops

Core shop record. One row per shopkeeper account.

```sql
CREATE TYPE shop_status AS ENUM ('active', 'pending_setup', 'suspended', 'cancelled');
CREATE TYPE business_type AS ENUM (
  'clothing', 'steel', 'electronics', 'grocery',
  'pharmacy', 'jewellery', 'furniture', 'other'
);
CREATE TYPE subscription_plan AS ENUM ('basic', 'pro', 'business');

CREATE TABLE shops (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id            UUID NOT NULL REFERENCES profiles(id),
  salesperson_id      UUID NOT NULL REFERENCES profiles(id),

  -- Basic info
  shop_name           TEXT NOT NULL,
  owner_name          TEXT NOT NULL,
  owner_phone         TEXT NOT NULL,
  whatsapp_number     TEXT NOT NULL,

  -- Address
  address             TEXT NOT NULL,
  city                TEXT NOT NULL,
  state               TEXT NOT NULL,
  pin_code            TEXT NOT NULL CHECK (pin_code ~ '^[0-9]{6}$'),

  -- Business
  gst_number          TEXT CHECK (
                        gst_number IS NULL OR
                        gst_number ~ '^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$'
                      ),
  business_type       business_type NOT NULL,
  logo_url            TEXT,

  -- Plan & subscription
  plan                subscription_plan NOT NULL DEFAULT 'basic',
  plan_started_at     TIMESTAMPTZ,
  plan_ends_at        TIMESTAMPTZ,

  -- Status
  status              shop_status NOT NULL DEFAULT 'pending_setup',
  suspended_at        TIMESTAMPTZ,
  suspended_reason    TEXT,
  cancelled_at        TIMESTAMPTZ,

  -- Template assigned
  template_id         UUID REFERENCES templates(id),

  -- Metadata
  is_deleted          BOOLEAN DEFAULT false,
  created_at          TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now()
);
```

```
Key relationships:
  shops.owner_id      → profiles.id (the shopkeeper)
  shops.salesperson_id → profiles.id (who onboarded them)
  shops.template_id   → templates.id (assigned WhatsApp template)

Indexes: owner_id, salesperson_id, status, plan, business_type, city, created_at
RLS:
  shopkeeper → SELECT own shop only (WHERE owner_id = auth.uid())
  salesperson → SELECT shops WHERE salesperson_id = auth.uid()
  super_admin → ALL operations
```

### 4.2 shop_credits

Real-time credit balances. One row per shop. Updated atomically.

```sql
CREATE TABLE shop_credits (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id               UUID UNIQUE NOT NULL REFERENCES shops(id),

  -- Bill credits (for sending PDF bills)
  bill_credits          INTEGER NOT NULL DEFAULT 0 CHECK (bill_credits >= 0),
  bill_credits_limit    INTEGER NOT NULL DEFAULT 100,
  bill_credits_used     INTEGER NOT NULL DEFAULT 0,

  -- Message credits (for bulk WhatsApp campaigns)
  msg_credits           INTEGER NOT NULL DEFAULT 0 CHECK (msg_credits >= 0),
  msg_credits_limit     INTEGER NOT NULL DEFAULT 300,
  msg_credits_used      INTEGER NOT NULL DEFAULT 0,

  -- Billing cycle
  billing_cycle_start   DATE NOT NULL,
  billing_cycle_end     DATE NOT NULL,
  credits_reset_at      TIMESTAMPTZ,

  created_at            TIMESTAMPTZ DEFAULT now(),
  updated_at            TIMESTAMPTZ DEFAULT now()
);
```

```
Plan credit limits:
  Basic:    bill_credits_limit = 100,  msg_credits_limit = 300
  Pro:      bill_credits_limit = 300,  msg_credits_limit = 800
  Business: bill_credits_limit = 99999 (unlimited), msg_credits_limit = 2000

Credit deduction is done via DB function (Section 16.1) — atomic operation.
Credits reset monthly via scheduled Supabase Edge Function.

RLS:
  shopkeeper → SELECT + UPDATE own shop_credits only
  super_admin → ALL operations
  Node.js service role → ALL operations (for credit deduction)
```

### 4.3 shop_settings

Per-shop configurable settings.

```sql
CREATE TABLE shop_settings (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id             UUID UNIQUE NOT NULL REFERENCES shops(id),

  -- GST configuration
  gst_rate            NUMERIC(5,2) DEFAULT 5.00
                        CHECK (gst_rate IN (0, 5, 12, 18, 28)),
  gst_type            TEXT DEFAULT 'CGST_SGST'
                        CHECK (gst_type IN ('CGST_SGST', 'IGST', 'NONE')),

  -- Bill defaults
  default_notes       TEXT,
  bill_number_prefix  TEXT DEFAULT 'BILL',
  bill_number_counter INTEGER NOT NULL DEFAULT 1,

  -- Notification preferences
  notify_credit_low       BOOLEAN DEFAULT true,
  notify_payment_success  BOOLEAN DEFAULT true,
  notify_bill_delivered   BOOLEAN DEFAULT true,
  notify_bulk_complete    BOOLEAN DEFAULT true,

  created_at          TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now()
);
```

```
bill_number_counter auto-increments per shop.
Format: {prefix}-{YEAR}-{counter padded to 4 digits}
e.g. BILL-2026-0042

RLS: shopkeeper → SELECT + UPDATE own settings only
```

---

## SECTION 5 — CUSTOMER TABLES

### 5.1 customers

Shopkeeper's customer database. Isolated per shop.

```sql
CREATE TABLE customers (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id         UUID NOT NULL REFERENCES shops(id),

  name            TEXT NOT NULL,
  phone           TEXT NOT NULL,
  business_type   business_type,
  notes           TEXT,

  -- Computed stats (updated via trigger on bill creation)
  total_bills_count   INTEGER DEFAULT 0,
  total_billed_amount NUMERIC(12,2) DEFAULT 0.00,
  last_bill_date      TIMESTAMPTZ,

  is_deleted          BOOLEAN DEFAULT false,
  created_at          TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now()
);
```

```
Uniqueness:
  (shop_id, phone) → warn on duplicate, do not block INSERT
  Reason: shopkeeper may have two customers with same number

Plan limits enforced in Node.js (not DB constraint):
  Basic:    500 customers max
  Pro:      2000 customers max
  Business: unlimited

Indexes: shop_id, phone, name, last_bill_date, total_billed_amount
RLS: shopkeeper → ALL ops on own shop's customers only
```

---

## SECTION 6 — BILLING TABLES

### 6.1 bills

Every bill created. Immutable after creation (no UPDATE on core fields).

```sql
CREATE TYPE bill_status AS ENUM ('created', 'sent', 'failed', 'cancelled');

CREATE TABLE bills (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id             UUID NOT NULL REFERENCES shops(id),
  customer_id         UUID NOT NULL REFERENCES customers(id),

  -- Bill identity
  bill_number         TEXT NOT NULL,
  -- Format: BILL-{YEAR}-{4-digit-counter}
  -- Unique per shop: UNIQUE(shop_id, bill_number)

  -- Financials (stored in rupees as NUMERIC for accuracy)
  subtotal            NUMERIC(12,2) NOT NULL CHECK (subtotal > 0),
  gst_rate            NUMERIC(5,2) NOT NULL DEFAULT 5.00,
  gst_amount          NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  cgst_amount         NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  sgst_amount         NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  igst_amount         NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  total               NUMERIC(12,2) NOT NULL CHECK (total > 0),
  notes               TEXT,

  -- Status
  status              bill_status NOT NULL DEFAULT 'created',

  -- WhatsApp delivery
  aisensy_message_id  TEXT,
  pdf_url             TEXT,
  sent_at             TIMESTAMPTZ,
  delivered_at        TIMESTAMPTZ,

  -- Credits tracking
  bill_credit_deducted  BOOLEAN DEFAULT false,

  is_deleted          BOOLEAN DEFAULT false,
  created_at          TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now(),

  UNIQUE(shop_id, bill_number)
);
```

```
Immutability rule:
  After status = 'sent' → core financial fields CANNOT be updated.
  Only updatable fields after send: status, aisensy_message_id, delivered_at.
  Enforced via trigger (Section 16.2).

Indexes: shop_id, customer_id, status, created_at, bill_number, sent_at
RLS: shopkeeper → SELECT all own bills, INSERT, no DELETE, no UPDATE core fields
```

### 6.2 bill_items

Line items for each bill. Separate table for normalization.

```sql
CREATE TABLE bill_items (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bill_id         UUID NOT NULL REFERENCES bills(id) ON DELETE CASCADE,
  shop_id         UUID NOT NULL REFERENCES shops(id),

  item_name       TEXT NOT NULL,
  quantity        NUMERIC(10,3) NOT NULL CHECK (quantity > 0),
  rate_per_unit   NUMERIC(12,2) NOT NULL CHECK (rate_per_unit > 0),
  amount          NUMERIC(12,2) NOT NULL CHECK (amount > 0),

  sort_order      INTEGER NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ DEFAULT now()
);
```

```
Notes:
  quantity uses NUMERIC(10,3) to support fractional units (e.g. 1.5 kg of steel)
  amount = quantity × rate_per_unit (validated in Node.js, not DB constraint)
  Deletes cascade when parent bill is deleted (should never happen — soft delete)

Indexes: bill_id, shop_id
RLS: same as bills — shopkeeper sees only own shop's bill_items
```

### 6.3 bill_resends

Audit log of every re-send action.

```sql
CREATE TABLE bill_resends (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bill_id         UUID NOT NULL REFERENCES bills(id),
  shop_id         UUID NOT NULL REFERENCES shops(id),
  resent_by       UUID NOT NULL REFERENCES profiles(id),
  aisensy_message_id TEXT,
  status          TEXT NOT NULL CHECK (status IN ('sent', 'failed')),
  created_at      TIMESTAMPTZ DEFAULT now()
);
```

```
Note: Re-sends do NOT deduct credits. Logged for audit only.
Indexes: bill_id, shop_id, created_at
```

---

## SECTION 7 — MESSAGING TABLES

### 7.1 campaigns

Bulk WhatsApp campaign records.

```sql
CREATE TYPE campaign_status AS ENUM (
  'draft', 'queued', 'sending', 'completed', 'failed', 'cancelled'
);

CREATE TABLE campaigns (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id               UUID NOT NULL REFERENCES shops(id),
  template_id           UUID NOT NULL REFERENCES templates(id),

  -- Campaign details
  name                  TEXT,
  recipient_mode        TEXT NOT NULL CHECK (recipient_mode IN ('all', 'manual')),
  total_recipients      INTEGER NOT NULL DEFAULT 0,

  -- Template variables used
  template_variables    JSONB NOT NULL DEFAULT '{}',
  -- e.g. {"shop_name": "Raju Silks", "offer": "30% Off", "season": "Diwali"}

  -- Status
  status                campaign_status NOT NULL DEFAULT 'draft',

  -- Delivery stats (updated as messages send)
  sent_count            INTEGER NOT NULL DEFAULT 0,
  delivered_count       INTEGER NOT NULL DEFAULT 0,
  failed_count          INTEGER NOT NULL DEFAULT 0,
  pending_count         INTEGER NOT NULL DEFAULT 0,

  -- Credits
  msg_credits_used      INTEGER NOT NULL DEFAULT 0,

  -- Timestamps
  queued_at             TIMESTAMPTZ,
  started_at            TIMESTAMPTZ,
  completed_at          TIMESTAMPTZ,
  created_at            TIMESTAMPTZ DEFAULT now(),
  updated_at            TIMESTAMPTZ DEFAULT now()
);
```

```
Indexes: shop_id, status, created_at, template_id
RLS: shopkeeper → ALL ops on own campaigns only
```

### 7.2 campaign_recipients

One row per recipient per campaign. Updated as delivery status changes.

```sql
CREATE TYPE delivery_status AS ENUM (
  'pending', 'queued', 'sent', 'delivered', 'read', 'failed'
);

CREATE TABLE campaign_recipients (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id         UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  shop_id             UUID NOT NULL REFERENCES shops(id),
  customer_id         UUID NOT NULL REFERENCES customers(id),

  phone               TEXT NOT NULL,
  customer_name       TEXT NOT NULL,

  -- AiSensy message tracking
  aisensy_message_id  TEXT,
  status              delivery_status NOT NULL DEFAULT 'pending',
  failure_reason      TEXT,

  -- Timestamps
  sent_at             TIMESTAMPTZ,
  delivered_at        TIMESTAMPTZ,
  read_at             TIMESTAMPTZ,

  created_at          TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now()
);
```

```
Indexes: campaign_id, shop_id, customer_id, status, aisensy_message_id
RLS: shopkeeper → SELECT own campaign recipients only
     Node.js service role → ALL (for updating delivery status from webhook)
```

---

## SECTION 8 — CREDITS & SUBSCRIPTIONS TABLES

### 8.1 subscriptions

Razorpay subscription details per shop.

```sql
CREATE TYPE subscription_status AS ENUM (
  'pending', 'active', 'halted', 'cancelled', 'expired', 'paused'
);

CREATE TABLE subscriptions (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id               UUID UNIQUE NOT NULL REFERENCES shops(id),

  -- Razorpay IDs
  razorpay_subscription_id  TEXT UNIQUE,
  razorpay_plan_id          TEXT,
  razorpay_mandate_id       TEXT,

  -- Plan details
  plan                  subscription_plan NOT NULL,
  plan_amount           INTEGER NOT NULL,
  -- stored in paise: ₹599 = 59900

  -- UPI details
  upi_id                TEXT NOT NULL,
  -- stored as-is, returned masked to Flutter

  -- Status
  status                subscription_status NOT NULL DEFAULT 'pending',
  mandate_approved_at   TIMESTAMPTZ,

  -- Billing cycle
  billing_day           INTEGER NOT NULL DEFAULT 1 CHECK (billing_day BETWEEN 1 AND 28),
  -- day of month AutoPay fires
  next_billing_date     DATE,
  last_billed_at        TIMESTAMPTZ,
  trial_ends_at         TIMESTAMPTZ,

  -- Cancellation
  cancellation_requested_at TIMESTAMPTZ,
  cancelled_at              TIMESTAMPTZ,
  cancel_at_period_end      BOOLEAN DEFAULT false,
  access_ends_at            TIMESTAMPTZ,

  -- Setup
  setup_by_salesperson_id UUID REFERENCES profiles(id),
  created_at              TIMESTAMPTZ DEFAULT now(),
  updated_at              TIMESTAMPTZ DEFAULT now()
);
```

```
upi_id masking rule:
  "9876543210@upi" → returned to Flutter as "xxxxxxxx10@upi"
  Masking done in Node.js before returning to Flutter.

Indexes: shop_id, razorpay_subscription_id, status, next_billing_date
RLS:
  shopkeeper → SELECT own subscription only (no UPI_ID field returned)
  salesperson → SELECT subscriptions for their shops only
  super_admin → ALL operations
  Node.js service role → ALL (for webhook processing)
```

### 8.2 credit_transactions

Immutable audit log of every credit change. Never updated, only inserted.

```sql
CREATE TYPE credit_transaction_type AS ENUM (
  'plan_allocation',    -- credits given at plan start / renewal
  'bill_deduction',     -- 1 credit used per bill sent
  'msg_deduction',      -- credits used per bulk message recipient
  'topup_addition',     -- credits added via top-up purchase
  'manual_addition',    -- credits added manually by Super Admin
  'rollback',           -- credit restored after failed send
  'plan_upgrade',       -- credits adjusted on plan upgrade
  'monthly_reset'       -- unused credits cleared on billing cycle reset
);

CREATE TABLE credit_transactions (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id           UUID NOT NULL REFERENCES shops(id),

  credit_type       TEXT NOT NULL CHECK (credit_type IN ('bill_credits', 'msg_credits')),
  transaction_type  credit_transaction_type NOT NULL,
  amount            INTEGER NOT NULL,
  -- positive = addition, negative = deduction

  balance_before    INTEGER NOT NULL,
  balance_after     INTEGER NOT NULL,

  -- Reference to the triggering entity
  reference_type    TEXT CHECK (reference_type IN (
                      'bill', 'campaign', 'topup_order',
                      'subscription', 'admin_action', 'system'
                    )),
  reference_id      UUID,
  -- e.g. if transaction_type = 'bill_deduction', reference_id = bills.id

  performed_by      UUID REFERENCES profiles(id),
  -- null for system-triggered (webhooks, etc.)

  notes             TEXT,
  created_at        TIMESTAMPTZ DEFAULT now()
  -- NO updated_at — this table is append-only
);
```

```
This table is APPEND-ONLY. Never UPDATE or DELETE any row.
It is the source of truth for credit history.

Indexes: shop_id, credit_type, transaction_type, created_at, reference_id
RLS:
  shopkeeper → SELECT own transactions only
  super_admin → SELECT all
  Node.js service role → INSERT only (no UPDATE, no DELETE)
```

### 8.3 topup_orders

Razorpay orders for credit top-ups.

```sql
CREATE TYPE topup_status AS ENUM (
  'created', 'paid', 'failed', 'refunded'
);

CREATE TABLE topup_orders (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id               UUID NOT NULL REFERENCES shops(id),

  -- Pack details (snapshot at time of order)
  pack_id               TEXT NOT NULL,
  pack_name             TEXT NOT NULL,
  credit_type           TEXT NOT NULL CHECK (credit_type IN ('bill_credits', 'msg_credits')),
  credits_purchased     INTEGER NOT NULL CHECK (credits_purchased > 0),

  -- Payment
  amount_paise          INTEGER NOT NULL CHECK (amount_paise > 0),
  -- e.g. ₹320 = 32000 paise
  currency              TEXT NOT NULL DEFAULT 'INR',

  -- Razorpay
  razorpay_order_id     TEXT UNIQUE,
  razorpay_payment_id   TEXT UNIQUE,
  razorpay_signature    TEXT,

  -- Status
  status                topup_status NOT NULL DEFAULT 'created',
  paid_at               TIMESTAMPTZ,
  credits_added_at      TIMESTAMPTZ,

  created_at            TIMESTAMPTZ DEFAULT now(),
  updated_at            TIMESTAMPTZ DEFAULT now()
);
```

```
Idempotency: razorpay_payment_id must be unique — prevents double credit addition.
Check ALREADY_PROCESSED error by querying this column before processing.

Indexes: shop_id, razorpay_order_id, razorpay_payment_id, status, created_at
RLS:
  shopkeeper → SELECT own orders only
  super_admin → SELECT all
  Node.js service role → ALL (for payment verification + status update)
```

---

## SECTION 9 — TEMPLATES TABLES

### 9.1 templates

WhatsApp message templates for all 7 business types.

```sql
CREATE TYPE meta_approval_status AS ENUM (
  'draft', 'pending', 'approved', 'rejected', 'disabled'
);
CREATE TYPE template_category AS ENUM ('marketing', 'utility', 'authentication');

CREATE TABLE templates (
  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Identity
  name                    TEXT UNIQUE NOT NULL,
  -- AiSensy template name: lowercase, underscores, e.g. "clothing_festival_offer"
  display_name            TEXT NOT NULL,
  -- Human readable: "Festival Offer"

  -- Classification
  business_type           business_type NOT NULL,
  category                template_category NOT NULL DEFAULT 'marketing',
  language                TEXT NOT NULL DEFAULT 'en',

  -- Template content
  header_type             TEXT DEFAULT 'NONE'
                            CHECK (header_type IN ('NONE', 'TEXT', 'IMAGE', 'DOCUMENT')),
  header_content          TEXT,
  body                    TEXT NOT NULL,
  footer                  TEXT,

  -- Variables
  variables               JSONB NOT NULL DEFAULT '[]',
  /*
  [
    { "index": 1, "key": "shop_name", "description": "Your shop name" },
    { "index": 2, "key": "offer", "description": "Discount e.g. 30% Off" }
  ]
  */

  -- AiSensy / Meta
  aisensy_template_id     TEXT,
  meta_submission_id      TEXT,
  meta_status             meta_approval_status NOT NULL DEFAULT 'draft',
  meta_rejection_reason   TEXT,
  submitted_at            TIMESTAMPTZ,
  approved_at             TIMESTAMPTZ,

  -- Platform
  is_active               BOOLEAN DEFAULT false,
  -- Only set to true after meta_status = 'approved'

  cost_per_message        NUMERIC(6,4),
  -- ₹0.8600 for marketing, ₹0.1200 for utility

  shops_using_count       INTEGER DEFAULT 0,
  -- Denormalized count updated by trigger

  created_by              UUID REFERENCES profiles(id),
  -- Super Admin who created it

  is_deleted              BOOLEAN DEFAULT false,
  created_at              TIMESTAMPTZ DEFAULT now(),
  updated_at              TIMESTAMPTZ DEFAULT now()
);
```

```
Rule: is_active can only be true when meta_status = 'approved'.
Enforced via check constraint:
  CHECK (NOT (is_active = true AND meta_status != 'approved'))

Indexes: business_type, meta_status, is_active, name
RLS:
  shopkeeper → SELECT active templates for their business_type only
  salesperson → SELECT all active templates
  super_admin → ALL operations
```

---

## SECTION 10 — NOTIFICATIONS TABLES

### 10.1 notifications

In-app notifications per user.

```sql
CREATE TYPE notification_type AS ENUM (
  'credit_low',          -- bill or msg credits < 20%
  'credit_exhausted',    -- credits = 0
  'payment_success',     -- AutoPay deducted successfully
  'payment_failed',      -- AutoPay failed
  'topup_success',       -- Credit top-up completed
  'bill_delivered',      -- Bill confirmed delivered by AiSensy
  'bulk_completed',      -- Bulk campaign finished sending
  'bulk_failed',         -- Bulk campaign failed
  'cancellation_update', -- Cancellation request status changed
  'plan_renewed',        -- Monthly subscription renewed
  'plan_expiring',       -- Plan ends in 3 days
  'system'               -- Generic system notification
);

CREATE TABLE notifications (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES profiles(id),
  shop_id         UUID REFERENCES shops(id),

  type            notification_type NOT NULL,
  title           TEXT NOT NULL,
  body            TEXT NOT NULL,

  -- Deep link data
  data            JSONB DEFAULT '{}',
  -- e.g. {"screen": "/credits/topup", "creditType": "bill_credits"}

  -- FCM
  fcm_sent        BOOLEAN DEFAULT false,
  fcm_sent_at     TIMESTAMPTZ,

  is_read         BOOLEAN DEFAULT false,
  read_at         TIMESTAMPTZ,

  created_at      TIMESTAMPTZ DEFAULT now()
  -- No updated_at — only is_read changes, tracked via read_at
);
```

```
FCM push is sent when notification is created (via trigger or Node.js).
In-app notification badge = COUNT WHERE is_read = false AND user_id = auth.uid()

Indexes: user_id, shop_id, is_read, type, created_at
RLS: user → SELECT + UPDATE (is_read) own notifications only
```

### 10.2 fcm_tokens

FCM device tokens per user.

```sql
CREATE TABLE fcm_tokens (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES profiles(id),

  token       TEXT NOT NULL,
  platform    TEXT NOT NULL CHECK (platform IN ('android', 'ios')),
  app_version TEXT,
  is_active   BOOLEAN DEFAULT true,

  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now(),

  UNIQUE(user_id, token)
);
```

```
On new token → upsert (update is_active = true)
Old tokens deactivated after 30 days without update.

Indexes: user_id, token, is_active
RLS: user → SELECT + UPDATE own tokens only
     Node.js service role → ALL (for sending FCM)
```

---

## SECTION 11 — ADMIN & AUDIT TABLES

### 11.1 salespersons

Extended profile for salesperson role with performance tracking.

```sql
CREATE TABLE salespersons (
  id                  UUID PRIMARY KEY REFERENCES profiles(id),
  city_region         TEXT NOT NULL,
  notes               TEXT,
  -- internal notes from Super Admin

  -- Performance (denormalized — updated by trigger)
  total_shops         INTEGER DEFAULT 0,
  active_shops        INTEGER DEFAULT 0,
  revenue_generated   INTEGER DEFAULT 0,
  -- in paise

  new_shops_this_month INTEGER DEFAULT 0,

  is_active           BOOLEAN DEFAULT true,
  deactivated_at      TIMESTAMPTZ,
  deactivated_reason  TEXT,

  created_by          UUID REFERENCES profiles(id),
  -- Super Admin who created this account

  created_at          TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now()
);
```

```
Indexes: is_active, city_region, revenue_generated
RLS:
  salesperson → SELECT own row only
  super_admin → ALL operations
```

### 11.2 cancellation_requests

AutoPay cancellation requests from shopkeepers.

```sql
CREATE TYPE cancellation_request_status AS ENUM (
  'pending',    -- submitted, awaiting salesperson review
  'approved',   -- Super Admin approved + AutoPay cancelled
  'rejected'    -- rejected (shopkeeper stays subscribed)
);

CREATE TYPE cancellation_reason AS ENUM (
  'no_longer_needed',
  'too_expensive',
  'switching_app',
  'technical_issues',
  'other'
);

CREATE TABLE cancellation_requests (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id             UUID NOT NULL REFERENCES shops(id),
  subscription_id     UUID NOT NULL REFERENCES subscriptions(id),
  requested_by        UUID NOT NULL REFERENCES profiles(id),
  -- shopkeeper's profile id

  reason              cancellation_reason NOT NULL,
  custom_reason       TEXT,
  -- filled when reason = 'other'

  -- Processing
  status              cancellation_request_status NOT NULL DEFAULT 'pending',

  -- Salesperson review
  salesperson_note    TEXT,
  salesperson_reviewed_at TIMESTAMPTZ,
  salesperson_action  TEXT CHECK (salesperson_action IN ('approved', 'rejected', NULL)),
  salesperson_id      UUID REFERENCES profiles(id),

  -- Super Admin action
  admin_note          TEXT,
  actioned_by         UUID REFERENCES profiles(id),
  actioned_at         TIMESTAMPTZ,

  -- Impact
  access_ends_at      TIMESTAMPTZ,
  -- set when approved: end of current billing period

  -- Razorpay
  razorpay_cancellation_ref TEXT,

  created_at          TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now()
);
```

```
Business rule: Only ONE active (pending) request per shop at a time.
Enforced via partial unique index:
  CREATE UNIQUE INDEX one_pending_per_shop
    ON cancellation_requests(shop_id)
    WHERE status = 'pending';

Indexes: shop_id, status, created_at, actioned_by
RLS:
  shopkeeper → SELECT own requests only, INSERT only
  salesperson → SELECT requests for their shops
  super_admin → ALL operations
```

### 11.3 webhook_logs

All inbound webhook events logged for debugging and replay.

```sql
CREATE TABLE webhook_logs (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source          TEXT NOT NULL CHECK (source IN ('razorpay', 'aisensy')),
  event_type      TEXT NOT NULL,
  -- e.g. 'payment.captured', 'subscription.activated'
  payload         JSONB NOT NULL,
  signature       TEXT,
  is_valid        BOOLEAN NOT NULL,
  processed       BOOLEAN DEFAULT false,
  processed_at    TIMESTAMPTZ,
  error           TEXT,
  -- error message if processing failed

  created_at      TIMESTAMPTZ DEFAULT now()
);
```

```
Rule: Log ALL incoming webhooks before processing.
If signature invalid: log with is_valid = false, stop processing.
If processing fails: log error, set processed = false for retry.

Retention: auto-delete logs older than 90 days (Supabase scheduled function).

Indexes: source, event_type, processed, created_at
RLS: super_admin only — no other role can access this table
```

### 11.4 admin_actions

Audit log of all Super Admin actions.

```sql
CREATE TABLE admin_actions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id        UUID NOT NULL REFERENCES profiles(id),

  action_type     TEXT NOT NULL,
  -- e.g. 'shop_suspended', 'credits_added', 'plan_changed',
  --      'salesperson_deactivated', 'template_approved'

  target_type     TEXT NOT NULL CHECK (target_type IN (
                    'shop', 'salesperson', 'template', 'subscription',
                    'cancellation_request', 'platform_settings'
                  )),
  target_id       UUID NOT NULL,

  before_state    JSONB,
  after_state     JSONB,
  reason          TEXT,
  notes           TEXT,

  created_at      TIMESTAMPTZ DEFAULT now()
  -- Append-only. Never UPDATE.
);
```

```
All Super Admin mutations write a row here automatically (via trigger or Node.js).
This is the full audit trail for compliance.

Indexes: admin_id, action_type, target_type, target_id, created_at
RLS: super_admin → SELECT only. INSERT via Node.js service role.
```

### 11.5 platform_settings

Global platform configuration. Single row.

```sql
CREATE TABLE platform_settings (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  -- Only ONE row in this table

  -- AiSensy
  aisensy_api_key_hint    TEXT,
  -- NOT the real key — just hint e.g. "****XY89" for display
  -- Real key stored in Node.js .env ONLY
  aisensy_connected       BOOLEAN DEFAULT false,
  aisensy_last_synced_at  TIMESTAMPTZ,
  aisensy_platform_number TEXT,

  -- Razorpay
  razorpay_key_id         TEXT,
  -- Public key — safe to store in DB
  razorpay_connected      BOOLEAN DEFAULT false,
  razorpay_mode           TEXT DEFAULT 'test' CHECK (razorpay_mode IN ('test', 'live')),

  -- Notification settings
  notify_admin_on_cancellation  BOOLEAN DEFAULT true,
  notify_admin_on_payment_fail  BOOLEAN DEFAULT true,
  notify_salesperson_on_cancel  BOOLEAN DEFAULT true,
  admin_whatsapp_number         TEXT,

  -- App
  app_version             TEXT DEFAULT '1.0.0',
  api_version             TEXT DEFAULT '1.0.0',
  maintenance_mode        BOOLEAN DEFAULT false,
  maintenance_message     TEXT,

  updated_by              UUID REFERENCES profiles(id),
  created_at              TIMESTAMPTZ DEFAULT now(),
  updated_at              TIMESTAMPTZ DEFAULT now()
);
```

```
Single-row table. Seed with INSERT on first deploy.
Never INSERT a second row (enforced in Node.js).

RLS: super_admin → SELECT + UPDATE only
```

---

## SECTION 12 — ROW LEVEL SECURITY (RLS) POLICIES

Enable RLS on every table immediately after creation.

```sql
-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_credits ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE bills ENABLE ROW LEVEL SECURITY;
ALTER TABLE bill_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE bill_resends ENABLE ROW LEVEL SECURITY;
ALTER TABLE campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE campaign_recipients ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE credit_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE topup_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE fcm_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE salespersons ENABLE ROW LEVEL SECURITY;
ALTER TABLE cancellation_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE webhook_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE platform_settings ENABLE ROW LEVEL SECURITY;
```

### 12.1 Helper Functions

```sql
-- Get current user's role
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS TEXT AS $$
  SELECT role FROM profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;

-- Get current shopkeeper's shop_id
CREATE OR REPLACE FUNCTION get_shop_id()
RETURNS UUID AS $$
  SELECT id FROM shops WHERE owner_id = auth.uid() AND is_deleted = false LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;

-- Check if current user is super_admin
CREATE OR REPLACE FUNCTION is_super_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  );
$$ LANGUAGE sql SECURITY DEFINER;

-- Check if current user is salesperson
CREATE OR REPLACE FUNCTION is_salesperson()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'salesperson'
  );
$$ LANGUAGE sql SECURITY DEFINER;
```

### 12.2 Key RLS Policies

```sql
-- ── SHOPS ──────────────────────────────────────────────────────────────────
-- Shopkeeper: select own shop only
CREATE POLICY "shopkeeper_select_own_shop"
  ON shops FOR SELECT
  USING (owner_id = auth.uid() AND is_deleted = false);

-- Salesperson: select their assigned shops
CREATE POLICY "salesperson_select_own_shops"
  ON shops FOR SELECT
  USING (salesperson_id = auth.uid() AND is_deleted = false);

-- Salesperson: insert new shops
CREATE POLICY "salesperson_insert_shops"
  ON shops FOR INSERT
  WITH CHECK (salesperson_id = auth.uid() AND is_salesperson());

-- Salesperson: update their shops
CREATE POLICY "salesperson_update_own_shops"
  ON shops FOR UPDATE
  USING (salesperson_id = auth.uid());

-- Super Admin: all operations
CREATE POLICY "admin_all_shops"
  ON shops FOR ALL
  USING (is_super_admin());


-- ── CUSTOMERS ──────────────────────────────────────────────────────────────
-- Shopkeeper: all operations on own shop's customers
CREATE POLICY "shopkeeper_all_customers"
  ON customers FOR ALL
  USING (shop_id = get_shop_id() AND is_deleted = false);

-- Super Admin: all operations
CREATE POLICY "admin_all_customers"
  ON customers FOR ALL
  USING (is_super_admin());


-- ── BILLS ──────────────────────────────────────────────────────────────────
-- Shopkeeper: select + insert own bills (no update of core fields)
CREATE POLICY "shopkeeper_select_bills"
  ON bills FOR SELECT
  USING (shop_id = get_shop_id() AND is_deleted = false);

CREATE POLICY "shopkeeper_insert_bills"
  ON bills FOR INSERT
  WITH CHECK (shop_id = get_shop_id());

-- Shopkeeper: update ONLY status, delivered_at (not financial fields)
CREATE POLICY "shopkeeper_update_bill_status"
  ON bills FOR UPDATE
  USING (shop_id = get_shop_id())
  WITH CHECK (shop_id = get_shop_id());
  -- Core field immutability enforced via trigger (Section 16.2)

-- Super Admin: all
CREATE POLICY "admin_all_bills"
  ON bills FOR ALL
  USING (is_super_admin());


-- ── CAMPAIGNS ──────────────────────────────────────────────────────────────
CREATE POLICY "shopkeeper_all_campaigns"
  ON campaigns FOR ALL
  USING (shop_id = get_shop_id());

CREATE POLICY "admin_all_campaigns"
  ON campaigns FOR ALL
  USING (is_super_admin());


-- ── SHOP_CREDITS ───────────────────────────────────────────────────────────
-- Shopkeeper: select only (updates via DB function only)
CREATE POLICY "shopkeeper_select_credits"
  ON shop_credits FOR SELECT
  USING (shop_id = get_shop_id());

-- Super Admin: all
CREATE POLICY "admin_all_credits"
  ON shop_credits FOR ALL
  USING (is_super_admin());


-- ── TEMPLATES ──────────────────────────────────────────────────────────────
-- Shopkeeper: select active templates for their business type
CREATE POLICY "shopkeeper_select_templates"
  ON templates FOR SELECT
  USING (
    is_active = true
    AND meta_status = 'approved'
    AND is_deleted = false
    AND business_type = (
      SELECT business_type FROM shops WHERE owner_id = auth.uid() LIMIT 1
    )
  );

-- Super Admin: all operations
CREATE POLICY "admin_all_templates"
  ON templates FOR ALL
  USING (is_super_admin());


-- ── NOTIFICATIONS ──────────────────────────────────────────────────────────
CREATE POLICY "user_own_notifications"
  ON notifications FOR ALL
  USING (user_id = auth.uid());


-- ── CANCELLATION_REQUESTS ──────────────────────────────────────────────────
-- Shopkeeper: select own, insert
CREATE POLICY "shopkeeper_cancellation_requests"
  ON cancellation_requests FOR SELECT
  USING (requested_by = auth.uid());

CREATE POLICY "shopkeeper_insert_cancellation"
  ON cancellation_requests FOR INSERT
  WITH CHECK (
    requested_by = auth.uid()
    AND shop_id = get_shop_id()
  );

-- Salesperson: select requests for their shops
CREATE POLICY "salesperson_cancellation_requests"
  ON cancellation_requests FOR SELECT
  USING (
    shop_id IN (
      SELECT id FROM shops WHERE salesperson_id = auth.uid()
    )
  );

-- Super Admin: all
CREATE POLICY "admin_all_cancellations"
  ON cancellation_requests FOR ALL
  USING (is_super_admin());


-- ── WEBHOOK_LOGS ───────────────────────────────────────────────────────────
-- Super Admin only
CREATE POLICY "admin_only_webhook_logs"
  ON webhook_logs FOR ALL
  USING (is_super_admin());


-- ── ADMIN_ACTIONS ──────────────────────────────────────────────────────────
CREATE POLICY "admin_only_admin_actions"
  ON admin_actions FOR SELECT
  USING (is_super_admin());
```

---

## SECTION 13 — INDEXES

Critical indexes for query performance. Create after tables.

```sql
-- ── SHOPS ──────────────────────────────────────────────────────────────────
CREATE INDEX idx_shops_owner_id ON shops(owner_id);
CREATE INDEX idx_shops_salesperson_id ON shops(salesperson_id);
CREATE INDEX idx_shops_status ON shops(status);
CREATE INDEX idx_shops_plan ON shops(plan);
CREATE INDEX idx_shops_business_type ON shops(business_type);
CREATE INDEX idx_shops_city ON shops(city);
CREATE INDEX idx_shops_created_at ON shops(created_at DESC);

-- ── CUSTOMERS ──────────────────────────────────────────────────────────────
CREATE INDEX idx_customers_shop_id ON customers(shop_id);
CREATE INDEX idx_customers_phone ON customers(phone);
CREATE INDEX idx_customers_name ON customers USING gin(to_tsvector('english', name));
-- Full-text search on name
CREATE INDEX idx_customers_last_bill_date ON customers(last_bill_date DESC);
CREATE INDEX idx_customers_total_billed ON customers(total_billed_amount DESC);

-- ── BILLS ──────────────────────────────────────────────────────────────────
CREATE INDEX idx_bills_shop_id ON bills(shop_id);
CREATE INDEX idx_bills_customer_id ON bills(customer_id);
CREATE INDEX idx_bills_status ON bills(status);
CREATE INDEX idx_bills_created_at ON bills(created_at DESC);
CREATE INDEX idx_bills_sent_at ON bills(sent_at DESC);
CREATE INDEX idx_bills_bill_number ON bills(bill_number);
CREATE INDEX idx_bills_shop_created ON bills(shop_id, created_at DESC);
-- Compound — for "bills for this shop sorted by date" query

-- ── BILL_ITEMS ─────────────────────────────────────────────────────────────
CREATE INDEX idx_bill_items_bill_id ON bill_items(bill_id);
CREATE INDEX idx_bill_items_shop_id ON bill_items(shop_id);

-- ── CAMPAIGNS ──────────────────────────────────────────────────────────────
CREATE INDEX idx_campaigns_shop_id ON campaigns(shop_id);
CREATE INDEX idx_campaigns_status ON campaigns(status);
CREATE INDEX idx_campaigns_created_at ON campaigns(created_at DESC);

-- ── CAMPAIGN_RECIPIENTS ────────────────────────────────────────────────────
CREATE INDEX idx_campaign_recipients_campaign_id ON campaign_recipients(campaign_id);
CREATE INDEX idx_campaign_recipients_shop_id ON campaign_recipients(shop_id);
CREATE INDEX idx_campaign_recipients_status ON campaign_recipients(status);
CREATE INDEX idx_campaign_recipients_aisensy_id ON campaign_recipients(aisensy_message_id);

-- ── SUBSCRIPTIONS ──────────────────────────────────────────────────────────
CREATE INDEX idx_subscriptions_shop_id ON subscriptions(shop_id);
CREATE INDEX idx_subscriptions_razorpay_id ON subscriptions(razorpay_subscription_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_next_billing ON subscriptions(next_billing_date);

-- ── CREDIT_TRANSACTIONS ────────────────────────────────────────────────────
CREATE INDEX idx_credit_tx_shop_id ON credit_transactions(shop_id);
CREATE INDEX idx_credit_tx_type ON credit_transactions(transaction_type);
CREATE INDEX idx_credit_tx_reference ON credit_transactions(reference_type, reference_id);
CREATE INDEX idx_credit_tx_created_at ON credit_transactions(created_at DESC);

-- ── TOPUP_ORDERS ───────────────────────────────────────────────────────────
CREATE INDEX idx_topup_shop_id ON topup_orders(shop_id);
CREATE INDEX idx_topup_razorpay_order ON topup_orders(razorpay_order_id);
CREATE INDEX idx_topup_razorpay_payment ON topup_orders(razorpay_payment_id);
CREATE INDEX idx_topup_status ON topup_orders(status);

-- ── TEMPLATES ──────────────────────────────────────────────────────────────
CREATE INDEX idx_templates_business_type ON templates(business_type);
CREATE INDEX idx_templates_meta_status ON templates(meta_status);
CREATE INDEX idx_templates_is_active ON templates(is_active);

-- ── NOTIFICATIONS ──────────────────────────────────────────────────────────
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_shop_id ON notifications(shop_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);

-- ── CANCELLATION_REQUESTS ──────────────────────────────────────────────────
CREATE INDEX idx_cancel_req_shop_id ON cancellation_requests(shop_id);
CREATE INDEX idx_cancel_req_status ON cancellation_requests(status);
CREATE INDEX idx_cancel_req_created_at ON cancellation_requests(created_at DESC);

-- ── WEBHOOK_LOGS ───────────────────────────────────────────────────────────
CREATE INDEX idx_webhook_logs_source ON webhook_logs(source);
CREATE INDEX idx_webhook_logs_processed ON webhook_logs(processed);
CREATE INDEX idx_webhook_logs_created_at ON webhook_logs(created_at DESC);
```

---

## SECTION 14 — SUPABASE STORAGE BUCKETS

```sql
-- Create storage buckets (via Supabase dashboard or API)

-- 1. Shop logos
-- Bucket: shop-logos
-- Access: Private (served via signed URL or Node.js proxy)
-- Max file size: 2MB
-- Allowed types: image/jpeg, image/png
-- Path pattern: {shopId}.jpg

-- 2. Bill PDFs
-- Bucket: bills
-- Access: Private (served via signed URL — time-limited)
-- Max file size: 5MB
-- Allowed type: application/pdf
-- Path pattern: {shopId}/{billId}.pdf

-- 3. App assets (illustrations, icons — if stored in Supabase)
-- Bucket: app-assets
-- Access: Public
-- Max file size: 1MB
```

```
Signed URL expiry:
  shop-logos:  7 days (logo doesn't change often)
  bills:       1 hour (re-generate URL when expired)

RLS on storage:
  shop-logos: shopkeeper can read own logo; salesperson can read any logo; public cannot
  bills: shopkeeper can read own bills only; public cannot
```

---

## SECTION 15 — SUPABASE REALTIME SUBSCRIPTIONS

Flutter listens to these real-time channels:

```dart
// 1. Credit balance (live update when credits change)
// Screen: S1-03 Dashboard, S1-16 Credits
supabase
  .from('shop_credits')
  .stream(primaryKey: ['id'])
  .eq('shop_id', shopId)
  .listen((data) { /* update credits in Riverpod */ });

// 2. Notifications (live new notification badge)
// Screen: All screens (tab bar bell)
supabase
  .from('notifications')
  .stream(primaryKey: ['id'])
  .eq('user_id', userId)
  .order('created_at', ascending: false)
  .limit(20)
  .listen((data) { /* update notification count */ });

// 3. Campaign delivery status (polling alternative)
// Screen: S1-15 Delivery Report
supabase
  .from('campaigns')
  .stream(primaryKey: ['id'])
  .eq('id', campaignId)
  .listen((data) { /* update delivery stats in real-time */ });

// 4. AutoPay mandate status (polling during S2-07)
// Screen: S2-07 Add Shop AutoPay
supabase
  .from('subscriptions')
  .stream(primaryKey: ['id'])
  .eq('shop_id', shopId)
  .listen((data) { /* check mandate status */ });
```

```
Enable Realtime on these tables (Supabase dashboard → Table Editor → Enable Realtime):
  ✓ shop_credits
  ✓ notifications
  ✓ campaigns
  ✓ subscriptions

Do NOT enable Realtime on:
  ✗ bills (too high volume — use REST polling instead)
  ✗ credit_transactions (append-only, high volume)
  ✗ webhook_logs (internal only)
  ✗ admin_actions (internal only)
```

---

## SECTION 16 — DATABASE FUNCTIONS & TRIGGERS

### 16.1 Atomic Credit Deduction Function

```sql
-- Used for bill send — deducts 1 bill_credit atomically
CREATE OR REPLACE FUNCTION deduct_bill_credit(p_shop_id UUID, p_bill_id UUID)
RETURNS JSON AS $$
DECLARE
  v_current_credits INTEGER;
  v_new_credits INTEGER;
BEGIN
  -- Lock the row for update (prevents race conditions)
  SELECT bill_credits INTO v_current_credits
  FROM shop_credits
  WHERE shop_id = p_shop_id
  FOR UPDATE;

  -- Check sufficient credits
  IF v_current_credits <= 0 THEN
    RETURN json_build_object(
      'success', false,
      'error', 'INSUFFICIENT_BILL_CREDITS',
      'credits', v_current_credits
    );
  END IF;

  -- Deduct credit
  v_new_credits := v_current_credits - 1;

  UPDATE shop_credits
  SET
    bill_credits = v_new_credits,
    bill_credits_used = bill_credits_used + 1,
    updated_at = now()
  WHERE shop_id = p_shop_id;

  -- Log the transaction
  INSERT INTO credit_transactions (
    shop_id, credit_type, transaction_type,
    amount, balance_before, balance_after,
    reference_type, reference_id
  ) VALUES (
    p_shop_id, 'bill_credits', 'bill_deduction',
    -1, v_current_credits, v_new_credits,
    'bill', p_bill_id
  );

  RETURN json_build_object(
    'success', true,
    'credits_remaining', v_new_credits
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### 16.2 Bill Immutability Trigger

```sql
-- Prevent updates to core financial fields after bill is sent
CREATE OR REPLACE FUNCTION enforce_bill_immutability()
RETURNS TRIGGER AS $$
BEGIN
  IF OLD.status = 'sent' THEN
    IF NEW.subtotal != OLD.subtotal OR
       NEW.total != OLD.total OR
       NEW.gst_amount != OLD.gst_amount OR
       NEW.customer_id != OLD.customer_id THEN
      RAISE EXCEPTION 'Cannot modify financial fields of a sent bill';
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER bill_immutability_trigger
  BEFORE UPDATE ON bills
  FOR EACH ROW
  EXECUTE FUNCTION enforce_bill_immutability();
```

### 16.3 Auto-Update updated_at Trigger

```sql
-- Apply to all tables with updated_at column
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to each table
CREATE TRIGGER update_shops_updated_at
  BEFORE UPDATE ON shops
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_customers_updated_at
  BEFORE UPDATE ON customers
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Repeat for: shop_credits, shop_settings, bills, campaigns,
-- subscriptions, topup_orders, templates, notifications, etc.
```

### 16.4 Customer Stats Update Trigger

```sql
-- Auto-update customer total_bills_count + total_billed_amount when bill is sent
CREATE OR REPLACE FUNCTION update_customer_stats()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'sent' AND OLD.status != 'sent' THEN
    UPDATE customers
    SET
      total_bills_count = total_bills_count + 1,
      total_billed_amount = total_billed_amount + NEW.total,
      last_bill_date = NEW.sent_at,
      updated_at = now()
    WHERE id = NEW.customer_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER customer_stats_trigger
  AFTER UPDATE ON bills
  FOR EACH ROW EXECUTE FUNCTION update_customer_stats();
```

### 16.5 Bill Number Generator Function

```sql
-- Generates next bill number for a shop
CREATE OR REPLACE FUNCTION generate_bill_number(p_shop_id UUID)
RETURNS TEXT AS $$
DECLARE
  v_counter INTEGER;
  v_year TEXT;
  v_prefix TEXT;
BEGIN
  -- Get and increment counter atomically
  UPDATE shop_settings
  SET
    bill_number_counter = bill_number_counter + 1,
    updated_at = now()
  WHERE shop_id = p_shop_id
  RETURNING bill_number_counter - 1 INTO v_counter;
  -- Return the PREVIOUS value (before increment) as the bill number

  SELECT bill_number_prefix INTO v_prefix
  FROM shop_settings WHERE shop_id = p_shop_id;

  v_year := EXTRACT(YEAR FROM now())::TEXT;

  RETURN v_prefix || '-' || v_year || '-' || LPAD(v_counter::TEXT, 4, '0');
  -- e.g. BILL-2026-0042
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### 16.6 Monthly Credits Reset (Supabase Edge Function — Cron)

```javascript
// Runs on 1st of every month at 00:01 IST
// Supabase Edge Function: reset-credits
// Schedule: 0 18 28-31 * * (runs on last day of month at 18:30 UTC = 00:00 IST next day)

import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  Deno.env.get('SUPABASE_URL'),
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
)

// Get all active shops + their plan limits
const { data: shops } = await supabase
  .from('shops')
  .select('id, plan')
  .eq('status', 'active')

const planLimits = {
  basic:    { bill: 100,   msg: 300 },
  pro:      { bill: 300,   msg: 800 },
  business: { bill: 99999, msg: 2000 },
}

for (const shop of shops) {
  const limits = planLimits[shop.plan]

  // Reset credits to plan limit (unused credits do NOT roll over)
  await supabase
    .from('shop_credits')
    .update({
      bill_credits: limits.bill,
      bill_credits_limit: limits.bill,
      bill_credits_used: 0,
      msg_credits: limits.msg,
      msg_credits_limit: limits.msg,
      msg_credits_used: 0,
      billing_cycle_start: new Date().toISOString().split('T')[0],
      billing_cycle_end: getLastDayOfMonth(),
      credits_reset_at: new Date().toISOString(),
    })
    .eq('shop_id', shop.id)

  // Log reset transaction
  await supabase.from('credit_transactions').insert([
    {
      shop_id: shop.id,
      credit_type: 'bill_credits',
      transaction_type: 'monthly_reset',
      amount: limits.bill,
      balance_before: 0, // simplified
      balance_after: limits.bill,
      reference_type: 'system',
    },
    {
      shop_id: shop.id,
      credit_type: 'msg_credits',
      transaction_type: 'monthly_reset',
      amount: limits.msg,
      balance_before: 0,
      balance_after: limits.msg,
      reference_type: 'system',
    }
  ])
}
```

---

## SECTION 17 — SEED DATA

Initial data required before the app can run.

```sql
-- 1. Platform settings (single row)
INSERT INTO platform_settings (
  razorpay_mode,
  notify_admin_on_cancellation,
  notify_admin_on_payment_fail,
  app_version
) VALUES (
  'test',
  true,
  true,
  '1.0.0'
);

-- 2. WhatsApp Templates (7 business types)
INSERT INTO templates (name, display_name, business_type, category, body, variables, is_active, meta_status) VALUES
(
  'clothing_festival_offer',
  'Festival Offer',
  'clothing',
  'marketing',
  'New arrivals at {{1}}! Visit us for {{2}} this {{3}}. Come in-store today.',
  '[{"index":1,"key":"shop_name","description":"Shop name"},{"index":2,"key":"offer","description":"Discount e.g. 30% Off"},{"index":3,"key":"season","description":"Season e.g. Diwali"}]',
  false, -- set to true after Meta approval
  'draft'
),
(
  'steel_price_update',
  'Price Update Alert',
  'steel',
  'marketing',
  'Today steel price update from {{1}}: TMT Rod {{2}}/kg, MS Angle {{3}}/kg. Call us to book.',
  '[{"index":1,"key":"shop_name","description":"Shop name"},{"index":2,"key":"tmt_price","description":"TMT rod price"},{"index":3,"key":"ms_price","description":"MS Angle price"}]',
  false,
  'draft'
),
(
  'electronics_new_arrival',
  'New Arrival',
  'electronics',
  'marketing',
  'New stock arrived at {{1}}! Check out our latest {{2}} collection. Visit us or call for details.',
  '[{"index":1,"key":"shop_name","description":"Shop name"},{"index":2,"key":"product","description":"Product type e.g. Smart TVs"}]',
  false,
  'draft'
),
(
  'grocery_daily_deal',
  'Daily Deal',
  'grocery',
  'marketing',
  'Fresh arrivals at {{1}} today! {{2}} Special: {{3}} at just {{4}}. Limited stock, visit us now!',
  '[{"index":1,"key":"shop_name","description":"Shop name"},{"index":2,"key":"day","description":"Today/Tomorrow etc"},{"index":3,"key":"item","description":"Product name"},{"index":4,"key":"price","description":"Price"}]',
  false,
  'draft'
),
(
  'pharmacy_reminder',
  'Medicine Reminder',
  'pharmacy',
  'utility',
  'Reminder from {{1}}: Your prescription refill may be due soon. Visit us or call {{2}} to order your medicines.',
  '[{"index":1,"key":"shop_name","description":"Pharmacy name"},{"index":2,"key":"phone","description":"Contact number"}]',
  false,
  'draft'
),
(
  'jewellery_gold_rate',
  'Gold Rate Update',
  'jewellery',
  'marketing',
  "Today's gold rate at {{1}}: 22K - {{2}}/gram, 24K - {{3}}/gram. Book your custom design. Call {{4}}.",
  '[{"index":1,"key":"shop_name","description":"Shop name"},{"index":2,"key":"22k_rate","description":"22K price per gram"},{"index":3,"key":"24k_rate","description":"24K price per gram"},{"index":4,"key":"phone","description":"Contact number"}]',
  false,
  'draft'
),
(
  'furniture_delivery_update',
  'Delivery Update',
  'furniture',
  'utility',
  'Good news from {{1}}! Your furniture is ready. Please contact us at {{2}} to schedule your delivery date.',
  '[{"index":1,"key":"shop_name","description":"Shop name"},{"index":2,"key":"phone","description":"Contact number"}]',
  false,
  'draft'
);

-- 3. Razorpay Plans (create via Razorpay dashboard, store IDs here)
-- These are created in Razorpay dashboard first, then their IDs stored in Node.js .env
-- RAZORPAY_PLAN_ID_BASIC=plan_xxx
-- RAZORPAY_PLAN_ID_PRO=plan_yyy
-- RAZORPAY_PLAN_ID_BUSINESS=plan_zzz
```

---

## QUICK REFERENCE — TABLE RELATIONSHIPS

```
profiles (1) ──────────────── (1) salespersons
    │
    │ owner_id
    ▼
shops (1) ──────────────────── (1) shop_credits
    │                           (1) shop_settings
    │                           (1) subscriptions
    │ shop_id
    ├──── customers (many)
    │         │ customer_id
    │         ▼
    ├──── bills (many)
    │         │ bill_id
    │         └──── bill_items (many)
    │         └──── bill_resends (many)
    │
    ├──── campaigns (many)
    │         │ campaign_id
    │         └──── campaign_recipients (many)
    │
    ├──── credit_transactions (many)
    ├──── topup_orders (many)
    └──── notifications (many via shop_id)

templates (1) ──── shops (many, via template_id)
               └── campaigns (many, via template_id)

cancellation_requests ──── shops (via shop_id)
                       └── subscriptions (via subscription_id)
```

---

*DATABASE.md v1.0 — Billing Project — One Stop Solutions*
*Complete Supabase schema · 21 tables · July 2026*
*Next document: FLOWS.md*
