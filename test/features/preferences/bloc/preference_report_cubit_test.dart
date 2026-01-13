import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/features/preferences/bloc/preference_report_cubit.dart';

class _MockPreferenceReportsRepository extends Mock
    implements PreferenceReportsRepository {}

void main() {
  late _MockPreferenceReportsRepository repository;

  const homeId = 'home-123';
  const subjectUserId = 'user-456';
  const templateKey = 'personal_preferences_v1';
  const resolvedLocale = 'en';

  final testResolution = PreferenceTemplateResolution.fromJson(const {
    'template_key': templateKey,
    'resolved_locale': resolvedLocale,
  });

  final testReport = PreferenceReport.fromJson(const {
    'id': 'report-789',
    'subject_user_id': subjectUserId,
    'template_key': templateKey,
    'locale': resolvedLocale,
    'published_content': {
      'summary': {'title': 'Test', 'subtitle': 'Subtitle'},
      'sections': [
        {'section_key': 'sec1', 'title': 'Section 1', 'text': 'Content 1'},
      ],
    },
  });

  PreferenceReportCubit buildCubit({
    PreferenceReport? initialReport,
    bool acknowledgeOnLoad = false,
  }) {
    return PreferenceReportCubit(
      repository: repository,
      homeId: homeId,
      subjectUserId: subjectUserId,
      templateKey: templateKey,
      initialReport: initialReport,
      acknowledgeOnLoad: acknowledgeOnLoad,
    );
  }

  setUp(() {
    repository = _MockPreferenceReportsRepository();

    when(() => repository.getTemplateResolution(templateKey: templateKey))
        .thenAnswer((_) async => testResolution);

    when(
      () => repository.getReportForHome(
        homeId: homeId,
        subjectUserId: subjectUserId,
        templateKey: templateKey,
        locale: resolvedLocale,
      ),
    ).thenAnswer((_) async => testReport);

    when(() => repository.acknowledgeReport(reportId: any(named: 'reportId')))
        .thenAnswer((_) async {});

    when(
      () => repository.editSectionText(
        templateKey: any(named: 'templateKey'),
        locale: any(named: 'locale'),
        sectionKey: any(named: 'sectionKey'),
        text: any(named: 'text'),
        changeSummary: any(named: 'changeSummary'),
      ),
    ).thenAnswer((_) async {});
  });

  group('PreferenceReportCubit', () {
    test('initial state is loading when no initialReport', () {
      final cubit = buildCubit();
      expect(cubit.state.status, PreferenceReportStatus.loading);
      expect(cubit.state.report, isNull);
      cubit.close();
    });

    test('initial state is ready when initialReport provided', () {
      final cubit = buildCubit(initialReport: testReport);
      expect(cubit.state.status, PreferenceReportStatus.ready);
      expect(cubit.state.report, testReport);
      cubit.close();
    });

    group('load', () {
      blocTest<PreferenceReportCubit, PreferenceReportState>(
        'emits loading then ready on success',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => [
          isA<PreferenceReportState>()
              .having((s) => s.status, 'status', PreferenceReportStatus.loading),
          isA<PreferenceReportState>()
              .having((s) => s.status, 'status', PreferenceReportStatus.ready)
              .having((s) => s.report, 'report', testReport),
        ],
        verify: (_) {
          verify(
            () => repository.getTemplateResolution(templateKey: templateKey),
          ).called(1);
          verify(
            () => repository.getReportForHome(
              homeId: homeId,
              subjectUserId: subjectUserId,
              templateKey: templateKey,
              locale: resolvedLocale,
            ),
          ).called(1);
        },
      );

      blocTest<PreferenceReportCubit, PreferenceReportState>(
        'emits empty when report is null',
        build: () {
          when(
            () => repository.getReportForHome(
              homeId: homeId,
              subjectUserId: subjectUserId,
              templateKey: templateKey,
              locale: resolvedLocale,
            ),
          ).thenAnswer((_) async => null);
          return buildCubit();
        },
        act: (cubit) => cubit.load(),
        expect: () => [
          isA<PreferenceReportState>()
              .having((s) => s.status, 'status', PreferenceReportStatus.loading),
          isA<PreferenceReportState>()
              .having((s) => s.status, 'status', PreferenceReportStatus.empty),
        ],
      );

      blocTest<PreferenceReportCubit, PreferenceReportState>(
        'emits failure on error',
        build: () {
          when(() => repository.getTemplateResolution(templateKey: templateKey))
              .thenThrow(Exception('Network error'));
          return buildCubit();
        },
        act: (cubit) => cubit.load(),
        expect: () => [
          isA<PreferenceReportState>()
              .having((s) => s.status, 'status', PreferenceReportStatus.loading),
          isA<PreferenceReportState>()
              .having((s) => s.status, 'status', PreferenceReportStatus.failure)
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                contains('Network error'),
              ),
        ],
      );

      blocTest<PreferenceReportCubit, PreferenceReportState>(
        'acknowledges report when acknowledgeOnLoad is true',
        build: () => buildCubit(acknowledgeOnLoad: true),
        act: (cubit) => cubit.load(),
        expect: () => [
          isA<PreferenceReportState>()
              .having((s) => s.status, 'status', PreferenceReportStatus.loading),
          isA<PreferenceReportState>()
              .having((s) => s.status, 'status', PreferenceReportStatus.ready),
        ],
        verify: (_) {
          verify(
            () => repository.acknowledgeReport(reportId: testReport.id),
          ).called(1);
        },
      );

      blocTest<PreferenceReportCubit, PreferenceReportState>(
        'does not acknowledge report when acknowledgeOnLoad is false',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        verify: (_) {
          verifyNever(
            () => repository.acknowledgeReport(reportId: any(named: 'reportId')),
          );
        },
      );
    });

    group('refresh', () {
      blocTest<PreferenceReportCubit, PreferenceReportState>(
        'calls load',
        build: buildCubit,
        act: (cubit) => cubit.refresh(),
        expect: () => [
          isA<PreferenceReportState>()
              .having((s) => s.status, 'status', PreferenceReportStatus.loading),
          isA<PreferenceReportState>()
              .having((s) => s.status, 'status', PreferenceReportStatus.ready),
        ],
        verify: (_) {
          verify(
            () => repository.getTemplateResolution(templateKey: templateKey),
          ).called(1);
        },
      );
    });

    group('editSectionText', () {
      blocTest<PreferenceReportCubit, PreferenceReportState>(
        'returns true and refreshes on success',
        build: buildCubit,
        act: (cubit) async {
          final result = await cubit.editSectionText(
            sectionKey: 'sec1',
            text: 'Updated content',
          );
          expect(result, isTrue);
        },
        expect: () => [
          isA<PreferenceReportState>()
              .having((s) => s.status, 'status', PreferenceReportStatus.loading),
          isA<PreferenceReportState>()
              .having((s) => s.status, 'status', PreferenceReportStatus.ready),
        ],
        verify: (_) {
          verify(
            () => repository.editSectionText(
              templateKey: templateKey,
              locale: resolvedLocale,
              sectionKey: 'sec1',
              text: 'Updated content',
              changeSummary: any(named: 'changeSummary'),
            ),
          ).called(1);
        },
      );

      blocTest<PreferenceReportCubit, PreferenceReportState>(
        'returns false on error',
        build: () {
          when(
            () => repository.editSectionText(
              templateKey: any(named: 'templateKey'),
              locale: any(named: 'locale'),
              sectionKey: any(named: 'sectionKey'),
              text: any(named: 'text'),
              changeSummary: any(named: 'changeSummary'),
            ),
          ).thenThrow(Exception('Edit failed'));
          return buildCubit();
        },
        act: (cubit) async {
          final result = await cubit.editSectionText(
            sectionKey: 'sec1',
            text: 'Updated content',
          );
          expect(result, isFalse);
        },
        expect: () => [],
      );
    });
  });
}
