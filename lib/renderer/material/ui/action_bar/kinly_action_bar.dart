import 'package:flutter/material.dart';

import '../../theme/spacing.dart';
import '../buttons/kinly_filled_button.dart';
import '../buttons/kinly_outlined_button.dart';
import '../kinly_loader.dart';
import '../enums/kinly_action_button_varient.dart';

class KinlyActionButton {
  const KinlyActionButton({
    required this.label,
    required this.onPressed,
    this.destructive = false,
    this.busy = false,
    this.disabled = false,
    this.variant = KinlyActionButtonVariant.filled,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool destructive;
  final bool busy;
  final bool disabled;
  final KinlyActionButtonVariant variant;
}

class KinlyActionBar extends StatelessWidget {
  const KinlyActionBar({
    super.key,
    required this.primary,
    this.secondary,
    this.includeSafeArea = true,
    this.padding,
  });

  final KinlyActionButton primary;
  final KinlyActionButton? secondary;
  final bool includeSafeArea;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    Widget content = _buttons(context);
    if (includeSafeArea) {
      content = SafeArea(top: false, child: content);
    }
    return content;
  }

  Widget _buttons(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;
    final effectivePadding =
        padding ??
        EdgeInsetsDirectional.fromSTEB(
          spacing.lg,
          spacing.md,
          spacing.lg,
          spacing.lg,
        );

    return Padding(
      padding: effectivePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildButton(context, primary),
          if (secondary != null) ...[
            SizedBox(height: spacing.md),
            _buildButton(context, secondary!),
          ],
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, KinlyActionButton config) {
    final onTap = config.disabled ? null : config.onPressed;
    final Widget button =
        config.variant == KinlyActionButtonVariant.outlined
            ? KinlyOutlinedButton.text(
              fullWidth: true,
              onPressed: onTap,
              label: config.label,
            )
            : KinlyFilledButton.text(
              fullWidth: true,
              onPressed: onTap,
              label: config.label,
              destructive: config.destructive,
            );

    if (!config.busy) return button;

    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 0.6, child: button),
        const SizedBox(height: 20, width: 20, child: KinlyLoader(size: 20)),
      ],
    );
  }
}
