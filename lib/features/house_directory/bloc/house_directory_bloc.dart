import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';

part 'house_directory_event.dart';
part 'house_directory_state.dart';

class HouseDirectoryBloc
    extends Bloc<HouseDirectoryEvent, HouseDirectoryState> {
  HouseDirectoryBloc({
    required HouseDirectoryRepository repository,
    required String homeId,
    required bool isOwner,
  }) : _repository = repository,
       _homeId = homeId,
       super(HouseDirectoryState.initial(isOwner: isOwner)) {
    on<HouseDirectoryStarted>(_onStarted);
    on<HouseDirectoryRefreshed>(_onRefreshed);
    on<HouseDirectoryWifiSaved>(_onWifiSaved);
    on<HouseDirectoryServiceSaved>(_onServiceSaved);
    on<HouseDirectoryServiceArchived>(_onServiceArchived);
    on<HouseDirectoryNoteSaved>(_onNoteSaved);
    on<HouseDirectoryNoteArchived>(_onNoteArchived);
    on<HouseDirectoryReminderAcknowledged>(_onReminderAcknowledged);
    on<HouseDirectoryReminderDismissed>(_onReminderDismissed);

    add(const HouseDirectoryStarted());
  }

  final HouseDirectoryRepository _repository;
  final String _homeId;

  Future<void> _onStarted(
    HouseDirectoryStarted event,
    Emitter<HouseDirectoryState> emit,
  ) async {
    await _load(emit, isRefresh: false);
  }

  Future<void> _onRefreshed(
    HouseDirectoryRefreshed event,
    Emitter<HouseDirectoryState> emit,
  ) async {
    await _load(emit, isRefresh: true);
  }

  Future<void> _onWifiSaved(
    HouseDirectoryWifiSaved event,
    Emitter<HouseDirectoryState> emit,
  ) async {
    await _runMutation(
      emit,
      action: () => _repository.upsertWifi(event.input),
      successNotice: HouseDirectoryNotice.wifiSaved,
    );
  }

  Future<void> _onServiceSaved(
    HouseDirectoryServiceSaved event,
    Emitter<HouseDirectoryState> emit,
  ) async {
    await _runMutation(
      emit,
      action: () => _repository.upsertService(event.input),
      successNotice: HouseDirectoryNotice.serviceSaved,
    );
  }

  Future<void> _onServiceArchived(
    HouseDirectoryServiceArchived event,
    Emitter<HouseDirectoryState> emit,
  ) async {
    await _runMutation(
      emit,
      action:
          () => _repository.archiveService(
            homeId: _homeId,
            serviceId: event.serviceId,
          ),
      successNotice: HouseDirectoryNotice.serviceArchived,
    );
  }

  Future<void> _onNoteSaved(
    HouseDirectoryNoteSaved event,
    Emitter<HouseDirectoryState> emit,
  ) async {
    await _runMutation(
      emit,
      action: () => _repository.upsertNote(event.input),
      successNotice: HouseDirectoryNotice.noteSaved,
    );
  }

  Future<void> _onNoteArchived(
    HouseDirectoryNoteArchived event,
    Emitter<HouseDirectoryState> emit,
  ) async {
    await _runMutation(
      emit,
      action:
          () => _repository.archiveNote(
            homeId: _homeId,
            noteId: event.noteId,
          ),
      successNotice: HouseDirectoryNotice.noteArchived,
    );
  }

  Future<void> _onReminderAcknowledged(
    HouseDirectoryReminderAcknowledged event,
    Emitter<HouseDirectoryState> emit,
  ) async {
    await _runMutation(
      emit,
      action:
          () => _repository.acknowledgeReminder(
            homeId: _homeId,
            reminderId: event.reminderId,
          ),
      successNotice: HouseDirectoryNotice.reminderAcknowledged,
    );
  }

  Future<void> _onReminderDismissed(
    HouseDirectoryReminderDismissed event,
    Emitter<HouseDirectoryState> emit,
  ) async {
    await _runMutation(
      emit,
      action:
          () => _repository.dismissReminder(
            homeId: _homeId,
            reminderId: event.reminderId,
          ),
      successNotice: HouseDirectoryNotice.reminderDismissed,
    );
  }

  Future<void> _load(
    Emitter<HouseDirectoryState> emit, {
    required bool isRefresh,
  }) async {
    emit(
      state.copyWith(
        status:
            isRefresh && state.hasLoaded
                ? HouseDirectoryStatus.success
                : HouseDirectoryStatus.loading,
        isRefreshing: isRefresh,
        notice: null,
        errorMessage: null,
      ),
    );
    try {
      final wifiFuture = _repository.getWifi(homeId: _homeId);
      final contentFuture = _repository.getContent(homeId: _homeId);
      final remindersFuture = _repository.listDueReminders(homeId: _homeId);
      final wifi = await wifiFuture;
      final content = await contentFuture;
      final reminders = await remindersFuture;
      emit(
        state.copyWith(
          status: HouseDirectoryStatus.success,
          wifi: wifi,
          services: content.services,
          notes: content.notes,
          reminders: reminders,
          isRefreshing: false,
          notice: null,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HouseDirectoryStatus.failure,
          isRefreshing: false,
          errorMessage: _mapErrorMessage(error),
          notice: HouseDirectoryNotice.loadFailed,
        ),
      );
    }
  }

  Future<void> _runMutation(
    Emitter<HouseDirectoryState> emit, {
    required Future<Object?> Function() action,
    required HouseDirectoryNotice successNotice,
  }) async {
    emit(
      state.copyWith(
        status: HouseDirectoryStatus.working,
        notice: null,
        errorMessage: null,
      ),
    );
    try {
      await action();
      final wifiFuture = _repository.getWifi(homeId: _homeId);
      final contentFuture = _repository.getContent(homeId: _homeId);
      final remindersFuture = _repository.listDueReminders(homeId: _homeId);
      final wifi = await wifiFuture;
      final content = await contentFuture;
      final reminders = await remindersFuture;
      emit(
        state.copyWith(
          status: HouseDirectoryStatus.success,
          wifi: wifi,
          services: content.services,
          notes: content.notes,
          reminders: reminders,
          notice: successNotice,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HouseDirectoryStatus.success,
          notice: HouseDirectoryNotice.actionFailed,
          errorMessage: _mapErrorMessage(error),
        ),
      );
    }
  }

  String _mapErrorMessage(Object error) {
    if (error is HouseDirectoryException) return error.message;
    return error.toString();
  }
}
