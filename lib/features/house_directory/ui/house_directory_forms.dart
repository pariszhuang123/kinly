import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/theme/spacing.dart';
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
  return showGeneralDialog<UpsertHouseDirectoryWifiInput>(
    context: context,
    barrierDismissible: true,
    barrierLabel:
        wifi == null ? s.houseDirectoryAddWifi : s.houseDirectoryEditWifi,
    barrierColor: const Color(0x99000000),
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder:
        (dialogContext, _, __) => _WifiDialog(
          homeId: homeId,
          wifi: wifi,
        ),
    transitionBuilder: (dialogContext, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 0.96,
            end: 1,
          ).animate(curved),
          child: child,
        ),
      );
    },
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

class _WifiDialog extends StatefulWidget {
  const _WifiDialog({
    required this.homeId,
    this.wifi,
  });

  final String homeId;
  final HouseDirectoryWifi? wifi;

  @override
  State<_WifiDialog> createState() => _WifiDialogState();
}

class _WifiDialogState extends State<_WifiDialog> {
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
    final title =
        widget.wifi == null
            ? s.houseDirectoryAddWifi
            : s.houseDirectoryEditWifi;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Material(
              color: Colors.transparent,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(spacing.lg),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.45,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.12),
                      blurRadius: spacing.xl,
                      offset: Offset(0, spacing.xs),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    spacing.lg,
                    spacing.lg,
                    spacing.lg,
                    spacing.lg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(title, style: theme.textTheme.titleLarge),
                      SizedBox(height: spacing.xs),
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
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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
            hintText: s.houseDirectoryCustomLabelHint,
          ),
        ],
        const SizedBox(height: 12),
        KinlyTextField(
          controller: _providerController,
          labelText: s.houseDirectoryProviderLabel,
          hintText: s.houseDirectoryProviderHint,
        ),
        const SizedBox(height: 12),
        KinlyTextField(
          controller: _referenceController,
          labelText: s.houseDirectoryAccountReferenceLabel,
          hintText: s.houseDirectoryAccountReferenceHint,
        ),
        const SizedBox(height: 12),
        KinlyTextField(
          controller: _linkController,
          labelText: s.houseDirectoryLinkLabel,
          hintText: s.houseDirectoryProviderLinkHint,
        ),
        const SizedBox(height: 12),
        _DateButtons(
          startLabel: _formatDateLabel(s.houseDirectoryStartDate, _startDate),
          endLabel: _formatDateLabel(s.houseDirectoryEndDate, _endDate),
          onStartPressed: _pickStartDate,
          onEndPressed: _pickEndDate,
        ),
        if (_endDate != null) ...[
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
                child: KinlyDropdownField<HouseDirectoryReminderOffsetUnit>(
                  value: _offsetUnit ?? HouseDirectoryReminderOffsetUnit.day,
                  labelText: s.houseDirectoryReminderOffsetUnit,
                  items:
                      HouseDirectoryReminderOffsetUnit.values
                          .map(
                            (unit) => KinlyDropdownMenuItem.item(
                              value: unit,
                              child: Text(unit.wireValue),
                            ),
                          )
                          .toList(growable: false),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _offsetUnit = value);
                  },
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        KinlyTextField(
          controller: _notesController,
          labelText: s.houseDirectoryNotes,
          hintText: s.houseDirectoryNotesHint,
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
          hintText: s.houseDirectoryLinkTitleHint,
        ),
        const SizedBox(height: 12),
        KinlyTextField(
          controller: _urlController,
          labelText: s.houseDirectoryUrlLabel,
          hintText: s.houseDirectoryUrlHint,
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
            hintText: s.houseDirectoryCustomTagHint,
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
