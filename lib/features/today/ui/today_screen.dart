// lib/features/today/ui/today_screen.dart
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
import 'widgets/today_header_container.dart';
import 'widgets/today_flow_section_container.dart';
import 'widgets/today_share_section.dart';
import 'widgets/today_add_sheet.dart';
import '../../../core/ui/home_bottom_nav.dart';
import '../../flow/domain/flow_chore_outcome.dart';
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
      TodayShareExpense(id: '3', title: s.todayShareSampleInternet, amount: 75),
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
                      // 🔹 Header now modular
                      TodayHeaderContainer(partOfDay: partOfDay),
                      SizedBox(height: spacing.xl),

                      // 🔹 Flow section now modular
                      TodayFlowSectionContainer(
                        onTaskTap: (task) => _handleFlowTaskTap(context, task),
                        onSeeAllTap: () => context.go(AppRoutes.flow),
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
            onAddShare: () => _openShareCreate(context),
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

  Future<void> _openShareCreate(BuildContext context) async {
    final result = await context.push<bool>(AppRoutes.shareCreate);
    if (result == true && context.mounted) {
      final s = S.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.shareCreateSuccess)),
      );
    }
  }
}
