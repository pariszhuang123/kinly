import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/profile_settings/shared_unit_join/profile_shared_unit_join_provider.dart';
import 'package:kinly/generated/l10n.dart';

class _MockHomeUnitsRepository extends Mock implements HomeUnitsRepository {}

void main() {
  late _MockHomeUnitsRepository homeUnitsRepository;

  setUp(() {
    homeUnitsRepository = _MockHomeUnitsRepository();
    when(
      () => homeUnitsRepository.listJoinableSharedUnits(
        homeId: any(named: 'homeId'),
      ),
    ).thenAnswer((_) async => const []);
  });

  Widget buildApp() {
    return MaterialApp(
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: ProfileSharedUnitJoinProvider(
        homeId: 'home-1',
        homeUnitsRepository: homeUnitsRepository,
      ),
    );
  }

  testWidgets('loads joinable shared units on startup', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Join shared unit'), findsNWidgets(2));
    verify(
      () => homeUnitsRepository.listJoinableSharedUnits(homeId: 'home-1'),
    ).called(1);
  });
}
