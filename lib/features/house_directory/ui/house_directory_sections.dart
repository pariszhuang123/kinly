import 'package:flutter/widgets.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/kinly_bottom_sheet.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kinly/renderer/material/kinly_icons.dart';

class HouseDirectorySectionHeader extends StatelessWidget {
  const HouseDirectorySectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final sectionColors = context.houseNormSection;
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing.md,
        spacing.sm,
        spacing.md,
        spacing.sm,
      ),
      decoration: BoxDecoration(
        color: sectionColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: sectionColors.accent,
              ),
            ),
          ),
          if (actionLabel != null && onAction != null)
            KinlyOutlinedButton.text(
              onPressed: onAction,
              label: actionLabel!,
              compact: true,
            ),
        ],
      ),
    );
  }
}

class HouseDirectorySurfaceCard extends StatelessWidget {
  const HouseDirectorySurfaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final card = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border:
            borderColor == null ? null : Border.all(color: borderColor!),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      child: child,
    );
    if (onTap == null) return card;
    return KinlyTapTarget(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      alignment: AlignmentDirectional.centerStart,
      child: card,
    );
  }
}

class HouseDirectoryEmptyCard extends StatelessWidget {
  const HouseDirectoryEmptyCard({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    return HouseDirectorySurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(message, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class HouseDirectoryWifiCardContent extends StatelessWidget {
  const HouseDirectoryWifiCardContent({
    super.key,
    required this.wifi,
    required this.isOwner,
  });

  final HouseDirectoryWifi? wifi;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    if (wifi == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isOwner
                ? s.houseDirectoryWifiOwnerEmpty
                : s.houseDirectoryWifiMemberEmpty,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: KinlyTapTarget(
            onTap: () => _showWifiQrSheet(context, wifi!),
            borderRadius: BorderRadius.circular(12),
            alignment: AlignmentDirectional.center,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.all(spacing.sm),
                child: QrImageView(
                  data: wifi!.qrPayload,
                  version: QrVersions.auto,
                  size: 136,
                  eyeStyle: QrEyeStyle(color: theme.colorScheme.onSurface),
                  dataModuleStyle: QrDataModuleStyle(
                    color: theme.colorScheme.onSurface,
                    dataModuleShape: QrDataModuleShape.square,
                  ),
                  backgroundColor: theme.colorScheme.surface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showWifiQrSheet(
    BuildContext context,
    HouseDirectoryWifi wifi,
  ) async {
    await KinlyBottomSheet.show<void>(
      context: context,
      title: S.of(context).houseDirectoryWifiTitle,
      body: _WifiQrSheetBody(wifi: wifi),
    );
  }
}

class _WifiQrSheetBody extends StatelessWidget {
  const _WifiQrSheetBody({required this.wifi});

  final HouseDirectoryWifi wifi;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing.md),
          child: QrImageView(
            data: wifi.qrPayload,
            version: QrVersions.auto,
            size: 280,
            eyeStyle: QrEyeStyle(color: theme.colorScheme.onSurface),
            dataModuleStyle: QrDataModuleStyle(
              color: theme.colorScheme.onSurface,
              dataModuleShape: QrDataModuleShape.square,
            ),
            backgroundColor: theme.colorScheme.surface,
          ),
        ),
      ),
    );
  }
}

class HouseDirectoryServiceCard extends StatelessWidget {
  const HouseDirectoryServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  final HouseDirectoryService service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final s = S.of(context);
    final serviceLabel =
        service.serviceType == HouseDirectoryServiceType.other
            ? (service.customLabel?.trim().isNotEmpty == true
                ? service.customLabel!.trim()
                : s.houseDirectoryServiceOther)
            : service.serviceType.wireValue;
    final metadataIcons = <IconData>[
      if ((service.linkUrl ?? '').trim().isNotEmpty) KinlyIcons.openInNew,
      if ((service.accountReference ?? '').trim().isNotEmpty)
        KinlyIcons.menuBookOutlined,
      if ((service.notes ?? '').trim().isNotEmpty) KinlyIcons.notesOutlined,
      if (service.termStartDate != null || service.termEndDate != null)
        KinlyIcons.calendarTodayRounded,
      if (service.reminder != null) KinlyIcons.notificationsActiveOutlined,
    ];
    return HouseDirectorySurfaceCard(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 260;
          final icons = Wrap(
            spacing: 6,
            runSpacing: 6,
            children: metadataIcons
                .map(
                  (icon) => Icon(
                    icon,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
                .toList(growable: false),
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        service.providerName,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      serviceLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
                if (metadataIcons.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  icons,
                ],
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        service.providerName,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    if (metadataIcons.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Flexible(child: icons),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                serviceLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          );
        },
      ),
    );
  }
}

class HouseDirectoryNoteCard extends StatelessWidget {
  const HouseDirectoryNoteCard({
    super.key,
    required this.note,
    required this.onTap,
  });

  final HouseDirectoryNote note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final metadataIcons = <IconData>[
      if (note.referenceUrl?.isNotEmpty == true) KinlyIcons.openInNew,
      if (note.photoPath?.isNotEmpty == true) KinlyIcons.photoCameraOutlined,
    ];
    return HouseDirectorySurfaceCard(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 220;
          final icons = Wrap(
            spacing: 6,
            runSpacing: 6,
            children: metadataIcons
                .map(
                  (icon) => Icon(
                    icon,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
                .toList(growable: false),
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.title, style: theme.textTheme.titleSmall),
                if (metadataIcons.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  icons,
                ],
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(note.title, style: theme.textTheme.titleSmall),
              ),
              if (metadataIcons.isNotEmpty) ...[
                const SizedBox(width: 8),
                Flexible(child: icons),
              ],
            ],
          );
        },
      ),
    );
  }
}

Future<void> launchHouseDirectoryUrl(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    KinlySnackBar.showError(context, S.of(context).houseDirectoryOpenLinkError);
    return;
  }
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    KinlySnackBar.showError(context, S.of(context).houseDirectoryOpenLinkError);
  }
}
