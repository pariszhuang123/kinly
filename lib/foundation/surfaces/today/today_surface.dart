// lib/foundation/surfaces/today/today_surface.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:confetti/confetti.dart';

import '../../../core/di/locator.dart';
import '../../../core/logging/debug_logger.dart';
import '../../../core/logging/logger.dart';
import '../../../core/notifications/device_token_provider.dart';
import '../../../core/notifications/notification_permission_service.dart';
import '../../../app/router/app_route_names.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/time/iana_timezone_resolver.dart';
import '../../../core/ui/buttons/kinly_fab.dart';
import '../../../core/ui/home_bottom_nav.dart';
import '../../../core/ui/kinly_confetti_overlay.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../contracts/homes/ports/home_repository.dart';
import 'package:kinly/core/ui/paywall/paywall_strings.dart';
import 'package:kinly/core/ui/paywall/ports/paywall_launcher.dart';
import '../../../core/ui/navigation/share_navigation.dart';
import '../../../core/notifications/notifications.dart';
import '../../../generated/l10n.dart';
import '../../../core/config/app_config.dart';
import '../../../contracts/homes/models.dart';
import 'package:kinly/contracts/flow/flow_chore_outcome.dart';
import 'package:kinly/contracts/flow/enums/flow_list_filter.dart';
import 'bloc/today_bloc.dart';
import 'domain/models.dart';
import 'today_slots.dart';
import 'today_registry.dart';
import 'widgets/today_add_sheet.dart';
import 'widgets/today_empty_state_card.dart';
import 'widgets/today_header/today_header_container.dart';
import '../../../contracts/share/share_edit_outcome.dart';
import '../../../contracts/share/share_edit_route_args.dart';
import 'package:kinly/core/ui/paywall/paywall_sources.dart';
import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_theme_access.dart';
import '../../../core/ui/kinly_fab_location.dart';

part 'today_surface_helpers.dart';
part 'today_surface_flow_helpers.dart';
part 'today_surface_share_helpers.dart';
part 'today_surface_notifications_helpers.dart';

const _shareLogTag = 'TodayShare';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key, this.onNotificationPrompt});

  final VoidCallback? onNotificationPrompt;

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen>
    with SingleTickerProviderStateMixin {
  late final ConfettiController _confettiController;
  TodayState? _lastNonLoadingState;
  bool _hasPendingTodayItems = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _partOfDay(DateTime now) => partOfDayExt(now);

  @override
  Widget build(BuildContext context) {
    TodayRegistry.bootstrap();
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final sizes = theme.extension<AppSizes>();
    final sections = theme.extension<KinlySections>()!;
    final s = S.of(context);
    final logger =
        sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger();

    final now = DateTime.now();
    final partOfDay = _partOfDay(now);

    return MultiBlocListener(
      listeners: [
        BlocListener<TodayBloc, TodayState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) => _onTodayStateChanged(state),
        ),
        BlocListener<TodayBloc, TodayState>(
          listenWhen:
              (prev, curr) =>
                  prev.notificationPromptTick != curr.notificationPromptTick &&
                  curr.notificationPromptTick > 0,
          listener: (context, state) => _maybePromptNotifications(context),
        ),
        BlocListener<TodayBloc, TodayState>(
          listenWhen:
              (prev, curr) =>
                  prev.harmonyPromptTick != curr.harmonyPromptTick &&
                  curr.harmonyPromptTick > 0,
          listener: (context, state) async {
            await _openHarmonyPage(context);
            if (context.mounted) {
              context.read<TodayBloc>().add(const TodayRefreshed());
            }
          },
        ),
        BlocListener<TodayBloc, TodayState>(
          listenWhen:
              (prev, curr) =>
                  prev.npsPromptTick != curr.npsPromptTick &&
                  curr.npsPromptTick > 0,
          listener: (context, state) async {
            await context.pushNamed(AppRouteNames.nps);
            if (context.mounted) {
              context.read<TodayBloc>().add(const TodayRefreshed());
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        child: KinlyScaffold(
          backgroundColor: colorScheme.surface,
          body: Stack(
            children: [
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxWidth = sizes?.maxContentWidth ?? 640.0;

                    return Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              constraints.maxWidth < maxWidth
                                  ? constraints.maxWidth
                                  : maxWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                spacing.lg,
                                spacing.lg,
                                spacing.lg,
                                0,
                              ),
                              child: TodayHeaderContainer(partOfDay: partOfDay),
                            ),
                            SizedBox(height: spacing.xl),
                            Expanded(
                              child: KinlyScrollFade(
                                child: SingleChildScrollView(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    spacing.lg,
                                    spacing.lg,
                                    spacing.lg,
                                    spacing.xl * 2, // bottom spacing for FAB
                                  ),
                                  child: BlocBuilder<TodayBloc, TodayState>(
                                    builder: (context, state) {
                                      return _buildTodayContent(
                                        context,
                                        state,
                                        spacing,
                                        s,
                                        logger,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: KinlyConfettiOverlay(
                  confettiController: _confettiController,
                  colors: [
                    sections.flow.accent,
                    sections.share.accent,
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: KinlyFab(
            onPressed: () async {
              await TodayAddSheet.show(
                context,
                sections,
                onAddFlow: () => _openFlowChore(context),
                onAddShare: () => _openShareCreate(context),
              );
            },
            heroTag: 'today_fab',
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: HomeBottomNav(
            currentIndex: 0,
            onTap: (index) {
              switch (index) {
                case 0:
                  break;
                case 1:
                  context.goNamed(AppRouteNames.explore);
                  break;
                case 2:
                  context.goNamed(AppRouteNames.hub);
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  void _onTodayStateChanged(TodayState state) => onTodayStateChangedExt(state);

  Future<void> _handleFlowTaskTap(
    BuildContext context,
    TodayFlowTask task,
  ) async => handleFlowTaskTapExt(context, task);

  void _openFlowList(BuildContext context, FlowListFilter filter) =>
      openFlowListExt(context, filter);

  Future<void> _openFlowChore(BuildContext context, {String? choreId}) =>
      openFlowChoreExt(context, choreId: choreId);

  Future<void> _openShareCreate(BuildContext context) =>
      openShareCreateExt(context);

  Future<void> _openShareOwedDetail(
    BuildContext context,
    TodayShareOwed owed,
  ) => openShareOwedDetailExt(context, owed);

  Future<void> _openShareDraftEdit(
    BuildContext context,
    TodayShareDraft draft,
  ) => openShareDraftEditExt(context, draft);

  Future<void> _openSharePaidToMeDetail(
    BuildContext context,
    TodaySharePaidToMe entry,
  ) => openSharePaidToMeDetailExt(context, entry);

  Future<void> _openShareCreatedList(BuildContext context) =>
      openShareCreatedListExt(context);

  Future<void> _openGratitudeWall(BuildContext context) =>
      openGratitudeWallExt(context);

  Future<void> _openHarmonyPage(BuildContext context) =>
      openHarmonyPageExt(context);

  String _formatMemberCapNames(List<String> names) =>
      formatMemberCapNamesExt(names);

  Future<void> _openMemberCapPaywall(
    BuildContext context, {
    required String homeId,
  }) => openMemberCapPaywallExt(context, homeId: homeId);

  Future<bool> _shareInvite(BuildContext context, {required bool isFlatmate}) =>
      shareInviteExt(context, isFlatmate: isFlatmate);

  @visibleForTesting
  Future<void> debugTriggerNotificationPrompt() =>
      debugTriggerNotificationPromptExt();

  Future<void> _maybePromptNotifications(BuildContext context) =>
      maybePromptNotificationsExt(context);

  Widget _buildTodayContent(
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
    final hasShare = state.hasShareContent;
    final hasGratitude = state.hasGratitudeUnread;
    final hasInvitePrompt =
        state.shouldPromptFlatmateInviteShare || state.shouldPromptInviteShare;
    final hasMemberCapPrompt =
        (state.memberCapJoinRequests?.pendingCount ?? 0) > 0 &&
        state.profile?.isOwner == true;
    final hasPreferencePrompt = state.shouldPromptPreferences;

    if (!hasFlow &&
        !hasShare &&
        !hasGratitude &&
        !hasInvitePrompt &&
        !hasMemberCapPrompt &&
        !hasPreferencePrompt) {
      return const TodayEmptyStateCard();
    }

    final inviteConfig = _inviteConfig(state);
    final actions = TodaySurfaceActions(
      onMemberCapPrimary: () {
        final homeId = context.read<TodayBloc>().homeId;
        return _openMemberCapPaywall(context, homeId: homeId);
      },
      onMemberCapSecondary:
          () => context.read<TodayBloc>().add(const TodayMemberCapDismissed()),
      onPreferencePrompt:
          () => context.pushNamed(AppRouteNames.preferenceOnboarding),
      onInvitePrimary: (config) async {
        final shared = await _shareInvite(
          context,
          isFlatmate: config.isFlatmate,
        );
        if (!context.mounted || !shared) return;
        context.read<TodayBloc>().add(config.logEvent);
      },
      onInviteSecondary:
          () => context.read<TodayBloc>().add(
            const TodayFlatmateInviteDismissed(),
          ),
      onFlowTaskTap: (task) => _handleFlowTaskTap(context, task),
      onFlowSeeAllTap: (filter) => _openFlowList(context, filter),
      onShareOwedTap: (owed) {
        logger.info(
          'Tapped owed entry: ${owed.displayName}',
          tag: _shareLogTag,
        );
        _openShareOwedDetail(context, owed);
      },
      onSharePaidToMeTap: (entry) {
        logger.info(
          'Tapped paid-to-me entry: ${entry.debtorUsername}',
          tag: _shareLogTag,
        );
        _openSharePaidToMeDetail(context, entry);
      },
      onShareDraftTap: (draft) {
        logger.info(
          'Tapped draft share: ${draft.expenseId}',
          tag: _shareLogTag,
        );
        _openShareDraftEdit(context, draft);
      },
      onShareSeeAllDraftsTap: () {
        logger.info('Tapped see all share drafts', tag: _shareLogTag);
        _openShareCreatedList(context);
      },
      onGratitudeTap: () => _openGratitudeWall(context),
    );
    final scope = TodaySurfaceScope(
      context: context,
      state: state,
      spacing: spacing,
      sections: KinlyThemeAccess.of(context).extension<KinlySections>()!,
      strings: s,
      actions: actions,
      inviteConfig: inviteConfig,
      formatMemberCapNames: _formatMemberCapNames,
    );
    final slots = TodaySurfaceSlots(body: _buildTodayBody(scope));
    return slots.body;
  }

  Widget _buildTodayBody(TodaySurfaceScope scope) {
    final spacing = scope.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildTodaySections(scope, spacing),
    );
  }

  List<Widget> _buildTodaySections(TodaySurfaceScope scope, Spacing spacing) {
    final entries = TodayRegistry.bodySections;
    final children = <Widget>[SizedBox(height: spacing.lg)];

    for (final entry in entries) {
      if (entry.isVisible != null && !entry.isVisible!(scope)) {
        continue;
      }
      children.add(entry.builder(scope));
      final gap = _resolveSectionSpacing(entry.spacingAfter, spacing);
      if (gap > 0) {
        children.add(SizedBox(height: gap));
      }
    }

    return children;
  }

  double _resolveSectionSpacing(TodaySectionSpacing spacing, Spacing tokens) {
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

  TodayInviteConfig _inviteConfig(TodayState state) {
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
}
