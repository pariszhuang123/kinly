import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../splash/ui/widgets/kinly_logo.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';

class OfflineSplash extends StatelessWidget {
  const OfflineSplash({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
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
                    color: colors.onSurface.withAlpha(
                      isDark ? 210 : 185,
                      // 210 ≈ 82% alpha
                      // 185 ≈ 72% alpha
                    ),
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
