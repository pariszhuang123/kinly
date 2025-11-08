```mermaid
flowchart TD
  A[User taps Logout] --> B[Supabase auth.signOut]
  B --> C[Clear local session/cache]
  C --> D[Navigate to Welcome]
```

