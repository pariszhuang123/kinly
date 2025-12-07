import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dopamine/dopamine_models.dart';
import '../../../../core/dopamine/enums/dopamine_milestone.dart';
import '../../../../core/dopamine/enums/dopamine_strength.dart';
import '../../../../core/dopamine/dopamine_overlay.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/flow_chore_detail_bloc.dart';
import '../../domain/flow_chore_outcome.dart';
import 'widgets/flow_chore_detail_view.dart';

class FlowChoreDetailScreen extends StatefulWidget {
  const FlowChoreDetailScreen({super.key});

  @override
  State<FlowChoreDetailScreen> createState() => _FlowChoreDetailScreenState();
}

class _FlowChoreDetailScreenState extends State<FlowChoreDetailScreen> {
  final _dopamineHostKey = GlobalKey<DopamineOverlayHostState>();
  final _completeButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).flowChoreDetailTitle)),
      body: SafeArea(
        child: DopamineOverlayHost(
          key: _dopamineHostKey,
          child: BlocConsumer<FlowChoreDetailBloc, FlowChoreDetailState>(
            listenWhen:
                (previous, current) =>
                    previous.completionResult != current.completionResult ||
                    previous.completionErrorTick != current.completionErrorTick,
            listener: (context, state) async {
              // Successful completion -> pop with outcome
              if (state.completionResult != null) {
                // Guard this callback's BuildContext first
                if (!context.mounted) return;

                // Capture context-dependent values BEFORE the async gap
                final affirmation = S.of(context).dopamineFlowAffirmation;
                final reduceMotion =
                    MediaQuery.maybeOf(context)?.disableAnimations ?? false;

                await _showDopamine(
                  affirmation: affirmation,
                  reduceMotion: reduceMotion,
                );

                // Guard the SAME context used below
                if (!context.mounted) return;

                Navigator.of(context).pop(
                  FlowChoreOutcome(
                    choreId: state.completionResult!.choreId,
                    isUpdate: false,
                    isCompleted: true,
                  ),
                );
                return;
              }

              // Completion error -> show snackbar
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
                completeButtonKey: _completeButtonKey,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showDopamine({
    required String affirmation,
    required bool reduceMotion,
  }) async {
    final host = _dopamineHostKey.currentState;
    if (host == null) return;

    final renderBox =
        _completeButtonKey.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    final anchor =
        (renderBox != null && position != null)
            ? Rect.fromLTWH(
              position.dx,
              position.dy,
              renderBox.size.width,
              renderBox.size.height,
            )
            : null;

    host.show(
      DopamineMoment(
        milestone: DopamineMilestone.flow,
        strength: DopamineStrength.medium,
        affirmation: affirmation,
        reduceMotion: reduceMotion,
        hapticEnabled: true,
      ),
      anchorRect: anchor,
    );

    // Let the dopamine moment play briefly before navigating away.
    await Future<void>.delayed(const Duration(milliseconds: 720));
  }
}
