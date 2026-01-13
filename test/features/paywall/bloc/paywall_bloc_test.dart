import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/paywall/enums/paywall_event_type.dart';
import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/purchases/revenuecat_service.dart';
import 'package:kinly/contracts/auth/ports/auth_repository.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/features/paywall/paywall.dart';
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
    flutter_test
        .TestDefaultBinaryMessengerBinding
        .instance
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
    ).thenAnswer(
      (_) async => [
        HomeMemberSummary(
          userId: 'user-1',
          username: 'You',
          role: 'owner',
          validFrom: DateTime(2024, 1, 1),
          avatarUrl: null,
        ),
      ],
    );
    when(
      () => revenueCatService.fetchMonthlyPackage(
        placementId: any(named: 'placementId'),
      ),
    ).thenAnswer(
      (_) async =>
          RevenueCatPackage(identifier: 'monthly', priceString: '\$4.99'),
    );
    when(
      () => revenueCatService.isEntitlementActive(any()),
    ).thenAnswer((_) async => true);
    when(
      () => revenueCatService.purchaseMonthly(any()),
    ).thenAnswer((_) async {});
    when(() => revenueCatService.restorePurchases()).thenAnswer((_) async {});
    when(
      () => revenueCatService.getCustomerInfo(),
    ).thenThrow(Exception('stub'));
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

  blocTest<PaywallBloc, PaywallState>(
    'purchase failure emits error',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const PaywallStarted());
      await Future<void>.delayed(Duration.zero);
      when(
        () => revenueCatService.purchaseMonthly(any()),
      ).thenThrow(Exception('fail'));
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
          isA<PaywallState>()
              .having((s) => s.actionStatus, 'idle', PaywallActionStatus.idle)
              .having((s) => s.error, 'error', flutter_test.isNotNull),
        ],
  );

  group('PaywallEvent props', () {
    group('PaywallStarted', () {
      test('props contains source and triggers', () {
        final event = const PaywallStarted(
          source: 'test_source',
          triggers: {PaywallTrigger.flowActiveCap},
        );
        expect(event.props, ['test_source', {PaywallTrigger.flowActiveCap}]);
      });

      test('two events with same props are equal', () {
        const event1 = PaywallStarted(source: 'a');
        const event2 = PaywallStarted(source: 'a');
        expect(event1, equals(event2));
      });

      test('two events with different props are not equal', () {
        const event1 = PaywallStarted(source: 'a');
        const event2 = PaywallStarted(source: 'b');
        expect(event1, isNot(equals(event2)));
      });
    });

    group('PaywallCtaPressed', () {
      test('props contains locale, email, and source', () {
        const event = PaywallCtaPressed(
          locale: 'en',
          email: 'test@example.com',
          source: 'cta_test',
        );
        expect(event.props, ['en', 'test@example.com', 'cta_test']);
      });

      test('two events with same props are equal', () {
        const event1 = PaywallCtaPressed(locale: 'en', email: 'a@b.com');
        const event2 = PaywallCtaPressed(locale: 'en', email: 'a@b.com');
        expect(event1, equals(event2));
      });
    });

    group('PaywallRestorePressed', () {
      test('props contains source', () {
        const event = PaywallRestorePressed(source: 'restore_test');
        expect(event.props, ['restore_test']);
      });

      test('two events with same source are equal', () {
        const event1 = PaywallRestorePressed(source: 'x');
        const event2 = PaywallRestorePressed(source: 'x');
        expect(event1, equals(event2));
      });
    });

    group('PaywallDismissed', () {
      test('props contains source', () {
        const event = PaywallDismissed(source: 'dismiss_test');
        expect(event.props, ['dismiss_test']);
      });

      test('two events with same source are equal', () {
        const event1 = PaywallDismissed(source: 'y');
        const event2 = PaywallDismissed(source: 'y');
        expect(event1, equals(event2));
      });

      test('two events with different source are not equal', () {
        const event1 = PaywallDismissed(source: 'x');
        const event2 = PaywallDismissed(source: 'y');
        expect(event1, isNot(equals(event2)));
      });
    });
  });
}
