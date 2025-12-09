import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:kinly/core/paywall/paywall_models.dart';
import 'package:kinly/core/purchases/revenuecat_service.dart';
import 'package:kinly/data/repositories/auth_repository.dart';
import 'package:kinly/data/repositories/paywall_repository.dart';
import 'package:kinly/features/paywall/ui/paywall_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kinly/core/theme/kinly_theme.dart';

class _MockPaywallRepository extends Mock implements PaywallRepository {}

class _MockRevenueCatService extends Mock implements RevenueCatService {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _RevenueCatPackageFake extends Fake implements RevenueCatPackage {}

void main() {
  final sl = GetIt.instance;

  setUp(() {
    sl.reset();
    sl.registerLazySingleton<PaywallRepository>(() => _MockPaywallRepository());
    sl.registerLazySingleton<RevenueCatService>(() => _MockRevenueCatService());
    sl.registerLazySingleton<AuthRepository>(() => _MockAuthRepository());
  });

  setUpAll(() {
    registerFallbackValue(PaywallEventType.impression);
    registerFallbackValue(_RevenueCatPackageFake());
  });

  testWidgets('renders paywall content and triggers CTA', (tester) async {
    final repo = sl<PaywallRepository>() as _MockPaywallRepository;
    final rc = sl<RevenueCatService>() as _MockRevenueCatService;
    final auth = sl<AuthRepository>() as _MockAuthRepository;

    when(() => auth.current).thenReturn(const AuthSession(userId: 'user-1'));
    when(() => repo.logEvent(
          homeId: any(named: 'homeId'),
          eventType: any(named: 'eventType'),
          source: any(named: 'source'),
        )).thenAnswer((_) async {});
    when(() => rc.fetchMonthlyPackage()).thenAnswer(
      (_) async => RevenueCatPackage(identifier: 'monthly', priceString: '\$4.99'),
    );
    when(() => rc.purchaseMonthly(any())).thenAnswer((_) async {});
    when(
      () => rc.setSubscriberAttributes(
        appUserId: any(named: 'appUserId'),
        homeId: any(named: 'homeId'),
        locale: any(named: 'locale'),
        email: any(named: 'email'),
      ),
    ).thenAnswer((_) async {});
    when(() => rc.setSubscriberAttributes(
          appUserId: any(named: 'appUserId'),
          homeId: any(named: 'homeId'),
          locale: any(named: 'locale'),
          email: any(named: 'email'),
        )).thenAnswer((_) async {});

    final strings = PaywallStrings(
      title: 'Harmony headline',
      subtitle: 'Affordable message',
      bulletMembers: 'Unlimited members',
      bulletFlows: 'Unlimited flows',
      bulletPhotos: 'Unlimited photos',
      bulletShares: 'Unlimited shares',
      unlimitedLabel: 'Unlimited everything',
      primaryCta: 'Upgrade',
      secondaryCta: 'Continue free',
      purchaseFailed: 'Purchase failed',
      purchaseSuccess: 'Purchase success',
      restoreCta: 'Restore',
      errorTitle: 'Load error',
      retryLabel: 'Retry',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKinlyTheme(Brightness.light),
        home: KinlyPaywallScreen(
          homeId: 'home-1',
          strings: strings,
        ),
      ),
    );

    // initial loader then loaded content
    await tester.pump();
    await tester.pump();

    expect(find.text('Harmony headline'), findsOneWidget);
    expect(find.text('Upgrade'), findsOneWidget);

    await tester.tap(find.text('Upgrade'));
    await tester.pump();
    verify(() => rc.purchaseMonthly(any())).called(1);
  });
}
