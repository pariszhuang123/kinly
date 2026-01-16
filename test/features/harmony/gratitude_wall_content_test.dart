import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/features/harmony/bloc/gratitude_wall_cubit.dart';
import 'package:kinly/features/harmony/ui/gratitude_wall/gratitude_wall_content.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/theme/opacity.dart';

class _MockGratitudeWallCubit extends Mock implements GratitudeWallCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testSpacing = Spacing(
    xxs: 2,
    xs: 4,
    s: 8,
    m: 12,
    l: 16,
    xl: 24,
    xxl: 32,
    xxxl: 40,
  );

  ThemeData buildTheme() => ThemeData(useMaterial3: true).copyWith(
        extensions: const <ThemeExtension<dynamic>>[
          testSpacing,
          KinlyOpacity.defaults,
        ],
      );

  final samplePost = GratitudeWallPost(
    id: 'p1',
    authorUserId: 'u1',
    authorUsername: 'HiddenUser',
    authorAvatarUrl: null,
    mood: MoodScale.sunny,
    message: 'Shared care message',
    createdAt: DateTime(2024, 1, 1),
  );

  GratitudeWallState loadedState({
    List<GratitudeWallPost> posts = const [],
    bool hasMore = false,
  }) {
    return GratitudeWallState(
      posts: posts,
      isLoading: false,
      isLoadingMore: false,
      hasMore: hasMore,
      hasLoaded: true,
      totalPosts: posts.length,
      uniqueAuthors: posts.length,
      error: null,
      cursorCreatedAt: null,
      cursorId: null,
    );
  }

  Widget wrap(GratitudeWallState state, GratitudeWallCubit cubit) {
    return MaterialApp(
      theme: buildTheme(),
      localizationsDelegates: const [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider<GratitudeWallCubit>.value(
        value: cubit,
        child: Scaffold(
          body: GratitudeWallContent(maxHeight: 600),
        ),
      ),
    );
  }

  testWidgets('house wall shows header once and cards omit per-card headers', (tester) async {
    final cubit = _MockGratitudeWallCubit();
    when(() => cubit.state).thenReturn(loadedState(posts: [samplePost]));
    when(() => cubit.stream).thenAnswer((_) => const Stream<GratitudeWallState>.empty());

    await tester.pumpWidget(wrap(cubit.state, cubit));
    await tester.pumpAndSettle();

    final strings = S.of(tester.element(find.byType(GratitudeWallContent)));
    final headerText = '${strings.gratitudeWallShareTitle} - ${strings.gratitudeWallHouseTab}';

    // Header appears once (top of wall), not on each card.
    expect(find.text(headerText), findsOneWidget);
    expect(find.text(samplePost.message!), findsOneWidget);
  });
}
