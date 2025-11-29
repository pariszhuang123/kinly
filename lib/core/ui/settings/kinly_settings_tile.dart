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
    final leadingColor =
        destructive
            ? (colors?.error ?? colorScheme.error)
            : (colors?.primary ?? colorScheme.primary);

    final titleStyle =
        (type?.titleMedium ?? theme.textTheme.titleMedium)?.copyWith(
          fontWeight: FontWeight.w600,
          color: destructive
              ? (colors?.error ?? colorScheme.error)
              : colorScheme.onSurface,
        );

    final subtitleStyle =
        (type?.bodyMedium ?? theme.textTheme.bodyMedium)?.copyWith(
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
        backgroundColor: leadingColor.withValues(alpha: 0.12),
        child: Icon(icon, color: leadingColor),
      ),
      title: Text(title, style: titleStyle),
      subtitle: Text(subtitle, style: subtitleStyle),
      trailing:
          showProgress
              ? SizedBox(
                width: 20,
                height: 20,
                child: KinlyLoader(size: 18, color: leadingColor),
              )
              : const Icon(Icons.chevron_right),
      onTap: showProgress ? null : onTap,
    );
  }
}
