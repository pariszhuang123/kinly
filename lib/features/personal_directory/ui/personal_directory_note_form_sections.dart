import 'package:flutter/widgets.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
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
    required this.validationError,
    required this.titleController,
    required this.contactNameController,
    required this.phoneController,
    required this.detailsController,
    required this.onNoteTypeSelected,
    required this.onSave,
    required this.onArchive,
  });

  final PersonalDirectoryNoteType noteType;
  final List<PersonalDirectoryNoteType> availableNoteTypes;
  final bool canEdit;
  final bool isCreating;
  final bool isSaving;
  final String? validationError;
  final TextEditingController titleController;
  final TextEditingController contactNameController;
  final TextEditingController phoneController;
  final TextEditingController detailsController;
  final ValueChanged<PersonalDirectoryNoteType> onNoteTypeSelected;
  final VoidCallback onSave;
  final VoidCallback onArchive;

  bool get _showsDetailsField => noteType != PersonalDirectoryNoteType.allergy;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
        children: [
          _TypeSelectorSection(
            noteType: noteType,
            availableNoteTypes: availableNoteTypes,
            canEdit: canEdit,
            isCreating: isCreating,
            onNoteTypeSelected: onNoteTypeSelected,
          ),
          const SizedBox(height: 16),
          _PrimaryFieldsSection(
            noteType: noteType,
            canEdit: canEdit,
            isSaving: isSaving,
            titleController: titleController,
            contactNameController: contactNameController,
            phoneController: phoneController,
          ),
          if (_showsDetailsField) ...[
            const SizedBox(height: 16),
            _DetailsFieldSection(
              noteType: noteType,
              canEdit: canEdit,
              isSaving: isSaving,
              detailsController: detailsController,
            ),
          ],
          if (validationError != null) ...[
            const SizedBox(height: 12),
            _ValidationMessage(message: validationError!),
          ],
          if (canEdit) ...[
            const SizedBox(height: 24),
            KinlyFilledButton.text(
              fullWidth: true,
              onPressed: isSaving ? null : onSave,
              label: isCreating ? s.personalDirectorySave : s.shoppingSubmitEdit,
            ),
            if (!isCreating) ...[
              const SizedBox(height: 12),
              KinlyFilledButton.text(
                fullWidth: true,
                onPressed: isSaving ? null : onArchive,
                label: s.houseDirectoryArchiveConfirm,
              ),
            ],
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
  });

  final PersonalDirectoryNoteType noteType;
  final bool canEdit;
  final bool isSaving;
  final TextEditingController titleController;
  final TextEditingController contactNameController;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    if (noteType == PersonalDirectoryNoteType.emergencyContact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldHelp(message: s.personalDirectoryContactNameHelp),
          const SizedBox(height: 8),
          KinlyTextField(
            controller: contactNameController,
            enabled: canEdit && !isSaving,
            labelText: s.personalDirectoryContactNameLabel,
          ),
          const SizedBox(height: 16),
          _FieldHelp(message: s.personalDirectoryPhoneNumberHelp),
          const SizedBox(height: 8),
          KinlyTextField(
            controller: phoneController,
            enabled: canEdit && !isSaving,
            labelText: s.personalDirectoryPhoneNumberLabel,
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldHelp(message: _titleHelpText(s, noteType)),
        const SizedBox(height: 8),
        KinlyTextField(
          controller: titleController,
          enabled: canEdit && !isSaving,
          labelText: _titleLabelText(s, noteType),
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
  });

  final PersonalDirectoryNoteType noteType;
  final bool canEdit;
  final bool isSaving;
  final TextEditingController detailsController;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldHelp(message: _detailsHelpText(s, noteType)),
        const SizedBox(height: 8),
        KinlyTextField(
          controller: detailsController,
          enabled: canEdit && !isSaving,
          labelText: s.personalDirectoryDetailsLabel,
          maxLines: 5,
          minLines: 4,
        ),
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

class _FieldHelp extends StatelessWidget {
  const _FieldHelp({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    return Text(
      message,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
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
