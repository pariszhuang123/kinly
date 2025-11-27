import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/locator.dart';
import '../../../core/logging/debug_logger.dart';
import '../../../core/logging/logger.dart';
import '../../../data/repositories/home_repository.dart';
import '../bloc/hub_bloc.dart';
import 'hub_screen.dart';

class HubProvider extends StatelessWidget {
  const HubProvider({
    super.key,
    required this.homeId,
    required this.homeRepository,
  });

  final String homeId;
  final HomeRepository homeRepository;

  @override
  Widget build(BuildContext context) {
    final logger =
        sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger();

    return BlocProvider(
      create:
          (_) => HubBloc(
            homeRepository: homeRepository,
            homeId: homeId,
            logger: logger,
          ),
      child: HubScreen(homeId: homeId),
    );
  }
}
