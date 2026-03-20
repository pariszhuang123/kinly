import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/logging/logger.dart';

class _FakeLogger extends Logger {
  final List<String> errors = [];

  @override
  void log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level == LogLevel.error) {
      errors.add(message);
    }
  }
}

void main() {
  group('routeFallback', () {
    late _FakeLogger fakeLogger;

    setUp(() {
      fakeLogger = _FakeLogger();
      if (sl.isRegistered<Logger>()) {
        sl.unregister<Logger>();
      }
      sl.registerSingleton<Logger>(fakeLogger);
    });

    tearDown(() {
      if (sl.isRegistered<Logger>()) {
        sl.unregister<Logger>();
      }
    });

    testWidgets('logs an error with the route name', (tester) async {
      final router = GoRouter(
        initialLocation: '/missing-args',
        routes: [
          GoRoute(
            path: '/missing-args',
            name: 'missingArgs',
            builder: (_, __) => routeFallback('testRoute'),
          ),
          GoRoute(
            path: '/today',
            name: AppRouteNames.today,
            builder: (_, __) => const Scaffold(body: Text('Today')),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(
        fakeLogger.errors,
        contains(
          'Missing required args for "testRoute", redirecting to Today',
        ),
      );
    });

    testWidgets('redirects to Today after frame callback', (tester) async {
      final router = GoRouter(
        initialLocation: '/missing-args',
        routes: [
          GoRoute(
            path: '/missing-args',
            name: 'missingArgs',
            builder: (_, __) => routeFallback('testRoute'),
          ),
          GoRoute(
            path: '/today',
            name: AppRouteNames.today,
            builder: (_, __) => const Scaffold(body: Text('Today')),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('redirects to Today instead of popping an existing stack', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/base',
        routes: [
          GoRoute(
            path: '/base',
            builder: (_, context) => const _PushMissingArgsPage(),
          ),
          GoRoute(
            path: '/missing-args',
            name: 'missingArgs',
            builder: (_, __) => routeFallback('testRoute'),
          ),
          GoRoute(
            path: '/today',
            name: AppRouteNames.today,
            builder: (_, __) => const Scaffold(body: Text('Today')),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Base'), findsNothing);
    });
  });
}

class _PushMissingArgsPage extends StatefulWidget {
  const _PushMissingArgsPage();

  @override
  State<_PushMissingArgsPage> createState() => _PushMissingArgsPageState();
}

class _PushMissingArgsPageState extends State<_PushMissingArgsPage> {
  bool _didPush = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPush) return;
    _didPush = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      GoRouter.of(context).push('/missing-args');
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('Base'));
}
