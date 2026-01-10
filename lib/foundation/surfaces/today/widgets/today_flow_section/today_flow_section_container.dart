// lib/features/today/ui/widgets/today_flow_section_container.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/today_bloc.dart';
import '../../domain/models.dart';
import 'today_flow_section.dart';
import '../today_empty_state_card.dart';
import '../../../../../core/ui/kinly_loader.dart';
import 'package:kinly/contracts/flow/enums/flow_list_filter.dart';
import '../../../../../core/ui/kinly_theme_access.dart';

class TodayFlowSectionContainer extends StatelessWidget {
  final void Function(TodayFlowTask task) onTaskTap;
  final void Function(FlowListFilter filter) onSeeAllTap;

  const TodayFlowSectionContainer({
    super.key,
    required this.onTaskTap,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<TodayBloc, TodayState>(
      buildWhen:
          (previous, current) =>
              previous.activeTasks != current.activeTasks ||
              previous.draftTasks != current.draftTasks ||
              previous.isLoading != current.isLoading ||
              previous.message != current.message,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: KinlyLoader(size: 40));
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
          onTaskTap: onTaskTap,
          onSeeAllTap: onSeeAllTap,
        );
      },
    );
  }
}
