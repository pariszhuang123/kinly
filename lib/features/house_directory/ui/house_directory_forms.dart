import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_bottom_sheet.dart';
import 'package:kinly/core/ui/kinly_date_picker.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/features/house_directory/ui/house_directory_form_sections.dart';
import 'package:kinly/generated/l10n.dart';

Future<UpsertHouseDirectoryWifiInput?> showHouseDirectoryWifiSheet(
  BuildContext context, {
  required String homeId,
  HouseDirectoryWifi? wifi,
}) {
  final s = S.of(context);
  return KinlyBottomSheet.show<UpsertHouseDirectoryWifiInput>(
    context: context,
    title: wifi == null ? s.houseDirectoryAddWifi : s.houseDirectoryEditWifi,
    body: _WifiSheetBody(homeId: homeId, wifi: wifi),
  );
}

Future<UpsertHouseDirectoryServiceInput?> showHouseDirectoryServiceSheet(
  BuildContext context, {
  required String homeId,
  HouseDirectoryService? service,
  HouseDirectoryServiceType? initialType,
}) {
  final s = S.of(context);
  return KinlyBottomSheet.show<UpsertHouseDirectoryServiceInput>(
    context: context,
    title:
        service == null
            ? s.houseDirectoryAddService
            : s.houseDirectoryEditService,
    body: _ServiceSheetBody(
      homeId: homeId,
      service: service,
      initialType: initialType,
    ),
  );
}

Future<UpsertHouseDirectoryNoteInput?> showHouseDirectoryNoteSheet(
  BuildContext context, {
  required String homeId,
  HouseDirectoryNote? note,
}) {
  final s = S.of(context);
  return KinlyBottomSheet.show<UpsertHouseDirectoryNoteInput>(
    context: context,
    title: note == null ? s.houseDirectoryAddNote : s.houseDirectoryEditNote,
    body: _NoteSheetBody(homeId: homeId, note: note),
  );
}

class _WifiSheetBody extends StatefulWidget {
  const _WifiSheetBody({
    required this.homeId,
    this.wifi,
  });

  final String homeId;
  final HouseDirectoryWifi? wifi;

  @override
  State<_WifiSheetBody> createState() => _WifiSheetBodyState();
}

class _WifiSheetBodyState extends State<_WifiSheetBody> {
  late final TextEditingController _ssidController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _ssidController = TextEditingController(text: widget.wifi?.ssid ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          s.houseDirectoryPasswordHelper,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.lg),
        KinlyTextField(
          controller: _ssidController,
          labelText: s.houseDirectorySsidLabel,
        ),
        SizedBox(height: spacing.md),
        KinlyTextField(
          controller: _passwordController,
          labelText: s.houseDirectoryPasswordLabel,
          hintText: s.houseDirectoryPasswordHelper,
          obscureText: true,
        ),
        SizedBox(height: spacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            KinlyOutlinedButton.text(
              onPressed: _close,
              label: s.shareEditClose,
              fullWidth: false,
              compact: true,
            ),
            SizedBox(width: spacing.sm),
            KinlyFilledButton.text(
              onPressed: _save,
              label: s.houseDirectorySave,
            ),
          ],
        ),
      ],
    );
  }

  void _close() {
    Navigator.of(context).pop();
  }

  void _save() {
    Navigator.of(context).pop(
      UpsertHouseDirectoryWifiInput(
        homeId: widget.homeId,
        ssid: _ssidController.text.trim(),
        password:
            _passwordController.text.trim().isEmpty
                ? null
                : _passwordController.text,
      ),
    );
  }
}

class _ServiceSheetBody extends StatefulWidget {
  const _ServiceSheetBody({
    required this.homeId,
    this.service,
    this.initialType,
  });

  final String homeId;
  final HouseDirectoryService? service;
  final HouseDirectoryServiceType? initialType;

  @override
  State<_ServiceSheetBody> createState() => _ServiceSheetBodyState();
}

class _ServiceSheetBodyState extends State<_ServiceSheetBody> {
  static const int _daysPerWeek = 7;
  static const int _daysPerMonth = 30;

  late final TextEditingController _providerController;
  late final TextEditingController _customLabelController;
  late final TextEditingController _referenceController;
  late final TextEditingController _linkController;
  late final TextEditingController _offsetValueController;
  late final TextEditingController _notesController;
  late HouseDirectoryServiceType _type;
  HouseDirectoryReminderOffsetUnit? _offsetUnit;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _error;

  @override
  void initState() {
    super.initState();
    final service = widget.service;
    _providerController = TextEditingController(text: service?.providerName ?? '');
    _customLabelController = TextEditingController(
      text: service?.customLabel ?? '',
    );
    _referenceController = TextEditingController(
      text: service?.accountReference ?? '',
    );
    _linkController = TextEditingController(text: service?.linkUrl ?? '');
    _offsetValueController = TextEditingController(
      text: service?.renewalReminderOffsetValue?.toString() ?? '',
    );
    _notesController = TextEditingController(text: service?.notes ?? '');
    _type =
        service?.serviceType ??
        widget.initialType ??
        HouseDirectoryServiceType.internet;
    _offsetUnit = service?.renewalReminderOffsetUnit;
    _startDate = service?.termStartDate;
    _endDate = service?.termEndDate;
    _seedReminderDefaults();
  }

  @override
  void dispose() {
    _providerController.dispose();
    _customLabelController.dispose();
    _referenceController.dispose();
    _linkController.dispose();
    _offsetValueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return HouseDirectoryServiceSheetContent(
      type: _type,
      customLabelController: _customLabelController,
      providerController: _providerController,
      referenceController: _referenceController,
      linkController: _linkController,
      offsetValueController: _offsetValueController,
      notesController: _notesController,
      offsetUnit: _endDate == null ? null : _offsetUnit,
      startLabel: _formatDateLabel(s.houseDirectoryStartDate, _startDate),
      endLabel: _formatDateLabel(s.houseDirectoryEndDate, _endDate),
      error: _error,
      onTypeChanged: _updateType,
      onStartPressed: _pickStartDate,
      onEndPressed: _pickEndDate,
      onOffsetUnitChanged: _updateOffsetUnit,
      onSave: _save,
    );
  }

  String _formatDateLabel(String label, DateTime? value) {
    if (value == null) return label;
    return DateFormat.yMMMd().format(value);
  }

  void _updateType(HouseDirectoryServiceType? value) {
    if (value == null) return;
    setState(() => _type = value);
  }

  void _updateOffsetUnit(HouseDirectoryReminderOffsetUnit? value) {
    if (value == null) return;
    setState(() => _offsetUnit = value);
  }

  Future<void> _pickStartDate() async {
    final picked = await showKinlyDateOnlyPicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() => _startDate = picked);
  }

  Future<void> _pickEndDate() async {
    final picked = await showKinlyDateOnlyPicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _endDate = picked;
      _seedReminderDefaults(force: true);
    });
  }

  void _save() {
    final error = _validationError(S.of(context));
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() => _error = null);
    Navigator.of(context).pop(_buildInput());
  }

  String? _validationError(S s) {
    final providerName = _providerController.text.trim();
    final customLabel = _customLabelController.text.trim();
    final offsetValueRaw = _offsetValueController.text.trim();
    if (providerName.isEmpty) return s.houseDirectoryValidationProvider;
    if (_type == HouseDirectoryServiceType.other && customLabel.isEmpty) {
      return s.houseDirectoryValidationCustomLabel;
    }
    if (_type == HouseDirectoryServiceType.rent) {
      if (_startDate == null || _endDate == null) {
        return s.houseDirectoryValidationRentDates;
      }
    }
    if (_startDate != null &&
        _endDate != null &&
        _endDate!.isBefore(_startDate!)) {
      return s.houseDirectoryValidationDateRange;
    }
    if (_endDate != null && _isInvalidReminderOffset(offsetValueRaw)) {
      return s.houseDirectoryValidationReminderOffset;
    }
    return null;
  }

  bool _isInvalidReminderOffset(String offsetValueRaw) {
    if (offsetValueRaw.isEmpty) return false;
    final offsetValue = int.tryParse(offsetValueRaw);
    return offsetValue == null || offsetValue < 1;
  }

  void _seedReminderDefaults({bool force = false}) {
    if (_endDate == null) {
      _offsetValueController.clear();
      _offsetUnit = null;
      return;
    }
    final hasExistingOffset = _offsetValueController.text.trim().isNotEmpty;
    if (!force && hasExistingOffset && _offsetUnit != null) {
      return;
    }
    _offsetValueController.text = '1';
    _offsetUnit = _defaultOffsetUnitFor(_endDate!);
  }

  HouseDirectoryReminderOffsetUnit _defaultOffsetUnitFor(DateTime endDate) {
    final daysUntilEnd = endDate.difference(DateTime.now()).inDays;
    if (daysUntilEnd > _daysPerMonth) {
      return HouseDirectoryReminderOffsetUnit.month;
    }
    if (daysUntilEnd > _daysPerWeek) {
      return HouseDirectoryReminderOffsetUnit.week;
    }
    return HouseDirectoryReminderOffsetUnit.day;
  }

  UpsertHouseDirectoryServiceInput _buildInput() {
    final offsetValueRaw = _offsetValueController.text.trim();
    final shouldIncludeReminder = _endDate != null;
    final offsetValue =
        shouldIncludeReminder && offsetValueRaw.isNotEmpty
            ? int.tryParse(offsetValueRaw)
            : null;
    return UpsertHouseDirectoryServiceInput(
      homeId: widget.homeId,
      serviceId: widget.service?.id,
      serviceType: _type,
      providerName: _providerController.text.trim(),
      customLabel: _nullIfBlank(_customLabelController.text),
      accountReference: _nullIfBlank(_referenceController.text),
      linkUrl: _nullIfBlank(_linkController.text),
      termStartDate: _startDate,
      termEndDate: _endDate,
      renewalReminderOffsetValue: offsetValue,
      renewalReminderOffsetUnit:
          shouldIncludeReminder && offsetValue != null ? _offsetUnit : null,
      notes: _nullIfBlank(_notesController.text),
    );
  }
}

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
      error: _error,
      onSave: _save,
    );
  }

  void _save() {
    final error = _validationError(S.of(context));
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() => _error = null);
    Navigator.of(context).pop(
      UpsertHouseDirectoryNoteInput(
        homeId: widget.homeId,
        noteId: widget.note?.id,
        title: _titleController.text.trim(),
        details: _detailsController.text.trim(),
        referenceUrl: _nullIfBlank(_referenceUrlController.text),
        photoPath: widget.note?.photoPath,
      ),
    );
  }

  String? _validationError(S s) {
    final title = _titleController.text.trim();
    final details = _detailsController.text.trim();
    final referenceUrl = _referenceUrlController.text.trim();
    if (title.isEmpty || details.isEmpty) {
      return s.houseDirectoryValidationNoteFields;
    }
    if (referenceUrl.isEmpty) return null;
    final uri = Uri.tryParse(referenceUrl);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return s.houseDirectoryValidationUrl;
    }
    return null;
  }
}

String? _nullIfBlank(String raw) {
  final value = raw.trim();
  return value.isEmpty ? null : value;
}
