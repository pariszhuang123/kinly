import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/theme/opacity.dart';
import 'package:kinly/features/harmony/harmony.dart';
import 'package:kinly/features/harmony/bloc/harmony_cubit.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/homes/models.dart';

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
  }) async {
    return const MoodSubmitResult(entryId: 'fake', mentionCount: 0);
  }

  @override
  Future<GratitudeWallPage> listWall({
    required String homeId,
    int limit = 20,
    DateTime? cursorCreatedAt,
    String? cursorId,
  }) async {
    return const GratitudeWallPage(
      posts: [],
      cursorCreatedAt: null,
      cursorId: null,
    );
  }

  @override
  Future<GratitudeWallStats> getWallStats(String homeId) async {
    return const GratitudeWallStats(
      totalPosts: 0,
      unreadCount: 0,
      lastReadAt: null,
    );
  }

  @override
  Future<void> markWallRead(String homeId) async {}

  @override
  Future<GratitudeWallStatus> getWallStatus(String homeId) async {
    return const GratitudeWallStatus(hasUnread: false, lastReadAt: null);
  }

  @override
  Future<bool> isNpsRequired(String homeId) async => false;

  @override
  Future<void> submitNps({required String homeId, required int score}) async {}
}

class _FakeHomeRepository extends Fake implements HomeRepository {
  @override
  Future<List<HomeMemberSummary>> listActiveMembers(
    String homeId, {
    bool excludeSelf = false,
  }) async {
    return [];
  }

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
  Future<void> transferOwner({required String homeId, required String newOwnerId}) {
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

const _rtlSpacing = Spacing(
  xxs: 2,
  xs: 4,
  s: 8,
  m: 12,
  l: 16,
  xl: 24,
  xxl: 32,
  xxxl: 40,
);

final ThemeData _rtlTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
).copyWith(
  extensions: const <ThemeExtension<dynamic>>[
    _rtlSpacing,
    KinlyOpacity.defaults,
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HarmonyScreen RTL', () {
    final repo = _FakeMoodRepository();
    final homeRepo = _FakeHomeRepository();

    Future<void> pumpRtlHarmony(WidgetTester tester) async {
      final binding = tester.binding;
      final dispatcher = binding.platformDispatcher;

      // Pin common drift sources (helps consistency even without goldens)
      tester.view.devicePixelRatio = 3.0;
      dispatcher.textScaleFactorTestValue = 1.0;

      addTearDown(() {
        tester.view.resetDevicePixelRatio();
        dispatcher.clearAllTestValues();
        binding.setSurfaceSize(null);
      });

      await binding.setSurfaceSize(const Size(393, 852)); // iPhone 14-ish

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: _rtlTheme,
          home: BlocProvider(
            create: (_) => HarmonyCubit(
              homeId: 'home',
              moodRepository: repo,
              homeRepository: homeRepo,
            ),
            child: const Directionality(
              // belt-and-suspenders: keep RTL even if locale plumbing changes
              textDirection: TextDirection.rtl,
              child: HarmonyPage(homeId: 'home'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
    }

    testWidgets('renders RTL with localized copy and options', (tester) async {
      await pumpRtlHarmony(tester);

      final context = tester.element(find.byType(HarmonyPage));
      final strings = S.of(context);

      // RTL
      expect(Directionality.of(context), TextDirection.rtl);

      // Localized copy exists
      expect(find.text(strings.harmonyQuestion), findsOneWidget);
      expect(find.text(strings.harmonySubmitCta), findsOneWidget);

      // Mood options are exposed via semantics (stable + meaningful)
      expect(find.bySemanticsLabel(strings.harmonyMoodSunny), findsOneWidget);
      expect(
        find.bySemanticsLabel(strings.harmonyMoodPartiallySunny),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel(strings.harmonyMoodCloudy), findsOneWidget);
      expect(find.bySemanticsLabel(strings.harmonyMoodRainy), findsOneWidget);
      expect(
        find.bySemanticsLabel(strings.harmonyMoodThunderstorm),
        findsOneWidget,
      );

      // Optional: sanity check key UI exists (non-pixel)
      expect(find.byType(HarmonyPage), findsOneWidget);
    });
  });
}
