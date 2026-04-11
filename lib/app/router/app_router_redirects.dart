part of 'app_router.dart';

String? _pendingProtectedLocation;

const _activeMembershipPrefixes = <String>[
  AppRoutes.today,
  AppRoutes.hub,
  AppRoutes.explore,
  AppRoutes.flow,
  '/share',
  AppRoutes.profileSharedUnitHub,
  AppRoutes.nps,
  AppRoutes.harmony,
  AppRoutes.gratitudeWall,
  AppRoutes.houseNormsOnboarding,
  AppRoutes.houseNormsReport,
  AppRoutes.houseNormsEdit,
];

const _activeMembershipExactPaths = <String>{
  AppRoutes.profileSettings,
  AppRoutes.profileIdentity,
  AppRoutes.connectionSettings,
};

@visibleForTesting
void resetPendingProtectedLocationForTest() {
  _pendingProtectedLocation = null;
}

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
    _clearPendingProtectedLocation();
    return authRedirect;
  }

  if (isProfileDeactivated) {
    _clearPendingProtectedLocation();
    return AppRoutes.welcome;
  }

  return _membershipRedirect(path: path, uri: uri, status: membershipStatus);
}

String? _redirectForNoMembership(String path) {
  if (_requiresActiveMembershipPath(path)) return AppRoutes.start;
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
  final isForceUpdateRoute = path == AppRoutes.forceUpdate;
  final isPublicRoute =
      path == AppRoutes.welcome ||
      path == AppRoutes.demoAccess ||
      isForceUpdateRoute;
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

String? _membershipRedirect({
  required String path,
  required Uri uri,
  required AuthMembershipStatus status,
}) {
  if (status == AuthMembershipStatus.unknown) {
    if (_requiresActiveMembershipPath(path)) {
      _pendingProtectedLocation ??= uri.toString();
      return path == AppRoutes.splash ? null : AppRoutes.splash;
    }
    return null;
  }
  if (status != AuthMembershipStatus.active) {
    _clearPendingProtectedLocation();
    return _redirectForNoMembership(path);
  }
  if (path == AppRoutes.splash) {
    final pendingReplay = _consumePendingProtectedLocation(path: path);
    if (pendingReplay != null) {
      return pendingReplay;
    }
  } else {
    _clearPendingProtectedLocation();
  }
  return _redirectForMember(path);
}

void _clearPendingProtectedLocation() {
  _pendingProtectedLocation = null;
}

String? _consumePendingProtectedLocation({required String path}) {
  if (path != AppRoutes.splash) return null;
  final pending = _pendingProtectedLocation;
  _pendingProtectedLocation = null;
  if (pending == null || pending.isEmpty) return null;
  return pending;
}

bool _requiresActiveMembershipPath(String path) {
  if (_activeMembershipExactPaths.contains(path)) return true;
  return _activeMembershipPrefixes.any(
    (basePath) => _matchesPathOrChild(path, basePath),
  );
}

bool _matchesPathOrChild(String path, String basePath) {
  return path == basePath || path.startsWith('$basePath/');
}
