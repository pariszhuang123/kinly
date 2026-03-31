import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/flow/flow_chore_outcome.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_service_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/theme/kinly_theme.dart';
import 'package:mocktail/mocktail.dart';

class _MockHouseDirectoryBloc
    extends MockBloc<HouseDirectoryEvent, HouseDirectoryState>
    implements HouseDirectoryBloc {}

void main() {
  late _MockHouseDirectoryBloc bloc;

  setUpAll(() {
    registerFallbackValue(const HouseDirectoryReminderDismissed('fallback'));
  });

  setUp(() {
    bloc = _MockHouseDirectoryBloc();
  });

  testWidgets(
    'successful task creation from reminder pops back to parent screen',
    (tester) async {
      final state = _buildState(includeReminderOnService: true);
      when(() => bloc.state).thenReturn(state);
      whenListen(
        bloc,
        const Stream<HouseDirectoryState>.empty(),
        initialState: state,
      );

      final router = _buildRouter(
        bloc: bloc,
        serviceScreenBuilder:
            () => const HouseDirectoryServiceScreen(
              homeId: 'home-1',
              isOwner: true,
              serviceId: 'service-1',
              reminderId: 'reminder-1',
            ),
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(_buildApp(router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create task'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Return success'));
      await tester.pumpAndSettle();

      expect(find.text('parent-screen'), findsOneWidget);
      verify(
        () => bloc.add(const HouseDirectoryReminderDismissed('reminder-1')),
      ).called(1);
    },
  );

  testWidgets(
    'successful task creation without reminder route context stays on service screen',
    (tester) async {
      final state = _buildState(includeReminderOnService: true);
      when(() => bloc.state).thenReturn(state);
      whenListen(
        bloc,
        const Stream<HouseDirectoryState>.empty(),
        initialState: state,
      );

      final router = _buildRouter(
        bloc: bloc,
        serviceScreenBuilder:
            () => const HouseDirectoryServiceScreen(
              homeId: 'home-1',
              isOwner: true,
              serviceId: 'service-1',
            ),
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(_buildApp(router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create task'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Return success'));
      await tester.pump();

      expect(find.byType(HouseDirectoryServiceScreen), findsOneWidget);
      expect(find.text('parent-screen'), findsNothing);
      verify(
        () => bloc.add(const HouseDirectoryReminderDismissed('reminder-1')),
      ).called(1);
    },
  );
}

GoRouter _buildRouter({
  required HouseDirectoryBloc bloc,
  required Widget Function() serviceScreenBuilder,
}) {
  return GoRouter(
    initialLocation: '/parent/service',
    routes: [
      GoRoute(
        path: '/parent',
        builder: (_, __) => const Scaffold(body: Text('parent-screen')),
        routes: [
          GoRoute(
            path: 'service',
            builder:
                (_, __) => BlocProvider<HouseDirectoryBloc>.value(
                  value: bloc,
                  child: serviceScreenBuilder(),
                ),
          ),
        ],
      ),
      GoRoute(
        path: '/flow/chore/new',
        name: AppRouteNames.flowChoreCreate,
        builder: (_, __) => const _FlowResultScreen(),
      ),
    ],
  );
}

Widget _buildApp(GoRouter router) {
  return MaterialApp.router(
    theme: buildKinlyTheme(Brightness.light),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    routerConfig: router,
  );
}

class _FlowResultScreen extends StatelessWidget {
  const _FlowResultScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed:
              () => Navigator.of(context).pop(
                const FlowChoreOutcome(
                  choreId: 'chore-1',
                  isUpdate: false,
                ),
              ),
          child: const Text('Return success'),
        ),
      ),
    );
  }
}

HouseDirectoryState _buildState({required bool includeReminderOnService}) {
  final now = DateTime(2026, 3, 29);
  final reminder = HouseDirectoryReminder(
    id: 'reminder-1',
    serviceId: 'service-1',
    termStartDate: now.subtract(const Duration(days: 27)),
    termEndDate: now.add(const Duration(days: 3)),
    providerName: 'Provider',
    dueAt: now.add(const Duration(days: 3)),
    kind: HouseDirectoryReminderKind.renewal,
    status: HouseDirectoryReminderStatus.active,
    serviceType: HouseDirectoryServiceType.internet,
  );

  return HouseDirectoryState(
    status: HouseDirectoryStatus.success,
    isOwner: true,
    services: [
      HouseDirectoryService(
        id: 'service-1',
        homeId: 'home-1',
        serviceType: HouseDirectoryServiceType.internet,
        providerName: 'Provider',
        createdAt: now,
        updatedAt: now,
        reminder: includeReminderOnService ? reminder : null,
      ),
    ],
    notes: const [],
    tutorials: const [],
    members: const [
      HouseDirectoryMemberCard(
        userId: 'owner-1',
        username: 'Owner',
        isOwner: true,
        hasPersonalDirectoryContent: false,
      ),
    ],
    reminders: [reminder],
  );
}
