import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/chores_repository.dart';
import '../bloc/flow_chore_bloc.dart';
import 'flow_chore_screen.dart';

class FlowChoreProvider extends StatelessWidget {
  final String homeId;
  final ChoresRepository choresRepository;
  final String? choreId;

  const FlowChoreProvider({
    super.key,
    required this.homeId,
    required this.choresRepository,
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
          )..add(const FlowChoreStarted()),
      child: const FlowChoreScreen(),
    );
  }
}
