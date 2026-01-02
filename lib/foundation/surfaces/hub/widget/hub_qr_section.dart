// lib/features/hub/ui/hub_qr_section.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../generated/l10n.dart';
import '../bloc/hub_bloc.dart';

class HubQrSection extends StatelessWidget {
  const HubQrSection({
    super.key,
    required this.state,
    required this.onShareAppTap,
    required this.onQrTap,
  });

  final HubState state;
  final VoidCallback onShareAppTap;
  final VoidCallback onQrTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final appLink =
        state.appLink.isNotEmpty ? state.appLink : 'https://kinly.app';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsetsDirectional.all(spacing.md),
      child: Row(
        children: [
          GestureDetector(
            onTap: onQrTap,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(1),
              ),
              padding: EdgeInsetsDirectional.all(spacing.xs),
              child: HubQrCode(
                data: appLink,
                backgroundColor: colorScheme.surface,
                size: 70,
              ),
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KinlyFilledButton.icon(
                  onPressed: onShareAppTap,
                  icon: Icons.ios_share_rounded,
                  label: S.of(context).hubShareAppCta,
                  fullWidth: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable QR widget so you can drop this anywhere in the app.
class HubQrCode extends StatelessWidget {
  const HubQrCode({
    super.key,
    required this.data,
    required this.backgroundColor,
    this.isDarkOverride,
    this.size = 250,
  });

  final String data;
  final Color backgroundColor;
  final bool? isDarkOverride;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark =
        isDarkOverride ?? Theme.of(context).brightness == Brightness.dark;

    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      eyeStyle: QrEyeStyle(color: isDark ? Colors.white : Colors.black),
      dataModuleStyle: QrDataModuleStyle(
        color: isDark ? Colors.white : Colors.black,
        dataModuleShape: QrDataModuleShape.square,
      ),
      backgroundColor: backgroundColor,
    );
  }
}
