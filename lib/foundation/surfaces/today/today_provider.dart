import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/flow/ports/chores_repository.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import 'package:kinly/contracts/mood/ports/house_pulse_repository.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import '../../../contracts/onboarding/ports/onboarding_repository.dart';
import '../../../core/notifications/profile_update_notifier.dart';
import 'bloc/today_bloc.dart';
import 'today_surface.dart';

class TodayProvider extends StatelessWidget {
  final String homeId;
  final ChoresRepository choresRepository;
  final ProfileRepository profileRepository;
  final ExpensesRepository expensesRepository;
  final HomeRepository homeRepository;
  final MoodRepository moodRepository;
  final HousePulseRepository housePulseRepository;
  final OnboardingRepository onboardingRepository;
  final PreferenceReportsRepository preferenceReportsRepository;
  final HouseNormsRepository? houseNormsRepository;
  final HouseDirectoryRepository? houseDirectoryRepository;
  final ProfileUpdateNotifier profileUpdateNotifier;

  const TodayProvider({
    super.key,
    required this.homeId,
    required this.choresRepository,
    required this.profileRepository,
    required this.expensesRepository,
    required this.homeRepository,
    required this.moodRepository,
    required this.housePulseRepository,
    required this.onboardingRepository,
    required this.preferenceReportsRepository,
    this.houseNormsRepository,
    this.houseDirectoryRepository,
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
            housePulseRepository: housePulseRepository,
            onboardingRepository: onboardingRepository,
            preferenceReportsRepository: preferenceReportsRepository,
            houseNormsRepository: houseNormsRepository,
            houseDirectoryRepository: houseDirectoryRepository,
            homeId: homeId,
            profileUpdateNotifier: profileUpdateNotifier,
          ),
      child: const TodayScreen(),
    );
  }
}
