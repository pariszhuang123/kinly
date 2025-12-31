import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/features/flow/flow.dart';
import '../../share/share.dart';
import '../../../../features/home/home.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../harmony/harmony.dart';
import '../../../core/onboarding/onboarding.dart';
import '../../../core/profile/profile_update_notifier.dart';
import '../bloc/today_bloc.dart';
import 'today_screen.dart';

class TodayProvider extends StatelessWidget {
  final String homeId;
  final ChoresRepository choresRepository;
  final ProfileRepository profileRepository;
  final ExpensesRepository expensesRepository;
  final HomeRepository homeRepository;
  final MoodRepository moodRepository;
  final OnboardingRepository onboardingRepository;
  final ProfileUpdateNotifier profileUpdateNotifier;

  const TodayProvider({
    super.key,
    required this.homeId,
    required this.choresRepository,
    required this.profileRepository,
    required this.expensesRepository,
    required this.homeRepository,
    required this.moodRepository,
    required this.onboardingRepository,
    required this.profileUpdateNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodayBloc>(
      create:
          (_) => TodayBloc(
            choresRepository: choresRepository,
            profileRepository: profileRepository,
            expensesRepository: expensesRepository,
            homeRepository: homeRepository,
            moodRepository: moodRepository,
            onboardingRepository: onboardingRepository,
            homeId: homeId,
            profileUpdateNotifier: profileUpdateNotifier,
          ),
      child: const TodayScreen(),
    );
  }
}
