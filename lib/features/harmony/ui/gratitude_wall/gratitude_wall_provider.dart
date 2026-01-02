import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import '../../bloc/gratitude_wall_cubit.dart';
import 'gratitude_wall_screen.dart';

class GratitudeWallProvider extends StatelessWidget {
  final String homeId;
  final MoodRepository moodRepository;
  final HomeRepository homeRepository;

  const GratitudeWallProvider({
    super.key,
    required this.homeId,
    required this.moodRepository,
    required this.homeRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => GratitudeWallCubit(
            homeId: homeId,
            moodRepository: moodRepository,
            homeRepository: homeRepository,
          )..loadInitial(),
      child: const GratitudeWallScreen(),
    );
  }
}
