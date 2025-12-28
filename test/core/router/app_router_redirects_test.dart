import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/router/app_router.dart';
import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/version_gating/bloc/app_version_cubit.dart';

void main() {
  group('redirectForTest', () {
    test('auth unknown redirects to splash for non-splash paths', () {
      expect(
        redirectForTest(
          path: '/today',
          authStatus: AuthStatus.unknown,
          membershipStatus: AuthMembershipStatus.unknown,
          appVersionStatus: AppVersionStatus.upToDate,
        ),
        AppRoutes.splash,
      );
      expect(
        redirectForTest(
          path: AppRoutes.splash,
          authStatus: AuthStatus.unknown,
          membershipStatus: AuthMembershipStatus.unknown,
          appVersionStatus: AppVersionStatus.upToDate,
        ),
        isNull,
      );
    });

    test('unauthenticated redirects to welcome except on welcome', () {
      expect(
        redirectForTest(
          path: '/today',
          authStatus: AuthStatus.unauthenticated,
          membershipStatus: AuthMembershipStatus.none,
          appVersionStatus: AppVersionStatus.upToDate,
        ),
        AppRoutes.welcome,
      );
      expect(
        redirectForTest(
          path: AppRoutes.welcome,
          authStatus: AuthStatus.unauthenticated,
          membershipStatus: AuthMembershipStatus.none,
          appVersionStatus: AppVersionStatus.upToDate,
        ),
        isNull,
      );
    });

    test('force update overrides all other redirects', () {
      expect(
        redirectForTest(
          path: AppRoutes.today,
          authStatus: AuthStatus.authenticated,
          membershipStatus: AuthMembershipStatus.active,
          appVersionStatus: AppVersionStatus.hardBlocked,
        ),
        AppRoutes.forceUpdate,
      );
      expect(
        redirectForTest(
          path: AppRoutes.forceUpdate,
          authStatus: AuthStatus.authenticated,
          membershipStatus: AuthMembershipStatus.active,
          appVersionStatus: AppVersionStatus.upToDate,
        ),
        AppRoutes.splash,
      );
    });

    test('authenticated without active membership redirects to start', () {
      expect(
        redirectForTest(
          path: AppRoutes.today,
          authStatus: AuthStatus.authenticated,
          membershipStatus: AuthMembershipStatus.none,
          appVersionStatus: AppVersionStatus.upToDate,
        ),
        AppRoutes.start,
      );
    });

    test('authenticated with active membership redirects to today for welcome/start', () {
      expect(
        redirectForTest(
          path: AppRoutes.welcome,
          authStatus: AuthStatus.authenticated,
          membershipStatus: AuthMembershipStatus.active,
          appVersionStatus: AppVersionStatus.upToDate,
        ),
        AppRoutes.today,
      );
      expect(
        redirectForTest(
          path: AppRoutes.start,
          authStatus: AuthStatus.authenticated,
          membershipStatus: AuthMembershipStatus.active,
          appVersionStatus: AppVersionStatus.upToDate,
        ),
        AppRoutes.today,
      );
      expect(
        redirectForTest(
          path: AppRoutes.today,
          authStatus: AuthStatus.authenticated,
          membershipStatus: AuthMembershipStatus.active,
          appVersionStatus: AppVersionStatus.upToDate,
        ),
        isNull,
      );
    });
  });
}
