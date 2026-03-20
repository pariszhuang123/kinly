import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/dialogs/kinly_dialogs.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_date_picker.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_route_args.dart';
import 'package:kinly/features/house_directory/ui/house_directory_service_screen_content.dart';
import 'package:kinly/generated/l10n.dart';

class HouseDirectoryServiceScreen extends StatefulWidget {
  const HouseDirectoryServiceScreen({
    super.key,
    required this.homeId,
    required this.isOwner,
    this.serviceId,
  });

  final String homeId;
  final bool isOwner;
  final String? serviceId;

  bool get isCreating => serviceId == null;

  @override
  State<HouseDirectoryServiceScreen> createState() =>
      _HouseDirectoryServiceScreenState();
}

class _HouseDirectoryServiceScreenState extends State<HouseDirectoryServiceScreen> {
  final _providerController = TextEditingController();
  final _customLabelController = TextEditingController();
  final _referenceController = TextEditingController();
  final _linkController = TextEditingController();
  final _offsetValueController = TextEditingController();
  final _notesController = TextEditingController();

  HouseDirectoryServiceType _type = HouseDirectoryServiceType.internet;
  HouseDirectoryReminderOffsetUnit? _offsetUnit;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _validationError;
  String? _providerError;
  String? _customLabelError;
  String? _linkError;
  String? _offsetValueError;
  bool _isEditing = false;
  String? _hydratedServiceId;
  HouseDirectoryNotice? _lastHandledNotice;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isCreating;
    for (final controller in [
      _providerController,
      _customLabelController,
      _referenceController,
      _linkController,
      _offsetValueController,
      _notesController,
    ]) {
      controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _providerController,
      _customLabelController,
      _referenceController,
      _linkController,
      _offsetValueController,
      _notesController,
    ]) {
      controller.removeListener(_onChanged);
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocConsumer<HouseDirectoryBloc, HouseDirectoryState>(
      listenWhen: (previous, current) => previous.notice != current.notice,
      listener: _onNoticeChanged,
      builder: (context, state) {
        final service = _resolveService(state);
        _hydrateFromService(service);

        return KinlyScaffold(
          appBar: KinlyAppBar(
            title: Text(_titleForState(s)),
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
            child: _buildBody(state: state, service: service),
          ),
        );
      },
    );
  }

  Widget _buildBody({
    required HouseDirectoryState state,
    required HouseDirectoryService? service,
  }) {
    final s = S.of(context);
    final canShow = widget.isCreating || service != null;

    if (!canShow && state.isLoading) {
      return const Center(child: KinlyLoader());
    }
    if (!canShow) {
      return Center(child: Text(s.houseDirectoryLoadError));
    }

    final hasChanges = houseDirectoryServiceHasChanges(
      isCreating: widget.isCreating,
      service: service,
      type: _type,
      providerController: _providerController,
      customLabelController: _customLabelController,
      referenceController: _referenceController,
      linkController: _linkController,
      notesController: _notesController,
      offsetValueController: _offsetValueController,
      offsetUnit: _offsetUnit,
      startDate: _startDate,
      endDate: _endDate,
    );

    return HouseDirectoryServiceContent(
      service: service,
      isEditing: _isEditing && widget.isOwner,
      isCreating: widget.isCreating,
      hasChanges: hasChanges,
      canSubmit: widget.isCreating || hasChanges,
      type: _type,
      offsetUnit: _offsetUnit,
      startDate: _startDate,
      endDate: _endDate,
      providerController: _providerController,
      customLabelController: _customLabelController,
      referenceController: _referenceController,
      linkController: _linkController,
      offsetValueController: _offsetValueController,
      notesController: _notesController,
      providerError: _providerError,
      customLabelError: _customLabelError,
      linkError: _linkError,
      offsetValueError: _offsetValueError,
      validationError: _validationError,
      onTypeChanged: (value) {
        if (value == null) return;
        setState(() => _type = value);
      },
      onStartPressed: _pickStartDate,
      onEndPressed: _pickEndDate,
      onOffsetUnitChanged: (value) {
        if (value == null) return;
        setState(() => _offsetUnit = value);
      },
      onArchive: () => _confirmArchive(service),
      onSave: () => _save(service),
    );
  }

  HouseDirectoryService? _resolveService(HouseDirectoryState state) {
    final serviceId = widget.serviceId;
    if (serviceId == null) return null;
    for (final service in state.services) {
      if (service.id == serviceId) return service;
    }
    return null;
  }

  void _hydrateFromService(HouseDirectoryService? service) {
    if (widget.isCreating || service == null) return;
    if (_hydratedServiceId == service.id && _isEditing) return;
    _hydratedServiceId = service.id;
    _providerController.text = service.providerName;
    _customLabelController.text = service.customLabel ?? '';
    _referenceController.text = service.accountReference ?? '';
    _linkController.text = service.linkUrl ?? '';
    _offsetValueController.text =
        service.renewalReminderOffsetValue?.toString() ?? '';
    _notesController.text = service.notes ?? '';
    _type = service.serviceType;
    _offsetUnit = service.renewalReminderOffsetUnit;
    _startDate = service.termStartDate;
    _endDate = service.termEndDate;
  }

  String _titleForState(S s) {
    if (widget.isCreating) return s.houseDirectoryAddService;
    if (_isEditing) return s.houseDirectoryEditService;
    return _providerController.text.trim().isEmpty
        ? s.houseDirectoryServicesTitle
        : _providerController.text.trim();
  }

  void _onChanged() {
    if (!mounted) return;
    setState(() {
      _validationError = null;
      _providerError = null;
      _customLabelError = null;
      _linkError = null;
      _offsetValueError = null;
    });
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

  void _save(HouseDirectoryService? service) {
    final s = S.of(context);
    final validation = validateHouseDirectoryService(
      s: s,
      type: _type,
      providerController: _providerController,
      customLabelController: _customLabelController,
      linkController: _linkController,
      offsetValueController: _offsetValueController,
      startDate: _startDate,
      endDate: _endDate,
    );
    if (validation.hasError) {
      setState(() {
        _providerError = validation.providerError;
        _customLabelError = validation.customLabelError;
        _linkError = validation.linkError;
        _offsetValueError = validation.offsetValueError;
        _validationError = validation.summaryError;
      });
      return;
    }
    setState(() {
      _validationError = null;
      _providerError = null;
      _customLabelError = null;
      _linkError = null;
      _offsetValueError = null;
    });
    final offsetValueRaw = _offsetValueController.text.trim();
    final offsetValue =
        _endDate != null && offsetValueRaw.isNotEmpty
            ? int.tryParse(offsetValueRaw)
            : null;
    context.read<HouseDirectoryBloc>().add(
          HouseDirectoryServiceSaved(
            UpsertHouseDirectoryServiceInput(
              homeId: widget.homeId,
              serviceId: service?.id,
              serviceType: _type,
              providerName: _providerController.text.trim(),
              customLabel: _emptyToNull(_customLabelController.text),
              accountReference: _emptyToNull(_referenceController.text),
              linkUrl: _emptyToNull(_linkController.text),
              termStartDate: _startDate,
              termEndDate: _endDate,
              renewalReminderOffsetValue: offsetValue,
              renewalReminderOffsetUnit:
                  _endDate != null && offsetValue != null ? _offsetUnit : null,
              notes: _emptyToNull(_notesController.text),
            ),
          ),
        );
  }

  Future<void> _confirmArchive(HouseDirectoryService? service) async {
    if (service == null) return;
    final s = S.of(context);
    final shouldArchive = await showKinlyConfirmDialog(
      context,
      title: s.houseDirectoryArchiveServiceTitle,
      message: s.houseDirectoryArchiveServiceBody,
      confirmLabel: s.houseDirectoryArchiveConfirm,
      destructive: true,
    );
    if (shouldArchive != true || !mounted) return;
    context.read<HouseDirectoryBloc>().add(
          HouseDirectoryServiceArchived(service.id),
        );
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
      case HouseDirectoryNotice.serviceSaved:
        if (!mounted) return;
        if (widget.isCreating) {
          Navigator.of(
            context,
          ).pop(HouseDirectoryRouteResult.serviceCreated);
          return;
        }
        setState(() => _isEditing = false);
        KinlySnackBar.showSuccess(
          context,
          S.of(context).houseDirectoryServiceSaved,
        );
        return;
      case HouseDirectoryNotice.serviceArchived:
        if (!mounted) return;
        Navigator.of(
          context,
        ).pop(HouseDirectoryRouteResult.serviceArchived);
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
}

String? _emptyToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
