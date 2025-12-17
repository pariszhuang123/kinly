import 'package:flutter/material.dart';

import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../generated/l10n.dart';
import '../../splash/ui/widgets/kinly_logo.dart';

class OfflineSplash extends StatelessWidget {
  const OfflineSplash({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final colorTokens = theme.extension<KinlyColorTokens>();
    final spacing = theme.extension<Spacing>() ??
        const Spacing(
          xxs: 2,
          xs: 4,
          s: 8,
          m: 12,
          l: 16,
          xl: 24,
          xxl: 32,
          xxxl: 40,
        );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsetsDirectional.all(spacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const KinlyLogo(size: 120),
                const SizedBox(height: 32),
                Text(
                  strings.offline_title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        colors.onSurface, // uses KinlyTheme (light/dark aware)
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  strings.offline_body,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    // Slightly softer body text; still uses the Kinly onSurface color
                    color: (colorTokens?.onSurface ?? colors.onSurface)
                        .withValues(alpha: 0.78),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                KinlyFilledButton.icon(
                  fullWidth: true,
                  onPressed: onRetry,
                  icon: Icons.refresh,
                  label: strings.offline_retry,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
