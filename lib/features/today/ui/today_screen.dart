// lib/features/today/presentation/pages/today_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/kinly_sections.dart'; // 👈 NEW
import '../domain/models.dart';
import 'widgets/today_flow_section.dart';
import 'widgets/today_share_section.dart';

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
    final sections = theme.extension<KinlySections>()!; // 👈 NEW

    // Temporary mock data – later comes from TodayBloc / use case
    const tasks = <TodayFlowTask>[
      TodayFlowTask(id: '1', title: 'Take out recycling'),
      TodayFlowTask(id: '2', title: 'Vacuum the living room'),
      TodayFlowTask(id: '3', title: 'Wipe the table', isNewToday: true),
      TodayFlowTask(id: '4', title: 'Water the plants'),
    ];

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

    final now = DateTime.now();
    final partOfDay = _partOfDay(now);
    const userName = 'Paris'; // later from profile BLoC

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
                      // HEADER
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Good $partOfDay, $userName',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                SizedBox(height: spacing.xs),
                                Text(
                                  "Here’s what’s flowing in your home today.",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: spacing.md),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: colorScheme.surfaceContainerHigh,
                            child: const Text(
                              '🦊',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacing.xl),

                      // FLOW SECTION (tasks)
                      TodayFlowSection(
                        tasks: tasks,
                        onTaskTap: (task) {
                          // TODO: Navigate to Flow/task details
                          debugPrint('Tapped task: ${task.title}');
                        },
                        onSeeAllTap: () {
                          // TODO: context.go('/flow');
                          debugPrint('See all Flow tasks');
                        },
                      ),
                      SizedBox(height: spacing.lg),

                      // SHARE SECTION (expenses)
                      TodayShareSection(
                        expenses: expenses,
                        onExpenseTap: (expense) {
                          // TODO: Navigate to Share/expense details
                          debugPrint('Tapped expense: ${expense.title}');
                        },
                        onSeeAllTap: () {
                          // TODO: context.go('/share');
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

      // FAB – add Flow / Share etc.
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing.lg,
                  spacing.md,
                  spacing.lg,
                  spacing.xl,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add to your home',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: spacing.md),
                    ListTile(
                      leading: Icon(
                        Icons.checklist,
                        // 👇 Flow uses its section icon color (light/dark aware)
                        color: sections.flow.icon,
                      ),
                      title: const Text('Add task (Flow)'),
                      onTap: () {
                        Navigator.of(context).pop();
                        // TODO: navigate to add-task flow
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.account_balance_wallet,
                        // 👇 Share uses its section icon color
                        color: sections.share.icon,
                      ),
                      title: const Text('Add expense (Share)'),
                      onTap: () {
                        Navigator.of(context).pop();
                        // TODO: navigate to add-expense flow
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // BOTTOM NAV (Today / Explore / Hub)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Today
        onTap: (index) {
          switch (index) {
            case 0:
              // already on Today
              break;
            case 1:
              // TODO: context.go('/explore');
              break;
            case 2:
              // TODO: context.go('/hub');
              break;
          }
        },
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
        backgroundColor: colorScheme.surfaceContainerHigh,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Hub',
          ),
        ],
      ),
    );
  }
}
