import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_route_args.dart';
import 'package:kinly/features/house_directory/ui/house_directory_screen.dart';
import 'package:kinly/features/house_directory/ui/house_directory_wifi_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/kinly_icons.dart';
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

    testWidgets('shows qr code for saved wifi and opens the wifi page for owners', (
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
      final context = tester.element(find.byType(HouseDirectoryScreen));
      final strings = S.of(context);

      expect(find.text(strings.houseDirectoryWifiTitle), findsOneWidget);
      expect(find.byType(QrImageView), findsOneWidget);
      expect(find.text(strings.houseDirectoryEdit), findsOneWidget);

      await tester.tap(find.text(strings.houseDirectoryEdit));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(HouseDirectoryWifiScreen), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('saving from the wifi page dispatches a wifi saved event', (
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
      final context = tester.element(find.byType(HouseDirectoryScreen));
      final strings = S.of(context);

      await tester.tap(find.text(strings.houseDirectoryEdit));
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
      final context = tester.element(find.byType(HouseDirectoryScreen));
      final strings = S.of(context);

      expect(find.text(strings.houseDirectoryWifiTitle), findsOneWidget);
      expect(find.byType(QrImageView), findsOneWidget);
      expect(find.text(strings.houseDirectoryEdit), findsNothing);
      verifyNever(() => bloc.add(any()));
    });

    testWidgets('owners see manage copy on the shared details card', (
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
      final context = tester.element(find.byType(HouseDirectoryScreen));
      final strings = S.of(context);

      expect(find.text(strings.houseDirectoryOwnerSubtitle), findsOneWidget);
      expect(find.byIcon(KinlyIcons.chevronRightRounded), findsOneWidget);
    });

    testWidgets('members see view copy and chevrons for details and member rows', (
      tester,
    ) async {
      final state = _buildState(
        isOwner: false,
        services: [
          HouseDirectoryService(
            id: 'service-1',
            homeId: 'home-1',
            serviceType: HouseDirectoryServiceType.electricity,
            providerName: 'Power Co',
            createdAt: DateTime(2026, 3, 14),
            updatedAt: DateTime(2026, 3, 14),
          ),
        ],
        members: const [
          HouseDirectoryMemberCard(
            userId: 'user-2',
            username: 'Alex',
            isOwner: false,
            hasPersonalDirectoryContent: true,
          ),
        ],
      );
      when(() => bloc.state).thenReturn(state);
      whenListen(
        bloc,
        const Stream<HouseDirectoryState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildHarness(bloc));
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(HouseDirectoryScreen));
      final strings = S.of(context);

      expect(find.text(strings.houseDirectoryMemberSubtitle), findsOneWidget);
      expect(find.text('Alex'), findsOneWidget);
      expect(find.byIcon(KinlyIcons.chevronRightRounded), findsNWidgets(2));
    });
  });
}

Widget _buildHarness(HouseDirectoryBloc bloc) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder:
            (_, __) => BlocProvider<HouseDirectoryBloc>.value(
              value: bloc,
              child: const HouseDirectoryScreen(homeId: 'home-1'),
            ),
        routes: [
          GoRoute(
            path: 'wifi',
            name: AppRouteNames.houseDirectoryWifi,
            builder: (_, state) {
              final args = state.extra as HouseDirectoryWifiRouteArgs?;
              return HouseDirectoryWifiScreen(
                homeId: 'home-1',
                wifi: args?.wifi,
              );
            },
          ),
        ],
      ),
    ],
  );
  return MaterialApp.router(
    theme: buildKinlyTheme(Brightness.light),
    routerConfig: router,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
  );
}

HouseDirectoryState _buildState({
  required bool isOwner,
  List<HouseDirectoryService> services = const [],
  List<HouseDirectoryMemberCard> members = const [],
}) {
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
    services: services,
    notes: const [],
    tutorials: const [],
    members: members,
    reminders: const [],
  );
}
