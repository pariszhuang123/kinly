part of 'today_surface.dart';

Widget _buildTodayContentImpl(
  _TodayScreenState stateful,
  BuildContext context,
  TodayState state,
  Spacing spacing,
  S s,
  Logger logger,
) {
  if (state.isLoading) {
    return const Center(child: KinlyLoader());
  }

  final hasFlow = state.hasFlowContent;
  final hasHouseDirectoryReminders = state.hasHouseDirectoryReminders;
  final hasShare = state.hasShareContent;
  final hasGratitude = state.hasGratitudeUnread;
  final hasHousePulse = state.hasHousePulseCard;
  final hasInvitePrompt =
      state.shouldPromptFlatmateInviteShare || state.shouldPromptInviteShare;
  final hasBankAccountPrompt = state.shouldPromptBankAccount;
  final hasShopping = stateful._shoppingCount > 0;
  final hasMemberCapPrompt =
      (state.memberCapJoinRequests?.pendingCount ?? 0) > 0 &&
      state.profile?.isOwner == true;
  final hasPreferencePrompt = state.shouldPromptPreferences;
  final hasHouseNormsPrompt = state.shouldPromptHouseNorms;

  if (!hasFlow &&
      !hasHouseDirectoryReminders &&
      !hasShare &&
      !hasGratitude &&
      !hasHousePulse &&
      !hasInvitePrompt &&
      !hasBankAccountPrompt &&
      !hasShopping &&
      !hasMemberCapPrompt &&
      !hasPreferencePrompt &&
      !hasHouseNormsPrompt) {
    return const TodayEmptyStateCard();
  }

  final inviteConfig = _inviteConfigImpl(state);
  final actions = TodaySurfaceActions(
    onMemberCapPrimary: () {
      final homeId = context.read<TodayBloc>().homeId;
      return stateful._openMemberCapPaywall(context, homeId: homeId);
    },
    onMemberCapSecondary:
        () => context.read<TodayBloc>().add(const TodayMemberCapDismissed()),
    onPreferencePrompt: () => context.pushNamed(AppRouteNames.preferenceOnboarding),
    onHouseNormsPrompt: () {
      final isOwner = state.profile?.isOwner == true;
      final routeName =
          isOwner
              ? AppRouteNames.houseNormsOnboarding
              : AppRouteNames.houseNormsReport;
      final extra =
          isOwner
              ? null
              : const <String, Object?>{
                'showConfetti': false,
                'backRouteName': AppRouteNames.today,
              };
      context.pushNamed(routeName, extra: extra).then((_) {
        if (!context.mounted) return;
        context.read<TodayBloc>().add(const TodayRefreshed());
      });
    },
    onInvitePrimary: (config) async {
      final shared = await stateful._shareInvite(
        context,
        isFlatmate: config.isFlatmate,
      );
      if (!context.mounted || !shared) return;
      context.read<TodayBloc>().add(config.logEvent);
    },
    onInviteSecondary:
        () => context.read<TodayBloc>().add(const TodayFlatmateInviteDismissed()),
    onFlowTaskTap: (task) => stateful._handleFlowTaskTap(context, task),
    onFlowSeeAllTap: (filter) => stateful._openFlowList(context, filter),
    onShareOwedTap: (owed) {
      logger.info('Tapped owed entry: ${owed.displayName}', tag: _shareLogTag);
      stateful._openShareOwedDetail(context, owed);
    },
    onSharePaidToMeTap: (entry) {
      logger.info(
        'Tapped paid-to-me entry: ${entry.debtorUsername}',
        tag: _shareLogTag,
      );
      stateful._openSharePaidToMeDetail(context, entry);
    },
    onShareDraftTap: (draft) {
      logger.info('Tapped draft share: ${draft.expenseId}', tag: _shareLogTag);
      stateful._openShareDraftEdit(context, draft);
    },
    onShareSeeAllDraftsTap: () {
      logger.info('Tapped see all share drafts', tag: _shareLogTag);
      stateful._openShareCreatedList(context);
    },
    onGratitudeTap: () => stateful._openGratitudeWall(context),
    onPersonalGratitudeTap:
        () => stateful._openGratitudeWall(context, openPersonal: true),
    onHousePulseTap: () => _openHousePulseDetail(context),
    onHouseDirectoryTap:
        () => context.pushNamed(AppRouteNames.houseDirectory),
    onHouseDirectoryReminderAcknowledge:
        (reminder) => context.read<TodayBloc>().add(
          TodayHouseDirectoryReminderAcknowledged(reminder.id),
        ),
    onHouseDirectoryReminderDismiss:
        (reminder) => context.read<TodayBloc>().add(
          TodayHouseDirectoryReminderDismissed(reminder.id),
        ),
    onShoppingTap: () => stateful._openShoppingList(context),
    onBankAccountPrompt: () {
      stateful._openPersonalDirectoryBank(context);
    },
  );

  final scope = TodaySurfaceScope(
    context: context,
    state: state,
    spacing: spacing,
    sections: KinlyThemeAccess.of(context).extension<KinlySections>()!,
    strings: s,
    actions: actions,
    inviteConfig: inviteConfig,
    formatMemberCapNames: stateful._formatMemberCapNames,
    shoppingCount: stateful._shoppingCount,
  );
  final body = _buildTodayBodyImpl(scope);
  return TodaySurfaceSlots(body: body).body;
}

Widget _buildTodayBodyImpl(TodaySurfaceScope scope) {
  final spacing = scope.spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: _buildTodaySectionsImpl(scope, spacing),
  );
}

List<Widget> _buildTodaySectionsImpl(TodaySurfaceScope scope, Spacing spacing) {
  final entries = TodayRegistry.bodySections;
  final children = <Widget>[SizedBox(height: spacing.lg)];

  for (final entry in entries) {
    if (entry.isVisible != null && !entry.isVisible!(scope)) {
      continue;
    }
    children.add(entry.builder(scope));
    final gap = _resolveSectionSpacingImpl(entry.spacingAfter, spacing);
    if (gap > 0) {
      children.add(SizedBox(height: gap));
    }
  }

  return children;
}

double _resolveSectionSpacingImpl(TodaySectionSpacing spacing, Spacing tokens) {
  switch (spacing) {
    case TodaySectionSpacing.none:
      return 0;
    case TodaySectionSpacing.sm:
      return tokens.sm;
    case TodaySectionSpacing.md:
      return tokens.md;
    case TodaySectionSpacing.lg:
      return tokens.lg;
    case TodaySectionSpacing.xl:
      return tokens.xl;
  }
}

TodayInviteConfig _inviteConfigImpl(TodayState state) {
  final isFlatmate = state.shouldPromptFlatmateInviteShare;
  final shouldShowGeneric = !isFlatmate && state.shouldPromptInviteShare;
  return TodayInviteConfig(
    showPrompt: isFlatmate || shouldShowGeneric,
    isFlatmate: isFlatmate,
    logEvent:
        isFlatmate
            ? const TodayFlatmateInviteShareLogged(channel: 'system_share')
            : const TodayInviteShareLogged(channel: 'system_share'),
  );
}

Future<void> _refreshShoppingCountImpl(_TodayScreenState stateful) async {
  try {
    final homeId = stateful.context.read<TodayBloc>().homeId;
    final snapshot = await sl<ShoppingListRepository>().getForHome(homeId: homeId);
    stateful._setShoppingCount(snapshot.itemsUnarchivedCount);
  } catch (_) {
    stateful._setShoppingCount(0);
  }
}
