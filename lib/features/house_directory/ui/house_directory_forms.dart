import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/inputs/kinly_dropdown_field.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_bottom_sheet.dart';
import 'package:kinly/core/ui/kinly_date_picker.dart';
import 'package:kinly/core/ui/kinly_dropdown_menu_item.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
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

Future<UpsertHouseDirectoryLinkInput?> showHouseDirectoryLinkSheet(
  BuildContext context, {
  required String homeId,
  HouseDirectoryLink? link,
}) {
  final s = S.of(context);
  return KinlyBottomSheet.show<UpsertHouseDirectoryLinkInput>(
    context: context,
    title: link == null ? s.houseDirectoryAddLink : s.houseDirectoryEditLink,
    body: _LinkSheetBody(homeId: homeId, link: link),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KinlyTextField(
          controller: _ssidController,
          labelText: s.houseDirectorySsidLabel,
        ),
        const SizedBox(height: 12),
        KinlyTextField(
          controller: _passwordController,
          labelText: s.houseDirectoryPasswordLabel,
          hintText: s.houseDirectoryPasswordHelper,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: KinlyFilledButton.text(
            onPressed: _save,
            label: s.houseDirectorySave,
          ),
        ),
      ],
    );
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
    final theme = KinlyThemeAccess.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KinlyDropdownField<HouseDirectoryServiceType>(
          value: _type,
          labelText: s.houseDirectoryServiceTypeLabel,
          items:
              HouseDirectoryServiceType.values
                  .map(
                    (type) => KinlyDropdownMenuItem.item(
                      value: type,
                      child: Text(type.wireValue),
                    ),
                  )
                  .toList(growable: false),
          onChanged: _updateType,
        ),
        if (_type == HouseDirectoryServiceType.other) ...[
          const SizedBox(height: 12),
          KinlyTextField(
            controller: _customLabelController,
            labelText: s.houseDirectoryCustomLabel,
          ),
        ],
        const SizedBox(height: 12),
        KinlyTextField(
          controller: _providerController,
          labelText: s.houseDirectoryProviderLabel,
        ),
        const SizedBox(height: 12),
        KinlyTextField(
          controller: _referenceController,
          labelText: s.houseDirectoryAccountReferenceLabel,
        ),
        const SizedBox(height: 12),
        KinlyTextField(
          controller: _linkController,
          labelText: s.houseDirectoryLinkLabel,
        ),
        const SizedBox(height: 12),
        _DateButtons(
          startLabel: _formatDateLabel(s.houseDirectoryStartDate, _startDate),
          endLabel: _formatDateLabel(s.houseDirectoryEndDate, _endDate),
          onStartPressed: _pickStartDate,
          onEndPressed: _pickEndDate,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: KinlyTextField(
                controller: _offsetValueController,
                labelText: s.houseDirectoryReminderOffset,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: KinlyDropdownField<HouseDirectoryReminderOffsetUnit?>(
                value: _offsetUnit,
                labelText: s.houseDirectoryReminderOffsetUnit,
                items: [
                  KinlyDropdownMenuItem.item<HouseDirectoryReminderOffsetUnit?>(
                    value: null,
                    child: Text(s.houseDirectoryReminderOffsetUnitNone),
                  ),
                  ...HouseDirectoryReminderOffsetUnit.values.map(
                    (unit) => KinlyDropdownMenuItem.item(
                      value: unit,
                      child: Text(unit.wireValue),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _offsetUnit = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        KinlyTextField(
          controller: _notesController,
          labelText: s.houseDirectoryNotes,
          minLines: 3,
          maxLines: 5,
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 16),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: KinlyFilledButton.text(
            onPressed: _save,
            label: s.houseDirectorySave,
          ),
        ),
      ],
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
    setState(() => _endDate = picked);
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
    if (_isInvalidReminderOffset(offsetValueRaw)) {
      return s.houseDirectoryValidationReminderOffset;
    }
    return null;
  }

  bool _isInvalidReminderOffset(String offsetValueRaw) {
    if (offsetValueRaw.isEmpty) return false;
    final offsetValue = int.tryParse(offsetValueRaw);
    return offsetValue == null || offsetValue < 1;
  }

  UpsertHouseDirectoryServiceInput _buildInput() {
    final offsetValueRaw = _offsetValueController.text.trim();
    final offsetValue =
        offsetValueRaw.isEmpty ? null : int.tryParse(offsetValueRaw);
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
      renewalReminderOffsetUnit: offsetValue == null ? null : _offsetUnit,
      notes: _nullIfBlank(_notesController.text),
    );
  }
}

class _LinkSheetBody extends StatefulWidget {
  const _LinkSheetBody({
    required this.homeId,
    this.link,
  });

  final String homeId;
  final HouseDirectoryLink? link;

  @override
  State<_LinkSheetBody> createState() => _LinkSheetBodyState();
}

class _LinkSheetBodyState extends State<_LinkSheetBody> {
  late final TextEditingController _titleController;
  late final TextEditingController _urlController;
  late final TextEditingController _customTagController;
  late HouseDirectoryLinkTag _tag;
  String? _error;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.link?.title ?? '');
    _urlController = TextEditingController(text: widget.link?.url ?? '');
    _customTagController = TextEditingController(
      text: widget.link?.customTag ?? '',
    );
    _tag = widget.link?.tag ?? HouseDirectoryLinkTag.utilities;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _customTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KinlyTextField(
          controller: _titleController,
          labelText: s.houseDirectoryTitleLabel,
        ),
        const SizedBox(height: 12),
        KinlyTextField(
          controller: _urlController,
          labelText: s.houseDirectoryUrlLabel,
        ),
        const SizedBox(height: 12),
        KinlyDropdownField<HouseDirectoryLinkTag>(
          value: _tag,
          labelText: s.houseDirectoryTagLabel,
          items:
              HouseDirectoryLinkTag.values
                  .map(
                    (tag) => KinlyDropdownMenuItem.item(
                      value: tag,
                      child: Text(tag.wireValue),
                    ),
                  )
                  .toList(growable: false),
          onChanged: _updateTag,
        ),
        if (_tag == HouseDirectoryLinkTag.other) ...[
          const SizedBox(height: 12),
          KinlyTextField(
            controller: _customTagController,
            labelText: s.houseDirectoryCustomTag,
          ),
        ],
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 16),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: KinlyFilledButton.text(
            onPressed: _save,
            label: s.houseDirectorySave,
          ),
        ),
      ],
    );
  }

  void _updateTag(HouseDirectoryLinkTag? value) {
    if (value == null) return;
    setState(() => _tag = value);
  }

  void _save() {
    final error = _validationError(S.of(context));
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() => _error = null);
    Navigator.of(context).pop(
      UpsertHouseDirectoryLinkInput(
        homeId: widget.homeId,
        linkId: widget.link?.id,
        title: _titleController.text.trim(),
        url: _urlController.text.trim(),
        tag: _tag,
        customTag: _nullIfBlank(_customTagController.text),
      ),
    );
  }

  String? _validationError(S s) {
    final title = _titleController.text.trim();
    final url = _urlController.text.trim();
    final customTag = _customTagController.text.trim();
    if (title.isEmpty || url.isEmpty) {
      return s.houseDirectoryValidationLinkFields;
    }
    final uri = Uri.tryParse(url);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return s.houseDirectoryValidationUrl;
    }
    if (_tag == HouseDirectoryLinkTag.other && customTag.isEmpty) {
      return s.houseDirectoryValidationCustomTag;
    }
    return null;
  }
}

class _DateButtons extends StatelessWidget {
  const _DateButtons({
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
    return Row(
      children: [
        Expanded(
          child: KinlyOutlinedButton.text(
            onPressed: onStartPressed,
            label: startLabel,
          ),
        ),
        const SizedBox(width: 12),
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

String? _nullIfBlank(String raw) {
  final value = raw.trim();
  return value.isEmpty ? null : value;
}
