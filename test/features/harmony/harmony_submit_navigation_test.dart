import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/harmony/bloc/harmony_cubit.dart';
import 'package:kinly/features/harmony/ui/harmony_page.dart';
import 'package:kinly/generated/l10n.dart';

class _FakeMoodRepository extends Fake implements MoodRepository {
  @override
  Future<bool> isSubmittedThisWeek(String homeId) async => false;

  @override
  Future<MoodSubmitResult> submit({
    required String homeId,
    required MoodScale mood,
    String? comment,
    bool addToWall = false,
    List<String> mentions = const [],
  }) async => const MoodSubmitResult(entryId: 'fake', mentionCount: 0);

  @override
  Future<GratitudeWallPage> listWall({
    required String homeId,
    int limit = 20,
    DateTime? cursorCreatedAt,
    String? cursorId,
  }) async =>
      const GratitudeWallPage(posts: [], cursorCreatedAt: null, cursorId: null);

  @override
  Future<GratitudeWallStats> getWallStats(String homeId) async =>
      const GratitudeWallStats(totalPosts: 0, unreadCount: 0, lastReadAt: null);

  @override
  Future<void> markWallRead(String homeId) async {}

  @override
  Future<GratitudeWallStatus> getWallStatus(String homeId) async =>
      const GratitudeWallStatus(hasUnread: false, lastReadAt: null);

  @override
  Future<bool> isNpsRequired(String homeId) async => false;

  @override
  Future<void> submitNps({required String homeId, required int score}) async {}
}

class _StubHomeRepository extends Fake implements HomeRepository {
  _StubHomeRepository(this.members);

  final List<HomeMemberSummary> members;

  @override
  Future<List<HomeMemberSummary>> listActiveMembers(
    String homeId, {
    bool excludeSelf = false,
  }) async => members;

  @override
  Future<HomeCreationResult> create({String? name}) {
    throw UnimplementedError();
  }

  @override
  Future<HomeInvite> getOrCreateInvite({required String homeId}) {
    throw UnimplementedError();
  }

  @override
  Future<HomeInvite> revokeInvite({required String homeId}) {
    throw UnimplementedError();
  }

  @override
  Future<HomeInvite> getActiveInvite(String homeId) {
    throw UnimplementedError();
  }

  @override
  Future<HomeJoinResult> join(String code) {
    throw UnimplementedError();
  }

  @override
  Future<HomeJoinResult> joinHome(String code) {
    throw UnimplementedError();
  }

  @override
  Future<void> transferOwner({
    required String homeId,
    required String newOwnerId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> kickMember({required String homeId, required String userId}) {
    throw UnimplementedError();
  }

  @override
  Future<LeaveResult> leave({required String homeId}) {
    throw UnimplementedError();
  }

  @override
  Future<CurrentMembership?> getCurrentMembership({bool excludeSelf = false}) {
    throw UnimplementedError();
  }

  @override
  Future<HomeInvite> rotateInvite(String homeId) {
    throw UnimplementedError();
  }

  @override
  Future<void> logShareEvent({
    required String homeId,
    required String feature,
    required String channel,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> dismissMemberCapJoinRequests({required String homeId}) {
    throw UnimplementedError();
  }

  @override
  Future<PlanStatus> getPlanStatus() async => PlanStatus.free;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('successful submit navigates to Today', (tester) async {
    final moodRepo = _FakeMoodRepository();
    final homeRepo = _StubHomeRepository(const <HomeMemberSummary>[]);
    final router = GoRouter(
      initialLocation: AppRoutePaths.harmony,
      routes: [
        GoRoute(
          path: AppRoutePaths.harmony,
          name: AppRouteNames.harmony,
          builder: (_, __) {
            return BlocProvider(
              create:
                  (_) => HarmonyCubit(
                    homeId: 'home',
                    moodRepository: moodRepo,
                    homeRepository: homeRepo,
                  )..loadMembers(),
              child: const HarmonyPage(homeId: 'home'),
            );
          },
        ),
        GoRoute(
          path: AppRoutePaths.today,
          name: AppRouteNames.today,
          builder: (_, __) => const Scaffold(body: Text('today-screen')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        theme: buildKinlyTheme(Brightness.light),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(HarmonyPage));
    final strings = S.of(context);

    await tester.tap(find.bySemanticsLabel(strings.harmonyMoodSunny));
    await tester.pumpAndSettle();

    await tester.tap(find.text(strings.harmonySubmitCta));
    await tester.pumpAndSettle();

    expect(find.text('today-screen'), findsOneWidget);
  });
}
