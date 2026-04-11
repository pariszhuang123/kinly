import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/features/home/data/supabase/supabase_home_units_repository.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _FakePostgrestFilterBuilder<T> extends Fake
    implements PostgrestFilterBuilder<T> {
  _FakePostgrestFilterBuilder(this._future);

  final Future<T> _future;

  @override
  Stream<T> asStream() => _future.asStream();

  @override
  Future<T> catchError(Function onError, {bool Function(Object error)? test}) =>
      _future.catchError(onError, test: test);

  @override
  Future<R> then<R>(
    FutureOr<R> Function(T value) onValue, {
    Function? onError,
  }) => _future.then(onValue, onError: onError);

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) =>
      _future.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) =>
      _future.whenComplete(action);
}

void main() {
  late _MockSupabaseClient client;
  late SupabaseHomeUnitsRepository repository;

  setUp(() {
    client = _MockSupabaseClient();
    repository = SupabaseHomeUnitsRepository(client: client);
  });

  test('getMyUnitContext maps snake_case payload', () async {
    when(
      () => client.rpc(
        'home_units_get_my_context',
        params: {'p_home_id': 'home-1'},
      ),
    ).thenAnswer(
      (_) => _FakePostgrestFilterBuilder(
        Future<Map<String, dynamic>>.value({
          'personal_unit': {
            'unit_id': 'unit-personal',
            'home_id': 'home-1',
            'name': 'Personal',
            'unit_type': 'personal',
            'member_user_ids': ['user-1'],
          },
          'active_shared_unit': {
            'unit_id': 'unit-shared',
            'home_id': 'home-1',
            'name': 'Alex + Sam',
            'unit_type': 'shared',
            'member_user_ids': ['user-1', 'user-2'],
          },
          'allowed_shopping_scopes': ['house', 'unit'],
        }),
      ),
    );

    final result = await repository.getMyUnitContext(homeId: 'home-1');

    expect(result.personalUnit.unitId, 'unit-personal');
    expect(result.activeSharedUnit?.unitId, 'unit-shared');
    expect(result.allowedShoppingScopes, hasLength(2));
  });

  test('listJoinableSharedUnits maps rpc response', () async {
    when(
      () => client.rpc(
        'home_units_list_joinable_shared_units',
        params: {'p_home_id': 'home-1'},
      ),
    ).thenAnswer(
      (_) => _FakePostgrestFilterBuilder(
        Future<List<Map<String, dynamic>>>.value([
          {
            'unit_id': 'unit-shared',
            'home_id': 'home-1',
            'name': 'Alex + Sam',
            'unit_type': 'shared',
            'member_user_ids': ['user-2', 'user-3'],
          },
        ]),
      ),
    );

    final result = await repository.listJoinableSharedUnits(homeId: 'home-1');

    expect(result, hasLength(1));
    expect(result.single.name, 'Alex + Sam');
    verify(
      () => client.rpc(
        'home_units_list_joinable_shared_units',
        params: {'p_home_id': 'home-1'},
      ),
    ).called(1);
  });

  test('renameSharedUnit returns unit id from object payload', () async {
    when(
      () => client.rpc(
        'home_units_update_shared',
        params: {'p_unit_id': 'unit-shared', 'p_name': 'New name'},
      ),
    ).thenAnswer(
      (_) => _FakePostgrestFilterBuilder(
        Future<Map<String, String>>.value({'unit_id': 'unit-shared'}),
      ),
    );

    final result = await repository.renameSharedUnit(
      unitId: 'unit-shared',
      name: 'New name',
    );

    expect(result, 'unit-shared');
  });

  test('joinSharedUnit throws on malformed payload', () async {
    when(
      () => client.rpc(
        'home_units_join_shared',
        params: {'p_unit_id': 'unit-shared'},
      ),
    ).thenAnswer(
      (_) => _FakePostgrestFilterBuilder(
        Future<Map<String, String>>.value({'unexpected': 'payload'}),
      ),
    );

    expect(
      () => repository.joinSharedUnit(unitId: 'unit-shared'),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          'Malformed join shared unit payload.',
        ),
      ),
    );
  });

  test('leaveSharedUnit throws on malformed payload', () async {
    when(
      () => client.rpc(
        'home_units_leave_shared',
        params: {'p_unit_id': 'unit-shared'},
      ),
    ).thenAnswer((_) => _FakePostgrestFilterBuilder(Future<Null>.value(null)));

    expect(
      () => repository.leaveSharedUnit(unitId: 'unit-shared'),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          'Malformed leave shared unit payload.',
        ),
      ),
    );
  });
}
