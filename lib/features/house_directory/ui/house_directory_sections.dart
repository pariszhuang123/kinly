import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/kinly_list_tile.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/generated/l10n.dart';
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
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      child: child,
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

class HouseDirectoryWifiCard extends StatelessWidget {
  const HouseDirectoryWifiCard({
    super.key,
    required this.wifi,
    required this.isOwner,
  });

  final HouseDirectoryWifi? wifi;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    if (wifi == null) {
      return HouseDirectorySurfaceCard(
        child: Text(
          isOwner
              ? s.houseDirectoryWifiOwnerEmpty
              : s.houseDirectoryWifiMemberEmpty,
        ),
      );
    }

    return HouseDirectorySurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            wifi!.ssid,
            style: KinlyThemeAccess.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(s.houseDirectoryWifiMaskedHint),
          const SizedBox(height: 12),
          Text(wifi!.qrPayload),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: KinlyOutlinedButton.text(
              onPressed: () => _copySsid(context, wifi!.ssid),
              label: s.houseDirectoryCopySsid,
              compact: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copySsid(BuildContext context, String ssid) async {
    await Clipboard.setData(ClipboardData(text: ssid));
    if (!context.mounted) return;
    KinlySnackBar.showSuccess(context, S.of(context).houseDirectorySsidCopied);
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

class HouseDirectoryLinkCard extends StatelessWidget {
  const HouseDirectoryLinkCard({
    super.key,
    required this.link,
    required this.isOwner,
    required this.onEdit,
    required this.onArchive,
  });

  final HouseDirectoryLink link;
  final bool isOwner;
  final VoidCallback onEdit;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return HouseDirectorySurfaceCard(
      child: Column(
        children: [
          KinlyListTile(
            title: link.title,
            subtitle: _linkLabel(s, link),
            onTap: () => launchHouseDirectoryUrl(context, link.url),
          ),
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

String _linkLabel(S s, HouseDirectoryLink link) {
  if (link.tag == HouseDirectoryLinkTag.other) {
    return link.customTag ?? s.houseDirectoryLinkOther;
  }
  return link.tag.wireValue;
}
