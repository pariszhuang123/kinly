import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/color_tokens.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';

/// Kinly-styled text field wrapper that applies tokens for padding, radius,
/// colors, and typography.
class KinlyTextField extends StatelessWidget {
  const KinlyTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.obscureText = false,
    this.inputFormatters,
    this.autocorrect = true,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final String? errorText;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final bool autocorrect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<KinlyColorTokens>();
    final corners = theme.extension<Corners>();
    final spacing = theme.extension<Spacing>();
    final type = theme.extension<KinlyTypography>();

    final borderRadius = BorderRadius.circular(corners?.md ?? 12);
    final outlineColor = colors?.outline ?? theme.colorScheme.outline;
    final errorColor = colors?.error ?? theme.colorScheme.error;
    final focusedColor = colors?.primary ?? theme.colorScheme.primary;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
      enabled: enabled,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      autocorrect: autocorrect,
      style: type?.bodyMedium ?? theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
        filled: true,
        fillColor:
            colors?.surfaceVariant ??
            theme.colorScheme.surfaceContainerHighest,
        contentPadding: EdgeInsetsDirectional.fromSTEB(
          spacing?.l ?? 16,
          spacing?.m ?? 12,
          spacing?.l ?? 16,
          spacing?.m ?? 12,
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: outlineColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: outlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: focusedColor, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: errorColor, width: 1.4),
        ),
        labelStyle: type?.bodyMedium ??
            theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        hintStyle: type?.bodyMedium ??
            theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
      ),
    );
  }
}
