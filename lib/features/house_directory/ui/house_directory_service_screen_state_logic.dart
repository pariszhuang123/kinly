part of 'house_directory_service_screen.dart';

Widget _buildHouseDirectoryServiceBody({
  required _HouseDirectoryServiceScreenState screen,
  required HouseDirectoryState state,
  required HouseDirectoryService? service,
  required HouseDirectoryReminder? reminder,
}) {
  final s = S.of(screen.context);
  final canShow = screen.widget.isCreating || service != null;

  if (!canShow && state.isLoading) {
    return const Center(child: KinlyLoader());
  }
  if (!canShow) {
    return Center(child: Text(s.houseDirectoryLoadError));
  }

  final hasChanges = houseDirectoryServiceHasChanges(
    isCreating: screen.widget.isCreating,
    service: service,
    type: screen._type,
    providerController: screen._providerController,
    customLabelController: screen._customLabelController,
    referenceController: screen._referenceController,
    linkController: screen._linkController,
    notesController: screen._notesController,
    offsetValueController: screen._offsetValueController,
    offsetUnit: screen._offsetUnit,
    startDate: screen._startDate,
    endDate: screen._endDate,
  );

  return HouseDirectoryServiceContent(
    service: service,
    isEditing: screen._isEditing && screen.widget.isOwner,
    isCreating: screen.widget.isCreating,
    hasChanges: hasChanges,
    canSubmit: screen.widget.isCreating || hasChanges,
    type: screen._type,
    offsetUnit: screen._offsetUnit,
    startDate: screen._startDate,
    endDate: screen._endDate,
    providerController: screen._providerController,
    customLabelController: screen._customLabelController,
    referenceController: screen._referenceController,
    linkController: screen._linkController,
    offsetValueController: screen._offsetValueController,
    notesController: screen._notesController,
    providerError: screen._providerError,
    customLabelError: screen._customLabelError,
    linkError: screen._linkError,
    offsetValueError: screen._offsetValueError,
    validationError: screen._validationError,
    onTypeChanged: (value) => _updateHouseDirectoryServiceType(screen, value),
    onStartPressed: screen._pickStartDate,
    onEndPressed: screen._pickEndDate,
    onOffsetUnitChanged:
        (value) => _updateHouseDirectoryReminderOffsetUnit(screen, value),
    onArchive: () => screen._confirmArchive(service),
    onSave: () => screen._save(service),
    reminder: reminder,
    onCreateTask: buildHouseDirectoryCreateTaskAction(
      isOwner: screen.widget.isOwner,
      isEditing: screen._isEditing,
      service: service,
      reminder: reminder,
      onCreateTask: screen._openCreateTask,
    ),
  );
}

void _updateHouseDirectoryServiceType(
  _HouseDirectoryServiceScreenState screen,
  HouseDirectoryServiceType? value,
) {
  if (value == null) return;
  screen.setState(() => screen._type = value);
}

void _updateHouseDirectoryReminderOffsetUnit(
  _HouseDirectoryServiceScreenState screen,
  HouseDirectoryReminderOffsetUnit? value,
) {
  if (value == null) return;
  screen.setState(() => screen._offsetUnit = value);
}

void _hydrateHouseDirectoryService(
  _HouseDirectoryServiceScreenState screen,
  HouseDirectoryService? service,
) {
  if (screen.widget.isCreating || service == null) return;
  if (screen._hydratedServiceId == service.id) return;
  screen._isHydrating = true;
  try {
    screen._hydratedServiceId = service.id;
    screen._providerController.text = service.providerName;
    screen._customLabelController.text = service.customLabel ?? '';
    screen._referenceController.text = service.accountReference ?? '';
    screen._linkController.text = service.linkUrl ?? '';
    screen._offsetValueController.text =
        service.renewalReminderOffsetValue?.toString() ?? '';
    screen._notesController.text = service.notes ?? '';
    screen._type = service.serviceType;
    screen._offsetUnit = service.renewalReminderOffsetUnit;
    screen._startDate = service.termStartDate;
    screen._endDate = service.termEndDate;
    _seedHouseDirectoryReminderDefaults(screen);
  } finally {
    screen._isHydrating = false;
  }
}

void _scheduleHouseDirectoryServiceHydration(
  _HouseDirectoryServiceScreenState screen,
  HouseDirectoryService? service,
) {
  if (screen.widget.isCreating || service == null) return;
  if (screen._hydratedServiceId == service.id) return;
  if (screen._pendingHydrationServiceId == service.id) return;
  screen._pendingHydrationServiceId = service.id;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    screen._pendingHydrationServiceId = null;
    if (!screen.mounted) return;
    final latestService = screen._resolveService(
      screen.context.read<HouseDirectoryBloc>().state,
    );
    if (latestService == null) return;
    if (screen._hydratedServiceId == latestService.id) {
      return;
    }
    screen.setState(() {
      _hydrateHouseDirectoryService(screen, latestService);
    });
  });
}

void _saveHouseDirectoryService(
  _HouseDirectoryServiceScreenState screen,
  HouseDirectoryService? service,
) {
  final validation = validateHouseDirectoryService(
    s: S.of(screen.context),
    type: screen._type,
    providerController: screen._providerController,
    customLabelController: screen._customLabelController,
    linkController: screen._linkController,
    offsetValueController: screen._offsetValueController,
    startDate: screen._startDate,
    endDate: screen._endDate,
  );
  if (validation.hasError) {
    _applyHouseDirectoryServiceValidationErrors(screen, validation);
    return;
  }

  screen.setState(() {
    screen._validationError = null;
    screen._providerError = null;
    screen._customLabelError = null;
    screen._linkError = null;
    screen._offsetValueError = null;
  });

  final offsetValue = _parseHouseDirectoryReminderOffset(screen);
  screen.context.read<HouseDirectoryBloc>().add(
    HouseDirectoryServiceSaved(
      UpsertHouseDirectoryServiceInput(
        homeId: screen.widget.homeId,
        serviceId: service?.id,
        serviceType: screen._type,
        providerName: screen._providerController.text.trim(),
        customLabel: _emptyToNull(screen._customLabelController.text),
        accountReference: _emptyToNull(screen._referenceController.text),
        linkUrl: _emptyToNull(screen._linkController.text),
        termStartDate: screen._startDate,
        termEndDate: screen._endDate,
        renewalReminderOffsetValue: offsetValue,
        renewalReminderOffsetUnit:
            _resolveHouseDirectoryReminderOffsetUnit(screen, offsetValue),
        notes: _emptyToNull(screen._notesController.text),
      ),
    ),
  );
}

void _applyHouseDirectoryServiceValidationErrors(
  _HouseDirectoryServiceScreenState screen,
  HouseDirectoryServiceValidationResult validation,
) {
  screen.setState(() {
    screen._providerError = validation.providerError;
    screen._customLabelError = validation.customLabelError;
    screen._linkError = validation.linkError;
    screen._offsetValueError = validation.offsetValueError;
    screen._validationError = validation.summaryError;
  });
}

int? _parseHouseDirectoryReminderOffset(
  _HouseDirectoryServiceScreenState screen,
) {
  final offsetValueRaw = screen._offsetValueController.text.trim();
  if (screen._endDate == null || offsetValueRaw.isEmpty) {
    return null;
  }
  return int.tryParse(offsetValueRaw);
}

HouseDirectoryReminderOffsetUnit? _resolveHouseDirectoryReminderOffsetUnit(
  _HouseDirectoryServiceScreenState screen,
  int? offsetValue,
) {
  if (screen._endDate == null || offsetValue == null) {
    return null;
  }
  return screen._offsetUnit;
}

void _seedHouseDirectoryReminderDefaults(
  _HouseDirectoryServiceScreenState screen,
) {
  if (screen._endDate == null) {
    screen._offsetValueController.clear();
    screen._offsetUnit = null;
    return;
  }
  final hasOffsetValue = screen._offsetValueController.text.trim().isNotEmpty;
  if (hasOffsetValue && screen._offsetUnit != null) {
    return;
  }
  screen._offsetValueController.text = '1';
  screen._offsetUnit = defaultHouseDirectoryReminderOffsetUnit(
    endDate: screen._endDate!,
    today: DateTime.now(),
    daysPerMonth: _HouseDirectoryServiceScreenState._daysPerMonth,
  );
}

Future<void> _openHouseDirectoryCreateTask(
  _HouseDirectoryServiceScreenState screen,
  HouseDirectoryService service,
  HouseDirectoryReminder reminder,
) async {
  final ownerUserId = screen._ownerUserId(
    screen.context.read<HouseDirectoryBloc>().state,
  );
  final result = await screen.context.pushNamed<FlowChoreOutcome>(
    AppRouteNames.flowChoreCreate,
    queryParameters: {'homeId': screen.widget.homeId},
    extra: FlowChoreRouteArgs(
      initialForm: FlowChorePrefill(
        startDate: reminder.dueAt,
        assigneeUserId: ownerUserId,
        title: screen._taskTitleFor(service),
        notes: buildHouseDirectoryTaskNotes(
          strings: S.of(screen.context),
          service: service,
          reminder: reminder,
        ),
        howToVideoUrl: service.linkUrl ?? '',
      ),
    ),
  );
  if (!screen.mounted || result == null || result.isDeleted) return;
  screen.context.read<HouseDirectoryBloc>().add(
    HouseDirectoryReminderDismissed(reminder.id),
  );
  KinlySnackBar.showSuccess(
    screen.context,
    S.of(screen.context).flowChoreCreateSuccess,
  );
  if (screen.widget.reminderId != null) {
    Navigator.of(screen.context).pop();
  }
}

void _handleHouseDirectoryServiceNotice(
  _HouseDirectoryServiceScreenState screen,
  BuildContext context,
  HouseDirectoryState state,
) {
  final notice = state.notice;
  if (notice == null) {
    screen._lastHandledNotice = null;
    return;
  }
  if (notice == screen._lastHandledNotice) return;
  screen._lastHandledNotice = notice;
  if (!screen.mounted) return;

  switch (notice) {
    case HouseDirectoryNotice.serviceSaved:
      Navigator.of(context).pop(
        screen.widget.isCreating
            ? HouseDirectoryRouteResult.serviceCreated
            : HouseDirectoryRouteResult.serviceUpdated,
      );
      return;
    case HouseDirectoryNotice.serviceArchived:
      Navigator.of(context).pop(HouseDirectoryRouteResult.serviceArchived);
      return;
    case HouseDirectoryNotice.actionFailed:
      KinlySnackBar.showError(
        context,
        state.errorMessage ?? S.of(context).houseDirectoryActionFailed,
      );
      return;
    default:
      return;
  }
}
