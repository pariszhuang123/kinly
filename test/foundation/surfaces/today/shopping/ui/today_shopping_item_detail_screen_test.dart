import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/foundation/surfaces/today/shopping/today_shopping_item_detail_screen.dart';
import 'package:kinly/generated/l10n.dart';

void main() {
  ShoppingListItem item({
    required bool isCompleted,
    String? quantity,
    String? details,
  }) {
    final now = DateTime(2026, 2, 1, 10);
    return ShoppingListItem(
      id: 'item-1',
      homeId: 'home-1',
      name: 'Milk',
      scopeType: ShoppingItemScopeType.house,
      quantity: quantity,
      details: details,
      referencePhotoPath: null,
      isCompleted: isCompleted,
      completedByUserId: isCompleted ? 'user-me' : null,
      completedByAvatarId: null,
      completedAt: isCompleted ? now : null,
      archivedAt: null,
      createdAt: now.subtract(const Duration(minutes: 5)),
      updatedAt: now,
    );
  }

  Widget buildTestApp(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: buildKinlyTheme(Brightness.light),
      home: child,
    );
  }

  testWidgets('hides empty read-only fields and complete button for completed item', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        TodayShoppingItemDetailScreen(
          item: item(isCompleted: true),
          photoUrl: '',
          onMarkComplete: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(TodayShoppingItemDetailScreen));
    final s = S.of(context);

    expect(find.text(s.shoppingNameLabel), findsOneWidget);
    expect(find.text(s.shoppingAmountLabel), findsNothing);
    expect(find.text(s.shoppingContextLabel), findsNothing);
    expect(find.text(s.shoppingPhotoLabel), findsNothing);
    expect(find.text(s.shoppingMarkCompleteCta), findsNothing);
  });

  testWidgets('shows populated quantity and notes fields for read-only detail', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        TodayShoppingItemDetailScreen(
          item: item(
            isCompleted: false,
            quantity: '2 cartons',
            details: 'Skimmed only',
          ),
          photoUrl: '',
          onMarkComplete: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(TodayShoppingItemDetailScreen));
    final s = S.of(context);

    expect(find.text(s.shoppingAmountLabel), findsOneWidget);
    expect(find.text('2 cartons'), findsOneWidget);
    expect(find.text(s.shoppingContextLabel), findsOneWidget);
    expect(find.text('Skimmed only'), findsOneWidget);
    expect(find.text(s.shoppingMarkCompleteCta), findsOneWidget);
  });
}
