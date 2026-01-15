import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/personal_wall_models.dart';
import 'package:kinly/features/harmony/ui/gratitude_wall/personal_gratitude_wall_content.dart';
import 'package:kinly/features/harmony/bloc/personal_gratitude_cubit.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/theme/opacity.dart';

class _MockPersonalGratitudeCubit extends Mock implements PersonalGratitudeCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  ThemeData _theme() => ThemeData(useMaterial3: true).copyWith(
        extensions: const <ThemeExtension<dynamic>>[
          _testSpacing,
          KinlyOpacity.defaults,
        ],
      );

  final sampleItem = PersonalGratitudeItem(
    id: 'i1',
    createdAt: DateTime(2024, 2, 1),
    homeId: 'h1',
    mood: MoodScale.sunny,
    message: 'Thanks for the help!',
    sourceKind: 'home_post',
    sourcePostId: 'p1',
    sourceEntryId: 'e1',
    authorUserId: 'u1',
    authorUsername: 'Alice',
    authorAvatarPath: null,
  );

  PersonalGratitudeState loadedState({
    List<PersonalGratitudeItem> items = const [],
    PersonalGratitudeStats? stats,
    bool hasMore = false,
    bool isLoadingMore = false,
  }) =>
      PersonalGratitudeState(
        isLoading: false,
        isLoadingMore: isLoadingMore,
        hasMore: hasMore,
        hasLoaded: true,
        items: items,
        cursorAt: null,
        cursorId: null,
        status: const PersonalGratitudeStatus(hasUnread: false, lastReadAt: null),
        stats: stats,
        error: null,
      );

  Widget _wrap(PersonalGratitudeState state, PersonalGratitudeCubit cubit) {
    return MaterialApp(
      theme: _theme(),
      localizationsDelegates: const [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider<PersonalGratitudeCubit>.value(
        value: cubit,
        child: Scaffold(
          body: PersonalGratitudeWallContent(maxHeight: 600),
        ),
      ),
    );
  }

  testWidgets('renders personal wall header, summary, stats, and cards', (tester) async {
    final cubit = _MockPersonalGratitudeCubit();
    final stats = PersonalGratitudeStats(
      totalReceived: 3,
      uniqueIndividuals: 2,
      uniqueHomes: 1,
    );
    when(() => cubit.state).thenReturn(
      loadedState(items: [sampleItem], stats: stats),
    );
    when(() => cubit.stream).thenAnswer(
      (_) => const Stream<PersonalGratitudeState>.empty(),
    );

    await tester.pumpWidget(_wrap(cubit.state, cubit));
    await tester.pumpAndSettle();

    final strings = S.of(tester.element(find.byType(PersonalGratitudeWallContent)));

    expect(find.text(strings.gratitudeWallPersonalTitle), findsOneWidget);
    expect(find.text(strings.gratitudeWallPersonalSummary), findsOneWidget);
    expect(find.textContaining('3'), findsWidgets);
    expect(find.textContaining('2'), findsWidgets);
    expect(find.textContaining('1'), findsWidgets);
    expect(find.text(sampleItem.authorUsername), findsOneWidget);
    expect(find.text(sampleItem.message!), findsOneWidget);
  });

  testWidgets('shows empty state when no items', (tester) async {
    final cubit = _MockPersonalGratitudeCubit();
    when(() => cubit.state).thenReturn(loadedState(items: []));
    when(() => cubit.stream).thenAnswer(
      (_) => const Stream<PersonalGratitudeState>.empty(),
    );

    await tester.pumpWidget(_wrap(cubit.state, cubit));
    await tester.pumpAndSettle();

    final strings = S.of(tester.element(find.byType(PersonalGratitudeWallContent)));
    expect(find.text(strings.gratitudeWallEmptyTitle), findsOneWidget);
  });

  testWidgets('shows error message when error and empty', (tester) async {
    final cubit = _MockPersonalGratitudeCubit();
    when(() => cubit.state).thenReturn(
      const PersonalGratitudeState(
        isLoading: false,
        isLoadingMore: false,
        hasMore: false,
        hasLoaded: true,
        items: [],
        cursorAt: null,
        cursorId: null,
        status: null,
        stats: null,
        error: 'boom',
      ),
    );
    when(() => cubit.stream).thenAnswer(
      (_) => const Stream<PersonalGratitudeState>.empty(),
    );

    await tester.pumpWidget(_wrap(cubit.state, cubit));
    await tester.pumpAndSettle();

    final strings = S.of(tester.element(find.byType(PersonalGratitudeWallContent)));
    expect(find.text(strings.gratitudeWallErrorGeneric), findsOneWidget);
  });

  testWidgets('triggers loadMore when scrolled near end and hasMore', (tester) async {
    final cubit = _MockPersonalGratitudeCubit();
    when(() => cubit.state).thenReturn(
      loadedState(
        items: List.generate(5, (i) => sampleItem),
        hasMore: true,
        isLoadingMore: false,
      ),
    );
    when(() => cubit.stream).thenAnswer(
      (_) => Stream<PersonalGratitudeState>.fromIterable([
        cubit.state,
        cubit.state.copyWith(isLoadingMore: true),
      ]),
    );
    when(() => cubit.loadMore()).thenAnswer((_) async {});

    await tester.pumpWidget(
      SizedBox(
        height: 400,
        child: _wrap(cubit.state, cubit),
      ),
    );
    await tester.pump();

    await tester.drag(find.byType(PersonalGratitudeWallContent), const Offset(0, -500));
    await tester.pump();
  });
}
