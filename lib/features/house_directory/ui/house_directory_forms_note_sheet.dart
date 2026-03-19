part of 'house_directory_forms.dart';

class _NoteSheetBody extends StatefulWidget {
  const _NoteSheetBody({
    required this.homeId,
    this.note,
  });

  final String homeId;
  final HouseDirectoryNote? note;

  @override
  State<_NoteSheetBody> createState() => _NoteSheetBodyState();
}

class _NoteSheetBodyState extends State<_NoteSheetBody> {
  late final TextEditingController _titleController;
  late final TextEditingController _detailsController;
  late final TextEditingController _referenceUrlController;
  String? _titleError;
  String? _detailsError;
  String? _referenceUrlError;
  String? _error;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _detailsController = TextEditingController(
      text: widget.note?.details ?? '',
    );
    _referenceUrlController = TextEditingController(
      text: widget.note?.referenceUrl ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    _referenceUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HouseDirectoryNoteSheetContent(
      titleController: _titleController,
      detailsController: _detailsController,
      referenceUrlController: _referenceUrlController,
      titleError: _titleError,
      detailsError: _detailsError,
      referenceUrlError: _referenceUrlError,
      error: _error,
      onSave: _save,
    );
  }

  void _save() {
    final s = S.of(context);
    final title = _titleController.text.trim();
    final details = _detailsController.text.trim();
    final referenceUrl = _referenceUrlController.text.trim();
    String? titleError;
    String? detailsError;
    String? referenceUrlError;

    if (title.isEmpty) {
      titleError = s.houseDirectoryValidationNoteFields;
    }
    if (details.isEmpty) {
      detailsError = s.houseDirectoryNoteDetailsHint;
    }
    if (referenceUrl.isNotEmpty) {
      final uri = Uri.tryParse(referenceUrl);
      if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
        referenceUrlError = s.houseDirectoryValidationUrl;
      }
    }

    if (titleError != null || detailsError != null || referenceUrlError != null) {
      setState(() {
        _titleError = titleError;
        _detailsError = detailsError;
        _referenceUrlError = referenceUrlError;
        _error = null;
      });
      return;
    }
    setState(() {
      _titleError = null;
      _detailsError = null;
      _referenceUrlError = null;
      _error = null;
    });
    Navigator.of(context).pop(
      UpsertHouseDirectoryNoteInput(
        homeId: widget.homeId,
        noteId: widget.note?.id,
        title: _titleController.text.trim(),
        details: _detailsController.text.trim(),
        noteType: widget.note?.noteType ?? HouseDirectoryNoteType.general,
        referenceUrl: _nullIfBlank(_referenceUrlController.text),
        photoPath: widget.note?.photoPath,
      ),
    );
  }
}
