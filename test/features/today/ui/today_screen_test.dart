import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:kinly/contracts/auth/ports/auth_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/contracts/paywall/enums/paywall_event_type.dart';
import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import 'package:kinly/core/purchases/revenuecat_service.dart';
import 'package:kinly/core/ui/paywall/ports/paywall_launcher.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/features/paywall/paywall.dart';
import 'package:kinly/features/paywall/ui/paywall_launcher.dart';
import 'package:kinly/features/paywall/ui/paywall_route_args.dart';

import 'package:kinly/contracts/chores/models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/foundation/surfaces/today/bloc/today_bloc.dart';
import 'package:kinly/foundation/surfaces/today/domain/models.dart';
import 'package:kinly/foundation/surfaces/today/today_surface.dart';
import 'package:kinly/foundation/surfaces/today/widgets/today_header/today_header.dart';
import 'package:kinly/foundation/surfaces/today/widgets/today_gratitude_section.dart';
import 'package:kinly/foundation/surfaces/today/widgets/today_invite_prompt.dart';
import 'package:kinly/foundation/surfaces/today/widgets/today_flow_section/today_flow_section_container.dart';
import 'package:kinly/foundation/surfaces/today/widgets/today_share_section/today_share_section_container.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/foundation/surfaces/today/widgets/today_empty_state_card.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/contracts/expenses/enums/expense_recurrence_interval.dart';
import 'package:kinly/contracts/onboarding/ports/onboarding_repository.dart';
import 'package:kinly/contracts/mood/models.dart';

class _MockTodayBloc extends MockBloc<TodayEvent, TodayState>
    implements TodayBloc {}

class _FakeTodayEvent extends Fake implements TodayEvent {}

class _MockPaywallRepository extends Mock implements PaywallRepository {}

class _MockRevenueCatService extends Mock implements RevenueCatService {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockLogger extends Mock implements Logger {}

class _RevenueCatPackageFake extends Fake implements RevenueCatPackage {}

class _FakeSvgBundle extends CachingAssetBundle {
  static const _emptySvg = '<svg viewBox="0 0 24 24"></svg>';

  @override
  Future<ByteData> load(String key) async {
    return ByteData.view(Uint8List.fromList(_emptySvg.codeUnits).buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key.endsWith('Share.svg') ||
        key.endsWith('Hub.svg') ||
        key.endsWith('Home.svg')) {
      return _emptySvg;
    }
    throw FlutterError('Asset $key not mocked in tests');
  }
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    const purchasesChannel = MethodChannel('purchases_flutter');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(purchasesChannel, (methodCall) async {
          if (methodCall.method == 'getAppUserID') return 'rc-test-user';
          return null;
        });
    registerFallbackValue(_FakeTodayEvent());
    registerFallbackValue(const TodayState.loading());
    registerFallbackValue(PaywallEventType.impression);
    registerFallbackValue(_RevenueCatPackageFake());
  });

  late _MockTodayBloc todayBloc;

  setUp(() {
    todayBloc = _MockTodayBloc();
    when(
      () => todayBloc.stream,
    ).thenAnswer((_) => const Stream<TodayState>.empty());
    when(
      () => todayBloc.state,
    ).thenReturn(const TodayState.loading(harmonyPromptTick: 0));
  });

  Widget buildApp({AssetBundle? bundle}) {
    final app = MaterialApp(
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider<TodayBloc>.value(
        value: todayBloc,
        child: const TodayScreen(),
      ),
    );

    if (bundle == null) {
      return app;
    }

    return DefaultAssetBundle(bundle: bundle, child: app);
  }

  Widget buildRouterApp({AssetBundle? bundle}) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: AppRouteNames.today,
          builder:
              (_, __) => BlocProvider<TodayBloc>.value(
                value: todayBloc,
                child: const TodayScreen(),
              ),
        ),
        GoRoute(
          path: '/paywall',
          name: AppRouteNames.paywall,
          builder: (_, state) {
            final args = state.extra as PaywallRouteArgs;
            return KinlyPaywallScreen(
              homeId: args.homeId,
              strings: args.strings,
              source: args.source,
              placementId: args.placementId,
              triggers: args.triggers,
            );
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    final app = MaterialApp.router(
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

    if (bundle == null) {
      return app;
    }

    return DefaultAssetBundle(bundle: bundle, child: app);
  }

  testWidgets('shows loading indicator while state is loading', (tester) async {
    when(() => todayBloc.state).thenReturn(const TodayState.loading());

    await tester.pumpWidget(buildApp());
    await tester.pump();

    expect(find.byType(KinlyLoader), findsWidgets);
  });

  testWidgets('renders Flow section when tasks are available', (tester) async {
    when(() => todayBloc.state).thenReturn(
      TodayState.loaded(
        activeTasks: const [
          TodayFlowTask(
            id: '1',
            title: 'Take out trash',
            state: ChoreState.active,
          ),
        ],
        draftTasks: const [],
        shareOwed: const [],
        sharePaidToMe: const [],
        shareDrafts: const [],
      ),
    );

    await tester.pumpWidget(buildApp());
    await tester.pump();

    expect(find.text('Take out trash'), findsOneWidget);
  });

  testWidgets('shows empty state card when no tasks', (tester) async {
    when(() => todayBloc.state).thenReturn(
      const TodayState.loaded(
        activeTasks: [],
        draftTasks: [],
        shareOwed: [],
        sharePaidToMe: [],
        shareDrafts: [],
      ),
    );

    await tester.pumpWidget(buildApp());
    await tester.pump();

    expect(find.byType(TodayEmptyStateCard), findsOneWidget);
  });

  testWidgets('shows member cap prompt when onboarding hints provide it', (
    tester,
  ) async {
    when(() => todayBloc.state).thenReturn(
      TodayState.loaded(
        activeTasks: const [
          TodayFlowTask(
            id: '1',
            title: 'Take out trash',
            state: ChoreState.active,
          ),
        ],
        draftTasks: const [],
        shareOwed: const [],
        sharePaidToMe: const [],
        shareDrafts: const [],
        profile: const TodayUserProfile(
          userId: 'owner-1',
          username: 'Owner',
          isOwner: true,
        ),
        memberCapJoinRequests: const MemberCapJoinRequests(
          homeId: 'home-1',
          pendingCount: 1,
          joinerNames: ['Alex'],
          requestIds: ['req-1'],
        ),
      ),
    );
    when(() => todayBloc.homeId).thenReturn('home-1');

    await tester.pumpWidget(buildApp());
    await tester.pump();

    expect(find.text(S.current.todayMemberCapTitle), findsOneWidget);
  });

  testWidgets('renders flow, share, gratitude, and invite sections', (
    tester,
  ) async {
    when(() => todayBloc.state).thenReturn(
      TodayState.loaded(
        activeTasks: const [
          TodayFlowTask(
            id: '1',
            title: 'Take out trash',
            state: ChoreState.active,
          ),
        ],
        draftTasks: const [],
        shareOwed: [
          TodayShareOwed(
            payerUserId: 'payer-1',
            displayName: 'Payer',
            totalOwedCents: 1200,
            items: [
              TodayShareOwedItem(
                expenseId: 'expense-1',
                description: 'Test expense',
                amountCents: 1200,
                recurrenceInterval: ExpenseRecurrenceInterval.none,
                startDate: DateTime(2024, 1, 1),
              ),
            ],
          ),
        ],
        sharePaidToMe: const [],
        shareDrafts: const [],
        gratitudeStatus: const GratitudeWallStatus(hasUnread: true),
        shouldPromptInviteShare: true,
      ),
    );

    await tester.pumpWidget(buildRouterApp(bundle: _FakeSvgBundle()));
    await tester.pump();

    expect(find.byType(TodayFlowSectionContainer), findsOneWidget);
    expect(find.byType(TodayShareSectionContainer), findsOneWidget);
    expect(find.byType(TodayGratitudeSection), findsOneWidget);
    expect(find.byType(TodayInvitePrompt), findsOneWidget);
  });

  testWidgets('member cap CTA opens paywall with members cap trigger', (
    tester,
  ) async {
    final sl = GetIt.instance;
    await sl.reset();
    addTearDown(sl.reset);
    sl.registerLazySingleton<PaywallRepository>(() => _MockPaywallRepository());
    sl.registerLazySingleton<RevenueCatService>(() => _MockRevenueCatService());
    sl.registerLazySingleton<AuthRepository>(() => _MockAuthRepository());
    sl.registerLazySingleton<HomeRepository>(() => _MockHomeRepository());
    sl.registerLazySingleton<Logger>(() => _MockLogger());
    sl.registerLazySingleton<PaywallLauncher>(() => const PaywallLauncherImpl());

    final repo = sl<PaywallRepository>() as _MockPaywallRepository;
    final rc = sl<RevenueCatService>() as _MockRevenueCatService;
    final auth = sl<AuthRepository>() as _MockAuthRepository;
    final homeRepo = sl<HomeRepository>() as _MockHomeRepository;
    final logger = sl<Logger>() as _MockLogger;

    when(() => auth.current).thenReturn(const AuthSession(userId: 'user-1'));
    when(() => logger.debug(any(), tag: any(named: 'tag'))).thenReturn(null);
    when(() => logger.info(any(), tag: any(named: 'tag'))).thenReturn(null);
    when(
      () => logger.warn(
        any(),
        tag: any(named: 'tag'),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).thenReturn(null);
    when(
      () => logger.error(
        any(),
        tag: any(named: 'tag'),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).thenReturn(null);
    when(
      () => repo.logEvent(
        homeId: any(named: 'homeId'),
        eventType: any(named: 'eventType'),
        source: any(named: 'source'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => homeRepo.listActiveMembers(
        any(),
        excludeSelf: any(named: 'excludeSelf'),
      ),
    ).thenAnswer((_) async => const <HomeMemberSummary>[]);
    when(
      () => rc.fetchMonthlyPackage(placementId: any(named: 'placementId')),
    ).thenAnswer(
      (_) async =>
          RevenueCatPackage(identifier: 'monthly', priceString: '\$4.99'),
    );
    when(() => rc.isEntitlementActive(any())).thenAnswer((_) async => false);
    when(
      () => rc.setSubscriberAttributes(
        appUserId: any(named: 'appUserId'),
        homeId: any(named: 'homeId'),
        locale: any(named: 'locale'),
        email: any(named: 'email'),
      ),
    ).thenAnswer((_) async {});

    when(() => todayBloc.state).thenReturn(
      TodayState.loaded(
        activeTasks: const [
          TodayFlowTask(
            id: '1',
            title: 'Take out trash',
            state: ChoreState.active,
          ),
        ],
        draftTasks: const [],
        shareOwed: const [],
        sharePaidToMe: const [],
        shareDrafts: const [],
        profile: const TodayUserProfile(
          userId: 'owner-1',
          username: 'Owner',
          isOwner: true,
        ),
        memberCapJoinRequests: const MemberCapJoinRequests(
          homeId: 'home-1',
          pendingCount: 1,
          joinerNames: ['Alex'],
          requestIds: ['req-1'],
        ),
      ),
    );
    when(() => todayBloc.homeId).thenReturn('home-1');

    await tester.pumpWidget(buildRouterApp(bundle: _FakeSvgBundle()));
    await tester.pumpAndSettle();

    await tester.tap(find.text(S.current.todayMemberCapPrimaryCta));
    await tester.pumpAndSettle();

    final paywallFinder = find.byType(KinlyPaywallScreen);
    expect(paywallFinder, findsOneWidget);
    final paywall = tester.widget<KinlyPaywallScreen>(paywallFinder);
    expect(paywall.triggers, const {PaywallTrigger.membersCap});
  });

  testWidgets('plays confetti when transitioning from tasks to caught up', (
    tester,
  ) async {
    final streamController = StreamController<TodayState>.broadcast();
    addTearDown(streamController.close);
    when(() => todayBloc.stream).thenAnswer((_) => streamController.stream);
    when(() => todayBloc.state).thenReturn(const TodayState.loading());

    await tester.pumpWidget(buildApp());
    await tester.pump();

    streamController.add(
      TodayState.loaded(
        activeTasks: const [
          TodayFlowTask(id: '1', title: 'Task', state: ChoreState.active),
        ],
        draftTasks: const [],
        shareOwed: const [],
        sharePaidToMe: const [],
        shareDrafts: const [],
      ),
    );
    await tester.pump();

    streamController.add(
      const TodayState.loaded(
        activeTasks: [],
        draftTasks: [],
        shareOwed: [],
        sharePaidToMe: [],
        shareDrafts: [],
      ),
    );
    await tester.pump();

    final confetti = tester.widget<ConfettiWidget>(find.byType(ConfettiWidget));
    expect(confetti.confettiController.state, ConfettiControllerState.playing);
  });

  testWidgets('does not play confetti when already caught up', (tester) async {
    final streamController = StreamController<TodayState>.broadcast();
    addTearDown(streamController.close);
    when(() => todayBloc.stream).thenAnswer((_) => streamController.stream);
    when(() => todayBloc.state).thenReturn(const TodayState.loading());

    await tester.pumpWidget(buildApp());
    await tester.pump();

    streamController.add(
      const TodayState.loaded(
        activeTasks: [],
        draftTasks: [],
        shareOwed: [],
        sharePaidToMe: [],
        shareDrafts: [],
      ),
    );
    await tester.pump();

    final confetti = tester.widget<ConfettiWidget>(find.byType(ConfettiWidget));
    expect(confetti.confettiController.state, ConfettiControllerState.stopped);
  });

  testWidgets('keeps header fixed while cards scroll', (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    when(() => todayBloc.state).thenReturn(
      TodayState.loaded(
        activeTasks: const [
          TodayFlowTask(
            id: '1',
            title: 'Take out trash',
            state: ChoreState.active,
          ),
        ],
        draftTasks: const [],
        shareOwed: List.generate(
          25,
          (i) => TodayShareOwed(
            payerUserId: 'payer_$i',
            displayName: 'Payer $i',
            totalOwedCents: 1234,
            items: [
              TodayShareOwedItem(
                expenseId: 'e1',
                description: 'Test expense',
                amountCents: 1234,
                recurrenceInterval: ExpenseRecurrenceInterval.none,
                startDate: DateTime(2024, 1, 1),
              ),
            ],
          ),
        ),
        sharePaidToMe: const [],
        shareDrafts: const [],
        profile: const TodayUserProfile(userId: 'u1', username: 'Alex'),
      ),
    );

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final headerFinder = find.byType(TodayHeader);
    expect(headerFinder, findsOneWidget);

    final listItemFinder = find.text('Payer 0');
    expect(listItemFinder, findsOneWidget);

    final headerTopBefore = tester.getTopLeft(headerFinder).dy;
    final listItemTopBefore = tester.getTopLeft(listItemFinder).dy;

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();

    final headerTopAfter = tester.getTopLeft(headerFinder).dy;
    final listItemTopAfter = tester.getTopLeft(listItemFinder).dy;

    expect(headerTopAfter, closeTo(headerTopBefore, 0.5));
    expect(listItemTopAfter, lessThan(listItemTopBefore - 20));
  });
}


