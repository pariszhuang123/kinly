import 'package:flutter/material.dart';

class KinlySettingsCard extends StatelessWidget {
  const KinlySettingsCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
