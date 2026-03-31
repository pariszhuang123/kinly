import 'package:flutter/widgets.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/inputs/kinly_choice_chip.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/features/personal_directory/ui/personal_directory_note_form_support.dart';
import 'package:kinly/generated/l10n.dart';

class PersonalDirectoryNoteFormBody extends StatelessWidget {
  const PersonalDirectoryNoteFormBody({
    super.key,
    required this.noteType,
    required this.availableNoteTypes,
    required this.canEdit,
    required this.isCreating,
    required this.isSaving,
    required this.isDirty,
    required this.validationError,
    required this.titleController,
    required this.contactNameController,
    required this.phoneController,
    required this.detailsController,
    required this.referenceUrlController,
    this.titleError,
    this.contactNameError,
    this.phoneError,
    this.detailsError,
    this.referenceUrlError,
    required this.onNoteTypeSelected,
    this.onCopyDetails,
    this.onCallPhoneNumber,
    this.onOpenReferenceUrl,
    required this.onSave,
    required this.onArchive,
  });

  final PersonalDirectoryNoteType noteType;
  final List<PersonalDirectoryNoteType> availableNoteTypes;
  final bool canEdit;
  final bool isCreating;
  final bool isSaving;
  final bool isDirty;
  final String? validationError;
  final TextEditingController titleController;
  final TextEditingController contactNameController;
  final TextEditingController phoneController;
  final TextEditingController detailsController;
  final TextEditingController referenceUrlController;
  final String? titleError;
  final String? contactNameError;
  final String? phoneError;
  final String? detailsError;
  final String? referenceUrlError;
  final ValueChanged<PersonalDirectoryNoteType> onNoteTypeSelected;
  final Future<void> Function()? onCopyDetails;
  final Future<void> Function()? onCallPhoneNumber;
  final Future<void> Function()? onOpenReferenceUrl;
  final VoidCallback onSave;
  final VoidCallback onArchive;

  bool get _showsDetailsField => noteType != PersonalDirectoryNoteType.allergy;
  bool get _showsReferenceUrlField => noteType != PersonalDirectoryNoteType.allergy;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final showTypeSelector = availableNoteTypes.length > 1;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
        children: [
          if (showTypeSelector) ...[
            _TypeSelectorSection(
              noteType: noteType,
              availableNoteTypes: availableNoteTypes,
              canEdit: canEdit,
              isCreating: isCreating,
              onNoteTypeSelected: onNoteTypeSelected,
            ),
            const SizedBox(height: 16),
          ],
          _PrimaryFieldsSection(
            noteType: noteType,
            canEdit: canEdit,
            isSaving: isSaving,
            titleController: titleController,
            contactNameController: contactNameController,
            phoneController: phoneController,
            titleError: titleError,
            contactNameError: contactNameError,
            phoneError: phoneError,
            onCallPhoneNumber: onCallPhoneNumber,
          ),
          if (_showsDetailsField) ...[
            const SizedBox(height: 16),
            _DetailsFieldSection(
              noteType: noteType,
              canEdit: canEdit,
              isSaving: isSaving,
              detailsController: detailsController,
              detailsError: detailsError,
              onCopyDetails: onCopyDetails,
            ),
          ],
          if (_showsReferenceUrlField) ...[
            const SizedBox(height: 16),
            _ReferenceUrlFieldSection(
              canEdit: canEdit,
              isSaving: isSaving,
              referenceUrlController: referenceUrlController,
              referenceUrlError: referenceUrlError,
              onOpenReferenceUrl: onOpenReferenceUrl,
            ),
          ],
          if (validationError != null) ...[
            const SizedBox(height: 12),
            _ValidationMessage(message: validationError!),
          ],
          if (canEdit) ...[
            const SizedBox(height: 24),
            if (isCreating || isDirty)
              KinlyFilledButton.text(
                fullWidth: true,
                onPressed: isSaving ? null : onSave,
                label: isCreating ? s.personalDirectorySave : s.shoppingSubmitEdit,
              )
            else if (!isCreating)
              KinlyFilledButton.destructiveText(
                fullWidth: true,
                onPressed: isSaving ? null : onArchive,
                label: s.houseDirectoryArchiveConfirm,
              ),
          ],
        ],
      ),
    );
  }
}

class _TypeSelectorSection extends StatelessWidget {
  const _TypeSelectorSection({
    required this.noteType,
    required this.availableNoteTypes,
    required this.canEdit,
    required this.isCreating,
    required this.onNoteTypeSelected,
  });

  final PersonalDirectoryNoteType noteType;
  final List<PersonalDirectoryNoteType> availableNoteTypes;
  final bool canEdit;
  final bool isCreating;
  final ValueChanged<PersonalDirectoryNoteType> onNoteTypeSelected;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.personalDirectoryNoteTypeLabel,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          personalDirectoryNoteTypeDescription(noteType, s),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              availableNoteTypes
                  .map(
                    (value) => KinlyChoiceChip(
                      label: personalDirectoryNoteTypeLabel(value, s),
                      selected: noteType == value,
                      onSelected:
                          canEdit && isCreating
                              ? (_) => onNoteTypeSelected(value)
                              : null,
                    ),
                  )
                  .toList(growable: false),
        ),
      ],
    );
  }
}

class _PrimaryFieldsSection extends StatelessWidget {
  const _PrimaryFieldsSection({
    required this.noteType,
    required this.canEdit,
    required this.isSaving,
    required this.titleController,
    required this.contactNameController,
    required this.phoneController,
    this.titleError,
    this.contactNameError,
    this.phoneError,
    this.onCallPhoneNumber,
  });

  final PersonalDirectoryNoteType noteType;
  final bool canEdit;
  final bool isSaving;
  final TextEditingController titleController;
  final TextEditingController contactNameController;
  final TextEditingController phoneController;
  final String? titleError;
  final String? contactNameError;
  final String? phoneError;
  final Future<void> Function()? onCallPhoneNumber;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    if (noteType == PersonalDirectoryNoteType.emergencyContact) {
      final phoneNumber = phoneController.text.trim();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KinlyTextField(
            controller: contactNameController,
            enabled: canEdit && !isSaving,
            labelText: s.personalDirectoryContactNameLabel,
            hintText: s.personalDirectoryContactNameHelp,
            errorText: contactNameError,
          ),
          const SizedBox(height: 16),
          KinlyTextField(
            controller: phoneController,
            enabled: canEdit && !isSaving,
            labelText: s.personalDirectoryPhoneNumberLabel,
            hintText: s.personalDirectoryPhoneNumberHelp,
            errorText: phoneError,
          ),
          if (!canEdit && phoneNumber.isNotEmpty && onCallPhoneNumber != null) ...[
            const SizedBox(height: 12),
            KinlyOutlinedButton.text(
              onPressed: () => onCallPhoneNumber!.call(),
              label: phoneNumber,
              fullWidth: true,
            ),
          ],
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KinlyTextField(
          controller: titleController,
          enabled: canEdit && !isSaving,
          labelText: _titleLabelText(s, noteType),
          hintText: _titleHelpText(s, noteType),
          errorText: titleError,
        ),
      ],
    );
  }
}

class _DetailsFieldSection extends StatelessWidget {
  const _DetailsFieldSection({
    required this.noteType,
    required this.canEdit,
    required this.isSaving,
    required this.detailsController,
    this.detailsError,
    this.onCopyDetails,
  });

  final PersonalDirectoryNoteType noteType;
  final bool canEdit;
  final bool isSaving;
  final TextEditingController detailsController;
  final String? detailsError;
  final Future<void> Function()? onCopyDetails;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final hasDetails = detailsController.text.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KinlyTextField(
          controller: detailsController,
          enabled: canEdit && !isSaving,
          labelText: s.personalDirectoryDetailsLabel,
          hintText: _detailsHelpText(s, noteType),
          errorText: detailsError,
          maxLines: 5,
          minLines: 4,
        ),
        if (!canEdit && hasDetails && onCopyDetails != null) ...[
          const SizedBox(height: 12),
          KinlyOutlinedButton.text(
            onPressed: () => onCopyDetails!.call(),
            label: s.shareOwedCopyCta,
            fullWidth: true,
          ),
        ],
      ],
    );
  }
}

class _ValidationMessage extends StatelessWidget {
  const _ValidationMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    return Text(
      message,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.error,
      ),
    );
  }
}

class _ReferenceUrlFieldSection extends StatelessWidget {
  const _ReferenceUrlFieldSection({
    required this.canEdit,
    required this.isSaving,
    required this.referenceUrlController,
    this.referenceUrlError,
    this.onOpenReferenceUrl,
  });

  final bool canEdit;
  final bool isSaving;
  final TextEditingController referenceUrlController;
  final String? referenceUrlError;
  final Future<void> Function()? onOpenReferenceUrl;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final hasReferenceUrl = referenceUrlController.text.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KinlyTextField(
          controller: referenceUrlController,
          enabled: canEdit && !isSaving,
          labelText: s.houseDirectoryNoteUrlLabel,
          hintText: s.houseDirectoryNoteUrlHint,
          errorText: referenceUrlError,
        ),
        if (!canEdit && hasReferenceUrl && onOpenReferenceUrl != null) ...[
          const SizedBox(height: 12),
          KinlyOutlinedButton.text(
            onPressed: () => onOpenReferenceUrl!.call(),
            label: s.houseDirectoryOpenLink,
            fullWidth: true,
          ),
        ],
      ],
    );
  }
}

String _titleHelpText(S s, PersonalDirectoryNoteType noteType) {
  return switch (noteType) {
    PersonalDirectoryNoteType.allergy => s.personalDirectoryAllergyHelp,
    PersonalDirectoryNoteType.emergencyContact =>
      s.personalDirectoryNoteTitleHelp,
    PersonalDirectoryNoteType.other => s.personalDirectoryNoteTitleHelp,
  };
}

String _titleLabelText(S s, PersonalDirectoryNoteType noteType) {
  return switch (noteType) {
    PersonalDirectoryNoteType.allergy => s.personalDirectoryAllergyLabel,
    PersonalDirectoryNoteType.emergencyContact =>
      s.personalDirectoryNoteTitleLabel,
    PersonalDirectoryNoteType.other => s.personalDirectoryNoteTitleLabel,
  };
}

String _detailsHelpText(S s, PersonalDirectoryNoteType noteType) {
  return switch (noteType) {
    PersonalDirectoryNoteType.emergencyContact =>
      s.personalDirectoryEmergencyDetailsHelp,
    PersonalDirectoryNoteType.allergy => s.personalDirectoryOtherDetailsHelp,
    PersonalDirectoryNoteType.other => s.personalDirectoryOtherDetailsHelp,
  };
}
