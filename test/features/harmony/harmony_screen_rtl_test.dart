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

class _FakeMoodRepository extends Fake implements MoodRepository {
  @override
  Future<bool> isSubmittedThisWeek(String homeId) async => false;

  @override
  Future<MoodSubmitResult> submit({
    required String homeId,
    required MoodScale mood,
    String? comment,
    bool addToWall = false,
  }) async {
    return const MoodSubmitResult(entryId: 'fake');
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
            create: (_) => HarmonyCubit(homeId: 'home', moodRepository: repo),
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
