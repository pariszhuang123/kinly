import 'package:flutter/material.dart';

import '../../theme/spacing.dart';
import '../../theme/kinly_sections.dart';
import '../../../generated/l10n.dart';
import 'kinly_fab.dart';

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
    final s = S.of(context);

    // Get the KinlySections instance from the theme
    final kinlySections =
        theme.extension<KinlySections>()!; // assume it's configured

    final flowColors = kinlySections.flow;
    final shareColors = kinlySections.share;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              spacing?.lg ?? 16,
              spacing?.md ?? 12,
              spacing?.lg ?? 16,
              (spacing?.sm ?? 8) + MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    s.quick_add_title, // e.g. "Quick Add"
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                SizedBox(height: spacing?.md ?? 12),
                const Divider(height: 1),

                _QuickAddTile(
                  sectionColors: flowColors,
                  leadingIcon: Icons.cleaning_services,
                  title: s.quick_add_flow_title, // "Flow"
                  subtitle: s.quick_add_flow_subtitle,
                  onTap: () {
                    Navigator.pop(context);
                    onAddFlow();
                  },
                ),
                _QuickAddTile(
                  sectionColors: shareColors,
                  leadingIcon: Icons.favorite,
                  title: s.quick_add_share_title, // "Share"
                  subtitle: s.quick_add_share_subtitle,
                  onTap: () {
                    Navigator.pop(context);
                    onAddShare();
                  },
                ),
              ],
            ),
          ),
        );
      },
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
  });

  final SectionColors sectionColors;
  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: spacing?.xs ?? 4,
      ),
      leading: Icon(
        leadingIcon,
        color: sectionColors.accent, // use your section accent
      ),
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: Text(subtitle, style: theme.textTheme.bodyMedium),
      onTap: onTap,
    );
  }
}
