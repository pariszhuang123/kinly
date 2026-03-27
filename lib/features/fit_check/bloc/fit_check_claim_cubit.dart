import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/fit_check_models.dart';
import 'package:kinly/contracts/homes/ports/fit_check_repository.dart';

part 'fit_check_claim_state.dart';

enum FitCheckClaimStatus { loading, ready, failure }

class FitCheckClaimCubit extends Cubit<FitCheckClaimState> {
  FitCheckClaimCubit({
    required FitCheckRepository repository,
    required String claimToken,
  }) : _repository = repository,
       _claimToken = claimToken,
       super(FitCheckClaimState.loading());

  final FitCheckRepository _repository;
  final String _claimToken;

  Future<void> load() async {
    emit(FitCheckClaimState.loading());
    if (_claimToken.trim().isEmpty) {
      emit(FitCheckClaimState.failure('MISSING_CLAIM_TOKEN'));
      return;
    }
    try {
      final result = await _repository.claimDraft(claimToken: _claimToken);
      emit(FitCheckClaimState.ready(result));
    } catch (error) {
      emit(FitCheckClaimState.failure(_resolveMessage(error)));
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
