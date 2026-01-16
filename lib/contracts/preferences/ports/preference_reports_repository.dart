import '../models.dart';

abstract class PreferenceReportsRepository {
  Future<PreferenceTemplateResolution> getTemplateResolution({
    String templateKey = 'personal_preferences_v1',
  });

  Future<void> submitResponses(Map<String, int> responsesById);

  Future<PreferenceReportGenerationResult> generateReport({
    String templateKey = 'personal_preferences_v1',
    required String locale,
    bool force = false,
  });

  Future<PreferenceReport?> getReportForHome({
    required String homeId,
    required String subjectUserId,
    String templateKey = 'personal_preferences_v1',
    required String locale,
  });

  Future<PreferenceReport?> getPersonalReport({
    String templateKey = 'personal_preferences_v1',
    required String locale,
  });

  Future<List<PreferenceReportListItem>> listReportsForHome({
    required String homeId,
    String templateKey = 'personal_preferences_v1',
    required String locale,
  });

  Future<void> editSectionText({
    String templateKey = 'personal_preferences_v1',
    required String locale,
    required String sectionKey,
    required String text,
    String? changeSummary,
  });

  Future<void> acknowledgeReport({required String reportId});
}
