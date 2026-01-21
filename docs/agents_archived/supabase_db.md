# Supabase/DB Agent

Template: Context → Objectives → Constraints → Contracts → DoD → Risks → Outputs

Responsibilities
- Design and migrate schemas, indexes, RLS policies, and RPCs.
- Ensure per-home isolation; inactive homes hidden.

Constraints
- All writes via RPCs; deny direct table writes to clients.
- Up/Down SQL migrations; review by Planner + Test.

Outputs
- Migration SQL (up/down), RPC definitions, RLS tests, contract updates.

