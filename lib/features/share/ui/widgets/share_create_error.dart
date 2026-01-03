import 'package:flutter/widgets.dart';

import '../../../../../core/theme/spacing.dart';
import '../../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../../generated/l10n.dart';
import '../../../../core/ui/kinly_theme_access.dart';

class ShareCreateError extends StatelessWidget {
  const ShareCreateError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.md),
          KinlyFilledButton.text(
            fullWidth: true,
            onPressed: onRetry,
            label: s.shareCreateRetry,
          ),
        ],
      ),
    );
  }
}




