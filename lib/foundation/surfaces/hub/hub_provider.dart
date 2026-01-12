import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/contracts/preferences/ports/house_vibe_repository.dart';
import 'bloc/hub_bloc.dart';
import 'hub_surface.dart';

class HubProvider extends StatelessWidget {
  const HubProvider({
    super.key,
    required this.homeId,
    required this.homeRepository,
    required this.preferenceReportsRepository,
    required this.houseVibeRepository,
  });

  final String homeId;
  final HomeRepository homeRepository;
  final PreferenceReportsRepository preferenceReportsRepository;
  final HouseVibeRepository houseVibeRepository;

  @override
  Widget build(BuildContext context) {
    final logger =
        sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger();

    return BlocProvider(
      create:
          (_) => HubBloc(
            homeRepository: homeRepository,
            preferenceReportsRepository: preferenceReportsRepository,
            houseVibeRepository: houseVibeRepository,
            homeId: homeId,
            logger: logger,
          ),
      child: HubScreen(homeId: homeId),
    );
  }
}
