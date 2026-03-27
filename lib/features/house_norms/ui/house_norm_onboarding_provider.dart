import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/features/house_norms/bloc/house_norm_capture_bloc.dart';
import 'package:kinly/features/house_norms/domain/house_norm_scenarios.dart';
import 'house_norm_onboarding_screen.dart';

class HouseNormOnboardingProvider extends StatelessWidget {
  const HouseNormOnboardingProvider({
    super.key,
    required this.repository,
    required this.homeId,
    required this.locale,
    this.initialResponses = const <String, int>{},
  });

  final HouseNormsRepository repository;
  final String homeId;
  final String locale;
  final Map<String, int> initialResponses;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => HouseNormCaptureBloc(
            repository: repository,
            scenarios: houseNormScenarios(),
            homeId: homeId,
            locale: locale,
            initialResponses: initialResponses,
            logger: sl<Logger>(),
          ),
      child: const HouseNormOnboardingScreen(),
    );
  }
}
