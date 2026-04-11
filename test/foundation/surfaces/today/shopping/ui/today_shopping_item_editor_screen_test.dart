import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/foundation/surfaces/today/shopping/bloc/shopping_item_bloc.dart';
import 'package:kinly/foundation/surfaces/today/shopping/today_shopping_item_editor_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:mocktail/mocktail.dart';

class _MockShoppingItemBloc
    extends MockBloc<ShoppingItemEvent, ShoppingItemState>
    implements ShoppingItemBloc {}

void main() {
  late _MockShoppingItemBloc bloc;

  Widget buildTestApp(ShoppingItemState state) {
    when(() => bloc.state).thenReturn(state);
    whenListen(
      bloc,
      Stream<ShoppingItemState>.fromIterable([state]),
      initialState: state,
    );

    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: buildKinlyTheme(Brightness.light),
      home: BlocProvider<ShoppingItemBloc>.value(
        value: bloc,
        child: const TodayShoppingItemEditorScreen(homeId: 'home-1'),
      ),
    );
  }

  setUp(() {
    bloc = _MockShoppingItemBloc();
  });

  testWidgets('renders localized house tab and unit name for scope selector', (
    tester,
  ) async {
    final state = ShoppingItemState.initial(
      item: null,
      isEditing: false,
      referencePhotoUrl: null,
    ).copyWith(
      unitContext: const HomeUnitContext(
        personalUnit: HomeUnitSummary(
          unitId: 'unit-personal',
          homeId: 'home-1',
          name: 'Personal',
          unitType: HomeUnitType.personal,
          memberUserIds: ['member_self'],
        ),
        activeSharedUnit: HomeUnitSummary(
          unitId: 'unit-shared',
          homeId: 'home-1',
          name: 'Flatmates',
          unitType: HomeUnitType.shared,
          memberUserIds: ['member_self', 'member_a'],
        ),
        allowedShoppingScopes: [
          ShoppingItemScopeType.house,
          ShoppingItemScopeType.unit,
        ],
      ),
      selectedScopeType: ShoppingItemScopeType.house,
      selectedUnitId: 'unit-shared',
    );

    await tester.pumpWidget(buildTestApp(state));
    await tester.pumpAndSettle();

    final s = S.of(tester.element(find.byType(TodayShoppingItemEditorScreen)));
    expect(find.text(s.gratitudeWallHouseTab), findsOneWidget);
    expect(find.text('Flatmates'), findsOneWidget);
  });
}
