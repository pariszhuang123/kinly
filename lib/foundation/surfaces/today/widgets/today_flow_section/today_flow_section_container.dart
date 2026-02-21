// lib/features/today/ui/widgets/today_flow_section_container.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/today_bloc.dart';
import '../../domain/models.dart';
import 'today_flow_section.dart';
import '../../../../../core/ui/kinly_loader.dart';
import 'package:kinly/contracts/flow/enums/flow_list_filter.dart';

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
    return BlocBuilder<TodayBloc, TodayState>(
      buildWhen:
          (previous, current) =>
              previous.activeTasks != current.activeTasks ||
              previous.draftTasks != current.draftTasks ||
              previous.isLoading != current.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: KinlyLoader(size: 40));
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
