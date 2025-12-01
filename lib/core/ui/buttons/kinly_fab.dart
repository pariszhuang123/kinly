import 'package:flutter/material.dart';

/// Kinly-branded FAB that adapts to light/dark mode.
///
/// Colors now mirror KinlyAddTileButton & KinlyTabBar:
/// - Light: primaryContainer background, onPrimaryContainer icon
/// - Dark:  inverseSurface background, onInverseSurface icon
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
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Align with KinlyAddTileButton & KinlyTabBar
    final Color bg =
        backgroundColor ?? (isDark ? colors.primaryContainer : colors.primary);

    final Color fg =
        foregroundColor ?? (isDark ? colors.onSurface : colors.onPrimary);

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
