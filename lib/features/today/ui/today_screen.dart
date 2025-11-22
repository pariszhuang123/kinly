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
import '../../../../data/repositories/expenses_repository.dart';
import '../../share/ui/share_owed_detail_screen.dart';

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
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final sizes = theme.extension<AppSizes>();
    final sections = theme.extension<KinlySections>()!;
    final logger =
        sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger();

    final now = DateTime.now();
    final partOfDay = _partOfDay(now);

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.shareCreateSuccess)));
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.shareOwedDetailSuccess)));
      context.read<TodayBloc>().add(const TodayRefreshed());
    }
  }

  Future<void> _openShareDraftEdit(
    BuildContext context,
    TodayShareDraft draft,
  ) async {
    final result = await context.push<bool>(
      AppRoutes.shareDraftEditPath(draft.expenseId),
    );
    if (result == true && context.mounted) {
      final s = S.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.shareEditSuccess)));
      context.read<TodayBloc>().add(const TodayRefreshed());
    }
  }
}
