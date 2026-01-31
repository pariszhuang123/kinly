import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/app/join_intent_bootstrap.dart';
import 'package:kinly/core/links/join_intent_coordinator.dart';
import 'package:kinly/core/links/pending_join_intent_storage.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/di/locator.dart';

class _MockCoordinator extends Mock implements JoinIntentCoordinator {}

class _MockLogger extends Mock implements Logger {}

class _MockAppLinks extends Mock implements AppLinks {}

class _MockPendingStorage extends Mock implements PendingJoinIntentStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://go.makinglifeeasie.com/kinly/join/ABC123'));
  });

  late _MockCoordinator coordinator;
  late _MockLogger logger;
  late _MockAppLinks appLinks;
  late _MockPendingStorage storage;

  setUp(() {
    coordinator = _MockCoordinator();
    logger = _MockLogger();
    appLinks = _MockAppLinks();
    storage = _MockPendingStorage();
    sl.reset();
    sl.registerLazySingleton<PendingJoinIntentStorage>(() => storage);
  });

  tearDown(() async {
    await sl.reset();
  });

  test('captures initial deep link and stream links', () async {
    final initial = Uri.parse('https://go.makinglifeeasie.com/kinly/join/ABC123');
    when(() => appLinks.getInitialLink()).thenAnswer((_) async => initial);

    final streamController = StreamController<Uri>();
    when(() => appLinks.uriLinkStream).thenAnswer((_) => streamController.stream);
    when(() => coordinator.capture(any())).thenAnswer((_) async => true);

    final bootstrap = JoinIntentBootstrap(coordinator: coordinator, logger: logger);
    // inject mocked AppLinks via factory override
    await bootstrap.initWith(appLinks: appLinks);

    verify(() => coordinator.capture(initial)).called(1);

    final next = Uri.parse('https://go.makinglifeeasie.com/kinly/join/ZZ99YY');
    streamController.add(next);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    verify(() => coordinator.capture(next)).called(1);

    await streamController.close();
    await bootstrap.dispose();
  });

  test('skips when coordinator is null', () async {
    final bootstrap = JoinIntentBootstrap(coordinator: null, logger: logger);
    await bootstrap.init();
    await bootstrap.dispose();
    verifyNever(() => logger.warn(any(), tag: any(named: 'tag'), error: any(named: 'error'), stackTrace: any(named: 'stackTrace')));
  });

}
