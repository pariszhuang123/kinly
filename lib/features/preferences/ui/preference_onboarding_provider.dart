import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/features/preferences/bloc/preference_capture_bloc.dart';
import 'package:kinly/features/preferences/domain/preference_scenarios.dart';
import 'preference_onboarding_screen.dart';

class PreferenceOnboardingProvider extends StatelessWidget {
  const PreferenceOnboardingProvider({
    super.key,
    required this.repository,
  });

  final PreferenceReportsRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => PreferenceCaptureBloc(
            repository: repository,
            scenarios: preferenceScenarios(),
          ),
      child: const PreferenceOnboardingScreen(),
    );
  }
}
