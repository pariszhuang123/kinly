import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/fit_check_models.dart';
import 'package:kinly/contracts/homes/ports/fit_check_repository.dart';

part 'fit_check_inbox_state.dart';

enum FitCheckInboxStatus { loading, ready, failure }

class FitCheckInboxCubit extends Cubit<FitCheckInboxState> {
  FitCheckInboxCubit({
    required FitCheckRepository repository,
    required String draftId,
    required String locale,
  }) : _repository = repository,
       _draftId = draftId,
       _locale = locale,
       super(FitCheckInboxState.loading());

  final FitCheckRepository _repository;
  final String _draftId;
  final String _locale;

  Future<void> load() async {
    emit(FitCheckInboxState.loading());
    try {
      final review = await _repository.getOwnerReview(
        draftId: _draftId,
        locale: _locale,
      );
      emit(FitCheckInboxState.ready(review));
    } catch (error) {
      emit(FitCheckInboxState.failure(_resolveMessage(error)));
    }
  }

  Future<FitCheckPrefillPayload> getPrefillPayload() {
    return _repository.getPrefillPayload(draftId: _draftId);
  }

  Future<FitCheckShareTokenActionResult> rotateShareToken() async {
    final result = await _repository.rotateShareToken(draftId: _draftId);
    await load();
    return result;
  }

  Future<FitCheckShareTokenActionResult> revokeShareToken() async {
    final result = await _repository.revokeShareToken(draftId: _draftId);
    await load();
    return result;
  }

  String _resolveMessage(Object error) {
    final text = error.toString().trim();
    if (text.startsWith('Exception: ')) {
      return text.substring('Exception: '.length).trim();
    }
    if (text.startsWith('StateError: ')) {
      return text.substring('StateError: '.length).trim();
    }
    if (text.startsWith('Bad state: ')) {
      return text.substring('Bad state: '.length).trim();
    }
    return text;
  }
}
