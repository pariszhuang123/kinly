// lib/features/hub/ui/hub_qr_section.dart
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../core/ui/kinly_tap_target.dart';
import '../../../../core/ui/kinly_icons.dart';
import '../../../../generated/l10n.dart';
import '../bloc/hub_bloc.dart';
import '../../../../core/ui/kinly_theme_access.dart';

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
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final appLink =
        state.appLink.isNotEmpty ? state.appLink : 'https://go.makinglifeeasie.com/kinly';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsetsDirectional.all(spacing.md),
      child: Row(
        children: [
          KinlyTapTarget(
            onTap: onQrTap,
            borderRadius: BorderRadius.circular(1),
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
                  icon: KinlyIcons.iosShareRounded,
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
    this.size = 250,
  });

  final String data;
  final Color backgroundColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = KinlyThemeAccess.of(context).colorScheme;
    final qrColor = colorScheme.onSurface;

    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      eyeStyle: QrEyeStyle(color: qrColor),
      dataModuleStyle: QrDataModuleStyle(
        color: qrColor,
        dataModuleShape: QrDataModuleShape.square,
      ),
      backgroundColor: backgroundColor,
    );
  }
}
