import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_config.dart';
import '../../../core/homes/models.dart';
import '../../../core/logging/debug_logger.dart';
import '../../../core/logging/logger.dart';
import '../../../data/repositories/home_repository.dart';

part 'hub_event.dart';
part 'hub_state.dart';

class HubBloc extends Bloc<HubEvent, HubState> {
  HubBloc({
    required HomeRepository homeRepository,
    required String homeId,
    Logger? logger,
  }) : _homeRepository = homeRepository,
       _homeId = homeId,
       _logger = logger ?? const DebugLogger(),
       super(HubState.initial(appLink: _resolveAppLink())) {
    on<HubStarted>(_onStarted);
    on<HubRefreshed>(_onRefreshed);

    add(const HubStarted());
  }

  final HomeRepository _homeRepository;
  final String _homeId;
  final Logger _logger;

  Future<void> _onStarted(HubStarted event, Emitter<HubState> emit) async {
    await _loadHub(emit, isRefresh: false);
  }

  Future<void> _onRefreshed(HubRefreshed event, Emitter<HubState> emit) async {
    await _loadHub(emit, isRefresh: true);
  }

  Future<void> _loadHub(
    Emitter<HubState> emit, {
    required bool isRefresh,
  }) async {
    emit(
      state.copyWith(
        status: isRefresh ? state.status : HubStatus.loading,
        isRefreshing: isRefresh,
        errorMessage: null,
      ),
    );

    List<HomeMemberSummary> members;
    try {
      members = await _homeRepository.listActiveMembers(_homeId);
    } catch (error, stack) {
      _logger.error(
        'Failed to load members',
        error: error,
        stackTrace: stack,
        tag: 'Hub',
      );
      emit(
        state.copyWith(
          status: HubStatus.failure,
          isRefreshing: false,
          errorMessage: error.toString(),
        ),
      );
      return;
    }

    HomeInvite? invite;
    String? inviteLink;
    try {
      invite = await _homeRepository.getOrCreateInvite(_homeId);
      inviteLink = _buildInviteLink(invite);
    } catch (error, stack) {
      _logger.warn(
        'Invite unavailable (non-owner or inactive home)',
        error: error,
        stackTrace: stack,
        tag: 'Hub',
      );
    }

    emit(
      state.copyWith(
        status: HubStatus.success,
        members: members,
        invite: invite,
        inviteLink: inviteLink,
        isRefreshing: false,
      ),
    );
  }
}

String _resolveAppLink() {
  if (Platform.isIOS && AppConfig.iosStoreUrl.isNotEmpty) {
    return AppConfig.iosStoreUrl;
  }
  if (Platform.isAndroid && AppConfig.androidStoreUrl.isNotEmpty) {
    return AppConfig.androidStoreUrl;
  }
  if (AppConfig.androidStoreUrl.isNotEmpty) return AppConfig.androidStoreUrl;
  return AppConfig.iosStoreUrl;
}

String _buildInviteLink(HomeInvite invite) {
  final host =
      AppConfig.inviteHost.isNotEmpty
          ? AppConfig.inviteHost
          : AppConfig.deeplinkHost;
  final uri = Uri(
    scheme: 'https',
    host: host,
    pathSegments: ['kinly', 'join', invite.code],
  );
  return uri.toString();
}
