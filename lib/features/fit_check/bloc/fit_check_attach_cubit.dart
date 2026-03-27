import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/fit_check_models.dart';
import 'package:kinly/contracts/homes/ports/fit_check_repository.dart';

part 'fit_check_attach_state.dart';

enum FitCheckAttachStatus { ready, loading, success, failure }

class FitCheckAttachCubit extends Cubit<FitCheckAttachState> {
  FitCheckAttachCubit({
    required FitCheckRepository repository,
    required String draftId,
  }) : _repository = repository,
       _draftId = draftId,
       super(FitCheckAttachState.ready());

  final FitCheckRepository _repository;
  final String _draftId;

  Future<void> attach({required String homeId}) async {
    emit(FitCheckAttachState.loading());
    try {
      final result = await _repository.attachDraftToHome(
        draftId: _draftId,
        homeId: homeId,
      );
      emit(FitCheckAttachState.success(result));
    } catch (error) {
      emit(FitCheckAttachState.failure(_resolveMessage(error)));
    }
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
