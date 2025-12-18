import 'package:flutter/material.dart';

import '../theme/kinly_sections.dart';
import '../theme/kinly_palette.dart';
import '../theme/color_tokens.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';

/// Reusable selection card used in Explore/Hub etc.
///
/// Shows:
/// - Section-colored icon tile
/// - Title + subtitle
/// - Chevron on the right
class KinlySelectionCard extends StatelessWidget {
  const KinlySelectionCard({
    super.key,
    required this.colors,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final SectionColors colors;
  final String title;
  final String subtitle;

  /// Now a Widget so we can pass Icon, SvgPicture, etc.
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final corners = theme.extension<Corners>();
    final tokens =
        theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;

    return Semantics(
      button: true,
      enabled: true,
      label: '$title, $subtitle',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(corners?.xlarge ?? 24),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(spacing.lg),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(corners?.xlarge ?? 24),
              ),
              child: Row(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: colors.icon.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(corners?.medium ?? 12),
                    ),
                    child: Center(
                      child: icon, // <- use the widget directly
                    ),
                  ),
                  SizedBox(width: spacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: tokens.onSurface,
                          ),
                        ),
                        SizedBox(height: spacing.xs),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: tokens.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: tokens.onSurface.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
