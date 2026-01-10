import 'package:flutter/widgets.dart';

import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/opacity.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../generated/l10n.dart';
import '../../../core/ui/branding/kinly_logo.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_theme_access.dart';
import '../../../core/ui/kinly_icons.dart';

class OfflineSplash extends StatelessWidget {
  const OfflineSplash({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final colors = theme.colorScheme;
    final colorTokens = theme.extension<KinlyColorTokens>();
    final opacities = theme.extension<KinlyOpacity>()!;
    final spacing = theme.extension<Spacing>()!;

    return KinlyScaffold(
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
                        .withValues(alpha: opacities.alphaFaintStrong),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                KinlyFilledButton.icon(
                  fullWidth: true,
                  onPressed: onRetry,
                  icon: KinlyIcons.refresh,
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
