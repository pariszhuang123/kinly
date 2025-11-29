import 'package:flutter/material.dart';

import '../theme/color_tokens.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';
import '../theme/typography_tokens.dart';
import 'buttons/kinly_filled_button.dart';

/// Reusable empty state: icon/illustration + title + body + optional CTA.
class KinlyEmptyState extends StatelessWidget {
  const KinlyEmptyState({
    super.key,
    this.icon,
    required this.title,
    this.body,
    this.ctaLabel,
    this.onCtaTap,
  });

  final Widget? icon;
  final String title;
  final String? body;
  final String? ctaLabel;
  final VoidCallback? onCtaTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final colors = theme.extension<KinlyColorTokens>();
    final type = theme.extension<KinlyTypography>();
    final corners = theme.extension<Corners>();
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing?.xl ?? 24),
      decoration: BoxDecoration(
        color: colors?.surfaceVariant ?? colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(corners?.large ?? 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            SizedBox(height: spacing?.m ?? 12),
          ],
          Text(
            title,
            style: type?.titleLarge ?? theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          if (body != null) ...[
            SizedBox(height: spacing?.s ?? 8),
            Text(
              body!,
              style: type?.bodyMedium ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
          if (ctaLabel != null && onCtaTap != null) ...[
            SizedBox(height: spacing?.l ?? 16),
            KinlyFilledButton.text(
              onPressed: onCtaTap,
              label: ctaLabel!,
              fullWidth: true,
            ),
          ],
        ],
      ),
    );
  }
}
