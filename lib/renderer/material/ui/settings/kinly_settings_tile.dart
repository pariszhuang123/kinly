import 'package:flutter/material.dart';

import '../../theme/control_tokens.dart';
import '../../theme/kinly_palette.dart';
import '../../theme/color_tokens.dart';
import '../../theme/spacing.dart';
import '../../theme/opacity.dart';
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
    final spacing = theme.extension<Spacing>()!;
    final controls =
        theme.extension<KinlyControlColors>() ??
        KinlyPalette.build(theme.brightness).controlColors;
    final opacities = theme.extension<KinlyOpacity>()!;
    final type = theme.extension<KinlyTypography>();
    final tokens =
        theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;
    final primary = controls.filledBg;
    final error = controls.filledDestructiveBg;

    late final Color leadingColor;
    late final Color avatarBackground;

    if (destructive) {
      leadingColor = controls.errorBadgeFg;
      avatarBackground = controls.errorBadgeBg;
    } else {
      leadingColor = tokens.onSurface;
      avatarBackground = primary.withValues(alpha: opacities.alphaSM);
    }

    final titleStyle =
        (type?.titleMedium ?? theme.textTheme.titleMedium)?.copyWith(
          fontWeight: FontWeight.w600,
          color: destructive ? error : tokens.onSurface,
        );

    final subtitleStyle =
        (type?.bodyMedium ?? theme.textTheme.bodyMedium)?.copyWith(
          color: tokens.onSurface.withValues(alpha: opacities.alphaFaint),
        );

    final trailingWidget = showProgress
        ? SizedBox(
            width: 20,
            height: 20,
            child: KinlyLoader(size: 18, color: leadingColor),
          )
        : Icon(
            Icons.chevron_right,
            color: tokens.onSurface.withValues(alpha: opacities.alphaFaint),
          );

    return ListTile(
      contentPadding: EdgeInsetsDirectional.fromSTEB(
        spacing.l,
        spacing.s,
        spacing.l,
        spacing.s,
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
