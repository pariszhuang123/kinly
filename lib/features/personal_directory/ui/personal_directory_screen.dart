import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/route_args.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/inputs/kinly_search_field.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_circle_avatar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_refresh_indicator.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/personal_directory/bloc/personal_directory_bloc.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:flutter/widgets.dart';

class PersonalDirectoryScreen extends StatefulWidget {
  const PersonalDirectoryScreen({super.key});

  @override
  State<PersonalDirectoryScreen> createState() => _PersonalDirectoryScreenState();
}

class _PersonalDirectoryScreenState extends State<PersonalDirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

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
        builder: (context, state) {
          final s = S.of(context);
          if (state.isLoading && !state.hasLoaded) {
            return const KinlyScaffold(
              body: Center(child: KinlyLoader()),
            );
          }
          final filteredNotes = _filterNotes(state.notes);
          return KinlyScaffold(
            appBar: KinlyAppBar(title: Text(s.personalDirectoryTitle)),
            body: KinlyScrollFade(
              child: KinlyRefreshIndicator(
                onRefresh: () => _handleRefresh(context),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
                  children: [
                    _TargetHeader(target: state.target),
                    const SizedBox(height: 24),
                    if (state.isSelf) ...[
                      _SectionHeader(
                        title: s.personalDirectoryBankTitle,
                        actionLabel:
                            state.bankAccount == null
                                ? s.personalDirectoryAddBank
                                : s.houseDirectoryEdit,
                        onAction: () => _openBank(context, state),
                      ),
                      const SizedBox(height: 12),
                      _BankCard(
                        bankAccount: state.bankAccount,
                        onTap: () => _openBank(context, state),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (state.notes.isNotEmpty) ...[
                      KinlySearchField(
                        controller: _searchController,
                        labelText: s.personalDirectorySearchLabel,
                        hintText: s.personalDirectorySearchHint,
                        onChanged: (value) => setState(() => _query = value),
                        onClear: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                    _SectionHeader(
                      title: s.personalDirectoryNotesTitle,
                      actionLabel:
                          state.isSelf ? s.personalDirectoryAddNote : null,
                      onAction:
                          state.isSelf ? () => _openCreateNote(context) : null,
                    ),
                    const SizedBox(height: 12),
                    if (state.notes.isEmpty)
                      _MessageCard(
                        message:
                            state.isSelf
                                ? s.personalDirectoryNotesEmptySelf
                                : s.personalDirectoryNotesEmptyOther,
                      )
                    else if (filteredNotes.isEmpty)
                      _MessageCard(message: s.personalDirectoryNotesSearchEmpty)
                    else
                      ...filteredNotes.map(
                        (note) => Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 12),
                          child: _NoteCard(
                            note: note,
                            title: _noteTitle(note),
                            onTap: () => _openNote(context, state, note),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _noteTitle(PersonalDirectoryNote note) {
    return switch (note.noteType) {
      PersonalDirectoryNoteType.emergencyContact =>
        note.contactName ?? note.customTitle ?? note.label ?? '',
      PersonalDirectoryNoteType.allergy => note.label ?? '',
      PersonalDirectoryNoteType.other => note.customTitle ?? '',
    };
  }

  List<PersonalDirectoryNote> _filterNotes(List<PersonalDirectoryNote> notes) {
    final trimmed = _query.trim().toLowerCase();
    if (trimmed.isEmpty) return notes;
    return notes.where((note) {
      final fields = <String?>[
        _noteTitle(note),
        note.label,
        note.customTitle,
        note.contactName,
        note.phoneNumber,
        note.details,
      ];
      return fields.any(
        (field) => (field ?? '').toLowerCase().contains(trimmed),
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
    final result = await context.pushNamed<bool>(
      AppRouteNames.personalDirectoryBank,
      extra: PersonalDirectoryBankRouteArgs(
        initial: state.bankAccount,
        canEdit: state.isSelf,
      ),
    );
    if (result == true && context.mounted) {
      context.read<PersonalDirectoryBloc>().add(const PersonalDirectoryRefreshed());
    }
  }

  Future<void> _openCreateNote(BuildContext context) async {
    final result = await context.pushNamed<bool>(
      AppRouteNames.personalDirectoryNote,
      extra: const PersonalDirectoryNoteRouteArgs(canEdit: true),
    );
    if (result == true && context.mounted) {
      context.read<PersonalDirectoryBloc>().add(const PersonalDirectoryRefreshed());
    }
  }

  Future<void> _openNote(
    BuildContext context,
    PersonalDirectoryState state,
    PersonalDirectoryNote note,
  ) async {
    final result = await context.pushNamed<bool>(
      AppRouteNames.personalDirectoryNote,
      extra: PersonalDirectoryNoteRouteArgs(
        note: note,
        canEdit: state.isSelf,
      ),
    );
    if (result == true && context.mounted) {
      context.read<PersonalDirectoryBloc>().add(const PersonalDirectoryRefreshed());
    }
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
}

class _TargetHeader extends StatelessWidget {
  const _TargetHeader({required this.target});

  final PersonalDirectoryMemberSummary target;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return Row(
      children: [
        KinlyCircleAvatar(
          avatarUrl: target.avatarUrl,
          radius: 28,
          isOwner: target.isHomeOwner,
        ),
        SizedBox(width: spacing.md),
        Expanded(
          child: Text(
            target.username.trim().isEmpty
                ? S.of(context).personalDirectoryFallbackName
                : target.username,
            style: theme.textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
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
    return Row(
      children: [
        Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
        if (actionLabel != null && onAction != null) ...[
          SizedBox(width: spacing.sm),
          KinlyOutlinedButton.text(
            onPressed: onAction,
            label: actionLabel!,
            compact: true,
            fullWidth: false,
          ),
        ],
      ],
    );
  }
}

class _BankCard extends StatelessWidget {
  const _BankCard({required this.bankAccount, this.onTap});

  final PersonalDirectoryBankAccount? bankAccount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final s = S.of(context);
    return _SurfaceCard(
      onTap: onTap,
      child:
          bankAccount == null
              ? Text(s.personalDirectoryBankEmpty)
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bankAccount!.accountHolderName,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(bankAccount!.accountNumber),
                ],
              ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.note,
    required this.title,
    required this.onTap,
  });

  final PersonalDirectoryNote note;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final summary = _noteSummary(note);
    return _SurfaceCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          if (summary != null) ...[
            const SizedBox(height: 8),
            Text(
              summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  String? _noteSummary(PersonalDirectoryNote note) {
    final details = note.details?.trim();
    if (details != null && details.isNotEmpty) return details;
    final phoneNumber = note.phoneNumber?.trim();
    if (phoneNumber != null && phoneNumber.isNotEmpty) return phoneNumber;
    return null;
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(child: Text(message));
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
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
