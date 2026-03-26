import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/logging/logger.dart';
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
  late final TextEditingController _referenceUrlController;
  bool _isSaving = false;
  String? _validationError;
  String? _titleError;
  String? _contactNameError;
  String? _phoneError;
  String? _detailsError;
  String? _referenceUrlError;

  bool get _isCreating => widget.note == null;
  bool get _isDirty {
    final note = widget.note;
    if (note == null) {
      return _titleController.text.trim().isNotEmpty ||
          _contactNameController.text.trim().isNotEmpty ||
          _phoneController.text.trim().isNotEmpty ||
          _detailsController.text.trim().isNotEmpty ||
          _referenceUrlController.text.trim().isNotEmpty;
    }
    return _noteType != note.noteType ||
        _titleController.text.trim() != (note.customTitle ?? note.label ?? '').trim() ||
        _contactNameController.text.trim() != (note.contactName ?? '').trim() ||
        _phoneController.text.trim() != (note.phoneNumber ?? '').trim() ||
        (_trimmedDetails() ?? '') != (note.details ?? '').trim() ||
        (_trimmedReferenceUrl() ?? '') != (note.referenceUrl ?? '').trim();
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
    _referenceUrlController = TextEditingController(
      text: note?.referenceUrl ?? '',
    );
    _titleController.addListener(_handleFieldChanged);
    _contactNameController.addListener(_handleFieldChanged);
    _phoneController.addListener(_handleFieldChanged);
    _detailsController.addListener(_handleFieldChanged);
    _referenceUrlController.addListener(_handleFieldChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contactNameController.dispose();
    _phoneController.dispose();
    _detailsController.dispose();
    _referenceUrlController.dispose();
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
        referenceUrlController: _referenceUrlController,
        titleError: _titleError,
        contactNameError: _contactNameError,
        phoneError: _phoneError,
        detailsError: _detailsError,
        referenceUrlError: _referenceUrlError,
        onNoteTypeSelected: _updateNoteType,
        onCallPhoneNumber: widget.canEdit ? null : _dialEmergencyContact,
        onOpenReferenceUrl: widget.canEdit ? null : _openReferenceUrl,
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
    final referenceUrl = _referenceUrlController.text.trim();
    String? titleError;
    String? contactNameError;
    String? phoneError;
    String? referenceUrlError;

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
        break;
    }

    if (referenceUrl.isNotEmpty &&
        !isValidPersonalDirectoryReferenceUrl(referenceUrl)) {
      referenceUrlError = s.houseDirectoryValidationUrl;
    }

    final isValid =
        titleError == null &&
        contactNameError == null &&
        phoneError == null &&
        referenceUrlError == null &&
        isValidPersonalDirectoryNoteForm(
          noteType: _noteType,
          title: title,
          contactName: contactName,
          phoneNumber: phoneNumber,
          details: details,
          referenceUrl: referenceUrl,
          isValidPhoneNumber: _isValidPhoneNumber,
          isValidReferenceUrl: isValidPersonalDirectoryReferenceUrl,
        );
    setState(() {
      _titleError = titleError;
      _contactNameError = contactNameError;
      _phoneError = phoneError;
      _detailsError = null;
      _referenceUrlError = referenceUrlError;
      _validationError =
          isValid ||
                  titleError != null ||
                  contactNameError != null ||
                  phoneError != null ||
                  referenceUrlError != null
              ? null
              : s.personalDirectoryNoteValidation;
    });
    return isValid;
  }

  void _handleFieldChanged() {
    if (!mounted) return;
    setState(() {
      _clearValidationErrors();
    });
  }

  void _clearValidationErrors() {
    _validationError = null;
    _titleError = null;
    _contactNameError = null;
    _phoneError = null;
    _detailsError = null;
    _referenceUrlError = null;
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
            referenceUrl: _trimmedReferenceUrl(),
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
            referenceUrl: _trimmedReferenceUrl(),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      KinlySnackBar.showError(context, S.of(context).personalDirectoryActionFailed);
      return;
    }
    if (!mounted) return;
    _closeWithResult(PersonalDirectoryRouteResult.noteSaved);
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
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      KinlySnackBar.showError(context, s.personalDirectoryActionFailed);
      return;
    }
    if (!mounted) return;
    _closeWithResult(PersonalDirectoryRouteResult.noteArchived);
  }

  String? _trimmedDetails() {
    return trimPersonalDirectoryNoteDetails(
      showsDetailsField: _showsDetailsField,
      details: _detailsController.text,
    );
  }

  String? _trimmedReferenceUrl() {
    return trimPersonalDirectoryReferenceUrl(_referenceUrlController.text);
  }

  Future<void> _dialEmergencyContact() async {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) return;
    final normalized = phoneNumber.replaceAll(RegExp(r'[\s()-]'), '');
    final uri = Uri(scheme: 'tel', path: normalized);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openReferenceUrl() async {
    final referenceUrl = _trimmedReferenceUrl();
    if (referenceUrl == null) return;
    final uri = Uri.tryParse(referenceUrl);
    if (uri == null) return;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      KinlySnackBar.showError(context, S.of(context).houseDirectoryOpenLinkError);
    }
  }

  bool _isValidPhoneNumber(String value) {
    return _phoneNumberPattern.hasMatch(value) &&
        value.contains(RegExp(r'\d'));
  }

  void _closeWithResult(PersonalDirectoryRouteResult result) {
    unawaited(_closeAfterFrame(result));
  }

  Future<void> _closeAfterFrame(PersonalDirectoryRouteResult result) async {
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    try {
      Navigator.of(context).pop(result);
    } catch (error, stackTrace) {
      sl<Logger>().error(
        'Personal directory route pop failed after a successful mutation.',
        tag: 'Router',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      GoRouter.of(context).goNamed(AppRouteNames.personalDirectory);
    }
  }
}
