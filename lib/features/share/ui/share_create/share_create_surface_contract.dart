import 'package:flutter/widgets.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/share_create_bloc/share_create_bloc.dart';

class ShareCreateSurfaceSlots {
  const ShareCreateSurfaceSlots({
    this.header,
    required this.body,
    this.empty,
    this.footer,
    this.actions,
  });

  final Widget? header;
  final Widget body;
  final Widget? empty;
  final Widget? footer;
  final List<Widget>? actions;
}

class ShareCreateSurfaceActions {
  const ShareCreateSurfaceActions({
    required this.onRetry,
    required this.onSubmit,
    required this.onDeleteRequested,
    required this.onTerminatePlan,
    required this.onPaywallOpened,
    required this.onEvidencePhotoCapture,
  });

  final VoidCallback onRetry;
  final VoidCallback onSubmit;
  final VoidCallback? onDeleteRequested;
  final VoidCallback onTerminatePlan;
  final VoidCallback? onPaywallOpened;
  final VoidCallback onEvidencePhotoCapture;
}

class ShareCreateSurfaceScope {
  const ShareCreateSurfaceScope({
    required this.context,
    required this.state,
    required this.spacing,
    required this.sections,
    required this.strings,
    required this.actions,
    required this.allowDelete,
    required this.showTerminatePlan,
    required this.descriptionController,
    required this.amountController,
    required this.notesController,
    required this.recurrenceEveryController,
    required this.customControllers,
    required this.evidencePhotoUrl,
    required this.isUploadingEvidencePhoto,
  });

  final BuildContext context;
  final ShareCreateState state;
  final Spacing spacing;
  final KinlySections? sections;
  final S strings;
  final ShareCreateSurfaceActions actions;
  final bool allowDelete;
  final bool showTerminatePlan;
  final TextEditingController descriptionController;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final TextEditingController recurrenceEveryController;
  final Map<String, TextEditingController> customControllers;
  final String? evidencePhotoUrl;
  final bool isUploadingEvidencePhoto;
}
