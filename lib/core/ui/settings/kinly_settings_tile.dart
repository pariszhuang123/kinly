import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';
import '../kinly_loader.dart';

class KinlySettingsTile extends StatelessWidget {
  const KinlySettingsTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.destructive = false,
    this.showProgress = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final bool destructive;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final colors = theme.extension<KinlyColorTokens>();
    final type = theme.extension<KinlyTypography>();
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final primary = colors?.primary ?? colorScheme.primary;
    final error = colors?.error ?? colorScheme.error;

    // ── Leading icon + avatar colors ────────────────────────────────────────
    late final Color leadingColor;
    late final Color avatarBackground;

    if (destructive) {
      // Destructive is always “error-ish” in both light & dark.
      leadingColor = error;
      avatarBackground = error.withValues(alpha: isDark ? 0.20 : 0.12);
    } else {
      if (isDark) {
        // In dark mode, align with KinlyFilledButton:
        // use onSurface as the main icon color so it’s always readable.
        leadingColor = colorScheme.onSurface;
        // Soft halo using onSurface at low alpha.
        avatarBackground = colorScheme.onSurface.withValues(alpha: 0.16);
      } else {
        // Light mode: use primary, as before.
        leadingColor = primary;
        avatarBackground = primary.withValues(alpha: 0.12);
      }
    }

    // ── Text styles ─────────────────────────────────────────────────────────
    final titleStyle =
        (type?.titleMedium ?? theme.textTheme.titleMedium)?.copyWith(
          fontWeight: FontWeight.w600,
          color: destructive ? error : colorScheme.onSurface,
        );

    final subtitleStyle =
        (type?.bodyMedium ?? theme.textTheme.bodyMedium)?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );

    // ── Trailing chevron / loader ──────────────────────────────────────────
    final trailingWidget = showProgress
        ? SizedBox(
            width: 20,
            height: 20,
            child: KinlyLoader(size: 18, color: leadingColor),
          )
        : Icon(
            Icons.chevron_right,
            color: colorScheme.onSurfaceVariant,
          );

    return ListTile(
      contentPadding: EdgeInsetsDirectional.fromSTEB(
        spacing?.l ?? 16,
        spacing?.s ?? 8,
        spacing?.l ?? 16,
        spacing?.s ?? 8,
      ),
      leading: CircleAvatar(
        backgroundColor: avatarBackground,
        child: Icon(icon, color: leadingColor),
      ),
      title: Text(title, style: titleStyle),
      subtitle: Text(subtitle, style: subtitleStyle),
      trailing: trailingWidget,
      onTap: showProgress ? null : onTap,
    );
  }
}
