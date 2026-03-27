import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/contracts/homes/fit_check_models.dart';
import 'package:kinly/contracts/homes/ports/fit_check_repository.dart';

class SupabaseFitCheckRepository implements FitCheckRepository {
  SupabaseFitCheckRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<FitCheckClaimResult> claimDraft({required String claimToken}) async {
    final response = await _client.rpc(
      'fit_check_claim_draft',
      params: {'p_claim_token': claimToken},
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing fit check claim response.');
    }
    return FitCheckClaimResult.fromJson(payload);
  }

  @override
  Future<FitCheckAttachResult> attachDraftToHome({
    required String draftId,
    required String homeId,
  }) async {
    final response = await _client.rpc(
      'fit_check_attach_draft_to_home',
      params: {'p_draft_id': draftId, 'p_home_id': homeId},
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing fit check attach response.');
    }
    return FitCheckAttachResult.fromJson(payload);
  }

  @override
  Future<FitCheckOwnerReview> getOwnerReview({
    required String draftId,
    required String locale,
  }) async {
    final response = await _client.rpc(
      'fit_check_get_owner_review',
      params: {'p_draft_id': draftId, 'p_locale': locale},
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing fit check owner review response.');
    }
    return FitCheckOwnerReview.fromJson(payload);
  }

  @override
  Future<FitCheckOwnerBriefing> getOwnerBriefing({
    required String submissionId,
    required String locale,
  }) async {
    final response = await _client.rpc(
      'fit_check_get_owner_briefing',
      params: {'p_submission_id': submissionId, 'p_locale': locale},
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing fit check owner briefing response.');
    }
    return FitCheckOwnerBriefing.fromJson(payload);
  }

  @override
  Future<FitCheckPrefillPayload> getPrefillPayload({
    required String draftId,
  }) async {
    final response = await _client.rpc(
      'fit_check_get_prefill_payload',
      params: {'p_draft_id': draftId},
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing fit check prefill payload.');
    }
    return FitCheckPrefillPayload.fromJson(payload);
  }

  @override
  Future<FitCheckShareTokenActionResult> rotateShareToken({
    required String draftId,
  }) async {
    final response = await _client.rpc(
      'fit_check_rotate_share_token',
      params: {'p_draft_id': draftId},
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing fit check rotate share token response.');
    }
    return FitCheckShareTokenActionResult.fromJson(payload);
  }

  @override
  Future<FitCheckShareTokenActionResult> revokeShareToken({
    required String draftId,
  }) async {
    final response = await _client.rpc(
      'fit_check_revoke_share_token',
      params: {'p_draft_id': draftId},
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing fit check revoke share token response.');
    }
    return FitCheckShareTokenActionResult.fromJson(payload);
  }

  Map<String, dynamic>? _coerceMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return response.cast<String, dynamic>();
    if (response is List && response.isNotEmpty) {
      final first = response.first;
      if (first is Map<String, dynamic>) return first;
      if (first is Map) return first.cast<String, dynamic>();
    }
    return null;
  }
}
