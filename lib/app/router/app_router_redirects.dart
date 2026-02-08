part of 'app_router.dart';

String? _redirect({
  required GoRouterState state,
  required AuthBloc authBloc,
  required AppVersionCubit appVersionCubit,
  required Logger logger,
}) {
  final authState = authBloc.state;
  final redirectTarget = _redirectCore(
    path: state.uri.path,
    uri: state.uri,
    authStatus: authState.status,
    membershipStatus: authState.membershipStatus,
    isProfileDeactivated: authState.isProfileDeactivated,
    appVersionStatus: appVersionCubit.state.status,
  );
  if (redirectTarget != null && redirectTarget != state.uri.path) {
    logger.info(
      'Router redirect: from=${state.uri} to=$redirectTarget '
      'auth=${authState.status} membership=${authState.membershipStatus} '
      'deactivated=${authState.isProfileDeactivated} '
      'version=${appVersionCubit.state.status}',
      tag: 'Router',
    );
  }
  return redirectTarget;
}

@visibleForTesting
String? redirectForTest({
  required String path,
  required AuthStatus authStatus,
  required AuthMembershipStatus membershipStatus,
  bool isProfileDeactivated = false,
  required AppVersionStatus appVersionStatus,
}) => _redirectCore(
  path: path,
  uri: Uri.parse(path),
  authStatus: authStatus,
  membershipStatus: membershipStatus,
  isProfileDeactivated: isProfileDeactivated,
  appVersionStatus: appVersionStatus,
);

String? _redirectCore({
  required String path,
  required Uri uri,
  required AuthStatus authStatus,
  required AuthMembershipStatus membershipStatus,
  required bool isProfileDeactivated,
  required AppVersionStatus appVersionStatus,
}) {
  final forceUpdateRedirect = _forceUpdateRedirect(path, appVersionStatus);
  if (forceUpdateRedirect != null) return forceUpdateRedirect;

  final authRedirect = _authRedirect(path: path, uri: uri, status: authStatus);
  if (authStatus != AuthStatus.authenticated) {
    return authRedirect;
  }

  if (isProfileDeactivated) {
    return AppRoutes.welcome;
  }

  return _membershipRedirect(path, membershipStatus);
}

String? _redirectForNoMembership(String path) {
  if (path == AppRoutes.today) return AppRoutes.start;
  if (path == AppRoutes.splash || path == AppRoutes.welcome) {
    return AppRoutes.start;
  }
  return null;
}

String? _redirectForMember(String path) {
  if (path == AppRoutes.splash || path == AppRoutes.welcome) {
    return AppRoutes.today;
  }
  if (path == AppRoutes.start) return AppRoutes.today;
  return null;
}

String? _forceUpdateRedirect(String path, AppVersionStatus status) {
  final forceUpdateRequired = status == AppVersionStatus.hardBlocked;
  if (forceUpdateRequired && path != AppRoutes.forceUpdate) {
    return AppRoutes.forceUpdate;
  }
  if (!forceUpdateRequired && path == AppRoutes.forceUpdate) {
    return AppRoutes.splash;
  }
  return null;
}

String? _authRedirect({
  required String path,
  required Uri uri,
  required AuthStatus status,
}) {
  final isPublicRoute =
      path == AppRoutes.welcome || path == AppRoutes.demoAccess;
  final isAllowedWhenUnknown = isPublicRoute || path == AppRoutes.splash;
  if (_looksLikeInviteIntent(uri)) {
    NavigationIntents.captureInvite(uri);
  }
  if (status == AuthStatus.unknown) {
    return isAllowedWhenUnknown ? null : AppRoutes.splash;
  }
  if (status != AuthStatus.authenticated) {
    return isPublicRoute ? null : AppRoutes.welcome;
  }
  return null;
}

bool _looksLikeInviteIntent(Uri uri) {
  final aliases = {'invite_code', 'inviteCode', 'invite_id', 'code'};
  for (final entry in uri.queryParameters.entries) {
    final key = entry.key.trim();
    if (aliases.contains(key) && entry.value.trim().isNotEmpty) {
      return true;
    }
  }

  final segments =
      uri.pathSegments.map((segment) => segment.trim().toLowerCase()).toList();
  if (segments.isEmpty) return false;
  final joinIndex = segments.indexOf('join');
  return joinIndex >= 0 && joinIndex < segments.length - 1;
}

String? _membershipRedirect(String path, AuthMembershipStatus status) {
  if (status == AuthMembershipStatus.unknown) {
    return path == AppRoutes.splash ? null : AppRoutes.splash;
  }
  if (status != AuthMembershipStatus.active) {
    return _redirectForNoMembership(path);
  }
  return _redirectForMember(path);
}
