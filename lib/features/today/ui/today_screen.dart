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
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/time/iana_timezone_resolver.dart';
import '../../../../core/ui/buttons/kinly_fab.dart';
import '../../../../core/ui/home_bottom_nav.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../data/repositories/expenses_repository.dart';
import '../../../../data/repositories/home_repository.dart';
import '../../../../data/repositories/notifications_repository.dart';
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
import '../../share/ui/share_edit_route_args.dart';
import '../../share/ui/share_owed_detail_screen.dart';
import '../../share/ui/share_paid_to_me_detail_screen.dart';

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

  String _partOfDay(DateTime now) {
    final hour = now.hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

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
                                      if (state.isLoading) {
                                        return const Center(
                                          child: KinlyLoader(),
                                        );
                                      }

                                      final hasFlow = state.hasFlowContent;
                                      final hasShare = state.hasShareContent;
                                      final hasGratitude =
                                          state.hasGratitudeUnread;

                                      if (!hasFlow &&
                                          !hasShare &&
                                          !hasGratitude) {
                                        return const TodayEmptyStateCard();
                                      }

                                      final shouldShowFlatmateInvite =
                                          state.shouldPromptFlatmateInviteShare;
                                      final shouldShowGenericInvite =
                                          !shouldShowFlatmateInvite &&
                                          state.shouldPromptInviteShare;
                                      final showInvitePrompt =
                                          shouldShowFlatmateInvite ||
                                          shouldShowGenericInvite;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (showInvitePrompt) ...[
                                            TodayInvitePrompt(
                                              title:
                                                  shouldShowFlatmateInvite
                                                      ? s.todayFlatmateInviteTitle
                                                      : s.todayInviteFriendsTitle,
                                              subtitle:
                                                  shouldShowFlatmateInvite
                                                      ? s.todayFlatmateInviteSubtitle
                                                      : s.todayInviteFriendsSubtitle,
                                              primaryLabel:
                                                  s.todayInviteShareCta,
                                              secondaryLabel:
                                                  shouldShowFlatmateInvite
                                                      ? s.todayInviteNotNow
                                                      : s.todayInviteNotNow,
                                              onPrimary: () async {
                                                final shared = await _shareInvite(
                                                  context,
                                                  isFlatmate:
                                                      shouldShowFlatmateInvite,
                                                );
                                                if (!context.mounted ||
                                                    !shared) {
                                                  return;
                                                }
                                                if (shouldShowFlatmateInvite) {
                                                  context.read<TodayBloc>().add(
                                                    const TodayFlatmateInviteShareLogged(
                                                      channel: 'system_share',
                                                    ),
                                                  );
                                                } else {
                                                  context.read<TodayBloc>().add(
                                                    const TodayInviteShareLogged(
                                                      channel: 'system_share',
                                                    ),
                                                  );
                                                }
                                              },
                                              onSecondary:
                                                  shouldShowFlatmateInvite
                                                      ? () => context
                                                          .read<TodayBloc>()
                                                          .add(
                                                            const TodayFlatmateInviteDismissed(),
                                                          )
                                                      : null,
                                            ),
                                            SizedBox(height: spacing.lg),
                                          ],
                                          if (hasFlow) ...[
                                            TodayFlowSectionContainer(
                                              onTaskTap:
                                                  (task) => _handleFlowTaskTap(
                                                    context,
                                                    task,
                                                  ),
                                              onSeeAllTap:
                                                  (filter) => _openFlowList(
                                                    context,
                                                    filter,
                                                  ),
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
                                                _openShareOwedDetail(
                                                  context,
                                                  owed,
                                                );
                                              },
                                              onPaidToMeTap: (entry) {
                                                logger.info(
                                                  'Tapped paid-to-me entry: ${entry.debtorUsername}',
                                                  tag: _shareLogTag,
                                                );
                                                _openSharePaidToMeDetail(
                                                  context,
                                                  entry,
                                                );
                                              },
                                              onDraftTap: (draft) {
                                                logger.info(
                                                  'Tapped draft share: ${draft.expenseId}',
                                                  tag: _shareLogTag,
                                                );
                                                _openShareDraftEdit(
                                                  context,
                                                  draft,
                                                );
                                              },
                                              onSeeAllDraftsTap: () {
                                                logger.info(
                                                  'Tapped see all share drafts',
                                                  tag: _shareLogTag,
                                                );
                                                _openShareCreatedList(context);
                                              },
                                            ),
                                          if (hasGratitude) ...[
                                            SizedBox(height: spacing.lg),
                                            TodayGratitudeSection(
                                              onTap:
                                                  () => _openGratitudeWall(
                                                    context,
                                                  ),
                                            ),
                                          ],
                                        ],
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

  void _onTodayStateChanged(TodayState state) {
    if (state.isLoading) return;

    final previous = _lastNonLoadingState;
    _lastNonLoadingState = state;

    if (!state.isCaughtUp) {
      _hasPendingTodayItems = true;
      return;
    }

    final hadItemsBefore =
        _hasPendingTodayItems ||
        (previous != null && !previous.isCaughtUp) ||
        (previous?.activeChoreCount ?? 0) > 0;
    if (!hadItemsBefore) return;

    _hasPendingTodayItems = false;
    _confettiController.play();
  }

  Future<void> _handleFlowTaskTap(
    BuildContext context,
    TodayFlowTask task,
  ) async {
    if (task.isActive) {
      await _openFlowChoreDetail(context, choreId: task.id);
    } else {
      await _openFlowChore(context, choreId: task.id);
    }
  }

  Future<void> _openFlowChoreDetail(
    BuildContext context, {
    required String choreId,
  }) async {
    final result = await context.push(AppRoutes.flowChoreDetailPath(choreId));
    if (result is FlowChoreOutcome) {
      if (!context.mounted) return;
      if (result.isCompleted) {
        final s = S.of(context);
        final accent =
            Theme.of(context).extension<KinlySections>()?.flow.accent;
        KinlySnackBar.showSuccess(
          context,
          s.flowChoreDetailCompletionSuccess,
          accentColor: accent,
        );
      }
      context.read<TodayBloc>().add(const TodayRefreshed());
    }
  }

  void _openFlowList(BuildContext context, FlowListFilter filter) {
    final filterParam = filter.toQueryParam();
    context.push('${AppRoutes.flow}?filter=$filterParam&scope=mine').then((_) {
      if (context.mounted) {
        context.read<TodayBloc>().add(const TodayRefreshed());
      }
    });
  }

  Future<void> _openFlowChore(BuildContext context, {String? choreId}) async {
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

  Future<void> _openShareCreate(BuildContext context) async {
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

  Future<void> _openShareOwedDetail(
    BuildContext context,
    TodayShareOwed owed,
  ) async {
    final repository = sl<ExpensesRepository>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder:
            (_) => ShareOwedDetailScreen(
              owed: owed,
              expensesRepository: repository,
            ),
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

  Future<void> _openShareDraftEdit(
    BuildContext context,
    TodayShareDraft draft,
  ) async {
    final result = await context.push(
      AppRoutes.shareDraftEditPath(draft.expenseId),
      extra: const ShareEditRouteArgs(allowDelete: false),
    );
    if (!context.mounted) return;
    final s = S.of(context);
    final accent = Theme.of(context).extension<KinlySections>()?.share.accent;
    if (result == true || result == ShareEditOutcome.updated) {
      KinlySnackBar.showSuccess(
        context,
        s.shareEditSuccess,
        accentColor: accent,
      );
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

  Future<void> _openSharePaidToMeDetail(
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

  Future<void> _openShareCreatedList(BuildContext context) async {
    await context.push<bool>(AppRoutes.shareCreatedList, extra: true);
    if (context.mounted) {
      context.read<TodayBloc>().add(const TodayRefreshed());
    }
  }

  Future<void> _openGratitudeWall(BuildContext context) async {
    await context.push(AppRoutes.gratitudeWall);
    if (context.mounted) {
      context.read<TodayBloc>().add(const TodayRefreshed());
    }
  }

  Future<void> _openHarmonyPage(BuildContext context) async {
    await context.push(AppRoutes.harmony);
  }

  Future<bool> _shareInvite(
    BuildContext context, {
    required bool isFlatmate,
  }) async {
    final s = S.of(context);
    final repo = sl<HomeRepository>();
    final logger =
        sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger();

    try {
      final membership = await repo.getCurrentMembership();
      if (!context.mounted) return false;
      final homeId = membership?.homeId;
      if (homeId == null) {
        if (!context.mounted) return false;
        KinlySnackBar.showError(context, s.hubInviteUnavailable);
        return false;
      }

      HomeInvite? invite;
      try {
        invite = await repo.getActiveInvite(homeId);
      } catch (_) {
        try {
          invite = await repo.getOrCreateInvite(homeId);
        } catch (_) {
          invite = null;
        }
      }

      if (invite == null) {
        if (!context.mounted) return false;
        KinlySnackBar.showError(context, s.hubInviteUnavailable);
        return false;
      }

      final appLink = _buildInviteLink(invite);
      final raw = s.hubShareInviteBody(invite.code, appLink);
      final message = raw.replaceAll(r'\n', '\n');
      await Share.share(message, subject: s.hubShareInviteTitle);
      if (!context.mounted) return false;
      return true;
    } catch (error, stack) {
      logger.warn(
        'Failed to share invite from Today',
        error: error,
        stackTrace: stack,
        tag: _shareLogTag,
      );
      if (!context.mounted) return false;
      KinlySnackBar.showError(context, s.hubInviteUnavailable);
      return false;
    }
  }

  String _buildInviteLink(HomeInvite invite) {
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
  Future<void> debugTriggerNotificationPrompt() =>
      _maybePromptNotifications(context);

  Future<void> _maybePromptNotifications(BuildContext context) async {
    if (!context.mounted) return;
    widget.onNotificationPrompt?.call();
    final repo = sl<NotificationsRepository>();
    final permissionService =
        sl.isRegistered<NotificationPermissionService>()
            ? sl<NotificationPermissionService>()
            : NotificationPermissionService(notificationsRepository: repo);
    final tokenProvider =
        sl.isRegistered<DeviceTokenProvider>()
            ? sl<DeviceTokenProvider>()
            : const FirebaseDeviceTokenProvider();
    final locale = Localizations.localeOf(context).toLanguageTag();
    final platformName = Theme.of(context).platform.name;
    final timezone = await sl<IanaTimezoneResolver>().resolve();
    final logger =
        sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger();
    const notifTag = 'TodayNotifications';
    logger.debug('Using timezone=$timezone for notifications sync', tag: notifTag);
    String? deviceToken;
    try {
      deviceToken = await tokenProvider.getToken();
    } catch (error, stackTrace) {
      logger.warn(
        'Failed to read device token; continuing without it',
        tag: notifTag,
        error: error,
        stackTrace: stackTrace,
      );
    }
    if (!context.mounted) return;
    try {
      await permissionService.requestAndSync(
        wantsDaily: true,
        preferredHour: 9,
        preferredMinute: 0,
        timezone: timezone,
        locale: locale,
        deviceToken: deviceToken,
        platform: platformName,
      );
    } on NotificationPermissionException catch (error, stackTrace) {
      logger.warn(
        'Notification permission rejected or unavailable',
        tag: notifTag,
        error: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      logger.warn(
        'Failed to request notification permissions',
        tag: notifTag,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
