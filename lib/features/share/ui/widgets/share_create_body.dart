import 'package:flutter/widgets.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/share_create_bloc/share_create_bloc.dart';
import 'share_create_action_bar.dart';
import 'share_create_error.dart';
import 'share_create_form_view.dart';

class ShareCreateBody extends StatelessWidget {
  const ShareCreateBody({
    super.key,
    required this.spacing,
    required this.state,
    required this.shareColors,
    required this.allowDelete,
    required this.showTerminatePlan,
    required this.onRetry,
    required this.descriptionController,
    required this.amountController,
    required this.notesController,
    required this.recurrenceEveryController,
    required this.customControllers,
    required this.onSubmit,
    required this.onDeleteRequested,
    required this.onTerminatePlan,
    required this.onPaywallOpened,
  });

  final Spacing spacing;
  final ShareCreateState state;
  final SectionColors? shareColors;
  final bool allowDelete;
  final bool showTerminatePlan;
  final VoidCallback onRetry;
  final TextEditingController descriptionController;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final TextEditingController recurrenceEveryController;
  final Map<String, TextEditingController> customControllers;
  final VoidCallback onSubmit;
  final VoidCallback? onDeleteRequested;
  final VoidCallback onTerminatePlan;
  final VoidCallback? onPaywallOpened;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    if (state.isLoading) {
      return const Center(child: KinlyLoader(size: 40));
    }
    if (state.loadErrorMessage != null) {
      return Padding(
        padding: EdgeInsetsDirectional.all(spacing.lg),
        child: ShareCreateError(
          message: s.shareCreateLoadError,
          onRetry: onRetry,
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.all(spacing.lg),
            child: KinlyScrollFade(
              child: ShareCreateFormView(
                state: state,
                shareColors: shareColors,
                descriptionController: descriptionController,
                amountController: amountController,
                notesController: notesController,
                recurrenceEveryController: recurrenceEveryController,
                customControllers: customControllers,
                allowDelete: false,
                onDeleteRequested: null,
                showTerminatePlan: false,
                showPrimaryActions: false,
              ),
            ),
          ),
        ),
        ShareCreateActionBar(
          state: state,
          allowDelete: allowDelete,
          onDeleteRequested: onDeleteRequested,
          onSubmit: onSubmit,
          showTerminatePlan: showTerminatePlan,
          isTerminatingPlan: state.isTerminatingPlan,
          onTerminatePlan: onTerminatePlan,
          onPaywallOpened: onPaywallOpened,
        ),
      ],
    );
  }
}
