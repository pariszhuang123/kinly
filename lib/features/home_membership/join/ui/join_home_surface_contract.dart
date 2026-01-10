import 'package:flutter/widgets.dart';

class JoinHomeSurfaceSlots {
  const JoinHomeSurfaceSlots({
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

class JoinHomeSurfaceScope {
  const JoinHomeSurfaceScope({
    required this.context,
    required this.initialCode,
  });

  final BuildContext context;
  final String initialCode;
}
