part of 'today_surface.dart';

Future<void> _openShareCreateImpl(BuildContext context) async {
  final result = await context.pushNamed<bool>(AppRouteNames.shareCreate);
  if (!context.mounted) return;
  context.read<TodayBloc>().add(const TodayRefreshed());
  if (result == true) {
    final s = S.of(context);
    final accent =
        KinlyThemeAccess.of(context).extension<KinlySections>()?.share.accent;
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
  final navigator = sl<ShareNavigation>();
  final currentUsername = context.read<TodayBloc>().state.profile?.username;
  final result = await navigator.openOwedDetail(
    context: context,
    owed: owed,
    currentUsername: currentUsername,
  );
  if (result == true && context.mounted) {
    final s = S.of(context);
    final accent =
        KinlyThemeAccess.of(context).extension<KinlySections>()?.share.accent;
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
  final result = await context.pushNamed(
    AppRouteNames.shareDraftEdit,
    pathParameters: {'expenseId': draft.expenseId},
    extra: const ShareEditRouteArgs(allowDelete: true),
  );
  if (!context.mounted) return;
  final s = S.of(context);
  final accent =
      KinlyThemeAccess.of(context).extension<KinlySections>()?.share.accent;
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
  final bloc = context.read<TodayBloc>();
  final navigator = sl<ShareNavigation>();
  await navigator.openPaidToMeDetail(
    context: context,
    entry: entry,
    homeId: bloc.homeId,
  );
  if (context.mounted) {
    context.read<TodayBloc>().add(const TodayRefreshed());
  }
}

Future<void> _openShareCreatedListImpl(BuildContext context) async {
  await context.pushNamed<bool>(AppRouteNames.shareCreatedList, extra: true);
  if (context.mounted) {
    context.read<TodayBloc>().add(const TodayRefreshed());
  }
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

    if (!context.mounted) return false;
    final shareOrigin = sharePositionOriginForContext(context);
    final appLink = _buildInviteLinkImpl(invite);
    final raw = l10n.hubShareInviteBody(invite.code, appLink);
    final message = raw.replaceAll(r'\n', '\n');
    await Share.share(
      message,
      subject: l10n.hubShareInviteTitle,
      sharePositionOrigin: shareOrigin,
    );
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
          : 'go.makinglifeeasie.com';
  final uri = Uri(
    scheme: 'https',
    host: host,
    pathSegments: ['kinly', 'join', invite.code],
  );
  return uri.toString();
}

@visibleForTesting
String buildInviteLinkForTest(HomeInvite invite) => _buildInviteLinkImpl(invite);

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
