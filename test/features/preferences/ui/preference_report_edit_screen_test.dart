import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/preferences/bloc/preference_report_cubit.dart';
import 'package:kinly/features/preferences/ui/preference_report_edit_screen.dart';
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

  Widget buildApp(_MockPreferenceReportCubit cubit) {
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
        child: const PreferenceReportEditScreen(),
      ),
    );
  }

  testWidgets('renders edit cards for each section', (tester) async {
    final cubit = _MockPreferenceReportCubit();
    when(
      () => cubit.stream,
    ).thenAnswer((_) => const Stream<PreferenceReportState>.empty());
    when(
      () => cubit.state,
    ).thenReturn(PreferenceReportState.ready(buildReport()));

    await tester.pumpWidget(buildApp(cubit));
    await tester.pumpAndSettle();

    expect(find.text('Section 1'), findsOneWidget);
    expect(find.text('Section 1 body'), findsOneWidget);
    expect(find.text('Section 2'), findsOneWidget);
    expect(find.text('Section 2 body'), findsOneWidget);
  });
}
