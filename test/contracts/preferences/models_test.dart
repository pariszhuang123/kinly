import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/preferences/models.dart';

void main() {
  group('PreferenceReportSummary.fromJson', () {
    test('parses complete summary', () {
      final json = {'title': 'Weekly Report', 'subtitle': 'For January 2024'};
      final result = PreferenceReportSummary.fromJson(json);

      expect(result.title, 'Weekly Report');
      expect(result.subtitle, 'For January 2024');
    });

    test('handles null fields with empty string defaults', () {
      final json = <String, dynamic>{};
      final result = PreferenceReportSummary.fromJson(json);

      expect(result.title, '');
      expect(result.subtitle, '');
    });
  });

  group('PreferenceReportSection.fromJson', () {
    test('parses complete section', () {
      final json = {
        'section_key': 'summary',
        'title': 'Summary',
        'text': 'This is the summary text.',
      };
      final result = PreferenceReportSection.fromJson(json);

      expect(result.sectionKey, 'summary');
      expect(result.title, 'Summary');
      expect(result.text, 'This is the summary text.');
    });

    test('handles null fields with empty string defaults', () {
      final json = <String, dynamic>{};
      final result = PreferenceReportSection.fromJson(json);

      expect(result.sectionKey, '');
      expect(result.title, '');
      expect(result.text, '');
    });
  });

  group('PreferenceReportContent.fromJson', () {
    test('parses content with summary and sections', () {
      final json = {
        'summary': {'title': 'Report Title', 'subtitle': 'Subtitle'},
        'sections': [
          {'section_key': 'intro', 'title': 'Introduction', 'text': 'Intro text'},
          {'section_key': 'details', 'title': 'Details', 'text': 'Detail text'},
        ],
      };
      final result = PreferenceReportContent.fromJson(json);

      expect(result.summary.title, 'Report Title');
      expect(result.summary.subtitle, 'Subtitle');
      expect(result.sections.length, 2);
      expect(result.sections[0].sectionKey, 'intro');
      expect(result.sections[1].sectionKey, 'details');
    });

    test('handles null summary with empty defaults', () {
      final json = {'sections': <dynamic>[]};
      final result = PreferenceReportContent.fromJson(json);

      expect(result.summary.title, '');
      expect(result.summary.subtitle, '');
    });

    test('handles null sections with empty list', () {
      final json = {'summary': {'title': 'T', 'subtitle': 'S'}};
      final result = PreferenceReportContent.fromJson(json);

      expect(result.sections, isEmpty);
    });

    test('handles non-map summary gracefully', () {
      final json = {'summary': 'invalid', 'sections': <dynamic>[]};
      final result = PreferenceReportContent.fromJson(json);

      expect(result.summary.title, '');
    });

    test('handles non-list sections gracefully', () {
      final json = {'summary': <String, dynamic>{}, 'sections': 'invalid'};
      final result = PreferenceReportContent.fromJson(json);

      expect(result.sections, isEmpty);
    });

    test('filters out non-map entries in sections list', () {
      final json = {
        'summary': <String, dynamic>{},
        'sections': [
          {'section_key': 'valid', 'title': 'Valid', 'text': 'Valid text'},
          'invalid_entry',
          123,
          null,
        ],
      };
      final result = PreferenceReportContent.fromJson(json);

      expect(result.sections.length, 1);
      expect(result.sections[0].sectionKey, 'valid');
    });
  });

  group('PreferenceReport.fromJson', () {
    test('parses complete report', () {
      final json = {
        'id': 'report-123',
        'subject_user_id': 'user-456',
        'template_key': 'weekly',
        'locale': 'en',
        'published_at': '2024-01-15T10:30:00Z',
        'published_content': {
          'summary': {'title': 'Title', 'subtitle': 'Subtitle'},
          'sections': <dynamic>[],
        },
        'last_edited_at': '2024-01-16T12:00:00Z',
        'last_edited_by': 'editor-789',
      };
      final result = PreferenceReport.fromJson(json);

      expect(result.id, 'report-123');
      expect(result.subjectUserId, 'user-456');
      expect(result.templateKey, 'weekly');
      expect(result.locale, 'en');
      expect(result.publishedAt, isNotNull);
      expect(result.publishedAt!.year, 2024);
      expect(result.content.summary.title, 'Title');
      expect(result.lastEditedAt, isNotNull);
      expect(result.lastEditedBy, 'editor-789');
    });

    test('handles null dates', () {
      final json = {
        'id': 'report-123',
        'subject_user_id': 'user-456',
        'template_key': 'weekly',
        'locale': 'en',
        'published_at': null,
        'published_content': <String, dynamic>{},
        'last_edited_at': null,
        'last_edited_by': null,
      };
      final result = PreferenceReport.fromJson(json);

      expect(result.publishedAt, isNull);
      expect(result.lastEditedAt, isNull);
      expect(result.lastEditedBy, isNull);
    });

    test('handles DateTime objects directly', () {
      final now = DateTime.now();
      final json = {
        'id': 'report-123',
        'subject_user_id': 'user-456',
        'template_key': 'weekly',
        'locale': 'en',
        'published_at': now,
        'published_content': <String, dynamic>{},
        'last_edited_at': now,
      };
      final result = PreferenceReport.fromJson(json);

      expect(result.publishedAt, now);
      expect(result.lastEditedAt, now);
    });

    test('handles empty string dates', () {
      final json = {
        'id': 'report-123',
        'subject_user_id': 'user-456',
        'template_key': 'weekly',
        'locale': 'en',
        'published_at': '',
        'published_content': <String, dynamic>{},
        'last_edited_at': '',
      };
      final result = PreferenceReport.fromJson(json);

      expect(result.publishedAt, isNull);
      expect(result.lastEditedAt, isNull);
    });

    test('handles non-map published_content gracefully', () {
      final json = {
        'id': 'report-123',
        'subject_user_id': 'user-456',
        'template_key': 'weekly',
        'locale': 'en',
        'published_content': 'invalid',
      };
      final result = PreferenceReport.fromJson(json);

      expect(result.content.summary.title, '');
      expect(result.content.sections, isEmpty);
    });

    test('handles missing required string fields with empty defaults', () {
      final json = <String, dynamic>{};
      final result = PreferenceReport.fromJson(json);

      expect(result.id, '');
      expect(result.subjectUserId, '');
      expect(result.templateKey, '');
      expect(result.locale, '');
    });
  });

  group('PreferenceReportGenerationResult.fromJson', () {
    test('parses complete result', () {
      final json = {
        'status': 'success',
        'unresolved_pref_ids': ['pref-1', 'pref-2', 'pref-3'],
      };
      final result = PreferenceReportGenerationResult.fromJson(json);

      expect(result.status, 'success');
      expect(result.unresolvedPreferenceIds, ['pref-1', 'pref-2', 'pref-3']);
    });

    test('handles empty unresolved list', () {
      final json = {'status': 'success', 'unresolved_pref_ids': <dynamic>[]};
      final result = PreferenceReportGenerationResult.fromJson(json);

      expect(result.status, 'success');
      expect(result.unresolvedPreferenceIds, isEmpty);
    });

    test('handles null status with unknown default', () {
      final json = {'unresolved_pref_ids': <dynamic>[]};
      final result = PreferenceReportGenerationResult.fromJson(json);

      expect(result.status, 'unknown');
    });

    test('handles null unresolved_pref_ids with empty list', () {
      final json = {'status': 'pending'};
      final result = PreferenceReportGenerationResult.fromJson(json);

      expect(result.unresolvedPreferenceIds, isEmpty);
    });

    test('handles non-list unresolved_pref_ids gracefully', () {
      final json = {'status': 'success', 'unresolved_pref_ids': 'invalid'};
      final result = PreferenceReportGenerationResult.fromJson(json);

      expect(result.unresolvedPreferenceIds, isEmpty);
    });

    test('converts non-string entries to strings', () {
      final json = {
        'status': 'success',
        'unresolved_pref_ids': [123, 'pref-2', 456],
      };
      final result = PreferenceReportGenerationResult.fromJson(json);

      expect(result.unresolvedPreferenceIds, ['123', 'pref-2', '456']);
    });
  });

  group('PreferenceReportListItem.fromJson', () {
    test('parses complete list item', () {
      final json = {
        'report_id': 'report-123',
        'subject_user_id': 'user-456',
        'published_at': '2024-01-15T10:30:00Z',
        'last_edited_at': '2024-01-16T12:00:00Z',
      };
      final result = PreferenceReportListItem.fromJson(json);

      expect(result.reportId, 'report-123');
      expect(result.subjectUserId, 'user-456');
      expect(result.publishedAt, isNotNull);
      expect(result.publishedAt!.month, 1);
      expect(result.lastEditedAt, isNotNull);
    });

    test('handles null dates', () {
      final json = {
        'report_id': 'report-123',
        'subject_user_id': 'user-456',
        'published_at': null,
        'last_edited_at': null,
      };
      final result = PreferenceReportListItem.fromJson(json);

      expect(result.publishedAt, isNull);
      expect(result.lastEditedAt, isNull);
    });

    test('handles missing fields with empty defaults', () {
      final json = <String, dynamic>{};
      final result = PreferenceReportListItem.fromJson(json);

      expect(result.reportId, '');
      expect(result.subjectUserId, '');
    });
  });

  group('PreferenceTemplateResolution.fromJson', () {
    test('parses complete resolution', () {
      final json = {
        'template_key': 'weekly',
        'requested_locale': 'fr',
        'resolved_locale': 'en',
      };
      final result = PreferenceTemplateResolution.fromJson(json);

      expect(result.templateKey, 'weekly');
      expect(result.requestedLocale, 'fr');
      expect(result.resolvedLocale, 'en');
    });

    test('handles null requested_locale', () {
      final json = {
        'template_key': 'monthly',
        'requested_locale': null,
        'resolved_locale': 'de',
      };
      final result = PreferenceTemplateResolution.fromJson(json);

      expect(result.requestedLocale, isNull);
      expect(result.resolvedLocale, 'de');
    });

    test('defaults resolved_locale to en', () {
      final json = {'template_key': 'daily'};
      final result = PreferenceTemplateResolution.fromJson(json);

      expect(result.resolvedLocale, 'en');
    });

    test('handles missing template_key with empty default', () {
      final json = <String, dynamic>{};
      final result = PreferenceTemplateResolution.fromJson(json);

      expect(result.templateKey, '');
    });
  });

  group('HouseVibeCoverage.fromJson', () {
    test('parses complete coverage', () {
      final json = {'answered': 5, 'total': 10};
      final result = HouseVibeCoverage.fromJson(json);

      expect(result.answered, 5);
      expect(result.total, 10);
    });

    test('handles missing fields with zero defaults', () {
      final json = <String, dynamic>{};
      final result = HouseVibeCoverage.fromJson(json);

      expect(result.answered, 0);
      expect(result.total, 0);
    });
  });

  group('HouseVibePayload.fromJson', () {
    test('parses complete payload', () {
      final json = {
        'home_id': 'home-123',
        'mapping_version': 'v1',
        'label_id': 'label-456',
        'title_key': 'cozy_home',
        'summary_key': 'warm_welcoming',
        'image_key': 'house_sunny',
        'ui': {'theme': 'light', 'accent': 'blue'},
        'coverage': {'answered': 8, 'total': 10},
      };
      final result = HouseVibePayload.fromJson(json);

      expect(result.homeId, 'home-123');
      expect(result.mappingVersion, 'v1');
      expect(result.labelId, 'label-456');
      expect(result.titleKey, 'cozy_home');
      expect(result.summaryKey, 'warm_welcoming');
      expect(result.imageKey, 'house_sunny');
      expect(result.ui['theme'], 'light');
      expect(result.coverage.answered, 8);
      expect(result.coverage.total, 10);
    });

    test('handles nested presentation object fallback', () {
      final json = {
        'home_id': 'home-123',
        'mapping_version': 'v1',
        'label_id': 'label-456',
        'presentation': {
          'title_key': 'from_presentation',
          'summary_key': 'summary_from_presentation',
          'image_key': 'image_from_presentation',
          'ui': {'mode': 'dark'},
        },
        'coverage': {'answered': 3, 'total': 5},
      };
      final result = HouseVibePayload.fromJson(json);

      expect(result.titleKey, 'from_presentation');
      expect(result.summaryKey, 'summary_from_presentation');
      expect(result.imageKey, 'image_from_presentation');
      expect(result.ui['mode'], 'dark');
    });

    test('top-level keys override presentation keys', () {
      final json = {
        'home_id': 'home-123',
        'mapping_version': 'v1',
        'label_id': 'label-456',
        'title_key': 'top_level_title',
        'presentation': {'title_key': 'presentation_title'},
        'coverage': <String, dynamic>{},
      };
      final result = HouseVibePayload.fromJson(json);

      expect(result.titleKey, 'top_level_title');
    });

    test('handles missing coverage with empty defaults', () {
      final json = {
        'home_id': 'home-123',
        'mapping_version': 'v1',
        'label_id': 'label-456',
      };
      final result = HouseVibePayload.fromJson(json);

      expect(result.coverage.answered, 0);
      expect(result.coverage.total, 0);
    });

    test('handles non-map coverage gracefully', () {
      final json = {
        'home_id': 'home-123',
        'mapping_version': 'v1',
        'label_id': 'label-456',
        'coverage': 'invalid',
      };
      final result = HouseVibePayload.fromJson(json);

      expect(result.coverage.answered, 0);
    });

    test('handles non-map ui gracefully', () {
      final json = {
        'home_id': 'home-123',
        'mapping_version': 'v1',
        'label_id': 'label-456',
        'ui': 'invalid',
        'coverage': <String, dynamic>{},
      };
      final result = HouseVibePayload.fromJson(json);

      expect(result.ui, isEmpty);
    });

    test('handles missing string fields with empty defaults', () {
      final json = <String, dynamic>{};
      final result = HouseVibePayload.fromJson(json);

      expect(result.homeId, '');
      expect(result.mappingVersion, '');
      expect(result.labelId, '');
      expect(result.titleKey, '');
      expect(result.summaryKey, '');
      expect(result.imageKey, '');
    });
  });
}
