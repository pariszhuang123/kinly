import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Row(
      children: [
        Expanded(
          child: Text(title, style: theme.textTheme.titleMedium),
        ),
        if (actionLabel != null && onAction != null)
          KinlyOutlinedButton.text(
            onPressed: onAction,
            label: actionLabel!,
            compact: true,
          ),
      ],
    );
  }
}

class HouseDirectorySurfaceCard extends StatelessWidget {
  const HouseDirectorySurfaceCard({
    super.key,
    required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final card = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
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
    this.onEdit,
  });

  final HouseDirectoryWifi? wifi;
  final bool isOwner;
  final VoidCallback? onEdit;

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
          if (isOwner && onEdit != null) ...[
            const SizedBox(height: 12),
            KinlyOutlinedButton.text(
              onPressed: onEdit,
              label: s.houseDirectoryAddWifi,
              compact: true,
            ),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                wifi!.ssid,
                style: theme.textTheme.titleMedium,
              ),
            ),
            if (isOwner && onEdit != null)
              KinlyOutlinedButton.text(
                onPressed: onEdit,
                label: s.houseDirectoryEdit,
                compact: true,
                fullWidth: false,
              ),
          ],
        ),
        const SizedBox(height: 12),
        Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.all(spacing.xs),
              child: QrImageView(
                data: wifi!.qrPayload,
                version: QrVersions.auto,
                size: 132,
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
      ],
    );
  }
}

class HouseDirectoryServiceCard extends StatelessWidget {
  const HouseDirectoryServiceCard({
    super.key,
    required this.service,
    required this.isOwner,
    required this.onEdit,
    required this.onArchive,
  });

  final HouseDirectoryService service;
  final bool isOwner;
  final VoidCallback onEdit;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final s = S.of(context);
    final format = DateFormat.yMMMd();
    return HouseDirectorySurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(service.providerName, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(_serviceLabel(s, service), style: theme.textTheme.bodyMedium),
          for (final detail in _serviceDetails(s, format, service)) ...[
            const SizedBox(height: 8),
            Text(detail, style: theme.textTheme.bodyMedium),
          ],
          if (service.linkUrl?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            KinlyOutlinedButton.text(
              onPressed: () => launchHouseDirectoryUrl(
                context,
                service.linkUrl!,
              ),
              label: s.houseDirectoryOpenLink,
              compact: true,
            ),
          ],
          if (isOwner) ...[
            const SizedBox(height: 12),
            HouseDirectoryOwnerActions(
              onEdit: onEdit,
              onArchive: onArchive,
            ),
          ],
        ],
      ),
    );
  }
}

class HouseDirectoryNoteCard extends StatelessWidget {
  const HouseDirectoryNoteCard({
    super.key,
    required this.note,
    required this.isOwner,
    required this.onEdit,
    required this.onArchive,
  });

  final HouseDirectoryNote note;
  final bool isOwner;
  final VoidCallback onEdit;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    return HouseDirectorySurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(note.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(note.details, style: theme.textTheme.bodyMedium),
          if (note.referenceUrl?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            KinlyOutlinedButton.text(
              onPressed: () => launchHouseDirectoryUrl(
                context,
                note.referenceUrl!,
              ),
              label: s.houseDirectoryOpenLink,
              compact: true,
            ),
          ],
          if (note.photoPath?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              s.houseDirectoryNotePhotoAttached,
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (isOwner) ...[
            const SizedBox(height: 12),
            HouseDirectoryOwnerActions(
              onEdit: onEdit,
              onArchive: onArchive,
            ),
          ],
        ],
      ),
    );
  }
}

class HouseDirectoryOwnerActions extends StatelessWidget {
  const HouseDirectoryOwnerActions({
    super.key,
    required this.onEdit,
    required this.onArchive,
  });

  final VoidCallback onEdit;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        KinlyOutlinedButton.text(
          onPressed: onEdit,
          label: s.houseDirectoryEdit,
          compact: true,
        ),
        KinlyFilledButton.destructiveText(
          onPressed: onArchive,
          label: s.houseDirectoryDelete,
          compact: true,
        ),
      ],
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

String _serviceLabel(S s, HouseDirectoryService service) {
  if (service.serviceType == HouseDirectoryServiceType.other) {
    return service.customLabel ?? s.houseDirectoryServiceOther;
  }
  return service.serviceType.wireValue;
}

List<String> _serviceDetails(
  S s,
  DateFormat format,
  HouseDirectoryService service,
) {
  final details = <String>[];
  if (service.termStartDate != null || service.termEndDate != null) {
    final start =
        service.termStartDate == null
            ? s.houseDirectoryDateUnknown
            : format.format(service.termStartDate!);
    final end =
        service.termEndDate == null
            ? s.houseDirectoryDateUnknown
            : format.format(service.termEndDate!);
    details.add(s.houseDirectoryTermRange(start, end));
  }
  if (service.accountReference?.isNotEmpty == true) {
    details.add(s.houseDirectoryAccountReference(service.accountReference!));
  }
  if (service.notes?.isNotEmpty == true) {
    details.add(service.notes!);
  }
  if (service.reminder != null) {
    details.add(
      s.houseDirectoryReminderDue(format.format(service.reminder!.dueAt)),
    );
  }
  return details;
}
