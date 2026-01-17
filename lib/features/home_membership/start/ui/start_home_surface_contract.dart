import 'package:flutter/widgets.dart';

import '../../../../generated/l10n.dart';

class StartHomeSurfaceSlots {
  const StartHomeSurfaceSlots({
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

class StartHomeSurfaceActions {
  const StartHomeSurfaceActions({required this.onCreate, required this.onJoin});

  final VoidCallback onCreate;
  final VoidCallback onJoin;
}

class StartHomeSurfaceScope {
  const StartHomeSurfaceScope({
    required this.context,
    required this.strings,
    required this.membershipMessage,
    required this.isCreating,
    required this.canPress,
    required this.actions,
    this.personalizedTitle,
    this.personalizedSubtitle,
    this.isPersonalized = false,
  });

  final BuildContext context;
  final S strings;
  final String membershipMessage;
  final bool isCreating;
  final bool canPress;
  final StartHomeSurfaceActions actions;
  final String? personalizedTitle;
  final String? personalizedSubtitle;
  final bool isPersonalized;
}
