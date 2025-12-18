import { createClient } from "npm:@supabase/supabase-js@2.48.0";

type RcPayload = Record<string, unknown>;

type Store = "app_store" | "play_store" | "stripe" | "promotional";

const JSON_HEADERS = { "Content-Type": "application/json" };

const json = (body: unknown, status = 200): Response =>
  new Response(JSON.stringify(body), { status, headers: JSON_HEADERS });

type Env = {
  SUPABASE_URL?: string;
  SUPABASE_SERVICE_ROLE_KEY?: string;
  RC_WEBHOOK_SECRET?: string;
};

type SupabaseRpcResult = { error: { message?: string } | null };
type SupabaseTableInsertResult = { error: { message?: string } | null };

export type SupabaseLike = {
  rpc: (fn: string, args: Record<string, unknown>) => Promise<SupabaseRpcResult>;
  from: (table: string) => {
    insert: (row: Record<string, unknown>) => Promise<SupabaseTableInsertResult>;
  };
};

export const statusFromEvent = (
  eventType?: string,
): "active" | "cancelled" | "expired" | "inactive" => {
  const normalized = (eventType ?? "").toUpperCase();
  switch (normalized) {
    case "INITIAL_PURCHASE":
    case "RENEWAL":
    case "PRODUCT_CHANGE":
    case "UNCANCELLATION":
      return "active";
    case "CANCELLATION":
    case "BILLING_ISSUE":
      return "cancelled";
    case "EXPIRATION":
      return "expired";
    default:
      return "inactive";
  }
};

export const storeFromPayload = (value?: string | null): Store => {
  const normalized = (value ?? "").toLowerCase();
  if (normalized.includes("app_store") || normalized === "apple") return "app_store";
  if (normalized.includes("play_store") || normalized === "google") return "play_store";
  if (normalized.includes("stripe")) return "stripe";
  return "promotional"; // you can later tighten this if you add more stores
};

export const parseDate = (value: unknown): string | null => {
  if (value === null || value === undefined) return null;

  // number → detect seconds vs milliseconds
  if (typeof value === "number") {
    const asMs = value < 1e12 ? value * 1000 : value;
    const d = new Date(asMs);
    return Number.isNaN(d.getTime()) ? null : d.toISOString();
  }

  // digit-only string → detect seconds vs milliseconds based on length
  if (typeof value === "string" && /^\d+$/.test(value)) {
    const num = Number(value);
    const asMs = value.length === 10 ? num * 1000 : num;
    const d = new Date(asMs);
    return Number.isNaN(d.getTime()) ? null : d.toISOString();
  }

  // Fallback: let Date parse strings like "2025-01-01T00:00:00Z"
  const d = new Date(String(value));
  return Number.isNaN(d.getTime()) ? null : d.toISOString();
};

const UUID_REGEX =
  /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$/;

export const asUuid = (value: unknown): string | null => {
  if (typeof value !== "string") return null;
  const trimmed = value.trim();
  return UUID_REGEX.test(trimmed) ? trimmed : null;
};

// ✅ IMPORTANT: Only start the server when this file is run directly.
// When imported by `deno test`, this block will NOT execute.
export const extractBearerToken = (authHeader: string | null): string => {
  const header = (authHeader ?? "").trim();
  if (header.toLowerCase().startsWith("bearer ")) return header.slice(7).trim();
  return header;
};

export const handleRevenueCatWebhook = async (
  req: Request,
  env: Env,
  createSupabase: (url: string, key: string) => SupabaseLike = (url, key) =>
    createClient(url, key, {
      auth: { autoRefreshToken: false, persistSession: false },
    }) as unknown as SupabaseLike,
): Promise<Response> => {
  const supabaseUrl = env.SUPABASE_URL;
  const supabaseKey = env.SUPABASE_SERVICE_ROLE_KEY;
  const webhookSecret = env.RC_WEBHOOK_SECRET;

  if (!supabaseUrl || !supabaseKey) {
    return json(
      { error: "Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY" },
      500,
    );
  }

  if (!webhookSecret) {
    return json({ error: "Missing RC_WEBHOOK_SECRET" }, 500);
  }

  const token = extractBearerToken(req.headers.get("authorization"));
  if (token !== webhookSecret) {
    return json({ error: "Unauthorized" }, 401);
  }

  let payload: RcPayload;
  try {
    payload = await req.json();
  } catch (_err) {
    return json({ error: "Invalid JSON body" }, 400);
  }

  const event = payload?.event as Record<string, unknown> | undefined;
  const transaction = payload?.transaction as Record<string, unknown> | undefined;

  const eventType =
    (event?.type as string | undefined) ??
    (payload?.event_type as string | undefined) ??
    (payload?.type as string | undefined);

  const appUserId =
    (payload?.app_user_id as string | undefined) ??
    (event?.app_user_id as string | undefined);

  const entitlementId =
    (payload?.entitlement_id as string | undefined) ??
    ((payload?.entitlement_ids as string[] | undefined)?.[0]) ??
    (event?.entitlement_id as string | undefined);

  const productId =
    (payload?.product_id as string | undefined) ??
    (event?.product_id as string | undefined) ??
    (transaction?.product_id as string | undefined);

  const storeRaw =
    (payload?.store as string | undefined) ??
    (event?.store as string | undefined) ??
    (payload?.platform as string | undefined);

  const environment =
    (payload?.environment as string | undefined) ??
    (event?.environment as string | undefined);

  const subscriberAttributes = payload?.subscriber_attributes as
    | Record<string, unknown>
    | undefined;
  const homeIdAttr = subscriberAttributes?.home_id as
    | Record<string, unknown>
    | string
    | undefined;

  const homeIdValue =
    typeof homeIdAttr === "object" && homeIdAttr !== null && "value" in homeIdAttr
      ? (homeIdAttr as { value?: unknown }).value
      : homeIdAttr;
  const homeId = asUuid(homeIdValue);

  const currentPeriodEndAt = parseDate(
    payload?.expiration_at_ms ??
      event?.expiration_at_ms ??
      event?.expiration_at,
  );

  const originalPurchaseAt = parseDate(
    payload?.original_purchase_at_ms ??
      event?.original_purchase_at_ms ??
      event?.original_purchase_at,
  );

  const lastPurchaseAt = parseDate(
    payload?.purchased_at_ms ??
      event?.purchased_at_ms ??
      event?.purchased_at,
  );

  const latestTransactionId =
    (payload?.transaction_id as string | undefined) ??
    (event?.transaction_id as string | undefined) ??
    (transaction?.transaction_id as string | undefined);

  const eventTimestamp = parseDate(
    payload?.event_timestamp_ms ??
      event?.event_timestamp_ms ??
      payload?.sent_at_ms ??
      event?.sent_at_ms,
  );

  const store = storeFromPayload(storeRaw);
  const status = statusFromEvent(eventType);

  const supabase = createSupabase(supabaseUrl, supabaseKey);

  const appUserUuid = asUuid(appUserId);

  if (!appUserUuid || !entitlementId || !productId) {
    await supabase.from("revenuecat_webhook_events").insert({
      rc_app_user_id: appUserId ?? "unknown",
      entitlement_id: entitlementId ?? "unknown",
      product_id: productId ?? "unknown",
      store,
      status,
      current_period_end_at: currentPeriodEndAt,
      original_purchase_at: originalPurchaseAt,
      last_purchase_at: lastPurchaseAt,
      latest_transaction_id: latestTransactionId,
      home_id: homeId,
      event_timestamp: eventTimestamp,
      environment,
      raw: payload,
      error: "Missing or invalid app_user_id/entitlement/product",
    });

    return json({ error: "Invalid webhook payload" }, 400);
  }

  const { error } = await supabase.rpc("paywall_record_subscription", {
    p_user_id: appUserUuid,
    p_home_id: homeId,
    p_store: store,
    p_rc_app_user_id: appUserId,
    p_entitlement_id: entitlementId,
    p_product_id: productId,
    p_status: status,
    p_current_period_end_at: currentPeriodEndAt,
    p_original_purchase_at: originalPurchaseAt,
    p_last_purchase_at: lastPurchaseAt,
    p_latest_transaction_id: latestTransactionId,
    p_event_timestamp: eventTimestamp,
    p_environment: environment,
    p_raw_event: payload,
    p_error: null,
  });

  if (error) {
    await supabase.from("revenuecat_webhook_events").insert({
      rc_app_user_id: appUserId,
      entitlement_id: entitlementId,
      product_id: productId,
      store,
      status,
      current_period_end_at: currentPeriodEndAt,
      original_purchase_at: originalPurchaseAt,
      last_purchase_at: lastPurchaseAt,
      latest_transaction_id: latestTransactionId,
      home_id: homeId,
      event_timestamp: eventTimestamp,
      environment,
      raw: payload,
      error: error.message ?? "rpc_failed",
    });

    return json(
      { error: "Failed to persist subscription", details: error.message },
      500,
    );
  }

  return json({ ok: true }, 200);
};

if (import.meta.main) {
  Deno.serve(async (req: Request) => {
    const env: Env = {
      SUPABASE_URL: Deno.env.get("SUPABASE_URL") ?? undefined,
      SUPABASE_SERVICE_ROLE_KEY: Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ??
        undefined,
      RC_WEBHOOK_SECRET: Deno.env.get("RC_WEBHOOK_SECRET") ?? undefined,
    };
    return await handleRevenueCatWebhook(req, env);
  });
}
