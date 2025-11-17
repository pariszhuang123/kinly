import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../domain/models.dart';
import '../bloc/today_bloc.dart';
import 'widgets/today_flow_section.dart';
import 'widgets/today_share_section.dart';
import 'widgets/today_header.dart';
import 'widgets/today_add_sheet.dart';
import '../../../core/ui/home_bottom_nav.dart';

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
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final sizes = theme.extension<AppSizes>();
    final sections = theme.extension<KinlySections>()!;

    final now = DateTime.now();
    final partOfDay = _partOfDay(now);
    const userName = 'Paris'; // later from profile BLoC

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
                      TodayHeader(partOfDay: partOfDay, userName: userName),
                      SizedBox(height: spacing.xl),

                      // 🔹 Bloc-powered Flow section
                      BlocBuilder<TodayBloc, TodayState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is TodayState &&
                              state.flowTasks.isEmpty &&
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
                            return Text(
                              "No chores for today yet. Add one to get things flowing.",
                              style: theme.textTheme.bodyMedium,
                            );
                          }

                          return TodayFlowSection(
                            tasks: tasks,
                            onTaskTap: (task) {
                              // TODO: Navigate to Flow/task details
                              debugPrint('Tapped task: ${task.title}');
                            },
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
        onPressed: () {
          TodayAddSheet.show(context, sections);
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
}
