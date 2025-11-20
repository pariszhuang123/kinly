import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/app_version_repository.dart';

enum AppVersionStatus {
  initial,
  checking,
  upToDate,
  updateRecommended,
  hardBlocked,
  failed,
}

class AppVersionState extends Equatable {
  const AppVersionState({
    this.status = AppVersionStatus.initial,
    this.clientVersion,
    this.currentVersion,
    this.minSupportedVersion,
    this.notes,
    this.releasedAt,
    this.errorMessage,
  });

  final AppVersionStatus status;
  final String? clientVersion;
  final String? currentVersion;
  final String? minSupportedVersion;
  final String? notes;
  final DateTime? releasedAt;
  final String? errorMessage;

  AppVersionState copyWith({
    AppVersionStatus? status,
    String? clientVersion,
    String? currentVersion,
    String? minSupportedVersion,
    String? notes,
    DateTime? releasedAt,
    String? errorMessage,
  }) {
    return AppVersionState(
      status: status ?? this.status,
      clientVersion: clientVersion ?? this.clientVersion,
      currentVersion: currentVersion ?? this.currentVersion,
      minSupportedVersion: minSupportedVersion ?? this.minSupportedVersion,
      notes: notes ?? this.notes,
      releasedAt: releasedAt ?? this.releasedAt,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        clientVersion,
        currentVersion,
        minSupportedVersion,
        notes,
        releasedAt,
        errorMessage,
      ];
}

class AppVersionCubit extends Cubit<AppVersionState> {
  AppVersionCubit({required AppVersionRepository repository})
      : _repository = repository,
        super(const AppVersionState());

  final AppVersionRepository _repository;

  Future<void> checkForUpdates({required String clientVersion}) async {
    if (state.status == AppVersionStatus.checking &&
        state.clientVersion == clientVersion) {
      return;
    }
    emit(
      state.copyWith(
        status: AppVersionStatus.checking,
        clientVersion: clientVersion,
        errorMessage: null,
      ),
    );
    _log('Checking version for $clientVersion');
    try {
      final result = await _repository.checkVersion(
        clientVersion: clientVersion,
      );
      final status = result.hardBlocked
          ? AppVersionStatus.hardBlocked
          : result.updateRecommended
              ? AppVersionStatus.updateRecommended
              : AppVersionStatus.upToDate;
      emit(
        state.copyWith(
          status: status,
          currentVersion: result.currentVersion,
          minSupportedVersion: result.minSupportedVersion,
          notes: result.notes,
          releasedAt: result.releasedAt,
        ),
      );
      _log(
        'Server current=${result.currentVersion} min=${result.minSupportedVersion} '
        'hardBlocked=${result.hardBlocked} updateRecommended=${result.updateRecommended}',
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AppVersionStatus.failed,
          errorMessage: error.toString(),
        ),
      );
      _log('Version check failed: $error');
    }
  }

  void _log(String message) {
    debugPrint('[AppVersionCubit] $message');
  }
}
