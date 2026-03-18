import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/house_directory/house_directory_photo_capture.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/dialogs/kinly_dialogs.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_note_screen_content.dart';
import 'package:kinly/features/house_directory/ui/house_directory_route_args.dart';
import 'package:kinly/features/house_directory/ui/house_directory_sections.dart';
import 'package:kinly/generated/l10n.dart';

class HouseDirectoryNoteScreen extends StatefulWidget {
  const HouseDirectoryNoteScreen({
    super.key,
    required this.homeId,
    required this.repository,
    required this.isOwner,
    this.noteId,
    this.initialNoteType = HouseDirectoryNoteType.general,
  });

  final String homeId;
  final HouseDirectoryRepository repository;
  final bool isOwner;
  final String? noteId;
  final HouseDirectoryNoteType initialNoteType;

  bool get isCreating => noteId == null;

  @override
  State<HouseDirectoryNoteScreen> createState() => _HouseDirectoryNoteScreenState();
}

class _HouseDirectoryNoteScreenState extends State<HouseDirectoryNoteScreen> {
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final _referenceUrlController = TextEditingController();

  bool _isEditing = false;
  bool _isUploadingPhoto = false;
  String? _photoPath;
  String? _photoUrl;
  String? _validationError;
  String? _titleError;
  String? _detailsError;
  String? _referenceUrlError;
  HouseDirectoryNotice? _lastHandledNotice;
  String? _hydratedNoteId;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isCreating;
    _titleController.addListener(_onChanged);
    _detailsController.addListener(_onChanged);
    _referenceUrlController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onChanged);
    _detailsController.removeListener(_onChanged);
    _referenceUrlController.removeListener(_onChanged);
    _titleController.dispose();
    _detailsController.dispose();
    _referenceUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocConsumer<HouseDirectoryBloc, HouseDirectoryState>(
      listenWhen: (previous, current) => previous.notice != current.notice,
      listener: _onNoticeChanged,
      builder: (context, state) {
        final note = _resolveNote(state);
        _hydrateFromNote(note);
        final photoUrl = _photoUrl ?? widget.repository.toPublicPhotoUrl(_photoPath) ?? '';
        final hasPhoto = photoUrl.isNotEmpty;
        final title = widget.isCreating
            ? _createTitle(s)
            : _titleForState(s, note);

        return KinlyScaffold(
          appBar: KinlyAppBar(
            title: Text(title),
            actions: [
              if (!widget.isCreating && widget.isOwner && !_isEditing)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: Center(
                    child: KinlyFilledButton.text(
                      onPressed: () => setState(() => _isEditing = true),
                      label: s.houseDirectoryEdit,
                      compact: true,
                      fullWidth: false,
                    ),
                  ),
                ),
            ],
          ),
          body: SafeArea(
            child: _buildBody(
              state: state,
              note: note,
              photoUrl: photoUrl,
              hasPhoto: hasPhoto,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody({
    required HouseDirectoryState state,
    required HouseDirectoryNote? note,
    required String photoUrl,
    required bool hasPhoto,
  }) {
    final canShowEditor = widget.isCreating || note != null;

    if (!canShowEditor && state.isLoading) {
      return const Center(child: KinlyLoader());
    }
    final hasChanges = houseDirectoryNoteHasChanges(
      isCreating: widget.isCreating,
      note: note,
      titleController: _titleController,
      detailsController: _detailsController,
      referenceUrlController: _referenceUrlController,
      photoPath: _photoPath,
    );

    return HouseDirectoryNoteContent(
      note: note,
      canShowEditor: canShowEditor,
      isEditing: _isEditing,
      isCreating: widget.isCreating,
      isUploadingPhoto: _isUploadingPhoto,
      photoUrl: photoUrl,
      hasPhoto: hasPhoto,
      hasChanges: hasChanges,
      canSubmit: !_isUploadingPhoto && (widget.isCreating || hasChanges),
      titleController: _titleController,
      detailsController: _detailsController,
      referenceUrlController: _referenceUrlController,
      titleError: _titleError,
      detailsError: _detailsError,
      referenceUrlError: _referenceUrlError,
      validationError: _validationError,
      onCapturePhoto: _capturePhoto,
      onReferenceTap:
          _referenceUrlController.text.trim().isEmpty
              ? null
              : () => launchHouseDirectoryUrl(
                context,
                _referenceUrlController.text.trim(),
              ),
      onPhotoTap: hasPhoto ? () => _openPhotoViewer(photoUrl) : null,
      onArchive: () => _confirmArchive(note),
      onSave: () => _save(note),
    );
  }

  void _hydrateFromNote(HouseDirectoryNote? note) {
    if (widget.isCreating || note == null) return;
    if (_hydratedNoteId == note.id && _isEditing) return;
    _hydratedNoteId = note.id;
    _titleController.text = note.title;
    _detailsController.text = note.details;
    _referenceUrlController.text = note.referenceUrl ?? '';
    _photoPath = note.photoPath;
    _photoUrl = widget.repository.toPublicPhotoUrl(note.photoPath);
  }

  HouseDirectoryNote? _resolveNote(HouseDirectoryState state) {
    final noteId = widget.noteId;
    if (noteId == null) return null;
    for (final note in state.allNotes) {
      if (note.id == noteId) return note;
    }
    return null;
  }

  String _createTitle(S s) {
    return widget.initialNoteType == HouseDirectoryNoteType.tutorial
        ? s.houseDirectoryAddTutorial
        : s.houseDirectoryAddNote;
  }

  String _titleForState(S s, HouseDirectoryNote? note) {
    if (_isEditing) {
      final noteType = note?.noteType ?? widget.initialNoteType;
      return noteType == HouseDirectoryNoteType.tutorial
          ? s.houseDirectoryEditTutorial
          : s.houseDirectoryEditNote;
    }
    return _titleController.text.trim().isEmpty
        ? (note?.noteType == HouseDirectoryNoteType.tutorial
            ? s.houseDirectoryTutorialsTitle
            : s.houseDirectoryTitle)
        : _titleController.text.trim();
  }

  void _onChanged() {
    if (!mounted) return;
    setState(() {
      _validationError = null;
      _titleError = null;
      _detailsError = null;
      _referenceUrlError = null;
    });
  }

  Future<void> _capturePhoto() async {
    if (_isUploadingPhoto) return;
    setState(() => _isUploadingPhoto = true);
    try {
      final photoPath = await widget.repository.captureAndUploadNotePhoto(
        homeId: widget.homeId,
      );
      if (photoPath == null || !mounted) {
        setState(() => _isUploadingPhoto = false);
        return;
      }
      setState(() {
        _isUploadingPhoto = false;
        _photoPath = photoPath;
        _photoUrl = widget.repository.toPublicPhotoUrl(photoPath);
      });
    } on HouseDirectoryPhotoCaptureException catch (error) {
      setState(() => _isUploadingPhoto = false);
      if (!mounted) return;
      if (error.kind == HouseDirectoryPhotoCaptureErrorKind.permission) {
        KinlySnackBar.showInfo(
          context,
          error.message,
          actionLabel:
              error.permanentlyDenied ? S.of(context).flowChorePhotoPermissionOpenSettings : null,
          onAction: error.permanentlyDenied ? openAppSettings : null,
        );
        return;
      }
      KinlySnackBar.showError(context, error.message);
    } catch (_) {
      setState(() => _isUploadingPhoto = false);
      if (!mounted) return;
      KinlySnackBar.showError(context, S.of(context).houseDirectoryNotePhotoUploadError);
    }
  }

  void _save(HouseDirectoryNote? note) {
    final s = S.of(context);
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() {
        _titleError = title.isEmpty ? s.houseDirectoryValidationNoteFields : null;
        _detailsError = null;
        _referenceUrlError = null;
        _validationError = s.houseDirectoryValidationNoteFields;
      });
      return;
    }
    if (!hasValidHouseDirectoryReferenceUrl(_referenceUrlController.text)) {
      setState(() {
        _titleError = null;
        _detailsError = null;
        _referenceUrlError = s.houseDirectoryValidationUrl;
        _validationError = s.houseDirectoryValidationUrl;
      });
      return;
    }
    setState(() {
      _validationError = null;
      _titleError = null;
      _detailsError = null;
      _referenceUrlError = null;
    });
    context.read<HouseDirectoryBloc>().add(
          HouseDirectoryNoteSaved(
            UpsertHouseDirectoryNoteInput(
              homeId: widget.homeId,
              noteId: note?.id,
              title: _titleController.text.trim(),
              details: _detailsController.text.trim(),
              noteType:
                  note?.noteType ??
                  widget.initialNoteType,
              referenceUrl: _emptyToNull(_referenceUrlController.text),
              photoPath: _photoPath,
            ),
          ),
        );
  }

  Future<void> _confirmArchive(HouseDirectoryNote? note) async {
    if (note == null) return;
    final s = S.of(context);
    final shouldArchive = await showKinlyConfirmDialog(
      context,
      title: s.houseDirectoryArchiveNoteTitle,
      message: s.houseDirectoryArchiveNoteBody,
      confirmLabel: s.houseDirectoryArchiveConfirm,
      destructive: true,
    );
    if (shouldArchive != true || !mounted) return;
    context.read<HouseDirectoryBloc>().add(HouseDirectoryNoteArchived(note.id));
  }

  void _onNoticeChanged(BuildContext context, HouseDirectoryState state) {
    final notice = state.notice;
    if (notice == null) {
      _lastHandledNotice = null;
      return;
    }
    if (notice == _lastHandledNotice) return;
    _lastHandledNotice = notice;
    switch (notice) {
      case HouseDirectoryNotice.noteSaved:
        if (!mounted) return;
        if (widget.isCreating) {
          Navigator.of(context).pop();
          return;
        }
        setState(() => _isEditing = false);
        return;
      case HouseDirectoryNotice.noteArchived:
        if (!mounted) return;
        Navigator.of(context).pop();
        return;
      case HouseDirectoryNotice.actionFailed:
        if (!mounted) return;
        KinlySnackBar.showError(
          context,
          state.errorMessage ?? S.of(context).houseDirectoryActionFailed,
        );
        return;
      default:
        return;
    }
  }

  void _openPhotoViewer(String photoUrl) {
    final heroTag = 'house-directory-note-photo-${photoUrl.hashCode}';
    context.pushNamed(
      AppRouteNames.houseDirectoryPhoto,
      extra: HouseDirectoryPhotoRouteArgs(
        photoUrl: photoUrl,
        title: S.of(context).houseDirectoryPhotoViewerTitle,
        heroTag: heroTag,
      ),
    );
  }
}

String? _emptyToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
