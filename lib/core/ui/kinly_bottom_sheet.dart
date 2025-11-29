import 'package:flutter/material.dart';

import '../theme/color_tokens.dart';
import '../theme/elevation.dart';
import '../theme/motion.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';

class KinlyBottomSheet extends StatelessWidget {
  const KinlyBottomSheet({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    this.footer = const [],
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget> footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colorScheme = theme.colorScheme;
    final colors = theme.extension<KinlyColorTokens>();
    final corners = theme.extension<Corners>();
    final elevations = theme.extension<Elevations>();
    final motion = theme.extension<Motion>();
    final media = MediaQuery.of(context);
    final bottomPadding = media.viewPadding.bottom + media.viewInsets.bottom;
    final radius = corners?.xlarge ?? 24.0;

    return SafeArea(
      child: AnimatedPadding(
        padding: EdgeInsetsDirectional.fromSTEB(
          spacing.lg,
          spacing.lg,
          spacing.lg,
          spacing.lg + bottomPadding,
        ),
        duration: motion?.durationMedium ?? const Duration(milliseconds: 200),
        curve: motion?.easeEmotional ?? Curves.easeOutCubic,
        child: Material(
          elevation: elevations?.level4 ?? 10,
          color: colors?.surface ?? colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              spacing.xl,
              spacing.m,
              spacing.xl,
              spacing.m,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: spacing.md),

                  // Title
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Subtitle (optional)
                  if (subtitle != null) ...[
                    SizedBox(height: spacing.sm),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  SizedBox(height: spacing.lg),

                  // Main body
                  body,

                  // Footer actions (optional)
                  if (footer.isNotEmpty) ...[
                    SizedBox(height: spacing.xl),
                    ...footer,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
