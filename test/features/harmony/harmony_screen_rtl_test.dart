import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/core/mood/enums/mood_scale.dart';
import 'package:kinly/core/mood/models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/data/repositories/mood_repository.dart';
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
).copyWith(extensions: const <ThemeExtension<dynamic>>[_rtlSpacing]);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HarmonyScreen RTL', () {
    final repo = _FakeMoodRepository();

    Future<void> pumpRtlHarmony(WidgetTester tester) async {
      final binding = tester.binding;
      addTearDown(() => binding.setSurfaceSize(null));
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
            child: HarmonyPage(homeId: 'home'),
          ),
        ),
      );

      await tester.pumpAndSettle();
    }

    testWidgets('renders RTL with localized copy and options', (tester) async {
      await pumpRtlHarmony(tester);

      final context = tester.element(find.byType(HarmonyPage));
      final strings = S.of(context);

      expect(Directionality.of(context), TextDirection.rtl);
      expect(find.text(strings.harmonyTitle), findsOneWidget);
      expect(find.text(strings.harmonyQuestion), findsOneWidget);
      expect(find.text(strings.harmonySubtext), findsOneWidget);
      expect(find.text(strings.harmonySubmitCta), findsOneWidget);
      // Mood selector should expose all 5 moods via semantics in RTL
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

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/harmony_rtl.png'),
      );
    });
  });
}
