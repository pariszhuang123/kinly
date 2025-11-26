import 'package:flutter/material.dart';

/// Kinly-branded FAB that adapts to light/dark mode.
///
/// Colors mirror `KinlyAddTileButton`:
/// - Light: primaryContainer background, onPrimaryContainer icon
/// - Dark:  surfaceVariant background, onSurface icon
class KinlyFab extends StatelessWidget {
  const KinlyFab({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
    this.tooltip,
    this.heroTag,
    this.mini = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;
  final Object? heroTag;
  final bool mini;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final bg =
        backgroundColor ??
        (isDark
            ? colorScheme.secondaryContainer
            : colorScheme.primaryContainer);

    final fg =
        foregroundColor ??
        (isDark
            ? colorScheme.onSecondaryContainer
            : colorScheme.onPrimaryContainer);

    return FloatingActionButton(
      heroTag: heroTag,
      tooltip: tooltip,
      mini: mini,
      backgroundColor: bg,
      foregroundColor: fg,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
