import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/features/home/data/supabase/supabase_fit_check_repository.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockPostgrestFilterBuilder extends Mock
    implements PostgrestFilterBuilder<dynamic> {}

void main() {
  late _MockSupabaseClient client;
  late _MockPostgrestFilterBuilder builder;
  late SupabaseFitCheckRepository repository;

  setUp(() {
    client = _MockSupabaseClient();
    builder = _MockPostgrestFilterBuilder();
    repository = SupabaseFitCheckRepository(client: client);
  });

  void stubRpc({
    required String fn,
    required Map<String, Object?> params,
    required Map<String, dynamic> response,
  }) {
    when(
      () => client.rpc<dynamic>(fn, params: params),
    ).thenAnswer((_) => builder);
    when(
      () => builder.then<dynamic>(any(), onError: any(named: 'onError')),
    ).thenAnswer((invocation) async {
      final onValue =
          invocation.positionalArguments[0] as dynamic Function(dynamic);
      return onValue(response);
    });
  }

  test('attachDraftToHome calls the attach rpc', () async {
    stubRpc(
      fn: 'fit_check_attach_draft_to_home',
      params: {'p_draft_id': 'draft-1', 'p_home_id': 'home-1'},
      response: {
        'draft_id': 'draft-1',
        'home_id': 'home-1',
        'setup_prefill_ready': true,
      },
    );

    final result = await repository.attachDraftToHome(
      draftId: 'draft-1',
      homeId: 'home-1',
    );

    expect(result.draftId, 'draft-1');
    expect(result.homeId, 'home-1');
    verify(
      () => client.rpc(
        'fit_check_attach_draft_to_home',
        params: {'p_draft_id': 'draft-1', 'p_home_id': 'home-1'},
      ),
    ).called(1);
  });

  test('rotateShareToken calls the rotate rpc', () async {
    stubRpc(
      fn: 'fit_check_rotate_share_token',
      params: {'p_draft_id': 'draft-1'},
      response: {'draft_id': 'draft-1', 'share_token_status': 'active'},
    );

    final result = await repository.rotateShareToken(draftId: 'draft-1');

    expect(result.shareTokenStatus, 'active');
    verify(
      () => client.rpc(
        'fit_check_rotate_share_token',
        params: {'p_draft_id': 'draft-1'},
      ),
    ).called(1);
  });

  test('revokeShareToken calls the revoke rpc', () async {
    stubRpc(
      fn: 'fit_check_revoke_share_token',
      params: {'p_draft_id': 'draft-1'},
      response: {'draft_id': 'draft-1', 'share_token_status': 'revoked'},
    );

    final result = await repository.revokeShareToken(draftId: 'draft-1');

    expect(result.shareTokenStatus, 'revoked');
    verify(
      () => client.rpc(
        'fit_check_revoke_share_token',
        params: {'p_draft_id': 'draft-1'},
      ),
    ).called(1);
  });
}
