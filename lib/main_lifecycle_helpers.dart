part of 'main.dart';

Future<void> _handleAuthStateImpl(_MyAppState self, AuthState state) async {
  self._logger.debug(
    'Handle auth state. status=${state.status} membership=${state.membershipStatus} '
    'userId=${state.userId} homeId=${state.membership?.homeId} '
    'deactivated=${state.isProfileDeactivated} session=${self._appSessionId}',
    tag: _MyAppState._logTag,
  );
  final previousUserId = self._lastAuthUserId;
  final previousHomeId = self._lastHomeId;
  final currentUserId = state.userId;
  final currentHomeId = state.membership?.homeId;
  if (!state.isAuthenticated) {
    if (previousUserId != null) {
      await self._joinIntentCoordinator?.clear();
    }
    await self._clearFormDraftsOnLogout(
      previousUserId: previousUserId,
      previousHomeId: previousHomeId,
    );
    self._lastAuthUserId = null;
    self._lastHomeId = null;
    await syncRevenueCatUser(self._logger, userId: null);
    await self._stopNotificationTokenSync();
    return;
  }

  if (previousUserId != null &&
      currentUserId != null &&
      currentUserId != previousUserId) {
    await FormDraftStorage.clearPersonalPreferencesDraft(previousUserId);
  }
  if (previousHomeId != null && previousHomeId != currentHomeId) {
    await FormDraftStorage.clearHouseRulesDraft(previousHomeId);
    self._logger.info(
      'form_draft_cleared_on_home_change form=house_rules '
      'scope=${FormDraftStorage.hashScope(previousHomeId)} '
      'schemaVersion=${FormDraftStorage.schemaVersionV1}',
      tag: _MyAppState._draftLogTag,
    );
  }
  self._lastAuthUserId = currentUserId;
  self._lastHomeId = currentHomeId;

  await syncRevenueCatUser(self._logger, userId: state.userId);
  await self._refreshNotificationPreferencesFromOs();
  await self._startNotificationTokenSync();

  if (self._joinIntentCoordinator == null) return;
  final joinResult = await self._joinIntentCoordinator!.handleAuthState(
    authStatus: state.status,
    membershipStatus: state.membershipStatus,
    userId: state.userId,
  );
  self._logger.info(
    'Join intent navigation decision: ${joinResult.navigation} '
    'blockedRequestId=${joinResult.blockedRequestId} '
    'session=${self._appSessionId}',
    tag: _MyAppState._logTag,
  );
  await self._applyJoinNavigation(joinResult);
}

Future<void> _applyJoinNavigationImpl(
  _MyAppState self,
  JoinIntentResult result,
) async {
  final currentUri = self._router.routeInformationProvider.value.uri;
  final currentPath = currentUri.path;
  self._logger.info(
    'Applying join navigation: ${result.navigation} '
    'blockedRequestId=${result.blockedRequestId} '
    'currentPath=$currentPath session=${self._appSessionId}',
    tag: _MyAppState._logTag,
  );
  if (!self._shouldApplyJoinNavigation(
    navigation: result.navigation,
    currentPath: currentPath,
  )) {
    self._logger.info(
      'Skipping join navigation ${result.navigation}; preserving currentPath=$currentPath '
      'session=${self._appSessionId}',
      tag: _MyAppState._logTag,
    );
    return;
  }
  switch (result.navigation) {
    case JoinIntentNavigation.none:
      return;
    case JoinIntentNavigation.welcome:
      self._router.goNamed(AppRouteNames.welcome);
      return;
    case JoinIntentNavigation.start:
      self._router.goNamed(AppRouteNames.start);
      return;
    case JoinIntentNavigation.today:
      self._router.goNamed(AppRouteNames.today);
      return;
    case JoinIntentNavigation.blocked:
      self._router.goNamed(AppRouteNames.joinBlocked);
      return;
  }
}

Future<void> _refreshNotificationPreferencesFromOsImpl(_MyAppState self) async {
  if (!self._authBloc.state.isAuthenticated) return;
  if (!sl.isRegistered<NotificationsRepository>() ||
      !sl.isRegistered<NotificationSyncState>()) {
    self._logger.debug(
      'Skipping notification prefs refresh; dependencies not registered',
      tag: _MyAppState._logTag,
    );
    return;
  }

  final notificationsRepo = sl<NotificationsRepository>();
  final syncState = sl<NotificationSyncState>();

  final osPermission = await self._readOsPermission();
  final locale =
      WidgetsBinding.instance.platformDispatcher.locale.toLanguageTag();
  final timezone = await self._timezoneResolver.resolve();
  final platformName = defaultTargetPlatform.name;
  final deviceToken = await _readDeviceTokenForSync(self, osPermission);

  try {
    final prefs = await notificationsRepo.fetchPreferences(
      timezone: timezone,
      locale: locale,
      osPermission: osPermission,
      deviceToken: deviceToken,
      platform: platformName,
    );

    syncState.setPayload(
      NotificationSyncPayload(
        wantsDaily: prefs.wantsDaily,
        preferredHour: prefs.preferredHour,
        preferredMinute: prefs.preferredMinute,
        timezone: timezone,
        locale: locale,
        osPermission:
            prefs.osPermission.isNotEmpty ? prefs.osPermission : osPermission,
        platform: platformName,
      ),
    );
  } catch (error, stackTrace) {
    self._logger.warn(
      'Failed to refresh notification preferences from OS: $error',
      tag: _MyAppState._logTag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

Future<String?> _readDeviceTokenForSync(
  _MyAppState self,
  String osPermission,
) async {
  try {
    final canReadToken = await self._canReadFcmToken(osPermission);
    if (canReadToken) {
      return FirebaseMessaging.instance.getToken();
    }
    self._logger.debug(
      'Skipping FCM token read; APNS token not yet available',
      tag: _MyAppState._logTag,
    );
  } catch (error, stackTrace) {
    if (self._isApnsTokenMissing(error)) {
      self._logger.debug(
        'Skipping FCM token read; APNS token not yet available ($error)',
        tag: _MyAppState._logTag,
      );
    } else {
      self._logger.warn(
        'Failed to read FCM token during prefs refresh: $error',
        tag: _MyAppState._logTag,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
  return null;
}
