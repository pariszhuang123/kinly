---
name: creating-repository
description: Creates repository interfaces in contracts, Supabase implementations, error codes, and error mappers. Use when asked to create a repository, add a data layer, or implement a new domain port.
---

# Creating Repositories

Step-by-step workflow for creating repositories in Kinly.

## Prerequisites

Before starting, read:
- `AGENTS.md` § Boundaries — Repositories → Supabase (RPC only)
- `AGENTS.md` § Contracts — understand the RPC signatures

## Workflow Overview

```
1. Error Codes → 2. Exception Class → 3. Error Mapper → 4. Models → 5. Contract Interface → 6. Supabase Implementation
```

---

## File Structure

```
lib/
├── contracts/<domain>/
│   ├── ports/<domain>_repository.dart    # Abstract interface
│   ├── models.dart                        # DTOs with fromJson
│   └── enums/<outcome>.dart               # Domain enums (if needed)
├── core/supabase/
│   ├── supabase_error_mapper.dart         # Central error mapper
│   └── enums/<domain>_error_code.dart     # Error codes from RPCs
└── features/<domain>/data/supabase/
    └── supabase_<domain>_repository.dart  # Implementation
```

---

## Step 1: Create Error Codes

Create `lib/core/supabase/enums/<domain>_error_code.dart`:

```dart
/// Error codes emitted by database RPCs via public.api_error/api_assert.
/// Keep these in sync with Supabase migrations.
enum <Action>ErrorCode {
  invalidInput,
  notMember,
  notFound,
  forbidden,
  unauthorized,
  unknown,
}
```

### Naming Convention

| RPC Error Code | Dart Enum Value |
|----------------|-----------------|
| `INVALID_INPUT` | `invalidInput` |
| `NOT_HOME_MEMBER` | `notMember` |
| `NOT_FOUND` | `notFound` |
| `FORBIDDEN` | `forbidden` |
| `UNAUTHORIZED` | `unauthorized` |

Export from `supabase_error_mapper.dart`:
```dart
export 'enums/<domain>_error_code.dart';
```

---

## Step 2: Create Exception Class

Add to `lib/core/supabase/supabase_error_mapper.dart`:

```dart
class <Domain><Action>Exception implements Exception {
  final <Action>ErrorCode code;
  final String message;
  final Map<String, dynamic>? details;

  <Domain><Action>Exception(this.code, this.message, {this.details});

  @override
  String toString() => '<Domain><Action>Exception($code): $message';
}
```

---

## Step 3: Add Error Mapper

Add mapper method to `SupabaseErrorMapper` class:

```dart
// ----- <domain>.<action> -----
static <Domain><Action>Exception map<Action>(Object error) =>
    _mapWithAuth<<Domain><Action>Exception, <Action>ErrorCode>(
      error: error,
      authFactory: (message) =>
          <Domain><Action>Exception(<Action>ErrorCode.unauthorized, message),
      postgrestFactory: (parsed) => <Domain><Action>Exception(
        _<action>CodeMap[parsed.code] ?? <Action>ErrorCode.unknown,
        parsed.message,
        details: parsed.details,
      ),
      fallbackFactory: (message) =>
          <Domain><Action>Exception(<Action>ErrorCode.unknown, message),
    );
```

Add the code map:

```dart
static const _<action>CodeMap = <String, <Action>ErrorCode>{
  'INVALID_INPUT': <Action>ErrorCode.invalidInput,
  'NOT_HOME_MEMBER': <Action>ErrorCode.notMember,
  'NOT_FOUND': <Action>ErrorCode.notFound,
  'FORBIDDEN': <Action>ErrorCode.forbidden,
};
```

---

## Step 4: Create Models

Create `lib/contracts/<domain>/models.dart`:

```dart
import 'package:kinly/contracts/time/timezone.dart';

// Export domain enums
export 'enums/<outcome>.dart';

class <Entity>Result {
  final String id;
  final String name;
  final DateTime createdAt;

  const <Entity>Result({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory <Entity>Result.fromJson(Map<String, dynamic> json) {
    return <Entity>Result(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      createdAt:
          parseTimestampToLocal(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
    );
  }
}
```

### fromJson Patterns

| SQL Column | Dart Type | Pattern |
|------------|-----------|---------|
| `uuid` | `String` | `json['id'] as String? ?? ''` |
| `text` | `String` | `json['name'] as String? ?? ''` |
| `integer` | `int` | `(json['count'] as num?)?.toInt() ?? 0` |
| `bigint` | `int` | `(json['amount_cents'] as num?)?.toInt() ?? 0` |
| `boolean` | `bool` | `json['is_active'] as bool? ?? false` |
| `timestamptz` | `DateTime` | `parseTimestampToLocal(json['created_at'])` |
| `jsonb` (nested) | `Map` | `(json['data'] as Map?)?.cast<String, dynamic>()` |
| `enum` | `Enum` | `<Enum>.values.byName(json['status'] ?? 'default')` |

### Null Handling

```dart
// Optional field
final DateTime? revokedAt;
revokedAt: parseTimestampToLocal(json['revoked_at']),

// Required field with fallback
final DateTime createdAt;
createdAt: parseTimestampToLocal(json['created_at']) ??
    DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
```

---

## Step 5: Create Contract Interface

Create `lib/contracts/<domain>/ports/<domain>_repository.dart`:

```dart
import '../models.dart';

abstract class <Domain>Repository {
  /// Creates a new <entity>.
  Future<<Entity>Result> create({
    required String homeId,
    required String name,
  });

  /// Gets <entity> by ID.
  Future<<Entity>Result> getById(String id);

  /// Lists all <entities> for a home.
  Future<List<<Entity>Summary>> listForHome(String homeId);

  /// Updates an existing <entity>.
  Future<<Entity>Result> update({
    required String id,
    required String name,
  });

  /// Deletes/cancels an <entity>.
  Future<void> cancel(String id);
}
```

### Naming Convention

| Operation | Method Name |
|-----------|-------------|
| Create | `create(...)` |
| Read one | `getById(id)`, `getForEdit(id)` |
| Read list | `listForHome(homeId)`, `listActive(...)` |
| Update | `update(...)`, `edit(...)` |
| Delete | `cancel(id)`, `delete(id)` |
| Actions | `complete(id)`, `markPaid(id)` |

---

## Step 6: Create Supabase Implementation

Create `lib/features/<domain>/data/supabase/supabase_<domain>_repository.dart`:

```dart
import 'package:kinly/contracts/<domain>/models.dart';
import 'package:kinly/contracts/<domain>/ports/<domain>_repository.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Supabase<Domain>Repository implements <Domain>Repository {
  Supabase<Domain>Repository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<<Entity>Result> create({
    required String homeId,
    required String name,
  }) async {
    try {
      final response = await _client.rpc(
        '<domain>_create',
        params: {
          'p_home_id': homeId,
          'p_name': name,
        },
      );
      return <Entity>Result.fromJson(
        (response as Map).cast<String, dynamic>(),
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapCreate(error);
    }
  }

  @override
  Future<<Entity>Result> getById(String id) async {
    try {
      final response = await _client.rpc(
        '<domain>_get',
        params: {'p_id': id},
      );
      return <Entity>Result.fromJson(
        (response as Map).cast<String, dynamic>(),
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapGet(error);
    }
  }

  @override
  Future<List<<Entity>Summary>> listForHome(String homeId) async {
    try {
      final response = await _client.rpc(
        '<domain>_list_for_home',
        params: {'p_home_id': homeId},
      );
      return _mapList(response);
    } catch (error) {
      rethrow; // List operations often don't need special mapping
    }
  }

  @override
  Future<<Entity>Result> update({
    required String id,
    required String name,
  }) async {
    try {
      final response = await _client.rpc(
        '<domain>_update',
        params: {
          'p_id': id,
          'p_name': name,
        },
      );
      return <Entity>Result.fromJson(
        (response as Map).cast<String, dynamic>(),
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapUpdate(error);
    }
  }

  @override
  Future<void> cancel(String id) async {
    try {
      await _client.rpc(
        '<domain>_cancel',
        params: {'p_id': id},
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapCancel(error);
    }
  }

  // Private helper for list mapping
  List<<Entity>Summary> _mapList(dynamic response) {
    final rows = response is List ? response : const <dynamic>[];
    return rows
        .map((raw) => (raw as Map).cast<String, dynamic>())
        .map(<Entity>Summary.fromJson)
        .toList(growable: false);
  }
}
```

### Key Patterns

| Pattern | Example |
|---------|---------|
| RPC naming | `'<domain>_<action>'` — matches SQL function |
| Params | `'p_<name>'` — matches SQL parameter names |
| Response parsing | `(response as Map).cast<String, dynamic>()` |
| List parsing | Private `_mapList()` helper |
| Error handling | `throw SupabaseErrorMapper.map<Action>(error)` |
| No error mapping | `rethrow` for non-critical operations |

### Optional Parameters

```dart
final response = await _client.rpc(
  'entity_create',
  params: {
    'p_home_id': homeId,
    'p_name': name,
    if (description != null) 'p_description': description,
    if (startDate != null) 'p_start_date': startDate.toIso8601String(),
  },
);
```

---

## Dependency Injection

Register in `lib/app/di/` or feature module:

```dart
GetIt.I.registerLazySingleton<DomainRepository>(
  () => SupabaseDomainRepository(),
);
```

---

## Checklist

- [ ] Error codes enum created in `lib/core/supabase/enums/`
- [ ] Error codes exported from `supabase_error_mapper.dart`
- [ ] Exception class added to `supabase_error_mapper.dart`
- [ ] Mapper method added with code map
- [ ] Models created in `lib/contracts/<domain>/models.dart`
- [ ] Models use `fromJson` with proper null handling
- [ ] Contract interface in `lib/contracts/<domain>/ports/`
- [ ] Supabase implementation in `lib/features/<domain>/data/supabase/`
- [ ] Implementation uses `SupabaseErrorMapper` for error handling
- [ ] RPC names match SQL functions (`<domain>_<action>`)
- [ ] Param names match SQL params (`p_<name>`)
- [ ] Registered in DI container

---

## Anti-Patterns to Avoid

### ❌ Business Logic in Repository

```dart
// BAD — logic belongs in RPC
Future<void> leave(String homeId) async {
  await _client.rpc('homes_leave', params: {'p_home_id': homeId});
  final members = await _client.from('memberships').select();
  if (members.isEmpty) {
    await _client.from('homes').update({'is_active': false});
  }
}

// GOOD — thin repository, logic in RPC
Future<LeaveResult> leave(String homeId) async {
  final response = await _client.rpc('homes_leave', params: {'p_home_id': homeId});
  return LeaveResult.fromJson((response as Map).cast<String, dynamic>());
}
```

### ❌ Direct Table Access

```dart
// BAD — bypasses RLS and business logic
final data = await _client.from('homes').select().eq('id', homeId);

// GOOD — use RPC
final data = await _client.rpc('homes_get', params: {'p_home_id': homeId});
```

### ❌ Swallowing Errors

```dart
// BAD — hides errors
try {
  await _client.rpc('action');
} catch (_) {
  return null; // Silent failure
}

// GOOD — map and rethrow
try {
  await _client.rpc('action');
} catch (error) {
  throw SupabaseErrorMapper.mapAction(error);
}
```

### ❌ Inconsistent Parameter Naming

```dart
// BAD — mixed naming
params: {'homeId': id, 'p_name': name}

// GOOD — consistent p_ prefix
params: {'p_home_id': id, 'p_name': name}
```
