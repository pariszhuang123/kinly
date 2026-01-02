import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
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
  });
}
