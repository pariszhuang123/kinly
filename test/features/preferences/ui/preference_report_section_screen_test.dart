import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/preferences/ui/preference_report_section_route_args.dart';
import 'package:kinly/features/preferences/ui/preference_report_section_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockPreferenceReportsRepository extends Mock
    implements PreferenceReportsRepository {}

void main() {
  late _MockPreferenceReportsRepository repository;

  setUp(() {
    repository = _MockPreferenceReportsRepository();
  });

  Widget buildApp() {
    final router = GoRouter(
      initialLocation: '/host/edit',
      routes: [
        GoRoute(
          path: '/host',
          builder: (_, __) => const Scaffold(body: Text('Host')),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (_, __) => PreferenceReportSectionScreen(
                args: const PreferenceReportSectionRouteArgs(
                  sectionKey: 'section-1',
                  title: 'Section 1',
                  text: 'Initial text',
                ),
                repository: repository,
              ),
            ),
          ],
        ),
      ],
    );
    return MaterialApp.router(
      routerConfig: router,
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }

  testWidgets('saves section edits and returns to host', (tester) async {
    when(
      () => repository.getTemplateResolution(),
    ).thenAnswer(
      (_) async => const PreferenceTemplateResolution(
        templateKey: 'personal_preferences_v1',
        requestedLocale: 'en-NZ',
        resolvedLocale: 'en',
      ),
    );
    when(
      () => repository.editSectionText(
        locale: any(named: 'locale'),
        sectionKey: any(named: 'sectionKey'),
        text: any(named: 'text'),
      ),
    ).thenAnswer((_) async {});

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Updated text');
    await tester.tap(
      find.text(
        S.of(tester.element(find.byType(PreferenceReportSectionScreen)))
            .preferenceReportEditSectionDone,
      ),
    );
    await tester.pumpAndSettle();

    verify(
      () => repository.editSectionText(
        locale: 'en',
        sectionKey: 'section-1',
        text: 'Updated text',
      ),
    ).called(1);
    expect(find.text('Host'), findsOneWidget);
  });
}
