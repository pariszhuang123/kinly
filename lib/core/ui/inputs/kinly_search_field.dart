import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';

/// Kinly-styled search field with leading search icon and optional clear action.
class KinlySearchField extends StatelessWidget {
  const KinlySearchField({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
    this.onClear,
  });

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<KinlyColorTokens>();
    final corners = theme.extension<Corners>();
    final spacing = theme.extension<Spacing>();
    final type = theme.extension<KinlyTypography>();
    final colorScheme = theme.colorScheme;

    final borderRadius = BorderRadius.circular(corners?.medium ?? 12);
    final outlineColor = colors?.outline ?? colorScheme.outline;
    final focusedColor = colors?.primary ?? colorScheme.primary;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor:
            colors?.surfaceVariant ?? colorScheme.surfaceContainerHighest,
        contentPadding: EdgeInsetsDirectional.fromSTEB(
          spacing?.l ?? 16,
          spacing?.s ?? 8,
          spacing?.l ?? 16,
          spacing?.s ?? 8,
        ),
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            controller.text.isNotEmpty && onClear != null
                ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClear,
                )
                : null,
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
        labelStyle: type?.bodyMedium ??
            theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        hintStyle: type?.bodyMedium ??
            theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
      ),
      style: type?.bodyMedium ?? theme.textTheme.bodyMedium,
    );
  }
}
