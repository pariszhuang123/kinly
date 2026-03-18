part of 'today_surface.dart';

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

  _maybeShowMemberCapResolutionSnackBar(state, newState, previous);

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

void _maybeShowMemberCapResolutionSnackBar(
  _TodayScreenState state,
  TodayState newState,
  TodayState? previous,
) {
  final resolution = newState.memberCapJoinResolution;
  if (resolution == null) return;
  if (!state.mounted) return;

  final previousId = previous?.memberCapJoinResolution?.requestId;
  if (resolution.requestId.isEmpty || resolution.requestId == previousId) {
    return;
  }

  final s = S.of(state.context);
  final name =
      resolution.joinerName.isEmpty
          ? s.todayMemberCapResolutionUnknownName
          : resolution.joinerName;

  switch (resolution.resolvedReason) {
    case 'joined':
      KinlySnackBar.showSuccess(
        state.context,
        s.todayMemberCapResolutionJoined(name),
      );
      return;
    case 'joiner_superseded':
      KinlySnackBar.showError(
        state.context,
        s.todayMemberCapResolutionSuperseded(name),
      );
      return;
    case 'home_inactive':
    case 'invite_missing':
      KinlySnackBar.showError(
        state.context,
        s.todayMemberCapResolutionFailed(name),
      );
      return;
    default:
      return;
  }
}

String _formatMemberCapNamesImpl(List<String> names) {
  if (names.isEmpty) return '';
  if (names.length <= 3) {
    return names.join(', ');
  }
  final visible = names.take(3).join(', ');
  final remaining = names.length - 3;
  return '$visible +$remaining more';
}

Future<void> _openGratitudeWallImpl(
  BuildContext context, {
  bool openPersonal = false,
}) async {
  await context.pushNamed(
    AppRouteNames.gratitudeWall,
    queryParameters: openPersonal ? {'tab': 'personal'} : const {},
  );
  if (context.mounted) {
    context.read<TodayBloc>().add(const TodayRefreshed());
  }
}

Future<void> _openHarmonyPageImpl(BuildContext context) async {
  await context.pushNamed(AppRouteNames.harmony);
}

Future<void> _openMemberCapPaywallImpl(
  BuildContext context, {
  required String homeId,
}) async {
  final s = S.of(context);
  final launcher = sl<PaywallLauncher>();
  final result = await launcher.showPaywall(
    context: context,
    homeId: homeId,
    source: PaywallSources.membersCap,
    triggers: const {PaywallTrigger.membersCap},
    strings: PaywallStrings(
      title: s.paywallTitle,
      subtitle: s.paywallSubtitle,
      bulletMembers: s.paywallBulletMembers,
      bulletFlows: s.paywallBulletFlows,
      bulletPhotos: s.paywallBulletPhotos,
      bulletExpensePhotos: s.paywallFeatureUnlimitedSharedExpensePhotos,
      bulletShoppingPhotos: s.paywallBulletShoppingPhotos,
      bulletShares: s.paywallBulletShares,
      unlimitedLabel: s.paywallSubtitle,
      priceCaption: s.paywallPriceCaption,
      priceUnavailableLabel: s.paywallPriceUnavailable,
      priceFormatter: (price) => s.paywallPricePerMonth(price),
      primaryCta: s.paywallPrimaryCta,
      secondaryCta: s.paywallSecondaryCta,
      purchaseFailed: s.paywallPurchaseFailed,
      purchaseSuccess: s.paywallPurchaseSuccess,
      restoreCta: s.paywallRestoreCta,
      errorTitle: s.paywallErrorTitle,
      retryLabel: s.paywallRetryLabel,
    ),
  );
  if (result == true && context.mounted) {
    context.read<TodayBloc>().add(const TodayRefreshed());
  }
}

Future<void> _openPersonalDirectoryBankImpl(BuildContext context) async {
  final state = context.read<TodayBloc>().state;
  final profile = state.profile;
  if (profile == null) return;
  final result = await context.pushNamed<bool>(
    AppRouteNames.personalDirectoryBank,
    extra: const PersonalDirectoryBankRouteArgs(canEdit: true),
  );
  if (result == true && context.mounted) {
    context.read<TodayBloc>().add(const TodayRefreshed());
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

  Future<void> openPersonalDirectoryBankExt(BuildContext context) =>
      _openPersonalDirectoryBankImpl(context);

Future<void> openGratitudeWallExt(
  BuildContext context, {
  bool openPersonal = false,
}) =>
    _openGratitudeWallImpl(context, openPersonal: openPersonal);

  Future<void> openHarmonyPageExt(BuildContext context) =>
      _openHarmonyPageImpl(context);

  String formatMemberCapNamesExt(List<String> names) =>
      _formatMemberCapNamesImpl(names);

  Future<void> openMemberCapPaywallExt(
    BuildContext context, {
    required String homeId,
  }) => _openMemberCapPaywallImpl(context, homeId: homeId);

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
