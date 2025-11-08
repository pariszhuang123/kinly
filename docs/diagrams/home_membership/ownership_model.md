```mermaid
erDiagram
  USERS ||--o{ MEMBERSHIP : "has many (history)"
  HOMES ||--o{ MEMBERSHIP : "has many"
  
  %% many homes per one user
  HOMES }|--|| USERS : "owned by"


  HOMES {
    uuid id PK
    boolean active
    uuid owner_id FK "single owner (ref USERS.id)"
  }

  USERS {
    uuid id PK
    text email
  }

  MEMBERSHIP {
    uuid home_id FK
    uuid user_id FK "only one ACTIVE row per user (enforce in SQL)"
    timestamp left_at "NULL when active"
  }

```

Notes
- Exactly one active owner per home.
- Home.active = owner_id is not null.
- Owner must have MEMBERSHIP with left_at IS NULL.

