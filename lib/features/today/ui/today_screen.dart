import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../domain/models.dart';
import '../bloc/today_bloc.dart';
import 'widgets/today_flow_section.dart';
import 'widgets/today_share_section.dart';
import 'widgets/today_header.dart';
import 'widgets/today_add_sheet.dart';
import 'widgets/today_empty_state_card.dart';
import '../../../core/ui/home_bottom_nav.dart';
import '../../flow/domain/flow_chore_outcome.dart';
import '../../profile_settings/ui/profile_settings_provider.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/logging/debug_logger.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

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
    final s = S.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final sizes = theme.extension<AppSizes>();
    final sections = theme.extension<KinlySections>()!;
    final logger =
        sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger();

    final now = DateTime.now();
    final partOfDay = _partOfDay(now);

    // For now: expenses still mocked
    final expenses = <TodayShareExpense>[
      TodayShareExpense(
        id: '1',
        title: s.todayShareSampleGroceries,
        amount: 28.50,
      ),
      TodayShareExpense(
        id: '2',
        title: s.todayShareSampleRent,
        amount: 650,
        isUpcoming: true,
      ),
      TodayShareExpense(
        id: '3',
        title: s.todayShareSampleInternet,
        amount: 75,
      ),
    ];

    return Scaffold(
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
                  padding: EdgeInsets.fromLTRB(
                    spacing.lg,
                    spacing.lg,
                    spacing.lg,
                    spacing.xl * 2, // bottom spacing for FAB
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<TodayBloc, TodayState>(
                        buildWhen:
                            (previous, current) =>
                                previous.profile != current.profile ||
                                previous.isLoading != current.isLoading,
                        builder: (context, state) {
                          return TodayHeader(
                            partOfDay: partOfDay,
                            profile: state.profile,
                            onAvatarTap:
                                () => _openProfileSettings(
                                  context,
                                  profile: state.profile,
                                ),
                          );
                        },
                      ),
                      SizedBox(height: spacing.xl),

                      // dY"1 Bloc-powered Flow section
                      BlocBuilder<TodayBloc, TodayState>(
                        buildWhen:
                            (previous, current) =>
                                previous.activeTasks != current.activeTasks ||
                                previous.draftTasks != current.draftTasks ||
                                previous.isLoading != current.isLoading ||
                                previous.message != current.message,
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!state.hasFlowContent) {
                            if (state.message != null) {
                              return Text(
                                state.message!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.error,
                                ),
                              );
                            }
                            return const TodayEmptyStateCard();
                          }

                          return TodayFlowSection(
                            activeTasks: state.activeTasks,
                            draftTasks: state.draftTasks,
                            onTaskTap:
                                (task) => _handleFlowTaskTap(context, task),
                            onSeeAllTap: () => context.go(AppRoutes.flow),
                          );
                        },
                      ),

                      SizedBox(height: spacing.lg),

                      // Share section still static for now
                      TodayShareSection(
                        expenses: expenses,
                        onExpenseTap: (expense) {
                          logger.debug(
                            'Tapped expense: ${expense.title}',
                            tag: _shareLogTag,
                          );
                        },
                        onSeeAllTap: () {
                          logger.info(
                            'See all expenses tapped',
                            tag: _shareLogTag,
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        onPressed: () async {
          await TodayAddSheet.show(
            context,
            sections,
            onAddFlow: () => _openFlowChore(context),
            onAddShare: () async {
              final messenger = ScaffoldMessenger.of(context);
              messenger.showSnackBar(
                SnackBar(content: Text(s.todayAddShareComingSoon)),
              );
            },
          );
        },
        child: const Icon(Icons.add),
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
              // TODO: context.go('/hub');
              break;
          }
        },
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

  Future<void> _openProfileSettings(
    BuildContext context, {
    TodayUserProfile? profile,
  }) async {
    final authBloc = context.read<AuthBloc>();
    final membership = authBloc.state.membership;
    if (membership == null) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text(S.of(context).profileMissingHomeError)),
      );
      return;
    }
    final args = ProfileSettingsRouteArgs(
      homeId: membership.homeId,
      displayName: profile?.username,
      avatarUrl: profile?.avatarUrl,
    );
    await context.push(AppRoutes.profileSettings, extra: args);
  }
}
