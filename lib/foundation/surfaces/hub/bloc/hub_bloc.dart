import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/core/config/app_config.dart';
import 'package:kinly/core/platform/platform_info.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';

part 'hub_event.dart';
part '../enums/hub_enums.dart';
part 'hub_state.dart';

class HubBloc extends Bloc<HubEvent, HubState> {
  HubBloc({
    required HomeRepository homeRepository,
    required PreferenceReportsRepository preferenceReportsRepository,
    required String homeId,
    Logger? logger,
  }) : _homeRepository = homeRepository,
       _preferenceReportsRepository = preferenceReportsRepository,
       _homeId = homeId,
       _logger = logger ?? const DebugLogger(),
       super(HubState.initial(appLink: _resolveAppLink())) {
    on<HubStarted>(_onStarted);
    on<HubRefreshed>(_onRefreshed);
    on<HubInviteRotated>(_onRotateInvite);
    on<HubShareLogged>(_onShareLogged);

    add(const HubStarted());
  }

  final HomeRepository _homeRepository;
  final PreferenceReportsRepository _preferenceReportsRepository;
  final String _homeId;
  final Logger _logger;

  Future<void> _onStarted(HubStarted event, Emitter<HubState> emit) async {
    await _loadHub(emit, isRefresh: false);
  }

  Future<void> _onRefreshed(HubRefreshed event, Emitter<HubState> emit) async {
    await _loadHub(emit, isRefresh: true);
  }

  Future<void> _onRotateInvite(
    HubInviteRotated event,
    Emitter<HubState> emit,
  ) async {
    final previousInviteCode = state.invite?.code;
    var rotateFailed = false;
    try {
      await _homeRepository.rotateInvite(_homeId);
    } catch (error, stack) {
      rotateFailed = true;
      _logger.warn(
        'Failed to rotate invite',
        error: error,
        stackTrace: stack,
        tag: 'Hub',
      );
    }
    await _loadHub(
      emit,
      isRefresh: true,
      previousInviteCode: previousInviteCode,
      rotateFailed: rotateFailed,
    );
  }

  Future<void> _onShareLogged(
    HubShareLogged event,
    Emitter<HubState> emit,
  ) async {
    try {
      await _homeRepository.logShareEvent(
        feature: event.feature,
        channel: event.channel,
        homeId: _homeId,
      );
    } catch (error, stack) {
      _logger.warn(
        'Failed to log share event',
        error: error,
        stackTrace: stack,
        tag: 'Hub',
      );
    }
  }

  Future<void> _loadHub(
    Emitter<HubState> emit, {
    required bool isRefresh,
    String? previousInviteCode,
    bool rotateFailed = false,
  }) async {
    emit(
      state.copyWith(
        status: isRefresh ? state.status : HubStatus.loading,
        isRefreshing: isRefresh,
        notice: null,
      ),
    );

    List<HomeMemberSummary> members;
    String? currentRole;
    String? currentUserId;
    try {
      final membership = await _homeRepository.getCurrentMembership();
      currentRole = membership?.role.toLowerCase();
      currentUserId = membership?.userId;
      members = await _homeRepository.listActiveMembers(
        _homeId,
        excludeSelf: false,
      );
    } catch (error, stack) {
      _logger.error(
        'Failed to load members',
        error: error,
        stackTrace: stack,
        tag: 'Hub',
      );
      if (isRefresh && state.status == HubStatus.success) {
        emit(
          state.copyWith(isRefreshing: false, notice: HubNotice.refreshFailed),
        );
        return;
      }
      emit(
        state.copyWith(
          status: HubStatus.failure,
          isRefreshing: false,
          notice: HubNotice.loadFailed,
        ),
      );
      return;
    }

    List<PreferenceReportListItem> preferenceReports = const [];
    try {
      final resolution = await _preferenceReportsRepository
          .getTemplateResolution(templateKey: 'personal_preferences_v1');
      preferenceReports = await _preferenceReportsRepository.listReportsForHome(
        homeId: _homeId,
        templateKey: 'personal_preferences_v1',
        locale: resolution.resolvedLocale,
      );
    } catch (error, stack) {
      _logger.warn(
        'Failed to load preference reports',
        error: error,
        stackTrace: stack,
        tag: 'Hub',
      );
    }

    HomeInvite? invite;
    String? inviteLink;

    // First try to fetch an existing invite (allowed for any active member).
    try {
      invite = await _homeRepository.getActiveInvite(_homeId);
      inviteLink = _buildInviteLink(invite);
    } catch (error, stack) {
      _logger.warn(
        'Active invite not found or unavailable',
        error: error,
        stackTrace: stack,
        tag: 'Hub',
      );
      // Owners still get a best-effort create path if allowed.
      try {
        invite = await _homeRepository.getOrCreateInvite(homeId: _homeId);
        inviteLink = _buildInviteLink(invite);
      } catch (_) {
        // Swallow; sharing will be disabled but hub still renders.
      }
    }

    final isOwner = (currentRole ?? '') == 'owner';

    final previousCode = previousInviteCode ?? state.invite?.code;
    final nextCode = invite?.code;
    final hasRotateChange =
        previousCode != null && nextCode != null && previousCode != nextCode;
    final notice =
        hasRotateChange
            ? HubNotice.rotateSuccess
            : (rotateFailed ? HubNotice.rotateFailed : null);

    emit(
      state.copyWith(
        status: HubStatus.success,
        members: members,
        preferenceReports: preferenceReports,
        currentUserId: currentUserId ?? '',
        invite: invite,
        inviteLink: inviteLink,
        isRefreshing: false,
        isOwner: isOwner,
        notice: notice,
      ),
    );
  }
}

String _resolveAppLink() {
  if (PlatformInfo.isIOS && AppConfig.iosStoreUrl.isNotEmpty) {
    return AppConfig.iosStoreUrl;
  }
  if (PlatformInfo.isAndroid && AppConfig.androidStoreUrl.isNotEmpty) {
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
