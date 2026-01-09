---
name: creating-bloc
description: Creates Flutter BLoCs with events, states, and tests following Kinly patterns. Use when asked to create a BLoC, add business logic, or implement state management for a feature.
---

# Creating BLoCs

Step-by-step workflow for creating Flutter BLoCs in Kinly.

## Prerequisites

Before starting, read:
- `AGENTS.md` § Boundaries — BLoC consumes repositories only
- `AGENTS.md` § Guardrails — named handlers, complexity budget

## Workflow Overview

```
1. Events → 2. States → 3. BLoC → 4. Tests → 5. Verify
```

---

## File Structure

```
lib/features/<feature>/bloc/
├── <feature>_bloc.dart      # BLoC class
├── <feature>_event.dart     # part file
└── <feature>_state.dart     # part file
```

Or for complex features with multiple BLoCs:

```
lib/features/<feature>/bloc/<bloc_name>/
├── <bloc_name>_bloc.dart
├── <bloc_name>_event.dart
└── <bloc_name>_state.dart
```

---

## Step 1: Create Events

Create `<feature>_event.dart` as a `part` file:

```dart
part of '<feature>_bloc.dart';

abstract class <Feature>Event extends Equatable {
  const <Feature>Event();

  @override
  List<Object?> get props => [];
}

/// Triggered when user changes input field
class <Feature><Field>Changed extends <Feature>Event {
  const <Feature><Field>Changed(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

/// Triggered when user submits the form
class <Feature>Submitted extends <Feature>Event {
  const <Feature>Submitted();
}

/// Triggered to reset state
class <Feature>Reset extends <Feature>Event {
  const <Feature>Reset();
}
```

### Naming Convention

| Pattern | Example |
|---------|---------|
| `<Action><Entity>Event` | `JoinHomeCodeChanged`, `JoinHomeSubmitted` |
| Field changes | `<Feature><Field>Changed` |
| Actions | `<Feature>Submitted`, `<Feature>Canceled`, `<Feature>Reset` |
| Data loading | `<Feature>Loaded`, `<Feature>Refreshed` |

---

## Step 2: Create States

Create `<feature>_state.dart` as a `part` file:

```dart
part of '<feature>_bloc.dart';

enum <Feature>Status { initial, loading, success, failure }

class <Feature>State extends Equatable {
  const <Feature>State({
    this.field = '',
    this.status = <Feature>Status.initial,
    this.errorMessage,
    this.errorType,
  });

  final String field;
  final <Feature>Status status;
  final String? errorMessage;
  final <Feature>ErrorType? errorType;

  /// Computed property for UI
  bool get canSubmit => field.isNotEmpty;

  <Feature>State copyWith({
    String? field,
    <Feature>Status? status,
    Object? errorMessage = _unset,
    Object? errorType = _unset,
  }) {
    return <Feature>State(
      field: field ?? this.field,
      status: status ?? this.status,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
      errorType:
          errorType == _unset
              ? this.errorType
              : errorType as <Feature>ErrorType?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [field, status, errorMessage, errorType];
}

/// Domain-specific error types for UI handling
enum <Feature>ErrorType {
  invalidInput,
  notFound,
  unauthorized,
  unknown,
}
```

### Naming Convention

| Pattern | Example |
|---------|---------|
| Status enum | `<Feature>Status` with `initial`, `loading`, `success`, `failure` |
| State class | `<Feature>State` with `copyWith` |
| Error types | `<Feature>ErrorType` (UI-only; domain errors in `lib/core/.../enums/`) |

---

## Step 3: Create BLoC

Create `<feature>_bloc.dart`:

```dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:kinly/contracts/<domain>/ports/<domain>_repository.dart';
import 'package:kinly/contracts/<domain>/models.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';

part '<feature>_event.dart';
part '<feature>_state.dart';

class <Feature>Bloc extends Bloc<<Feature>Event, <Feature>State> {
  <Feature>Bloc({required <Domain>Repository repository})
    : _repository = repository,
      super(const <Feature>State()) {
    // Register event handlers with named methods (no inline closures)
    on<<Feature><Field>Changed>(_on<Field>Changed);
    on<<Feature>Submitted>(_onSubmitted);
    on<<Feature>Reset>(_onReset);
  }

  final <Domain>Repository _repository;

  void _on<Field>Changed(
    <Feature><Field>Changed event,
    Emitter<<Feature>State> emit,
  ) {
    emit(
      state.copyWith(
        field: event.value.trim(),
        status: <Feature>Status.initial,
        errorMessage: null,
        errorType: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    <Feature>Submitted event,
    Emitter<<Feature>State> emit,
  ) async {
    // Guard: prevent double-submit
    if (!state.canSubmit || state.status == <Feature>Status.loading) return;

    emit(
      state.copyWith(
        status: <Feature>Status.loading,
        errorMessage: null,
        errorType: null,
      ),
    );

    try {
      final result = await _repository.doAction(state.field);
      emit(
        state.copyWith(
          status: <Feature>Status.success,
          errorMessage: null,
          errorType: null,
        ),
      );
    } catch (error) {
      final mapped = _mapError(error);
      emit(
        state.copyWith(
          status: <Feature>Status.failure,
          errorMessage: mapped.message,
          errorType: mapped.type,
        ),
      );
    }
  }

  void _onReset(
    <Feature>Reset event,
    Emitter<<Feature>State> emit,
  ) {
    emit(const <Feature>State());
  }

  _ErrorResult _mapError(Object error) {
    if (error is <Domain>Exception) {
      return _ErrorResult(
        type: _mapErrorType(error.code),
        message: error.message,
      );
    }
    return _ErrorResult(
      type: <Feature>ErrorType.unknown,
      message: error.toString(),
    );
  }

  <Feature>ErrorType _mapErrorType(<Domain>ErrorCode code) {
    return switch (code) {
      <Domain>ErrorCode.invalidInput => <Feature>ErrorType.invalidInput,
      <Domain>ErrorCode.notFound => <Feature>ErrorType.notFound,
      _ => <Feature>ErrorType.unknown,
    };
  }
}

class _ErrorResult {
  const _ErrorResult({this.type, this.message});

  final <Feature>ErrorType? type;
  final String? message;
}
```

### Key Patterns

| Rule | Pattern |
|------|---------|
| Event registration | `on<Event>(_onEvent);` — named method, no inline closure |
| Handler naming | `_on<EventName>` |
| Repository injection | Constructor parameter, stored as `_repository` |
| Double-submit guard | Check `state.status == ...Loading` before async work |
| Error mapping | Private helper converts domain exceptions to UI error types |
| No side effects | Navigation, analytics belong in UI listeners, not BLoC |

---

## Step 4: Write Tests

Create `test/features/<feature>/bloc/<feature>_bloc_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/<domain>/ports/<domain>_repository.dart';
import 'package:kinly/contracts/<domain>/models.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:kinly/features/<feature>/bloc/<feature>_bloc.dart';

class _Mock<Domain>Repository extends Mock implements <Domain>Repository {}

void main() {
  late _Mock<Domain>Repository repository;

  setUp(() {
    repository = _Mock<Domain>Repository();
  });

  <Feature>Bloc buildBloc() => <Feature>Bloc(repository: repository);

  group('<Feature>Bloc', () {
    // Test: field change updates state
    blocTest<<Feature>Bloc, <Feature>State>(
      'updates field when <Feature><Field>Changed is added',
      build: buildBloc,
      act: (bloc) => bloc.add(const <Feature><Field>Changed(' value ')),
      expect: () => const [
        <Feature>State(field: 'value', status: <Feature>Status.initial),
      ],
    );

    // Test: happy path
    blocTest<<Feature>Bloc, <Feature>State>(
      'emits success when repository succeeds',
      build: () {
        when(() => repository.doAction(any()))
            .thenAnswer((_) async => const Result());
        return buildBloc();
      },
      seed: () => const <Feature>State(
        field: 'value',
        status: <Feature>Status.initial,
      ),
      act: (bloc) => bloc.add(const <Feature>Submitted()),
      expect: () => const [
        <Feature>State(field: 'value', status: <Feature>Status.loading),
        <Feature>State(field: 'value', status: <Feature>Status.success),
      ],
      verify: (_) {
        verify(() => repository.doAction('value')).called(1);
      },
    );

    // Test: error path
    blocTest<<Feature>Bloc, <Feature>State>(
      'emits failure when repository throws',
      build: () {
        when(() => repository.doAction(any()))
            .thenThrow(Exception('boom'));
        return buildBloc();
      },
      seed: () => const <Feature>State(
        field: 'value',
        status: <Feature>Status.initial,
      ),
      act: (bloc) => bloc.add(const <Feature>Submitted()),
      expect: () => const [
        <Feature>State(field: 'value', status: <Feature>Status.loading),
        <Feature>State(
          field: 'value',
          status: <Feature>Status.failure,
          errorMessage: 'Exception: boom',
          errorType: <Feature>ErrorType.unknown,
        ),
      ],
      verify: (_) {
        verify(() => repository.doAction('value')).called(1);
      },
    );

    // Test: domain-specific error mapping
    blocTest<<Feature>Bloc, <Feature>State>(
      'maps domain error to UI error type',
      build: () {
        when(() => repository.doAction(any())).thenThrow(
          <Domain>Exception(
            <Domain>ErrorCode.invalidInput,
            'Field is required',
          ),
        );
        return buildBloc();
      },
      seed: () => const <Feature>State(
        field: 'bad',
        status: <Feature>Status.initial,
      ),
      act: (bloc) => bloc.add(const <Feature>Submitted()),
      expect: () => const [
        <Feature>State(field: 'bad', status: <Feature>Status.loading),
        <Feature>State(
          field: 'bad',
          status: <Feature>Status.failure,
          errorMessage: 'Field is required',
          errorType: <Feature>ErrorType.invalidInput,
        ),
      ],
    );

    // Test: reset
    blocTest<<Feature>Bloc, <Feature>State>(
      'resets to initial state',
      build: buildBloc,
      seed: () => const <Feature>State(
        field: 'value',
        status: <Feature>Status.success,
      ),
      act: (bloc) => bloc.add(const <Feature>Reset()),
      expect: () => const [<Feature>State()],
    );
  });
}
```

### Test Coverage Requirements

| Scenario | Required |
|----------|----------|
| Field change | ✓ |
| Happy path (success) | ✓ |
| Error path (repository throws) | ✓ |
| Domain error mapping | ✓ |
| Reset | ✓ |
| Double-submit prevention | Optional |
| Edge cases | As needed |

---

## Step 5: Verify

```bash
# Run all checks
dart run tool/check_all.dart

# Run BLoC tests
flutter test test/features/<feature>/bloc/

# Run all tests
flutter test
```

---

## Checklist

- [ ] Events extend `Equatable` with `props`
- [ ] Event naming: `<Action><Entity>Event`
- [ ] States extend `Equatable` with `props`
- [ ] State has `copyWith` with `_unset` sentinel pattern
- [ ] Status enum: `initial`, `loading`/`submitting`, `success`, `failure`
- [ ] BLoC uses named handlers (`on<Event>(_onEvent)`) — no inline closures
- [ ] BLoC injects repository via constructor
- [ ] BLoC guards against double-submit
- [ ] Error mapping converts domain exceptions to UI error types
- [ ] No side effects in BLoC (navigation, analytics)
- [ ] Tests cover: field change, success, failure, error mapping, reset
- [ ] Tests use `blocTest` + `mocktail`
- [ ] `dart run tool/check_all.dart` passes
- [ ] `flutter test` passes

---

## Anti-Patterns to Avoid

### ❌ Inline Event Handlers

```dart
// BAD
on<SubmitEvent>((event, emit) async {
  // long handler...
});

// GOOD
on<SubmitEvent>(_onSubmit);
```

### ❌ Direct Supabase Calls

```dart
// BAD
final data = await supabase.rpc('do_action');

// GOOD
final result = await _repository.doAction();
```

### ❌ Navigation in BLoC

```dart
// BAD
if (state is Success) Navigator.of(context).pop();

// GOOD — UI listens and navigates
// In widget:
context.read<MyBloc>().stream.listen((state) {
  if (state.status == Status.success) Navigator.of(context).pop();
});
```

### ❌ UI Logic in State

```dart
// BAD
class MyState {
  String get buttonLabel => isLoading ? 'Loading...' : 'Submit';
}

// GOOD — computed in UI
Text(state.status == Status.loading ? 'Loading...' : 'Submit')
```
