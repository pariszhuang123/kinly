import 'package:bloc_test/bloc_test.dart';
import 'package:kinly/core/paywall/paywall_models.dart';
import 'package:kinly/core/purchases/revenuecat_service.dart';
import 'package:kinly/data/repositories/auth_repository.dart';
import 'package:kinly/data/repositories/paywall_repository.dart';
import 'package:kinly/features/paywall/bloc/paywall_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockPaywallRepository extends Mock implements PaywallRepository {}

class _MockRevenueCatService extends Mock implements RevenueCatService {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _RevenueCatPackageFake extends Fake implements RevenueCatPackage {}

void main() {
  late _MockPaywallRepository paywallRepository;
  late _MockRevenueCatService revenueCatService;
  late _MockAuthRepository authRepository;
  const homeId = 'home-1';
  setUpAll(() {
    registerFallbackValue(PaywallEventType.impression);
    registerFallbackValue(_RevenueCatPackageFake());
  });

  setUp(() {
    paywallRepository = _MockPaywallRepository();
    revenueCatService = _MockRevenueCatService();
    authRepository = _MockAuthRepository();

    when(() => authRepository.current).thenReturn(const AuthSession(userId: 'user-1'));
    when(() => paywallRepository.logEvent(
          homeId: any(named: 'homeId'),
          eventType: any(named: 'eventType'),
          source: any(named: 'source'),
        )).thenAnswer((_) async {});
    when(() => revenueCatService.fetchMonthlyPackage()).thenAnswer(
      (_) async => RevenueCatPackage(identifier: 'monthly', priceString: '\$4.99'),
    );
    when(() => revenueCatService.purchaseMonthly(any())).thenAnswer((_) async {});
    when(() => revenueCatService.restorePurchases()).thenAnswer((_) async {});
    when(
      () => revenueCatService.setSubscriberAttributes(
        appUserId: any(named: 'appUserId'),
        homeId: any(named: 'homeId'),
        locale: any(named: 'locale'),
        email: any(named: 'email'),
      ),
    ).thenAnswer((_) async {});
  });

  PaywallBloc buildBloc() => PaywallBloc(
        paywallRepository: paywallRepository,
        revenueCatService: revenueCatService,
        authRepository: authRepository,
        homeId: homeId,
      );

  blocTest<PaywallBloc, PaywallState>(
    'loads status and package on start',
    build: buildBloc,
    act: (bloc) => bloc.add(const PaywallStarted()),
    expect: () => [
      isA<PaywallState>().having((s) => s.status, 'loading', PaywallLoadStatus.loading),
      isA<PaywallState>()
          .having((s) => s.status, 'ready', PaywallLoadStatus.ready)
          .having((s) => s.package?.priceString, 'priceString', '\$4.99'),
    ],
  );

  blocTest<PaywallBloc, PaywallState>(
    'purchases monthly package',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const PaywallStarted());
      await Future<void>.delayed(Duration.zero);
      when(() => revenueCatService.purchaseMonthly(any())).thenAnswer((_) async {});
      bloc.add(const PaywallCtaPressed());
    },
    expect: () => [
      isA<PaywallState>().having((s) => s.status, 'loading', PaywallLoadStatus.loading),
      isA<PaywallState>().having((s) => s.status, 'ready', PaywallLoadStatus.ready),
      isA<PaywallState>()
          .having((s) => s.actionStatus, 'purchasing', PaywallActionStatus.purchasing),
      isA<PaywallState>()
          .having((s) => s.actionStatus, 'success', PaywallActionStatus.success),
    ],
    verify: (_) {
      verify(() => revenueCatService.purchaseMonthly(any())).called(1);
    },
  );

  blocTest<PaywallBloc, PaywallState>(
    'restore purchases emits success',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const PaywallStarted());
      await Future<void>.delayed(Duration.zero);
      when(() => revenueCatService.restorePurchases()).thenAnswer((_) async {});
      bloc.add(const PaywallRestorePressed());
    },
    expect: () => [
      isA<PaywallState>().having((s) => s.status, 'loading', PaywallLoadStatus.loading),
      isA<PaywallState>().having((s) => s.status, 'ready', PaywallLoadStatus.ready),
      isA<PaywallState>()
          .having((s) => s.actionStatus, 'restoring', PaywallActionStatus.restoring),
      isA<PaywallState>()
          .having((s) => s.actionStatus, 'success', PaywallActionStatus.success),
    ],
  );
}
