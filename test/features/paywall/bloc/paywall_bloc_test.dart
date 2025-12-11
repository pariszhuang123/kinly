import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:kinly/core/homes/models.dart';
import 'package:kinly/core/paywall/paywall_models.dart';
import 'package:kinly/core/paywall/enums/paywall_event_type.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/purchases/revenuecat_service.dart';
import 'package:kinly/data/repositories/auth_repository.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/data/repositories/paywall_repository.dart';
import 'package:kinly/features/paywall/bloc/paywall_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockPaywallRepository extends Mock implements PaywallRepository {}

class _MockRevenueCatService extends Mock implements RevenueCatService {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockLogger extends Mock implements Logger {}

class _RevenueCatPackageFake extends Fake implements RevenueCatPackage {}

void main() {
  late _MockPaywallRepository paywallRepository;
  late _MockRevenueCatService revenueCatService;
  late _MockAuthRepository authRepository;
  late _MockHomeRepository homeRepository;
  late _MockLogger logger;
  const homeId = 'home-1';
  setUpAll(() {
    flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
    const purchasesChannel = MethodChannel('purchases_flutter');
    flutter_test.TestDefaultBinaryMessengerBinding.instance
        .defaultBinaryMessenger
        .setMockMethodCallHandler(purchasesChannel, (methodCall) async {
      if (methodCall.method == 'getAppUserID') return 'rc-test-user';
      return null;
    });
    registerFallbackValue(PaywallEventType.impression);
    registerFallbackValue(_RevenueCatPackageFake());
  });

  setUp(() {
    paywallRepository = _MockPaywallRepository();
    revenueCatService = _MockRevenueCatService();
    authRepository = _MockAuthRepository();
    homeRepository = _MockHomeRepository();
    logger = _MockLogger();

    when(
      () => authRepository.current,
    ).thenReturn(const AuthSession(userId: 'user-1'));
    when(
      () => paywallRepository.logEvent(
        homeId: any(named: 'homeId'),
        eventType: any(named: 'eventType'),
        source: any(named: 'source'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => homeRepository.listActiveMembers(
        any(),
        excludeSelf: any(named: 'excludeSelf'),
      ),
    ).thenAnswer((_) async => [
          HomeMemberSummary(
            userId: 'user-1',
            username: 'You',
            role: 'owner',
            validFrom: DateTime(2024, 1, 1),
            avatarUrl: null,
          ),
        ]);
    when(
      () => revenueCatService.fetchMonthlyPackage(
        placementId: any(named: 'placementId'),
      ),
    ).thenAnswer(
      (_) async =>
          RevenueCatPackage(identifier: 'monthly', priceString: '\$4.99'),
    );
    when(() => revenueCatService.isEntitlementActive(any())).thenAnswer(
      (_) async => true,
    );
    when(
      () => revenueCatService.purchaseMonthly(any()),
    ).thenAnswer((_) async {});
    when(() => revenueCatService.restorePurchases()).thenAnswer((_) async {});
    when(() => revenueCatService.getCustomerInfo()).thenThrow(Exception('stub'));
    when(
      () => revenueCatService.setSubscriberAttributes(
        appUserId: any(named: 'appUserId'),
        homeId: any(named: 'homeId'),
        locale: any(named: 'locale'),
        email: any(named: 'email'),
      ),
    ).thenAnswer((_) async {});
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
  });

  PaywallBloc buildBloc() => PaywallBloc(
    paywallRepository: paywallRepository,
    revenueCatService: revenueCatService,
    authRepository: authRepository,
    homeRepository: homeRepository,
    homeId: homeId,
    logger: logger,
  );

  blocTest<PaywallBloc, PaywallState>(
    'loads status and package on start',
    build: buildBloc,
    act: (bloc) => bloc.add(const PaywallStarted()),
    expect:
        () => [
          isA<PaywallState>().having(
            (s) => s.status,
            'loading',
            PaywallLoadStatus.loading,
          ),
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
      when(
        () => revenueCatService.purchaseMonthly(any()),
      ).thenAnswer((_) async {});
      bloc.add(const PaywallCtaPressed());
    },
    expect:
        () => [
          isA<PaywallState>().having(
            (s) => s.status,
            'loading',
            PaywallLoadStatus.loading,
          ),
          isA<PaywallState>().having(
            (s) => s.status,
            'ready',
            PaywallLoadStatus.ready,
          ),
          isA<PaywallState>().having(
            (s) => s.actionStatus,
            'purchasing',
            PaywallActionStatus.purchasing,
          ),
          isA<PaywallState>().having(
            (s) => s.actionStatus,
            'success',
            PaywallActionStatus.success,
          ),
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
    expect:
        () => [
          isA<PaywallState>().having(
            (s) => s.status,
            'loading',
            PaywallLoadStatus.loading,
          ),
          isA<PaywallState>().having(
            (s) => s.status,
            'ready',
            PaywallLoadStatus.ready,
          ),
          isA<PaywallState>().having(
            (s) => s.actionStatus,
            'restoring',
            PaywallActionStatus.restoring,
          ),
          isA<PaywallState>().having(
            (s) => s.actionStatus,
            'success',
            PaywallActionStatus.success,
          ),
        ],
  );
}
