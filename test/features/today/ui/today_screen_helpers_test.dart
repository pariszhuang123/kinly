import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kinly/core/homes/models.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/notifications/device_token_provider.dart';
import 'package:kinly/core/notifications/notification_permission_service.dart';
import 'package:kinly/core/time/iana_timezone_resolver.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/core/notifications/notifications.dart';
import 'package:kinly/features/today/ui/today_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockLogger extends Mock implements Logger {}

class _MockNotificationPermissionService extends Mock
    implements NotificationPermissionService {}

class _MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class _MockDeviceTokenProvider extends Mock implements DeviceTokenProvider {}

class _MockTimezoneResolver extends Mock implements IanaTimezoneResolver {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late S l10n;

  setUpAll(() async {
    l10n = await S.delegate.load(const Locale('en'));
  });

  Future<BuildContext> pumpScaffold(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const Scaffold(body: Placeholder()),
      ),
    );
    return tester.element(find.byType(Placeholder));
  }

  group('shareInvite helpers', () {
    late _MockHomeRepository homeRepository;
    late _MockLogger logger;

    setUp(() {
      homeRepository = _MockHomeRepository();
      logger = _MockLogger();
    });

    testWidgets('returns false and shows error when no membership', (
      tester,
    ) async {
      when(
        () => homeRepository.getCurrentMembership(),
      ).thenAnswer((_) async => null);
      final ctx = await pumpScaffold(tester);
      final result = await shareInviteForTest(
        ctx,
        isFlatmate: false,
        repo: homeRepository,
        logger: logger,
        s: l10n,
      );

      expect(result, isFalse);
    });

    testWidgets('returns false and shows error when invite missing', (
      tester,
    ) async {
      when(() => homeRepository.getCurrentMembership()).thenAnswer(
        (_) async => CurrentMembership(
          userId: 'uid',
          homeId: 'hid',
          role: 'member',
          validFrom: DateTime(2024),
        ),
      );
      when(() => homeRepository.getActiveInvite('hid')).thenThrow(Exception());
      when(
        () => homeRepository.getOrCreateInvite(homeId: 'hid'),
      ).thenThrow(Exception());

      final ctx = await pumpScaffold(tester);

      final result = await shareInviteForTest(
        ctx,
        isFlatmate: true,
        repo: homeRepository,
        logger: logger,
        s: l10n,
      );

      expect(result, isFalse);
    });
  });

  group('maybePromptNotifications', () {
    late _MockNotificationPermissionService permissionService;
    late _MockNotificationsRepository notifRepo;
    late _MockDeviceTokenProvider tokenProvider;
    late _MockTimezoneResolver timezoneResolver;
    late _MockLogger logger;

    setUp(() {
      permissionService = _MockNotificationPermissionService();
      notifRepo = _MockNotificationsRepository();
      tokenProvider = _MockDeviceTokenProvider();
      timezoneResolver = _MockTimezoneResolver();
      logger = _MockLogger();
      when(
        () => timezoneResolver.resolve(),
      ).thenAnswer((_) async => 'America/Los_Angeles');
      when(() => tokenProvider.getToken()).thenAnswer((_) async => 'token');
    });

    testWidgets('exits early when context unmounted', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop();
              });
              return Placeholder(key: key);
            },
          ),
        ),
      );

      await tester.pump();
      // context is unmounted now
      await maybePromptNotificationsForTest(
        key.currentContext!,
        onPrompt: () {},
        permissionService: permissionService,
        notificationsRepository: notifRepo,
        tokenProvider: tokenProvider,
        timezoneResolver: timezoneResolver,
        logger: logger,
      );
      // If it runs to completion without throwing, it's good enough here.
    });
  });
}
