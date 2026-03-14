import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/theme/kinly_theme.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_flutter/qr_flutter.dart';

class _MockHouseDirectoryBloc
    extends MockBloc<HouseDirectoryEvent, HouseDirectoryState>
    implements HouseDirectoryBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(const HouseDirectoryStarted());
  });

  group('HouseDirectoryScreen', () {
    late _MockHouseDirectoryBloc bloc;

    setUp(() {
      bloc = _MockHouseDirectoryBloc();
    });

    testWidgets('shows qr code for saved wifi and lets the owner edit', (
      tester,
    ) async {
      when(() => bloc.state).thenReturn(_buildState(isOwner: true));
      whenListen(
        bloc,
        const Stream<HouseDirectoryState>.empty(),
        initialState: _buildState(isOwner: true),
      );

      await tester.pumpWidget(_buildHarness(bloc));
      await tester.pumpAndSettle();

      expect(find.text('Kinly Wifi'), findsOneWidget);
      expect(find.byType(QrImageView), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('saving from the wifi dialog dispatches a wifi saved event', (
      tester,
    ) async {
      when(() => bloc.state).thenReturn(_buildState(isOwner: true));
      whenListen(
        bloc,
        const Stream<HouseDirectoryState>.empty(),
        initialState: _buildState(isOwner: true),
      );

      await tester.pumpWidget(_buildHarness(bloc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'New SSID');
      await tester.enterText(textFields.at(1), 'super-secret');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      verify(
        () => bloc.add(
          any(
            that: isA<HouseDirectoryWifiSaved>().having(
              (event) => event.input.ssid,
              'ssid',
              'New SSID',
            ).having(
              (event) => event.input.password,
              'password',
              'super-secret',
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('members can see the wifi qr but cannot edit it', (tester) async {
      when(() => bloc.state).thenReturn(_buildState(isOwner: false));
      whenListen(
        bloc,
        const Stream<HouseDirectoryState>.empty(),
        initialState: _buildState(isOwner: false),
      );

      await tester.pumpWidget(_buildHarness(bloc));
      await tester.pumpAndSettle();

      expect(find.text('Kinly Wifi'), findsOneWidget);
      expect(find.byType(QrImageView), findsOneWidget);
      expect(find.text('Edit'), findsNothing);
      verifyNever(() => bloc.add(any()));
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
      child: const HouseDirectoryScreen(homeId: 'home-1'),
    ),
  );
}

HouseDirectoryState _buildState({required bool isOwner}) {
  final now = DateTime(2026, 3, 14);
  return HouseDirectoryState(
    status: HouseDirectoryStatus.success,
    isOwner: isOwner,
    wifi: HouseDirectoryWifi(
      id: 'wifi-1',
      homeId: 'home-1',
      ssid: 'Kinly Wifi',
      qrPayload: 'WIFI:T:WPA;S:Kinly Wifi;P:test;;',
      createdAt: now,
      updatedAt: now,
    ),
    services: const [],
    notes: const [],
    reminders: const [],
  );
}
