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
}
