import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/kinly_palette.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';

/// Kinly-styled dropdown field built on top of DropdownButtonFormField.
class KinlyDropdownField<T> extends StatelessWidget {
  const KinlyDropdownField({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.errorText,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? labelText;
  final String? hintText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;
    final corners = theme.extension<Corners>();
    final spacing = theme.extension<Spacing>();
    final type = theme.extension<KinlyTypography>();

    final borderRadius = BorderRadius.circular(corners?.medium ?? 12);
    final outlineColor = colors.outline;
    final focusedColor = colors.primary;
    final errorColor = colors.error;

    InputBorder outline(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: color, width: width),
        );

    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        filled: true,
        fillColor: colors.surfaceVariant,
        contentPadding: EdgeInsetsDirectional.fromSTEB(
          spacing?.l ?? 16,
          spacing?.m ?? 12,
          spacing?.l ?? 16,
          spacing?.m ?? 12,
        ),
        border: outline(outlineColor),
        enabledBorder: outline(outlineColor),
        focusedBorder: outline(focusedColor, 1.4),
        errorBorder: outline(errorColor),
        focusedErrorBorder: outline(errorColor, 1.4),
        labelStyle: type?.bodyMedium ??
            theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        hintStyle: type?.bodyMedium ??
            theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
      ),
      style: type?.bodyMedium ?? theme.textTheme.bodyMedium,
      iconEnabledColor: colors.onSurface,
      iconDisabledColor: colors.disabled,
      dropdownColor: colors.surface,
    );
  }
}
