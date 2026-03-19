import 'package:flutter/widgets.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/contracts/personal_directory/route_args.dart';
import 'package:kinly/core/ui/dialogs/kinly_dialogs.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/personal_directory/ui/personal_directory_note_form_support.dart';
import 'package:kinly/features/personal_directory/ui/personal_directory_note_form_sections.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String? _titleError;
  String? _contactNameError;
  String? _phoneError;
  String? _detailsError;

  bool get _isCreating => widget.note == null;
  bool get _isDirty {
    final note = widget.note;
    if (note == null) {
      return _titleController.text.trim().isNotEmpty ||
          _contactNameController.text.trim().isNotEmpty ||
          _phoneController.text.trim().isNotEmpty ||
          _detailsController.text.trim().isNotEmpty;
    }
    return _noteType != note.noteType ||
        _titleController.text.trim() != (note.customTitle ?? note.label ?? '').trim() ||
        _contactNameController.text.trim() != (note.contactName ?? '').trim() ||
        _phoneController.text.trim() != (note.phoneNumber ?? '').trim() ||
        (_trimmedDetails() ?? '') != (note.details ?? '').trim();
  }

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
    _titleController.addListener(_handleFieldChanged);
    _contactNameController.addListener(_handleFieldChanged);
    _phoneController.addListener(_handleFieldChanged);
    _detailsController.addListener(_handleFieldChanged);
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
      body: PersonalDirectoryNoteFormBody(
        noteType: _noteType,
        availableNoteTypes: widget.availableNoteTypes,
        canEdit: widget.canEdit,
        isCreating: _isCreating,
        isSaving: _isSaving,
        isDirty: _isDirty,
        validationError: _validationError,
        titleController: _titleController,
        contactNameController: _contactNameController,
        phoneController: _phoneController,
        detailsController: _detailsController,
        titleError: _titleError,
        contactNameError: _contactNameError,
        phoneError: _phoneError,
        detailsError: _detailsError,
        onNoteTypeSelected: _updateNoteType,
        onCallPhoneNumber: widget.canEdit ? null : _dialEmergencyContact,
        onSave: _save,
        onArchive: _archive,
      ),
    );
  }

  String _screenTitle(S s) {
    if (_isCreating) return s.personalDirectoryAddNote;
    if (widget.canEdit) return s.personalDirectoryEditNote;
    return existingPersonalDirectoryNoteTitle(note: widget.note, s: s);
  }

  bool get _showsDetailsField => _noteType != PersonalDirectoryNoteType.allergy;

  void _updateNoteType(PersonalDirectoryNoteType noteType) {
    setState(() {
      _noteType = noteType;
      _clearValidationErrors();
    });
  }

  bool _validate() {
    final s = S.of(context);
    final title = _titleController.text.trim();
    final contactName = _contactNameController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final details = _detailsController.text.trim();
    String? titleError;
    String? contactNameError;
    String? phoneError;
    String? detailsError;

    switch (_noteType) {
      case PersonalDirectoryNoteType.emergencyContact:
        if (contactName.isEmpty) {
          contactNameError = s.personalDirectoryContactNameHelp;
        }
        if (phoneNumber.isEmpty) {
          phoneError = s.personalDirectoryPhoneNumberHelp;
        } else if (!_isValidPhoneNumber(phoneNumber)) {
          phoneError = s.personalDirectoryNoteValidation;
        }
        break;
      case PersonalDirectoryNoteType.allergy:
        if (title.isEmpty) {
          titleError = s.personalDirectoryAllergyHelp;
        }
        break;
      case PersonalDirectoryNoteType.other:
        if (title.isEmpty) {
          titleError = s.personalDirectoryNoteTitleHelp;
        }
        if (details.isEmpty) {
          detailsError = s.personalDirectoryOtherDetailsHelp;
        }
        break;
    }

    final isValid =
        titleError == null &&
        contactNameError == null &&
        phoneError == null &&
        detailsError == null &&
        isValidPersonalDirectoryNoteForm(
          noteType: _noteType,
          title: title,
          contactName: contactName,
          phoneNumber: phoneNumber,
          details: details,
          isValidPhoneNumber: _isValidPhoneNumber,
        );
    setState(() {
      _titleError = titleError;
      _contactNameError = contactNameError;
      _phoneError = phoneError;
      _detailsError = detailsError;
      _validationError =
          isValid ||
                  titleError != null ||
                  contactNameError != null ||
                  phoneError != null ||
                  detailsError != null
              ? null
              : s.personalDirectoryNoteValidation;
    });
    return isValid;
  }

  void _handleFieldChanged() {
    if (_titleError == null &&
        _contactNameError == null &&
        _phoneError == null &&
        _detailsError == null &&
        _validationError == null) {
      return;
    }
    if (!mounted) return;
    setState(_clearValidationErrors);
  }

  void _clearValidationErrors() {
    _validationError = null;
    _titleError = null;
    _contactNameError = null;
    _phoneError = null;
    _detailsError = null;
  }

  Future<void> _save() async {
    if (!_validate()) return;
    setState(() => _isSaving = true);
    try {
      if (_isCreating) {
        await widget.repository.createNote(
          buildCreatePersonalDirectoryNoteInput(
            noteType: _noteType,
            title: _titleController.text.trim(),
            contactName: _contactNameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            details: _trimmedDetails(),
          ),
        );
      } else {
        await widget.repository.updateNote(
          buildUpdatePersonalDirectoryNoteInput(
            noteId: widget.note!.id,
            noteType: _noteType,
            title: _titleController.text.trim(),
            contactName: _contactNameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            details: _trimmedDetails(),
          ),
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(PersonalDirectoryRouteResult.noteSaved);
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
      Navigator.of(context).pop(PersonalDirectoryRouteResult.noteArchived);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      KinlySnackBar.showError(context, s.personalDirectoryActionFailed);
    }
  }

  String? _trimmedDetails() {
    return trimPersonalDirectoryNoteDetails(
      showsDetailsField: _showsDetailsField,
      details: _detailsController.text,
    );
  }

  Future<void> _dialEmergencyContact() async {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) return;
    final normalized = phoneNumber.replaceAll(RegExp(r'[\s()-]'), '');
    final uri = Uri(scheme: 'tel', path: normalized);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  bool _isValidPhoneNumber(String value) {
    return _phoneNumberPattern.hasMatch(value) &&
        value.contains(RegExp(r'\d'));
  }
}
