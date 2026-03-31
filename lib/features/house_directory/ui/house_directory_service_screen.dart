import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/flow/flow_chore_outcome.dart';
import 'package:kinly/contracts/flow/flow_chore_prefill.dart';
import 'package:kinly/contracts/flow/route_args.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/contracts/house_directory/route_args.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/dialogs/kinly_dialogs.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_date_picker.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_service_screen_content.dart';
import 'package:kinly/generated/l10n.dart';

part 'house_directory_service_screen_helpers.dart';
part 'house_directory_service_screen_state_logic.dart';

class HouseDirectoryServiceScreen extends StatefulWidget {
  const HouseDirectoryServiceScreen({
    super.key,
    required this.homeId,
    required this.isOwner,
    this.serviceId,
    this.reminderId,
    this.startInEditMode = false,
  });

  final String homeId;
  final bool isOwner;
  final String? serviceId;
  final String? reminderId;
  final bool startInEditMode;

  bool get isCreating => serviceId == null;

  @override
  State<HouseDirectoryServiceScreen> createState() =>
      _HouseDirectoryServiceScreenState();
}

class _HouseDirectoryServiceScreenState extends State<HouseDirectoryServiceScreen> {
  static const int _daysPerMonth = 30;

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
  bool _isHydrating = false;
  String? _hydratedServiceId;
  String? _pendingHydrationServiceId;
  HouseDirectoryNotice? _lastHandledNotice;

  @override
  void initState() {
    super.initState();
    _isEditing =
        widget.isCreating || (widget.isOwner && widget.startInEditMode);
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
        final reminder = _resolveReminder(state, service);
        _scheduleHydration(service);

        return KinlyScaffold(
          appBar: KinlyAppBar(
            title: Text(_titleForState(s)),
            actions: buildHouseDirectoryServiceAppBarActions(
              isCreating: widget.isCreating,
              isOwner: widget.isOwner,
              isEditing: _isEditing,
              editLabel: s.houseDirectoryEdit,
              onEdit: () => setState(() => _isEditing = true),
            ),
          ),
          body: SafeArea(
            child: _buildBody(
              state: state,
              service: service,
              reminder: reminder,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody({
    required HouseDirectoryState state,
    required HouseDirectoryService? service,
    required HouseDirectoryReminder? reminder,
  }) => _buildHouseDirectoryServiceBody(
    screen: this,
    state: state,
    service: service,
    reminder: reminder,
  );

  HouseDirectoryService? _resolveService(HouseDirectoryState state) {
    return resolveHouseDirectoryService(
      state: state,
      serviceId: widget.serviceId,
    );
  }

  HouseDirectoryReminder? _resolveReminder(
    HouseDirectoryState state,
    HouseDirectoryService? service,
  ) {
    return resolveHouseDirectoryReminder(
      state: state,
      reminderId: widget.reminderId,
      service: service,
    );
  }

  String _titleForState(S s) {
    if (widget.isCreating) return s.houseDirectoryAddService;
    if (_isEditing) return s.houseDirectoryEditService;
    return _providerController.text.trim().isEmpty
        ? s.houseDirectoryServicesTitle
        : _providerController.text.trim();
  }

  void _onChanged() {
    if (!mounted || _isHydrating) return;
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
    setState(() {
      _endDate = picked;
      _seedReminderDefaults();
    });
  }

  void _hydrateFromService(HouseDirectoryService? service) =>
      _hydrateHouseDirectoryService(this, service);

  void _scheduleHydration(HouseDirectoryService? service) =>
      _scheduleHouseDirectoryServiceHydration(this, service);

  void _save(HouseDirectoryService? service) =>
      _saveHouseDirectoryService(this, service);

  void _seedReminderDefaults() => _seedHouseDirectoryReminderDefaults(this);

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

  Future<void> _openCreateTask(
    HouseDirectoryService service,
    HouseDirectoryReminder reminder,
  ) => _openHouseDirectoryCreateTask(this, service, reminder);

  String _taskTitleFor(HouseDirectoryService service) {
    return (service.customLabel ?? service.providerName).trim();
  }

  String? _ownerUserId(HouseDirectoryState state) {
    for (final member in state.members) {
      if (member.isOwner) return member.userId;
    }
    return null;
  }

  void _onNoticeChanged(BuildContext context, HouseDirectoryState state) =>
      _handleHouseDirectoryServiceNotice(this, context, state);
}
