import 'package:flutter/widgets.dart';

import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/media/kinly_photo_capture.dart';
import 'package:kinly/generated/l10n.dart';

class HouseDirectoryNoteContent extends StatelessWidget {
  const HouseDirectoryNoteContent({
    super.key,
    required this.note,
    required this.canShowEditor,
    required this.isEditing,
    required this.isCreating,
    required this.isUploadingPhoto,
    required this.photoUrl,
    required this.hasPhoto,
    required this.hasChanges,
    required this.canSubmit,
    required this.titleController,
    required this.detailsController,
    required this.referenceUrlController,
    required this.titleError,
    required this.detailsError,
    required this.referenceUrlError,
    required this.validationError,
    required this.onCapturePhoto,
    required this.onReferenceTap,
    required this.onPhotoTap,
    required this.onArchive,
    required this.onSave,
  });

  final HouseDirectoryNote? note;
  final bool canShowEditor;
  final bool isEditing;
  final bool isCreating;
  final bool isUploadingPhoto;
  final String photoUrl;
  final bool hasPhoto;
  final bool hasChanges;
  final bool canSubmit;
  final TextEditingController titleController;
  final TextEditingController detailsController;
  final TextEditingController referenceUrlController;
  final String? titleError;
  final String? detailsError;
  final String? referenceUrlError;
  final String? validationError;
  final VoidCallback onCapturePhoto;
  final VoidCallback? onReferenceTap;
  final VoidCallback? onPhotoTap;
  final VoidCallback onArchive;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    if (!canShowEditor) {
      return Center(child: Text(s.houseDirectoryLoadError));
    }

    return Padding(
      padding: EdgeInsetsDirectional.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child:
                  isEditing
                      ? _HouseDirectoryNoteEditor(
                        titleController: titleController,
                        detailsController: detailsController,
                        referenceUrlController: referenceUrlController,
                        titleError: titleError,
                        detailsError: detailsError,
                        referenceUrlError: referenceUrlError,
                        validationError: validationError,
                        photoUrl: photoUrl,
                        hasPhoto: hasPhoto,
                        isUploadingPhoto: isUploadingPhoto,
                        onCapturePhoto: onCapturePhoto,
                      )
                      : HouseDirectoryNoteReadOnlyContent(
                        title: titleController.text.trim(),
                        details: detailsController.text.trim(),
                        referenceUrl: referenceUrlController.text.trim(),
                        photoUrl: photoUrl,
                        onReferenceTap: onReferenceTap,
                        onPhotoTap: onPhotoTap,
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
          ],
        ],
      ),
    );
  }
}

class _HouseDirectoryNoteEditor extends StatelessWidget {
  const _HouseDirectoryNoteEditor({
    required this.titleController,
    required this.detailsController,
    required this.referenceUrlController,
    required this.titleError,
    required this.detailsError,
    required this.referenceUrlError,
    required this.validationError,
    required this.photoUrl,
    required this.hasPhoto,
    required this.isUploadingPhoto,
    required this.onCapturePhoto,
  });

  final TextEditingController titleController;
  final TextEditingController detailsController;
  final TextEditingController referenceUrlController;
  final String? titleError;
  final String? detailsError;
  final String? referenceUrlError;
  final String? validationError;
  final String photoUrl;
  final bool hasPhoto;
  final bool isUploadingPhoto;
  final VoidCallback onCapturePhoto;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

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
          minLines: 4,
          maxLines: 7,
          errorText: detailsError,
        ),
        SizedBox(height: spacing.md),
        KinlyTextField(
          controller: referenceUrlController,
          labelText: s.houseDirectoryNoteUrlLabel,
          hintText: s.houseDirectoryNoteUrlHint,
          errorText: referenceUrlError,
        ),
        SizedBox(height: spacing.md),
        KinlyPhotoCapture(
          photoUrl: photoUrl.isEmpty ? null : photoUrl,
          label:
              hasPhoto
                  ? s.houseDirectoryNotePhotoReplaceLabel
                  : s.houseDirectoryNotePhotoLabel,
          placeholderText: s.houseDirectoryNotePhotoPlaceholder,
          isUploading: isUploadingPhoto,
          onTap: onCapturePhoto,
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

class HouseDirectoryNoteReadOnlyContent extends StatelessWidget {
  const HouseDirectoryNoteReadOnlyContent({
    super.key,
    required this.title,
    required this.details,
    required this.referenceUrl,
    required this.photoUrl,
    this.onReferenceTap,
    this.onPhotoTap,
  });

  final String title;
  final String details;
  final String referenceUrl;
  final String photoUrl;
  final VoidCallback? onReferenceTap;
  final VoidCallback? onPhotoTap;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final hasDetails = details.isNotEmpty;
    final hasPhoto = photoUrl.isNotEmpty;
    final heroTag = 'house-directory-note-photo-${photoUrl.hashCode}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReadOnlyField(label: s.houseDirectoryTitleLabel, value: title),
        if (hasDetails) ...[
          SizedBox(height: spacing.md),
          _ReadOnlyField(
            label: s.houseDirectoryNoteDetailsLabel,
            value: details,
            maxLines: 10,
          ),
        ],
        if (referenceUrl.isNotEmpty) ...[
          SizedBox(height: spacing.md),
          KinlyOutlinedButton.text(
            onPressed: onReferenceTap,
            label: s.houseDirectoryOpenLink,
            compact: true,
          ),
        ],
        if (hasPhoto) ...[
          SizedBox(height: spacing.md),
          Text(s.houseDirectoryNotePhotoLabel, style: theme.textTheme.titleSmall),
          SizedBox(height: spacing.sm),
          KinlyTapTarget(
            onTap: onPhotoTap,
            borderRadius: BorderRadius.circular(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Hero(
                tag: heroTag,
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    cacheWidth: 800,
                  ),
                ),
              ),
            ),
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
    this.maxLines = 2,
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

bool houseDirectoryNoteHasChanges({
  required bool isCreating,
  required HouseDirectoryNote? note,
  required TextEditingController titleController,
  required TextEditingController detailsController,
  required TextEditingController referenceUrlController,
  required String? photoPath,
}) {
  if (isCreating) return true;
  if (note == null) return false;
  return titleController.text.trim() != note.title.trim() ||
      detailsController.text.trim() != note.details.trim() ||
      referenceUrlController.text.trim() != (note.referenceUrl ?? '').trim() ||
      (photoPath ?? '').trim() != (note.photoPath ?? '').trim();
}

bool hasValidHouseDirectoryReferenceUrl(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return true;
  final uri = Uri.tryParse(trimmed);
  return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
}
