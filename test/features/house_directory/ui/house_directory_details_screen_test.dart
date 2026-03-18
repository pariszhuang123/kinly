import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_details_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/theme/kinly_theme.dart';
import 'package:mocktail/mocktail.dart';

class _MockHouseDirectoryBloc
    extends MockBloc<HouseDirectoryEvent, HouseDirectoryState>
    implements HouseDirectoryBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(const HouseDirectoryStarted());
  });

  group('HouseDirectoryDetailsScreen', () {
    late _MockHouseDirectoryBloc bloc;

    setUp(() {
      bloc = _MockHouseDirectoryBloc();
    });

    testWidgets('defaults to segmented browse mode and switches sections', (
      tester,
    ) async {
      final state = _buildState();
      when(() => bloc.state).thenReturn(state);
      whenListen(
        bloc,
        const Stream<HouseDirectoryState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildHarness(bloc));
      await tester.pumpAndSettle();

      expect(find.text('Searching all house details'), findsNothing);
      expect(find.text('Landlord'), findsOneWidget);
      expect(find.text('Move-in checklist'), findsNothing);
      expect(find.text('How to reset the boiler'), findsNothing);

      await tester.tap(find.text('House notes'));
      await tester.pumpAndSettle();

      expect(find.text('Move-in checklist'), findsOneWidget);
      expect(find.text('Landlord'), findsNothing);

      await tester.tap(find.text('Tutorials'));
      await tester.pumpAndSettle();

      expect(find.text('How to reset the boiler'), findsOneWidget);
      expect(find.text('Move-in checklist'), findsNothing);
    });

    testWidgets('search switches to stacked all-results mode and clear restores browse mode', (
      tester,
    ) async {
      final state = _buildState();
      when(() => bloc.state).thenReturn(state);
      whenListen(
        bloc,
        const Stream<HouseDirectoryState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildHarness(bloc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tutorials'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'reset');
      await tester.pumpAndSettle();

      expect(find.text('Searching all house details'), findsOneWidget);
      expect(find.text('How to reset the boiler'), findsOneWidget);
      expect(find.text('Tutorials'), findsAtLeastNWidgets(1));
      expect(find.text('House notes'), findsNothing);
      expect(find.text('Utilities and services'), findsNothing);

      final clearButton = find.byTooltip('Clear');
      if (clearButton.evaluate().isNotEmpty) {
        await tester.tap(clearButton);
      } else {
        await tester.enterText(find.byType(TextField), '');
      }
      await tester.pumpAndSettle();

      expect(find.text('Searching all house details'), findsNothing);
      expect(find.text('How to reset the boiler'), findsOneWidget);
      expect(find.text('Move-in checklist'), findsNothing);
    });
  });
}

Widget _buildHarness(HouseDirectoryBloc bloc) {
  return MaterialApp(
    theme: buildKinlyTheme(Brightness.light),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: BlocProvider<HouseDirectoryBloc>.value(
      value: bloc,
      child: const HouseDirectoryDetailsScreen(homeId: 'home-1'),
    ),
  );
}

HouseDirectoryState _buildState() {
  final now = DateTime(2026, 3, 14);
  return HouseDirectoryState(
    status: HouseDirectoryStatus.success,
    isOwner: true,
    services: [
      HouseDirectoryService(
        id: 'service-1',
        homeId: 'home-1',
        serviceType: HouseDirectoryServiceType.rent,
        providerName: 'Landlord',
        createdAt: now,
        updatedAt: now,
      ),
    ],
    notes: [
      HouseDirectoryNote(
        id: 'note-1',
        homeId: 'home-1',
        title: 'Move-in checklist',
        details: 'How to settle into the house',
        noteType: HouseDirectoryNoteType.general,
        createdAt: now,
        updatedAt: now,
      ),
    ],
    tutorials: [
      HouseDirectoryNote(
        id: 'tutorial-1',
        homeId: 'home-1',
        title: 'How to reset the boiler',
        details: 'Hold the reset button for ten seconds',
        noteType: HouseDirectoryNoteType.tutorial,
        createdAt: now,
        updatedAt: now,
      ),
    ],
    members: const [],
    reminders: const [],
  );
}
