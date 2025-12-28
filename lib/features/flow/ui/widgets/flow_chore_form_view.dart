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

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final form = state.form;
    final showValidation = state.showValidationErrors;
    final requiresAssignee = state.requiresAssignee;
    final hasAssigneeError =
        showValidation && requiresAssignee && form.assigneeUserId == null;
    final hasDateError = showValidation && !state.isStartDateValid;
    final hasHowToError = showValidation && !form.isHowToUrlValid;
    final hasOptionalContent =
        form.notes.trim().isNotEmpty ||
        form.howToVideoUrl.trim().isNotEmpty ||
        form.expectationPhotoPath.trim().isNotEmpty;
    final expandOptional = hasOptionalContent || hasHowToError;
    final dateLabel = DateFormat.yMMMMd().format(form.startDate);

    return ListView(
      children: [
        SizedBox(height: spacing?.xl ?? 16),
        KinlyTextField(
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
        ),
        SizedBox(height: spacing?.lg ?? 16),
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
        SizedBox(height: spacing?.lg ?? 16),
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
        SizedBox(height: spacing?.lg ?? 16),
        KinlyDropdownField<ChoreRecurrence>(
          value: form.recurrence,
          labelText: s.flowChoreRecurrenceLabel,
          items:
              ChoreRecurrence.values
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(_recurrenceLabel(context, value)),
                    ),
                  )
                  .toList(),
          onChanged:
              (value) => context.read<FlowChoreBloc>().add(
                FlowChoreRecurrenceChanged(value!),
              ),
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

  Future<void> _pickStartDate(BuildContext context, DateTime current) async {
    final now = DateTime.now();
    final earliestBase = DateTime(now.year - 10, now.month, now.day);
    final firstDate =
        current.isBefore(earliestBase)
            ? DateTime(current.year, current.month, current.day)
            : earliestBase;
    final lastDate = DateTime(now.year + 1, now.month, now.day);

    final picked = await showKinlyDatePicker(
      context: context,
      initialDate: current,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && context.mounted) {
      context.read<FlowChoreBloc>().add(FlowChoreStartDateChanged(picked));
    }
  }

  String _recurrenceLabel(BuildContext context, ChoreRecurrence recurrence) {
    final s = S.of(context);
    switch (recurrence) {
      case ChoreRecurrence.none:
        return s.flowChoreRecurrenceNone;
      case ChoreRecurrence.daily:
        return s.flowChoreRecurrenceDaily;
      case ChoreRecurrence.weekly:
        return s.flowChoreRecurrenceWeekly;
      case ChoreRecurrence.every2Weeks:
        return s.flowChoreRecurrenceEvery2Weeks;
      case ChoreRecurrence.monthly:
        return s.flowChoreRecurrenceMonthly;
      case ChoreRecurrence.every2Months:
        return s.flowChoreRecurrenceEvery2Months;
      case ChoreRecurrence.annual:
        return s.flowChoreRecurrenceAnnual;
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
    final theme = Theme.of(context);
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
      child: ExpansionTile(
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
