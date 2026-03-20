import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
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

part 'house_directory_details_screen_sections.dart';

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
                    ],
                    if (hasActiveSearch)
                      Text(
                        s.houseDirectorySearchingAll,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      )
                    else ...[
                      _BrowseActionRow(
                        actionLabel:
                            state.isOwner ? _actionLabelForSection(s) : null,
                        onAction:
                            state.isOwner
                                ? _openCreateForSelectedSection
                                : null,
                      ),
                      SizedBox(height: spacing.md),
                      KinlySegmentedControl<_HouseDirectoryBrowseSection>(
                        segments: segments,
                        selected: _selectedSection,
                        onChanged:
                            (value) => setState(() => _selectedSection = value),
                      ),
                    ],
                    SizedBox(height: spacing.lg),
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

  String _actionLabelForSection(S s) {
    return switch (_selectedSection) {
      _HouseDirectoryBrowseSection.services => s.houseDirectoryAddService,
      _HouseDirectoryBrowseSection.notes => s.houseDirectoryAddNote,
      _HouseDirectoryBrowseSection.tutorials => s.houseDirectoryAddTutorial,
    };
  }

  Future<void> _openCreateForSelectedSection() async {
    final router = GoRouter.of(context);
    final result = switch (_selectedSection) {
      _HouseDirectoryBrowseSection.services =>
        await router.pushNamed<HouseDirectoryRouteResult>(
          AppRouteNames.houseDirectoryService,
          extra: const HouseDirectoryServiceRouteArgs(),
        ),
      _HouseDirectoryBrowseSection.notes =>
        await router.pushNamed<HouseDirectoryRouteResult>(
          AppRouteNames.houseDirectoryNote,
          extra: HouseDirectoryNoteRouteArgs(
            initialNoteType: HouseDirectoryNoteType.general,
          ),
        ),
      _HouseDirectoryBrowseSection.tutorials =>
        await router.pushNamed<HouseDirectoryRouteResult>(
          AppRouteNames.houseDirectoryNote,
          extra: HouseDirectoryNoteRouteArgs(
            initialNoteType: HouseDirectoryNoteType.tutorial,
          ),
        ),
    };
    if (!mounted) return;
    _handleRouteResult(result);
  }

  void _handleRouteResult(HouseDirectoryRouteResult? result) {
    if (result == null || !mounted) return;
    final s = S.of(context);
    final message = switch (result) {
      HouseDirectoryRouteResult.serviceCreated =>
        s.houseDirectoryServiceSaved,
      HouseDirectoryRouteResult.serviceUpdated =>
        s.houseDirectoryServiceSaved,
      HouseDirectoryRouteResult.serviceArchived =>
        s.houseDirectoryServiceArchived,
      HouseDirectoryRouteResult.noteCreated => s.houseDirectoryNoteSaved,
      HouseDirectoryRouteResult.noteUpdated => s.houseDirectoryNoteSaved,
      HouseDirectoryRouteResult.noteArchived => s.houseDirectoryNoteArchived,
      HouseDirectoryRouteResult.tutorialCreated => s.houseDirectoryNoteSaved,
      HouseDirectoryRouteResult.tutorialUpdated => s.houseDirectoryNoteSaved,
      HouseDirectoryRouteResult.tutorialArchived =>
        s.houseDirectoryNoteArchived,
    };
    KinlySnackBar.showSuccess(context, message);
  }
}
