import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';

part 'personal_directory_event.dart';
part 'personal_directory_state.dart';

class PersonalDirectoryBloc
    extends Bloc<PersonalDirectoryEvent, PersonalDirectoryState> {
  PersonalDirectoryBloc({
    required PersonalDirectoryRepository repository,
    required PersonalDirectoryMemberSummary target,
    required String currentUserId,
    this.homeId,
  }) : _repository = repository,
       _target = target,
       super(
         PersonalDirectoryState.initial(
           target: target,
           currentUserId: currentUserId,
           homeId: homeId,
         ),
       ) {
    on<PersonalDirectoryStarted>(_onStarted);
    on<PersonalDirectoryRefreshed>(_onRefreshed);
    on<PersonalDirectoryBankAccountSaved>(_onBankAccountSaved);
    on<PersonalDirectoryNoteCreated>(_onNoteCreated);
    on<PersonalDirectoryNoteUpdated>(_onNoteUpdated);
    on<PersonalDirectoryNoteArchived>(_onNoteArchived);

    add(const PersonalDirectoryStarted());
  }

  final PersonalDirectoryRepository _repository;
  final PersonalDirectoryMemberSummary _target;
  final String? homeId;

  Future<void> _onStarted(
    PersonalDirectoryStarted event,
    Emitter<PersonalDirectoryState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onRefreshed(
    PersonalDirectoryRefreshed event,
    Emitter<PersonalDirectoryState> emit,
  ) async {
    await _load(emit, isRefresh: true);
  }

  Future<void> _onBankAccountSaved(
    PersonalDirectoryBankAccountSaved event,
    Emitter<PersonalDirectoryState> emit,
  ) async {
    await _runMutation(
      emit,
      action: () => _repository.upsertOwnBankAccount(event.input),
      successNotice: PersonalDirectoryNotice.bankAccountSaved,
    );
  }

  Future<void> _onNoteCreated(
    PersonalDirectoryNoteCreated event,
    Emitter<PersonalDirectoryState> emit,
  ) async {
    await _runMutation(
      emit,
      action: () => _repository.createNote(event.input),
      successNotice: PersonalDirectoryNotice.noteSaved,
    );
  }

  Future<void> _onNoteUpdated(
    PersonalDirectoryNoteUpdated event,
    Emitter<PersonalDirectoryState> emit,
  ) async {
    await _runMutation(
      emit,
      action: () => _repository.updateNote(event.input),
      successNotice: PersonalDirectoryNotice.noteSaved,
    );
  }

  Future<void> _onNoteArchived(
    PersonalDirectoryNoteArchived event,
    Emitter<PersonalDirectoryState> emit,
  ) async {
    await _runMutation(
      emit,
      action: () => _repository.archiveNote(event.noteId),
      successNotice: PersonalDirectoryNotice.noteArchived,
    );
  }

  Future<void> _load(
    Emitter<PersonalDirectoryState> emit, {
    bool isRefresh = false,
  }) async {
    emit(
      state.copyWith(
        status:
            isRefresh && state.hasLoaded
                ? PersonalDirectoryStatus.success
                : PersonalDirectoryStatus.loading,
        notice: null,
        errorMessage: null,
      ),
    );
    try {
      final isSelf = state.isSelf;
      final bankFuture =
          isSelf ? _repository.getOwnBankAccount() : Future.value(null);
      final notesFuture = _repository.getNotes(
        targetUserId: isSelf ? null : _target.userId,
      );
      final bankAccount = await bankFuture;
      final notes = _sortNotes(await notesFuture);
      emit(
        state.copyWith(
          status: PersonalDirectoryStatus.success,
          bankAccount: bankAccount,
          notes: notes,
          notice: null,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PersonalDirectoryStatus.failure,
          notice: PersonalDirectoryNotice.loadFailed,
          errorMessage: _mapErrorMessage(error),
        ),
      );
    }
  }

  Future<void> _runMutation(
    Emitter<PersonalDirectoryState> emit, {
    required Future<Object?> Function() action,
    required PersonalDirectoryNotice successNotice,
  }) async {
    emit(
      state.copyWith(
        status: PersonalDirectoryStatus.working,
        notice: null,
        errorMessage: null,
      ),
    );
    try {
      await action();
      await _load(emit, isRefresh: true);
      emit(
        state.copyWith(
          notice: successNotice,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PersonalDirectoryStatus.success,
          notice: PersonalDirectoryNotice.actionFailed,
          errorMessage: _mapErrorMessage(error),
        ),
      );
    }
  }

  String _mapErrorMessage(Object error) {
    if (error is PersonalDirectoryException) return error.message;
    return error.toString();
  }

  List<PersonalDirectoryNote> _sortNotes(List<PersonalDirectoryNote> notes) {
    final sorted = List<PersonalDirectoryNote>.from(notes);
    sorted.sort(_compareNotes);
    return List<PersonalDirectoryNote>.unmodifiable(sorted);
  }

  int _compareNotes(PersonalDirectoryNote left, PersonalDirectoryNote right) {
    final typeOrder = _noteTypeOrder(left.noteType).compareTo(
      _noteTypeOrder(right.noteType),
    );
    if (typeOrder != 0) return typeOrder;
    return switch (left.noteType) {
      PersonalDirectoryNoteType.emergencyContact => left.id.compareTo(right.id),
      PersonalDirectoryNoteType.allergy => _compareAllergyNotes(left, right),
      PersonalDirectoryNoteType.other => _compareOtherNotes(left, right),
    };
  }

  int _compareAllergyNotes(
    PersonalDirectoryNote left,
    PersonalDirectoryNote right,
  ) {
    final labelOrder = (left.label ?? '').toLowerCase().compareTo(
      (right.label ?? '').toLowerCase(),
    );
    if (labelOrder != 0) return labelOrder;
    return left.id.compareTo(right.id);
  }

  int _compareOtherNotes(
    PersonalDirectoryNote left,
    PersonalDirectoryNote right,
  ) {
    final createdAtOrder = right.createdAt.compareTo(left.createdAt);
    if (createdAtOrder != 0) return createdAtOrder;
    return left.id.compareTo(right.id);
  }

  int _noteTypeOrder(PersonalDirectoryNoteType type) {
    return switch (type) {
      PersonalDirectoryNoteType.emergencyContact => 0,
      PersonalDirectoryNoteType.allergy => 1,
      PersonalDirectoryNoteType.other => 2,
    };
  }
}
