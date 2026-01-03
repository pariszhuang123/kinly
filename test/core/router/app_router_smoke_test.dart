import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_router.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/version_gating/bloc/app_version_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthBloc extends Mock implements AuthBloc {}

class _MockAppVersionCubit extends Mock implements AppVersionCubit {}

void main() {
  group('AppRouter', () {
    test('exposes named routes without instantiating builders', () {
      final authBloc = _MockAuthBloc();
      final appVersionCubit = _MockAppVersionCubit();

      final membership = CurrentMembership(
        userId: 'user-1',
        homeId: 'home-1',
        role: 'owner',
        validFrom: DateTime.now(),
      );
      when(() => authBloc.state).thenReturn(
        AuthState(
          status: AuthStatus.authenticated,
          membershipStatus: AuthMembershipStatus.active,
          membership: membership,
        ),
      );
      when(
        () => appVersionCubit.state,
      ).thenReturn(const AppVersionState(status: AppVersionStatus.upToDate));

      final router = createRouter(
        authBloc: authBloc,
        appVersionCubit: appVersionCubit,
        refreshListenable: ValueNotifier(0),
      );

      expect(router.namedLocation('today'), AppRoutes.today);
      expect(router.namedLocation('hub'), AppRoutes.hub);
      expect(
        router.namedLocation(
          'flowChoreDetail',
          pathParameters: const {'choreId': 'abc'},
        ),
        '/flow/chore/abc/detail',
      );
      expect(
        router.namedLocation(
          'shareDraftEdit',
          pathParameters: const {'expenseId': 'exp1'},
        ),
        '/share/exp1/edit',
      );
    });

    test('registers unique names for every route', () {
      final authBloc = _MockAuthBloc();
      final appVersionCubit = _MockAppVersionCubit();

      final membership = CurrentMembership(
        userId: 'user-1',
        homeId: 'home-1',
        role: 'owner',
        validFrom: DateTime.now(),
      );
      when(() => authBloc.state).thenReturn(
        AuthState(
          status: AuthStatus.authenticated,
          membershipStatus: AuthMembershipStatus.active,
          membership: membership,
        ),
      );
      when(
        () => appVersionCubit.state,
      ).thenReturn(const AppVersionState(status: AppVersionStatus.upToDate));

      final router = createRouter(
        authBloc: authBloc,
        appVersionCubit: appVersionCubit,
        refreshListenable: ValueNotifier(0),
      );

      final names = <String>[];
      final missingNames = <String>[];

      for (final route in router.configuration.routes) {
        _collectRouteNames(route, names, missingNames);
      }

      expect(
        missingNames,
        isEmpty,
        reason: 'Every GoRoute should define a name for goNamed usage.',
      );

      final seen = <String, int>{};
      for (final name in names) {
        seen[name] = (seen[name] ?? 0) + 1;
      }

      final duplicates =
          seen.entries
              .where((entry) => entry.value > 1)
              .map((entry) => entry.key)
              .toList()
            ..sort();

      expect(
        duplicates,
        isEmpty,
        reason: 'Route names must be unique for named navigation.',
      );
    });
  });
}

void _collectRouteNames(
  RouteBase route,
  List<String> names,
  List<String> missingNames,
) {
  if (route is GoRoute) {
    if (route.name == null) {
      missingNames.add(route.path);
    } else {
      names.add(route.name!);
    }
  }

  if (route is ShellRoute) {
    for (final child in route.routes) {
      _collectRouteNames(child, names, missingNames);
    }
  } else if (route is StatefulShellRoute) {
    for (final branch in route.branches) {
      for (final child in branch.routes) {
        _collectRouteNames(child, names, missingNames);
      }
    }
  } else if (route is GoRoute) {
    for (final child in route.routes) {
      _collectRouteNames(child, names, missingNames);
    }
  }
}
