import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/contracts/personal_directory/route_args.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/personal_directory/bloc/personal_directory_bloc.dart';
import 'package:kinly/features/personal_directory/ui/personal_directory_note_screen.dart';
import 'package:kinly/features/personal_directory/ui/personal_directory_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:mocktail/mocktail.dart';

class _MockPersonalDirectoryBloc
    extends MockBloc<PersonalDirectoryEvent, PersonalDirectoryState>
    implements PersonalDirectoryBloc {}

class _MockPersonalDirectoryRepository extends Mock
    implements PersonalDirectoryRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const PersonalDirectoryStarted());
  });

  group('PersonalDirectoryScreen', () {
    late _MockPersonalDirectoryBloc bloc;
    late _MockPersonalDirectoryRepository repository;

    setUp(() {
      bloc = _MockPersonalDirectoryBloc();
      repository = _MockPersonalDirectoryRepository();
    });

    testWidgets(
      'create flow hides emergency contact type when one already exists',
      (tester) async {
        final state = _buildState(notes: [
          _note(
            id: 'emergency-1',
            type: PersonalDirectoryNoteType.emergencyContact,
            contactName: 'Alex',
            phoneNumber: '+64 21 111 2222',
          ),
        ]);
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<PersonalDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<PersonalDirectoryBloc>.value(
                    value: bloc,
                    child: const PersonalDirectoryScreen(),
                  ),
            ),
            GoRoute(
              path: '/note',
              name: AppRouteNames.personalDirectoryNote,
              builder: (_, routeState) {
                final args =
                    routeState.extra as PersonalDirectoryNoteRouteArgs;
                return PersonalDirectoryNoteScreen(
                  repository: repository,
                  canEdit: args.canEdit,
                  note: args.note,
                  availableNoteTypes: args.availableNoteTypes,
                );
              },
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Add note'));
        await tester.pumpAndSettle();

        expect(find.text('Emergency contact'), findsNothing);
        expect(find.text('Allergy'), findsOneWidget);
        expect(find.text('Other'), findsOneWidget);
      },
    );
  });
}

Widget _buildRouterHarness(GoRouter router) {
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

PersonalDirectoryState _buildState({
  required List<PersonalDirectoryNote> notes,
}) {
  return PersonalDirectoryState(
    status: PersonalDirectoryStatus.success,
    target: const PersonalDirectoryMemberSummary(
      userId: 'user-1',
      username: 'Alex',
      isHomeOwner: false,
    ),
    currentUserId: 'user-1',
    notes: notes,
  );
}

PersonalDirectoryNote _note({
  required String id,
  required PersonalDirectoryNoteType type,
  String? label,
  String? customTitle,
  String? contactName,
  String? phoneNumber,
  String? details,
}) {
  final timestamp = DateTime(2026, 3, 18);
  return PersonalDirectoryNote(
    id: id,
    noteType: type,
    label: label,
    customTitle: customTitle,
    contactName: contactName,
    phoneNumber: phoneNumber,
    details: details,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}
