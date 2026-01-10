import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/preferences/bloc/preference_report_cubit.dart';
import 'package:kinly/features/preferences/ui/preference_report_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockPreferenceReportCubit
    extends MockBloc<PreferenceReportState, PreferenceReportState>
    implements PreferenceReportCubit {}

class _FakePreferenceReportState extends Fake
    implements PreferenceReportState {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakePreferenceReportState());
  });

  PreferenceReport buildReport() {
    return PreferenceReport(
      id: 'report-1',
      subjectUserId: 'user-1',
      templateKey: 'personal_preferences_v1',
      locale: 'en',
      publishedAt: DateTime(2026, 1, 1),
      lastEditedAt: null,
      lastEditedBy: null,
      content: PreferenceReportContent(
        summary: const PreferenceReportSummary(
          title: 'Summary title',
          subtitle: 'Summary subtitle',
        ),
        sections: const [
          PreferenceReportSection(
            sectionKey: 'section-1',
            title: 'Section 1',
            text: 'Section 1 body',
          ),
          PreferenceReportSection(
            sectionKey: 'section-2',
            title: 'Section 2',
            text: 'Section 2 body',
          ),
        ],
      ),
    );
  }

  Widget buildApp(_MockPreferenceReportCubit cubit, Widget child) {
    return MaterialApp(
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider<PreferenceReportCubit>.value(
        value: cubit,
        child: child,
      ),
    );
  }

  testWidgets('renders summary and sections for ready state', (tester) async {
    final cubit = _MockPreferenceReportCubit();
    when(
      () => cubit.stream,
    ).thenAnswer((_) => const Stream<PreferenceReportState>.empty());
    when(
      () => cubit.state,
    ).thenReturn(PreferenceReportState.ready(buildReport()));

    await tester.pumpWidget(buildApp(cubit, const PreferenceReportScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Summary title'), findsOneWidget);
    expect(find.text('Summary subtitle'), findsOneWidget);
    expect(find.text('Section 1'), findsOneWidget);
    expect(find.text('Section 1 body'), findsOneWidget);
    expect(find.text('Section 2'), findsOneWidget);
    expect(find.text('Section 2 body'), findsOneWidget);

    final s = S.of(tester.element(find.byType(PreferenceReportScreen)));
    expect(find.text(s.preferenceReportEditCta), findsOneWidget);
    expect(find.text(s.preferenceReportDoneCta), findsOneWidget);
  });

  testWidgets('hides edit button when read-only', (tester) async {
    final cubit = _MockPreferenceReportCubit();
    when(
      () => cubit.stream,
    ).thenAnswer((_) => const Stream<PreferenceReportState>.empty());
    when(
      () => cubit.state,
    ).thenReturn(PreferenceReportState.ready(buildReport()));

    await tester.pumpWidget(
      buildApp(cubit, const PreferenceReportScreen(canEdit: false)),
    );
    await tester.pumpAndSettle();

    final s = S.of(tester.element(find.byType(PreferenceReportScreen)));
    expect(find.text(s.preferenceReportReadOnlyNote), findsOneWidget);
    expect(find.text(s.preferenceReportEditCta), findsNothing);
  });
}
