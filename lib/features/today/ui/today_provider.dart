import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/chores_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../bloc/today_bloc.dart';
import 'today_screen.dart';

class TodayProvider extends StatelessWidget {
  final String homeId;
  final ChoresRepository choresRepository;
  final ProfileRepository profileRepository;

  const TodayProvider({
    super.key,
    required this.homeId,
    required this.choresRepository,
    required this.profileRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodayBloc>(
      create: (_) => TodayBloc(
        choresRepository: choresRepository,
        profileRepository: profileRepository,
        homeId: homeId,
      ),
      child: const TodayScreen(),
    );
  }
}
