import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/contracts/share/share_create_route_args.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/toggles/kinly_checkbox.dart';
import 'package:kinly/foundation/surfaces/today/shopping/bloc/shopping_list_bloc.dart';
import 'package:kinly/foundation/surfaces/today/routes/today_shopping_route_args.dart';
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

  Widget buildRouterApp(
    ShoppingListState state, {
    TodayShoppingListMode mode = TodayShoppingListMode.purchase,
    List<ShoppingListState>? emittedStates,
  }) {
    when(() => bloc.state).thenReturn(state);
    whenListen(
      bloc,
      Stream<ShoppingListState>.fromIterable(emittedStates ?? [state]),
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
                child: TodayShoppingListScreen(homeId: 'home-1', mode: mode),
              ),
        ),
        GoRoute(
          path: '/today',
          name: AppRouteNames.today,
          builder: (_, __) => const Scaffold(body: Text('today-screen')),
        ),
        GoRoute(
          path: '/shopping/:itemId/edit',
          name: AppRouteNames.todayShoppingEdit,
          builder:
              (_, state) => Scaffold(
                body: Text('edit:${state.pathParameters['itemId']}'),
              ),
        ),
        GoRoute(
          path: '/shopping/new',
          name: AppRouteNames.todayShoppingCreate,
          builder: (_, __) => const Scaffold(body: Text('create')),
        ),
        GoRoute(
          path: '/share/new',
          name: AppRouteNames.shareCreate,
          builder: (_, state) {
            final args = state.extra as ShareCreateRouteArgs?;
            return Scaffold(
              body: Text(
                'share-create:${args?.presentationMode.name}:${args?.shoppingExpenseLinkRequest?.itemIds.join(",")}:${args?.preselectEqualSplit}',
              ),
            );
          },
        ),
        GoRoute(
          path: '/shopping/:itemId/detail',
          name: AppRouteNames.todayShoppingDetail,
          builder:
              (_, state) => Scaffold(
                body: Text('detail:${state.pathParameters['itemId']}'),
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

  S strings(WidgetTester tester) {
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

    await tester.pumpWidget(
      buildRouterApp(state, mode: TodayShoppingListMode.manage),
    );
    await tester.pumpAndSettle();

    expect(find.text('2 cartons'), findsOneWidget);
    expect(find.text('1 pack'), findsOneWidget);
    expect(find.byIcon(KinlyIcons.chevronRight), findsNWidgets(2));

    await tester.tap(find.text('Salt'));
    await tester.pumpAndSettle();
    expect(find.text('edit:salt'), findsOneWidget);

    await tester.pumpWidget(
      buildRouterApp(state, mode: TodayShoppingListMode.manage),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Milk'));
    await tester.pumpAndSettle();
    expect(find.text('edit:milk'), findsOneWidget);
  });

  testWidgets('shows only pending tab when no completed items exist', (tester) async {
    final state = ShoppingListState.loaded(
      pendingItems: [item(id: 'milk', name: 'Milk', isCompleted: false)],
      completedItems: const [],
      photoUrlsByItemId: const {},
      myCompletedCount: 0,
    );

    await tester.pumpWidget(buildRouterApp(state));
    await tester.pumpAndSettle();

    final s = strings(tester);
    expect(find.text('${s.shoppingTabPending} (1)'), findsOneWidget);
    expect(find.text('${s.shoppingArchiveCta} (0)'), findsNothing);
  });

  testWidgets('shows add fab in manage mode and opens create screen', (
    tester,
  ) async {
    final state = ShoppingListState.loaded(
      pendingItems: [item(id: 'milk', name: 'Milk', isCompleted: false)],
      completedItems: const [],
      photoUrlsByItemId: const {},
      myCompletedCount: 0,
    );

    await tester.pumpWidget(
      buildRouterApp(state, mode: TodayShoppingListMode.manage),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('create'), findsOneWidget);
  });

  testWidgets('shows add fab in purchase mode when no items are completed', (
    tester,
  ) async {
    final state = ShoppingListState.loaded(
      pendingItems: [item(id: 'milk', name: 'Milk', isCompleted: false)],
      completedItems: const [],
      photoUrlsByItemId: const {},
      myCompletedCount: 0,
    );

    await tester.pumpWidget(buildRouterApp(state));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('create'), findsOneWidget);
  });

  testWidgets('shows only completed tab when no pending items exist', (tester) async {
    final state = ShoppingListState.loaded(
      pendingItems: const [],
      completedItems: [item(id: 'milk', name: 'Milk', isCompleted: true)],
      photoUrlsByItemId: const {},
      myCompletedCount: 1,
    );

    await tester.pumpWidget(buildRouterApp(state));
    await tester.pumpAndSettle();

    final s = strings(tester);
    expect(find.text('${s.shoppingTabPending} (0)'), findsNothing);
    expect(find.text('${s.shoppingArchiveCta} (1)'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);
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

      await tester.pumpWidget(buildRouterApp(state));
      await tester.pumpAndSettle();

      final s = strings(tester);
      expect(find.text('${s.shoppingTabPending} (1)'), findsOneWidget);
      expect(find.text('${s.shoppingArchiveCta} (1)'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
    },
  );

  testWidgets(
    'dismissing archive confirm dialog does not dispatch archive event',
    (tester) async {
      final state = ShoppingListState.loaded(
        pendingItems: const [],
        completedItems: [item(id: 'milk', name: 'Milk', isCompleted: true)],
        photoUrlsByItemId: const {},
        myCompletedCount: 1,
      );

      await tester.pumpWidget(buildRouterApp(state));
      await tester.pumpAndSettle();

      final s = strings(tester);
      await tester.tap(
        find.widgetWithText(KinlyFilledButton, s.shoppingArchiveCta),
      );
      await tester.pumpAndSettle();
      expect(find.text(s.shoppingArchiveSharePromptTitle), findsOneWidget);

      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();
      expect(find.text(s.shoppingArchiveSharePromptTitle), findsNothing);

      verifyNever(
        () => bloc.add(
          const ArchiveMyCompletedShoppingItemsEvent(triggerShareSpend: true),
        ),
      );
      verifyNever(
        () => bloc.add(
          const ArchiveMyCompletedShoppingItemsEvent(triggerShareSpend: false),
        ),
      );
    },
  );

  testWidgets('shows all-items-bought checkbox when pending items exist', (
    tester,
  ) async {
    final state = ShoppingListState.loaded(
      pendingItems: [
        item(id: 'milk', name: 'Milk', isCompleted: false),
        item(id: 'eggs', name: 'Eggs', isCompleted: false),
      ],
      completedItems: const [],
      photoUrlsByItemId: const {},
      myCompletedCount: 0,
    );

    await tester.pumpWidget(buildRouterApp(state));
    await tester.pumpAndSettle();

    final s = strings(tester);
    expect(find.text(s.shoppingAllItemsBought), findsOneWidget);
  });

  testWidgets('tapping all-items-bought checkbox dispatches ToggleAllShoppingItemsEvent', (
    tester,
  ) async {
    final state = ShoppingListState.loaded(
      pendingItems: [
        item(id: 'milk', name: 'Milk', isCompleted: false),
      ],
      completedItems: const [],
      photoUrlsByItemId: const {},
      myCompletedCount: 0,
    );

    await tester.pumpWidget(buildRouterApp(state));
    await tester.pumpAndSettle();

    final s = strings(tester);
    final allItemsRow = find.ancestor(
      of: find.text(s.shoppingAllItemsBought),
      matching: find.byType(Row),
    );
    final allItemsCheckbox = find.descendant(
      of: allItemsRow,
      matching: find.byType(KinlyCheckbox),
    );
    await tester.tap(allItemsCheckbox);
    await tester.pumpAndSettle();

    verify(
      () => bloc.add(const ToggleAllShoppingItemsEvent(isCompleted: true)),
    ).called(1);
  });

  testWidgets('hides all-items-bought checkbox in manage mode', (
    tester,
  ) async {
    final state = ShoppingListState.loaded(
      pendingItems: [
        item(id: 'milk', name: 'Milk', isCompleted: false),
      ],
      completedItems: const [],
      photoUrlsByItemId: const {},
      myCompletedCount: 0,
    );

    await tester.pumpWidget(
      buildRouterApp(state, mode: TodayShoppingListMode.manage),
    );
    await tester.pumpAndSettle();

    final s = strings(tester);
    expect(find.text(s.shoppingAllItemsBought), findsNothing);
  });

  testWidgets('opens quick share create when pending bill handoff is emitted', (
    tester,
  ) async {
    final initial = ShoppingListState.loaded(
      pendingItems: const [],
      completedItems: [item(id: 'milk', name: 'Milk', isCompleted: true)],
      photoUrlsByItemId: const {},
      myCompletedCount: 1,
      pendingBillCreate: null,
      pendingBillCreateTick: 0,
    );
    final handoff = ShoppingListState.loaded(
      pendingItems: const [],
      completedItems: [item(id: 'milk', name: 'Milk', isCompleted: true)],
      photoUrlsByItemId: const {},
      myCompletedCount: 1,
      pendingBillCreate: const PendingShoppingBillCreate(
        description: 'Shopping spend',
        notes: '- Milk',
        itemIds: ['item-1', 'item-2'],
      ),
      pendingBillCreateTick: 1,
    );

    await tester.pumpWidget(
      buildRouterApp(initial, emittedStates: [handoff]),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'share-create:shoppingQuickCreate:item-1,item-2:true',
      ),
      findsOneWidget,
    );
  });
}
