import 'package:flutter/material.dart';

import '../../theme/spacing.dart';
import '../../theme/color_tokens.dart';
import '../../theme/kinly_palette.dart';
import '../../theme/kinly_sections.dart';
import '../../theme/opacity.dart';
import '../../../generated/l10n.dart';
import 'kinly_fab.dart';
import '../kinly_bottom_sheet.dart';
import '../kinly_list_tile.dart';

class KinlyQuickAddFab extends StatelessWidget {
  const KinlyQuickAddFab({
    super.key,
    required this.onAddFlow,
    required this.onAddShare,
    required this.onAddPoll,
    required this.onAddFairShare,
  });

  final VoidCallback onAddFlow;
  final VoidCallback onAddShare;
  final VoidCallback onAddPoll;
  final VoidCallback onAddFairShare;

  @override
  Widget build(BuildContext context) {
    return KinlyFab(
      onPressed: () => _showQuickAddSheet(context),
      heroTag: 'quick_add_fab',
    );
  }

  void _showQuickAddSheet(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final colors =
        theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;
    final opacities = Theme.of(context).extension<KinlyOpacity>()!;
    final iconTint = colors.onSurface.withValues(alpha: opacities.alphaFaint);
    final s = S.of(context);

    // Get the KinlySections instance from the theme
    final kinlySections =
        theme.extension<KinlySections>()!; // assume it's configured

    final flowColors = kinlySections.flow;
    final shareColors = kinlySections.share;

    final bottomPadding =
        (spacing?.sm ?? 8) + MediaQuery.of(context).padding.bottom;

    KinlyBottomSheet.show(
      context: context,
      title: s.quick_add_title,
      body: Padding(
        padding: EdgeInsetsDirectional.only(bottom: bottomPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _QuickAddTile(
              sectionColors: flowColors,
              leadingIcon: Icons.cleaning_services,
              title: s.quick_add_flow_title, // "Flow"
              subtitle: s.quick_add_flow_subtitle,
              onTap: () {
                Navigator.pop(context);
                onAddFlow();
              },
              trailingColor: iconTint,
            ),
            SizedBox(height: spacing?.sm ?? 8),
            _QuickAddTile(
              sectionColors: shareColors,
              leadingIcon: Icons.favorite,
              title: s.quick_add_share_title, // "Share"
              subtitle: s.quick_add_share_subtitle,
              onTap: () {
                Navigator.pop(context);
                onAddShare();
              },
              trailingColor: iconTint,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAddTile extends StatelessWidget {
  const _QuickAddTile({
    required this.sectionColors,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.trailingColor,
  });

  final SectionColors sectionColors;
  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color trailingColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();

    return KinlyListTile(
      leading: Icon(
        leadingIcon,
        color: sectionColors.icon,
      ),
      title: title,
      subtitle: subtitle,
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: trailingColor,
      ),
      onTap: onTap,
      contentPadding: EdgeInsetsDirectional.fromSTEB(
        0,
        spacing?.xs ?? 4,
        spacing?.xs ?? 4,
        spacing?.xs ?? 4,
      ),
    );
  }
}
