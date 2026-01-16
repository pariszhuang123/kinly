import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import '../../../../core/ui/kinly_app_bar.dart';
import '../../../../core/ui/kinly_scaffold.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/personal_gratitude_cubit.dart';
import 'personal_gratitude_wall_content.dart';

class PersonalMentionsProvider extends StatelessWidget {
  const PersonalMentionsProvider({
    super.key,
    required this.moodRepository,
    required this.homeRepository,
    this.homeId,
    this.entrySource,
  });

  final MoodRepository moodRepository;
  final HomeRepository homeRepository;
  final String? homeId;
  final String? entrySource;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => PersonalGratitudeCubit(
            moodRepository: moodRepository,
            homeRepository: homeRepository,
            homeId: homeId,
          )..loadInitial(),
      child: PersonalMentionsScreen(entrySource: entrySource),
    );
  }
}

class PersonalMentionsScreen extends StatelessWidget {
  const PersonalMentionsScreen({super.key, this.entrySource});

  final String? entrySource;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return KinlyScaffold(
      key:
          entrySource == null
              ? null
              : ValueKey('personal_mentions_$entrySource'),
      appBar: KinlyAppBar(
        title: Text(s.personalMentionsTitle),
      ),
      body: const SafeArea(
        child: PersonalGratitudeWallContent(),
      ),
    );
  }
}
