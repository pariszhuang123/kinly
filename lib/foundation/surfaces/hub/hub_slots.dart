import 'package:flutter/widgets.dart';

import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n.dart';
import 'bloc/hub_bloc.dart';

class HubSurfaceSlots {
  const HubSurfaceSlots({
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

class HubSurfaceActions {
  const HubSurfaceActions({
    required this.onInviteTap,
    required this.onShareAppTap,
    required this.onQrTap,
    required this.onHouseDirectoryTap,
    required this.onHouseNormsTap,
    required this.onGratitudeTap,
    this.onCopyCode,
    this.onRotateInvite,
  });

  final VoidCallback onInviteTap;
  final VoidCallback onShareAppTap;
  final VoidCallback onQrTap;
  final VoidCallback onHouseDirectoryTap;
  final VoidCallback onHouseNormsTap;
  final VoidCallback onGratitudeTap;
  final VoidCallback? onCopyCode;
  final VoidCallback? onRotateInvite;
}

class HubSurfaceScope {
  const HubSurfaceScope({
    required this.context,
    required this.state,
    required this.spacing,
    required this.sections,
    required this.strings,
    required this.actions,
    required this.homeId,
  });

  final BuildContext context;
  final HubState state;
  final Spacing spacing;
  final KinlySections sections;
  final S strings;
  final HubSurfaceActions actions;
  final String homeId;
}
