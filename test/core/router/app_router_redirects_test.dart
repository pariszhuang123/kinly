import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/app/router/app_router.dart';
import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/version_gating/bloc/app_version_cubit.dart';

void main() {
  group('redirectForTest', () {
    setUp(resetPendingProtectedLocationForTest);

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

    test(
      'authenticated with unknown membership redirects protected routes to splash',
      () {
        expect(
          redirectForTest(
            path: AppRoutes.flowChoreCreate,
            authStatus: AuthStatus.authenticated,
            membershipStatus: AuthMembershipStatus.unknown,
            appVersionStatus: AppVersionStatus.upToDate,
          ),
          AppRoutes.splash,
        );
      },
    );

    test(
      'replays pending protected route after membership becomes active',
      () {
        expect(
          redirectForTest(
            path: AppRoutes.flowChoreCreate,
            authStatus: AuthStatus.authenticated,
            membershipStatus: AuthMembershipStatus.unknown,
            appVersionStatus: AppVersionStatus.upToDate,
          ),
          AppRoutes.splash,
        );
        expect(
          redirectForTest(
            path: AppRoutes.splash,
            authStatus: AuthStatus.authenticated,
            membershipStatus: AuthMembershipStatus.active,
            appVersionStatus: AppVersionStatus.upToDate,
          ),
          AppRoutes.flowChoreCreate,
        );
      },
    );

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

    test('force update route stays reachable while auth is unknown', () {
      expect(
        redirectForTest(
          path: AppRoutes.splash,
          authStatus: AuthStatus.unknown,
          membershipStatus: AuthMembershipStatus.unknown,
          appVersionStatus: AppVersionStatus.hardBlocked,
        ),
        AppRoutes.forceUpdate,
      );
      expect(
        redirectForTest(
          path: AppRoutes.forceUpdate,
          authStatus: AuthStatus.unknown,
          membershipStatus: AuthMembershipStatus.unknown,
          appVersionStatus: AppVersionStatus.hardBlocked,
        ),
        isNull,
      );
    });

    test('force update route stays reachable when unauthenticated', () {
      expect(
        redirectForTest(
          path: AppRoutes.forceUpdate,
          authStatus: AuthStatus.unauthenticated,
          membershipStatus: AuthMembershipStatus.none,
          appVersionStatus: AppVersionStatus.hardBlocked,
        ),
        isNull,
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
      expect(
        redirectForTest(
          path: AppRoutes.shareCreate,
          authStatus: AuthStatus.authenticated,
          membershipStatus: AuthMembershipStatus.none,
          appVersionStatus: AppVersionStatus.upToDate,
        ),
        AppRoutes.start,
      );
    });

    test('authenticated without active membership can access fit check routes', () {
      expect(
        redirectForTest(
          path: '/fit-check/draft-1',
          authStatus: AuthStatus.authenticated,
          membershipStatus: AuthMembershipStatus.none,
          appVersionStatus: AppVersionStatus.upToDate,
        ),
        isNull,
      );
      expect(
        redirectForTest(
          path: '/fit-check/draft-1/submission/submission-1',
          authStatus: AuthStatus.authenticated,
          membershipStatus: AuthMembershipStatus.none,
          appVersionStatus: AppVersionStatus.upToDate,
        ),
        isNull,
      );
    });

    test(
      'authenticated with active membership redirects to today for welcome/start',
      () {
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
      },
    );
  });
}
