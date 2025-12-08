import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/chores_repository.dart';
import '../../../data/repositories/home_repository.dart';
import '../bloc/flow_chore_bloc.dart';
import 'flow_chore_screen.dart';

class FlowChoreProvider extends StatelessWidget {
  final String homeId;
  final ChoresRepository choresRepository;
  final HomeRepository homeRepository;
  final String? choreId;

  const FlowChoreProvider({
    super.key,
    required this.homeId,
    required this.choresRepository,
    required this.homeRepository,
    this.choreId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => FlowChoreBloc(
            homeId: homeId,
            choreId: choreId,
            choresRepository: choresRepository,
            homeRepository: homeRepository,
          )..add(const FlowChoreStarted()),
      child: FlowChoreScreen(homeId: homeId),
    );
  }
}
