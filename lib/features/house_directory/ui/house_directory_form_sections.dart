import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/ui/inputs/kinly_dropdown_field.dart';
import 'package:kinly/core/ui/kinly_dropdown_menu_item.dart';

class HouseDirectoryServiceSheetContent extends StatelessWidget {
  const HouseDirectoryServiceSheetContent({
    super.key,
    required this.type,
    required this.customLabelController,
    required this.providerController,
    required this.referenceController,
    required this.linkController,
    required this.offsetValueController,
    required this.notesController,
    required this.offsetUnit,
    required this.startLabel,
    required this.endLabel,
    this.customLabelError,
    this.providerError,
    this.linkError,
    this.offsetValueError,
    required this.error,
    required this.onTypeChanged,
    required this.onStartPressed,
    required this.onEndPressed,
    required this.onOffsetUnitChanged,
    required this.onSave,
  });

  final HouseDirectoryServiceType type;
  final TextEditingController customLabelController;
  final TextEditingController providerController;
  final TextEditingController referenceController;
  final TextEditingController linkController;
  final TextEditingController offsetValueController;
  final TextEditingController notesController;
  final HouseDirectoryReminderOffsetUnit? offsetUnit;
  final String startLabel;
  final String endLabel;
  final String? customLabelError;
  final String? providerError;
  final String? linkError;
  final String? offsetValueError;
  final String? error;
  final ValueChanged<HouseDirectoryServiceType?> onTypeChanged;
  final VoidCallback onStartPressed;
  final VoidCallback onEndPressed;
  final ValueChanged<HouseDirectoryReminderOffsetUnit?> onOffsetUnitChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;

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
        HouseDirectoryDateButtons(
          startLabel: startLabel,
          endLabel: endLabel,
          onStartPressed: onStartPressed,
          onEndPressed: onEndPressed,
        ),
        if (offsetUnit != null) ...[
          SizedBox(height: spacing.md),
          Row(
            children: [
              Expanded(
                child: KinlyTextField(
                  controller: offsetValueController,
                  labelText: s.houseDirectoryReminderOffset,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
        HouseDirectorySheetErrorText(error: error),
        SizedBox(height: spacing.lg),
        HouseDirectorySheetActions(onSave: onSave),
      ],
    );
  }
}

class HouseDirectoryNoteSheetContent extends StatelessWidget {
  const HouseDirectoryNoteSheetContent({
    super.key,
    required this.titleController,
    required this.detailsController,
    required this.referenceUrlController,
    this.titleError,
    this.detailsError,
    this.referenceUrlError,
    required this.error,
    required this.onSave,
  });

  final TextEditingController titleController;
  final TextEditingController detailsController;
  final TextEditingController referenceUrlController;
  final String? titleError;
  final String? detailsError;
  final String? referenceUrlError;
  final String? error;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KinlyTextField(
          controller: titleController,
          labelText: s.houseDirectoryTitleLabel,
          hintText: s.houseDirectoryNoteTitleHint,
          errorText: titleError,
        ),
        SizedBox(height: spacing.md),
        KinlyTextField(
          controller: detailsController,
          labelText: s.houseDirectoryNoteDetailsLabel,
          hintText: s.houseDirectoryNoteDetailsHint,
          errorText: detailsError,
          minLines: 3,
          maxLines: 5,
        ),
        SizedBox(height: spacing.md),
        KinlyTextField(
          controller: referenceUrlController,
          labelText: s.houseDirectoryNoteUrlLabel,
          hintText: s.houseDirectoryNoteUrlHint,
          errorText: referenceUrlError,
        ),
        HouseDirectorySheetErrorText(error: error),
        SizedBox(height: spacing.lg),
        HouseDirectorySheetActions(onSave: onSave),
      ],
    );
  }
}

class HouseDirectoryDateButtons extends StatelessWidget {
  const HouseDirectoryDateButtons({
    super.key,
    required this.startLabel,
    required this.endLabel,
    required this.onStartPressed,
    required this.onEndPressed,
  });

  final String startLabel;
  final String endLabel;
  final VoidCallback onStartPressed;
  final VoidCallback onEndPressed;

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;

    return Row(
      children: [
        Expanded(
          child: KinlyOutlinedButton.text(
            onPressed: onStartPressed,
            label: startLabel,
          ),
        ),
        SizedBox(width: spacing.md),
        Expanded(
          child: KinlyOutlinedButton.text(
            onPressed: onEndPressed,
            label: endLabel,
          ),
        ),
      ],
    );
  }
}

class HouseDirectorySheetActions extends StatelessWidget {
  const HouseDirectorySheetActions({
    super.key,
    required this.onSave,
  });

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: KinlyFilledButton.text(
        onPressed: onSave,
        label: S.of(context).houseDirectorySave,
      ),
    );
  }
}

class HouseDirectorySheetErrorText extends StatelessWidget {
  const HouseDirectorySheetErrorText({
    super.key,
    required this.error,
  });

  final String? error;

  @override
  Widget build(BuildContext context) {
    if (error == null) return const SizedBox.shrink();

    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    return Padding(
      padding: EdgeInsetsDirectional.only(top: spacing.md),
      child: Text(
        error!,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    );
  }
}
