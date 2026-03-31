part of 'house_directory_details_screen.dart';

class _BrowseActionRow extends StatelessWidget {
  const _BrowseActionRow({
    this.actionLabel,
    this.onAction,
  });

  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    if (actionLabel == null || onAction == null) {
      return const SizedBox.shrink();
    }
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: KinlyOutlinedButton.text(
        onPressed: onAction,
        label: actionLabel!,
        compact: true,
      ),
    );
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
        emptyMessage: s.houseDirectoryServicesEmpty,
        services: [...state.rentServices, ...state.utilityServices],
        hasActiveSearch: false,
        useTwoColumns: useTwoColumns,
      ),
      _HouseDirectoryBrowseSection.notes => _NoteSection(
        homeId: homeId,
        state: state,
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
    required this.emptyMessage,
    required this.services,
    required this.hasActiveSearch,
    required this.useTwoColumns,
  });

  final String homeId;
  final HouseDirectoryState state;
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
        if (hasActiveSearch) ...[
          HouseDirectorySectionHeader(
            title: s.houseDirectoryServicesTitle,
            actionLabel: state.isOwner ? s.houseDirectoryAddService : null,
            onAction: state.isOwner ? () => _openCreateSheet(context) : null,
          ),
          const SizedBox(height: 12),
        ],
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
    final result = await context.pushNamed<HouseDirectoryRouteResult>(
      AppRouteNames.houseDirectoryService,
      extra: const HouseDirectoryServiceRouteArgs(),
    );
    if (!context.mounted) return;
    _handleRouteResult(context, result);
  }

  Future<void> _openService(BuildContext context, String serviceId) async {
    final result = await context.pushNamed<HouseDirectoryRouteResult>(
      AppRouteNames.houseDirectoryService,
      extra: HouseDirectoryServiceRouteArgs(
        serviceId: serviceId,
        startInEditMode: state.isOwner,
      ),
    );
    if (!context.mounted) return;
    _handleRouteResult(context, result);
  }

  void _handleRouteResult(
    BuildContext context,
    HouseDirectoryRouteResult? result,
  ) {
    if (result == null || !context.mounted) return;
    final s = S.of(context);
    final message = switch (result) {
      HouseDirectoryRouteResult.serviceCreated =>
        s.houseDirectoryServiceSaved,
      HouseDirectoryRouteResult.serviceUpdated =>
        s.houseDirectoryServiceSaved,
      HouseDirectoryRouteResult.serviceArchived =>
        s.houseDirectoryServiceArchived,
      _ => null,
    };
    if (message == null) return;
    KinlySnackBar.showSuccess(context, message);
  }
}

class _NoteSection extends StatelessWidget {
  const _NoteSection({
    required this.homeId,
    required this.state,
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
            title: createNoteType == HouseDirectoryNoteType.tutorial
                ? S.of(context).houseDirectoryTutorialsTitle
                : S.of(context).houseDirectoryNotesTitle,
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
    final result = await context.pushNamed<HouseDirectoryRouteResult>(
      AppRouteNames.houseDirectoryNote,
      extra: HouseDirectoryNoteRouteArgs(initialNoteType: createNoteType),
    );
    if (!context.mounted) return;
    _handleRouteResult(context, result);
  }

  Future<void> _openNote(BuildContext context, String noteId) async {
    final result = await context.pushNamed<HouseDirectoryRouteResult>(
      AppRouteNames.houseDirectoryNote,
      extra: HouseDirectoryNoteRouteArgs(
        noteId: noteId,
        initialNoteType: createNoteType,
        startInEditMode: state.isOwner,
      ),
    );
    if (!context.mounted) return;
    _handleRouteResult(context, result);
  }

  void _handleRouteResult(
    BuildContext context,
    HouseDirectoryRouteResult? result,
  ) {
    if (result == null || !context.mounted) return;
    final s = S.of(context);
    final message = switch (result) {
      HouseDirectoryRouteResult.noteCreated => s.houseDirectoryNoteSaved,
      HouseDirectoryRouteResult.noteUpdated => s.houseDirectoryNoteSaved,
      HouseDirectoryRouteResult.noteArchived => s.houseDirectoryNoteArchived,
      HouseDirectoryRouteResult.tutorialCreated => s.houseDirectoryNoteSaved,
      HouseDirectoryRouteResult.tutorialUpdated => s.houseDirectoryNoteSaved,
      HouseDirectoryRouteResult.tutorialArchived =>
        s.houseDirectoryNoteArchived,
      _ => null,
    };
    if (message == null) return;
    KinlySnackBar.showSuccess(context, message);
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
