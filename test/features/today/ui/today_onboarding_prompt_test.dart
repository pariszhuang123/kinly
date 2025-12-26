import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/chores/models.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/notifications/device_token_provider.dart';
import 'package:kinly/core/notifications/notification_permission_service.dart';
import 'package:kinly/core/notifications/notification_preferences.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/data/repositories/notifications_repository.dart';
import 'package:kinly/features/today/bloc/today_bloc.dart';
import 'package:kinly/features/today/domain/models.dart';
import 'package:kinly/features/today/ui/today_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/time/iana_timezone_resolver.dart';
import 'package:kinly/core/logging/debug_logger.dart';

class _MockTodayBloc extends MockBloc<TodayEvent, TodayState>
    implements TodayBloc {}

class _FakeTodayEvent extends Fake implements TodayEvent {}

class _MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class _TestDeviceTokenProvider implements DeviceTokenProvider {
  @override
  Future<String?> getToken() async => 'test-token';
}

class _TestNotificationPermissionService extends NotificationPermissionService {
  _TestNotificationPermissionService({required this.repo})
      : super(notificationsRepository: repo);

  final NotificationsRepository repo;
  int callCount = 0;
  bool throwPermission = false;

  @override
  Future<void> requestAndSync({
    required bool wantsDaily,
    required int preferredHour,
    required int preferredMinute,
    required String timezone,
    required String locale,
    String? deviceToken,
    String? platform,
  }) async {
    callCount += 1;
    if (throwPermission) {
      throw NotificationPermissionException(permanentlyDenied: true);
    }
    await repo.syncPreferences(
      wantsDaily: wantsDaily,
      preferredHour: preferredHour,
      preferredMinute: preferredMinute,
      timezone: timezone,
      locale: locale,
      osPermission: 'allowed',
      deviceToken: deviceToken,
      platform: platform,
    );
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeTodayEvent());
    registerFallbackValue(const TodayState.loading());
  });

  late _MockTodayBloc todayBloc;
  late _MockNotificationsRepository notificationsRepository;
  late _TestNotificationPermissionService permissionService;
  late _TestDeviceTokenProvider tokenProvider;
  late String capturedTimezone;

  Widget buildApp() {
    return MaterialApp(
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
        child: TodayScreen(
          onNotificationPrompt: null,
        ),
      ),
    );
  }

  TodayState loadedState({required int notificationTick}) {
    return TodayState.loaded(
      activeTasks: const [
        TodayFlowTask(
          id: 'chore-1',
          title: 'Test chore',
          state: ChoreState.active,
        ),
      ],
      draftTasks: const [],
      shareOwed: const [],
      sharePaidToMe: const [],
      shareDrafts: const [],
      notificationPromptTick: notificationTick,
      hasShownNotificationPrompt: notificationTick > 0,
    );
  }

  setUp(() async {
    await sl.reset();
    todayBloc = _MockTodayBloc();
    notificationsRepository = _MockNotificationsRepository();
    permissionService =
        _TestNotificationPermissionService(repo: notificationsRepository);
    tokenProvider = _TestDeviceTokenProvider();
    capturedTimezone = '';

    sl.registerSingleton<NotificationsRepository>(notificationsRepository);
    sl.registerSingleton<NotificationPermissionService>(permissionService);
    sl.registerSingleton<DeviceTokenProvider>(tokenProvider);

    sl.registerLazySingleton<IanaTimezoneResolver>(
      () => IanaTimezoneResolver(
        logger: const DebugLogger(),
        loader: () async => 'Europe/Paris',
      ),
    );
    when(
      () => notificationsRepository.syncPreferences(
        wantsDaily: any(named: 'wantsDaily'),
        preferredHour: any(named: 'preferredHour'),
        preferredMinute: any(named: 'preferredMinute'),
        timezone: any(named: 'timezone'),
        locale: any(named: 'locale'),
        osPermission: any(named: 'osPermission'),
        deviceToken: any(named: 'deviceToken'),
        platform: any(named: 'platform'),
      ),
    ).thenAnswer((invocation) async {
      capturedTimezone = invocation.namedArguments[#timezone] as String? ?? '';
      return const NotificationPreferences(
        wantsDaily: true,
        preferredHour: 9,
        preferredMinute: 0,
        osPermission: 'allowed',
      );
    });
    when(() => todayBloc.state).thenReturn(loadedState(notificationTick: 0));
  });

  tearDown(() async {
    await sl.reset(dispose: true);
  });


  testWidgets(
    'fires notification permission sync when onboarding hint tick increments',
    (tester) async {
      await tester.pumpWidget(buildApp());
      final dynamic state = tester.state(find.byType(TodayScreen));
      await state.debugTriggerNotificationPrompt();
      await tester.pumpAndSettle();

      expect(permissionService.callCount, 1);
    },
  );

  testWidgets(
    'passes resolver timezone to notification sync',
    (tester) async {
      await tester.pumpWidget(buildApp());
      final dynamic state = tester.state(find.byType(TodayScreen));
      await state.debugTriggerNotificationPrompt();
      await tester.pumpAndSettle();

      expect(capturedTimezone, 'Europe/Paris');
    },
  );

  testWidgets(
    'swallows NotificationPermissionException and continues',
    (tester) async {
      permissionService.throwPermission = true;

      await tester.pumpWidget(buildApp());
      final dynamic state = tester.state(find.byType(TodayScreen));
      await state.debugTriggerNotificationPrompt();
      await tester.pumpAndSettle();

      expect(permissionService.callCount, 1);
    },
  );
}
