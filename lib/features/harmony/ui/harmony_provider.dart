import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/mood_repository.dart';
import '../../harmony/bloc/harmony_cubit.dart';
import 'harmony_screen.dart';

class HarmonyProvider extends StatelessWidget {
  final String homeId;
  final MoodRepository moodRepository;

  const HarmonyProvider({
    super.key,
    required this.homeId,
    required this.moodRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HarmonyCubit(
        homeId: homeId,
        moodRepository: moodRepository,
      ),
      child: HarmonyScreen(homeId: homeId),
    );
  }
}
