import 'package:flutter/widgets.dart';

import '../../../../generated/l10n.dart';

class JoinHomeBlockedSurfaceSlots {
  const JoinHomeBlockedSurfaceSlots({
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

class JoinHomeBlockedSurfaceActions {
  const JoinHomeBlockedSurfaceActions({required this.onBack});

  final VoidCallback onBack;
}

class JoinHomeBlockedSurfaceScope {
  const JoinHomeBlockedSurfaceScope({
    required this.context,
    required this.strings,
    required this.actions,
  });

  final BuildContext context;
  final S strings;
  final JoinHomeBlockedSurfaceActions actions;
}

