import 'package:flutter/material.dart';
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
    final colorScheme = theme.colorScheme;
    final leadingColor = destructive ? colorScheme.error : colorScheme.primary;

    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: destructive ? colorScheme.error : colorScheme.onSurface,
    );

    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return ListTile(
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
