import {
  asUuid,
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
