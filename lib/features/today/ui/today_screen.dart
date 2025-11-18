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
import '../../../core/ui/home_bottom_nav.dart';
import '../../flow/domain/flow_chore_outcome.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

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

    final now = DateTime.now();
    final partOfDay = _partOfDay(now);

    // For now: expenses still mocked
    const expenses = <TodayShareExpense>[
      TodayShareExpense(
        id: '1',
        title: 'Shared groceries from yesterday',
        amount: 28.50,
      ),
      TodayShareExpense(
        id: '2',
        title: 'Rent reminder coming up',
        amount: 650,
        isUpcoming: true,
      ),
      TodayShareExpense(id: '3', title: 'Internet bill this week', amount: 75),
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
                          );
                        },
                      ),
                      SizedBox(height: spacing.xl),

                      // dY"1 Bloc-powered Flow section
                      BlocBuilder<TodayBloc, TodayState>(
                        buildWhen:
                            (previous, current) =>
                                previous.flowTasks != current.flowTasks ||
                                previous.isLoading != current.isLoading ||
                                previous.message != current.message,
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state.flowTasks.isEmpty &&
                              state.message != null) {
                            // Error state with message
                            return Text(
                              state.message!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.error,
                              ),
                            );
                          }

                          final tasks = state.flowTasks;

                          if (tasks.isEmpty) {
                            return const SizedBox.shrink(); // nothing
                          }

                          return TodayFlowSection(
                            tasks: tasks,
                            onTaskTap:
                                (task) =>
                                    _openFlowChore(context, choreId: task.id),
                            onSeeAllTap: () {
                              // TODO: context.go('/flow');
                              debugPrint('See all Flow tasks');
                            },
                          );
                        },
                      ),

                      SizedBox(height: spacing.lg),

                      // Share section still static for now
                      TodayShareSection(
                        expenses: expenses,
                        onExpenseTap: (expense) {
                          debugPrint('Tapped expense: ${expense.title}');
                        },
                        onSeeAllTap: () {
                          debugPrint('See all expenses');
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
              // TODO: context.go('/explore');
              break;
            case 2:
              // TODO: context.go('/hub');
              break;
          }
        },
      ),
    );
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
}
