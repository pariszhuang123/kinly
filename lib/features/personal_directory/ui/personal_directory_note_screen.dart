import 'package:flutter/widgets.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/dialogs/kinly_dialogs.dart';
import 'package:kinly/core/ui/inputs/kinly_choice_chip.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/generated/l10n.dart';

class PersonalDirectoryNoteScreen extends StatefulWidget {
  const PersonalDirectoryNoteScreen({
    super.key,
    required this.repository,
    required this.canEdit,
    this.availableNoteTypes = PersonalDirectoryNoteType.values,
    this.note,
  });

  final PersonalDirectoryRepository repository;
  final PersonalDirectoryNote? note;
  final bool canEdit;
  final List<PersonalDirectoryNoteType> availableNoteTypes;

  @override
  State<PersonalDirectoryNoteScreen> createState() =>
      _PersonalDirectoryNoteScreenState();
}

class _PersonalDirectoryNoteScreenState extends State<PersonalDirectoryNoteScreen> {
  static final RegExp _phoneNumberPattern = RegExp(r'^[0-9+()\- ]{1,30}$');

  late PersonalDirectoryNoteType _noteType;
  late final TextEditingController _titleController;
  late final TextEditingController _contactNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _detailsController;
  bool _isSaving = false;
  String? _validationError;

  bool get _isCreating => widget.note == null;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    _noteType =
        note?.noteType ??
        (widget.availableNoteTypes.isNotEmpty
            ? widget.availableNoteTypes.first
            : PersonalDirectoryNoteType.allergy);
    _titleController = TextEditingController(
      text: note?.customTitle ?? note?.label ?? '',
    );
    _contactNameController = TextEditingController(text: note?.contactName ?? '');
    _phoneController = TextEditingController(text: note?.phoneNumber ?? '');
    _detailsController = TextEditingController(text: note?.details ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contactNameController.dispose();
    _phoneController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(_screenTitle(s)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
          children: _buildBodyChildren(context, s),
        ),
      ),
    );
  }

  String _screenTitle(S s) {
    if (_isCreating) return s.personalDirectoryAddNote;
    if (widget.canEdit) return s.personalDirectoryEditNote;
    return _existingNoteTitle(s);
  }

  List<Widget> _buildBodyChildren(BuildContext context, S s) {
    final children = <Widget>[
      _buildTypeSelector(context, s),
      const SizedBox(height: 16),
      ..._buildPrimaryFields(s),
    ];
    if (_showsDetailsField) {
      children.addAll([
        const SizedBox(height: 16),
        _buildDetailsField(s),
      ]);
    }
    children.addAll([
      ..._buildValidationMessage(context),
      ..._buildActions(s),
    ]);
    return children;
  }

  Widget _buildTypeSelector(BuildContext context, S s) {
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
          _noteTypeDescription(s),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              widget.availableNoteTypes
                  .map(
                    (value) => KinlyChoiceChip(
                      label: _noteTypeLabel(value, s),
                      selected: _noteType == value,
                      onSelected:
                          widget.canEdit && _isCreating
                              ? (_) => setState(() => _noteType = value)
                              : null,
                    ),
                  )
                  .toList(growable: false),
        ),
      ],
    );
  }

  List<Widget> _buildPrimaryFields(S s) {
    if (_noteType == PersonalDirectoryNoteType.emergencyContact) {
      return [
        _FieldHelp(message: s.personalDirectoryContactNameHelp),
        const SizedBox(height: 8),
        KinlyTextField(
          controller: _contactNameController,
          enabled: widget.canEdit && !_isSaving,
          labelText: s.personalDirectoryContactNameLabel,
        ),
        const SizedBox(height: 16),
        _FieldHelp(message: s.personalDirectoryPhoneNumberHelp),
        const SizedBox(height: 8),
        KinlyTextField(
          controller: _phoneController,
          enabled: widget.canEdit && !_isSaving,
          labelText: s.personalDirectoryPhoneNumberLabel,
        ),
      ];
    }
    return [
      _FieldHelp(
        message:
            _noteType == PersonalDirectoryNoteType.allergy
                ? s.personalDirectoryAllergyHelp
                : s.personalDirectoryNoteTitleHelp,
      ),
      const SizedBox(height: 8),
      KinlyTextField(
        controller: _titleController,
        enabled: widget.canEdit && !_isSaving,
        labelText:
            _noteType == PersonalDirectoryNoteType.allergy
                ? s.personalDirectoryAllergyLabel
                : s.personalDirectoryNoteTitleLabel,
      ),
    ];
  }

  Widget _buildDetailsField(S s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldHelp(
          message:
              _noteType == PersonalDirectoryNoteType.emergencyContact
                  ? s.personalDirectoryEmergencyDetailsHelp
                  : s.personalDirectoryOtherDetailsHelp,
        ),
        const SizedBox(height: 8),
        KinlyTextField(
          controller: _detailsController,
          enabled: widget.canEdit && !_isSaving,
          labelText: s.personalDirectoryDetailsLabel,
          maxLines: 5,
          minLines: 4,
        ),
      ],
    );
  }

  List<Widget> _buildValidationMessage(BuildContext context) {
    if (_validationError == null) return const <Widget>[];
    final theme = KinlyThemeAccess.of(context);
    return [
      const SizedBox(height: 12),
      Text(
        _validationError!,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    ];
  }

  List<Widget> _buildActions(S s) {
    if (!widget.canEdit) return const <Widget>[];
    final children = <Widget>[
      const SizedBox(height: 24),
      KinlyFilledButton.text(
        fullWidth: true,
        onPressed: _isSaving ? null : _save,
        label: _isCreating ? s.personalDirectorySave : s.shoppingSubmitEdit,
      ),
    ];
    if (!_isCreating) {
      children.addAll([
        const SizedBox(height: 12),
        KinlyFilledButton.text(
          fullWidth: true,
          onPressed: _isSaving ? null : _archive,
          label: s.houseDirectoryArchiveConfirm,
        ),
      ]);
    }
    return children;
  }

  String _existingNoteTitle(S s) {
    final note = widget.note;
    if (note == null) return s.personalDirectoryNotesTitle;
    return switch (note.noteType) {
      PersonalDirectoryNoteType.emergencyContact =>
        note.contactName ?? note.customTitle ?? note.label ?? s.personalDirectoryNotesTitle,
      PersonalDirectoryNoteType.allergy =>
        note.label ?? s.personalDirectoryNotesTitle,
      PersonalDirectoryNoteType.other =>
        note.customTitle ?? s.personalDirectoryNotesTitle,
    };
  }

  String _noteTypeLabel(PersonalDirectoryNoteType noteType, S s) {
    return switch (noteType) {
      PersonalDirectoryNoteType.emergencyContact =>
        s.personalDirectoryEmergencyContactTitle,
      PersonalDirectoryNoteType.allergy => s.personalDirectoryAllergyTitle,
      PersonalDirectoryNoteType.other => s.personalDirectoryOtherTitle,
    };
  }

  String _noteTypeDescription(S s) {
    return switch (_noteType) {
      PersonalDirectoryNoteType.emergencyContact =>
        s.personalDirectoryEmergencyContactHelp,
      PersonalDirectoryNoteType.allergy => s.personalDirectoryAllergyTypeHelp,
      PersonalDirectoryNoteType.other => s.personalDirectoryOtherTypeHelp,
    };
  }

  bool get _showsDetailsField => _noteType != PersonalDirectoryNoteType.allergy;

  bool _validate() {
    final s = S.of(context);
    final details = _detailsController.text.trim();
    final title = _titleController.text.trim();
    final contact = _contactNameController.text.trim();
    final phone = _phoneController.text.trim();
    final isValid = switch (_noteType) {
      PersonalDirectoryNoteType.emergencyContact =>
        contact.isNotEmpty &&
            contact.length <= 120 &&
            phone.isNotEmpty &&
            phone.length <= 30 &&
            _isValidPhoneNumber(phone) &&
            details.length <= 2000,
      PersonalDirectoryNoteType.allergy =>
        title.isNotEmpty && title.length <= 120 && details.isEmpty,
      PersonalDirectoryNoteType.other =>
        title.isNotEmpty && title.length <= 80 && details.length <= 2000,
    };
    setState(() {
      _validationError = isValid ? null : s.personalDirectoryNoteValidation;
    });
    return isValid;
  }

  Future<void> _save() async {
    if (!_validate()) return;
    setState(() => _isSaving = true);
    try {
      final details = _trimmedDetails();
      if (_isCreating) {
        await widget.repository.createNote(
          CreatePersonalDirectoryNoteInput(
            noteType: _noteType,
            label:
                _noteType == PersonalDirectoryNoteType.allergy
                    ? _titleController.text.trim()
                    : null,
            customTitle:
                _noteType == PersonalDirectoryNoteType.other
                    ? _titleController.text.trim()
                    : null,
            contactName:
                _noteType == PersonalDirectoryNoteType.emergencyContact
                    ? _contactNameController.text.trim()
                    : null,
            phoneNumber:
                _noteType == PersonalDirectoryNoteType.emergencyContact
                    ? _phoneController.text.trim()
                    : null,
            details: details,
          ),
        );
      } else {
        await widget.repository.updateNote(
          UpdatePersonalDirectoryNoteInput(
            noteId: widget.note!.id,
            label:
                _noteType == PersonalDirectoryNoteType.allergy
                    ? _titleController.text.trim()
                    : null,
            customTitle:
                _noteType == PersonalDirectoryNoteType.other
                    ? _titleController.text.trim()
                    : null,
            contactName:
                _noteType == PersonalDirectoryNoteType.emergencyContact
                    ? _contactNameController.text.trim()
                    : null,
            phoneNumber:
                _noteType == PersonalDirectoryNoteType.emergencyContact
                    ? _phoneController.text.trim()
                    : null,
            details: details,
          ),
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      KinlySnackBar.showError(context, S.of(context).personalDirectoryActionFailed);
    }
  }

  Future<void> _archive() async {
    final s = S.of(context);
    final confirmed = await showKinlyConfirmDialog(
      context,
      title: s.personalDirectoryArchiveNoteTitle,
      message: s.personalDirectoryArchiveNoteBody,
      confirmLabel: s.houseDirectoryArchiveConfirm,
      destructive: true,
    );
    if (confirmed != true || widget.note == null || !mounted) return;
    setState(() => _isSaving = true);
    try {
      await widget.repository.archiveNote(widget.note!.id);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      KinlySnackBar.showError(context, s.personalDirectoryActionFailed);
    }
  }

  String? _trimmedDetails() {
    if (!_showsDetailsField) return null;
    final value = _detailsController.text.trim();
    return value.isEmpty ? null : value;
  }

  bool _isValidPhoneNumber(String value) {
    return _phoneNumberPattern.hasMatch(value) &&
        value.contains(RegExp(r'\d'));
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
