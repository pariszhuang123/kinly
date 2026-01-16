import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/auth/models/user_context.dart';
import 'package:kinly/contracts/auth/ports/user_context_repository.dart';

import 'user_context_extensions.dart';

class UserContextState extends Equatable {
  const UserContextState({
    this.isLoading = false,
    this.context,
    this.error,
  });

  final bool isLoading;
  final UserContext? context;
  final String? error;

  bool get hasArtifacts => context?.hasPersonalArtifact == true;

  UserContextState copyWith({
    bool? isLoading,
    Object? context = _unset,
    Object? error = _unset,
  }) {
    return UserContextState(
      isLoading: isLoading ?? this.isLoading,
      context: context == _unset ? this.context : context as UserContext?,
      error: error == _unset ? this.error : error as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [isLoading, context, error];
}

class UserContextCubit extends Cubit<UserContextState> {
  UserContextCubit({required UserContextRepository repository})
    : _repository = repository,
      super(const UserContextState());

  final UserContextRepository _repository;

  Future<UserContext?> refresh() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final ctx = await _repository.fetch();
      emit(state.copyWith(isLoading: false, context: ctx));
      return ctx;
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
      return null;
    }
  }

  void clear() => emit(const UserContextState());
}
