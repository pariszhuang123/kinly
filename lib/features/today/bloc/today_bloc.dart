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
import '../domain/models.dart'; // TodayFlowTask etc.

part 'today_event.dart';
part 'today_state.dart';

class TodayBloc extends Bloc<TodayEvent, TodayState> {
  final ChoresRepository _choresRepository;
  final ProfileRepository _profileRepository;
  final ExpensesRepository _expensesRepository;
  final HomeRepository _homeRepository;
  final MoodRepository _moodRepository;
  final String _homeId;

  TodayBloc({
    required ChoresRepository choresRepository,
    required ProfileRepository profileRepository,
    required ExpensesRepository expensesRepository,
    required HomeRepository homeRepository,
    required MoodRepository moodRepository,
    required String homeId,
  }) : _choresRepository = choresRepository,
       _profileRepository = profileRepository,
       _expensesRepository = expensesRepository,
       _homeRepository = homeRepository,
       _moodRepository = moodRepository,
       _homeId = homeId,
       super(const TodayState.loading()) {
    on<TodayStarted>(_onStarted);
    on<TodayRefreshed>(_onRefreshed);

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

  Future<void> _loadToday(
    Emitter<TodayState> emit, {
    bool isRefresh = false,
  }) async {
    TodayUserProfile? profile = state.profile;
    final prevPromptTick = state.harmonyPromptTick;
    final prevHasShownHarmony = state.hasShownHarmonyPrompt;
    final prevNpsPromptTick = state.npsPromptTick;
    final prevHasShownNps = state.hasShownNpsPrompt;
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
