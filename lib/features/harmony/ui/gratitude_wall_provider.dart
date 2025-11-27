import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/mood_repository.dart';
import '../bloc/gratitude_wall_cubit.dart';
import 'gratitude_wall_screen.dart';

class GratitudeWallProvider extends StatelessWidget {
  final String homeId;
  final MoodRepository moodRepository;

  const GratitudeWallProvider({
    super.key,
    required this.homeId,
    required this.moodRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GratitudeWallCubit(
        homeId: homeId,
        moodRepository: moodRepository,
      )..loadInitial(),
      child: const GratitudeWallScreen(),
    );
  }
}
