part of '../flow_chore_screen.dart';

class _FlowChoreFormView extends StatelessWidget {
  const _FlowChoreFormView({
    required this.titleController,
    required this.notesController,
    required this.howToController,
    required this.state,
    required this.spacing,
    required this.flowColors,
    required this.isUploadingPhoto,
    required this.expectationPhotoUrl,
    required this.onPhotoCapture,
    required this.recurrenceEveryController,
  });

  final TextEditingController titleController;
  final TextEditingController notesController;
  final TextEditingController howToController;
  final FlowChoreState state;
  final Spacing? spacing;
  final SectionColors? flowColors;
  final bool isUploadingPhoto;
  final String? expectationPhotoUrl;
  final VoidCallback onPhotoCapture;
  final TextEditingController recurrenceEveryController;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final form = state.form;
    final showValidation = state.showValidationErrors;
    final hasAssigneeError =
        _hasAssigneeValidation(showValidation, state.requiresAssignee, form);
    final hasDateError = showValidation && !state.isStartDateValid;
    final hasHowToError = showValidation && !form.isHowToUrlValid;
    final hasRecurrenceError =
        showValidation && form.isRecurring && !form.isRecurrenceValid;
    final expandOptional =
        _shouldExpandOptional(form, hasHowToError: hasHowToError);

    return ListView(
      children: [
        SizedBox(height: spacing?.xl ?? 16),
        _buildTitleField(context, s, form, showValidation),
        SizedBox(height: spacing?.lg ?? 16),
        ..._buildAssigneeSection(context, theme, s, hasAssigneeError, form),
        SizedBox(height: spacing?.lg ?? 16),
        ..._buildStartDateSection(context, theme, s, form, hasDateError),
        SizedBox(height: spacing?.lg ?? 16),
        _RecurrenceField(
          form: form,
          showValidation: showValidation,
          hasRecurrenceError: hasRecurrenceError,
          controller: recurrenceEveryController,
        ),
        SizedBox(height: spacing?.lg ?? 16),
        _OptionalDetailsExpansion(
          spacing: spacing,
          s: s,
          hasHowToError: hasHowToError,
          notesController: notesController,
          howToController: howToController,
          isUploadingPhoto: isUploadingPhoto,
          photoUrl: expectationPhotoUrl,
          onPhotoCapture: onPhotoCapture,
          flowColors: flowColors,
          initiallyExpanded: expandOptional,
        ),
        SizedBox(height: spacing?.xl ?? 24),
      ],
    );
  }

  bool _hasAssigneeValidation(
    bool showValidation,
    bool requiresAssignee,
    FlowChoreForm form,
  ) {
    return showValidation && requiresAssignee && form.assigneeUserId == null;
  }

  bool _shouldExpandOptional(
    FlowChoreForm form, {
    required bool hasHowToError,
  }) {
    final hasOptionalContent =
        form.notes.trim().isNotEmpty ||
        form.howToVideoUrl.trim().isNotEmpty ||
        form.expectationPhotoPath.trim().isNotEmpty;
    return hasOptionalContent || hasHowToError;
  }

  Widget _buildTitleField(
    BuildContext context,
    S s,
    FlowChoreForm form,
    bool showValidation,
  ) {
    return KinlyTextField(
      controller: titleController,
      labelText: s.flowChoreNameLabel,
      hintText: s.flowChoreNameHint,
      errorText:
          showValidation && !form.isTitleValid
              ? s.flowChoreValidationName
              : null,
      textInputAction: TextInputAction.next,
      onChanged:
          (value) => context.read<FlowChoreBloc>().add(
            FlowChoreTitleChanged(value),
          ),
    );
  }

  List<Widget> _buildAssigneeSection(
    BuildContext context,
    dynamic theme,
    S s,
    bool hasAssigneeError,
    FlowChoreForm form,
  ) {
    return [
      Text(s.flowChoreAssigneeLabel, style: theme.textTheme.titleMedium),
      SizedBox(height: spacing?.sm ?? 8),
      _AssigneeSelector(
        assignees: state.assignees,
        selectedUserId: form.assigneeUserId,
      ),
      if (hasAssigneeError)
        Padding(
          padding: EdgeInsets.only(top: spacing?.xs ?? 4),
          child: Text(
            s.flowChoreValidationAssignee,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
    ];
  }

  List<Widget> _buildStartDateSection(
    BuildContext context,
    dynamic theme,
    S s,
    FlowChoreForm form,
    bool hasDateError,
  ) {
    final dateLabel = DateFormat.yMMMMd().format(form.startDate);
    return [
      Text(s.flowChoreStartLabel, style: theme.textTheme.titleMedium),
      SizedBox(height: spacing?.xs ?? 4),
      KinlyOutlinedButton.text(
        onPressed: () => _pickStartDate(context, form.startDate),
        label: dateLabel,
      ),
      if (hasDateError)
        Padding(
          padding: EdgeInsets.only(top: spacing?.xs ?? 4),
          child: Text(
            s.flowChoreValidationDate,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
    ];
  }

  Future<void> _pickStartDate(BuildContext context, DateTime current) async {
    final now = DateTime.now();
    final today = todayDateOnly(now);
    final currentDay = dateOnly(current);
    final earliestBase = DateTime(today.year - 10, today.month, today.day);
    final firstDate =
        currentDay.isBefore(earliestBase)
            ? DateTime(currentDay.year, currentDay.month, currentDay.day)
            : earliestBase;
    final lastDate = DateTime(today.year + 1, today.month, today.day);

    final picked = await showKinlyDateOnlyPicker(
      context: context,
      initialDate: currentDay,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && context.mounted) {
      context.read<FlowChoreBloc>().add(FlowChoreStartDateChanged(picked));
    }
  }

}

class _RecurrenceField extends StatelessWidget {
  const _RecurrenceField({
    required this.form,
    required this.showValidation,
    required this.hasRecurrenceError,
    required this.controller,
  });

  final FlowChoreForm form;
  final bool showValidation;
  final bool hasRecurrenceError;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final isRecurring = form.isRecurring;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.flowChoreRecurrenceLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing.xs),
        Row(
          children: [
            KinlyCheckbox(
              value: isRecurring,
              onChanged:
                  (value) => context.read<FlowChoreBloc>().add(
                    FlowChoreRecurrenceToggled(value ?? false),
                  ),
            ),
            SizedBox(width: spacing.xs),
            Text(s.shareCreateRecurrenceToggleLabel),
          ],
        ),
        if (isRecurring) ...[
          SizedBox(height: spacing.xs),
          Row(
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
                      (value) => context.read<FlowChoreBloc>().add(
                        FlowChoreRecurrenceEveryChanged(value),
                      ),
                  errorText:
                      showValidation && hasRecurrenceError
                      ? s.shareCreateValidationRecurrence
                      : null,
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: KinlyDropdownField<ChoreRecurrenceUnit>(
                  value: form.recurrenceUnit,
                  items:
                      ChoreRecurrenceUnit.values
                          .map(
                            (value) => KinlyDropdownMenuItem.item(
                              value: value,
                              child: Text(_recurrenceUnitLabel(context, value)),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) => context.read<FlowChoreBloc>().add(
                        FlowChoreRecurrenceUnitChanged(value!),
                      ),
                ),
              ),
            ],
          ),
        ],
        if (showValidation && hasRecurrenceError)
          Padding(
            padding: EdgeInsets.only(top: spacing.xs),
            child: Text(
              s.shareCreateValidationRecurrence,
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
    ChoreRecurrenceUnit unit,
  ) {
    final s = S.of(context);
    switch (unit) {
      case ChoreRecurrenceUnit.day:
        return s.shareCreateRecurrenceUnitDay;
      case ChoreRecurrenceUnit.week:
        return s.shareCreateRecurrenceUnitWeek;
      case ChoreRecurrenceUnit.month:
        return s.shareCreateRecurrenceUnitMonth;
      case ChoreRecurrenceUnit.year:
        return s.shareCreateRecurrenceUnitYear;
    }
  }
}

class _AssigneeSelector extends StatelessWidget {
  const _AssigneeSelector({
    required this.assignees,
    required this.selectedUserId,
  });

  final List<ChoreAssigneeSummary> assignees;
  final String? selectedUserId;

  @override
  Widget build(BuildContext context) {
    if (assignees.isEmpty) return const SizedBox.shrink();

    final members = assignees
        .map(
          (assignee) => HomeMemberSummary(
            userId: assignee.userId,
            username: assignee.fullName ?? '',
            role: assignee.isOwner ? 'owner' : 'member',
            validFrom: DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
            avatarUrl: assignee.avatarStoragePath,
            isOwner: assignee.isOwner,
          ),
        )
        .toList(growable: false);

    final selectedIds =
        selectedUserId != null ? {selectedUserId!} : const <String>{};

    return KinlySelectableMemberAvatarRow(
      members: members,
      selectedMemberIds: selectedIds,
      avatarRadius: 22,
      onToggle: (memberId) {
        if (selectedUserId == memberId) return;
        context.read<FlowChoreBloc>().add(FlowChoreAssigneeChanged(memberId));
      },
    );
  }
}

class _OptionalDetailsExpansion extends StatefulWidget {
  const _OptionalDetailsExpansion({
    required this.spacing,
    required this.s,
    required this.hasHowToError,
    required this.notesController,
    required this.howToController,
    required this.isUploadingPhoto,
    required this.photoUrl,
    required this.onPhotoCapture,
    required this.flowColors,
    this.initiallyExpanded = false,
  });

  final Spacing? spacing;
  final S s;
  final bool hasHowToError;
  final TextEditingController notesController;
  final TextEditingController howToController;
  final bool isUploadingPhoto;
  final String? photoUrl;
  final VoidCallback onPhotoCapture;
  final SectionColors? flowColors;
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
    _isExpanded = widget.initiallyExpanded || widget.hasHowToError;
  }

  @override
  void didUpdateWidget(covariant _OptionalDetailsExpansion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasHowToError && !_isExpanded) {
      _isExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final colors =
        widget.flowColors ??
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
        title: Text(
          widget.s.flowChoreDetailMoreInfoTitle,
          style: theme.textTheme.titleMedium,
        ),
        childrenPadding: EdgeInsetsDirectional.fromSTEB(
          16,
          0,
          16,
          widget.spacing?.md ?? 16,
        ),
        children: [
          SizedBox(height: widget.spacing?.xl ?? 16),
          KinlyTextField(
            controller: widget.notesController,
            minLines: 3,
            maxLines: 4,
            labelText: widget.s.flowChoreNotesLabel,
            hintText: widget.s.flowChoreNotesHint,
            onChanged:
                (value) => context.read<FlowChoreBloc>().add(
                  FlowChoreNotesChanged(value),
                ),
          ),
          SizedBox(height: widget.spacing?.lg ?? 16),
          KinlyTextField(
            controller: widget.howToController,
            labelText: widget.s.flowChoreHowToLabel,
            hintText: widget.s.flowChoreHowToHint,
            errorText:
                widget.hasHowToError
                    ? widget.s.flowChoreValidationHowToUrl
                    : null,
            keyboardType: TextInputType.url,
            onChanged:
                (value) => context.read<FlowChoreBloc>().add(
                  FlowChoreHowToChanged(value),
                ),
          ),
          SizedBox(height: widget.spacing?.lg ?? 16),
          _ExpectationPhotoPicker(
            spacing: widget.spacing,
            s: widget.s,
            isUploading: widget.isUploadingPhoto,
            photoUrl: widget.photoUrl,
            onCapture: widget.onPhotoCapture,
          ),
        ],
      ),
    );
  }
}

