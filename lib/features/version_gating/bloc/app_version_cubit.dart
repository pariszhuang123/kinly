import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/app_version_repository.dart';
import '../../../core/logging/debug_logger.dart';
import '../../../core/logging/logger.dart';

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
  AppVersionCubit({
    required AppVersionRepository repository,
    Logger? logger,
  })  : _repository = repository,
        _logger = logger ?? const DebugLogger(),
        super(const AppVersionState());

  final AppVersionRepository _repository;
  final Logger _logger;

  static const _logTag = 'AppVersionCubit';

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
    _logger.info('Checking version for $clientVersion', tag: _logTag);
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
      _logger.debug(
        'Server current=${result.currentVersion} min=${result.minSupportedVersion} '
        'hardBlocked=${result.hardBlocked} updateRecommended=${result.updateRecommended}',
        tag: _logTag,
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: AppVersionStatus.failed,
          errorMessage: error.toString(),
        ),
      );
      _logger.error(
        'Version check failed: $error',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
