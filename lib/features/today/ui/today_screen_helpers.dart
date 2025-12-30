part of 'today_screen.dart';

String _partOfDayImpl(DateTime now) {
  final hour = now.hour;
  if (hour < 12) return 'morning';
  if (hour < 17) return 'afternoon';
  return 'evening';
}

void _onTodayStateChangedImpl(_TodayScreenState state, TodayState newState) {
  if (newState.isLoading) return;

  final previous = state._lastNonLoadingState;
  state._lastNonLoadingState = newState;

  if (!newState.isCaughtUp) {
    state._hasPendingTodayItems = true;
    return;
  }

  final hadItemsBefore =
      state._hasPendingTodayItems ||
      (previous != null && !previous.isCaughtUp) ||
      (previous?.activeChoreCount ?? 0) > 0;
  if (!hadItemsBefore) return;

  state._hasPendingTodayItems = false;
  state._confettiController.play();
}

void _openFlowListImpl(BuildContext context, FlowListFilter filter) {
  final filterParam = filter.toQueryParam();
  context.push('${AppRoutes.flow}?filter=$filterParam&scope=mine').then((_) {
    if (context.mounted) {
      context.read<TodayBloc>().add(const TodayRefreshed());
    }
  });
}

Future<void> _openFlowChoreImpl(BuildContext context, {String? choreId}) async {
  final path =
      choreId == null
          ? AppRoutes.flowChoreCreate
          : AppRoutes.flowChoreEditPath(choreId);
  final result = await context.push(path);
  if (result is FlowChoreOutcome) {
    if (!context.mounted) return;
    final s = S.of(context);
    final accent = Theme.of(context).extension<KinlySections>()?.flow.accent;
    if (result.isUpdate) {
      KinlySnackBar.showSuccess(
        context,
        s.flowChoreUpdateSuccess,
        accentColor: accent,
      );
    } else if (!result.isDeleted && !result.isCompleted) {
      KinlySnackBar.showSuccess(
        context,
        s.flowChoreCreateSuccess,
        accentColor: accent,
      );
    }
    context.read<TodayBloc>().add(const TodayRefreshed());
  }
}

Future<void> _openFlowChoreDetailImpl(
  BuildContext context, {
  required String choreId,
}) async {
  final result = await context.push(AppRoutes.flowChoreDetailPath(choreId));
  if (result is FlowChoreOutcome) {
    if (!context.mounted) return;
    if (result.isCompleted) {
      final s = S.of(context);
      final accent = Theme.of(context).extension<KinlySections>()?.flow.accent;
      KinlySnackBar.showSuccess(
        context,
        s.flowChoreDetailCompletionSuccess,
        accentColor: accent,
      );
    }
    context.read<TodayBloc>().add(const TodayRefreshed());
  }
}

Future<void> _openShareCreateImpl(BuildContext context) async {
  final result = await context.push<bool>(AppRoutes.shareCreate);
  if (!context.mounted) return;
  context.read<TodayBloc>().add(const TodayRefreshed());
  if (result == true) {
    final s = S.of(context);
    final accent = Theme.of(context).extension<KinlySections>()?.share.accent;
    KinlySnackBar.showSuccess(
      context,
      s.shareCreateSuccess,
      accentColor: accent,
    );
  }
}

Future<void> _openShareOwedDetailImpl(
  BuildContext context,
  TodayShareOwed owed,
) async {
  final repository = sl<ExpensesRepository>();
  final result = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder:
          (_) =>
              ShareOwedDetailScreen(owed: owed, expensesRepository: repository),
    ),
  );
  if (result == true && context.mounted) {
    final s = S.of(context);
    final accent = Theme.of(context).extension<KinlySections>()?.share.accent;
    KinlySnackBar.showSuccess(
      context,
      s.shareOwedDetailSuccess,
      accentColor: accent,
    );
    context.read<TodayBloc>().add(const TodayRefreshed());
  }
}

Future<void> _openShareDraftEditImpl(
  BuildContext context,
  TodayShareDraft draft,
) async {
  final result = await context.push(
    AppRoutes.shareDraftEditPath(draft.expenseId),
    extra: const ShareEditRouteArgs(allowDelete: true),
  );
  if (!context.mounted) return;
  final s = S.of(context);
  final accent = Theme.of(context).extension<KinlySections>()?.share.accent;
  if (result == true || result == ShareEditOutcome.updated) {
    KinlySnackBar.showSuccess(context, s.shareEditSuccess, accentColor: accent);
    context.read<TodayBloc>().add(const TodayRefreshed());
  } else if (result == ShareEditOutcome.deleted) {
    KinlySnackBar.showSuccess(
      context,
      s.shareEditDeleteSuccess,
      accentColor: accent,
    );
    context.read<TodayBloc>().add(const TodayRefreshed());
  }
}

Future<void> _openSharePaidToMeDetailImpl(
  BuildContext context,
  TodaySharePaidToMe entry,
) async {
  final repository = sl<ExpensesRepository>();
  final bloc = context.read<TodayBloc>();
  await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder:
          (_) => SharePaidToMeDetailScreen(
            entry: entry,
            homeId: bloc.homeId,
            expensesRepository: repository,
          ),
    ),
  );
  if (context.mounted) {
    context.read<TodayBloc>().add(const TodayRefreshed());
  }
}

Future<void> _openShareCreatedListImpl(BuildContext context) async {
  await context.push<bool>(AppRoutes.shareCreatedList, extra: true);
  if (context.mounted) {
    context.read<TodayBloc>().add(const TodayRefreshed());
  }
}

Future<void> _openGratitudeWallImpl(BuildContext context) async {
  await context.push(AppRoutes.gratitudeWall);
  if (context.mounted) {
    context.read<TodayBloc>().add(const TodayRefreshed());
  }
}

Future<void> _openHarmonyPageImpl(BuildContext context) async {
  await context.push(AppRoutes.harmony);
}

Future<bool> _shareInviteImpl(
  BuildContext context, {
  required bool isFlatmate,
  HomeRepository? repo,
  Logger? logger,
  S? s,
}) async {
  final l10n = s ?? S.of(context);
  final repository = repo ?? sl<HomeRepository>();
  final resolvedLogger =
      logger ??
      (sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger());

  try {
    final membership = await repository.getCurrentMembership();
    if (!context.mounted) return false;
    final homeId = membership?.homeId;
    if (homeId == null) {
      if (!context.mounted) return false;
      KinlySnackBar.showError(context, l10n.hubInviteUnavailable);
      return false;
    }

    HomeInvite? invite;
    try {
      invite = await repository.getActiveInvite(homeId);
    } catch (_) {
      try {
        invite = await repository.getOrCreateInvite(homeId: homeId);
      } catch (_) {
        invite = null;
      }
    }

    if (invite == null) {
      if (!context.mounted) return false;
      KinlySnackBar.showError(context, l10n.hubInviteUnavailable);
      return false;
    }

    final appLink = _buildInviteLinkImpl(invite);
    final raw = l10n.hubShareInviteBody(invite.code, appLink);
    final message = raw.replaceAll(r'\n', '\n');
    await Share.share(message, subject: l10n.hubShareInviteTitle);
    if (!context.mounted) return false;
    return true;
  } catch (error, stack) {
    resolvedLogger.warn(
      'Failed to share invite from Today',
      error: error,
      stackTrace: stack,
      tag: _shareLogTag,
    );
    if (context.mounted) {
      KinlySnackBar.showError(context, l10n.hubInviteUnavailable);
    }
    return false;
  }
}

String _buildInviteLinkImpl(HomeInvite invite) {
  final host =
      AppConfig.inviteHost.isNotEmpty
          ? AppConfig.inviteHost
          : AppConfig.deeplinkHost;
  final uri = Uri(
    scheme: 'https',
    host: host,
    pathSegments: ['kinly', 'join', invite.code],
  );
  return uri.toString();
}

@visibleForTesting
Future<void> debugTriggerNotificationPromptImpl(
  BuildContext context, {
  VoidCallback? onPrompt,
}) => _maybePromptNotificationsImpl(context, onPrompt);

@visibleForTesting
Future<bool> shareInviteForTest(
  BuildContext context, {
  required bool isFlatmate,
  HomeRepository? repo,
  Logger? logger,
  S? s,
}) => _shareInviteImpl(
  context,
  isFlatmate: isFlatmate,
  repo: repo,
  logger: logger,
  s: s,
);

@visibleForTesting
Future<void> maybePromptNotificationsForTest(
  BuildContext context, {
  VoidCallback? onPrompt,
  NotificationPermissionService? permissionService,
  NotificationsRepository? notificationsRepository,
  DeviceTokenProvider? tokenProvider,
  IanaTimezoneResolver? timezoneResolver,
  Logger? logger,
}) => _maybePromptNotificationsImpl(
  context,
  onPrompt,
  permissionService: permissionService,
  notificationsRepository: notificationsRepository,
  tokenProvider: tokenProvider,
  timezoneResolver: timezoneResolver,
  logger: logger,
);

Future<void> _maybePromptNotificationsImpl(
  BuildContext context,
  VoidCallback? onPrompt, {
  NotificationPermissionService? permissionService,
  NotificationsRepository? notificationsRepository,
  DeviceTokenProvider? tokenProvider,
  IanaTimezoneResolver? timezoneResolver,
  Logger? logger,
}) async {
  if (!context.mounted) return;
  onPrompt?.call();
  final repo = notificationsRepository ?? sl<NotificationsRepository>();
  final resolvedPermissionService =
      permissionService ??
      (sl.isRegistered<NotificationPermissionService>()
          ? sl<NotificationPermissionService>()
          : NotificationPermissionService(notificationsRepository: repo));
  final resolvedTokenProvider =
      tokenProvider ??
      (sl.isRegistered<DeviceTokenProvider>()
          ? sl<DeviceTokenProvider>()
          : const FirebaseDeviceTokenProvider());
  final resolvedTimezoneResolver =
      timezoneResolver ?? sl<IanaTimezoneResolver>();
  final locale = Localizations.localeOf(context).toLanguageTag();
  final platformName = Theme.of(context).platform.name;
  final timezone = await resolvedTimezoneResolver.resolve();
  final resolvedLogger =
      logger ??
      (sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger());
  const notifTag = 'TodayNotifications';
  resolvedLogger.debug(
    'Using timezone=$timezone for notifications sync',
    tag: notifTag,
  );
  String? deviceToken;
  try {
    deviceToken = await resolvedTokenProvider.getToken();
  } catch (error, stackTrace) {
    resolvedLogger.warn(
      'Failed to read device token; continuing without it',
      tag: notifTag,
      error: error,
      stackTrace: stackTrace,
    );
  }
  if (!context.mounted) return;
  try {
    await resolvedPermissionService.requestAndSync(
      wantsDaily: true,
      preferredHour: 9,
      preferredMinute: 0,
      timezone: timezone,
      locale: locale,
      deviceToken: deviceToken,
      platform: platformName,
    );
  } on NotificationPermissionException catch (error, stackTrace) {
    resolvedLogger.warn(
      'Notification permission rejected or unavailable',
      tag: notifTag,
      error: error,
      stackTrace: stackTrace,
    );
  } catch (error, stackTrace) {
    resolvedLogger.warn(
      'Failed to request notification permissions',
      tag: notifTag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

extension _TodayScreenStateActions on _TodayScreenState {
  String partOfDayExt(DateTime now) => _partOfDayImpl(now);

  void onTodayStateChangedExt(TodayState state) =>
      _onTodayStateChangedImpl(this, state);

  Future<void> handleFlowTaskTapExt(
    BuildContext context,
    TodayFlowTask task,
  ) async {
    if (task.isActive) {
      await openFlowChoreDetailExt(context, choreId: task.id);
    } else {
      await openFlowChoreExt(context, choreId: task.id);
    }
  }

  Future<void> openFlowChoreDetailExt(
    BuildContext context, {
    required String choreId,
  }) => _openFlowChoreDetailImpl(context, choreId: choreId);

  void openFlowListExt(BuildContext context, FlowListFilter filter) =>
      _openFlowListImpl(context, filter);

  Future<void> openFlowChoreExt(BuildContext context, {String? choreId}) =>
      _openFlowChoreImpl(context, choreId: choreId);

  Future<void> openShareCreateExt(BuildContext context) =>
      _openShareCreateImpl(context);

  Future<void> openShareOwedDetailExt(
    BuildContext context,
    TodayShareOwed owed,
  ) => _openShareOwedDetailImpl(context, owed);

  Future<void> openShareDraftEditExt(
    BuildContext context,
    TodayShareDraft draft,
  ) => _openShareDraftEditImpl(context, draft);

  Future<void> openSharePaidToMeDetailExt(
    BuildContext context,
    TodaySharePaidToMe entry,
  ) => _openSharePaidToMeDetailImpl(context, entry);

  Future<void> openShareCreatedListExt(BuildContext context) =>
      _openShareCreatedListImpl(context);

  Future<void> openGratitudeWallExt(BuildContext context) =>
      _openGratitudeWallImpl(context);

  Future<void> openHarmonyPageExt(BuildContext context) =>
      _openHarmonyPageImpl(context);

  Future<bool> shareInviteExt(
    BuildContext context, {
    required bool isFlatmate,
  }) => _shareInviteImpl(context, isFlatmate: isFlatmate);

  Future<void> debugTriggerNotificationPromptExt() =>
      debugTriggerNotificationPromptImpl(
        context,
        onPrompt: widget.onNotificationPrompt,
      );

  Future<void> maybePromptNotificationsExt(BuildContext context) =>
      _maybePromptNotificationsImpl(context, widget.onNotificationPrompt);
}
