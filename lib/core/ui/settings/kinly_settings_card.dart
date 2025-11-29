import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/radius.dart';

class KinlySettingsCard extends StatelessWidget {
  const KinlySettingsCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<KinlyColorTokens>();
    final corners = theme.extension<Corners>();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(corners?.large ?? 16),
      ),
      color:
          colors?.surfaceVariant ??
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
