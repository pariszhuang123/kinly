import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/inputs/kinly_search_field.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_refresh_indicator.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_segmented_control.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
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
  });

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
            body: _DetailsBody(
              homeId: homeId,
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
    required this.state,
  });

  final String homeId;
  final HouseDirectoryState state;

  @override
  State<_DetailsBody> createState() => _DetailsBodyState();
}

enum _HouseDirectoryBrowseSection { services, notes, tutorials }

class _DetailsBodyState extends State<_DetailsBody> {
  final _searchController = TextEditingController();
  String _query = '';
  _HouseDirectoryBrowseSection _selectedSection =
      _HouseDirectoryBrowseSection.services;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    if (state.isLoading && !state.hasContent) {
      return const Center(child: KinlyLoader());
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasActiveSearch = _query.trim().isNotEmpty;
        final useTwoColumns = constraints.maxWidth >= 760;
        final filteredServices = [
          ...state.rentServices,
          ...state.utilityServices,
        ].where((service) => _matchesService(service, _query)).toList(
          growable: false,
        );
        final filteredNotes =
            state.notes.where((note) => _matchesNote(note, _query)).toList(
              growable: false,
            );
        final filteredTutorials =
            state.tutorials.where((note) => _matchesNote(note, _query)).toList(
              growable: false,
            );
        final segments = <_HouseDirectoryBrowseSection, String>{
          _HouseDirectoryBrowseSection.services: s.houseDirectoryServicesTitle,
          _HouseDirectoryBrowseSection.notes: s.houseDirectoryNotesTitle,
          _HouseDirectoryBrowseSection.tutorials: s.houseDirectoryTutorialsTitle,
        };

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
                    if (state.services.isNotEmpty ||
                        state.notes.isNotEmpty ||
                        state.tutorials.isNotEmpty) ...[
                      KinlySearchField(
                        controller: _searchController,
                        labelText: s.houseDirectorySearchLabel,
                        hintText: s.houseDirectorySearchHint,
                        onChanged: (value) => setState(() => _query = value),
                        onClear: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
                      SizedBox(height: spacing.md),
                      if (hasActiveSearch)
                        Text(
                          s.houseDirectorySearchingAll,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      else
                        KinlySegmentedControl<_HouseDirectoryBrowseSection>(
                          segments: segments,
                          selected: _selectedSection,
                          onChanged:
                              (value) => setState(() => _selectedSection = value),
                        ),
                      SizedBox(height: spacing.lg),
                    ],
                    if (hasActiveSearch)
                      _SearchResultsView(
                        homeId: widget.homeId,
                        state: state,
                        services: filteredServices,
                        notes: filteredNotes,
                        tutorials: filteredTutorials,
                        useTwoColumns: useTwoColumns,
                      )
                    else
                      _BrowseSectionView(
                        section: _selectedSection,
                        homeId: widget.homeId,
                        state: state,
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

class _BrowseSectionView extends StatelessWidget {
  const _BrowseSectionView({
    required this.section,
    required this.homeId,
    required this.state,
    required this.useTwoColumns,
  });

  final _HouseDirectoryBrowseSection section;
  final String homeId;
  final HouseDirectoryState state;
  final bool useTwoColumns;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return switch (section) {
      _HouseDirectoryBrowseSection.services => _ServiceSection(
        homeId: homeId,
        state: state,
        title: s.houseDirectoryServicesTitle,
        emptyMessage: s.houseDirectoryServicesEmpty,
        services: [...state.rentServices, ...state.utilityServices],
        hasActiveSearch: false,
        useTwoColumns: useTwoColumns,
      ),
      _HouseDirectoryBrowseSection.notes => _NoteSection(
        homeId: homeId,
        state: state,
        title: s.houseDirectoryNotesTitle,
        emptyMessage: s.houseDirectoryNotesEmpty,
        searchEmptyMessage: s.houseDirectoryNotesSearchEmpty,
        notes: state.notes,
        allNotes: state.notes,
        hasActiveSearch: false,
        useTwoColumns: useTwoColumns,
        actionLabel: s.houseDirectoryAddNote,
        createNoteType: HouseDirectoryNoteType.general,
      ),
      _HouseDirectoryBrowseSection.tutorials => _NoteSection(
        homeId: homeId,
        state: state,
        title: s.houseDirectoryTutorialsTitle,
        emptyMessage: s.houseDirectoryTutorialsEmpty,
        searchEmptyMessage: s.houseDirectoryTutorialsSearchEmpty,
        notes: state.tutorials,
        allNotes: state.tutorials,
        hasActiveSearch: false,
        useTwoColumns: useTwoColumns,
        actionLabel: s.houseDirectoryAddTutorial,
        createNoteType: HouseDirectoryNoteType.tutorial,
      ),
    };
  }
}

class _SearchResultsView extends StatelessWidget {
  const _SearchResultsView({
    required this.homeId,
    required this.state,
    required this.services,
    required this.notes,
    required this.tutorials,
    required this.useTwoColumns,
  });

  final String homeId;
  final HouseDirectoryState state;
  final List<HouseDirectoryService> services;
  final List<HouseDirectoryNote> notes;
  final List<HouseDirectoryNote> tutorials;
  final bool useTwoColumns;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final children = <Widget>[];
    if (services.isNotEmpty) {
      children.add(
        _ServiceSection(
          homeId: homeId,
          state: state,
          title: s.houseDirectoryServicesTitle,
          emptyMessage: s.houseDirectoryServicesEmpty,
          services: services,
          hasActiveSearch: true,
          useTwoColumns: useTwoColumns,
        ),
      );
    }
    if (notes.isNotEmpty) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: 24));
      }
      children.add(
        _NoteSection(
          homeId: homeId,
          state: state,
          title: s.houseDirectoryNotesTitle,
          emptyMessage: s.houseDirectoryNotesEmpty,
          searchEmptyMessage: s.houseDirectoryNotesSearchEmpty,
          notes: notes,
          allNotes: state.notes,
          hasActiveSearch: true,
          useTwoColumns: useTwoColumns,
          actionLabel: s.houseDirectoryAddNote,
          createNoteType: HouseDirectoryNoteType.general,
        ),
      );
    }
    if (tutorials.isNotEmpty) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: 24));
      }
      children.add(
        _NoteSection(
          homeId: homeId,
          state: state,
          title: s.houseDirectoryTutorialsTitle,
          emptyMessage: s.houseDirectoryTutorialsEmpty,
          searchEmptyMessage: s.houseDirectoryTutorialsSearchEmpty,
          notes: tutorials,
          allNotes: state.tutorials,
          hasActiveSearch: true,
          useTwoColumns: useTwoColumns,
          actionLabel: s.houseDirectoryAddTutorial,
          createNoteType: HouseDirectoryNoteType.tutorial,
        ),
      );
    }
    if (children.isEmpty) {
      return HouseDirectorySurfaceCard(
        child: Text(s.houseDirectorySearchAllEmpty),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
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

class _NoteSection extends StatelessWidget {
  const _NoteSection({
    required this.homeId,
    required this.state,
    required this.title,
    required this.emptyMessage,
    required this.searchEmptyMessage,
    required this.notes,
    required this.allNotes,
    required this.hasActiveSearch,
    required this.useTwoColumns,
    required this.actionLabel,
    required this.createNoteType,
  });

  final String homeId;
  final HouseDirectoryState state;
  final String title;
  final String emptyMessage;
  final String searchEmptyMessage;
  final List<HouseDirectoryNote> notes;
  final List<HouseDirectoryNote> allNotes;
  final bool hasActiveSearch;
  final bool useTwoColumns;
  final String actionLabel;
  final HouseDirectoryNoteType createNoteType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasActiveSearch) ...[
          HouseDirectorySectionHeader(
            title: title,
            actionLabel: state.isOwner ? actionLabel : null,
            onAction: state.isOwner ? () => _openCreateSheet(context) : null,
          ),
          const SizedBox(height: 12),
        ],
        if (allNotes.isEmpty)
          HouseDirectorySurfaceCard(child: Text(emptyMessage))
        else if (notes.isEmpty && hasActiveSearch)
          HouseDirectorySurfaceCard(
            child: Text(searchEmptyMessage),
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
      extra: HouseDirectoryNoteRouteArgs(initialNoteType: createNoteType),
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
