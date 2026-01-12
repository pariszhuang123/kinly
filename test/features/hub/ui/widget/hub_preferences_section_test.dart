import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/foundation/surfaces/hub/bloc/hub_bloc.dart';
import 'package:kinly/foundation/surfaces/hub/widget/hub_preferences_section.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:mocktail/mocktail.dart';

class _MockHubBloc extends Mock implements HubBloc {}

void main() {
  late HubBloc hubBloc;

  Widget wrap(Widget child) {
    return MaterialApp(
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders member cards when reports exist', (tester) async {
    hubBloc = _MockHubBloc();
    final members = [
      HomeMemberSummary(
        userId: 'user-1',
        username: 'Pat',
        role: 'owner',
        validFrom: DateTime(2024, 1, 1),
        avatarUrl: null,
      ),
      HomeMemberSummary(
        userId: 'user-2',
        username: 'Sam',
        role: 'member',
        validFrom: DateTime(2024, 1, 1),
        avatarUrl: null,
      ),
    ];
    final reports = [
      PreferenceReportListItem(
        reportId: 'report-1',
        subjectUserId: 'user-1',
        publishedAt: DateTime(2026, 1, 1),
        lastEditedAt: null,
      ),
    ];

    await tester.pumpWidget(
      wrap(
        HubPreferencesSection(
          members: members,
          reportItems: reports,
          currentUserId: 'user-1',
          houseVibe: null,
          hubBloc: hubBloc,
        ),
      ),
    );

    final s = S.of(tester.element(find.byType(HubPreferencesSection)));
    expect(find.text(s.hubPreferencesTitle), findsOneWidget);
    expect(find.text(s.hubPreferencesSubtitle), findsOneWidget);
  });
}
