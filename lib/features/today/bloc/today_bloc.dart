import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/chores/models.dart'; // ChoreListEntry, etc.
import '../../../core/expenses/models.dart';
import '../../../core/profile/models.dart';
import '../../../data/repositories/chores_repository.dart';
import '../../../data/repositories/expenses_repository.dart';
import '../../../data/repositories/home_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/mood_repository.dart';
import '../../../core/mood/models.dart';
import '../../../core/logging/logger.dart';
import '../../../core/logging/debug_logger.dart';
import '../../../core/profile/profile_update_notifier.dart';
import '../domain/models.dart'; // TodayFlowTask etc.

part 'today_event.dart';
part 'today_state.dart';

class TodayBloc extends Bloc<TodayEvent, TodayState> {
  final ChoresRepository _choresRepository;
  final ProfileRepository _profileRepository;
  final ExpensesRepository _expensesRepository;
  final HomeRepository _homeRepository;
  final MoodRepository _moodRepository;
  final ProfileUpdateNotifier _profileUpdateNotifier;
  final Logger _logger;
  final String _homeId;
  static const _gratitudeLogTag = 'TodayGratitude';
  late final StreamSubscription<UserProfile> _profileUpdateSub;

  TodayBloc({
    required ChoresRepository choresRepository,
    required ProfileRepository profileRepository,
    required ExpensesRepository expensesRepository,
    required HomeRepository homeRepository,
    required MoodRepository moodRepository,
    required String homeId,
    required ProfileUpdateNotifier profileUpdateNotifier,
    Logger? logger,
  }) : _choresRepository = choresRepository,
       _profileRepository = profileRepository,
       _expensesRepository = expensesRepository,
       _homeRepository = homeRepository,
       _moodRepository = moodRepository,
       _profileUpdateNotifier = profileUpdateNotifier,
       _logger = logger ?? const DebugLogger(),
       _homeId = homeId,
       super(const TodayState.loading()) {
    on<TodayStarted>(_onStarted);
    on<TodayRefreshed>(_onRefreshed);
    on<TodayProfileUpdated>(_onProfileUpdated);

    _profileUpdateSub = _profileUpdateNotifier.stream.listen(
      (profile) => add(TodayProfileUpdated(profile)),
    );

    // kick off initial load
    add(const TodayStarted());
  }

  Future<void> _onStarted(TodayStarted event, Emitter<TodayState> emit) async {
    await _loadToday(emit);
  }

  Future<void> _onRefreshed(
    TodayRefreshed event,
    Emitter<TodayState> emit,
  ) async {
    await _loadToday(emit, isRefresh: true);
  }

  Future<void> _onProfileUpdated(
    TodayProfileUpdated event,
    Emitter<TodayState> emit,
  ) async {
    final previous = state.profile;
    final resolvedProfile = TodayUserProfile(
      userId: event.profile.userId,
      username: event.profile.username,
      avatarUrl: event.profile.avatarUrl,
      isOwner: previous?.isOwner ?? false,
    );
    emit(_stateWithProfile(state, resolvedProfile));
  }

  Future<void> _loadToday(
    Emitter<TodayState> emit, {
    bool isRefresh = false,
  }) async {
    TodayUserProfile? profile = state.profile;
    final prevPromptTick = state.harmonyPromptTick;
    final prevHasShownHarmony = state.hasShownHarmonyPrompt;
    final prevNpsPromptTick = state.npsPromptTick;
    final prevHasShownNps = state.hasShownNpsPrompt;
    final prevGratitudeStatus = state.gratitudeStatus;
    try {
      if (!isRefresh) {
        emit(
          TodayState.loading(
            profile: profile,
            shareOwed: state.shareOwed,
            shareDrafts: state.shareDrafts,
            harmonyPromptTick: prevPromptTick,
            hasShownHarmonyPrompt: prevHasShownHarmony,
            npsPromptTick: prevNpsPromptTick,
            hasShownNpsPrompt: prevHasShownNps,
            gratitudeStatus: prevGratitudeStatus,
          ),
        );
      }

      final hasSubmittedMood = await _moodRepository.isSubmittedThisWeek(
        _homeId,
      );
      final npsRequired = await _isNpsRequiredSafely();
      final shouldPrompt = !hasSubmittedMood && !prevHasShownHarmony;
      final promptTick = shouldPrompt ? prevPromptTick + 1 : prevPromptTick;
      final hasShownPromptNext = prevHasShownHarmony || !hasSubmittedMood;
      final shouldPromptNps = npsRequired && !prevHasShownNps;
      final npsPromptTick =
          shouldPromptNps ? prevNpsPromptTick + 1 : prevNpsPromptTick;
      final hasShownNpsPromptNext = npsRequired;

      final profileFuture = _profileRepository.getCurrentProfile();
      final draftsFuture = _choresRepository.listTodayFlow(
        homeId: _homeId,
        state: ChoreState.draft,
      );
      final activeFuture = _choresRepository.listTodayFlow(
        homeId: _homeId,
        state: ChoreState.active,
      );
      final membersFuture = _homeRepository.listActiveMembers(
        _homeId,
        excludeSelf: false,
      );
      final wallStatusFuture = _moodRepository.getWallStatus(_homeId);

      final members = await membersFuture;
      String? ownerUserId;
      if (members.isNotEmpty) {
        ownerUserId =
            members
                .firstWhere(
                  (member) => member.isOwner,
                  orElse: () => members.first,
                )
                .userId;
      }

      profile = await _resolveProfile(
        profileFuture,
        fallback: profile,
        ownerUserId: ownerUserId,
      );
      final drafts = await draftsFuture;
      final active = await activeFuture;
      final shareSnapshot = await _loadShareSnapshot(
        ownerUserId: ownerUserId,
        currentUserId: profile?.userId,
      );
      final wallStatus = await _resolveGratitudeStatus(
        wallStatusFuture,
        fallback: prevGratitudeStatus,
        currentUserId: profile?.userId,
      );
      _logGratitudeStatus(wallStatus, profile?.userId);

      final draftTasks = drafts
          .map((entry) => _mapEntryToTodayTask(entry, isNewTodayOverride: true))
          .toList(growable: false);
      final activeTasks = active
          .map(_mapEntryToTodayTask)
          .toList(growable: false);

      emit(
        TodayState.loaded(
          activeTasks: activeTasks,
          draftTasks: draftTasks,
          shareOwed: shareSnapshot.owed,
          shareDrafts: shareSnapshot.drafts,
          shareErrorMessage: shareSnapshot.errorMessage,
          gratitudeStatus: wallStatus,
          profile: profile,
          harmonyPromptTick: promptTick,
          hasShownHarmonyPrompt: hasShownPromptNext,
          npsPromptTick: npsPromptTick,
          hasShownNpsPrompt: hasShownNpsPromptNext,
          // later: you can add today's expenses, gratitude items, etc.
        ),
      );
    } catch (error) {
      // for now: basic error handling
      emit(
        TodayState.failure(
          message: "Could not load today's chores. Please try again.",
          error: error,
          profile: profile,
          shareOwed: state.shareOwed,
          shareDrafts: state.shareDrafts,
          shareErrorMessage: state.shareErrorMessage,
          gratitudeStatus: prevGratitudeStatus,
          harmonyPromptTick: prevPromptTick,
          hasShownHarmonyPrompt: prevHasShownHarmony,
          npsPromptTick: prevNpsPromptTick,
          hasShownNpsPrompt: prevHasShownNps,
        ),
      );
      // optional: log error/stackTrace via your logger/Sentry here
    }
  }

  Future<TodayUserProfile?> _resolveProfile(
    Future<UserProfile?> future, {
    TodayUserProfile? fallback,
    String? ownerUserId,
  }) async {
    try {
      final profile = await future;
      if (profile == null) return fallback;
      return TodayUserProfile(
        userId: profile.userId,
        username: profile.username,
        avatarUrl: profile.avatarUrl,
        isOwner: ownerUserId != null && profile.userId == ownerUserId,
      );
    } catch (_) {
      return fallback;
    }
  }

  TodayFlowTask _mapEntryToTodayTask(
    TodayFlowEntry entry, {
    bool? isNewTodayOverride,
  }) {
    return TodayFlowTask(
      id: entry.id,
      title: entry.name,
      state: entry.state,
      isNewToday: isNewTodayOverride ?? entry.isDraft,
    );
  }

  Future<_ShareSnapshot> _loadShareSnapshot({
    String? ownerUserId,
    String? currentUserId,
  }) async {
    try {
      final owed = await _expensesRepository.listCurrentOwed(homeId: _homeId);
      final created = await _expensesRepository.listCreatedByMe(
        homeId: _homeId,
      );
      final owedView = owed
          .map(
            (entry) =>
                TodayShareOwed.fromModel(entry, ownerUserId: ownerUserId),
          )
          .toList(growable: false);
      final drafts = created
          .where(
            (entry) =>
                entry.status == ExpenseStatus.draft &&
                (currentUserId == null ||
                    entry.createdByUserId == currentUserId),
          )
          .map(TodayShareDraft.fromSummary)
          .toList(growable: false);
      return _ShareSnapshot(owed: owedView, drafts: drafts);
    } catch (error) {
      return _ShareSnapshot(
        owed: const [],
        drafts: const [],
        errorMessage: error.toString(),
      );
    }
  }

  Future<bool> _isNpsRequiredSafely() async {
    try {
      return await _moodRepository.isNpsRequired(_homeId);
    } catch (_) {
      return false;
    }
  }

  Future<GratitudeWallStatus> _resolveGratitudeStatus(
    Future<GratitudeWallStatus> future, {
    GratitudeWallStatus? fallback,
    String? currentUserId,
  }) async {
    try {
      return await future;
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to load gratitude wall status; using fallback '
        'hasUnread=${fallback?.hasUnread}',
        tag: _gratitudeLogTag,
        error: error,
        stackTrace: stackTrace,
      );
      return fallback ?? const GratitudeWallStatus(hasUnread: false);
    }
  }

  void _logGratitudeStatus(GratitudeWallStatus status, String? currentUserId) {
    _logger.info(
      'Gratitude status: hasUnread=${status.hasUnread} '
      'lastReadAt=${status.lastReadAt?.toIso8601String() ?? 'null'} '
      'userId=${currentUserId ?? 'unknown'} homeId=$_homeId',
      tag: _gratitudeLogTag,
    );
  }

  TodayState _stateWithProfile(
    TodayState current,
    TodayUserProfile? profile,
  ) {
    if (current.isLoading) {
      return TodayState.loading(
        profile: profile,
        shareOwed: current.shareOwed,
        shareDrafts: current.shareDrafts,
        harmonyPromptTick: current.harmonyPromptTick,
        hasShownHarmonyPrompt: current.hasShownHarmonyPrompt,
        npsPromptTick: current.npsPromptTick,
        hasShownNpsPrompt: current.hasShownNpsPrompt,
        gratitudeStatus: current.gratitudeStatus,
      );
    }

    if (current.message != null || current.error != null) {
      return TodayState.failure(
        profile: profile,
        message: current.message,
        error: current.error,
        shareOwed: current.shareOwed,
        shareDrafts: current.shareDrafts,
        shareErrorMessage: current.shareErrorMessage,
        harmonyPromptTick: current.harmonyPromptTick,
        hasShownHarmonyPrompt: current.hasShownHarmonyPrompt,
        npsPromptTick: current.npsPromptTick,
        hasShownNpsPrompt: current.hasShownNpsPrompt,
        gratitudeStatus: current.gratitudeStatus,
      );
    }

    return TodayState.loaded(
      activeTasks: current.activeTasks,
      draftTasks: current.draftTasks,
      shareOwed: current.shareOwed,
      shareDrafts: current.shareDrafts,
      profile: profile,
      shareErrorMessage: current.shareErrorMessage,
      harmonyPromptTick: current.harmonyPromptTick,
      hasShownHarmonyPrompt: current.hasShownHarmonyPrompt,
      npsPromptTick: current.npsPromptTick,
      hasShownNpsPrompt: current.hasShownNpsPrompt,
      gratitudeStatus: current.gratitudeStatus,
    );
  }

  @override
  Future<void> close() {
    _profileUpdateSub.cancel();
    return super.close();
  }
}

class _ShareSnapshot {
  const _ShareSnapshot({
    required this.owed,
    required this.drafts,
    this.errorMessage,
  });

  final List<TodayShareOwed> owed;
  final List<TodayShareDraft> drafts;
  final String? errorMessage;
}
