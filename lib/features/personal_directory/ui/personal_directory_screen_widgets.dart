part of 'personal_directory_screen.dart';

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

class _DirectorySectionHeader extends StatelessWidget {
  const _DirectorySectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final palette = context.preferenceSection;
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing.md,
        spacing.sm,
        spacing.md,
        spacing.sm,
      ),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: palette.accent,
        ),
      ),
    );
  }
}

class _EditableOwnerCardGrid extends StatelessWidget {
  const _EditableOwnerCardGrid({required this.cards});

  final List<Widget> cards;

  static const double _breakpoint = 520;
  static const double _spacing = 12;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns =
            cards.length > 1 && constraints.maxWidth >= _breakpoint;
        if (!useTwoColumns) {
          return Column(
            children: _withVerticalSpacing(cards, spacing: _spacing),
          );
        }
        final cardWidth = (constraints.maxWidth - _spacing) / 2;
        return Wrap(
          spacing: _spacing,
          runSpacing: _spacing,
          children: [
            for (final card in cards)
              SizedBox(
                width: cardWidth,
                child: card,
              ),
          ],
        );
      },
    );
  }

  List<Widget> _withVerticalSpacing(
    List<Widget> widgets, {
    required double spacing,
  }) {
    if (widgets.isEmpty) return const <Widget>[];
    final children = <Widget>[];
    for (var index = 0; index < widgets.length; index++) {
      if (index > 0) {
        children.add(SizedBox(height: spacing));
      }
      children.add(widgets[index]);
    }
    return children;
  }
}

class _BankCard extends StatelessWidget {
  const _BankCard({
    required this.bankAccount,
    this.onTap,
  });

  final PersonalDirectoryBankAccount? bankAccount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final subtitle =
        bankAccount == null
            ? s.todayBankAccountPromptSubtitle
            : bankAccount!.accountHolderName;
    final supportingText = bankAccount?.accountNumber;
    return _CompactInfoCard(
      title: s.personalDirectoryBankTitle,
      subtitle: subtitle,
      supportingText: supportingText,
      onTap: onTap,
    );
  }
}

class _EmergencyContactOwnerCard extends StatelessWidget {
  const _EmergencyContactOwnerCard({
    required this.note,
    this.onTap,
    this.onTapPhone,
  });

  final PersonalDirectoryNote? note;
  final VoidCallback? onTap;
  final VoidCallback? onTapPhone;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final phoneNumber = note?.phoneNumber?.trim();
    final details = note?.details?.trim();
    return _CompactInfoCard(
      title: s.personalDirectoryEmergencyContactTitle,
      subtitleWidget:
          phoneNumber == null || phoneNumber.isEmpty
              ? null
              : _InlineLinkText(
                text: phoneNumber,
                onTap: onTapPhone,
              ),
      subtitle:
          phoneNumber == null || phoneNumber.isEmpty
              ? s.personalDirectoryEmergencyContactHelp
              : null,
      supportingText: details == null || details.isEmpty ? null : details,
      onTap: onTap,
    );
  }
}

class _EmergencyContactViewerCard extends StatelessWidget {
  const _EmergencyContactViewerCard({required this.note});

  final PersonalDirectoryNote note;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final palette = context.preferenceSection;
    final phoneNumber = note.phoneNumber?.trim();
    final details = note.details?.trim();
    final hasPhoneNumber = phoneNumber != null && phoneNumber.isNotEmpty;
    final hasDetails = details != null && details.isNotEmpty;
    return _SurfaceCard(
      onTap: hasPhoneNumber ? () => _launchPhoneNumber(phoneNumber) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(_noteTitle(note), style: theme.textTheme.titleSmall),
              ),
              if (hasPhoneNumber) ...[
                SizedBox(width: spacing.sm),
                Icon(
                  KinlyIcons.callRounded,
                  size: 16,
                  color: palette.accent,
                ),
                SizedBox(width: spacing.xs),
                Flexible(
                  child: Text(
                    phoneNumber,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.accent,
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          if (hasDetails) ...[
            SizedBox(height: spacing.xs),
            Text(
              details,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _launchPhoneNumber(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;
    final normalized = phoneNumber.replaceAll(RegExp(r'[\s()-]'), '');
    final uri = Uri(scheme: 'tel', path: normalized);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _CompactInfoCard extends StatelessWidget {
  const _CompactInfoCard({
    required this.title,
    this.subtitle,
    this.subtitleWidget,
    this.supportingText,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final String? supportingText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final subtitleStyle = theme.textTheme.bodyMedium;
    final supporting = supportingText?.trim();

    return _SurfaceCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          if (subtitleWidget != null) ...[
            SizedBox(height: spacing.xs),
            subtitleWidget!,
          ],
          if ((subtitle ?? '').trim().isNotEmpty) ...[
            SizedBox(height: spacing.xs),
            _CompactCardText(
              subtitle!,
              style: subtitleStyle?.copyWith(
                color: onTap != null ? context.preferenceSection.accent : null,
              ),
            ),
          ],
          if (supporting != null && supporting.isNotEmpty) ...[
            SizedBox(height: spacing.xs),
            _CompactCardText(
              supporting,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InlineLinkText extends StatelessWidget {
  const _InlineLinkText({
    required this.text,
    this.onTap,
  });

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    return KinlyTapTarget(
      onTap: onTap,
      alignment: AlignmentDirectional.centerStart,
      child: _CompactCardText(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: context.preferenceSection.accent,
        ),
      ),
    );
  }
}

class _CompactCardText extends StatelessWidget {
  const _CompactCardText(this.text, {this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _NoteSection extends StatelessWidget {
  const _NoteSection({
    required this.notes,
    required this.showTypePill,
    required this.onOpenNote,
  });

  final List<PersonalDirectoryNote> notes;
  final bool showTypePill;
  final ValueChanged<PersonalDirectoryNote> onOpenNote;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...notes.map(
          (note) => Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 12),
            child: _NoteCard(
              note: note,
              title: _noteTitle(note),
              showTypePill: showTypePill,
              onTap: () => onOpenNote(note),
            ),
          ),
        ),
      ],
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.note,
    required this.title,
    required this.showTypePill,
    required this.onTap,
  });

  final PersonalDirectoryNote note;
  final String title;
  final bool showTypePill;
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(title, style: theme.textTheme.titleSmall),
              ),
              if (showTypePill) ...[
                const SizedBox(width: 12),
                _NoteTypePill(noteType: note.noteType),
              ],
            ],
          ),
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

class _NoteTypePill extends StatelessWidget {
  const _NoteTypePill({required this.noteType});

  final PersonalDirectoryNoteType noteType;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _label(context),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String _label(BuildContext context) {
    final s = S.of(context);
    return switch (noteType) {
      PersonalDirectoryNoteType.emergencyContact =>
        s.personalDirectoryEmergencyContactTitle,
      PersonalDirectoryNoteType.allergy => s.personalDirectoryAllergyTitle,
      PersonalDirectoryNoteType.other => s.personalDirectoryOtherTitle,
    };
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
