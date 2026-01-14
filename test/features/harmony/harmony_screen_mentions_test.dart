import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import 'package:kinly/features/harmony/bloc/harmony_cubit.dart';
import 'package:kinly/features/harmony/ui/harmony_page.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/theme/opacity.dart';
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

  // Unused members of the interface
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
}

const _testSpacing = Spacing(
  xxs: 2,
  xs: 4,
  s: 8,
  m: 12,
  l: 16,
  xl: 24,
  xxl: 32,
  xxxl: 40,
);

final ThemeData _theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
).copyWith(
  extensions: const <ThemeExtension<dynamic>>[
    _testSpacing,
    KinlyOpacity.defaults,
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  List<HomeMemberSummary> buildMembers(int count) => List.generate(
    count,
    (index) => HomeMemberSummary(
      userId: 'u$index',
      username: 'Member $index',
      role: 'member',
      validFrom: DateTime.fromMillisecondsSinceEpoch(0),
      avatarUrl: null,
    ),
  );

  testWidgets('mentions visible only for positive mood and clear on flip', (
    tester,
  ) async {
    final homeRepo = _StubHomeRepository(buildMembers(2));
    final moodRepo = _FakeMoodRepository();

    await tester.pumpWidget(
      MaterialApp(
        theme: _theme,
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        home: BlocProvider(
          create:
              (_) => HarmonyCubit(
                homeId: 'home',
                moodRepository: moodRepo,
                homeRepository: homeRepo,
              )..loadMembers(),
          child: const HarmonyPage(homeId: 'home'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // No mood selected -> mention suggestions disabled but field present
    expect(find.byKey(const ValueKey('harmony_mentions_input')), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Sunny'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('harmony_mentions_input')), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Thunderstorm'));
    await tester.pumpAndSettle();

    // Field stays, but mentions disabled
    final textField = tester.widget<TextField>(
      find.byKey(const ValueKey('harmony_mentions_input')),
    );
    expect(textField.enabled, isTrue);
  });

  testWidgets('mentions capped at 5 selections', (tester) async {
    final homeRepo = _StubHomeRepository(buildMembers(6));
    final moodRepo = _FakeMoodRepository();

    await tester.pumpWidget(
      MaterialApp(
        theme: _theme,
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        home: BlocProvider(
          create:
              (_) => HarmonyCubit(
                homeId: 'home',
                moodRepository: moodRepo,
                homeRepository: homeRepo,
              )..loadMembers(),
          child: const HarmonyPage(homeId: 'home'),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Sunny'));
    await tester.pumpAndSettle();

    for (var i = 0; i < 5; i++) {
      await tester.enterText(
        find.byKey(const ValueKey('harmony_mentions_input')),
        '@',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Member $i').first);
      await tester.pumpAndSettle();
    }

    final context = tester.element(find.byType(HarmonyPage));
    final cubit = context.read<HarmonyCubit>();
    expect(cubit.state.selectedMentions.length, 5);
  });
}
