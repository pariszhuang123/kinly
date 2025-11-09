# Contributing to Kinly

This repo uses a SPARC-shaped workflow: Specification → Pseudocode → Architecture → Refinement → Completion.
Keep contributions small, testable, and linked to the contract version.

## Workflow (SPARC)
- Specification
  - Define scope and acceptance criteria using Given / When / Then.
  - Source of truth: `AGENTS.md` (MVP), contracts in `docs/contracts/`.
- Pseudocode
  - Write a 1‑page flow before coding using `docs/templates/pseudocode.md`.
  - Store under `docs/flows/` and add diagrams in `docs/diagrams/` (Mermaid).
- Architecture
  - Respect boundaries: UI → BLoC → Repositories → Supabase (RPC/PostgREST).
  - Capture significant decisions in `docs/adr/`.
- Refinement
  - Add/adjust tests: BLoC + repository unit tests; RLS/RPC tests as needed.
  - Keep contracts versioned and stable (v1 in `docs/contracts/homes_v1.md`).
- Completion
  - CI must pass (format, analyze, test, build). Attach artifacts/screens if UI.

## Where things live
- Contracts: `docs/contracts/homes_v1.md` (frozen on merge)
- Flows (pseudocode): `docs/flows/`
- Diagrams (Mermaid): `docs/diagrams/`
- ADRs: `docs/adr/`
- Test plans: `docs/testing/`
- PR checklist: `.github/pull_request_template.md`

## Pseudocode quick-start
1. Copy `docs/templates/pseudocode.md` → `docs/flows/<feature>.md`.
2. Fill Given/When/Then, steps, postconditions, and error cases.
3. (Optional) Add a Mermaid diagram in `docs/diagrams/` and link it.

## Mermaid diagrams — preview/export
- GitHub renders fenced `mermaid` blocks in Markdown.
- Local preview options:
  - VS Code: open Markdown file with a fenced ```mermaid block and use preview.
  - CLI export: `npx @mermaid-js/mermaid-cli -i docs/diagrams/join_flow.mmd -o join_flow.svg`
- See `docs/diagrams/README.md` for details and examples.

## Database & Contracts (Supabase) — source of truth
- All DB changes must go through code: add SQL under `supabase/migrations/**` (and Edge Functions under `supabase/functions/**`). Do not edit remote DB without pulling diffs back.
- Contracts are versioned in `docs/contracts/*_vN.md` with a fenced `contracts-json` block. Bump to `vN+1` for breaking changes; update in place for additive.
- Registry is generated to `docs/contracts/registry.json` from the embedded blocks.

### Local workflow (required before committing)
- Windows: `powershell tool/snapshot_contracts.ps1`
- macOS/Linux: `bash tool/snapshot_contracts.sh`
- These scripts will:
  - Start a local Supabase stack and apply migrations
  - Dump snapshots: `schema.sql`, `rls_policies.sql`, `openapi.json`, `types.generated.ts`, `edge_functions.json`
  - Regenerate `docs/contracts/registry.json` and validate it
- Commit changes under both `supabase/**` and `docs/contracts/**`.

### CI gates (drift prevention)
- CI regenerates the registry and fails if `docs/contracts/registry.json` is stale.
- On DB/Edge changes, CI starts local Supabase, applies migrations, regenerates snapshots, and fails if any changed files are not committed.
- `supabase_dev` job depends on contracts drift checks and only runs when they pass.

### Prereqs
- Supabase CLI installed and Docker available locally for running snapshot scripts.
- Dart SDK available to run tools under `tool/*.dart`.

## PR requirements
- Use `.github/pull_request_template.md` and provide links to the flow and contract version.
- If contracts change, create a new versioned doc (e.g., `homes_v2.md`) and an ADR.
- UI strings must use `S.of(context)`.

## Boundaries & Guardrails (MVP)
- No direct Supabase/HTTP in UI or BLoC.
- Writes only via approved RPCs; schema changes require migrations + RLS + reviews.
- Keep platform parity (Android/iOS) and i18n scaffold current.
