import {
  asUuid,
  extractBearerToken,
  handleRevenueCatWebhook,
  parseDate,
  statusFromEvent,
  storeFromPayload,
} from "./index.ts";

Deno.test("statusFromEvent maps RevenueCat events", () => {
  console.assert(statusFromEvent("INITIAL_PURCHASE") === "active");
  console.assert(statusFromEvent("CANCELLATION") === "cancelled");
  console.assert(statusFromEvent("EXPIRATION") === "expired");
  console.assert(statusFromEvent("UNKNOWN") === "inactive");
});

Deno.test("storeFromPayload normalizes store", () => {
  console.assert(storeFromPayload("app_store") === "app_store");
  console.assert(storeFromPayload("google") === "play_store");
  console.assert(storeFromPayload("stripe") === "stripe");
  console.assert(storeFromPayload("something") === "promotional");
});

Deno.test("parseDate accepts ms / seconds / iso", () => {
  const iso = parseDate("2025-01-01T00:00:00Z");
  if (iso === null) throw new Error("parseDate(iso) returned null");
  console.assert(iso.startsWith("2025-01-01"));

  const fromSeconds = parseDate("1735689600"); // seconds for 2025-01-01
  if (fromSeconds === null) throw new Error("parseDate(seconds) returned null");
  console.assert(fromSeconds.startsWith("2025-01-01"));

  const fromMs = parseDate(1735689600000);
  if (fromMs === null) throw new Error("parseDate(ms) returned null");
  console.assert(fromMs.startsWith("2025-01-01"));
});

Deno.test("asUuid filters invalid values", () => {
  const valid = asUuid("00000000-0000-4000-8000-000000000000");
  if (valid === null) throw new Error("asUuid(valid) returned null");
  console.assert(valid === "00000000-0000-4000-8000-000000000000");

  console.assert(asUuid("not-a-uuid") === null);
});

Deno.test("extractBearerToken handles bearer and raw tokens", () => {
  console.assert(extractBearerToken("Bearer abc") === "abc");
  console.assert(extractBearerToken("bearer abc") === "abc");
  console.assert(extractBearerToken("abc") === "abc");
  console.assert(extractBearerToken(null) === "");
});

Deno.test("handleRevenueCatWebhook rejects unauthorized", async () => {
  const env = {
    SUPABASE_URL: "http://localhost",
    SUPABASE_SERVICE_ROLE_KEY: "service",
    RC_WEBHOOK_SECRET: "secret",
  };
  const req = new Request("http://localhost", {
    method: "POST",
    headers: { "content-type": "application/json", authorization: "Bearer nope" },
    body: JSON.stringify({}),
  });

  const calls: string[] = [];
  const res = await handleRevenueCatWebhook(
    req,
    env,
    (_url, _key) => ({
      rpc: async (_fn, _args) => {
        calls.push("rpc");
        return { error: null };
      },
      from: (_table) => ({
        insert: async (_row) => {
          calls.push("insert");
          return { error: null };
        },
      }),
    }),
  );

  console.assert(res.status === 401);
  console.assert(calls.length === 0);
});

Deno.test("handleRevenueCatWebhook logs invalid payload to events table", async () => {
  const env = {
    SUPABASE_URL: "http://localhost",
    SUPABASE_SERVICE_ROLE_KEY: "service",
    RC_WEBHOOK_SECRET: "secret",
  };
  const req = new Request("http://localhost", {
    method: "POST",
    headers: { "content-type": "application/json", authorization: "Bearer secret" },
    body: JSON.stringify({
      app_user_id: "not-a-uuid",
      entitlement_id: "kinly_premium",
      product_id: "com.example.kinly.premium.monthly",
      event: { type: "INITIAL_PURCHASE" },
    }),
  });

  const inserts: Array<{ table: string; row: Record<string, unknown> }> = [];
  const res = await handleRevenueCatWebhook(
    req,
    env,
    (_url, _key) => ({
      rpc: async (_fn, _args) => ({ error: null }),
      from: (table) => ({
        insert: async (row) => {
          inserts.push({ table, row });
          return { error: null };
        },
      }),
    }),
  );

  console.assert(res.status === 400);
  console.assert(inserts.length === 1);
  console.assert(inserts[0]?.table === "revenuecat_webhook_events");
});

Deno.test("handleRevenueCatWebhook calls paywall_record_subscription on valid payload", async () => {
  const env = {
    SUPABASE_URL: "http://localhost",
    SUPABASE_SERVICE_ROLE_KEY: "service",
    RC_WEBHOOK_SECRET: "secret",
  };

  const payload = {
    app_user_id: "00000000-0000-4000-8000-000000000000",
    entitlement_id: "kinly_premium",
    product_id: "com.example.kinly.premium.monthly",
    store: "google",
    subscriber_attributes: {
      home_id: { value: "00000000-0000-4000-8000-000000000123" },
    },
    expiration_at_ms: 1735689600000,
    event: { type: "INITIAL_PURCHASE" },
  };

  const rpcs: Array<{ fn: string; args: Record<string, unknown> }> = [];
  const inserts: Array<{ table: string }> = [];

  const req = new Request("http://localhost", {
    method: "POST",
    headers: { "content-type": "application/json", authorization: "Bearer secret" },
    body: JSON.stringify(payload),
  });

  const res = await handleRevenueCatWebhook(
    req,
    env,
    (_url, _key) => ({
      rpc: async (fn, args) => {
        rpcs.push({ fn, args });
        return { error: null };
      },
      from: (table) => ({
        insert: async (_row) => {
          inserts.push({ table });
          return { error: null };
        },
      }),
    }),
  );

  console.assert(res.status === 200);
  const body = await res.json();
  console.assert(body.ok === true);
  console.assert(rpcs.length === 1);
  console.assert(rpcs[0]?.fn === "paywall_record_subscription");
  console.assert(rpcs[0]?.args.p_store === "play_store");
  console.assert(rpcs[0]?.args.p_status === "active");
  console.assert(
    rpcs[0]?.args.p_home_id === "00000000-0000-4000-8000-000000000123",
  );
  console.assert(inserts.length === 0);
});
