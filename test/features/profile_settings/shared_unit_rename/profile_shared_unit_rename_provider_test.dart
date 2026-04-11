import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/profile_settings/shared_unit_rename/profile_shared_unit_rename_provider.dart';
import 'package:kinly/generated/l10n.dart';

class _MockHomeUnitsRepository extends Mock implements HomeUnitsRepository {}

void main() {
  Widget buildApp(_MockHomeUnitsRepository homeUnitsRepository) {
    return MaterialApp(
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: ProfileSharedUnitRenameProvider(
        unitId: 'unit-shared',
        initialName: 'Alex + Sam',
        homeUnitsRepository: homeUnitsRepository,
      ),
    );
  }

  testWidgets('passes initial name through to the rename screen', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(_MockHomeUnitsRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Rename shared unit'), findsOneWidget);
    expect(find.text('Alex + Sam'), findsOneWidget);
  });
}
