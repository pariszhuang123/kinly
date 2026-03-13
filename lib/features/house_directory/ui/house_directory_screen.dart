import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_forms.dart';
import 'package:kinly/features/house_directory/ui/house_directory_sections.dart';
import 'package:kinly/generated/l10n.dart';

class HouseDirectoryScreen extends StatelessWidget {
  const HouseDirectoryScreen({super.key, required this.homeId});

  final String homeId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HouseDirectoryBloc, HouseDirectoryState>(
      listenWhen: (previous, current) => previous.notice != current.notice,
      listener: _showNotice,
      builder: (context, state) {
        return KinlyScaffold(
          appBar: KinlyAppBar(title: Text(S.of(context).houseDirectoryTitle)),
          body: _HouseDirectoryBody(homeId: homeId, state: state),
        );
      },
    );
  }

  void _showNotice(BuildContext context, HouseDirectoryState state) {
    final message = _noticeMessage(context, state);
    if (message == null) return;
    if (_isFailureNotice(state.notice)) {
      KinlySnackBar.showError(context, message);
      return;
    }
    KinlySnackBar.showSuccess(context, message);
  }

  String? _noticeMessage(BuildContext context, HouseDirectoryState state) {
    final s = S.of(context);
    return switch (state.notice) {
      HouseDirectoryNotice.loadFailed =>
        state.errorMessage ?? s.houseDirectoryLoadError,
      HouseDirectoryNotice.wifiSaved => s.houseDirectoryWifiSaved,
      HouseDirectoryNotice.serviceSaved => s.houseDirectoryServiceSaved,
      HouseDirectoryNotice.serviceArchived => s.houseDirectoryServiceArchived,
      HouseDirectoryNotice.linkSaved => s.houseDirectoryLinkSaved,
      HouseDirectoryNotice.linkArchived => s.houseDirectoryLinkArchived,
      HouseDirectoryNotice.reminderAcknowledged =>
        s.houseDirectoryReminderAcknowledged,
      HouseDirectoryNotice.reminderDismissed =>
        s.houseDirectoryReminderDismissed,
      HouseDirectoryNotice.actionFailed =>
        state.errorMessage ?? s.houseDirectoryActionFailed,
      null => null,
    };
  }

  bool _isFailureNotice(HouseDirectoryNotice? notice) {
    return notice == HouseDirectoryNotice.loadFailed ||
        notice == HouseDirectoryNotice.actionFailed;
  }
}

class _HouseDirectoryBody extends StatelessWidget {
  const _HouseDirectoryBody({
    required this.homeId,
    required this.state,
  });

  final String homeId;
  final HouseDirectoryState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && !state.hasContent) {
      return const Center(child: KinlyLoader());
    }
    if (state.isFailure && !state.hasContent) {
      return _LoadFailure(onRetry: () => _refresh(context));
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!state.hasContent) ...[
              HouseDirectoryEmptyCard(
                title: S.of(context).houseDirectoryEmptyTitle,
                message: S.of(context).houseDirectoryEmptyBody,
              ),
              const SizedBox(height: 24),
            ],
            _WifiSection(homeId: homeId, state: state),
            const SizedBox(height: 24),
            _ServiceSection(
              homeId: homeId,
              state: state,
              title: S.of(context).houseDirectoryRentTitle,
              emptyMessage: S.of(context).houseDirectoryRentEmpty,
              services: state.rentServices,
              initialType: HouseDirectoryServiceType.rent,
            ),
            const SizedBox(height: 24),
            _ServiceSection(
              homeId: homeId,
              state: state,
              title: S.of(context).houseDirectoryServicesTitle,
              emptyMessage: S.of(context).houseDirectoryServicesEmpty,
              services: state.utilityServices,
            ),
            const SizedBox(height: 24),
            _LinksSection(homeId: homeId, state: state),
          ],
        ),
      ),
    );
  }

  void _refresh(BuildContext context) {
    context.read<HouseDirectoryBloc>().add(const HouseDirectoryRefreshed());
  }
}

class _LoadFailure extends StatelessWidget {
  const _LoadFailure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: KinlyFilledButton.text(
        onPressed: onRetry,
        label: S.of(context).houseDirectoryRetry,
      ),
    );
  }
}

class _WifiSection extends StatelessWidget {
  const _WifiSection({
    required this.homeId,
    required this.state,
  });

  final String homeId;
  final HouseDirectoryState state;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HouseDirectorySectionHeader(
          title: s.houseDirectoryWifiTitle,
          actionLabel:
              state.isOwner
                  ? (state.wifi == null
                      ? s.houseDirectoryAddWifi
                      : s.houseDirectoryEditWifi)
                  : null,
          onAction: state.isOwner ? () => _openWifiSheet(context) : null,
        ),
        const SizedBox(height: 12),
        HouseDirectoryWifiCard(wifi: state.wifi, isOwner: state.isOwner),
      ],
    );
  }

  Future<void> _openWifiSheet(BuildContext context) async {
    final result = await showHouseDirectoryWifiSheet(
      context,
      homeId: homeId,
      wifi: state.wifi,
    );
    if (result == null || !context.mounted) return;
    context.read<HouseDirectoryBloc>().add(HouseDirectoryWifiSaved(result));
  }
}

class _ServiceSection extends StatelessWidget {
  const _ServiceSection({
    required this.homeId,
    required this.state,
    required this.title,
    required this.emptyMessage,
    required this.services,
    this.initialType,
  });

  final String homeId;
  final HouseDirectoryState state;
  final String title;
  final String emptyMessage;
  final List<HouseDirectoryService> services;
  final HouseDirectoryServiceType? initialType;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HouseDirectorySectionHeader(
          title: title,
          actionLabel: state.isOwner ? s.houseDirectoryAddService : null,
          onAction: state.isOwner ? () => _openCreateSheet(context) : null,
        ),
        const SizedBox(height: 12),
        if (services.isEmpty)
          HouseDirectorySurfaceCard(child: Text(emptyMessage))
        else
          ...services.map(
            (service) => Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 12),
              child: HouseDirectoryServiceCard(
                service: service,
                isOwner: state.isOwner,
                onEdit: () => _openEditSheet(context, service),
                onArchive: () => _archive(context, service.id),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openCreateSheet(BuildContext context) async {
    final result = await showHouseDirectoryServiceSheet(
      context,
      homeId: homeId,
      initialType: initialType,
    );
    if (result == null || !context.mounted) return;
    context.read<HouseDirectoryBloc>().add(HouseDirectoryServiceSaved(result));
  }

  Future<void> _openEditSheet(
    BuildContext context,
    HouseDirectoryService service,
  ) async {
    final result = await showHouseDirectoryServiceSheet(
      context,
      homeId: homeId,
      service: service,
    );
    if (result == null || !context.mounted) return;
    context.read<HouseDirectoryBloc>().add(HouseDirectoryServiceSaved(result));
  }

  void _archive(BuildContext context, String serviceId) {
    context.read<HouseDirectoryBloc>().add(
      HouseDirectoryServiceArchived(serviceId),
    );
  }
}

class _LinksSection extends StatelessWidget {
  const _LinksSection({
    required this.homeId,
    required this.state,
  });

  final String homeId;
  final HouseDirectoryState state;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HouseDirectorySectionHeader(
          title: s.houseDirectoryLinksTitle,
          actionLabel: state.isOwner ? s.houseDirectoryAddLink : null,
          onAction: state.isOwner ? () => _openCreateSheet(context) : null,
        ),
        const SizedBox(height: 12),
        if (state.links.isEmpty)
          HouseDirectorySurfaceCard(child: Text(s.houseDirectoryLinksEmpty))
        else
          ...state.links.map(
            (link) => Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 12),
              child: HouseDirectoryLinkCard(
                link: link,
                isOwner: state.isOwner,
                onEdit: () => _openEditSheet(context, link),
                onArchive: () => _archive(context, link.id),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openCreateSheet(BuildContext context) async {
    final result = await showHouseDirectoryLinkSheet(context, homeId: homeId);
    if (result == null || !context.mounted) return;
    context.read<HouseDirectoryBloc>().add(HouseDirectoryLinkSaved(result));
  }

  Future<void> _openEditSheet(
    BuildContext context,
    HouseDirectoryLink link,
  ) async {
    final result = await showHouseDirectoryLinkSheet(
      context,
      homeId: homeId,
      link: link,
    );
    if (result == null || !context.mounted) return;
    context.read<HouseDirectoryBloc>().add(HouseDirectoryLinkSaved(result));
  }

  void _archive(BuildContext context, String linkId) {
    context.read<HouseDirectoryBloc>().add(
      HouseDirectoryLinkArchived(linkId),
    );
  }
}
