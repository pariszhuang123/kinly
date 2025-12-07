import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/chores/models.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/notifications/notification_permission_service.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/data/repositories/notifications_repository.dart';
import 'package:kinly/features/today/bloc/today_bloc.dart';
import 'package:kinly/features/today/domain/models.dart';
import 'package:kinly/features/today/ui/today_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockTodayBloc extends MockBloc<TodayEvent, TodayState>
    implements TodayBloc {}

class _FakeTodayEvent extends Fake implements TodayEvent {}

class _MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class _TestFirebaseMessagingPlatform extends FirebaseMessagingPlatform {
  @override
  Future<String?> getToken({String? vapidKey}) async => 'test-token';
}

class _TestNotificationPermissionService extends NotificationPermissionService {
  _TestNotificationPermissionService({required NotificationsRepository repo})
      : super(notificationsRepository: repo);

  int callCount = 0;
  bool throwPermission = false;

  @override
  Future<void> requestAndSync({
    required bool wantsDaily,
    required int preferredHour,
    required String timezone,
    required String locale,
    String? deviceToken,
    String? platform,
  }) async {
    callCount += 1;
    if (throwPermission) {
      throw NotificationPermissionException(permanentlyDenied: true);
    }
    await super.requestAndSync(
      wantsDaily: wantsDaily,
      preferredHour: preferredHour,
      timezone: timezone,
      locale: locale,
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
  late _TestFirebaseMessagingPlatform messagingPlatform;
  late StreamController<TodayState> todayStateController;

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
          onNotificationPrompt: () => permissionService.callCount += 1,
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
    messagingPlatform = _TestFirebaseMessagingPlatform();
    FirebaseMessagingPlatform.instance = messagingPlatform;
    todayStateController = StreamController<TodayState>.broadcast();

    sl.registerSingleton<NotificationsRepository>(notificationsRepository);
    sl.registerSingleton<NotificationPermissionService>(permissionService);

    when(() => todayBloc.stream).thenAnswer((_) => todayStateController.stream);
  });

  tearDown(() async {
    await todayStateController.close();
    await sl.reset(dispose: true);
  });

  testWidgets(
    'fires notification permission sync when onboarding hint tick increments',
    (tester) async {
      final initial = loadedState(notificationTick: 0);
      final prompted = loadedState(notificationTick: 1);

      when(() => todayBloc.state).thenReturn(initial);
      await tester.pumpWidget(buildApp());
      todayStateController.add(prompted);
      await tester.pumpAndSettle();

      expect(permissionService.callCount, 1);
    },
  );

  testWidgets(
    'swallows NotificationPermissionException and continues',
    (tester) async {
      final initial = loadedState(notificationTick: 0);
      final prompted = loadedState(notificationTick: 1);

      when(() => todayBloc.state).thenReturn(initial);
      permissionService.throwPermission = true;

      await tester.pumpWidget(buildApp());
      todayStateController.add(prompted);
      await tester.pumpAndSettle();

      expect(permissionService.callCount, 1);
    },
  );
}
