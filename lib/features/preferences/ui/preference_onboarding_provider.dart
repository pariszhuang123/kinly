import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/features/preferences/bloc/preference_capture_bloc.dart';
import 'package:kinly/features/preferences/domain/preference_scenarios.dart';
import 'preference_onboarding_screen.dart';

class PreferenceOnboardingProvider extends StatelessWidget {
  const PreferenceOnboardingProvider({
    super.key,
    required this.repository,
    required this.userId,
    this.homeId,
  });

  final PreferenceReportsRepository repository;
  final String userId;
  final String? homeId;

  @override
  Widget build(BuildContext context) {
    // Resolve preference palette to keep the provider aligned with the UI contract.
    final _ = context.preferenceSection;
    return BlocProvider(
      create:
          (_) => PreferenceCaptureBloc(
          repository: repository,
          scenarios: preferenceScenarios(),
          userId: userId,
          homeId: homeId,
          logger: sl<Logger>(),
          ),
      child: const PreferenceOnboardingScreen(),
    );
  }
}
