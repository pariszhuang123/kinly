import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/foundation/surfaces/hub/bloc/hub_bloc.dart';
import 'package:kinly/foundation/surfaces/hub/routes/hub_house_vibe_share_route_args.dart';
import 'package:kinly/foundation/surfaces/hub/widget/hub_preferences_list_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/theme/kinly_sections.dart';

class _MockHubBloc extends Mock implements HubBloc {}

class _FakeHubState extends Fake implements HubState {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeHubState());
  });

  final palette = const SectionColors(
    background: Colors.black,
    card: Colors.brown,
    icon: Colors.amber,
    accent: Colors.orange,
  );

  const houseVibe = HouseVibePayload(
    homeId: 'home-1',
    mappingVersion: 'v1',
    labelId: 'default_home',
    titleKey: 'vibe.default.title',
    summaryKey: 'vibe.default.summary',
    imageKey: 'vibe_default_v1',
    ui: {},
    coverage: HouseVibeCoverage(answered: 2, total: 5),
  );

  testWidgets('tapping the house vibe card navigates to share screen', (
    tester,
  ) async {
    final hubBloc = _MockHubBloc();
    when(() => hubBloc.state).thenReturn(HubState.initial(appLink: 'link'));
    when(
      () => hubBloc.stream,
    ).thenAnswer((_) => const Stream<HubState>.empty());

    final router = GoRouter(
      initialLocation: '/hub',
      routes: [
        GoRoute(
          path: '/hub',
          name: AppRouteNames.hubPreferencesList,
          builder:
              (_, __) => HubPreferencesListScreen(
                members: const <HomeMemberSummary>[],
                palette: palette,
                currentUserId: 'user-1',
                houseVibe: houseVibe,
                hubBloc: hubBloc,
              ),
        ),
        GoRoute(
          path: '/hub/share',
          name: AppRouteNames.hubHouseVibeShare,
          builder: (_, state) {
            final args = state.extra as HubHouseVibeShareArgs?;
            expect(args, isNotNull);
            return const Placeholder(key: Key('share-screen'));
          },
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: buildKinlyTheme(Brightness.light),
        routerConfig: router,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Home Vibe'), findsOneWidget);
    await tester.tap(find.text('Home Vibe'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('share-screen')), findsOneWidget);
  });

  testWidgets(
    'share screen is portrait, centered, with large image between title and summary',
    (tester) async {
      final hubBloc = _MockHubBloc();
      when(() => hubBloc.state).thenReturn(HubState.initial(appLink: 'link'));
      when(
        () => hubBloc.stream,
      ).thenAnswer((_) => const Stream<HubState>.empty());

      await tester.pumpWidget(
        MaterialApp(
          theme: buildKinlyTheme(Brightness.light),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: HouseVibeShareScreen(
            vibe: houseVibe,
            palette: palette,
            hubBloc: hubBloc,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // No AppBar/title chrome on the share canvas
      expect(find.byType(AppBar), findsNothing);

      // Title and summary are centered
      final titleText = tester.widget<Text>(find.text('Home Vibe'));
      expect(titleText.textAlign, TextAlign.center);
      final summaryText = tester.widget<Text>(
        find.text('Your home feels balanced and easy to share.'),
      );
      expect(summaryText.textAlign, TextAlign.center);

      // Image sits between title and summary with a wide aspect ratio (4:3)
      expect(find.byType(AspectRatio), findsOneWidget);
      final aspect = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspect.aspectRatio, closeTo(4 / 3, 0.01));

      // Share FAB present
      expect(find.byIcon(KinlyIcons.iosShareRounded), findsOneWidget);
    },
  );
}
