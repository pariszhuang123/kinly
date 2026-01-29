import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/core/auth/enums/auth_status.dart';
import 'package:kinly/core/links/enums/join_intent_navigator.dart';
import 'package:kinly/core/links/invite_code_parser.dart';
import 'package:kinly/core/links/join_intent_coordinator.dart';
import 'package:kinly/core/links/pending_join_intent_storage.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockLogger extends Mock implements Logger {}

class _InMemorySecureStorage extends Fake implements FlutterSecureStorage {
  final _store = <String, String?>{};

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
  }) async => _store[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
  }) async {
    _store[key] = value;
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
  }) async {
    _store.remove(key);
  }
}

void main() {
  late _MockHomeRepository homeRepository;
  late _MockLogger logger;
  late PendingJoinIntentStorage storage;
  late JoinIntentCoordinator coordinator;

  setUp(() {
    homeRepository = _MockHomeRepository();
    logger = _MockLogger();
    storage = PendingJoinIntentStorage(storage: _InMemorySecureStorage());
    coordinator = JoinIntentCoordinator(
      storage: storage,
      parser: const InviteCodeParser(),
      homeRepository: homeRepository,
      logger: logger,
    );
  });

  tearDown(() {
    coordinator.dispose();
  });

  test('capture saves a valid invite code', () async {
    final saved = await coordinator.capture(
      Uri.parse('https://go.makinglifeeasie.com/kinly/join/ab23cd'),
    );

    expect(saved, isTrue);
    final loaded = await storage.load();
    expect(loaded?.inviteCode, 'AB23CD');
  });

  test(
    'authenticated with active membership skips RPC and clears intent',
    () async {
      await coordinator.capture(Uri.parse('kinly://join?code=abc234'));

      final result = await coordinator.handleAuthState(
        authStatus: AuthStatus.authenticated,
        membershipStatus: AuthMembershipStatus.active,
        userId: 'u1',
      );

      verifyNever(() => homeRepository.joinHome(any()));
      expect(result.navigation, JoinIntentNavigation.today);
      expect(await storage.load(), isNull);
    },
  );

  test(
    'authenticated without membership calls join and routes by outcome',
    () async {
      when(() => homeRepository.joinHome(any())).thenAnswer(
        (_) async => HomeJoinResult(homeId: 'h1', outcome: JoinOutcome.success),
      );
      await coordinator.capture(Uri.parse('kinly://join?code=abc234'));

      final result = await coordinator.handleAuthState(
        authStatus: AuthStatus.authenticated,
        membershipStatus: AuthMembershipStatus.none,
        userId: 'u1',
      );

      verify(() => homeRepository.joinHome('ABC234')).called(1);
      expect(result.navigation, JoinIntentNavigation.today);
      expect(await storage.load(), isNull);
    },
  );

  test('blocked outcome routes to blocked and clears intent', () async {
    when(() => homeRepository.joinHome(any())).thenAnswer(
      (_) async => HomeJoinResult(
        homeId: 'h1',
        outcome: JoinOutcome.blocked,
        code: 'member_cap',
      ),
    );
    await coordinator.capture(Uri.parse('kinly://join?code=abc234'));

    final result = await coordinator.handleAuthState(
      authStatus: AuthStatus.authenticated,
      membershipStatus: AuthMembershipStatus.none,
      userId: 'u1',
    );

    expect(result.navigation, JoinIntentNavigation.blocked);
    expect(await storage.load(), isNull);
  });

  test('captureInstallReferrer stores a valid code with source', () async {
    final stored = await coordinator.captureInstallReferrer(
      'kinly_invite_code=ab23cd&src=web_join',
    );

    expect(stored, isTrue);
    final loaded = await storage.load();
    expect(loaded?.inviteCode, 'AB23CD');
    expect(loaded?.source, 'android_install_referrer');
  });

  test('install referrer does not override higher-precedence deep link', () async {
    await coordinator.capture(Uri.parse('https://go.makinglifeeasie.com/kinly/join/zz99yy'));

    final stored = await coordinator.captureInstallReferrer(
      'kinly_invite_code=ab23cd',
    );

    expect(stored, isFalse);
    final loaded = await storage.load();
    expect(loaded?.inviteCode, 'ZZ99YY');
  });

  test('manual entry parses raw code and respects precedence', () async {
    final stored = await coordinator.captureManualEntry('ab23cd');
    expect(stored, isTrue);
    expect((await storage.load())?.source, 'ios_manual_confirm');

    final override = await coordinator.captureInstallReferrer(
      'kinly_invite_code=cd34ef',
    );
    expect(override, isTrue);
    expect((await storage.load())?.inviteCode, 'CD34EF');
    expect((await storage.load())?.source, 'android_install_referrer');
  });

  test('onIntentCaptured fires when a valid invite is captured', () async {
    var eventCount = 0;
    final sub = coordinator.onIntentCaptured.listen((_) => eventCount++);

    await coordinator.capture(
      Uri.parse('https://go.makinglifeeasie.com/kinly/join/ab23cd'),
    );
    await Future<void>.delayed(Duration.zero);
    expect(eventCount, 1);

    await coordinator.capture(Uri.parse('kinly://join?code=invalid!'));
    await Future<void>.delayed(Duration.zero);
    expect(eventCount, 1);

    await sub.cancel();
  });
}
