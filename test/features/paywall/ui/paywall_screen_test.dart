import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/homes/models.dart';
import 'package:kinly/core/paywall/enums/paywall_event_type.dart';
import 'package:kinly/core/purchases/revenuecat_service.dart';
import 'package:kinly/data/repositories/auth_repository.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/data/repositories/paywall_repository.dart';
import 'package:kinly/features/paywall/ui/paywall_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kinly/core/theme/kinly_theme.dart';

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
  final sl = GetIt.instance;

  setUp(() {
    sl.reset();
    sl.registerLazySingleton<PaywallRepository>(() => _MockPaywallRepository());
    sl.registerLazySingleton<RevenueCatService>(() => _MockRevenueCatService());
    sl.registerLazySingleton<AuthRepository>(() => _MockAuthRepository());
    sl.registerLazySingleton<HomeRepository>(() => _MockHomeRepository());
    sl.registerLazySingleton<Logger>(() => _MockLogger());
  });

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    const purchasesChannel = MethodChannel('purchases_flutter');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(purchasesChannel, (methodCall) async {
          if (methodCall.method == 'getAppUserID') return 'rc-test-user';
          return null;
        });
    registerFallbackValue(PaywallEventType.impression);
    registerFallbackValue(_RevenueCatPackageFake());
  });

  testWidgets('renders paywall content and triggers CTA', (tester) async {
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
    ).thenAnswer(
      (_) async => List.generate(
        6,
        (i) => HomeMemberSummary(
          userId: 'user-${i + 1}',
          username: 'Member ${i + 1}',
          role: i == 0 ? 'owner' : 'member',
          validFrom: DateTime(2024, 1, 1),
          avatarUrl: null,
        ),
      ),
    );
    when(
      () => rc.fetchMonthlyPackage(placementId: any(named: 'placementId')),
    ).thenAnswer(
      (_) async =>
          RevenueCatPackage(identifier: 'monthly', priceString: '\$4.99'),
    );
    when(() => rc.purchaseMonthly(any())).thenAnswer((_) async {});
    when(() => rc.isEntitlementActive(any())).thenAnswer((_) async => true);
    when(
      () => rc.setSubscriberAttributes(
        appUserId: any(named: 'appUserId'),
        homeId: any(named: 'homeId'),
        locale: any(named: 'locale'),
        email: any(named: 'email'),
      ),
    ).thenAnswer((_) async {});

    final strings = PaywallStrings(
      title: 'Harmony headline',
      subtitle: 'Affordable message',
      bulletMembers: 'Unlimited members',
      bulletFlows: 'Unlimited flows',
      bulletPhotos: 'Unlimited photos',
      bulletShares: 'Unlimited shares',
      unlimitedLabel: 'Unlimited everything',
      priceCaption: 'Home-level plan',
      priceUnavailableLabel: 'Price unavailable',
      priceFormatter: (p) => '$p per home',
      primaryCta: 'Upgrade',
      secondaryCta: 'Continue free',
      purchaseFailed: 'Purchase failed',
      purchaseSuccess: 'Purchase success',
      restoreCta: 'Restore',
      errorTitle: 'Load error',
      retryLabel: 'Retry',
    );

    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: _FakeSvgBundle(),
        child: MaterialApp(
          theme: buildKinlyTheme(Brightness.light),
          home: KinlyPaywallScreen(homeId: 'home-1', strings: strings),
        ),
      ),
    );

    // initial loader then loaded content
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Harmony headline'), findsOneWidget);
    expect(find.text('Unlimited flows'), findsOneWidget);
    expect(find.text('+1'), findsOneWidget);
    expect(find.text('Upgrade (\$4.99 per home)'), findsOneWidget);

    await tester.tap(find.text('Upgrade (\$4.99 per home)'));
    await tester.pumpAndSettle();
    verify(() => rc.purchaseMonthly(any())).called(1);
  });
}
