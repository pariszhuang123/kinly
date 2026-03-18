import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/chores/models.dart';
import 'package:kinly/contracts/expenses/models.dart';
import 'package:kinly/contracts/profile/models.dart';
import 'package:kinly/contracts/flow/ports/chores_repository.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import 'package:kinly/contracts/onboarding/ports/onboarding_repository.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/contracts/mood/house_pulse_models.dart';
import 'package:kinly/contracts/mood/ports/house_pulse_repository.dart';
import 'package:kinly/contracts/mood/personal_wall_models.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/notifications/profile_update_notifier.dart';
import 'package:kinly/foundation/surfaces/today/domain/house_pulse_helpers.dart';
import '../domain/models.dart'; // TodayFlowTask etc.

part 'today_event.dart';
part 'today_state.dart';
part 'today_state_mutations.dart';

class TodayBloc extends Bloc<TodayEvent, TodayState> {
  final ChoresRepository _choresRepository;
  final ProfileRepository _profileRepository;
  final ExpensesRepository _expensesRepository;
  final HomeRepository _homeRepository;
  final MoodRepository _moodRepository;
  final HousePulseRepository _housePulseRepository;
  final OnboardingRepository _onboardingRepository;
  final PreferenceReportsRepository _preferenceReportsRepository;
  final HouseNormsRepository? _houseNormsRepository;
  final HouseDirectoryRepository? _houseDirectoryRepository;
  final PersonalDirectoryRepository? _personalDirectoryRepository;
  final ProfileUpdateNotifier _profileUpdateNotifier;
  final Logger _logger;
  final String _homeId;
  String get homeId => _homeId;
  static const _gratitudeLogTag = 'TodayGratitude';
  static const _onboardingLogTag = 'TodayOnboarding';
  static const _housePulseLogTag = 'TodayHousePulse';
  late final StreamSubscription<UserProfile> _profileUpdateSub;

  TodayBloc({
    required ChoresRepository choresRepository,
    required ProfileRepository profileRepository,
    required ExpensesRepository expensesRepository,
    required HomeRepository homeRepository,
    required MoodRepository moodRepository,
    required HousePulseRepository housePulseRepository,
    required OnboardingRepository onboardingRepository,
    required PreferenceReportsRepository preferenceReportsRepository,
    HouseNormsRepository? houseNormsRepository,
    HouseDirectoryRepository? houseDirectoryRepository,
    PersonalDirectoryRepository? personalDirectoryRepository,
    required String homeId,
    required ProfileUpdateNotifier profileUpdateNotifier,
    Logger? logger,
  }) : _choresRepository = choresRepository,
      _profileRepository = profileRepository,
      _expensesRepository = expensesRepository,
      _homeRepository = homeRepository,
      _moodRepository = moodRepository,
      _housePulseRepository = housePulseRepository,
      _onboardingRepository = onboardingRepository,
      _preferenceReportsRepository = preferenceReportsRepository,
      _houseNormsRepository = houseNormsRepository,
      _houseDirectoryRepository = houseDirectoryRepository,
      _personalDirectoryRepository = personalDirectoryRepository,
      _profileUpdateNotifier = profileUpdateNotifier,
      _logger = logger ?? const DebugLogger(),
      _homeId = homeId,
      super(const TodayState.loading()) {
    on<TodayStarted>(_onStarted);
    on<TodayRefreshed>(_onRefreshed);
    on<TodayProfileUpdated>(_onProfileUpdated);
    on<TodayFlatmateInviteDismissed>(_onFlatmateInviteDismissed);
    on<TodayFlatmateInviteShareLogged>(_onFlatmateInviteShareLogged);
    on<TodayInviteShareLogged>(_onInviteShareLogged);
    on<TodayMemberCapDismissed>(_onMemberCapDismissed);
    on<TodayHousePulseViewed>(_onHousePulseViewed);
    on<TodayHousePulseShareLogged>(_onHousePulseShareLogged);
    on<TodayHouseDirectoryReminderAcknowledged>(
      _onHouseDirectoryReminderAcknowledged,
    );
    on<TodayHouseDirectoryReminderDismissed>(_onHouseDirectoryReminderDismissed);

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
    emit(_todayStateWithProfile(state, resolvedProfile));
  }

  Future<void> _loadToday(
    Emitter<TodayState> emit, {
    bool isRefresh = false,
  }) async {
    TodayUserProfile? profile = state.profile;
    HousePulsePayload? housePulse = state.housePulse;
    var houseDirectoryReminders = state.houseDirectoryReminders;
    final prevPromptTick = state.harmonyPromptTick;
    final prevHasShownHarmony = state.hasShownHarmonyPrompt;
    final prevNpsPromptTick = state.npsPromptTick;
    final prevHasShownNps = state.hasShownNpsPrompt;
    final prevGratitudeStatus = state.gratitudeStatus;
    final prevNotificationPromptTick = state.notificationPromptTick;
    final prevHasShownNotification = state.hasShownNotificationPrompt;
    var notificationPromptTick = prevNotificationPromptTick;
    var hasShownNotificationPrompt = prevHasShownNotification;
    var shouldPromptFlatmateInviteShare = state.shouldPromptFlatmateInviteShare;
    var shouldPromptInviteShare = state.shouldPromptInviteShare;
    var shouldPromptPreferences = state.shouldPromptPreferences;
    var shouldPromptHouseNorms = state.shouldPromptHouseNorms;
    var shouldPromptBankAccount = state.shouldPromptBankAccount;
    var activeChoreCount = state.activeChoreCount;
    var memberCapJoinRequests = state.memberCapJoinRequests;
    var memberCapJoinResolution = state.memberCapJoinResolution;
    try {
      _emitLoadingIfNeeded(
        emit: emit,
        isRefresh: isRefresh,
        profile: profile,
        houseDirectoryReminders: houseDirectoryReminders,
        prevPromptTick: prevPromptTick,
        prevHasShownHarmony: prevHasShownHarmony,
        prevNpsPromptTick: prevNpsPromptTick,
        prevHasShownNps: prevHasShownNps,
        prevGratitudeStatus: prevGratitudeStatus,
        prevNotificationPromptTick: prevNotificationPromptTick,
        prevHasShownNotification: prevHasShownNotification,
      );

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
      final hintsSnapshot = await _loadHintsSnapshot(
        prevNotificationPromptTick: prevNotificationPromptTick,
        prevHasShownNotification: prevHasShownNotification,
        activeChoreCount: activeChoreCount,
        shouldPromptFlatmateInviteShare: shouldPromptFlatmateInviteShare,
        shouldPromptInviteShare: shouldPromptInviteShare,
        memberCapJoinRequests: memberCapJoinRequests,
        memberCapJoinResolution: memberCapJoinResolution,
      );
      activeChoreCount = hintsSnapshot.activeChoreCount;
      hasShownNotificationPrompt = hintsSnapshot.hasShownNotificationPrompt;
      notificationPromptTick = hintsSnapshot.notificationPromptTick;
      shouldPromptFlatmateInviteShare =
          hintsSnapshot.shouldPromptFlatmateInviteShare;
      shouldPromptInviteShare = hintsSnapshot.shouldPromptInviteShare;
      memberCapJoinRequests = hintsSnapshot.memberCapJoinRequests;
      memberCapJoinResolution = hintsSnapshot.memberCapJoinResolution;

      final housePulseFuture = _housePulseRepository.getWeeklyPulse(
        homeId: _homeId,
      );
      final houseDirectoryRemindersFuture = _loadHouseDirectoryReminders();
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
      final personalStatusFuture = _loadPersonalStatusFuture();
      final hasBankAccountFuture = _loadHasBankAccount();

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
      final promptSnapshot = await _resolvePromptSnapshot(
        profile: profile,
        fallbackShouldPromptPreferences: shouldPromptPreferences,
        fallbackShouldPromptHouseNorms: shouldPromptHouseNorms,
      );
      shouldPromptPreferences = promptSnapshot.shouldPromptPreferences;
      shouldPromptHouseNorms = promptSnapshot.shouldPromptHouseNorms;
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
      final personalStatus = await _resolvePersonalStatus(
        personalStatusFuture,
        currentUserId: profile?.userId,
      );
      final hasBankAccount = await hasBankAccountFuture;
      shouldPromptBankAccount = !hasBankAccount;
      _logGratitudeStatus(wallStatus, profile?.userId);
      housePulse = await _resolveHousePulseSnapshot(
        future: housePulseFuture,
        fallback: housePulse,
      );
      houseDirectoryReminders = await houseDirectoryRemindersFuture;

      final draftTasks = drafts
          .map(_mapEntryToTodayTask)
          .toList(growable: false);
      final activeTasks = active
          .map(_mapEntryToTodayTask)
          .toList(growable: false);

      emit(
        TodayState.loaded(
          houseDirectoryReminders: houseDirectoryReminders,
          activeTasks: activeTasks,
          draftTasks: draftTasks,
          shareOwed: shareSnapshot.owed,
          sharePaidToMe: shareSnapshot.paidToMe,
          shareDrafts: shareSnapshot.drafts,
          shareErrorMessage: shareSnapshot.errorMessage,
          gratitudeStatus: wallStatus,
          personalGratitudeStatus: personalStatus,
          profile: profile,
          harmonyPromptTick: promptTick,
          hasShownHarmonyPrompt: hasShownPromptNext,
          npsPromptTick: npsPromptTick,
          hasShownNpsPrompt: hasShownNpsPromptNext,
          notificationPromptTick: notificationPromptTick,
          hasShownNotificationPrompt: hasShownNotificationPrompt,
          activeChoreCount: activeChoreCount,
          shouldPromptFlatmateInviteShare: shouldPromptFlatmateInviteShare,
          shouldPromptInviteShare: shouldPromptInviteShare,
          shouldPromptPreferences: shouldPromptPreferences,
          shouldPromptHouseNorms: shouldPromptHouseNorms,
          shouldPromptBankAccount: shouldPromptBankAccount,
          memberCapJoinRequests: memberCapJoinRequests,
          memberCapJoinResolution: memberCapJoinResolution,
          housePulse: housePulse,
          // later: you can add today's expenses, gratitude items, etc.
        ),
      );
    } catch (error) {
      // for now: basic error handling
      emit(
        TodayState.failure(
          houseDirectoryReminders: houseDirectoryReminders,
          message: "Could not load today's chores. Please try again.",
          error: error,
          profile: profile,
          shareOwed: state.shareOwed,
          sharePaidToMe: state.sharePaidToMe,
          shareDrafts: state.shareDrafts,
          shareErrorMessage: state.shareErrorMessage,
          gratitudeStatus: prevGratitudeStatus,
          personalGratitudeStatus: state.personalGratitudeStatus,
          harmonyPromptTick: prevPromptTick,
          hasShownHarmonyPrompt: prevHasShownHarmony,
          npsPromptTick: prevNpsPromptTick,
          hasShownNpsPrompt: prevHasShownNps,
          shouldPromptPreferences: state.shouldPromptPreferences,
          shouldPromptHouseNorms: state.shouldPromptHouseNorms,
          shouldPromptBankAccount: state.shouldPromptBankAccount,
          memberCapJoinRequests: memberCapJoinRequests,
          memberCapJoinResolution: memberCapJoinResolution,
          housePulse: housePulse,
        ),
      );
      // optional: log error/stackTrace via your logger/Sentry here
    }
  }

  Future<PersonalGratitudeStatus> _loadPersonalStatusFuture() {
    try {
      return _moodRepository.getPersonalStatus();
    } catch (_) {
      return Future.value(
        const PersonalGratitudeStatus(hasUnread: false, lastReadAt: null),
      );
    }
  }

  Future<List<HouseDirectoryReminder>> _loadHouseDirectoryReminders() async {
    final repository = _houseDirectoryRepository;
    if (repository == null) return const <HouseDirectoryReminder>[];
    try {
      return await repository.listDueReminders(homeId: _homeId);
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to load house directory reminders',
        error: error,
        stackTrace: stackTrace,
        tag: 'TodayHouseDirectory',
      );
      return state.houseDirectoryReminders;
    }
  }

  Future<bool> _loadHasBankAccount() async {
    final repository = _personalDirectoryRepository;
    if (repository == null) return true;
    try {
      return await repository.getOwnBankAccount() != null;
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to load personal directory bank account',
        error: error,
        stackTrace: stackTrace,
        tag: 'TodayPersonalDirectory',
      );
      return !state.shouldPromptBankAccount;
    }
  }

  Future<HousePulsePayload?> _resolveHousePulseSnapshot({
    required Future<HousePulsePayload?> future,
    required HousePulsePayload? fallback,
  }) async {
    try {
      final pulse = await future;
      _logHousePulseLoaded(pulse);
      return pulse ?? fallback;
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to load house pulse',
        tag: _housePulseLogTag,
        error: error,
        stackTrace: stackTrace,
      );
      return fallback;
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

  void _emitLoadingIfNeeded({
    required Emitter<TodayState> emit,
    required bool isRefresh,
    required TodayUserProfile? profile,
    required List<HouseDirectoryReminder> houseDirectoryReminders,
    required int prevPromptTick,
    required bool prevHasShownHarmony,
    required int prevNpsPromptTick,
    required bool prevHasShownNps,
    required GratitudeWallStatus? prevGratitudeStatus,
    required int prevNotificationPromptTick,
    required bool prevHasShownNotification,
  }) {
    if (isRefresh) return;
    emit(
      TodayState.loading(
        houseDirectoryReminders: houseDirectoryReminders,
        profile: profile,
        shareOwed: state.shareOwed,
        sharePaidToMe: state.sharePaidToMe,
        shareDrafts: state.shareDrafts,
        harmonyPromptTick: prevPromptTick,
        hasShownHarmonyPrompt: prevHasShownHarmony,
        npsPromptTick: prevNpsPromptTick,
        hasShownNpsPrompt: prevHasShownNps,
        gratitudeStatus: prevGratitudeStatus,
        personalGratitudeStatus: state.personalGratitudeStatus,
        notificationPromptTick: prevNotificationPromptTick,
        hasShownNotificationPrompt: prevHasShownNotification,
        activeChoreCount: state.activeChoreCount,
        shouldPromptFlatmateInviteShare: state.shouldPromptFlatmateInviteShare,
        shouldPromptInviteShare: state.shouldPromptInviteShare,
        shouldPromptPreferences: state.shouldPromptPreferences,
        shouldPromptHouseNorms: state.shouldPromptHouseNorms,
        shouldPromptBankAccount: state.shouldPromptBankAccount,
        memberCapJoinRequests: state.memberCapJoinRequests,
        memberCapJoinResolution: state.memberCapJoinResolution,
        housePulse: state.housePulse,
      ),
    );
  }

  Future<_PromptSnapshot> _resolvePromptSnapshot({
    required TodayUserProfile? profile,
    required bool fallbackShouldPromptPreferences,
    required bool fallbackShouldPromptHouseNorms,
  }) async {
    if (profile == null) {
      return _PromptSnapshot(
        shouldPromptPreferences: fallbackShouldPromptPreferences,
        shouldPromptHouseNorms: fallbackShouldPromptHouseNorms,
      );
    }

    try {
      final resolution = await _preferenceReportsRepository.getTemplateResolution();
      final report = await _preferenceReportsRepository.getReportForHome(
        homeId: _homeId,
        subjectUserId: profile.userId,
        locale: resolution.resolvedLocale,
      );
      return _PromptSnapshot(
        shouldPromptPreferences: report == null,
        shouldPromptHouseNorms: await _resolveHouseNormPrompt(
          profile: profile,
          locale: resolution.resolvedLocale,
          fallback: fallbackShouldPromptHouseNorms,
        ),
      );
    } catch (_) {
      // Ignore preference prompt errors; keep Today usable.
      return _PromptSnapshot(
        shouldPromptPreferences: fallbackShouldPromptPreferences,
        shouldPromptHouseNorms: fallbackShouldPromptHouseNorms,
      );
    }
  }

  Future<bool> _resolveHouseNormPrompt({
    required TodayUserProfile profile,
    required String locale,
    required bool fallback,
  }) async {
    final repository = _houseNormsRepository;
    if (repository == null) return fallback;
    try {
      final houseNorms = await repository.getForHome(
        homeId: _homeId,
        locale: locale,
      );
      if (profile.isOwner) {
        return houseNorms == null;
      }
      if (houseNorms == null) {
        return false;
      }
      return houseNorms.showMemberReviewCard;
    } catch (_) {
      // Ignore house norms prompt errors; keep Today usable.
      return fallback;
    }
  }

  TodayFlowTask _mapEntryToTodayTask(TodayFlowEntry entry) {
    final isCreatedToday = _isSameDay(
      entry.startDate.toLocal(),
      DateTime.now(),
    );
    return TodayFlowTask(
      id: entry.id,
      title: entry.name,
      state: entry.state,
      isNewToday: entry.state == ChoreState.draft && isCreatedToday,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
      final paidToMe = await _expensesRepository.listPaidToMeDebtors(
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
      final paidToMeView = paidToMe
          .map(TodaySharePaidToMe.fromModel)
          .toList(growable: false);
      return _ShareSnapshot(
        owed: owedView,
        paidToMe: paidToMeView,
        drafts: drafts,
      );
    } catch (error) {
      return _ShareSnapshot(
        owed: const <TodayShareOwed>[],
        paidToMe: const <TodaySharePaidToMe>[],
        drafts: const <TodayShareDraft>[],
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

  Future<_HintsSnapshot> _loadHintsSnapshot({
    required int prevNotificationPromptTick,
    required bool prevHasShownNotification,
    required int activeChoreCount,
    required bool shouldPromptFlatmateInviteShare,
    required bool shouldPromptInviteShare,
    required MemberCapJoinRequests? memberCapJoinRequests,
    required MemberCapJoinResolution? memberCapJoinResolution,
  }) async {
    try {
      final hints = await _onboardingRepository.getTodayHints();
      final nextHasShownNotification =
          hints.shouldPromptNotifications || prevHasShownNotification;
      final nextNotificationPromptTick =
          hints.shouldPromptNotifications && !prevHasShownNotification
              ? prevNotificationPromptTick + 1
              : prevNotificationPromptTick;
      return _HintsSnapshot(
        activeChoreCount: hints.activeChoreCount,
        hasShownNotificationPrompt: nextHasShownNotification,
        notificationPromptTick: nextNotificationPromptTick,
        shouldPromptFlatmateInviteShare: hints.shouldPromptFlatmateInviteShare,
        shouldPromptInviteShare: hints.shouldPromptInviteShare,
        memberCapJoinRequests: hints.memberCapJoinRequests,
        memberCapJoinResolution: hints.memberCapJoinResolution,
      );
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to load onboarding hints; keeping previous values',
        error: error,
        stackTrace: stackTrace,
        tag: _onboardingLogTag,
      );
      return _HintsSnapshot(
        activeChoreCount: activeChoreCount,
        hasShownNotificationPrompt: prevHasShownNotification,
        notificationPromptTick: prevNotificationPromptTick,
        shouldPromptFlatmateInviteShare: shouldPromptFlatmateInviteShare,
        shouldPromptInviteShare: shouldPromptInviteShare,
        memberCapJoinRequests: memberCapJoinRequests,
        memberCapJoinResolution: memberCapJoinResolution,
      );
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

  Future<PersonalGratitudeStatus> _resolvePersonalStatus(
    Future<PersonalGratitudeStatus> future, {
    String? currentUserId,
  }) async {
    try {
      return await future;
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to load personal gratitude status; defaulting to empty',
        tag: _gratitudeLogTag,
        error: error,
        stackTrace: stackTrace,
      );
      return const PersonalGratitudeStatus(hasUnread: false, lastReadAt: null);
    }
  }

  void _logHousePulseLoaded(HousePulsePayload? pulse) {
    if (pulse == null) {
      _logger.info(
        'House pulse payload missing; no card will render',
        tag: _housePulseLogTag,
      );
      return;
    }
    final seen = pulse.seen;
    _logger.info(
      'House pulse loaded state=${pulse.pulse.pulseState.wireValue} '
      'computedAt=${pulse.pulse.computedAt.toIso8601String()} '
      'seenAt=${seen?.seenAt.toIso8601String() ?? 'null'} '
      'hasUnseen=${hasUnseenHousePulse(pulse)} homeId=$_homeId',
      tag: _housePulseLogTag,
    );
  }

  Future<void> _onFlatmateInviteDismissed(
    TodayFlatmateInviteDismissed event,
    Emitter<TodayState> emit,
  ) async {
    try {
      await _homeRepository.logShareEvent(
        feature: 'invite_housemate',
        channel: 'onboarding_dismiss',
        homeId: _homeId,
      );
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to log flatmate invite dismissal',
        error: error,
        stackTrace: stackTrace,
        tag: _onboardingLogTag,
      );
    }
    emit(_todayStateWithoutFlatmatePrompt(state));
  }

  Future<void> _onFlatmateInviteShareLogged(
    TodayFlatmateInviteShareLogged event,
    Emitter<TodayState> emit,
  ) async {
    try {
      await _homeRepository.logShareEvent(
        feature: 'invite_housemate',
        channel: event.channel,
        homeId: _homeId,
      );
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to log flatmate invite share',
        error: error,
        stackTrace: stackTrace,
        tag: _onboardingLogTag,
      );
    }
    emit(_todayStateWithoutFlatmatePrompt(state));
  }

  Future<void> _onInviteShareLogged(
    TodayInviteShareLogged event,
    Emitter<TodayState> emit,
  ) async {
    try {
      await _homeRepository.logShareEvent(
        feature: 'invite_button',
        channel: event.channel,
        homeId: _homeId,
      );
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to log generic invite share',
        error: error,
        stackTrace: stackTrace,
        tag: _onboardingLogTag,
      );
    }
    emit(_todayStateWithoutInvitePrompt(state));
  }

  Future<void> _onMemberCapDismissed(
    TodayMemberCapDismissed event,
    Emitter<TodayState> emit,
  ) async {
    try {
      await _homeRepository.dismissMemberCapJoinRequests(homeId: _homeId);
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to dismiss member cap prompt',
        error: error,
        stackTrace: stackTrace,
        tag: _onboardingLogTag,
      );
    }
    emit(_todayStateWithoutMemberCapPrompt(state));
  }

  Future<void> _onHousePulseViewed(
    TodayHousePulseViewed event,
    Emitter<TodayState> emit,
  ) async {
    final currentPulse = state.housePulse;
    if (currentPulse == null) return;
    try {
      final seen = await _housePulseRepository.markSeen(homeId: _homeId);
      final nextPulse = currentPulse.copyWith(seen: seen ?? currentPulse.seen);
      emit(_todayStateWithHousePulse(state, nextPulse));
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to mark house pulse seen',
        tag: 'TodayHousePulse',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _onHousePulseShareLogged(
    TodayHousePulseShareLogged event,
    Emitter<TodayState> emit,
  ) async {
    try {
      await _homeRepository.logShareEvent(
        feature: 'house_pulse',
        channel: event.channel,
        homeId: _homeId,
      );
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to log house pulse share',
        tag: 'TodayHousePulse',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _onHouseDirectoryReminderAcknowledged(
    TodayHouseDirectoryReminderAcknowledged event,
    Emitter<TodayState> emit,
  ) async {
    final repository = _houseDirectoryRepository;
    if (repository == null) return;
    try {
      await repository.acknowledgeReminder(
        homeId: _homeId,
        reminderId: event.reminderId,
      );
      await _loadToday(emit, isRefresh: true);
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to acknowledge house directory reminder',
        error: error,
        stackTrace: stackTrace,
        tag: 'TodayHouseDirectory',
      );
    }
  }

  Future<void> _onHouseDirectoryReminderDismissed(
    TodayHouseDirectoryReminderDismissed event,
    Emitter<TodayState> emit,
  ) async {
    final repository = _houseDirectoryRepository;
    if (repository == null) return;
    try {
      await repository.dismissReminder(
        homeId: _homeId,
        reminderId: event.reminderId,
      );
      await _loadToday(emit, isRefresh: true);
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to dismiss house directory reminder',
        error: error,
        stackTrace: stackTrace,
        tag: 'TodayHouseDirectory',
      );
    }
  }

  @override
  Future<void> close() {
    _profileUpdateSub.cancel();
    return super.close();
  }
}

class _HintsSnapshot {
  const _HintsSnapshot({
    required this.activeChoreCount,
    required this.hasShownNotificationPrompt,
    required this.notificationPromptTick,
    required this.shouldPromptFlatmateInviteShare,
    required this.shouldPromptInviteShare,
    required this.memberCapJoinRequests,
    required this.memberCapJoinResolution,
  });

  final int activeChoreCount;
  final bool hasShownNotificationPrompt;
  final int notificationPromptTick;
  final bool shouldPromptFlatmateInviteShare;
  final bool shouldPromptInviteShare;
  final MemberCapJoinRequests? memberCapJoinRequests;
  final MemberCapJoinResolution? memberCapJoinResolution;
}

class _ShareSnapshot {
  const _ShareSnapshot({
    required this.owed,
    required this.paidToMe,
    required this.drafts,
    this.errorMessage,
  });

  final List<TodayShareOwed> owed;
  final List<TodaySharePaidToMe> paidToMe;
  final List<TodayShareDraft> drafts;
  final String? errorMessage;
}

class _PromptSnapshot {
  const _PromptSnapshot({
    required this.shouldPromptPreferences,
    required this.shouldPromptHouseNorms,
  });

  final bool shouldPromptPreferences;
  final bool shouldPromptHouseNorms;
}
