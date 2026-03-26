import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/inputs/kinly_dropdown_field.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_dropdown_menu_item.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/features/house_directory/ui/house_directory_sections.dart';
import 'package:kinly/generated/l10n.dart';

class HouseDirectoryServiceContent extends StatelessWidget {
  const HouseDirectoryServiceContent({
    super.key,
    required this.service,
    required this.isEditing,
    required this.isCreating,
    required this.hasChanges,
    required this.canSubmit,
    required this.type,
    required this.offsetUnit,
    required this.startDate,
    required this.endDate,
    required this.providerController,
    required this.customLabelController,
    required this.referenceController,
    required this.linkController,
    required this.offsetValueController,
    required this.notesController,
    required this.providerError,
    required this.customLabelError,
    required this.linkError,
    required this.offsetValueError,
    required this.validationError,
    required this.onTypeChanged,
    required this.onStartPressed,
    required this.onEndPressed,
    required this.onOffsetUnitChanged,
    required this.onArchive,
    required this.onSave,
    this.reminder,
    this.onCreateTask,
  });

  final HouseDirectoryService? service;
  final bool isEditing;
  final bool isCreating;
  final bool hasChanges;
  final bool canSubmit;
  final HouseDirectoryServiceType type;
  final HouseDirectoryReminderOffsetUnit? offsetUnit;
  final DateTime? startDate;
  final DateTime? endDate;
  final TextEditingController providerController;
  final TextEditingController customLabelController;
  final TextEditingController referenceController;
  final TextEditingController linkController;
  final TextEditingController offsetValueController;
  final TextEditingController notesController;
  final String? providerError;
  final String? customLabelError;
  final String? linkError;
  final String? offsetValueError;
  final String? validationError;
  final ValueChanged<HouseDirectoryServiceType?> onTypeChanged;
  final VoidCallback onStartPressed;
  final VoidCallback onEndPressed;
  final ValueChanged<HouseDirectoryReminderOffsetUnit?> onOffsetUnitChanged;
  final VoidCallback onArchive;
  final VoidCallback onSave;
  final HouseDirectoryReminder? reminder;
  final VoidCallback? onCreateTask;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    return Padding(
      padding: EdgeInsetsDirectional.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child:
                  isEditing
                      ? _HouseDirectoryServiceEditor(
                        type: type,
                        offsetUnit: offsetUnit,
                        startDate: startDate,
                        endDate: endDate,
                        providerController: providerController,
                        customLabelController: customLabelController,
                        referenceController: referenceController,
                        linkController: linkController,
                        offsetValueController: offsetValueController,
                        notesController: notesController,
                        providerError: providerError,
                        customLabelError: customLabelError,
                        linkError: linkError,
                        offsetValueError: offsetValueError,
                        validationError: validationError,
                        onTypeChanged: onTypeChanged,
                        onStartPressed: onStartPressed,
                        onEndPressed: onEndPressed,
                        onOffsetUnitChanged: onOffsetUnitChanged,
                      )
                      : HouseDirectoryServiceReadOnlyContent(
                        service: service!,
                        reminder: reminder,
                      ),
            ),
          ),
          if (isEditing) ...[
            SizedBox(height: spacing.lg),
            if (!isCreating && !hasChanges)
              KinlyFilledButton.destructiveText(
                onPressed: onArchive,
                label: s.houseDirectoryDelete,
                fullWidth: true,
              )
            else
              KinlyFilledButton.text(
                onPressed: canSubmit ? onSave : null,
                label: isCreating ? s.houseDirectorySave : s.houseDirectoryEdit,
                fullWidth: true,
              ),
          ] else if (onCreateTask != null) ...[
            SizedBox(height: spacing.lg),
            KinlyFilledButton.text(
              onPressed: onCreateTask,
              label: s.flowChoreSubmitCreate,
              fullWidth: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _HouseDirectoryServiceEditor extends StatelessWidget {
  const _HouseDirectoryServiceEditor({
    required this.type,
    required this.offsetUnit,
    required this.startDate,
    required this.endDate,
    required this.providerController,
    required this.customLabelController,
    required this.referenceController,
    required this.linkController,
    required this.offsetValueController,
    required this.notesController,
    required this.providerError,
    required this.customLabelError,
    required this.linkError,
    required this.offsetValueError,
    required this.validationError,
    required this.onTypeChanged,
    required this.onStartPressed,
    required this.onEndPressed,
    required this.onOffsetUnitChanged,
  });

  final HouseDirectoryServiceType type;
  final HouseDirectoryReminderOffsetUnit? offsetUnit;
  final DateTime? startDate;
  final DateTime? endDate;
  final TextEditingController providerController;
  final TextEditingController customLabelController;
  final TextEditingController referenceController;
  final TextEditingController linkController;
  final TextEditingController offsetValueController;
  final TextEditingController notesController;
  final String? providerError;
  final String? customLabelError;
  final String? linkError;
  final String? offsetValueError;
  final String? validationError;
  final ValueChanged<HouseDirectoryServiceType?> onTypeChanged;
  final VoidCallback onStartPressed;
  final VoidCallback onEndPressed;
  final ValueChanged<HouseDirectoryReminderOffsetUnit?> onOffsetUnitChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KinlyDropdownField<HouseDirectoryServiceType>(
          value: type,
          labelText: s.houseDirectoryServiceTypeLabel,
          items:
              HouseDirectoryServiceType.values
                  .map(
                    (value) => KinlyDropdownMenuItem.item(
                      value: value,
                      child: Text(value.wireValue),
                    ),
                  )
                  .toList(growable: false),
          onChanged: onTypeChanged,
        ),
        if (type == HouseDirectoryServiceType.other) ...[
          SizedBox(height: spacing.md),
          KinlyTextField(
            controller: customLabelController,
            labelText: s.houseDirectoryCustomLabel,
            hintText: s.houseDirectoryCustomLabelHint,
            errorText: customLabelError,
          ),
        ],
        SizedBox(height: spacing.md),
        KinlyTextField(
          controller: providerController,
          labelText: s.houseDirectoryProviderLabel,
          hintText: s.houseDirectoryProviderHint,
          errorText: providerError,
        ),
        SizedBox(height: spacing.md),
        KinlyTextField(
          controller: referenceController,
          labelText: s.houseDirectoryAccountReferenceLabel,
          hintText: s.houseDirectoryAccountReferenceHint,
        ),
        SizedBox(height: spacing.md),
        KinlyTextField(
          controller: linkController,
          labelText: s.houseDirectoryLinkLabel,
          hintText: s.houseDirectoryProviderLinkHint,
          errorText: linkError,
        ),
        SizedBox(height: spacing.md),
        Row(
          children: [
            Expanded(
              child: KinlyOutlinedButton.text(
                onPressed: onStartPressed,
                label: _dateLabel(
                  fallback: s.houseDirectoryStartDate,
                  value: startDate,
                ),
              ),
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: KinlyOutlinedButton.text(
                onPressed: onEndPressed,
                label: _dateLabel(
                  fallback: s.houseDirectoryEndDate,
                  value: endDate,
                ),
              ),
            ),
          ],
        ),
        if (endDate != null) ...[
          SizedBox(height: spacing.md),
          Row(
            children: [
              Expanded(
                child: KinlyTextField(
                  controller: offsetValueController,
                  labelText: s.houseDirectoryReminderOffset,
                  keyboardType: TextInputType.number,
                  errorText: offsetValueError,
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: KinlyDropdownField<HouseDirectoryReminderOffsetUnit>(
                  value: offsetUnit ?? HouseDirectoryReminderOffsetUnit.day,
                  labelText: s.houseDirectoryReminderOffsetUnit,
                  items:
                      HouseDirectoryReminderOffsetUnit.values
                          .map(
                            (value) => KinlyDropdownMenuItem.item(
                              value: value,
                              child: Text(value.wireValue),
                            ),
                          )
                          .toList(growable: false),
                  onChanged: onOffsetUnitChanged,
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: spacing.md),
        KinlyTextField(
          controller: notesController,
          labelText: s.houseDirectoryNotes,
          hintText: s.houseDirectoryNotesHint,
          minLines: 3,
          maxLines: 5,
        ),
        if (validationError != null) ...[
          SizedBox(height: spacing.md),
          Text(
            validationError!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}

class HouseDirectoryServiceReadOnlyContent extends StatelessWidget {
  const HouseDirectoryServiceReadOnlyContent({
    super.key,
    required this.service,
    this.reminder,
  });

  final HouseDirectoryService service;
  final HouseDirectoryReminder? reminder;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final format = DateFormat.yMMMd();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (reminder != null) ...[
          _ReadOnlyField(
            label: s.todayHouseDirectoryRemindersTitle,
            value: s.todayHouseDirectoryReminderDue(
              format.format(reminder!.dueAt),
            ),
          ),
          SizedBox(height: spacing.md),
        ],
        _ReadOnlyField(label: s.houseDirectoryProviderLabel, value: service.providerName),
        SizedBox(height: spacing.md),
        _ReadOnlyField(
          label: s.houseDirectoryServiceTypeLabel,
          value:
              service.serviceType == HouseDirectoryServiceType.other
                  ? (service.customLabel ?? s.houseDirectoryServiceOther)
                  : service.serviceType.wireValue,
        ),
        if ((service.accountReference ?? '').trim().isNotEmpty) ...[
          SizedBox(height: spacing.md),
          _ReadOnlyField(
            label: s.houseDirectoryAccountReferenceLabel,
            value: service.accountReference!.trim(),
          ),
        ],
        if (service.termStartDate != null || service.termEndDate != null) ...[
          SizedBox(height: spacing.md),
          _ReadOnlyField(
            label: s.houseDirectoryTermLabel,
            value: s.houseDirectoryTermRange(
              service.termStartDate == null
                  ? s.houseDirectoryDateUnknown
                  : format.format(service.termStartDate!),
              service.termEndDate == null
                  ? s.houseDirectoryDateUnknown
                  : format.format(service.termEndDate!),
            ),
          ),
        ],
        if ((service.notes ?? '').trim().isNotEmpty) ...[
          SizedBox(height: spacing.md),
          _ReadOnlyField(
            label: s.houseDirectoryNotes,
            value: service.notes!.trim(),
            maxLines: 8,
          ),
        ],
        if ((service.linkUrl ?? '').trim().isNotEmpty) ...[
          SizedBox(height: spacing.md),
          KinlyOutlinedButton.text(
            onPressed: () => launchHouseDirectoryUrl(context, service.linkUrl!),
            label: s.houseDirectoryOpenLink,
            compact: true,
          ),
        ],
      ],
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
    this.maxLines = 3,
  });

  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleSmall),
        SizedBox(height: spacing.xs),
        Container(
          width: double.infinity,
          padding: EdgeInsetsDirectional.all(spacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

String _dateLabel({required String fallback, required DateTime? value}) {
  if (value == null) return fallback;
  return DateFormat.yMMMd().format(value);
}

bool houseDirectoryServiceHasChanges({
  required bool isCreating,
  required HouseDirectoryService? service,
  required HouseDirectoryServiceType type,
  required TextEditingController providerController,
  required TextEditingController customLabelController,
  required TextEditingController referenceController,
  required TextEditingController linkController,
  required TextEditingController notesController,
  required TextEditingController offsetValueController,
  required HouseDirectoryReminderOffsetUnit? offsetUnit,
  required DateTime? startDate,
  required DateTime? endDate,
}) {
  if (isCreating) return true;
  if (service == null) return false;
  return type != service.serviceType ||
      providerController.text.trim() != service.providerName.trim() ||
      customLabelController.text.trim() != (service.customLabel ?? '').trim() ||
      referenceController.text.trim() !=
          (service.accountReference ?? '').trim() ||
      linkController.text.trim() != (service.linkUrl ?? '').trim() ||
      notesController.text.trim() != (service.notes ?? '').trim() ||
      offsetValueController.text.trim() !=
          (service.renewalReminderOffsetValue?.toString() ?? '').trim() ||
      offsetUnit != service.renewalReminderOffsetUnit ||
      startDate != service.termStartDate ||
      endDate != service.termEndDate;
}

class HouseDirectoryServiceValidationResult {
  const HouseDirectoryServiceValidationResult({
    this.summaryError,
    this.providerError,
    this.customLabelError,
    this.linkError,
    this.offsetValueError,
  });

  final String? summaryError;
  final String? providerError;
  final String? customLabelError;
  final String? linkError;
  final String? offsetValueError;

  bool get hasError =>
      summaryError != null ||
      providerError != null ||
      customLabelError != null ||
      linkError != null ||
      offsetValueError != null;
}

HouseDirectoryServiceValidationResult validateHouseDirectoryService({
  required S s,
  required HouseDirectoryServiceType type,
  required TextEditingController providerController,
  required TextEditingController customLabelController,
  required TextEditingController linkController,
  required TextEditingController offsetValueController,
  required DateTime? startDate,
  required DateTime? endDate,
}) {
  final providerError = _validateProviderName(
    s,
    providerController.text.trim(),
  );
  final customLabelError = _validateCustomLabel(
    s,
    type,
    customLabelController.text.trim(),
  );
  final linkError = _validateLinkUrl(
    s,
    linkController.text.trim(),
  );
  final offsetValueError = _validateOffsetValue(
    s,
    offsetValueController.text.trim(),
    endDate,
  );
  final summaryError = _validateServiceSummary(
    s,
    type: type,
    startDate: startDate,
    endDate: endDate,
  );

  return HouseDirectoryServiceValidationResult(
    summaryError:
        providerError == null &&
                customLabelError == null &&
                linkError == null &&
                offsetValueError == null
            ? summaryError
            : null,
    providerError: providerError,
    customLabelError: customLabelError,
    linkError: linkError,
    offsetValueError: offsetValueError,
  );
}

String? _validateProviderName(S s, String providerName) {
  return providerName.isEmpty ? s.houseDirectoryValidationProvider : null;
}

String? _validateCustomLabel(
  S s,
  HouseDirectoryServiceType type,
  String customLabel,
) {
  if (type == HouseDirectoryServiceType.other && customLabel.isEmpty) {
    return s.houseDirectoryValidationCustomLabel;
  }
  return null;
}

String? _validateLinkUrl(S s, String linkUrl) {
  if (linkUrl.isEmpty) return null;
  final uri = Uri.tryParse(linkUrl);
  final isValid = uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  return isValid ? null : s.houseDirectoryValidationUrl;
}

String? _validateOffsetValue(
  S s,
  String offsetValueRaw,
  DateTime? endDate,
) {
  if (endDate == null || offsetValueRaw.isEmpty) return null;
  final offsetValue = int.tryParse(offsetValueRaw);
  return offsetValue == null || offsetValue < 1
      ? s.houseDirectoryValidationReminderOffset
      : null;
}

String? _validateServiceSummary(
  S s, {
  required HouseDirectoryServiceType type,
  required DateTime? startDate,
  required DateTime? endDate,
}) {
  if (type == HouseDirectoryServiceType.rent &&
      (startDate == null || endDate == null)) {
    return s.houseDirectoryValidationRentDates;
  }
  if (startDate != null && endDate != null && endDate.isBefore(startDate)) {
    return s.houseDirectoryValidationDateRange;
  }
  return null;
}
