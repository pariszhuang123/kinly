part of 'share_create_form_view.dart';

// ----------------------------------------------------------------------
// Sub-widgets: fields + sections
// ----------------------------------------------------------------------

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({
    required this.controller,
    required this.state,
    required this.showValidation,
    required this.enabled,
  });

  final TextEditingController controller;
  final ShareCreateState state;
  final bool showValidation;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return KinlyTextField(
      controller: controller,
      enabled: enabled,
      labelText: s.shareCreateDescriptionLabel,
      hintText: s.shareCreateDescriptionHint,
      errorText:
          showValidation && !state.form.hasValidDescription
              ? s.shareCreateValidationDescription
              : null,
      onChanged:
          (value) => context.read<ShareCreateBloc>().add(
            ShareCreateDescriptionChanged(value),
          ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.controller,
    required this.state,
    required this.showValidation,
    required this.locked,
  });

  final TextEditingController controller;
  final ShareCreateState state;
  final bool showValidation;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final requiresAmount =
        state.isEditing ? !state.isAmountLocked : state.form.splitMode != null;

    return KinlyTextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: !locked,
      labelText: s.shareCreateAmountLabel,
      hintText: s.shareCreateAmountHint,
      errorText:
          showValidation &&
                  requiresAmount &&
                  (state.form.amountCents == null ||
                      state.form.amountCents! <= 0)
              ? s.shareCreateValidationAmount
              : null,
      onChanged:
          (value) => context.read<ShareCreateBloc>().add(
            ShareCreateAmountChanged(value),
          ),
    );
  }
}

class _SplitModeSelector extends StatelessWidget {
  const _SplitModeSelector({required this.state, required this.locked});

  final ShareCreateState state;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    final splitMode = state.form.splitMode; // ShareSplitMode?

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.shareCreateSplitLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing.sm),
        Opacity(
          opacity: locked ? 0.6 : 1.0,
          child: IgnorePointer(
            ignoring: locked,
            child: KinlyTabBar<ShareSplitMode>(
              tabs: {
                ShareSplitMode.equal: s.shareCreateSplitEqual,
                ShareSplitMode.custom: s.shareCreateSplitCustom,
              },
              selected: splitMode, // nullable
              emptySelectionAllowed: true, // key line
              onChanged: (mode) {
                // mode is ShareSplitMode? (can be null)
                context.read<ShareCreateBloc>().add(
                  ShareCreateSplitModeChanged(mode),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _StartDateField extends StatelessWidget {
  const _StartDateField({required this.state, required this.locked});

  final ShareCreateState state;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final dateLabel = DateFormat.yMMMMd().format(state.form.startDate);
    final today = todayDateOnly();
    final firstDate = today.subtract(const Duration(days: 90));
    final lastDate = today.add(const Duration(days: 365));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.shareCreateStartLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing.xs),
        KinlyOutlinedButton.text(
          onPressed:
              locked
                  ? null
                  : () async {
                    final picked = await showKinlyDateOnlyPicker(
                      context: context,
                      initialDate: dateOnly(state.form.startDate),
                      firstDate: firstDate,
                      lastDate: lastDate,
                    );
                    if (picked != null && context.mounted) {
                      context.read<ShareCreateBloc>().add(
                        ShareCreateStartDateChanged(picked),
                      );
                    }
                  },
          label: dateLabel,
        ),
      ],
    );
  }
}

class _RecurrenceField extends StatelessWidget {
  const _RecurrenceField({
    required this.state,
    required this.locked,
    required this.recurrenceNeedsSplit,
    required this.recurrenceInvalid,
    required this.controller,
  });

  final ShareCreateState state;
  final bool locked;
  final bool recurrenceNeedsSplit;
  final bool recurrenceInvalid;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final isRecurring = state.form.isRecurring;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.shareCreateRecurrenceLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing.xs),
        Opacity(
          opacity: locked ? 0.6 : 1.0,
          child: IgnorePointer(
            ignoring: locked,
            child: Row(
              children: [
                KinlyCheckbox(
                  value: isRecurring,
                  onChanged:
                      (value) => context.read<ShareCreateBloc>().add(
                        ShareCreateRecurrenceToggled(value),
                      ),
                ),
                SizedBox(width: spacing.xs),
                Text(s.shareCreateRecurrenceToggleLabel),
              ],
            ),
          ),
        ),
        if (isRecurring) ...[
          SizedBox(height: spacing.xs),
          Opacity(
            opacity: locked ? 0.6 : 1.0,
            child: IgnorePointer(
              ignoring: locked,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.shareCreateRecurrenceEveryLabel),
                  SizedBox(width: spacing.sm),
                  SizedBox(
                    width: 72,
                    child: KinlyTextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged:
                          (value) => context.read<ShareCreateBloc>().add(
                            ShareCreateRecurrenceEveryChanged(value),
                          ),
                      errorText:
                          recurrenceInvalid
                              ? s.shareCreateValidationRecurrence
                              : null,
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: KinlyDropdownField<ExpenseRecurrenceUnit>(
                      value: state.form.recurrenceUnit,
                      items:
                          ExpenseRecurrenceUnit.values
                              .map(
                                (value) => KinlyDropdownMenuItem.item(
                                  value: value,
                                  child: Text(
                                    _recurrenceUnitLabel(context, value),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) => context.read<ShareCreateBloc>().add(
                            ShareCreateRecurrenceUnitChanged(value!),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (recurrenceNeedsSplit || recurrenceInvalid)
          Padding(
            padding: EdgeInsets.only(top: spacing.xs),
            child: Text(
              recurrenceNeedsSplit
                  ? s.shareCreateValidationRecurrenceSplit
                  : s.shareCreateValidationRecurrence,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  String _recurrenceUnitLabel(
    BuildContext context,
    ExpenseRecurrenceUnit unit,
  ) {
    final s = S.of(context);
    switch (unit) {
      case ExpenseRecurrenceUnit.day:
        return s.shareCreateRecurrenceUnitDay;
      case ExpenseRecurrenceUnit.week:
        return s.shareCreateRecurrenceUnitWeek;
      case ExpenseRecurrenceUnit.month:
        return s.shareCreateRecurrenceUnitMonth;
      case ExpenseRecurrenceUnit.year:
        return s.shareCreateRecurrenceUnitYear;
    }
  }
}

class _EmptyParticipantsText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);

    return Text(
      s.shareCreateParticipantsEmpty,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _NotesField extends StatelessWidget {
  const _NotesField({required this.controller, required this.enabled});

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return KinlyTextField(
      controller: controller,
      enabled: enabled,
      minLines: 3,
      maxLines: 4,
      labelText: s.shareCreateNotesLabel,
      hintText: s.shareCreateNotesHint,
      onChanged:
          (value) => context.read<ShareCreateBloc>().add(
            ShareCreateNotesChanged(value),
          ),
    );
  }
}

class _OptionalDetailsExpansion extends StatefulWidget {
  const _OptionalDetailsExpansion({
    required this.spacing,
    required this.title,
    required this.notesController,
    required this.notesEnabled,
    required this.isUploadingEvidencePhoto,
    required this.evidencePhotoUrl,
    required this.evidencePhotoEnabled,
    required this.onEvidencePhotoCapture,
    required this.shareColors,
    this.initiallyExpanded = false,
  });

  final Spacing spacing;
  final String title;
  final TextEditingController notesController;
  final bool notesEnabled;
  final bool isUploadingEvidencePhoto;
  final String? evidencePhotoUrl;
  final bool evidencePhotoEnabled;
  final VoidCallback onEvidencePhotoCapture;
  final SectionColors? shareColors;
  final bool initiallyExpanded;

  @override
  State<_OptionalDetailsExpansion> createState() =>
      _OptionalDetailsExpansionState();
}

class _OptionalDetailsExpansionState extends State<_OptionalDetailsExpansion> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(covariant _OptionalDetailsExpansion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initiallyExpanded && !_isExpanded) {
      _isExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final colors =
        widget.shareColors ??
        SectionColors(
          background: colorScheme.surfaceContainerHigh,
          card: colorScheme.surfaceContainerHigh,
          icon: colorScheme.onSurfaceVariant,
          accent: colorScheme.primary,
        );

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: KinlyExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged:
            (expanded) => setState(() {
              _isExpanded = expanded;
            }),
        trailing: KinlyExpandBadge(isExpanded: _isExpanded, colors: colors),
        title: Text(widget.title, style: theme.textTheme.titleMedium),
        childrenPadding: EdgeInsetsDirectional.fromSTEB(
          16,
          0,
          16,
          widget.spacing.md,
        ),
        children: [
          SizedBox(height: widget.spacing.md),
          _NotesField(
            controller: widget.notesController,
            enabled: widget.notesEnabled,
          ),
          SizedBox(height: widget.spacing.lg),
          _EvidencePhotoPicker(
            spacing: widget.spacing,
            isUploading: widget.isUploadingEvidencePhoto,
            photoUrl: widget.evidencePhotoUrl,
            enabled: widget.evidencePhotoEnabled,
            onCapture: widget.onEvidencePhotoCapture,
          ),
        ],
      ),
    );
  }
}

class _EvidencePhotoPicker extends StatelessWidget {
  const _EvidencePhotoPicker({
    required this.spacing,
    required this.isUploading,
    required this.photoUrl,
    required this.enabled,
    required this.onCapture,
  });

  final Spacing spacing;
  final bool isUploading;
  final String? photoUrl;
  final bool enabled;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final hasPhoto = photoUrl?.trim().isNotEmpty == true;

    final preview = Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child:
                hasPhoto && photoUrl != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Center(
                              child: Text(
                                s.flowChorePhotoLoadError,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      ),
                    )
                    : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            KinlyIcons.photoCameraOutlined,
                            size: 32,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(height: spacing.xs),
                          Text(
                            s.flowChorePhotoPlaceholder,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
          ),
          if (isUploading)
            Container(
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(
                  alpha:
                      KinlyThemeAccess.of(
                        context,
                      ).extension<KinlyOpacity>()!.alphaHalo,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: KinlyLoader(size: 32)),
            ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.shoppingPhotoLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing.xs),
        Opacity(
          opacity: enabled ? 1 : 0.6,
          child: IgnorePointer(
            ignoring: !enabled || isUploading,
            child: KinlyTapTarget(
              onTap: onCapture,
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(aspectRatio: 4 / 3, child: preview),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.shareColors,
    required this.isBusy,
    required this.shouldDisable,
    this.destructive = false,
    required this.onPressed,
  });

  final String label;
  final SectionColors? shareColors;
  final bool isBusy;
  final bool shouldDisable;
  final bool destructive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final button =
        destructive
            ? KinlyFilledButton.destructiveText(
              fullWidth: true,
              onPressed: shouldDisable ? null : onPressed,
              label: label,
            )
            : KinlyFilledButton.text(
              fullWidth: true,
              onPressed: shouldDisable ? null : onPressed,
              label: label,
            );

    if (!isBusy) return button;

    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 0.6, child: button),
        const SizedBox(height: 20, width: 20, child: KinlyLoader(size: 20)),
      ],
    );
  }
}

// ----------------------------------------------------------------------
// Participants section + row
// ----------------------------------------------------------------------
