part of 'app_router.dart';

String? _redirect({
  required GoRouterState state,
  required AuthBloc authBloc,
  required AppVersionCubit appVersionCubit,
}) {
  final authState = authBloc.state;
  return _redirectCore(
    path: state.uri.path,
    uri: state.uri,
    authStatus: authState.status,
    membershipStatus: authState.membershipStatus,
    isProfileDeactivated: authState.isProfileDeactivated,
    appVersionStatus: appVersionCubit.state.status,
  );
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

void _captureJoinCodeIfPresent(Uri uri) {
  final segments = uri.pathSegments;
  final isJoin = segments.isNotEmpty && segments.first == 'join';
  final hasCode = segments.length >= 2;
  if (isJoin && hasCode) {
    NavigationIntents.setPendingJoinCode(segments[1]);
  }
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
  if (status == AuthStatus.unknown) {
    return path == AppRoutes.splash ? null : AppRoutes.splash;
  }
  if (status != AuthStatus.authenticated) {
    _captureJoinCodeIfPresent(uri);
    return path == AppRoutes.welcome ? null : AppRoutes.welcome;
  }
  return null;
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
