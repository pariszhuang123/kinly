// lib/features/today/ui/today_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/buttons/kinly_fab.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../core/ui/kinly_bottom_sheet.dart';
import '../domain/models.dart';
import '../bloc/today_bloc.dart';
import 'widgets/today_header_container.dart';
import 'widgets/today_flow_section_container.dart';
import 'widgets/today_share_section.dart';
import 'widgets/today_add_sheet.dart';
import 'widgets/today_empty_state_card.dart';
import 'widgets/today_gratitude_section.dart';
import '../../../../core/ui/home_bottom_nav.dart';
import '../../flow/ui/flow_list_filter.dart';
import '../../flow/domain/flow_chore_outcome.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/logging/debug_logger.dart';
import '../../../../data/repositories/expenses_repository.dart';
import '../../share/ui/share_owed_detail_screen.dart';
import '../../share/ui/share_edit_route_args.dart';
import '../../share/ui/share_edit_outcome.dart';
import '../../harmony/ui/harmony_provider.dart';
import '../../../data/repositories/mood_repository.dart';

class TodayScreen extends StatelessWidget {
  final String homeId;
  const TodayScreen({super.key, required this.homeId});

  static const _shareLogTag = 'TodayShare';

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
    final logger =
        sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger();

    final now = DateTime.now();
    final partOfDay = _partOfDay(now);

    return MultiBlocListener(
      listeners: [
        BlocListener<TodayBloc, TodayState>(
          listenWhen:
              (prev, curr) =>
                  prev.harmonyPromptTick != curr.harmonyPromptTick &&
                  curr.harmonyPromptTick > 0,
          listener: (context, state) async {
            await _openHarmonySheet(context);
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
        // Prevent leaving TodayScreen via system back / back gesture
        canPop: false,
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          body: SafeArea(
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
                    child: SingleChildScrollView(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        spacing.lg,
                        spacing.lg,
                        spacing.lg,
                        spacing.xl * 2, // bottom spacing for FAB
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Header
                          TodayHeaderContainer(partOfDay: partOfDay),
                          SizedBox(height: spacing.xl),

                          // 🔹 Today content driven by TodayBloc
                          BlocBuilder<TodayBloc, TodayState>(
                            builder: (context, state) {
                              if (state.isLoading) {
                                return const Center(child: KinlyLoader());
                              }

                              final hasFlow = state.hasFlowContent;
                              final hasShare = state.hasShareContent;
                              final hasGratitude = state.hasGratitudeUnread;

                              // If no Flow and no Share show empty state card
                              if (!hasFlow && !hasShare && !hasGratitude) {
                                return const TodayEmptyStateCard();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (hasFlow) ...[
                                    TodayFlowSectionContainer(
                                      onTaskTap:
                                          (task) =>
                                              _handleFlowTaskTap(context, task),
                                      onSeeAllTap:
                                          (filter) =>
                                              _openFlowList(context, filter),
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
                                      onDraftTap: (draft) {
                                        logger.info(
                                          'Tapped draft share: ${draft.expenseId}',
                                          tag: _shareLogTag,
                                        );
                                        _openShareDraftEdit(context, draft);
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
                                      onTap: () => _openGratitudeWall(context),
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
                  // Already on Today
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
      context.read<TodayBloc>().add(const TodayRefreshed());
    }
  }

  void _openFlowList(BuildContext context, FlowListFilter filter) {
    final filterParam = filter.toQueryParam();
    context.push('${AppRoutes.flow}?filter=$filterParam');
  }

  Future<void> _openFlowChore(BuildContext context, {String? choreId}) async {
    final path =
        choreId == null
            ? AppRoutes.flowChoreCreate
            : AppRoutes.flowChoreEditPath(choreId);
    final result = await context.push(path);
    if (result is FlowChoreOutcome) {
      if (!context.mounted) return;
      context.read<TodayBloc>().add(const TodayRefreshed());
    }
  }

  Future<void> _openShareCreate(BuildContext context) async {
    final result = await context.push<bool>(AppRoutes.shareCreate);
    if (!context.mounted) return;
    context.read<TodayBloc>().add(const TodayRefreshed());
    if (result == true) {
      final s = S.of(context);
      KinlySnackBar.showSuccess(context, s.shareCreateSuccess);
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
      KinlySnackBar.showSuccess(context, s.shareOwedDetailSuccess);
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
    if (result == true || result == ShareEditOutcome.updated) {
      KinlySnackBar.showSuccess(context, s.shareEditSuccess);
      context.read<TodayBloc>().add(const TodayRefreshed());
    } else if (result == ShareEditOutcome.deleted) {
      KinlySnackBar.showSuccess(context, s.shareEditDeleteSuccess);
      context.read<TodayBloc>().add(const TodayRefreshed());
    }
  }

  Future<void> _openShareCreatedList(BuildContext context) async {
    await context.push<bool>(
      AppRoutes.shareCreatedList,
      extra: true, // show drafts-only list
    );
  }

  Future<void> _openGratitudeWall(BuildContext context) async {
    await context.push(AppRoutes.gratitudeWall);
    if (context.mounted) {
      context.read<TodayBloc>().add(const TodayRefreshed());
    }
  }

  Future<void> _openHarmonySheet(BuildContext context) {
    final s = S.of(context);
    final media = MediaQuery.of(context);
    return KinlyBottomSheet.show(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      title: s.harmonyTitle,
      subtitle: s.harmonySubtext,
      body: SizedBox(
        height: media.size.height * 0.82,
        child: HarmonyProvider(
          homeId: homeId,
          moodRepository: sl<MoodRepository>(),
        ),
      ),
    );
  }
}
