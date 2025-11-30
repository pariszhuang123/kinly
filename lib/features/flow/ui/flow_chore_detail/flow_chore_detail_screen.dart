// lib/features/flow/ui/flow_chore_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/l10n.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../bloc/flow_chore_detail_bloc.dart';
import '../../domain/flow_chore_outcome.dart';
import 'widgets/flow_chore_detail_view.dart';

class FlowChoreDetailScreen extends StatelessWidget {
  const FlowChoreDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).flowChoreDetailTitle)),
      body: SafeArea(
        child: BlocConsumer<FlowChoreDetailBloc, FlowChoreDetailState>(
          listenWhen:
              (previous, current) =>
                  previous.completionResult != current.completionResult ||
                  previous.completionErrorTick != current.completionErrorTick,
          listener: (context, state) {
            // Successful completion → pop with outcome
            if (state.completionResult != null) {
              Navigator.of(context).pop(
                FlowChoreOutcome(
                  choreId: state.completionResult!.choreId,
                  isUpdate: false,
                  isCompleted: true,
                ),
              );
              return;
            }

            // Completion error → show snackbar
            if (state.completionErrorTick > 0) {
              final message =
                  state.completionErrorMessage ??
                  S.of(context).flowChoreDetailCompletionError;

              KinlySnackBar.showError(context, message);
            }
          },
          builder: (context, state) {
            return FlowChoreDetailView(
              state: state,
              onRetry:
                  () => context.read<FlowChoreDetailBloc>().add(
                    const FlowChoreDetailStarted(),
                  ),
              onComplete:
                  state.canComplete
                      ? () => context.read<FlowChoreDetailBloc>().add(
                        const FlowChoreDetailCompletionRequested(),
                      )
                      : null,
            );
          },
        ),
      ),
    );
  }
}
