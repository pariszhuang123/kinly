import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/route_args.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/inputs/kinly_search_field.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_circle_avatar.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_refresh_indicator.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_segmented_control.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/core/utils/kinly_search.dart';
import 'package:kinly/features/personal_directory/bloc/personal_directory_bloc.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

part 'personal_directory_screen_view_data.dart';
part 'personal_directory_screen_widgets.dart';
part 'personal_directory_screen_helpers.dart';

class PersonalDirectoryScreen extends StatefulWidget {
  const PersonalDirectoryScreen({
    super.key,
    this.canEdit = true,
  });

  final bool canEdit;

  @override
  State<PersonalDirectoryScreen> createState() => _PersonalDirectoryScreenState();
}

class _PersonalDirectoryScreenState extends State<PersonalDirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  _PersonalDirectoryBrowseSection _selectedSection =
      _PersonalDirectoryBrowseSection.allergy;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PersonalDirectoryBloc, PersonalDirectoryState>(
      listenWhen: (previous, current) => previous.notice != current.notice,
      listener: _showNotice,
      child: BlocBuilder<PersonalDirectoryBloc, PersonalDirectoryState>(
        builder: _buildState,
      ),
    );
  }

  Widget _buildState(BuildContext context, PersonalDirectoryState state) {
    if (state.isLoading && !state.hasLoaded) {
      return const KinlyScaffold(
        body: Center(child: KinlyLoader()),
      );
    }
    final data = _PersonalDirectoryViewData.fromState(
      context: context,
      state: state,
      query: _query,
      selectedSection: _selectedSection,
      filterNotes: (notes) => _filterNotes(context, notes),
    );
    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(S.of(context).personalDirectoryTitle)),
      body: KinlyScrollFade(
        child: KinlyRefreshIndicator(
          onRefresh: () => _handleRefresh(context),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
            children: _buildBodyChildren(context, state, data),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBodyChildren(
    BuildContext context,
    PersonalDirectoryState state,
    _PersonalDirectoryViewData data,
  ) {
    return [
      _TargetHeader(target: state.target),
      const SizedBox(height: 24),
      ..._buildOwnerCards(context, state, data),
      ..._buildReadOnlyEmergencySection(context, state, data),
      _buildNotesHeader(context, state),
      const SizedBox(height: 12),
      ..._buildSearchField(context, data),
      ..._buildNotesBody(context, state, data),
    ];
  }

  List<Widget> _buildOwnerCards(
    BuildContext context,
    PersonalDirectoryState state,
    _PersonalDirectoryViewData data,
  ) {
    if (!state.isSelf) {
      return const <Widget>[];
    }
    final hasBankCard = state.bankAccount != null || _canEdit(state);
    final hasEmergencyCard = data.emergencyContact != null || _canEdit(state);
    if (!hasBankCard && !hasEmergencyCard) {
      return const <Widget>[];
    }
    final cards = <Widget>[];
    if (hasBankCard) {
      cards.add(
        _BankCard(
          bankAccount: state.bankAccount,
          onTap:
              state.bankAccount != null || _canEdit(state)
                  ? () => _openBank(context, state)
                  : null,
        ),
      );
    }
    if (hasEmergencyCard) {
      cards.add(
        _EmergencyContactOwnerCard(
          note: data.emergencyContact,
          onTap:
              data.emergencyContact != null || _canEdit(state)
                  ? () => _openEmergencyContact(
                    context,
                    state,
                    data.emergencyContact,
                  )
                  : null,
          onTapPhone:
              data.emergencyPhoneNumber == null
                  ? null
                  : () => _launchPhoneNumber(data.emergencyPhoneNumber!),
          ),
      );
    }
    if (_canEdit(state)) {
      return [
        _EditableOwnerCardGrid(cards: cards),
        const SizedBox(height: 24),
      ];
    }
    return [
      ...withVerticalSpacing(cards, spacing: 12),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _buildReadOnlyEmergencySection(
    BuildContext context,
    PersonalDirectoryState state,
    _PersonalDirectoryViewData data,
  ) {
    if (state.isSelf || data.emergencyContact == null) {
      return const <Widget>[];
    }
    return [
      _SectionHeader(title: S.of(context).personalDirectoryEmergencyContactTitle),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 24),
        child: _EmergencyContactViewerCard(note: data.emergencyContact!),
      ),
    ];
  }

  Widget _buildNotesHeader(
    BuildContext context,
    PersonalDirectoryState state,
  ) {
    final s = S.of(context);
    return _SectionHeader(
      title: s.personalDirectoryNotesTitle,
      actionLabel: _canEdit(state) ? s.personalDirectoryAddNote : null,
      onAction: _canEdit(state) ? () => _openCreateNote(context, state) : null,
    );
  }

  List<Widget> _buildSearchField(
    BuildContext context,
    _PersonalDirectoryViewData data,
  ) {
    if (data.browsableNotes.isEmpty) {
      return const <Widget>[];
    }
    final s = S.of(context);
    return [
      KinlySearchField(
        controller: _searchController,
        labelText: s.personalDirectorySearchLabel,
        hintText: s.personalDirectorySearchHint,
        onChanged: _updateQuery,
        onClear: _clearQuery,
      ),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _buildNotesBody(
    BuildContext context,
    PersonalDirectoryState state,
    _PersonalDirectoryViewData data,
  ) {
    final emptyMessage =
        _canEdit(state)
            ? S.of(context).personalDirectoryNotesEmptySelf
            : S.of(context).personalDirectoryNotesEmptyOther;
    if (data.hasNoBrowsableNotes) {
      return [_MessageCard(message: emptyMessage)];
    }
    if (data.showSearchEmpty) {
      return [_MessageCard(message: S.of(context).personalDirectoryNotesSearchEmpty)];
    }
    return [
      ..._buildBrowseControls(data),
      _NoteSection(
        notes: data.visibleBrowseNotes,
        showTypePill: data.showTypePill,
        onOpenNote: (note) => _openNote(context, state, note),
      ),
    ];
  }

  List<Widget> _buildBrowseControls(_PersonalDirectoryViewData data) {
    if (data.hasActiveSearch) {
      return const <Widget>[];
    }
    if (data.showSegmentedControl) {
      return [
        KinlySegmentedControl<_PersonalDirectoryBrowseSection>(
          segments: data.segments,
          selected: data.browseSection,
          onChanged: (value) => setState(() => _selectedSection = value),
        ),
        const SizedBox(height: 16),
      ];
    }
    if (data.singleSectionTitle == null) {
      return const <Widget>[];
    }
    return [
      _DirectorySectionHeader(title: data.singleSectionTitle!),
      const SizedBox(height: 12),
    ];
  }

  void _updateQuery(String value) {
    setState(() => _query = value);
  }

  void _clearQuery() {
    _searchController.clear();
    setState(() => _query = '');
  }

  List<PersonalDirectoryNote> _filterNotes(
    BuildContext context,
    List<PersonalDirectoryNote> notes,
  ) {
    return notes.where((note) {
      return matchesSearchQuery(
        query: _query,
        searchableText: buildSearchableText([
          personalDirectoryNoteTypeLabel(context, note.noteType),
          _noteTitle(note),
          note.label,
          note.customTitle,
          note.contactName,
          note.phoneNumber,
          note.details,
        ]),
      );
    }).toList(growable: false);
  }

  Future<void> _handleRefresh(BuildContext context) async {
    final bloc = context.read<PersonalDirectoryBloc>();
    bloc.add(const PersonalDirectoryRefreshed());
    await bloc.stream.firstWhere(
      (state) => state.status != PersonalDirectoryStatus.loading,
    );
  }

  Future<void> _openBank(
    BuildContext context,
    PersonalDirectoryState state,
  ) async {
    final result = await context.pushNamed<PersonalDirectoryRouteResult>(
      AppRouteNames.personalDirectoryBank,
      extra: PersonalDirectoryBankRouteArgs(
        initial: state.bankAccount,
        canEdit: _canEdit(state),
      ),
    );
    if (!context.mounted) return;
    _handleRouteResult(context, result);
  }

  Future<void> _openCreateNote(
    BuildContext context,
    PersonalDirectoryState state,
  ) async {
    final result = await context.pushNamed<PersonalDirectoryRouteResult>(
      AppRouteNames.personalDirectoryNote,
      extra: PersonalDirectoryNoteRouteArgs(
        canEdit: _canEdit(state),
        availableNoteTypes: const [
          PersonalDirectoryNoteType.allergy,
          PersonalDirectoryNoteType.other,
        ],
      ),
    );
    if (!context.mounted) return;
    _handleRouteResult(context, result);
  }

  Future<void> _openEmergencyContact(
    BuildContext context,
    PersonalDirectoryState state,
    PersonalDirectoryNote? note,
  ) async {
    final result = await context.pushNamed<PersonalDirectoryRouteResult>(
      AppRouteNames.personalDirectoryNote,
      extra: PersonalDirectoryNoteRouteArgs(
        note: note,
        canEdit: _canEdit(state),
        availableNoteTypes: const [PersonalDirectoryNoteType.emergencyContact],
      ),
    );
    if (!context.mounted) return;
    _handleRouteResult(context, result);
  }

  Future<void> _openNote(
    BuildContext context,
    PersonalDirectoryState state,
    PersonalDirectoryNote note,
  ) async {
    final result = await context.pushNamed<PersonalDirectoryRouteResult>(
      AppRouteNames.personalDirectoryNote,
      extra: PersonalDirectoryNoteRouteArgs(
        note: note,
        canEdit: _canEdit(state),
        availableNoteTypes: [note.noteType],
      ),
    );
    if (!context.mounted) return;
    _handleRouteResult(context, result);
  }

  void _handleRouteResult(
    BuildContext context,
    PersonalDirectoryRouteResult? result,
  ) {
    if (result == null || !context.mounted) return;
    context.read<PersonalDirectoryBloc>().add(const PersonalDirectoryRefreshed());
    final s = S.of(context);
    final message = switch (result) {
      PersonalDirectoryRouteResult.bankSaved => s.personalDirectoryBankSaved,
      PersonalDirectoryRouteResult.noteSaved => s.personalDirectoryNoteSaved,
      PersonalDirectoryRouteResult.noteArchived =>
        s.personalDirectoryNoteArchived,
    };
    KinlySnackBar.showSuccess(context, message);
  }

  void _showNotice(BuildContext context, PersonalDirectoryState state) {
    final s = S.of(context);
    final message = switch (state.notice) {
      PersonalDirectoryNotice.loadFailed =>
        state.errorMessage ?? s.personalDirectoryLoadError,
      PersonalDirectoryNotice.bankAccountSaved => s.personalDirectoryBankSaved,
      PersonalDirectoryNotice.noteSaved => s.personalDirectoryNoteSaved,
      PersonalDirectoryNotice.noteArchived => s.personalDirectoryNoteArchived,
      PersonalDirectoryNotice.actionFailed =>
        state.errorMessage ?? s.personalDirectoryActionFailed,
      _ => null,
    };
    if (message == null) return;
    if (state.notice == PersonalDirectoryNotice.loadFailed ||
        state.notice == PersonalDirectoryNotice.actionFailed) {
      KinlySnackBar.showError(context, message);
      return;
    }
    KinlySnackBar.showSuccess(context, message);
  }

  Future<void> _launchPhoneNumber(String phoneNumber) async {
    final normalized = phoneNumber.replaceAll(RegExp(r'[\s()-]'), '');
    final uri = Uri(scheme: 'tel', path: normalized);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  bool _canEdit(PersonalDirectoryState state) {
    return widget.canEdit && state.isSelf;
  }
}
