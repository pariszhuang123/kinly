// supabase/functions/revenue_webhook/index.ts
import { createClient } from "npm:@supabase/supabase-js@2.48.0";
import {
  computeIdempotencyKey,
  parseWebhookPayload,
  type RcPayload,
  type Store,
  type SubscriptionStatus,
} from "./parse.ts";

const JSON_HEADERS = { "Content-Type": "application/json" };
const json = (body: unknown, status = 200): Response =>
  new Response(JSON.stringify(body), { status, headers: JSON_HEADERS });

type Env = {
  SUPABASE_URL?: string;
  SUPABASE_SERVICE_ROLE_KEY?: string;
  RC_WEBHOOK_SECRET?: string; // raw secret token (NOT including "Bearer ")
};

type SbError = { message?: string; code?: string; details?: string; hint?: string } | null;

type SupabaseRpcResult<T> = { error: SbError; data?: T };
type SupabaseTableWriteResult = { error: SbError; data?: Array<Record<string, unknown>> };

export type SupabaseLike = {
  rpc: <T = unknown>(fn: string, args: Record<string, unknown>) => Promise<SupabaseRpcResult<T>>;
  from: (table: string) => {
    insert: (
      row: Record<string, unknown>,
      options?: { returning?: "minimal" | "representation" },
    ) => Promise<SupabaseTableWriteResult>;
    upsert: (
      row: Record<string, unknown>,
      options?: {
        onConflict?: string;
        ignoreDuplicates?: boolean;
        returning?: "minimal" | "representation";
      },
    ) => Promise<SupabaseTableWriteResult>;
  };
};

const createSupabaseDefault = (url: string, key: string): SupabaseLike =>
  createClient(url, key, {
    auth: { autoRefreshToken: false, persistSession: false },
  }) as unknown as SupabaseLike;

/** Accept ONLY "Authorization: Bearer <token>" */
export const extractBearerTokenStrict = (authHeader: string | null): string | null => {
  const header = (authHeader ?? "").trim();
  const lower = header.toLowerCase();
  if (!lower.startsWith("bearer ")) return null;
  const token = header.slice(7).trim();
  return token.length > 0 ? token : null;
};

/** Constant-time string compare (UTF-8 bytes) */
const timingSafeEqual = (a: string, b: string): boolean => {
  const enc = new TextEncoder();
  const aBytes = enc.encode(a);
  const bBytes = enc.encode(b);
  const len = Math.max(aBytes.length, bBytes.length);

  let diff = aBytes.length ^ bBytes.length;
  for (let i = 0; i < len; i++) diff |= (aBytes[i] ?? 0) ^ (bBytes[i] ?? 0);
  return diff === 0;
};

/**
 * Retry classifier.
 * Default FALSE for safety (avoid endless retry storms on permanent bugs/data issues).
 */
const isTransientDbError = (err: SbError): boolean => {
  const code = (err?.code ?? "").trim();
  const msg = (err?.message ?? "").toLowerCase();

  // Best signal: SQLSTATE
  if (code === "40001") return true; // serialization_failure
  if (code === "40P01") return true; // deadlock_detected
  if (code === "57014") return true; // query_canceled / statement_timeout

  // Fallback to message heuristics ONLY when code missing
  if (!code) {
    if (msg.includes("timeout")) return true;
    if (msg.includes("connection")) return true;
    if (msg.includes("network")) return true;
    if (msg.includes("could not connect")) return true;
    if (msg.includes("too many")) return true; // rate limit-ish
  }

  return false;
};

/**
 * Read request body as JSON with a hard byte limit to avoid abuse/accidental huge payloads.
 * - RevenueCat payloads are normally small; 256KB is generous.
 */
const readJsonWithLimit = async (req: Request, maxBytes = 256_000): Promise<unknown> => {
  const contentLength = req.headers.get("content-length");
  if (contentLength) {
    const n = Number(contentLength);
    if (Number.isFinite(n) && n > maxBytes) throw new Error("payload_too_large");
  }

  const reader = req.body?.getReader();
  if (!reader) throw new Error("missing_body");

  const chunks: Uint8Array[] = [];
  let total = 0;

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    if (!value) continue;

    total += value.length;
    if (total > maxBytes) throw new Error("payload_too_large");
    chunks.push(value);
  }

  const merged = new Uint8Array(total);
  let offset = 0;
  for (const c of chunks) {
    merged.set(c, offset);
    offset += c.length;
  }

  const text = new TextDecoder().decode(merged);
  return JSON.parse(text);
};

const isPlainObject = (v: unknown): v is Record<string, unknown> =>
  typeof v === "object" && v !== null && !Array.isArray(v);

export const handleRevenueCatWebhook = async (
  req: Request,
  env: Env,
  createSupabase: (url: string, key: string) => SupabaseLike = createSupabaseDefault,
): Promise<Response> => {
  // Require POST
  if (req.method.toUpperCase() !== "POST") {
    return json({ ok: false, error_code: "method_not_allowed", message: "POST required" }, 405);
  }

  const supabaseUrl = env.SUPABASE_URL;
  const supabaseKey = env.SUPABASE_SERVICE_ROLE_KEY;
  const webhookSecret = env.RC_WEBHOOK_SECRET;

  if (!supabaseUrl || !supabaseKey) {
    return json(
      { ok: false, error_code: "missing_env", message: "Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY" },
      500,
    );
  }
  if (!webhookSecret) {
    return json({ ok: false, error_code: "missing_env", message: "Missing RC_WEBHOOK_SECRET" }, 500);
  }

  // Authorization: Bearer <secret>
  const token = extractBearerTokenStrict(req.headers.get("authorization"));
  if (!token || !timingSafeEqual(token, webhookSecret)) {
    return json({ ok: false, error_code: "unauthorized", message: "Unauthorized" }, 401);
  }

  // Parse JSON defensively (size-limited)
  let payloadUnknown: unknown;
  try {
    payloadUnknown = await readJsonWithLimit(req);
  } catch (e) {
    const msg = (e as Error)?.message ?? "invalid_json";
    const code = msg === "payload_too_large" ? "payload_too_large" : "invalid_json";
    const status = msg === "payload_too_large" ? 413 : 400;
    return json({ ok: false, error_code: code, message: code === "payload_too_large" ? "Payload too large" : "Invalid JSON body" }, status);
  }

  if (!isPlainObject(payloadUnknown)) {
    return json({ ok: false, error_code: "invalid_body", message: "Expected JSON object" }, 400);
  }

  const payload = payloadUnknown as RcPayload;

  const parsed = parseWebhookPayload(payload);
  const supabase = createSupabase(supabaseUrl, supabaseKey);

  const warnings: string[] = [];
  if (parsed.missingLatestTransactionId) warnings.push("missing_latest_transaction_id");
  if (!parsed.rcEventId) warnings.push("missing_rc_event_id");
  if (parsed.unknownEventType) warnings.push(`unknown_event_type:${parsed.eventTypeRaw}`);
  if (parsed.store === "unknown") warnings.push(`unknown_store:${parsed.storeRaw ?? "unknown"}`);

  // Fatal validation (safety)
  const fatal = (() => {
    // SAFETY: Only accept subscriber_attributes.user_id as the true Supabase user
    if (!parsed.rcUserId) return { code: "missing_user_uuid", message: "Missing or invalid subscriber_attributes.user_id" };

    // As agreed: home_id is fatal
    if (!parsed.homeId) return { code: "missing_home_id", message: "Missing home_id" };

    if (!parsed.primaryEntitlementId) return { code: "missing_entitlement", message: "Missing entitlement_id" };
    if (!parsed.productId) return { code: "missing_product", message: "Missing product_id" };

    // NEW: unknown store is fatal (avoid enum mismatch and unsafe assumptions)
    if (parsed.store === "unknown") return { code: "unknown_store", message: "Unknown store; refusing to process" };

    return null;
  })();

  const environment = parsed.environment;
  const idempotencyKey = await computeIdempotencyKey(parsed);

  // Always attempt audit write first (best-effort).
  // IMPORTANT: audit table must allow NULLs for fields that can be missing/fatal.
  const auditRow: Record<string, unknown> = {
    environment,
    idempotency_key: idempotencyKey,
    rc_event_id: parsed.rcEventId,
    original_transaction_id: parsed.originalTransactionId,
    latest_transaction_id: parsed.latestTransactionId,
    event_timestamp: parsed.eventTimestamp, // let PG cast if column is timestamptz
    rc_app_user_id: parsed.rcAppUserId ?? null,

    // UUID fields: keep null if missing/invalid
    user_id: parsed.rcUserId,
    home_id: parsed.homeId,

    entitlement_id: parsed.primaryEntitlementId ?? null,
    entitlement_ids: parsed.entitlementIds.length > 0 ? parsed.entitlementIds : null,
    product_id: parsed.productId ?? null,

    // enum store: ONLY write if known, else null to avoid enum mismatch
    store: parsed.store === "unknown" ? null : parsed.store,

    status: parsed.status,
    current_period_end_at: parsed.currentPeriodEndAt,
    original_purchase_at: parsed.originalPurchaseAt,
    last_purchase_at: parsed.lastPurchaseAt,

    warnings: warnings.length ? warnings : null,
    fatal_error_code: fatal?.code ?? null,
    fatal_error: fatal?.message ?? null,
    raw: payload,
  };

  const auditWrite = await supabase
    .from("revenuecat_webhook_events")
    .upsert(auditRow, {
      onConflict: "environment,idempotency_key",
      returning: "minimal",
    });

  if (auditWrite.error) {
    // If we can't even log, prefer retries ONLY if it's transient.
    const retryable = isTransientDbError(auditWrite.error);
    return json(
      {
        ok: false,
        retryable,
        error_code: "audit_write_failed",
        message: "Failed to log webhook event",
        details: auditWrite.error.message,
      },
      retryable ? 500 : 200,
    );
  }

  // If fatal validation, return 400 (no retry; permanent data issue)
  if (fatal) {
    return json({ ok: false, retryable: false, error_code: fatal.code, message: fatal.message, warnings }, 400);
  }

  // Call idempotent RPC (real source of truth for retry safety)
  const rpcArgs: Record<string, unknown> = {
    p_idempotency_key: idempotencyKey,
    p_user_id: parsed.rcUserId,
    p_home_id: parsed.homeId,

    // store is guaranteed known by fatal validation above
    p_store: parsed.store,

    p_rc_app_user_id: parsed.rcAppUserId,
    p_entitlement_id: parsed.primaryEntitlementId,
    p_entitlement_ids: parsed.entitlementIds,
    p_product_id: parsed.productId,
    p_status: parsed.status,
    p_current_period_end_at: parsed.currentPeriodEndAt,
    p_original_purchase_at: parsed.originalPurchaseAt,
    p_last_purchase_at: parsed.lastPurchaseAt,
    p_latest_transaction_id: parsed.latestTransactionId,
    p_event_timestamp: parsed.eventTimestamp,
    p_environment: environment,
    p_rc_event_id: parsed.rcEventId,
    p_original_transaction_id: parsed.originalTransactionId,
    p_raw_event: payload,
    p_warnings: warnings.length ? warnings : null,
  };

  const { data: deduped, error: rpcError } = await supabase.rpc<boolean>("paywall_record_subscription", rpcArgs);

  if (rpcError) {
    const retryable = isTransientDbError(rpcError);

    // Update audit row (best-effort)
    await supabase
      .from("revenuecat_webhook_events")
      .upsert(
        {
          ...auditRow,
          rpc_error_code: "rpc_failure",
          rpc_error: rpcError.message ?? "rpc_failure",
          rpc_retryable: retryable,
        },
        { onConflict: "environment,idempotency_key", returning: "minimal" },
      );

    return json(
      { ok: false, retryable, error_code: "rpc_failure", message: rpcError.message ?? "rpc_failure", warnings },
      retryable ? 500 : 200,
    );
  }

  return json({ ok: true, deduped: Boolean(deduped), warnings }, 200);
};

if (import.meta.main) {
  Deno.serve(async (req: Request) => {
    const env: Env = {
      SUPABASE_URL: Deno.env.get("SUPABASE_URL") ?? undefined,
      SUPABASE_SERVICE_ROLE_KEY: Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? undefined,
      RC_WEBHOOK_SECRET: Deno.env.get("RC_WEBHOOK_SECRET") ?? undefined,
    };
    return await handleRevenueCatWebhook(req, env);
  });
}
