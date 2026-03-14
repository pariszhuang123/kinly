import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_forms.dart';
import 'package:kinly/features/house_directory/ui/house_directory_sections.dart';
import 'package:kinly/generated/l10n.dart';

class HouseDirectoryDetailsScreen extends StatelessWidget {
  const HouseDirectoryDetailsScreen({super.key, required this.homeId});

  final String homeId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HouseDirectoryBloc, HouseDirectoryState>(
      listenWhen: (previous, current) => previous.notice != current.notice,
      listener: _showNotice,
      child: BlocBuilder<HouseDirectoryBloc, HouseDirectoryState>(
        builder: (context, state) {
          return KinlyScaffold(
            appBar: KinlyAppBar(title: Text(S.of(context).houseDirectoryTitle)),
            body: _DetailsBody(homeId: homeId, state: state),
          );
        },
      ),
    );
  }

  void _showNotice(BuildContext context, HouseDirectoryState state) {
    final s = S.of(context);
    final message = switch (state.notice) {
      HouseDirectoryNotice.loadFailed =>
        state.errorMessage ?? s.houseDirectoryLoadError,
      HouseDirectoryNotice.serviceSaved => s.houseDirectoryServiceSaved,
      HouseDirectoryNotice.serviceArchived => s.houseDirectoryServiceArchived,
      HouseDirectoryNotice.linkSaved => s.houseDirectoryLinkSaved,
      HouseDirectoryNotice.linkArchived => s.houseDirectoryLinkArchived,
      HouseDirectoryNotice.actionFailed =>
        state.errorMessage ?? s.houseDirectoryActionFailed,
      _ => null,
    };
    if (message == null) return;
    if (state.notice == HouseDirectoryNotice.loadFailed ||
        state.notice == HouseDirectoryNotice.actionFailed) {
      KinlySnackBar.showError(context, message);
      return;
    }
    KinlySnackBar.showSuccess(context, message);
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth >= 760;
        final services = [
          ...state.rentServices,
          ...state.utilityServices,
        ];
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ServiceSection(
                  homeId: homeId,
                  state: state,
                  title: S.of(context).houseDirectoryServicesTitle,
                  emptyMessage: S.of(context).houseDirectoryServicesEmpty,
                  services: services,
                  useTwoColumns: useTwoColumns,
                ),
                const SizedBox(height: 24),
                _LinksSection(
                  homeId: homeId,
                  state: state,
                  useTwoColumns: useTwoColumns,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ServiceSection extends StatelessWidget {
  const _ServiceSection({
    required this.homeId,
    required this.state,
    required this.title,
    required this.emptyMessage,
    required this.services,
    required this.useTwoColumns,
  });

  final String homeId;
  final HouseDirectoryState state;
  final String title;
  final String emptyMessage;
  final List<HouseDirectoryService> services;
  final bool useTwoColumns;

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
          _ResponsiveCardGrid(
            useTwoColumns: useTwoColumns,
            children:
                services
                    .map(
                      (service) => HouseDirectoryServiceCard(
                        service: service,
                        isOwner: state.isOwner,
                        onEdit: () => _openEditSheet(context, service),
                        onArchive: () => _archive(context, service.id),
                      ),
                    )
                    .toList(growable: false),
          ),
      ],
    );
  }

  Future<void> _openCreateSheet(BuildContext context) async {
    final result = await showHouseDirectoryServiceSheet(
      context,
      homeId: homeId,
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
    required this.useTwoColumns,
  });

  final String homeId;
  final HouseDirectoryState state;
  final bool useTwoColumns;

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
          _ResponsiveCardGrid(
            useTwoColumns: useTwoColumns,
            children:
                state.links
                    .map(
                      (link) => HouseDirectoryLinkCard(
                        link: link,
                        isOwner: state.isOwner,
                        onEdit: () => _openEditSheet(context, link),
                        onArchive: () => _archive(context, link.id),
                      ),
                    )
                    .toList(growable: false),
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

class _ResponsiveCardGrid extends StatelessWidget {
  const _ResponsiveCardGrid({
    required this.useTwoColumns,
    required this.children,
  });

  final bool useTwoColumns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (!useTwoColumns) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            children
                .map(
                  (child) => Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 12),
                    child: child,
                  ),
                )
                .toList(growable: false),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              children
                  .map((child) => SizedBox(width: itemWidth, child: child))
                  .toList(growable: false),
        );
      },
    );
  }
}
