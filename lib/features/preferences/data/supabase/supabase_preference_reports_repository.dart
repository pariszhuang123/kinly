import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';

class SupabasePreferenceReportsRepository implements PreferenceReportsRepository {
  SupabasePreferenceReportsRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<PreferenceTemplateResolution> getTemplateResolution({
    String templateKey = 'personal_preferences_v1',
  }) async {
    final response = await _client.rpc(
      'preference_templates_get_for_user',
      params: {'p_template_key': templateKey},
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing preference template resolution.');
    }
    return PreferenceTemplateResolution.fromJson(payload);
  }

  @override
  Future<void> submitResponses(Map<String, int> responsesById) async {
    await _client.rpc(
      'preference_responses_submit',
      params: {'p_answers': responsesById},
    );
  }

  @override
  Future<PreferenceReportGenerationResult> generateReport({
    String templateKey = 'personal_preferences_v1',
    required String locale,
    bool force = false,
  }) async {
    final response = await _client.rpc(
      'preference_reports_generate',
      params: {
        'p_template_key': templateKey,
        'p_locale': locale,
        'p_force': force,
      },
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing preference report generation payload.');
    }
    return PreferenceReportGenerationResult.fromJson(payload);
  }

  @override
  Future<PreferenceReport?> getReportForHome({
    required String homeId,
    required String subjectUserId,
    String templateKey = 'personal_preferences_v1',
    required String locale,
  }) async {
    final response = await _client.rpc(
      'preference_reports_get_for_home',
      params: {
        'p_home_id': homeId,
        'p_subject_user_id': subjectUserId,
        'p_template_key': templateKey,
        'p_locale': locale,
      },
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing preference report response.');
    }
    final found = payload['found'] as bool? ?? false;
    if (!found) return null;
    final reportRaw = payload['report'];
    if (reportRaw is! Map) {
      throw StateError('Malformed preference report payload.');
    }
    return PreferenceReport.fromJson(reportRaw.cast<String, dynamic>());
  }

  @override
  Future<List<PreferenceReportListItem>> listReportsForHome({
    required String homeId,
    String templateKey = 'personal_preferences_v1',
    required String locale,
  }) async {
    final response = await _client.rpc(
      'preference_reports_list_for_home',
      params: {
        'p_home_id': homeId,
        'p_template_key': templateKey,
        'p_locale': locale,
      },
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing preference report list payload.');
    }
    final itemsRaw = payload['items'];
    if (itemsRaw is! List) return const <PreferenceReportListItem>[];
    return itemsRaw
        .whereType<Map>()
        .map(
          (entry) =>
              PreferenceReportListItem.fromJson(entry.cast<String, dynamic>()),
        )
        .toList(growable: false);
  }

  @override
  Future<void> editSectionText({
    String templateKey = 'personal_preferences_v1',
    required String locale,
    required String sectionKey,
    required String text,
    String? changeSummary,
  }) async {
    await _client.rpc(
      'preference_reports_edit_section_text',
      params: {
        'p_template_key': templateKey,
        'p_locale': locale,
        'p_section_key': sectionKey,
        'p_new_text': text,
        'p_change_summary': changeSummary,
      },
    );
  }

  @override
  Future<void> acknowledgeReport({required String reportId}) async {
    await _client.rpc(
      'preference_reports_acknowledge',
      params: {'p_report_id': reportId},
    );
  }

  Map<String, dynamic>? _coerceMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return response.cast<String, dynamic>();
    return null;
  }
}
