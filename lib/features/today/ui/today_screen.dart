// lib/features/today/ui/today_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:confetti/confetti.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/logging/debug_logger.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/notifications/device_token_provider.dart';
import '../../../../core/notifications/notification_permission_service.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/time/iana_timezone_resolver.dart';
import '../../../../core/ui/buttons/kinly_fab.dart';
import '../../../../core/ui/home_bottom_nav.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../features/share/share.dart';
import '../../../../../features/home/home.dart';
import '../../../../core/notifications/notifications.dart';
import '../../../../generated/l10n.dart';
import '../../../core/config/app_config.dart';
import '../../../core/homes/models.dart';
import '../../flow/domain/flow_chore_outcome.dart';
import '../../flow/ui/flow_list_filter.dart';
import '../bloc/today_bloc.dart';
import '../domain/models.dart';
import 'widgets/today_add_sheet.dart';
import 'widgets/today_empty_state_card.dart';
import 'widgets/today_flow_section/today_flow_section_container.dart';
import 'widgets/today_gratitude_section.dart';
import 'widgets/today_header/today_header_container.dart';
import 'widgets/today_invite_prompt.dart';
import 'widgets/today_share_section/today_share_section_container.dart';
import '../../share/ui/share_edit_outcome.dart';
import '../../share/ui/share_owed_detail_screen.dart';
import '../../share/ui/share_paid_to_me_detail_screen.dart';
import 'package:kinly/features/paywall/paywall.dart';
import 'package:kinly/core/paywall/paywall_sources.dart';
import 'package:kinly/core/paywall/enums/paywall_trigger.dart';

part 'today_screen_helpers.dart';

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
    final theme = Theme.of(context);
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
            await context.push(AppRoutes.nps);
            if (context.mounted) {
              context.read<TodayBloc>().add(const TodayRefreshed());
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        child: Scaffold(
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
                child: IgnorePointer(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      emissionFrequency: 0.01,
                      maxBlastForce: 4,
                      minBlastForce: 2,
                      numberOfParticles: 6,
                      gravity: 0.12,
                      colors: [
                        sections.flow.accent,
                        sections.share.accent,
                        colorScheme.primary,
                        colorScheme.secondary,
                      ],
                    ),
                  ),
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
                  context.go(AppRoutes.explore);
                  break;
                case 2:
                  context.go(AppRoutes.hub);
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

    if (!hasFlow && !hasShare && !hasGratitude) {
      return const TodayEmptyStateCard();
    }

    final memberCap = state.memberCapJoinRequests;
    final memberCapNames = memberCap?.joinerNames ?? const <String>[];
    final memberCapNamesLabel = _formatMemberCapNames(memberCapNames);
    final memberCapSubtitle =
        memberCapNamesLabel.isNotEmpty
            ? s.todayMemberCapSubtitle(memberCapNamesLabel)
            : s.todayMemberCapSubtitleGeneric;
    final showMemberCapPrompt =
        (memberCap?.pendingCount ?? 0) > 0 &&
        state.profile?.isOwner == true;

    final inviteConfig = _inviteConfig(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showMemberCapPrompt) ...[
          TodayInvitePrompt(
            title: s.todayMemberCapTitle,
            subtitle: memberCapSubtitle,
            primaryLabel: s.todayMemberCapPrimaryCta,
            secondaryLabel: s.todayMemberCapSecondaryCta,
            onPrimary: () {
              final homeId = context.read<TodayBloc>().homeId;
              _openMemberCapPaywall(context, homeId: homeId);
            },
            onSecondary:
                () => context.read<TodayBloc>().add(
                  const TodayMemberCapDismissed(),
                ),
          ),
          SizedBox(height: spacing.lg),
        ],
        if (inviteConfig.showPrompt) ...[
          TodayInvitePrompt(
            title:
                inviteConfig.isFlatmate
                    ? s.todayFlatmateInviteTitle
                    : s.todayInviteFriendsTitle,
            subtitle:
                inviteConfig.isFlatmate
                    ? s.todayFlatmateInviteSubtitle
                    : s.todayInviteFriendsSubtitle,
            primaryLabel: s.todayInviteShareCta,
            secondaryLabel:
                inviteConfig.isFlatmate
                    ? s.todayInviteNotNow
                    : s.todayInviteNotNow,
            onPrimary: () async {
              final shared = await _shareInvite(
                context,
                isFlatmate: inviteConfig.isFlatmate,
              );
              if (!context.mounted || !shared) return;
              context.read<TodayBloc>().add(inviteConfig.logEvent);
            },
            onSecondary:
                inviteConfig.isFlatmate
                    ? () => context.read<TodayBloc>().add(
                      const TodayFlatmateInviteDismissed(),
                    )
                    : null,
          ),
          SizedBox(height: spacing.lg),
        ],
        if (hasFlow) ...[
          TodayFlowSectionContainer(
            onTaskTap: (task) => _handleFlowTaskTap(context, task),
            onSeeAllTap: (filter) => _openFlowList(context, filter),
          ),
          SizedBox(height: spacing.lg),
        ],
        if (hasShare)
          TodayShareSectionContainer(
            onOwedTap: (owed) {
              logger.info(
                'Tapped owed entry: ${owed.displayName}',
                tag: _shareLogTag,
              );
              _openShareOwedDetail(context, owed);
            },
            onPaidToMeTap: (entry) {
              logger.info(
                'Tapped paid-to-me entry: ${entry.debtorUsername}',
                tag: _shareLogTag,
              );
              _openSharePaidToMeDetail(context, entry);
            },
            onDraftTap: (draft) {
              logger.info(
                'Tapped draft share: ${draft.expenseId}',
                tag: _shareLogTag,
              );
              _openShareDraftEdit(context, draft);
            },
            onSeeAllDraftsTap: () {
              logger.info('Tapped see all share drafts', tag: _shareLogTag);
              _openShareCreatedList(context);
            },
          ),
        if (hasGratitude) ...[
          SizedBox(height: spacing.lg),
          TodayGratitudeSection(onTap: () => _openGratitudeWall(context)),
        ],
      ],
    );
  }

  _InviteConfig _inviteConfig(TodayState state) {
    final isFlatmate = state.shouldPromptFlatmateInviteShare;
    final shouldShowGeneric = !isFlatmate && state.shouldPromptInviteShare;
    return _InviteConfig(
      showPrompt: isFlatmate || shouldShowGeneric,
      isFlatmate: isFlatmate,
      logEvent:
          isFlatmate
              ? const TodayFlatmateInviteShareLogged(channel: 'system_share')
              : const TodayInviteShareLogged(channel: 'system_share'),
    );
  }
}

class _InviteConfig {
  const _InviteConfig({
    required this.showPrompt,
    required this.isFlatmate,
    required this.logEvent,
  });

  final bool showPrompt;
  final bool isFlatmate;
  final TodayEvent logEvent;
}
