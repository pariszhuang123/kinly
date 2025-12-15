import {
  buildMessage,
  isPermanentTokenError,
  truncateReason,
} from "./index.ts";

Deno.test("buildMessage picks locale, language fallback, then default", () => {
  const enMessage = buildMessage("en");
  console.assert(enMessage === buildMessage("EN"));
  console.assert(buildMessage("es-MX") === buildMessage("es"));
  console.assert(buildMessage("unknown") === enMessage);
});

Deno.test("isPermanentTokenError detects permanent token failures", () => {
  console.assert(isPermanentTokenError("UNREGISTERED token"));
  console.assert(
    isPermanentTokenError(JSON.stringify({ error: { status: "NOT_FOUND" } })),
  );
  console.assert(
    isPermanentTokenError(
      JSON.stringify({ error: { details: [{ errorCode: "UNREGISTERED" }] } }),
    ),
  );
  console.assert(isPermanentTokenError("transient") === false);
});

Deno.test("truncateReason caps grapheme count and appends ellipsis", () => {
  const truncated = truncateReason("1234567890", 5);
  console.assert(truncated.startsWith("12345"));
  console.assert(truncated.endsWith("…"));
  console.assert(truncated.length === 6);
});
