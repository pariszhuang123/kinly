import 'package:flutter/material.dart';

import '../theme/control_tokens.dart';
import '../theme/kinly_palette.dart';
import '../theme/spacing.dart';

/// Reusable Kinly-styled multiline comment box.
///
/// - Adapts to light/dark using ThemeData by default.
class KinlyCommentBox extends StatelessWidget {
  const KinlyCommentBox({
    super.key,
    required this.label,
    this.hint,
    this.maxLines = 4,
    this.maxLength = 500,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final String? hint;
  final int maxLines;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final controls =
        theme.extension<KinlyControlColors>() ??
        KinlyPalette.build(theme.brightness).controlColors;
    final fillColor = controls.commentBoxBg;
    final borderColor = controls.commentBoxBorder;

    return TextField(
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: '',
        filled: true,
        fillColor: fillColor,
        contentPadding: EdgeInsetsDirectional.fromSTEB(
          spacing.md,
          spacing.md,
          spacing.md,
          spacing.md,
        ),
        border:
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
