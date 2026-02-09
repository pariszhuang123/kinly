part of 'share_create_form_view.dart';

class _ParticipantsSection extends StatelessWidget {
  const _ParticipantsSection({
    required this.state,
    required this.shareColors,
    required this.spacing,
    required this.customSummary,
    required this.showValidation,
    required this.locked,
    required this.customControllers,
  });

  final ShareCreateState state;
  final SectionColors? shareColors;
  final Spacing spacing;
  final ShareCustomSplitSummary customSummary;
  final bool showValidation;
  final bool locked;
  final Map<String, TextEditingController> customControllers;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final s = S.of(context);
    final splitMode = state.form.splitMode;

    if (splitMode == null) {
      return const SizedBox.shrink();
    }

    if (splitMode == ShareSplitMode.custom) {
      final errorText = _customErrorText(
        s,
        customSummary,
        showValidation,
        theme,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.shareCreateCustomHelper,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: spacing.sm),
          ...state.participants.map((participant) {
            final controller = customControllers[participant.userId]!;
            final isSelected = state.form.selectedParticipantIds.contains(
              participant.userId,
            );
            return _CustomSplitRow(
              participant: participant,
              controller: controller,
              selected: isSelected,
              canToggle: !locked,
              canEditAmount: !locked,
              onToggled:
                  locked
                      ? null
                      : (value) => context.read<ShareCreateBloc>().add(
                        ShareCreateParticipantToggled(
                          participant.userId,
                          value,
                        ),
                      ),
              onAmountChanged:
                  locked
                      ? null
                      : (value) => context.read<ShareCreateBloc>().add(
                        ShareCreateCustomAmountChanged(
                          participant.userId,
                          value,
                        ),
                      ),
            );
          }),
          if (errorText != null)
            Padding(
              padding: EdgeInsets.only(top: spacing.xs),
              child: Text(
                errorText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _validationColor(theme),
                ),
              ),
            ),
        ],
      );
    }

    // Equal split
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (locked)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.xs),
            child: Text(
              s.shareEditSplitsLocked,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        IgnorePointer(
          ignoring: locked,
          child: Opacity(
            opacity: locked ? 0.6 : 1.0,
            child: KinlySelectableMemberAvatarRow(
              members: state.participants
                  .map(
                    (participant) => HomeMemberSummary(
                      userId: participant.userId,
                      username: participant.displayName,
                      role: participant.isOwner ? 'owner' : 'member',
                      validFrom:
                          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
                      avatarUrl: participant.avatarUrl,
                      isOwner: participant.isOwner,
                    ),
                  )
                  .toList(growable: false),
              selectedMemberIds: state.form.selectedParticipantIds,
              onToggle:
                  (memberId) => context.read<ShareCreateBloc>().add(
                    ShareCreateParticipantToggled(
                      memberId,
                      !state.form.selectedParticipantIds.contains(memberId),
                    ),
                  ),
            ),
          ),
        ),
        if (!locked &&
            showValidation &&
            splitMode == ShareSplitMode.equal &&
            !state.hasEqualSelection)
          Padding(
            padding: EdgeInsets.only(top: spacing.xs),
            child: Text(
              s.shareCreateValidationEqualParticipants,
              style: theme.textTheme.bodySmall?.copyWith(
                color: _validationColor(theme),
              ),
            ),
          ),
      ],
    );
  }

  String? _customErrorText(
    S s,
    ShareCustomSplitSummary summary,
    bool showValidation,
    dynamic theme,
  ) {
    if (!showValidation) return null;
    if (summary.missingTotal) return s.shareCreateValidationAmount;
    if (summary.hasInvalidAmounts) {
      return s.shareCreateValidationCustomAmounts;
    }
    if (summary.hasInsufficientParticipants) {
      return s.shareCreateValidationCustomParticipants;
    }
    if (!summary.sumMatchesTotal) {
      return s.shareCreateValidationCustomSum;
    }
    if (summary.hasSinglePayer) {
      return s.shareCreateValidationCustomSinglePayer;
    }
    return null;
  }
}

class _CustomSplitRow extends StatelessWidget {
  const _CustomSplitRow({
    required this.participant,
    required this.controller,
    required this.selected,
    required this.canToggle,
    required this.canEditAmount,
    required this.onToggled,
    required this.onAmountChanged,
  });

  final ShareParticipant participant;
  final TextEditingController controller;
  final bool selected;
  final bool canToggle;
  final bool canEditAmount;
  final ValueChanged<bool>? onToggled;
  final ValueChanged<String>? onAmountChanged;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsetsDirectional.all(spacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        children: [
          IgnorePointer(
            ignoring: !canToggle,
            child: Opacity(
              opacity: canToggle ? 1.0 : 0.6,
              child: KinlyCheckbox(
                value: selected,
                onChanged: (value) => onToggled?.call(value),
              ),
            ),
          ),
          KinlyCircleAvatar(
            avatarUrl: participant.avatarUrl,
            radius: 20,
            isOwner: participant.isOwner,
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(
              participant.displayName,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          SizedBox(
            width: 110,
            child: KinlyTextField(
              controller: controller,
              enabled: canEditAmount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              labelText: s.shareCreateCustomAmountLabel,
              onChanged: onAmountChanged,
            ),
          ),
        ],
      ),
    );
  }
}

Color _validationColor(dynamic theme) {
  final tokens = theme.extension<KinlyColorTokens>();
  final scheme = theme.colorScheme;
  // Use the same high-contrast error color in both themes to keep helper text visible.
  return tokens?.error ?? scheme.error;
}
