import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/auth/bloc/auth_bloc.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/supabase/storage_path_resolver.dart';
import '../../bloc/flow_chore_detail_bloc.dart';
import '../../domain/flow_chore_outcome.dart';
import 'widgets/flow_chore_detail_view.dart';

class FlowChoreDetailScreen extends StatefulWidget {
  const FlowChoreDetailScreen({super.key});

  @override
  State<FlowChoreDetailScreen> createState() => _FlowChoreDetailScreenState();
}

class _FlowChoreDetailScreenState extends State<FlowChoreDetailScreen> {
  final _completeButtonKey = GlobalKey();

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

            if (state.completionErrorTick > 0) {
              final message =
                  state.completionErrorMessage ??
                  S.of(context).flowChoreDetailCompletionError;

              final accent =
                  Theme.of(context).extension<KinlySections>()?.flow.accent;
              KinlySnackBar.showError(context, message, accentColor: accent);
            }
          },
          builder: (context, state) {
            final currentUserId =
                context.select<AuthBloc, String?>(
                  (bloc) => bloc.state.userId,
                );
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
              currentUserId: currentUserId,
              storagePathResolver: sl<StoragePathResolver>(),
            );
          },
        ),
      ),
    );
  }
}
