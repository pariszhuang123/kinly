import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/fit_check_models.dart';
import 'package:kinly/contracts/homes/ports/fit_check_repository.dart';

part 'fit_check_briefing_state.dart';

enum FitCheckBriefingStatus { loading, ready, failure }

class FitCheckBriefingCubit extends Cubit<FitCheckBriefingState> {
  FitCheckBriefingCubit({
    required FitCheckRepository repository,
    required String submissionId,
    required String locale,
  }) : _repository = repository,
       _submissionId = submissionId,
       _locale = locale,
       super(FitCheckBriefingState.loading());

  final FitCheckRepository _repository;
  final String _submissionId;
  final String _locale;

  Future<void> load() async {
    emit(FitCheckBriefingState.loading());
    try {
      final briefing = await _repository.getOwnerBriefing(
        submissionId: _submissionId,
        locale: _locale,
      );
      emit(FitCheckBriefingState.ready(briefing));
    } catch (error) {
      emit(FitCheckBriefingState.failure(_resolveMessage(error)));
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
