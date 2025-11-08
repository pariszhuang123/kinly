import 'package:flutter/material.dart';

class KinlyButton extends StatelessWidget {
  const KinlyButton.primary({
    super.key,
    required this.onPressed,
    required this.label,
  }) : variant = KinlyButtonVariant.primary;

  final VoidCallback? onPressed;
  final String label;
  final KinlyButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.elevatedButtonTheme.style;
    final cs = theme.colorScheme;
    final bg =
        variant == KinlyButtonVariant.primary ? cs.primary : cs.secondary;
    final fg =
        variant == KinlyButtonVariant.primary ? cs.onPrimary : cs.onSecondary;
    final style = baseStyle?.copyWith(
      backgroundColor: WidgetStatePropertyAll(bg),
      foregroundColor: WidgetStatePropertyAll(fg),
    );
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Text(label),
    );
  }
}

enum KinlyButtonVariant { primary }
