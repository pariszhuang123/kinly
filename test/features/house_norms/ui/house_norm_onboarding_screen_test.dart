import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/core/ui/selector/kinly_onboarding_option_card.dart';
import 'package:kinly/features/house_norms/bloc/house_norm_capture_bloc.dart';
import 'package:kinly/features/house_norms/ui/house_norm_onboarding_screen.dart';
import 'package:kinly/generated/l10n.dart';
import '../../../helpers/test_storage.dart';

class _FakeHouseNormsRepository implements HouseNormsRepository {
  @override
  Future<HouseNormDocument?> getForHome({
    required String homeId,
    required String locale,
  }) async {
    return _buildHouseNormDocument();
  }

  @override
  Future<HouseNormDocument> generateForHome({
    required String homeId,
    String templateKey = 'house_norms_v1',
    required String locale,
    required Map<String, int> inputs,
    bool force = false,
  }) async {
    return _buildHouseNormDocument();
  }

  @override
  Future<HouseNormDocument> editSectionText({
    required String homeId,
    required String locale,
    required String sectionKey,
    required String text,
    String? changeSummary,
  }) async {
    return _buildHouseNormDocument();
  }

  @override
  Future<HouseNormDocument> publishForHome({
    required String homeId,
    required String locale,
  }) async {
    return _buildHouseNormDocument();
  }

  @override
  Future<void> recordView({required String homeId}) async {}
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HydratedBloc.storage = TestStorage();
  });

  setUp(() async {
    await HydratedBloc.storage.clear();
  });

  HouseNormCaptureBloc buildBloc() {
    return HouseNormCaptureBloc(
      repository: _FakeHouseNormsRepository(),
      scenarios: _buildScenarios(),
      homeId: 'home-1',
      locale: 'en',
    );
  }

  Widget buildApp(HouseNormCaptureBloc bloc) {
    return MaterialApp(
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider.value(value: bloc, child: const HouseNormOnboardingScreen()),
    );
  }

  Widget buildRouterApp(HouseNormCaptureBloc bloc) {
    final router = GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          name: AppRouteNames.houseNormsOnboarding,
          builder: (_, __) => BlocProvider.value(
            value: bloc,
            child: const HouseNormOnboardingScreen(),
          ),
        ),
        GoRoute(
          path: '/report',
          name: AppRouteNames.houseNormsReport,
          builder: (_, __) => const Scaffold(body: Text('House Norms Report')),
        ),
        GoRoute(
          path: '/today',
          name: AppRouteNames.today,
          builder: (_, __) => const Scaffold(body: Text('Today')),
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

  testWidgets('advances to next scenario after selecting an option', (
    tester,
  ) async {
    final bloc = buildBloc();
    addTearDown(bloc.close);

    await tester.pumpWidget(buildApp(bloc));
    await tester.pump();

    expect(find.text('Question 1'), findsOneWidget);
    await tester.tap(find.text('Option 2'));
    await tester.pump();
    expect(find.text('Question 2'), findsOneWidget);
  });

  testWidgets('renders shared onboarding option cards for current scenario', (
    tester,
  ) async {
    final bloc = buildBloc();
    addTearDown(bloc.close);

    await tester.pumpWidget(buildApp(bloc));
    await tester.pump();

    expect(find.byType(KinlyOnboardingOptionCard), findsNWidgets(3));
  });

  testWidgets('navigates to report after successful reflection', (tester) async {
    final bloc = buildBloc();
    addTearDown(bloc.close);

    await tester.pumpWidget(buildRouterApp(bloc));
    await tester.pump();

    await tester.tap(find.text('Option 1'));
    await tester.pump();
    await tester.tap(find.text('Option 1'));
    await tester.pump();
    final strings = S.of(tester.element(find.byType(HouseNormOnboardingScreen)));
    await tester.tap(find.text(strings.houseNormOnboardingSubmit));

    await tester.pump(const Duration(milliseconds: 4700));
    await tester.pumpAndSettle();

    expect(find.text('House Norms Report'), findsOneWidget);
  });
}

List<HouseNormScenarioDefinition> _buildScenarios() {
  return const [
    HouseNormScenarioDefinition(
      id: 'scenario_one',
      domain: 'context',
      question: _scenarioOneQuestion,
      options: [_scenarioOneOption1, _scenarioOneOption2, _scenarioOneOption3],
    ),
    HouseNormScenarioDefinition(
      id: 'scenario_two',
      domain: 'rhythm',
      question: _scenarioTwoQuestion,
      options: [_scenarioTwoOption1, _scenarioTwoOption2, _scenarioTwoOption3],
    ),
  ];
}

HouseNormDocument _buildHouseNormDocument() {
  return HouseNormDocument(
    homeId: 'home-1',
    templateKey: 'house_norms_v1',
    status: 'out_of_date',
    inputs: const {'scenario_one': 0, 'scenario_two': 1},
    draftContent: const HouseNormContent(
      summary: HouseNormSummary(
        title: 'House norms',
        subtitle: 'Shared defaults',
        framing: 'A shared starting point.',
      ),
      context: 'Context',
      sections: [
        HouseNormSection(
          sectionKey: 'norms_rhythm_quiet',
          title: 'Rhythm',
          text: 'We usually wind down.',
        ),
      ],
    ),
    draftUpdatedAt: DateTime.utc(2026, 1, 1),
    publishedContent: null,
    publishedAt: null,
    publishedVersion: null,
    isPublished: false,
    hasUnpublishedChanges: true,
    lastEditedAt: null,
    lastEditedBy: null,
    homePublicId: null,
    publicUrl: null,
    showPublishButton: true,
    showRepublishButton: false,
    showPublicUrl: false,
    memberViewedAt: null,
    showMemberReviewCard: false,
  );
}

String _scenarioOneQuestion(S _) => 'Question 1';
String _scenarioOneOption1(S _) => 'Option 1';
String _scenarioOneOption2(S _) => 'Option 2';
String _scenarioOneOption3(S _) => 'Option 3';

String _scenarioTwoQuestion(S _) => 'Question 2';
String _scenarioTwoOption1(S _) => 'Option 1';
String _scenarioTwoOption2(S _) => 'Option 2';
String _scenarioTwoOption3(S _) => 'Option 3';
