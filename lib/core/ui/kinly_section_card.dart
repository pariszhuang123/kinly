import 'package:flutter/widgets.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/section_container.dart';
import 'package:kinly/core/ui/enums/kinly_section_card_visual_position.dart';

/// A standardized card component wrapping a [SectionContainer] with common layout.
///
/// Features:
/// - Header (via [SectionContainer])
/// - Title & Summary
/// - Visual (Image/Glyph) positioned Left or Right
/// - Tags/Badges below summary
/// - Footer section at the bottom
/// - Optional tap handling
/// - Optional trailing widget
class KinlySectionCard extends StatelessWidget {
  const KinlySectionCard({
    super.key,
    required this.header,
    required this.palette,
    required this.title,
    this.summary,
    this.summaryMaxLines,
    this.visual,
    this.visualPosition = KinlySectionCardVisualPosition.right,
    this.tags,
    this.footer,
    this.trailing,
    this.onTap,
  });

  final String header;
  final SectionColors palette;
  final String title;
  final String? summary;
  final int? summaryMaxLines;
  final Widget? visual;
  final KinlySectionCardVisualPosition visualPosition;
  final Widget? tags;
  final Widget? footer;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    Widget content = SectionContainer(
      title: header,
      colors: palette,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (visual != null &&
                  visualPosition == KinlySectionCardVisualPosition.left) ...[
                visual!,
                SizedBox(width: spacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: palette.accent,
                      ),
                    ),
                    if (summary != null && summary!.isNotEmpty) ...[
                      SizedBox(height: spacing.xs),
                      Text(
                        summary!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: summaryMaxLines,
                        overflow:
                            summaryMaxLines != null
                                ? TextOverflow.ellipsis
                                : null,
                      ),
                    ],
                    if (tags != null) ...[SizedBox(height: spacing.sm), tags!],
                  ],
                ),
              ),
              if (visual != null &&
                  visualPosition == KinlySectionCardVisualPosition.right) ...[
                SizedBox(width: spacing.md),
                visual!,
              ],
              if (trailing != null) ...[SizedBox(width: spacing.sm), trailing!],
            ],
          ),
          if (footer != null) ...[SizedBox(height: spacing.md), footer!],
        ],
      ),
    );

    if (onTap != null) {
      return KinlyTapTarget(
        onTap: onTap!,
        borderRadius: BorderRadius.circular(24),
        child: content,
      );
    }

    return content;
  }
}
