import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/foundation/surfaces/today/shopping/bloc/shopping_list_bloc.dart';
import 'package:kinly/foundation/surfaces/today/shopping/today_shopping_list_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/kinly_icons.dart';
import 'package:mocktail/mocktail.dart';

class _MockShoppingListBloc
    extends MockBloc<ShoppingListEvent, ShoppingListState>
    implements ShoppingListBloc {}

void main() {
  late _MockShoppingListBloc bloc;

  ShoppingListItem item({
    required String id,
    required String name,
    required bool isCompleted,
    String? quantity,
    String? details,
    String? photoPath,
  }) {
    final now = DateTime(2026, 2, 1, 10);
    return ShoppingListItem(
      id: id,
      homeId: 'home-1',
      name: name,
      quantity: quantity,
      details: details,
      referencePhotoPath: photoPath,
      isCompleted: isCompleted,
      completedByUserId: isCompleted ? 'user-me' : null,
      completedByAvatarId: null,
      completedAt: isCompleted ? now : null,
      archivedAt: null,
      createdAt: now.subtract(const Duration(minutes: 10)),
      updatedAt: now,
    );
  }

  Widget _buildRouterApp(ShoppingListState state) {
    when(() => bloc.state).thenReturn(state);
    whenListen(
      bloc,
      Stream<ShoppingListState>.fromIterable([state]),
      initialState: state,
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder:
              (_, __) => BlocProvider<ShoppingListBloc>.value(
                value: bloc,
                child: const TodayShoppingListScreen(homeId: 'home-1'),
              ),
        ),
        GoRoute(
          path: '/shopping/:itemId/edit',
          name: AppRouteNames.todayShoppingEdit,
          builder:
              (_, state) => Scaffold(
                body: Text('edit:${state.pathParameters['itemId']}'),
              ),
        ),
      ],
    );
    addTearDown(router.dispose);

    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: buildKinlyTheme(Brightness.light),
    );
  }

  S _strings(WidgetTester tester) {
    final context = tester.element(find.byType(TodayShoppingListScreen));
    return S.of(context);
  }

  setUp(() {
    bloc = _MockShoppingListBloc();
  });

  testWidgets('shows quantity as subtitle and opens editor for every row', (
    tester,
  ) async {
    final state = ShoppingListState.loaded(
      pendingItems: [
        item(
          id: 'milk',
          name: 'Milk',
          quantity: '2 cartons',
          details: 'Skimmed',
          isCompleted: false,
        ),
        item(id: 'salt', name: 'Salt', quantity: '1 pack', isCompleted: false),
      ],
      completedItems: const [],
      photoUrlsByItemId: const {},
      myCompletedCount: 0,
    );

    await tester.pumpWidget(_buildRouterApp(state));
    await tester.pumpAndSettle();

    expect(find.text('2 cartons'), findsOneWidget);
    expect(find.text('1 pack'), findsOneWidget);
    expect(find.byIcon(KinlyIcons.chevronRight), findsNWidgets(2));

    await tester.tap(find.text('Salt'));
    await tester.pumpAndSettle();
    expect(find.text('edit:salt'), findsOneWidget);

    await tester.pumpWidget(_buildRouterApp(state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Milk'));
    await tester.pumpAndSettle();
    expect(find.text('edit:milk'), findsOneWidget);
  });

  testWidgets('hides tabs when only pending items exist', (tester) async {
    final state = ShoppingListState.loaded(
      pendingItems: [item(id: 'milk', name: 'Milk', isCompleted: false)],
      completedItems: const [],
      photoUrlsByItemId: const {},
      myCompletedCount: 0,
    );

    await tester.pumpWidget(_buildRouterApp(state));
    await tester.pumpAndSettle();

    final s = _strings(tester);
    expect(find.text('${s.shoppingTabPending} (1)'), findsNothing);
    expect(find.text('${s.shoppingArchiveCta} (0)'), findsNothing);
  });

  testWidgets('hides tabs when only completed items exist', (tester) async {
    final state = ShoppingListState.loaded(
      pendingItems: const [],
      completedItems: [item(id: 'milk', name: 'Milk', isCompleted: true)],
      photoUrlsByItemId: const {},
      myCompletedCount: 1,
    );

    await tester.pumpWidget(_buildRouterApp(state));
    await tester.pumpAndSettle();

    final s = _strings(tester);
    expect(find.text('${s.shoppingTabPending} (0)'), findsNothing);
    expect(find.text('${s.shoppingArchiveCta} (1)'), findsNothing);
  });

  testWidgets(
    'shows both tabs with pending count when pending and completed exist',
    (tester) async {
      final state = ShoppingListState.loaded(
        pendingItems: [item(id: 'milk', name: 'Milk', isCompleted: false)],
        completedItems: [item(id: 'eggs', name: 'Eggs', isCompleted: true)],
        photoUrlsByItemId: const {},
        myCompletedCount: 1,
      );

      await tester.pumpWidget(_buildRouterApp(state));
      await tester.pumpAndSettle();

      final s = _strings(tester);
      expect(find.text('${s.shoppingTabPending} (1)'), findsOneWidget);
      expect(find.text('${s.shoppingArchiveCta} (1)'), findsOneWidget);
    },
  );
}
