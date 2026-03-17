import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/inputs/kinly_search_field.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_refresh_indicator.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/core/utils/kinly_search.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_route_args.dart';
import 'package:kinly/features/house_directory/ui/house_directory_sections.dart';
import 'package:kinly/generated/l10n.dart';

class HouseDirectoryDetailsScreen extends StatelessWidget {
  const HouseDirectoryDetailsScreen({
    super.key,
    required this.homeId,
    required this.repository,
  });

  final String homeId;
  final HouseDirectoryRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HouseDirectoryBloc, HouseDirectoryState>(
      listenWhen: (previous, current) => previous.notice != current.notice,
      listener: _showNotice,
      child: BlocBuilder<HouseDirectoryBloc, HouseDirectoryState>(
        builder: (context, state) {
          return KinlyScaffold(
            appBar: KinlyAppBar(title: Text(S.of(context).houseDirectoryTitle)),
            body: _DetailsBody(
              homeId: homeId,
              repository: repository,
              state: state,
            ),
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
      HouseDirectoryNotice.noteSaved => s.houseDirectoryNoteSaved,
      HouseDirectoryNotice.noteArchived => s.houseDirectoryNoteArchived,
      HouseDirectoryNotice.reminderAcknowledged =>
        s.houseDirectoryReminderAcknowledged,
      HouseDirectoryNotice.reminderDismissed =>
        s.houseDirectoryReminderDismissed,
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

class _DetailsBody extends StatefulWidget {
  const _DetailsBody({
    required this.homeId,
    required this.repository,
    required this.state,
  });

  final String homeId;
  final HouseDirectoryRepository repository;
  final HouseDirectoryState state;

  @override
  State<_DetailsBody> createState() => _DetailsBodyState();
}

class _DetailsBodyState extends State<_DetailsBody> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    if (state.isLoading && !state.hasContent) {
      return const Center(child: KinlyLoader());
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth >= 760;
        final services = [
          ...state.rentServices,
          ...state.utilityServices,
        ].where((service) => _matchesService(service, _query)).toList(
          growable: false,
        );
        final filteredNotes =
            state.notes.where((note) => _matchesNote(note, _query)).toList(
              growable: false,
            );
        return KinlyScrollFade(
          child: KinlyRefreshIndicator(
            onRefresh: () => _handleRefresh(context),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.services.isNotEmpty || state.notes.isNotEmpty) ...[
                      KinlySearchField(
                        controller: _searchController,
                        labelText: S.of(context).houseDirectorySearchLabel,
                        hintText: S.of(context).houseDirectorySearchHint,
                        onChanged: (value) => setState(() => _query = value),
                        onClear: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                    _ServiceSection(
                      homeId: widget.homeId,
                      state: state,
                      title: S.of(context).houseDirectoryServicesTitle,
                      emptyMessage: S.of(context).houseDirectoryServicesEmpty,
                      services: services,
                      hasActiveSearch: _query.trim().isNotEmpty,
                      useTwoColumns: useTwoColumns,
                    ),
                    const SizedBox(height: 24),
                    _NotesSection(
                      homeId: widget.homeId,
                      repository: widget.repository,
                      state: state,
                      notes: filteredNotes,
                      hasActiveSearch: _query.trim().isNotEmpty,
                      useTwoColumns: useTwoColumns,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _matchesService(HouseDirectoryService service, String query) {
    return matchesSearchQuery(
      query: query,
      searchableText: _serviceSearchText(service),
    );
  }

  bool _matchesNote(HouseDirectoryNote note, String query) {
    return matchesSearchQuery(
      query: query,
      searchableText: _noteSearchText(note),
    );
  }

  String _serviceSearchText(HouseDirectoryService service) {
    return buildSearchableText([
      service.providerName,
      service.customLabel,
      service.serviceType.wireValue,
      service.accountReference,
      service.notes,
      service.linkUrl,
    ]);
  }

  String _noteSearchText(HouseDirectoryNote note) {
    return buildSearchableText([
      note.title,
      note.details,
      note.referenceUrl,
    ]);
  }

  Future<void> _handleRefresh(BuildContext context) async {
    final bloc = context.read<HouseDirectoryBloc>();
    bloc.add(const HouseDirectoryRefreshed());
    await bloc.stream.firstWhere((state) => !state.isRefreshing);
  }
}

class _ServiceSection extends StatelessWidget {
  const _ServiceSection({
    required this.homeId,
    required this.state,
    required this.title,
    required this.emptyMessage,
    required this.services,
    required this.hasActiveSearch,
    required this.useTwoColumns,
  });

  final String homeId;
  final HouseDirectoryState state;
  final String title;
  final String emptyMessage;
  final List<HouseDirectoryService> services;
  final bool hasActiveSearch;
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
        if (state.services.isEmpty)
          HouseDirectorySurfaceCard(child: Text(emptyMessage))
        else if (services.isEmpty && hasActiveSearch)
          HouseDirectorySurfaceCard(
            child: Text(s.houseDirectoryServicesSearchEmpty),
          )
        else
          _ResponsiveCardGrid(
            useTwoColumns: useTwoColumns,
            children:
                services
                    .map(
                      (service) => HouseDirectoryServiceCard(
                        service: service,
                        onTap: () => _openService(context, service.id),
                      ),
                    )
                    .toList(growable: false),
          ),
      ],
    );
  }

  Future<void> _openCreateSheet(BuildContext context) async {
    await context.pushNamed(
      AppRouteNames.houseDirectoryService,
      extra: const HouseDirectoryServiceRouteArgs(),
    );
  }

  Future<void> _openService(
    BuildContext context,
    String serviceId,
  ) async {
    await context.pushNamed(
      AppRouteNames.houseDirectoryService,
      extra: HouseDirectoryServiceRouteArgs(serviceId: serviceId),
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection({
    required this.homeId,
    required this.repository,
    required this.state,
    required this.notes,
    required this.hasActiveSearch,
    required this.useTwoColumns,
  });

  final String homeId;
  final HouseDirectoryRepository repository;
  final HouseDirectoryState state;
  final List<HouseDirectoryNote> notes;
  final bool hasActiveSearch;
  final bool useTwoColumns;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HouseDirectorySectionHeader(
          title: s.houseDirectoryNotesTitle,
          actionLabel: state.isOwner ? s.houseDirectoryAddNote : null,
          onAction: state.isOwner ? () => _openCreateSheet(context) : null,
        ),
        const SizedBox(height: 12),
        if (state.notes.isEmpty)
          HouseDirectorySurfaceCard(child: Text(s.houseDirectoryNotesEmpty))
        else if (notes.isEmpty && hasActiveSearch)
          HouseDirectorySurfaceCard(
            child: Text(s.houseDirectoryNotesSearchEmpty),
          )
        else
          _ResponsiveCardGrid(
            useTwoColumns: useTwoColumns,
            children:
                notes
                    .map(
                      (note) => HouseDirectoryNoteCard(
                        note: note,
                        onTap: () => _openNote(context, note.id),
                      ),
                    )
                    .toList(growable: false),
          ),
      ],
    );
  }

  Future<void> _openCreateSheet(BuildContext context) async {
    await context.pushNamed(
      AppRouteNames.houseDirectoryNote,
      extra: const HouseDirectoryNoteRouteArgs(),
    );
  }

  Future<void> _openNote(
    BuildContext context,
    String noteId,
  ) async {
    await context.pushNamed(
      AppRouteNames.houseDirectoryNote,
      extra: HouseDirectoryNoteRouteArgs(noteId: noteId),
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
